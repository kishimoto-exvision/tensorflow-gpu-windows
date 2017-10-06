call "C:\Program Files (x86)\Microsoft Visual Studio 14.0\VC\vcvarsall.bat" amd64

REM https://www.tensorflow.org/install/install_windows
REM https://github.com/tensorflow/tensorflow/blob/master/tensorflow/contrib/cmake/README.md
REM http://twonightmare.blogspot.jp/2017/08/tensorflow-gpu-build-for-windows-for.html
REM Download the prebuilt swig.exe from http://prdownloads.sourceforge.net/swig/swigwin-3.0.12.zip and add the PATH to swig.exe, and FindSWIG.cmake will find the path of swig.exe.

cd /d %~dp0
copy /Y ".\tensorflow\contrib\cmake\CMakeLists.txt" "..\tensorflow\tensorflow\contrib\cmake\CMakeLists.txt"
cd "..\tensorflow\tensorflow\contrib\cmake"

REM rmdir /S /Q build
mkdir build
cd build

cmake .. -G "Visual Studio 14 2015 Win64" ^
-Dtensorflow_ENABLE_GPU:BOOL=TRUE ^
-DCUDNN_HOME:PATH="C:/Program Files/NVIDIA GPU Computing Toolkit/CUDA/v8.0" ^
-Dtensorflow_BUILD_PYTHON_TESTS:BOOL=TRUE ^
-DCMAKE_CONFIGURATION_TYPES:STRING="Release"

REM -DSWIG_EXECUTABLE="C:/SDKs/swigwin-3.0.12/swig.exe" ^
REM -Dtensorflow_WIN_CPU_SIMD_OPTIONS is unavailable now.



msbuild /p:Configuration=Release /p:Platform=x64 /m:8 tensorflow.sln /p:PreferredToolArchitecture=x64
ctest -C Release
