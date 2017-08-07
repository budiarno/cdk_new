#
# Makefile to build NEUTRINO-PLUGINS
#

#
# links
#
LINKS-VER = 2.7

$(ARCHIVE)/links-$(LINKS-VER).tar.bz2:
	$(WGET) http://links.twibright.com/download/links-$(LINKS-VER).tar.bz2

ifeq ($(BOXTYPE), $(filter $(BOXTYPE), spark spark7162))
BOXEVENT = $(PATCH)/links-2.7-spark-input.patch;
endif

$(D)/links: $(D)/bootstrap $(D)/libpng $(D)/openssl $(ARCHIVE)/links-$(LINKS-VER).tar.bz2
	$(START_BUILD)
	$(REMOVE)/links-$(LINKS-VER)
	$(UNTAR)/links-$(LINKS-VER).tar.bz2
	set -e; cd $(BUILD_TMP)/links-$(LINKS-VER); \
		$(PATCH)/links-$(LINKS-VER).patch; \
		$(BOXEVENT) \
		$(CONFIGURE) \
			--host=$(TARGET) \
			--build=$(BUILD) \
			--prefix= \
			--mandir=/.remove \
			--without-svgalib \
			--without-x \
			--without-libtiff \
			--enable-graphics \
			--enable-javascript \
			--with-ssl; \
		$(MAKE); \
		$(MAKE) install DESTDIR=$(TARGET_DIR)
	mkdir -p $(TARGET_DIR)/var/tuxbox/plugins $(TARGET_DIR)/var/tuxbox/config/links
	mv $(TARGET_DIR)/bin/links $(TARGET_DIR)/var/tuxbox/plugins/links.so
	echo "name=Links Web Browser"	 > $(TARGET_DIR)/var/tuxbox/plugins/links.cfg
	echo "desc=Web Browser"		>> $(TARGET_DIR)/var/tuxbox/plugins/links.cfg
	echo "type=2"			>> $(TARGET_DIR)/var/tuxbox/plugins/links.cfg
	echo "needfb=1"			>> $(TARGET_DIR)/var/tuxbox/plugins/links.cfg
	echo "needrc=1"			>> $(TARGET_DIR)/var/tuxbox/plugins/links.cfg
	echo "needoffsets=1"		>> $(TARGET_DIR)/var/tuxbox/plugins/links.cfg
	echo "bookmarkcount=0"		 > $(TARGET_DIR)/var/tuxbox/config/bookmarks
	touch $(TARGET_DIR)/var/tuxbox/config/links/links.his
	cp -a $(SKEL_ROOT)/var/tuxbox/config/links/bookmarks.html $(SKEL_ROOT)/var/tuxbox/config/links/tables.tar.gz $(TARGET_DIR)/var/tuxbox/config/links
	$(REMOVE)/links-$(LINKS-VER)
	$(TOUCH)

#
# neutrino-mp plugins
#
$(D)/neutrino-mp-plugins.do_prepare:
	rm -rf $(SOURCE_DIR)/neutrino-mp-plugins
	set -e; if [ -d $(ARCHIVE)/neutrino-mp-plugins.git ]; \
		then cd $(ARCHIVE)/neutrino-mp-plugins.git; git pull; \
		else cd $(ARCHIVE); git clone https://github.com/Duckbox-Developers/neutrino-mp-plugins.git; \
		fi
	cp -ra $(ARCHIVE)/neutrino-mp-plugins.git $(SOURCE_DIR)/neutrino-mp-plugins
	touch $@

$(SOURCE_DIR)/neutrino-mp-plugins/config.status: $(D)/bootstrap $(D)/xupnpd
	cd $(SOURCE_DIR)/neutrino-mp-plugins; \
		./autogen.sh && automake --add-missing; \
		$(BUILDENV) \
		./configure --enable-silent-rules \
			--host=$(TARGET) \
			--build=$(BUILD) \
			--prefix= \
			--with-target=cdk \
			--oldinclude=$(TARGET_DIR)/include \
			--enable-maintainer-mode \
			--with-boxtype=$(BOXTYPE) \
			--with-plugindir=/var/tuxbox/plugins \
			--with-libdir=/usr/lib \
			--with-datadir=/usr/share/tuxbox \
			--with-fontdir=/usr/share/fonts \
			PKG_CONFIG=$(PKG_CONFIG) \
			PKG_CONFIG_PATH=$(PKG_CONFIG_PATH) \
			CPPFLAGS="$(N_CPPFLAGS) -DMARTII -DNEW_LIBCURL" \
			LDFLAGS="$(TARGET_LDFLAGS) -L$(SOURCE_DIR)/neutrino-mp-plugins/fx2/lib/.libs"

