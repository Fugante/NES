TARGET_EXEC := game.nes

BUILD_DIR := ./build
SRC_DIRS := ./src

SRCS := $(shell find $(SRC_DIRS) -name '*.asm')

OBJS := $(SRCS:%=$(BUILD_DIR)/%.o)

DEPS := $(OBJS:.o=.d)

INC_DIRS := $(shell find $(SRC_DIRS) -type d)
INC_FLAFS := $(addprefix -I,%(INC_DIRS))


$(BUILD_DIR)/$(TARGET_EXEC): $(OBJS)
	cl65 $(OBJS) --config nes.cfg -o $@

$(BUILD_DIR)/%.asm.o : %.asm
	mkdir -p $(dir $@)
	ca65 $< -o $@

.PHONY: clean
clean:
	rm -r $(BUILD_DIR)
