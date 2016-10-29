xcodebuild:=xcodebuild -configuration

ifdef BUILDLOG
REDIRECT=>> $(BUILDLOG)
endif

.PHONY: release debug clean clean-release clean-debug uninstall uuid build-test

release: uuid
	$(xcodebuild) Release $(REDIRECT)
	rm -rf ./build

debug: uuid
	$(xcodebuild) Debug $(REDIRECT)
	rm -rf ./build


clean: clean-release clean-debug

clean-release:
	$(xcodebuild) Release clean

clean-debug:
	$(xcodebuild) Debug clean


uninstall:
	rm -rf "$(HOME)/Library/Application Support/Developer/Shared/Xcode/Plug-ins/CoderPower.xcplugin"

uuid:
	@xcode_path=`xcode-select -p`; \
	uuid=`defaults read "$${xcode_path}/../Info" DVTPlugInCompatibilityUUID`; \
	grep $${uuid} CoderPower/Info.plist > /dev/null ; \
	if [ $$? -ne 0 ]; then \
		printf "Add xcode uuid to Info.plist"
		plutil -insert DVTPlugInCompatibilityUUIDs.0 -string $${uuid} CoderPower/Info.plist; \
		printf "\n"; \
	fi ;

# Build with all the available Xcode in /Applications directory
build-test:
	@> build.log; \
    xcode_path=`xcode-select -p`; \
	for xcode in /Applications/Xcode*.app; do \
		sudo xcode-select -s "$$xcode"; \
		echo Building with $$xcode >> build.log; \
		"$(MAKE)" -C . BUILDLOG=build.log; \
	done; \
	sudo xcode-select -s $${xcode_path}; \
