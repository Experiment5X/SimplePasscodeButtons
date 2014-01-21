THEOS_DEVICE_IP = 192.168.1.11

TARGET := iphone:7.0:2.0
ARCHS := armv6 arm64

include theos/makefiles/common.mk

TWEAK_NAME = SimplePasscodeButtons
SimplePasscodeButtons_FILES = Tweak.xm
SimplePasscodeButtons_FRAMEWORKS = UIKit CoreGraphics

include $(THEOS_MAKE_PATH)/tweak.mk

SUBPROJECTS += simplepasscodebuttonspreferences
include theos/makefiles/aggregate.mk

after-install::
	install.exec "killall -9 SpringBoard"
SUBPROJECTS += simplepasscodebuttonspreferences
include $(THEOS_MAKE_PATH)/aggregate.mk
