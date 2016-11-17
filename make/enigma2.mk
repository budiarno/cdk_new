#
# enigma2
#
E_CPPFLAGS    = -I$(DRIVER_DIR)/include
E_CPPFLAGS   += -I$(TARGETPREFIX)/usr/include
E_CPPFLAGS   += -I$(KERNEL_DIR)/include
E_CPPFLAGS   += -I$(APPS_DIR)/tools/libeplayer3/include
E_CPPFLAGS   += -I$(APPS_DIR)/tools
E_CPPFLAGS   += $(LOCAL_ENIGMA2_CPPFLAGS)

ENIGMA2_DEPS  = $(D)/bootstrap $(D)/opkg $(D)/libncurses $(D)/lirc $(D)/libcurl $(D)/libid3tag $(D)/libmad
ENIGMA2_DEPS += $(D)/libpng $(D)/libjpeg $(D)/libgif $(D)/libfreetype
ENIGMA2_DEPS += $(D)/alsa-utils $(D)/ffmpeg
ENIGMA2_DEPS += $(D)/libfribidi $(D)/libsigc++_e2 $(D)/libexpat $(D)/libdvbsi++ $(D)/libusb
ENIGMA2_DEPS += $(D)/sdparm $(D)/minidlna $(D)/ethtool
ENIGMA2_DEPS += python-all
ENIGMA2_DEPS += $(D)/libdreamdvd $(D)/tuxtxt32bpp $(D)/hotplug_e2
ENIGMA2_DEPS += $(LOCAL_ENIGMA2_DEPS)

ifeq ($(IMAGE), enigma2-wlandriver)
ENIGMA2_DEPS += $(D)/wpa_supplicant $(D)/wireless_tools
endif

ifeq ($(EXTERNAL_LCD), externallcd)
ENIGMA2_DEPS  += $(D)/graphlcd
E_CONFIG_OPTS += --with-graphlcd
endif

ifeq ($(EXTERNAL_LCD), lcd4linux)
ENIGMA2_DEPS += $(D)/lcd4linux
endif

ifeq ($(E2_DIFF), 5)
ENIGMA2_DEPS  += $(D)/libxmlccwrap
endif

ifeq ($(MEDIAFW), eplayer3)
ENIGMA2_DEPS  += $(D)/tools-eplayer3
E_CONFIG_OPTS += --enable-libeplayer3
endif

ifeq ($(MEDIAFW), gstreamer)
ENIGMA2_DEPS  += $(D)/gst_plugins_dvbmediasink
E_CONFIG_OPTS += --with-gstversion=1.0 --enable-mediafwgstreamer
endif

ifeq ($(MEDIAFW), gst-eplayer3)
ENIGMA2_DEPS  += $(D)/tools-libeplayer3
ENIGMA2_DEPS  += $(D)/gst_plugins_dvbmediasink
E_CONFIG_OPTS += --with-gstversion=1.0 --enable-libeplayer3 --enable-mediafwgstreamer
endif

ifeq ($(BOXTYPE),spark)
E_CONFIG_OPTS += --enable-spark
endif

ifeq ($(BOXTYPE),spark7162)
E_CONFIG_OPTS += --enable-spark7162
ENIGMA2_DEPS += ntp
endif

ifeq ($(BOXTYPE),fortis_hdbox)
E_CONFIG_OPTS += --enable-fortis_hdbox
endif

ifeq ($(BOXTYPE),octagon1008)
E_CONFIG_OPTS += --enable-octagon1008
endif

ifeq ($(BOXTYPE),atevio7500)
E_CONFIG_OPTS += --enable-atevio7500
endif

ifeq ($(BOXTYPE),hs7110)
E_CONFIG_OPTS += --enable-hs7110
endif

ifeq ($(BOXTYPE),hs7420)
E_CONFIG_OPTS += --enable-hs7420
endif

ifeq ($(BOXTYPE),hs7810a)
E_CONFIG_OPTS += --enable-hs7810a
endif

ifeq ($(BOXTYPE),hs7119)
E_CONFIG_OPTS += --enable-hs7119
endif

ifeq ($(BOXTYPE),hs7429)
E_CONFIG_OPTS += --enable-hs7429
endif

ifeq ($(BOXTYPE),hs7819)
E_CONFIG_OPTS += --enable-hs7819
endif

E_CONFIG_OPTS +=$(LOCAL_ENIGMA2_BUILD_OPTIONS)

#
# yaud-enigma2
#
yaud-enigma2: yaud-none $(D)/enigma2 $(D)/enigma2-plugins $(D)/release_enigma2
	$(TUXBOX_YAUD_CUSTOMIZE)

#
# enigma2
#
REPO_REPLY_1="https://github.com/MaxWiesel/enigma2-openpli-fulan.git"

