# target name
TARGET = $(notdir $(PWD))
# compiler && parameters
COMPILER = g++
COMPILER_PARAMETERS_RELEASE = -std=c++11
COMPILER_PARAMETERS_DEBUG = $(COMPILER_PARAMETERS_RELEASE) -g
# include paths && libs
INCLUDEPATHS = 
LIBS = -lpthread 
# variables
ALL_DIRS := $(shell find $(SOURCE_DIR) $(PROJECT_DIR) -maxdepth 5 -type d)
INCLUDEPATHS += $(addprefix -I,$(ALL_DIRS)) 
SOURCE_FILES = $(foreach i,$(ALL_DIRS),$(wildcard $(i)/*.cpp))
RELEASE_O_FILES = $(notdir $(patsubst %.cpp, %.ro, $(SOURCE_FILES)))
DEBUG_O_FILES = $(notdir $(patsubst %.cpp, %.do, $(SOURCE_FILES)))
RELEASE_DIR = release
DEBUG_DIR = debug

VPATH += $(ALL_DIRS) 

# release
release: RELEASE_LINK
RELEASE_LINK: RELEASE_COMPILE
	@echo "Release linking..."
	@$(COMPILER) $(RELEASE_DIR)/*.ro -o $(RELEASE_DIR)/$(TARGET) $(LIBS)
	@echo "Build success. Release target =" $(RELEASE_DIR)/$(TARGET) "."
RELEASE_COMPILE: $(RELEASE_O_FILES) 
$(RELEASE_O_FILES): %.ro : %.cpp
ifneq  ($(RELEASE_DIR), $(wildcard $(RELEASE_DIR)))
	@mkdir -p $(RELEASE_DIR)
endif
	@echo "Release compiling" $(<F) ...
	@$(COMPILER) -c $< -o $(RELEASE_DIR)/$@ $(INCLUDEPATHS) $(LIBS) $(COMPILER_PARAMETERS_RELEASE)

# debug
debug: DEBUG_LINK
DEBUG_LINK: DEBUG_COMPILE
	@echo "Debug linking..."
	@$(COMPILER) $(DEBUG_DIR)/*.do -o $(DEBUG_DIR)/$(TARGET) $(LIBS)
	@echo "Build success. Debug target =" $(DEBUG_DIR)/$(TARGET) "."
DEBUG_COMPILE: $(DEBUG_O_FILES) 
$(DEBUG_O_FILES): %.do : %.cpp
ifneq  ($(DEBUG_DIR), $(wildcard $(DEBUG_DIR)))
	@mkdir -p $(DEBUG_DIR)
endif
	@echo "Debug compiling" $(<F) ...
	@$(COMPILER) -c $< -o $(DEBUG_DIR)/$@ $(INCLUDEPATHS) $(LIBS) $(COMPILER_PARAMETERS_DEBUG)

.PHONY: parameters
parameters: 
	@echo "TARGET:"   							$(TARGET)
	@echo "COMPILER:" 							$(COMPILER)
	@echo "COMPILER_PARAMETERS_RELEASE:" 		$(COMPILER_PARAMETERS_RELEASE)
	@echo "COMPILER_PARAMETERS_DEBUG:" 			$(COMPILER_PARAMETERS_DEBUG)
	@echo "INCLUDEPATHS:" 						$(INCLUDEPATHS)
	@echo "LIBS:" 								$(LIBS)
	@echo "RELEASE_DIR:"						$(RELEASE_DIR)
	@echo "DEBUG_DIR:"							$(DEBUG_DIR)

.PHONY:clean
clean:
	rm -rf $(DEBUG_DIR)
	rm -rf $(RELEASE_DIR)
	@echo "Clean success."