$(D)/neutrino-mp-plugins.do_compile: $(SOURCE_DIR)/neutrino-mp-plugins/config.status
	cd $(SOURCE_DIR)/neutrino-mp-plugins; \
		$(MAKE)
	touch $@

$(D)/neutrino-mp-plugins: neutrino-mp-plugins.do_prepare neutrino-mp-plugins.do_compile
	$(START_BUILD)
	$(MAKE) -C $(SOURCE_DIR)/neutrino-mp-plugins install DESTDIR=$(TARGET_DIR)
	$(TOUCH)

neutrino-mp-plugins-clean:
	rm -f $(D)/neutrino-mp-plugins
	cd $(SOURCE_DIR)/neutrino-mp-plugins; \
		$(MAKE) clean

neutrino-mp-plugins-distclean:
	rm -f $(D)/neutrino-mp-plugins.do_prepare
	rm -f $(D)/neutrino-mp-plugins.do_compile

#
# xupnpd
#
$(D)/xupnpd: $(D)/bootstrap $(D)/plugins-scripts-lua
	$(START_BUILD)
	$(REMOVE)/xupnpd
	set -e; if [ -d $(ARCHIVE)/xupnpd.git ]; \
		then cd $(ARCHIVE)/xupnpd.git; git pull; \
		else cd $(ARCHIVE); git clone git://github.com/clark15b/xupnpd.git xupnpd.git; \
		fi
	cp -ra $(ARCHIVE)/xupnpd.git $(BUILD_TMP)/xupnpd
	set -e; cd $(BUILD_TMP)/xupnpd && $(PATCH)/xupnpd.patch
	set -e; cd $(BUILD_TMP)/xupnpd/src; \
		$(BUILDENV) \
		$(MAKE) TARGET=$(TARGET) sh4; \
		$(MAKE) install DESTDIR=$(TARGET_DIR)
	install -m 755 $(SKEL_ROOT)/etc/init.d/xupnpd $(TARGET_DIR)/etc/init.d/
	install -m 644 $(ARCHIVE)/cst-public-plugins-scripts-lua.git/xupnpd/xupnpd_18plus.lua ${TARGET_DIR}/usr/share/xupnpd/plugins/
	install -m 644 $(ARCHIVE)/cst-public-plugins-scripts-lua.git/xupnpd/xupnpd_cczwei.lua ${TARGET_DIR}/usr/share/xupnpd/plugins/
	: install -m 644 $(ARCHIVE)/cst-public-plugins-scripts-lua.git/xupnpd/xupnpd_coolstream.lua ${TARGET_DIR}/usr/share/xupnpd/plugins/
	install -m 644 $(ARCHIVE)/cst-public-plugins-scripts-lua.git/xupnpd/xupnpd_youtube.lua ${TARGET_DIR}/usr/share/xupnpd/plugins/
	$(REMOVE)/xupnpd
	$(TOUCH)