$(D)/enigma2.do_prepare: | $(ENIGMA2_DEPS)
	rm -rf $(SOURCE_DIR)/enigma2; \
	rm -rf $(SOURCE_DIR)/enigma2.org; \
	REVISION=$(E2_REVISION); \
	HEAD="master"; \
	DIFF=$(E2_DIFF); \
	clear; \
	echo "Starting OpenPLi Enigma2 build"; \
	echo "=============================="; \
	echo; \
	echo "Revision        : "$$REVISION; \
	echo "Diff            : "$$DIFF; \
	echo ""; \
	if [ "$$DIFF" != "1" ]; then \
		[ -d "$(ARCHIVE)/enigma2-pli-nightly.git" ] && \
		(cd $(ARCHIVE)/enigma2-pli-nightly.git; echo "Pulling archived OpenPLi git..."; git pull -q; echo "Checking out HEAD..."; git checkout -q HEAD; cd "$(BUILD_TMP)";); \
		[ -d "$(ARCHIVE)/enigma2-pli-nightly.git" ] || \
		(echo "Cloning remote OpenPLi git..."; git clone -q -b $$HEAD $$REPO $(ARCHIVE)/enigma2-pli-nightly.git;); \
		echo "Copying local git content to build environment..."; cp -ra $(ARCHIVE)/enigma2-pli-nightly.git $(SOURCE_DIR)/enigma2; \
		[ "$$REVISION" == "" ] || (cd $(SOURCE_DIR)/enigma2; echo "Checking out revision $$REVISION..."; git checkout -q "$$REVISION"; cd "$(BUILD_TMP)";); \
		cp -ra $(SOURCE_DIR)/enigma2 $(SOURCE_DIR)/enigma2.org; \
		echo "Applying diff-$$DIFF patch..."; \
		set -e; cd $(SOURCE_DIR)/enigma2 && patch -p1 < "../../cdk_new/Patches/enigma2-pli-nightly.$$DIFF.diff"; \
		if [ "$(MEDIAFW)" == "eplayer3" ]; then \
			set -e; cd $(SOURCE_DIR)/enigma2 && patch -p1 < "../../cdk_new/Patches/eplayer3.$$DIFF.patch"; \
		fi; \
		echo "Patching to diff-$$DIFF completed."; echo; \
		cd $(SOURCE_DIR)/enigma2; \
		echo "Building VFD-drivers..."; \
		patch -p1 -s -i "../../cdk_new/Patches/vfd-drivers.patch"; \
		rm -rf $(TARGETPREFIX)/usr/local/share/enigma2/rc_models; \
		echo; \
		echo "Patching remote control files..."; \
		patch -p1 -s -i "../../cdk_new/Patches/rc-models.patch"; \
		echo "Build preparation for OpenPLi complete."; echo; \
	else \
		[ -d "$(SOURCE_DIR)/enigma2" ] ; \
		echo "Cloning local git content to build environment..."; \
		git clone -b $$HEAD $$REPO_REPLY_1 $(SOURCE_DIR)/enigma2; \
	fi
	@touch $@

$(SOURCE_DIR)/enigma2/config.status:
	cd $(SOURCE_DIR)/enigma2; \
		./autogen.sh; \
		sed -e 's|#!/usr/bin/python|#!$(HOSTPREFIX)/bin/python|' -i po/xml2po.py; \
		$(BUILDENV) \
		./configure $(CONFIGURE_SILENT) \
			--build=$(BUILD) \
			--host=$(TARGET) \
			$(E_CONFIG_OPTS) \
			--with-libsdl=no \
			--datadir=/usr/local/share \
			--libdir=/usr/lib \
			--bindir=/usr/bin \
			--prefix=/usr \
			--sysconfdir=/etc \
			--with-boxtype=none \
			PKG_CONFIG=$(PKG_CONFIG) \
			PKG_CONFIG_PATH=$(PKG_CONFIG_PATH) \
			PY_PATH=$(TARGETPREFIX)/usr \
			$(PLATFORM_CPPFLAGS)

$(D)/enigma2.do_compile: $(SOURCE_DIR)/enigma2/config.status
	cd $(SOURCE_DIR)/enigma2; \
		$(MAKE) all
	@touch $@

$(D)/enigma2: $(D)/enigma2.do_prepare $(D)/enigma2.do_compile
	$(MAKE) -C $(SOURCE_DIR)/enigma2 install DESTDIR=$(TARGETPREFIX)
	if [ -e $(TARGETPREFIX)/usr/bin/enigma2 ]; then \
		$(TARGET)-strip $(TARGETPREFIX)/usr/bin/enigma2; \
	fi
	if [ -e $(TARGETPREFIX)/usr/local/bin/enigma2 ]; then \
		$(TARGET)-strip $(TARGETPREFIX)/usr/local/bin/enigma2; \
	fi
	@echo; \
	echo "Adding PLi-HD skin"; \
	HEAD="master"; \
	REPO="https://github.com/littlesat/skin-PLiHD.git"; \
	[ -d $(ARCHIVE)/PLi-HD_skin.git ] && \
		(echo -n "Pulling archived PLi-HD skin git..."; cd $(ARCHIVE)/PLi-HD_skin.git; git pull -q; git checkout -q $$HEAD; cd "$(BUILD_TMP)"; echo " done.";); \
	[ -d $(ARCHIVE)/PLi-HD_skin.git ] || \
		(echo -n "Cloning PLi-HD skin git..."; git clone -q -b $$HEAD $$REPO $(ARCHIVE)/PLi-HD_skin.git; echo " done.";);
	@cp -ra $(ARCHIVE)/PLi-HD_skin.git/usr/share/enigma2/* $(TARGETPREFIX)/usr/local/share/enigma2; \
	for i in \
		PLi-HD_skin.patch \
	; do \
		echo -e "==> \033[31mApplying Patch:\033[0m $$i"; \
		cd $(TARGETPREFIX)/usr/local/share/enigma2; \
		$(PATCH)/$$i; \
	done
	$(TOUCH)

enigma2-clean:
	rm -f $(D)/enigma2
	rm -f $(D)/enigma2.do_compile
	cd $(SOURCE_DIR)/enigma2; \
		$(MAKE) distclean

enigma2-distclean:
	rm -f $(D)/enigma2
	rm -f $(D)/enigma2.do_compile
	rm -f $(D)/enigma2.do_prepare
	rm -rf $(SOURCE_DIR)/enigma2
	rm -rf $(SOURCE_DIR)/enigma2.org
