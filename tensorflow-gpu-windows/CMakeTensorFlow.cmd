call "C:\Program Files (x86)\Microsoft Visual Studio 14.0\VC\vcvarsall.bat" amd64

REM https://www.tensorflow.org/install/install_windows
REM https://github.com/tensorflow/tensorflow/blob/master/tensorflow/contrib/cmake/README.md
REM http://twonightmare.blogspot.jp/2017/08/tensorflow-gpu-build-for-windows-for.html
REM Download the prebuilt swig.exe from http://prdownloads.sourceforge.net/swig/swigwin-3.0.12.zip and add the PATH to swig.exe, and FindSWIG.cmake will find the path of swig.exe.

cd /d %~dp0

if not exist tensorflow (
  git clone --recursive git://github.com/tensorflow/tensorflow "..\tensorflow"
  git checkout 2c3bf9eff79156e32512e8d6da2179cd044167b8
  copy /Y ".\tensorflow\contrib\cmake\CMakeLists.txt" "..\tensorflow\tensorflow\contrib\cmake\CMakeLists.txt"
)

cd "..\tensorflow\tensorflow\contrib\cmake"

REM rmdir /S /Q build
mkdir build
cd build

cmake .. -G "Visual Studio 14 2015 Win64" ^
-Dtensorflow_ENABLE_GPU:BOOL=TRUE ^
-DCMAKE_INSTALL_PREFIX:PATH="C:/SDKs/tensorflow-gpu-1.3"
-DCUDNN_HOME:PATH="C:/Program Files/NVIDIA GPU Computing Toolkit/CUDA/v8.0" ^
-Dtensorflow_BUILD_CC_EXAMPLE:BOOL=TRUE ^
-Dtensorflow_BUILD_CC_TESTS:BOOL=TRUE ^
-Dtensorflow_BUILD_PYTHON_BINDINGS:BOOL=TRUE ^
-Dtensorflow_BUILD_PYTHON_TESTS:BOOL=TRUE ^
-Dtensorflow_BUILD_SHARED_LIB:BOOL=FALSE ^
-Dtensorflow_OPTIMIZE_FOR_NATIVE_ARCH:BOOL=TRUE ^
-DCMAKE_CONFIGURATION_TYPES:STRING="Release"

REM -DSWIG_EXECUTABLE="C:/SDKs/swigwin-3.0.12/swig.exe" ^
REM -Dtensorflow_WIN_CPU_SIMD_OPTIONS is unavailable now.

REM Fails
msbuild /p:Configuration=Release /p:Platform=x64 /m:1 tensorflow.sln /p:PreferredToolArchitecture=x64 > "%~dp0\msbuild_1st_log.txt" 2>&1

cd /d %~dp0
xcopy /E /I /Q /Y "tensorflow" "..\tensorflow\tensorflow"
cd "..\tensorflow\tensorflow\contrib\cmake\build"
msbuild /p:Configuration=Release /p:Platform=x64 /m:1 tensorflow.sln /p:PreferredToolArchitecture=x64 > "%~dp0\msbuild_2nd_log.txt" 2>&1

ctest -C Release > "%~dp0\ctest_log.txt" 2>&1

cmake --build "." --target "ALL_BUILD" --config "Release" > "%~dp0\cmake_allbuild_log.txt" 2>&1
cmake --build "." --target "INSTALL" --config "Release" > "%~dp0\cmake_install_log.txt" 2>&1