#
# plugins-scripts-lua
#
$(D)/plugins-scripts-lua: $(D)/bootstrap $(D)/xupnpd
	$(START_BUILD)
	$(REMOVE)/plugins-scripts-lua
	set -e; if [ -d $(ARCHIVE)/cst-public-plugins-scripts-lua.git ]; \
		then cd $(ARCHIVE)/cst-public-plugins-scripts-lua.git; git pull; \
		else cd $(ARCHIVE); git clone https://github.com/coolstreamtech/cst-public-plugins-scripts-lua.git cst-public-plugins-scripts-lua.git; \
		fi
	cp -ra $(ARCHIVE)/cst-public-plugins-scripts-lua.git/plugins $(BUILD_TMP)/plugins-scripts-lua
	set -e; cd $(BUILD_TMP)/plugins-scripts-lua; \
		install -d $(TARGET_DIR)/var/tuxbox/plugins
		cp -R $(BUILD_TMP)/plugins-scripts-lua/ard_mediathek/* $(TARGET_DIR)/var/tuxbox/plugins/
		cp -R $(BUILD_TMP)/plugins-scripts-lua/favorites2bin/* $(TARGET_DIR)/var/tuxbox/plugins/
		cp -R $(BUILD_TMP)/plugins-scripts-lua/mtv/* $(TARGET_DIR)/var/tuxbox/plugins/
		cp -R $(BUILD_TMP)/plugins-scripts-lua/netzkino/* $(TARGET_DIR)/var/tuxbox/plugins/
	$(REMOVE)/plugins-scripts-lua
	$(TOUCH)

#
# neutrino-hd2 plugins
#
NEUTRINO_HD2_PLUGINS_PATCHES =

$(D)/neutrino-hd2-plugins.do_prepare:
	rm -rf $(SOURCE_DIR)/neutrino-hd2-plugins
	ln -s $(SOURCE_DIR)/neutrino-hd2.git/plugins $(SOURCE_DIR)/neutrino-hd2-plugins
	cd $(SOURCE_DIR)/neutrino-hd2-plugins && find ./ -name "Makefile.am" -exec sed -i -e "s/\/..\/nhd2-exp//g" {} \;
	cd $(SOURCE_DIR)/neutrino-hd2.git && git add --all
	for i in $(NEUTRINO_HD2_PLUGINS_PATCHES); do \
		echo "==> Applying Patch: $(subst $(PATCHES)/,'',$$i)"; \
		set -e; cd $(SOURCE_DIR)/neutrino-hd2-plugins && patch -p1 -i $$i; \
	done;
	touch $@

$(SOURCE_DIR)/neutrino-hd2-plugins/config.status: $(D)/bootstrap neutrino-hd2
	cd $(SOURCE_DIR)/neutrino-hd2-plugins; \
		./autogen.sh; \
		$(BUILDENV) \
		./configure \
			--host=$(TARGET) \
			--build=$(BUILD) \
			--prefix= \
			--with-target=cdk \
			--with-boxtype=$(BOXTYPE) \
			--with-plugindir=/var/tuxbox/plugins \
			--with-datadir=/usr/share/tuxbox \
			--with-fontdir=/usr/share/fonts \
			PKG_CONFIG=$(PKG_CONFIG) \
			PKG_CONFIG_PATH=$(PKG_CONFIG_PATH) \
			CPPFLAGS="$(CPPFLAGS) -I$(driverdir) -I$(KERNEL_DIR)/include -I$(TARGET_DIR)/include" \
			LDFLAGS="$(TARGET_LDFLAGS)"

$(D)/neutrino-hd2-plugins.do_compile: $(SOURCE_DIR)/neutrino-hd2-plugins/config.status
	cd $(SOURCE_DIR)/neutrino-hd2-plugins; \
	$(MAKE) top_srcdir=$(SOURCE_DIR)/neutrino-hd2
	touch $@

$(D)/neutrino-hd2-plugins: neutrino-hd2-plugins.do_prepare neutrino-hd2-plugins.do_compile
	$(START_BUILD)
	$(MAKE) -C $(SOURCE_DIR)/neutrino-hd2-plugins install DESTDIR=$(TARGET_DIR) top_srcdir=$(SOURCE_DIR)/neutrino-hd2
	$(TOUCH)

neutrino-hd2-plugins-clean:
	rm -f $(D)/neutrino-hd2-plugins
	cd $(SOURCE_DIR)/neutrino-hd2-plugins; \
	$(MAKE) clean
	rm -f $(SOURCE_DIR)/neutrino-hd2-plugins/config.status

neutrino-hd2-plugins-distclean: neutrino-hd2-plugins-clean
	rm -f $(D)/neutrino-hd2-plugins.do_prepare
	rm -f $(D)/neutrino-hd2-plugins.do_compile

