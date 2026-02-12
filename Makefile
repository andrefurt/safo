VERSION := 0.1.0
APP_NAME := Safo
CLI_NAME := safo
BUNDLE_ID := com.significa.safo

DIST_DIR := dist
APP_BUNDLE := $(DIST_DIR)/$(APP_NAME).app
PACKAGE_ZIP := $(DIST_DIR)/$(APP_NAME)-$(VERSION).zip

BIN_PATH = $(shell swift build -c release --show-bin-path)

# --- Build ---

.PHONY: build bundle package install uninstall clean

build:
	swift build -c release

# --- Bundle ---

bundle: build
	rm -rf $(APP_BUNDLE)
	mkdir -p $(APP_BUNDLE)/Contents/MacOS
	mkdir -p $(APP_BUNDLE)/Contents/Resources
	cp $(BIN_PATH)/$(APP_NAME) $(APP_BUNDLE)/Contents/MacOS/$(APP_NAME)
	cp Resources/Info.plist $(APP_BUNDLE)/Contents/Info.plist
	/usr/libexec/PlistBuddy -c "Add :CFBundleName string $(APP_NAME)" $(APP_BUNDLE)/Contents/Info.plist
	/usr/libexec/PlistBuddy -c "Add :CFBundleDisplayName string $(APP_NAME)" $(APP_BUNDLE)/Contents/Info.plist
	/usr/libexec/PlistBuddy -c "Add :CFBundleIdentifier string $(BUNDLE_ID)" $(APP_BUNDLE)/Contents/Info.plist
	/usr/libexec/PlistBuddy -c "Add :CFBundleVersion string $(VERSION)" $(APP_BUNDLE)/Contents/Info.plist
	/usr/libexec/PlistBuddy -c "Add :CFBundleShortVersionString string $(VERSION)" $(APP_BUNDLE)/Contents/Info.plist
	/usr/libexec/PlistBuddy -c "Add :CFBundleExecutable string $(APP_NAME)" $(APP_BUNDLE)/Contents/Info.plist
	/usr/libexec/PlistBuddy -c "Add :CFBundlePackageType string APPL" $(APP_BUNDLE)/Contents/Info.plist
	/usr/libexec/PlistBuddy -c "Add :CFBundleInfoDictionaryVersion string 6.0" $(APP_BUNDLE)/Contents/Info.plist
	/usr/libexec/PlistBuddy -c "Add :LSMinimumSystemVersion string 14.0" $(APP_BUNDLE)/Contents/Info.plist
	codesign --force --sign - $(APP_BUNDLE)
	@echo "Bundle created: $(APP_BUNDLE)"

# --- Package ---

package: bundle
	cp $(BIN_PATH)/safo-cli $(DIST_DIR)/$(CLI_NAME)
	cd $(DIST_DIR) && zip -r ../$(APP_NAME)-$(VERSION).zip $(APP_NAME).app $(CLI_NAME)
	rm $(DIST_DIR)/$(CLI_NAME)
	@echo "Package created: $(APP_NAME)-$(VERSION).zip"
	@shasum -a 256 $(APP_NAME)-$(VERSION).zip

# --- Install ---

install: bundle
	cp -R $(APP_BUNDLE) /Applications/$(APP_NAME).app
	cp $(BIN_PATH)/safo-cli /usr/local/bin/$(CLI_NAME)
	@echo "Installed $(APP_NAME).app to /Applications"
	@echo "Installed $(CLI_NAME) to /usr/local/bin"

uninstall:
	rm -rf /Applications/$(APP_NAME).app
	rm -f /usr/local/bin/$(CLI_NAME)
	@echo "Uninstalled $(APP_NAME)"

# --- Clean ---

clean:
	rm -rf $(DIST_DIR)
	rm -f $(APP_NAME)-*.zip
	swift package clean
