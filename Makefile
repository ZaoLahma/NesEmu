CCOMMAND = clang
CFLAGS = -Wall -c -Wextra -g
DEBUGFLAGS = -DNONE
LINKARGS = -lpthread -lsdl2
SOURCES = $(wildcard src/*.c config/*.c)
RELEASE_SOURCES = $(wildcard src/release/*.c)
TEST_SOURCES = $(wildcard test/*.c)
OBJECTS = $(SOURCES:.c=.o)
RELEASE_OBJECTS = $(RELEASE_SOURCES:.c=.o)
TEST_OBJECTS = $(TEST_SOURCES:.c=.o)
INC_DIRS = -I./inc -I./config
TEST_EXE_NAME = test_gameboy
RELEASE_EXE_NAME = gameboy

$(TEST_EXE_NAME): DEBUGFLAGS := -DDEBUG
$(TEST_EXE_NAME): CFLAGS += --coverage
$(TEST_EXE_NAME): LINKARGS += --coverage
$(TEST_EXE_NAME): $(OBJECTS) $(TEST_OBJECTS)
	$(CCOMMAND) $(OBJECTS) $(TEST_OBJECTS) $(LINKARGS) -o $(TEST_EXE_NAME)
	./$(TEST_EXE_NAME)
	@gcov ./src/*.gcno > coverage.txt || true
	@make -s clean || true

$(RELEASE_EXE_NAME): $(OBJECTS) $(RELEASE_OBJECTS)
	$(CCOMMAND) $(OBJECTS) $(RELEASE_OBJECTS) $(LINKARGS) -o $(RELEASE_EXE_NAME)

%.o: %.c
	$(CCOMMAND) $(INC_DIRS) -c $(CFLAGS) $(DEBUGFLAGS) $< -o $@

clean:
	rm -f $(TEST_EXE_NAME) $(RELEASE_EXE_NAME) $(OBJECTS) $(TEST_OBJECTS) $(RELEASE_OBJECTS)
	rm -f ./*.gc* ./config/*.gc* ./src/*.gc* ./test/*.gc*
