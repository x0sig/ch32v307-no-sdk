CC = riscv-none-elf-gcc

CURRENT_DIR := $(dir $(realpath $(lastword $(MAKEFILE_LIST))))
SRC_DIR := $(CURRENT_DIR)src
OBJ_DIR := $(CURRENT_DIR)obj
INC_DIR := $(CURRENT_DIR)inc

# Header files
LIBS := -I$(INC_DIR)
# Source files
SRCS := $(wildcard $(SRC_DIR)/*.c) $(wildcard $(SRC_DIR)/*.S)
# Object files
OBJS := $(patsubst $(SRC_DIR)/%.c,$(OBJ_DIR)/%.o,$(SRCS))
OBJS := $(patsubst $(SRC_DIR)/%.S,$(OBJ_DIR)/%.o,$(OBJS))
# Dependency files
DEPS := $(OBJS:.o=.d)

# Rule to compile .S files to .o files
$(OBJ_DIR)/%.o: $(SRC_DIR)/%.S
	$(CC) -march=rv32imac_zicsr -mabi=ilp32 -msmall-data-limit=8 -msave-restore -Os -fmessage-length=0 -fsigned-char -ffunction-sections -fdata-sections -fno-common -Wunused -Wuninitialized  -g -x assembler-with-cpp $(LIBS) -MMD -MP -MF"$(@:%.o=%.d)" -MT"$(@)" -c -o "$@" "$<"

# Rule to compile .c files to .o files
$(OBJ_DIR)/%.o: $(SRC_DIR)/%.c
	$(CC) -march=rv32imac_zicsr -mabi=ilp32 -msmall-data-limit=8 -msave-restore -Os -fmessage-length=0 -fsigned-char -ffunction-sections -fdata-sections -fno-common -Wunused -Wuninitialized  -g $(LIBS) -std=gnu99 -MMD -MP -MF"$(@:%.o=%.d)" -MT"$(@)" -c -o "$@" "$<"

main.o: main.c
	$(CC) -march=rv32imac_zicsr -mabi=ilp32 -msmall-data-limit=8 -msave-restore -Os -fmessage-length=0 -fsigned-char -ffunction-sections -fdata-sections -fno-common -Wunused -Wuninitialized  -g $(LIBS) -std=gnu99 -MMD -MP -MF"$(@:%.o=%.d)" -MT"$(@)" -c -o "$@" "$<"

# Rule to compile main.c project
main.elf: $(OBJS) main.o
	$(CC) -march=rv32imac_zicsr -mabi=ilp32 -msmall-data-limit=8 -msave-restore -Os -fmessage-length=0 -fsigned-char -ffunction-sections -fdata-sections -fno-common -Wunused -Wuninitialized  -g -T link.ld -nostartfiles -Xlinker --gc-sections -L"$(CURRENT_DIR)" --specs=nano.specs --specs=nosys.specs -o "$@" main.o $(OBJS) $(LIBS)

obj/:
	@mkdir -p $(OBJ_DIR)

cv_clean:
	rm -f $(OBJ_DIR)/*
	rm -f main.elf main.d main.o

cv_flash: obj/ main.elf
	@wlink flash main.elf

.PHONY: cv_clean cv_flash
