# This file is part of MUST (Marmot Umpire Scalable Tool)
#
# Copyright (C)
#   2011-2014 ZIH, Technische Universitaet Dresden, Federal Republic of Germany
#   2011-2014 Lawrence Livermore National Laboratories, United States of America
#   2013-2014 RWTH Aachen University, Federal Republic of Germany
#
# See the file LICENSE.txt in the package base directory for details


#
# include other CMake files
#
include(CheckTypeSize)


## \brief Sets \p VARIABLE to a valid basic C type derived from \p BTYPE
#   dependent of the size of \p TYPE.
#
# \details Calls check_type_size for \p type and sets \p variable to a basic C
#   type derived from \p BTYPE.
#
#   The following variables may be set before calling this macro to modify the
#   way the check is run:
#
#   CMAKE_REQUIRED_FLAGS = string of compile command line flags
#   CMAKE_REQUIRED_DEFINITIONS = list of macros to define (-DFOO=bar)
#   CMAKE_REQUIRED_INCLUDES = list of include directories
#   CMAKE_REQUIRED_LIBRARIES = list of libraries to link
#   CMAKE_EXTRA_INCLUDE_FILES = list of extra headers to include
#
#
# \param TYPE T
# \param BTYPE Basic C type. May be {int, uint}
# \param VARIABLE Variable to be set to the basic C type
#
# \return If \p TYPE does not exist, \p BTYPE is unknown or \p TYPE has an
#   unknown size, \p VARIABLE is set to "unknown_t". In any other case,
#   \p VARIABLE will be set to a valid basic C type.
#
function (CHECK_TYPE_BASIC_TYPE TYPE BTYPE VARIABLE)
	# get size of TYPE
	check_type_size(${TYPE} "${TYPE}_SIZE")

	# return function, if TYPE does not exist
	if (${${TYPE}_SIZE} GREATER 0)
		# lookup an suitable basic type
		if ((${BTYPE} STREQUAL "uint") OR (${BTYPE} STREQUAL "int"))
			math(EXPR x "${${TYPE}_SIZE} * 8")
			set(USE_TYPE "${BTYPE}${x}_t")
		endif ()


		# save current environment
		set(CMAKE_EXTRA_INCLUDE_FILES_TMP ${CMAKE_EXTRA_INCLUDE_FILES})
		set(CMAKE_EXTRA_INCLUDE_FILES)

		# does selected type exist?
		check_type_size(${USE_TYPE} "${TYPE}_SIZE_N")
		if (${${TYPE}_SIZE_N} GREATER 0)
			# does length of selected type match the original size?
			if (${${TYPE}_SIZE_N} EQUAL ${${TYPE}_SIZE})
				set(${VARIABLE} ${USE_TYPE})
			endif ()
		endif ()

		# restore environment
		set(CMAKE_EXTRA_INCLUDE_FILES ${CMAKE_EXTRA_INCLUDE_FILES_TMP})
		set(CMAKE_EXTRA_INCLUDE_FILES_TMP)
	endif ()

	# set VARIABLE as empty, if not already done
	if (NOT ${VARIABLE})
		set(${VARIABLE})
	endif ()
endfunction ()
