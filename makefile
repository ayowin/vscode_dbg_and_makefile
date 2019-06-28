# target name
TARGET = $(notdir $(PWD))
# compiler && parameters
COMPILER = g++
COMPILER_PARAMETERS = -std=c++11 -g
# include paths && libs
INCLUDEPATHS = 
LIBS = -lpthread 
# variables
ALL_DIRS := $(shell find $(SOURCE_DIR) $(PROJECT_DIR) -maxdepth 5 -type d)
INCLUDEPATHS += $(addprefix -I,$(ALL_DIRS)) 
SOURCE_FILES = $(foreach i,$(ALL_DIRS),$(wildcard $(i)/*.cpp))
O_FILES = $(notdir $(patsubst %.cpp, %.o, $(SOURCE_FILES)))
BUILD_DIR = build

VPATH += $(ALL_DIRS) 
VPATH += $(BUILD_DIR)

TARGET: LINK

LINK: COMPILE
	@echo "Linking..."
	@$(COMPILER) $(BUILD_DIR)/*.o -o $(BUILD_DIR)/$(TARGET) $(LIBS)
	@echo "Build success. Target =" $(BUILD_DIR)/$(TARGET) "."

COMPILE: $(O_FILES) 
$(O_FILES): %.o : %.cpp
ifneq  ($(BUILD_DIR), $(wildcard $(BUILD_DIR)))
	@mkdir -p $(BUILD_DIR)
endif
	@echo "Compiling" $(<F) ...
	@$(COMPILER) -c $< -o $(BUILD_DIR)/$@ $(INCLUDEPATHS) $(LIBS) $(COMPILER_PARAMETERS)

.PHONY: parameters
parameters: 
	@echo "TARGET:"   						$(TARGET)
	@echo "COMPILER:" 						$(COMPILER)
	@echo "COMPILER_PARAMETERS:" 			$(COMPILER_PARAMETERS)
	@echo "INCLUDEPATHS:" 					$(INCLUDEPATHS)
	@echo "LIBS:" 							$(LIBS)

.PHONY:clean
clean:
	rm -rf $(BUILD_DIR)
	rm -f $(TARGET)
	@echo "Clean success."
