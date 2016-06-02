# cm8kr
CMake Tools for cr8tr c++ projects

Cm8kr is a set of Convenience tools for cmake.
It is licensed under simplified BSD license.

In a CMakeLists.txt file of a repository, the cm8kr environment is initialized with

include(../cm8kr/base.cmake)

It holds several preassumption for a source repository:
* A source repository can only have one deployable app, the main app.
  * For this app, dmg files (on MacOSX) or debian package are created automatically
* The source of the main app is in src/app by default, can be changed with variable
  CM8KR_MAINAPP_SOURCE_PATH
* Deployment data files (like icons etc) are located in ${CM8KR_MAINAPP_SOURCE_PATH}/data
  by default.
* The main app can have plugins, which are located in src/plugins
  * There is a plugin system, which automatically makes shared objects for plugins
* A source repository can have multiple libraries, which are located in
  in src/lib by default, can be changed with variable CM8KR_LIBRARY_SOURCE_PATH

