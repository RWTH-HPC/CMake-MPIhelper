# This file is part of MUST (Marmot Umpire Scalable Tool)
#
# Copyright (C)
#   2011-2015 ZIH, Technische Universitaet Dresden, Federal Republic of Germany
#   2011-2015 Lawrence Livermore National Laboratories, United States of America
#   2013-2015 RWTH Aachen University, Federal Republic of Germany
#
# See the file LICENSE.txt in the package base directory for details


include(CheckFortranSourceCompiles)


## \brief Wrapper for check_fortran_source_compiles to test if \p symbol exists
#   in fortran MPI environment.
#
# \details Sets MPI environment, generates a new source file for \p symbol and
#   calls check_fortran_source_compiles.
#
#
# \param symbol Symbol to test.
# \param variable Variable to be set, if symbol exists.
#
# \return If \p symbol was found, \p variable will be set true. In any other
#   case \p variable will become false.
#
function(CHECK_FORTRAN_MPI_SYMBOL_EXISTS symbol variable)
	# Note: a check against CMake cache is not needed in this function, thus all
	# called functions implement such a check.

	# search for MPI environment
	find_package(MPI)

	if (MPI_Fortran_FOUND)
		# set environment
		set(CMAKE_REQUIRED_FLAGS "${MPI_Fortran_COMPILE_FLAGS}")
		set(CMAKE_REQUIRED_DEFINITIONS "")
		set(CMAKE_REQUIRED_INCLUDES "${MPI_Fortran_INCLUDE_PATH}")
		set(CMAKE_REQUIRED_LIBRARIES "${MPI_Fortran_LIBRARIES}")

		# generate test source
		set(TEST_SOURCE "      PROGRAM basic\n")
		set(TEST_SOURCE "${TEST_SOURCE}      IMPLICIT NONE\n")
		set(TEST_SOURCE "${TEST_SOURCE}      INCLUDE \"mpif.h\"\n")
		set(TEST_SOURCE "${TEST_SOURCE}      INTEGER CODE\n")
		set(TEST_SOURCE "${TEST_SOURCE}      CODE = ${symbol}\n")
		set(TEST_SOURCE "${TEST_SOURCE}      END\n")

		# try to compile source
		check_fortran_source_compiles("${TEST_SOURCE}" ${variable})
	endif ()

	# set variable to false, if MPI was not found
	set(${variable} false)
endfunction(CHECK_FORTRAN_MPI_SYMBOL_EXISTS)
