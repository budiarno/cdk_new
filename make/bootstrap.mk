BOOTSTRAP  = directories crosstool $(D)/ccache
BOOTSTRAP += $(HOST_DIR)/bin/opkg.sh
BOOTSTRAP += $(HOST_DIR)/bin/opkg-chksvn.sh
BOOTSTRAP += $(HOST_DIR)/bin/opkg-gitdescribe.sh
BOOTSTRAP += $(HOST_DIR)/bin/opkg-find-requires.sh
BOOTSTRAP += $(HOST_DIR)/bin/opkg-find-provides.sh
BOOTSTRAP += $(HOST_DIR)/bin/opkg-module-deps.sh
BOOTSTRAP += $(HOST_DIR)/bin/get-git-archive.sh
BOOTSTRAP += $(D)/host_pkgconfig $(D)/host_module_init_tools $(D)/host_mtd_utils

$(D)/bootstrap: $(BOOTSTRAP)
	$(TOUCH)

$(HOST_DIR)/bin/unpack%.sh \
$(HOST_DIR)/bin/get%.sh \
$(HOST_DIR)/bin/opkg%sh: | directories
	$(SILENT)ln -sf $(SCRIPTS_DIR)/$(shell basename $@) $(HOST_DIR)/bin

#
STM_RELOCATE = /opt/STM/STLinux-2.4

# updates / downloads
STL_FTP = http://archive.stlinux.com/stlinux/2.4
STL_FTP_UPD_SRC  = $(STL_FTP)/updates/SRPMS
STL_FTP_UPD_SH4  = $(STL_FTP)/updates/RPMS/sh4
STL_FTP_UPD_HOST = $(STL_FTP)/updates/RPMS/host

## ordering is important here. The /host/ rule must stay before the less
## specific %.sh4/%.i386/%.noarch rule. No idea if this is portable or
## even reliable :-(
$(ARCHIVE)/stlinux24-host-%.i386.rpm \
$(ARCHIVE)/stlinux24-host-%noarch.rpm:
	$(WGET) $(STL_FTP_UPD_HOST)/$(subst $(ARCHIVE)/,"",$@)

$(ARCHIVE)/stlinux24-host-%.src.rpm:
	$(WGET) $(STL_FTP_UPD_SRC)/$(subst $(ARCHIVE)/,"",$@)

$(ARCHIVE)/stlinux24-sh4-%.sh4.rpm \
$(ARCHIVE)/stlinux24-cross-%.i386.rpm \
$(ARCHIVE)/stlinux24-sh4-%.noarch.rpm:
	$(WGET) $(STL_FTP_UPD_SH4)/$(subst $(ARCHIVE)/,"",$@)

# 4.6.3
#BINUTILS_VER  = 2.22-64
#GCC_VER       = 4.6.3-111
#LIBGCC_VER    = 4.6.3-111
#GLIBC_VER     = 2.10.2-42

# 4.8.4
BINUTILS_VER  = 2.24.51.0.3-76
GCC_VER       = 4.8.4-139
LIBGCC_VER    = 4.8.4-148
GLIBC_VER     = 2.14.1-59

crosstool-rpminstall: \
$(ARCHIVE)/stlinux24-cross-sh4-binutils-$(BINUTILS_VER).i386.rpm \
$(ARCHIVE)/stlinux24-cross-sh4-binutils-dev-$(BINUTILS_VER).i386.rpm \
$(ARCHIVE)/stlinux24-cross-sh4-cpp-$(GCC_VER).i386.rpm \
$(ARCHIVE)/stlinux24-cross-sh4-gcc-$(GCC_VER).i386.rpm \
$(ARCHIVE)/stlinux24-cross-sh4-g++-$(GCC_VER).i386.rpm \
$(ARCHIVE)/stlinux24-sh4-linux-kernel-headers-$(STM_KERNEL_HEADERS_VER).noarch.rpm \
$(ARCHIVE)/stlinux24-sh4-glibc-$(GLIBC_VER).sh4.rpm \
$(ARCHIVE)/stlinux24-sh4-glibc-dev-$(GLIBC_VER).sh4.rpm \
$(ARCHIVE)/stlinux24-sh4-libgcc-$(LIBGCC_VER).sh4.rpm \
$(ARCHIVE)/stlinux24-sh4-libstdc++-$(LIBGCC_VER).sh4.rpm \
$(ARCHIVE)/stlinux24-sh4-libstdc++-dev-$(LIBGCC_VER).sh4.rpm
	$(START_BUILD)
	$(SILENT)unpack-rpm.sh $(BUILD_TMP) $(STM_RELOCATE)/devkit/sh4 $(CROSS_DIR) \
		$^
	@touch $(D)/$(notdir $@)
	@echo -e "Build of \033[01;32m$@\033[0m completed."; echo

