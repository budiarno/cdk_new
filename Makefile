#master makefile

SHELL = /bin/bash
UID := $(shell id -u)
ifeq ($(UID), 0)
warn:
	@echo "You are running as root. Do not do this, it is dangerous."
	@echo "Aborting the build. Goodbye."
else

PARALLEL_JOBS := $(shell echo $$((1 + `getconf _NPROCESSORS_ONLN 2>/dev/null || echo 1`)))
override MAKE = make $(if $(findstring j,$(filter-out --%,$(MAKEFLAGS))),,-j$(PARALLEL_JOBS))

include make/buildenv.mk

############################################################################
#  A print out of environment variables
#
# maybe a help about all supported targets would be nice here, too...
#
printenv:
	@echo
	@echo
	@echo '================================================================================'
	@echo "Build Environment Variables:"
	@echo "MAINTAINER       : $(MAINTAINER)"
	@echo "ARCHIVE_DIR      : $(ARCHIVE)"
	@echo "BASE_DIR         : $(BASE_DIR)"
	@echo "CDK_DIR          : $(CDK_DIR)"
	@echo "CUSTOM_DIR       : $(CUSTOM_DIR)"
	@echo "APPS_DIR         : $(APPS_DIR)"
	@echo "DRIVER_DIR       : $(DRIVER_DIR)"
	@echo "FLASH_DIR        : $(FLASH_DIR)"
	@echo "CROSS_DIR        : $(CROSS_DIR)"
	@echo "CROSS_BASE       : $(CROSS_BASE)"
	@echo "RELEASE_DIR      : $(RELEASE_DIR)"
	@echo "HOSTPREFIX       : $(HOSTPREFIX)"
	@echo "TARGETPREFIX     : $(TARGETPREFIX)"
	@echo "PATH             : `type -p fmt>/dev/null&&echo $(PATH)|sed 's/:/ /g' |fmt -65|sed 's/ /:/g; 2,$$s/^/                 : /;'||echo $(PATH)`"
	@echo "CPU_CORES        : $(CPU_CORES)"
	@echo "BOXARCH          : $(BOXARCH)"
	@echo "BUILD            : $(BUILD)"
	@echo "TARGET           : $(TARGET)"
	@echo "BOXTYPE          : $(BOXTYPE)"
	@echo "KERNEL_VERSION   : $(KERNEL_VERSION)"
	@echo "MULTICOM_VERSION : $(MULTICOM_VER)"
	@echo "PLAYER_VERSION   : $(PLAYER_VER)"
	@echo "MEDIAFW          : $(MEDIAFW)"
	@echo "EXTERNAL_LCD     : $(EXTERNAL_LCD)"
ifeq ($(TARGET), $(filter $(TARGET), hs7110 hs7119 hs7420 hs7429 hs7810a hs7819))
	@echo "DESTINATION      : $(DESTINATION)"
endif
	@echo "IMAGE            : $(IMAGE)"
	@echo "PARALLEL_JOBS    : $(PARALLEL_JOBS)"
	@echo '================================================================================'
ifeq ($(IMAGE), $(filter $(IMAGE), neutrino neutrino-wlandriver))
	@echo "NEUTRINO_VARIANT             : $(NEUTRINO_VARIANT)"
	@echo "LOCAL_NEUTRINO_BUILD_OPTIONS : $(LOCAL_NEUTRINO_BUILD_OPTIONS)"
	@echo "LOCAL_NEUTRINO_CFLAGS        : $(LOCAL_NEUTRINO_CFLAGS)"
	@echo "LOCAL_NEUTRINO_DEPS          : $(LOCAL_NEUTRINO_DEPS)"
else ifeq ($(IMAGE), $(filter $(IMAGE), enigma2 enigma2-wlandriver))
	@echo "E2_DIFF                      : $(E2_DIFF)"
	@echo "E2_REVISION                  : $(E2_REVISION)"
	@echo "LOCAL_ENIGMA2_BUILD_OPTIONS  : $(LOCAL_ENIGMA2_BUILD_OPTIONS)"
	@echo "LOCAL_ENIGMA2_CPPFLAGS       : $(LOCAL_ENIGMA2_CPPFLAGS)"
	@echo "LOCAL_ENIGMA2_DEPS           : $(LOCAL_ENIGMA2_DEPS)"
endif
	@echo '================================================================================'
	@echo ""
	@$(MAKE) --no-print-directory toolcheck
ifeq ($(MAINTAINER),)
	@echo "##########################################################################"
	@echo "# The MAINTAINER variable is not set. It defaults to your name from the  #"
	@echo "# passwd entry, but this seems to have failed. Please set it in 'config'.#"
	@echo "##########################################################################"
	@echo
endif
#	@LC_ALL=C make -n preqs|grep -q "Nothing to be done" && P=false || P=true; \
#	test -d $(TARGETPREFIX) && T=false || T=true; \
#	type -p $(TARGET)-pkg-config >/dev/null 2>&1 || T=true; \
#	PATH=$(PATH):$(CROSS_DIR)/bin; \
#	type -p $(TARGET)-gcc >/dev/null 2>&1 && C=false || C=true; \
#	if $$P || $$T || $$C; then \
#		echo "Your next steps are most likely (in this order):"; \
#		$$P && echo "	* 'make preqs'		for prerequisites"; \
#		$$C && echo "	* 'make crosstool'	for the cross compiler"; \
#		$$T && echo "	* 'make bootstrap'	to prepare the target root"; \
#		echo; \
#	fi

help:
	@echo "a few helpful make targets:"
	@echo "* make crosstool           - build cross toolchain"
	@echo "* make bootstrap           - prepares for building"
	@echo

# define package versions first...
include make/bootstrap.mk
include make/contrib-libs.mk
include make/contrib-apps.mk
include make/linux-kernel.mk
include make/driver.mk
include make/tools.mk
include make/root-etc.mk
include make/python.mk
include make/gstreamer.mk
include make/enigma2.mk
include make/enigma2-plugins.mk
include make/enigma2-release.mk
include make/neutrino.mk
include make/neutrino-plugins.mk
include make/neutrino-release.mk
include make/cleantargets.mk
include make/patches.mk
include make/yaud.mk

all:
	@echo "'make all' is not a valid target. Please read the documentation."

# target for testing only. not useful otherwise
everything: $(shell sed -n 's/^\$$.D.\/\(.*\):.*/\1/p' make/*.mk)

# print all present targets...
print-targets:
	sed -n 's/^\$$.D.\/\(.*\):.*/\1/p; s/^\([a-z].*\):\( \|$$\).*/\1/p;' \
		`ls -1 make/*.mk|grep -v make/unmaintained.mk` Makefile | \
		sort -u | fold -s -w 65

# for local extensions, e.g. special plugins or similar...
# put them into $(BASE_DIR)/local since that is ignored in .gitignore
-include ./Makefile.local

# debug target, if you need that, you know it. If you don't know if you need
# that, you don't need it.
.print-phony:
	@echo $(PHONY)

PHONY += everything print-targets
PHONY += all printenv .print-phony
.PHONY: $(PHONY)

# this makes sure we do not build top-level dependencies in parallel
# (which would not be too helpful anyway, running many configure and
# downloads in parallel...), but the sub-targets are still built in
# parallel, which is useful on multi-processor / multi-core machines
.NOTPARALLEL:
endif
