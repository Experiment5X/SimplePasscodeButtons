include theos/makefiles/common.mk

TARGET := iphone:7.0:2.0
ARCHS := armv6 arm64

BUNDLE_NAME = simplepasscodebuttonspreferences
simplepasscodebuttonspreferences_FILES = simplepasscodebuttonspreferences.mm
simplepasscodebuttonspreferences_INSTALL_PATH = /Library/PreferenceBundles
simplepasscodebuttonspreferences_FRAMEWORKS = UIKit
simplepasscodebuttonspreferences_PRIVATE_FRAMEWORKS = Preferences

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/simplepasscodebuttonspreferences.plist$(ECHO_END)