#
# crosstool-ng
#
CROSSTOOL_NG_VER = 1.22.0

$(ARCHIVE)/crosstool-ng-$(CROSSTOOL_NG_VER).tar.xz:
	$(WGET) http://crosstool-ng.org/download/crosstool-ng/crosstool-ng-$(CROSSTOOL_NG_VER).tar.xz

crosstool-ng: $(ARCHIVE)/crosstool-ng-$(CROSSTOOL_NG_VER).tar.xz
	make $(BUILD_TMP)
	if [ ! -e $(BASE_DIR)/cross ]; then \
		mkdir -p $(BASE_DIR)/cross; \
	fi;
	$(REMOVE)/crosstool-ng
	$(UNTAR)/crosstool-ng-$(CROSSTOOL_NG_VER).tar.xz
	$(SILENT)set -e; unset CONFIG_SITE; cd $(BUILD_TMP)/crosstool-ng; \
		cp -a $(PATCHES)/crosstool-ng-$(CROSSTOOL_NG_VER).config .config; \
		NUM_CPUS=$$(expr `getconf _NPROCESSORS_ONLN` \* 2); \
		MEM_512M=$$(awk '/MemTotal/ {M=int($$2/1024/512); print M==0?1:M}' /proc/meminfo); \
		test $$NUM_CPUS -gt $$MEM_512M && NUM_CPUS=$$MEM_512M; \
		test $$NUM_CPUS = 0 && NUM_CPUS=1; \
		sed -i "s@^CT_PARALLEL_JOBS=.*@CT_PARALLEL_JOBS=$$NUM_CPUS@" .config; \
		export NG_ARCHIVE=$(ARCHIVE); \
		export BS_BASE_DIR=$(BASE_DIR); \
		./configure --enable-local; \
		MAKELEVEL=0 make; \
		./ct-ng oldconfig; \
		./ct-ng build

crossmenuconfig: $(ARCHIVE)/crosstool-ng-$(CROSSTOOL_NG_VER).tar.xz
	make $(BUILD_TMP)
	$(REMOVE)/crosstool-ng-$(CROSSTOOL_NG_VER)
	$(UNTAR)/crosstool-ng-$(CROSSTOOL_NG_VER).tar.xz
	$(SILENT)set -e; unset CONFIG_SITE; cd $(BUILD_TMP)/crosstool-ng; \
		cp -a $(PATCHES)/crosstool-ng-$(CROSSTOOL_NG_VER).config .config; \
		test -f ./configure || ./bootstrap && \
		./configure --enable-local; MAKELEVEL=0 make; chmod 0755 ct-ng; \
		./ct-ng menuconfig

