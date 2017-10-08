# tensorflow-gpu-windows

## References

 * <https://www.tensorflow.org/install/install_windows>
 * <https://github.com/tensorflow/tensorflow/blob/master/tensorflow/contrib/cmake/README.md>
 * <http://twonightmare.blogspot.jp/2017/08/tensorflow-gpu-build-for-windows-for.html>

## How to build

 * Download the prebuilt swig.exe from <http://prdownloads.sourceforge.net/swig/swigwin-3.0.12.zip> and so on.
 * Add the PATH to swig.exe, and FindSWIG.cmake will find the path of swig.exe.
 * Call the following commands.
 
```
cd .\tensorflow-gpu-windows
.\CMakeTensorFlow.cmd
```
