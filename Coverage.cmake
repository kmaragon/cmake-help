
function(add_coverage_run _target_name _for_target)
    set(options "")
    set(oneValueArgs "FORMAT")
    set(multiValueArgs "ARGS")
    cmake_parse_arguments(COVERAGE "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})

    find_program(LCOV_EXE lcov)
    find_program(GENHTML_EXE genhtml)
    find_program(XDG_OPEN_EXE xdg-open)

    if (NOT LCOV_EXE)
        message(ERROR "lcov is required for code coverage")
    endif()

    if (NOT GENHTML_EXE)
        message(ERROR "genhtml is required for code coverage")
    endif()

    if (NOT XDG_OPEN_EXE)
        message(ERROR "xdg-open is required for code coverage")
    endif()

    get_target_property(TARGET_OUTPUT_DIR "${_for_target}" RUNTIME_OUTPUT_DIRECTORY_${CMAKE_BUILD_TYPE})
    if (NOT TARGET_OUTPUT_DIR)
        get_target_property(TARGET_OUTPUT_DIR "${_for_target}" RUNTIME_OUTPUT_DIRECTORY)
    endif()
    get_target_property(TARGET_SUFFIX "${_for_target}" SUFFIX)

    # just get all the project sources for the extract
    file(GLOB_RECURSE _all_sources "${CMAKE_SOURCE_DIR}/*")
    add_custom_target("${_target_name}"
            COMMAND ${LCOV_EXE} --zerocounters --directory "${CMAKE_BINARY_DIR}"
            COMMAND ${LCOV_EXE} --capture --initial --directory "${CMAKE_BINARY_DIR}" --output-file "${_target_name}_coverage.run.info.all"
            COMMAND "${TARGET_OUTPUT_DIR}/${_for_target}${SUFFIX}" ${COVERAGE_ARGS}
            COMMAND ${LCOV_EXE} --capture --directory "${CMAKE_BINARY_DIR}" --output-file "${_target_name}_coverage.run.info.all"
            COMMAND ${LCOV_EXE} --directory "${CMAKE_BINARY_DIR}" --output-file "${_target_name}_coverage.run.info" --extract "${_target_name}_coverage.run.info.all" ${_all_sources}
            COMMAND ${GENHTML_EXE} -o "${CMAKE_CURRENT_BINARY_DIR}/${_target_name}" "${_target_name}_coverage.run.info"
            COMMAND ${CMAKE_COMMAND} -E remove "${_target_name}_coverage.run.info"
            COMMAND ${XDG_OPEN_EXE} "${CMAKE_CURRENT_BINARY_DIR}/${_target_name}/index.html"
            WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
            DEPENDS "${_for_target}"
            COMMENT "Running and processing code coverage"
            )
endfunction()