# install the RPMs
crosstool: directories driver-symlink \
$(HOST_DIR)/bin/unpack-rpm.sh \
crosstool-rpminstall
	$(START_BUILD)
	$(SILENT)set -e; cd $(CROSS_BASE); rm -f sh4-linux/sys-root; ln -s ../target sh4-linux/sys-root
	$(SILENT)if [ -e $(CROSS_DIR)/target/usr/lib/libstdc++.la ]; then \
		sed -i "s,^libdir=.*,libdir='$(CROSS_DIR)/target/usr/lib'," $(CROSS_DIR)/target/usr/lib/lib{std,sup}c++.la; \
	fi
	$(SILENT)if test -e $(CROSS_DIR)/target/usr/lib/libstdc++.so; then \
		cp -a $(CROSS_DIR)/target/usr/lib/libstdc++.s*[!y] $(TARGETPREFIX)/lib; \
		cp -a $(CROSS_DIR)/target/usr/lib/libdl.so $(TARGETPREFIX)/usr/lib; \
		cp -a $(CROSS_DIR)/target/usr/lib/libm.so $(TARGETPREFIX)/usr/lib; \
		cp -a $(CROSS_DIR)/target/usr/lib/librt.so $(TARGETPREFIX)/usr/lib; \
		cp -a $(CROSS_DIR)/target/usr/lib/libutil.so $(TARGETPREFIX)/usr/lib; \
		cp -a $(CROSS_DIR)/target/usr/lib/libpthread.so $(TARGETPREFIX)/usr/lib; \
		cp -a $(CROSS_DIR)/target/usr/lib/libresolv.so $(TARGETPREFIX)/usr/lib; \
		ln -s $(CROSS_DIR)/target/usr/lib/libc.so $(TARGETPREFIX)/usr/lib/libc.so; \
		ln -s $(CROSS_DIR)/target/usr/lib/libc_nonshared.a $(TARGETPREFIX)/usr/lib/libc_nonshared.a; \
	fi
	$(SILENT)if test -e $(CROSS_DIR)/target/lib; then \
		cp -a $(CROSS_DIR)/target/lib/*so* $(TARGETPREFIX)/lib; \
	fi
	$(SILENT)if test -e $(CROSS_DIR)/target/sbin/ldconfig; then \
		cp -a $(CROSS_DIR)/target/sbin/ldconfig $(TARGETPREFIX)/sbin; \
		cp -a $(CROSS_DIR)/target/etc/ld.so.conf $(TARGETPREFIX)/etc; \
		cp -a $(CROSS_DIR)/target/etc/host.conf $(TARGETPREFIX)/etc; \
	fi
	@touch $(D)/$(notdir $@)
	@echo -e "Build of \033[01;32m$@\033[0m completed."; echo

#
# host_u_boot_tools
#
host_u_boot_tools: \
$(ARCHIVE)/stlinux24-host-u-boot-tools-1.3.1_stm24-9.i386.rpm
	$(START_BUILD)
	$(SILENT)unpack-rpm.sh $(BUILD_TMP) $(STM_RELOCATE)/host/bin $(HOST_DIR)/bin \
		$^
	@touch $(D)/$(notdir $@)
	@echo -e "Build of \033[01;32m$@\033[0m completed."; echo

#
# directories
#
directories:
	$(START_BUILD)
	$(SILENT)test -d $(D) || mkdir $(D)
	$(SILENT)test -d $(ARCHIVE) || mkdir $(ARCHIVE)
	$(SILENT)test -d $(BUILD_TMP) || mkdir $(BUILD_TMP)
	$(SILENT)test -d $(SOURCE_DIR) || mkdir $(SOURCE_DIR)
	$(SILENT)install -d $(TARGETPREFIX)
	$(SILENT)install -d $(CROSS_DIR)
	$(SILENT)install -d $(BOOT_DIR)
	$(SILENT)install -d $(HOST_DIR)
	$(SILENT)install -d $(HOST_DIR)/{bin,lib,share}
	$(SILENT)install -d $(TARGETPREFIX)/{bin,boot,etc,lib,sbin,usr,var}
	$(SILENT)install -d $(TARGETPREFIX)/etc/{init.d,mdev,network,rc.d}
	$(SILENT)install -d $(TARGETPREFIX)/etc/rc.d/{rc0.d,rc6.d}
	$(SILENT)ln -s ../init.d $(TARGETPREFIX)/etc/rc.d/init.d
	$(SILENT)install -d $(TARGETPREFIX)/lib/{lsb,firmware}
	$(SILENT)install -d $(TARGETPREFIX)/usr/{bin,lib,local,sbin,share}
	$(SILENT)install -d $(TARGETPREFIX)/usr/lib/pkgconfig
	$(SILENT)install -d $(TARGETPREFIX)/usr/include/linux
	$(SILENT)install -d $(TARGETPREFIX)/usr/include/linux/dvb
	$(SILENT)install -d $(TARGETPREFIX)/usr/local/{bin,sbin,share}
	$(SILENT)install -d $(TARGETPREFIX)/var/{etc,lib,run}
	$(SILENT)install -d $(TARGETPREFIX)/var/lib/{misc,nfs}
	$(SILENT)install -d $(TARGETPREFIX)/var/bin
	@touch $(D)/$(notdir $@)
	@echo -e "Build of \033[01;32m$@\033[0m completed."; echo

#
# ccache
#
CCACHE_BINDIR = $(HOST_DIR)/bin
CCACHE_BIN = $(CCACHE)

CCACHE_LINKS = \
	ln -sf $(CCACHE_BIN) $(CCACHE_BINDIR)/cc; \
	ln -sf $(CCACHE_BIN) $(CCACHE_BINDIR)/gcc; \
	ln -sf $(CCACHE_BIN) $(CCACHE_BINDIR)/g++; \
	ln -sf $(CCACHE_BIN) $(CCACHE_BINDIR)/$(TARGET)-gcc; \
	ln -sf $(CCACHE_BIN) $(CCACHE_BINDIR)/$(TARGET)-g++

CCACHE_ENV = install -d $(CCACHE_BINDIR); \
	$(CCACHE_LINKS)

$(D)/ccache:
	$(START_BUILD)
	$(CCACHE_ENV)
	$(TOUCH)

# hack to make sure they are always copied
PHONY += ccache bootstrap

#
# TF7700 installer
#
TFINSTALLER_DIR := $(CDK_DIR)/tfinstaller
U_BOOT_VER = 1.3.1

$(D)/tfinstaller: 
	$(START_BUILD)
	$(MAKE) $(MAKE_OPTS) -C $(TFINSTALLER_DIR)
	$(TOUCH)

$(D)/u-boot.ftfd: $(D)/uboot_tf7700 $(D)/tfpacker
	$(START_BUILD)
	$(TFINSTALLER_DIR)/tfpacker $(BUILD_TMP)/u-boot-$(U_BOOT_VER)/u-boot.bin $(TFINSTALLER_DIR)/u-boot.ftfd
	$(TFINSTALLER_DIR)/tfpacker -t $(BUILD_TMP)/u-boot-$(U_BOOT_VER)/u-boot.bin $(TFINSTALLER_DIR)/Enigma_Installer.tfd
	$(REMOVE)/uboot_tf7700
	$(TOUCH)

$(D)/tfpacker:
	$(START_BUILD)
	$(MAKE) -C $(TFINSTALLER_DIR) tfpacker
	$(TOUCH)

$(ARCHIVE)/u-boot-$(U_BOOT_VER).tar.bz2:
	$(WGET) ftp://ftp.denx.de/pub/u-boot/u-boot-$(U_BOOT_VER).tar.bz2

$(D)/uboot_tf7700: $(ARCHIVE)/u-boot-$(U_BOOT_VER).tar.bz2
	$(START_BUILD)
	$(REMOVE)/u-boot-$(U_BOOT_VER)
	$(UNTAR)/u-boot-$(U_BOOT_VER).tar.bz2
	$(SILENT)set -e; cd $(BUILD_TMP)/u-boot-$(U_BOOT_VER); \
		for i in \
			u-boot-$(U_BOOT_VER).patch \
			u-boot-$(U_BOOT_VER)_tf7700.patch \
		; do \
			echo -e "==> \033[31mApplying Patch:\033[0m $$i"; \
			$(PATCH)/$$i; \
		done; \
		$(MAKE) tf7700_config && \
		$(MAKE)
#	$(REMOVE)/uboot_tf7700
	$(TOUCH)

