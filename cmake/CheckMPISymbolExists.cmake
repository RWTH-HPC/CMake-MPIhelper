# This file is part of MUST (Marmot Umpire Scalable Tool)
#
# Copyright (C)
#   2011-2015 ZIH, Technische Universitaet Dresden, Federal Republic of Germany
#   2011-2015 Lawrence Livermore National Laboratories, United States of America
#   2013-2015 RWTH Aachen University, Federal Republic of Germany
#
# See the file LICENSE.txt in the package base directory for details


#
# include other CMake files
#
include(CheckSymbolExists)


## \brief Wrapper for check_symbol_exists to test \p function and
#   P${function} in one step.
#
# \details Calls check_symbol_exists for \p function and P${function} and
#   sets \p variable only, if both symbols exist.
#
#   The following variables may be set before calling this macro to modify the
#   way the check is run:
#
#   CMAKE_REQUIRED_FLAGS = string of compile command line flags
#   CMAKE_REQUIRED_DEFINITIONS = list of macros to define (-DFOO=bar)
#   CMAKE_REQUIRED_INCLUDES = list of include directories
#   CMAKE_REQUIRED_LIBRARIES = list of libraries to link
#
#
# \param function MPI function to test against
# \param files Include the given header files
# \param variable Variable to be set
#
function (CHECK_MPI_SYMBOL_EXISTS symbol files variable)
	# get upper case of symbol for variable name
	STRING (TOUPPER ${symbol} sym_upper)

	# check for PMPI_* function
	check_symbol_exists(P${symbol} "${files}" HAVE_P${sym_upper})
	if (HAVE_P${sym_upper})
		# PMPI function was found, so we can check the original MPI function now
		check_symbol_exists(${symbol} "${files}" ${variable})
	endif (HAVE_P${sym_upper})
endfunction ()
