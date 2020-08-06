# **************************************************************************** #
#                                                                              #
#                                                         ::::::::             #
#    Makefile                                           :+:    :+:             #
#                                                      +:+                     #
#    By: sverschu <sverschu@student.codam.n>          +#+                      #
#                                                    +#+                       #
#    Created: 2020/06/20 13:11:59 by sverschu      #+#    #+#                  #
#    Updated: 2020/08/06 20:00:16 by sverschu      ########   odam.nl          #
#                                                                              #
# **************************************************************************** #

NAME = libvector.a

# build variables

# directories
SRC_D = src
OBJ_D = obj
INC_D = inc

# C source and header files
SRC =	$(SRC_D)/vector.c													\
		$(SRC_D)/dispatch.c													\
		$(SRC_D)/ops/create.c												\
		$(SRC_D)/ops/destroy.c												\
		$(SRC_D)/ops/clone.c												\
		$(SRC_D)/ops/pushfront.c											\
		$(SRC_D)/ops/pushback.c												\
		$(SRC_D)/ops/pushat.c												\
		$(SRC_D)/ops/peekfront.c											\
		$(SRC_D)/ops/peekback.c												\
		$(SRC_D)/ops/peekat.c												\
		$(SRC_D)/ops/popfront.c												\
		$(SRC_D)/ops/popback.c												\
		$(SRC_D)/ops/popat.c												\
		$(SRC_D)/ops/size.c													\
		$(SRC_D)/libc/ft_memset.c											\
		$(SRC_D)/libc/ft_calloc.c											\
		$(SRC_D)/libc/ft_memcpy.c											\

INC =	$(INC_D)/vector.h													\
		$(INC_D)/vector_internal.h											\

OBJ :=	$(SRC:$(SRC_D)/%.c=$(OBJ_D)/%.o)

# output format
CC_LOG=./.cc.log
CC_ERROR=./.cc.error

NO_COLOR=\x1b[0m
OK_COLOR=\x1b[32;01m
ERROR_COLOR=\x1b[31;01m
WARN_COLOR=\x1b[33;01m

OK_STRING=$(OK_COLOR)[OK]$(NO_COLOR)
ERROR_STRING=$(ERROR_COLOR)[ERRORS]$(NO_COLOR)
WARN_STRING=$(WARN_COLOR)[WARNINGS]$(NO_COLOR)

# warriors of choice
ECHO=printf
CAT=cat

# compiler and linker
CC = clang
LD = ar

# compile flags
CC_FLAGS =			-Wall -Wextra -Werror
LD_FLAGS =  		-rcs

# debugging or optimilization flags
CC_OPT_FLAGS = -O3															\
			   -march=native

ifeq ($(ASAN),1)
	CC_FLAGS += -fsanitize=address											\
				-fno-optimize-sibling-calls
	LD_FLAGS +=
	DEBUG = 1
endif

ifeq ($(DEBUG),1)
	CC_FLAGS += -g 															\
				-O0															\
				-fno-omit-frame-pointer										\
				-fstack-protector-all										\
				-DDEBUG
	LD_FLAGS +=
else
	CC_FLAGS += $(CC_OPT_FLAGS)
	LD_FLAGS +=
endif

# os variables
UNAME_S := $(shell uname -s)
ifeq ($(UNAME_S),Linux)
    OS = LINUX
    CC_FLAGS += -D LINUX -Wno-misleading-indentation
    LD_FLAGS +=
endif
ifeq ($(UNAME_S),Darwin)
    OS = OSX
    CC_FLAGS += -D OSX
    LD_FLAGS +=
endif

# make commands
all: $(NAME)

submodule:
	@git submodule update --init --remote --recursive

$(NAME): $(OBJ_D) $(OBJ) $(INC_D) $(INC)
	@$(ECHO) "Linking $(NAME)..."
	@$(LD) $(LD_FLAGS) $(NAME) $(OBJ) 2>$(CC_LOG)
	@if test -e $(CC_ERROR); then											\
		$(ECHO) "$(ERROR_STRING)\n" && $(CAT) $(CC_LOG);					\
	elif test -s $(CC_LOG); then											\
		$(ECHO) "$(WARN_STRING)\n" && $(CAT) $(CC_LOG);						\
	else																	\
		$(ECHO) "$(OK_STRING)\n";											\
	fi
	@$(RM) -f $(CC_LOG) $(CC_ERROR)

$(OBJ_D):
	@mkdir -p $(OBJ_D)
	@mkdir -p $(OBJ_D)/ops
	@mkdir -p $(OBJ_D)/libc

$(OBJ): $(OBJ_D)/%.o: $(SRC_D)/%.c
	@$(ECHO) "Compiling $<..."
	@$(CC) $(CC_FLAGS) -I$(INC_D) -c $< -o $@ 2>$(CC_LOG) 					\
		|| touch $(CC_ERROR)
	@if test -e $(CC_ERROR); then											\
		$(ECHO) "$(ERROR_STRING)\n" && $(CAT) $(CC_LOG);					\
	elif test -s $(CC_LOG); then											\
		$(ECHO) "$(WARN_STRING)\n" && $(CAT) $(CC_LOG);						\
	else																	\
		$(ECHO) "$(OK_STRING)\n";											\
	fi
	@$(RM) -f $(CC_LOG) $(CC_ERROR)

clean:
	@$(RM) $(OBJ)
	@$(RM) -r $(NAME).dSYM
	@$(RM) -r $(OBJ_D)

fclean: clean
	@$(RM) $(NAME)
	@$(RM) bonus

bonus: $(NAME)
	@touch bonus

lre:
	@$(RM) $(NAME)
	@$(RM) $(OBJ)
	@$(RM) -r $(OBJ_D)
	@make

norm:
	@norminette $(SRC) $(INC)

re: fclean all

.PHONY = all clean fclean re bonus