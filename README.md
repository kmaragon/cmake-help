CMake Helpers
======================

### Conan.cmake
An automatic install / include for conan

#### Usage:
```cmake
conan_include_conanfile("${CMAKE_CURRENT_SOURCE_DIR}/conanfile.txt")
target_link_libraries(myprogram CONAN_PKG::zlib)
```
