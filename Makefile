PROJECT_NAME := my-new-project
BUILD_VERSION := v0.1

SRC_DIR := ./framework
GAME_SRC_DIR := ./game
BUILD_DIR := ./build
ASSETS_DIR := ./assets
MAPS_DIR := $(ASSETS_DIR)/tilemaps

LEVELS := $(MAPS_DIR)/level1.tmx $(MAPS_DIR)/debugroom.tmx

ARCHIVE_NAME := ./$(PROJECT_NAME).love
WIN64_ARTIFACT := ./$(PROJECT_NAME)-$(BUILD_VERSION)-win64.zip

ARTIFACTS := $(WIN64_ARTIFACT)

PHONY: build-dir

clean:
	rm -rf $(BUILD_DIR) *.love *.zip

build-dir:
	mkdir -p $(BUILD_DIR); \
	rsync -vr $(SRC_DIR)/* $(BUILD_DIR); \
	rsync -vr $(GAME_SRC_DIR)/* $(BUILD_DIR); \
	rsync --exclude="tilemaps" -vr ./assets $(BUILD_DIR); \
	./scripts/generate-leveldata.py $(LEVELS) > $(BUILD_DIR)/levels.lua; \
	sed -Ei 's/%_VERSION_%/$(BUILD_VERSION)/g' $(BUILD_DIR)/main.lua; \
	sed -Ei 's/%_NAME_%/$(PROJECT_NAME)/g' $(BUILD_DIR)/main.lua; \

$(ARCHIVE_NAME): build-dir
	cd $(BUILD_DIR); \
	zip -r ../$(ARCHIVE_NAME) *


$(WIN64_ARTIFACT): $(ARCHIVE_NAME)
	./scripts/builder.sh $(PROJECT_NAME) $(BUILD_VERSION)

package: $(ARTIFACTS)

run: build-dir
	love build --debug
