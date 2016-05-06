# This file is part of CMake-MPIhelper.
#
# Copyright (C)
#   2015 RWTH Aachen University, Federal Republic of Germany
#
# See the file LICENSE in the package base directory for details.

include(CheckCSourceCompiles)


## \brief Wrapper for check_source_compiles to test if MPI implements const
#   correctness or not.
#
# \details Sets MPI environment, generates a new source file and calls
#   check_source_compiles.
#
#
# \param variable Variable to be set, if const correctness is implemented.
#
# \return If const correctness is used, \p variable will be set true. In any
#   other case \p variable will become false.
#
function(CHECK_MPI_CONST_CORRECTNESS variable)
	# Note: a check against CMake cache is not needed in this function, thus all
	# called functions implement such a check.

	# search for MPI environment
	find_package(MPI)

	if (MPI_C_FOUND)
		# set environment
		set(CMAKE_REQUIRED_FLAGS "${MPI_C_COMPILE_FLAGS}")
		set(CMAKE_REQUIRED_DEFINITIONS "")
		set(CMAKE_REQUIRED_INCLUDES "${MPI_C_INCLUDE_PATH}")
		set(CMAKE_REQUIRED_LIBRARIES "${MPI_C_LIBRARIES}")

		# generate test source
		set (TEST_SOURCE "#include <mpi.h>
			int
			main(int argc, char **argv)
			{
				const int i = 0;
				MPI_Graph_create(MPI_COMM_WORLD, 0, &i, &i, 0, NULL);
				return 0;
			}
		")

		# try to compile source
		check_c_source_compiles("${TEST_SOURCE}" ${variable})
	endif ()

	# set variable to false, if MPI was not found
	set(${variable} false)
endfunction(CHECK_MPI_CONST_CORRECTNESS)
