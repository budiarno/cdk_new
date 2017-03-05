#
# auxiliary targets for model-specific builds
#

#
# release_cube_common
#
release_enigma2_cube_common:
	install -m 0755 $(SKEL_ROOT)/release/halt_cuberevo $(RELEASE_DIR)/etc/init.d/halt
	install -m 0777 $(SKEL_ROOT)/release/reboot_cuberevo $(RELEASE_DIR)/etc/init.d/reboot
	cp $(TARGETPREFIX)/lib/modules/$(KERNEL_VERSION)/extra/stgfb/stmfb/stmcore-display-stx7109c3.ko $(RELEASE_DIR)/lib/modules/
	cp $(TARGETPREFIX)/lib/modules/$(KERNEL_VERSION)/extra/frontcontroller/ipbox/micom.ko $(RELEASE_DIR)/lib/modules/
	cp $(SKEL_ROOT)/boot/video_7109.elf $(RELEASE_DIR)/boot/video.elf
	cp $(SKEL_ROOT)/boot/audio_7100.elf $(RELEASE_DIR)/boot/audio.elf
	cp $(TARGETPREFIX)/bin/eeprom $(RELEASE_DIR)/bin
	cp $(SKEL_ROOT)/firmware/dvb-fe-cx24116.fw $(RELEASE_DIR)/lib/firmware/
	cp $(SKEL_ROOT)/firmware/dvb-fe-stv6306.fw $(RELEASE_DIR)/lib/firmware/

#
# release_cube_common_tuner
#
release_enigma2_cube_common_tuner:
	cp $(TARGETPREFIX)/lib/modules/$(KERNEL_VERSION)/extra/frontends/multituner/*.ko $(RELEASE_DIR)/lib/modules/
	cp $(TARGETPREFIX)/lib/modules/$(KERNEL_VERSION)/kernel/drivers/media/dvb/frontends/dvb-pll.ko $(RELEASE_DIR)/lib/modules/

#
# release_cuberevo_9500hd
#
release_enigma2_cuberevo_9500hd: release_enigma2_cube_common release_enigma2_cube_common_tuner
	echo "cuberevo-9500hd" > $(RELEASE_DIR)/etc/hostname

#
# release_cuberevo_2000hd
#
release_enigma2_cuberevo_2000hd: release_enigma2_cube_common release_enigma2_cube_common_tuner
	echo "cuberevo-2000hd" > $(RELEASE_DIR)/etc/hostname

#
# release_cuberevo_250hd
#
release_enigma2_cuberevo_250hd: release_enigma2_cube_common release_enigma2_cube_common_tuner
	echo "cuberevo-250hd" > $(RELEASE_DIR)/etc/hostname

#
# release_cuberevo_mini_fta
#
release_enigma2_cuberevo_mini_fta: release_enigma2_cube_common release_enigma2_cube_common_tuner
	echo "cuberevo-mini-fta" > $(RELEASE_DIR)/etc/hostname

#
# release_cuberevo_mini2
#
release_enigma2_cuberevo_mini2: release_enigma2_cube_common release_enigma2_cube_common_tuner
	echo "cuberevo-mini2" > $(RELEASE_DIR)/etc/hostname

#
# release_cuberevo_mini
#
release_enigma2_cuberevo_mini: release_enigma2_cube_common release_enigma2_cube_common_tuner
	echo "cuberevo-mini" > $(RELEASE_DIR)/etc/hostname

#
# release_cuberevo
#
release_enigma2_cuberevo: release_enigma2_cube_common release_enigma2_cube_common_tuner
	echo "cuberevo" > $(RELEASE_DIR)/etc/hostname

#
# release_cuberevo_3000hd
#
release_enigma2_cuberevo_3000hd: release_enigma2_cube_common release_enigma2_cube_common_tuner
	echo "cuberevo-3000hd" > $(RELEASE_DIR)/etc/hostname

#
# release_common_ipbox
#
release_enigma2_common_ipbox:
	install -m 0755 $(SKEL_ROOT)/release/halt_ipbox $(RELEASE_DIR)/etc/init.d/halt
	cp $(TARGETPREFIX)/lib/modules/$(KERNEL_VERSION)/extra/frontends/*.ko $(RELEASE_DIR)/lib/modules/
	cp $(TARGETPREFIX)/lib/modules/$(KERNEL_VERSION)/extra/stgfb/stmfb/stmcore-display-stx7109c3.ko $(RELEASE_DIR)/lib/modules/
	cp $(TARGETPREFIX)/lib/modules/$(KERNEL_VERSION)/extra/siinfo/siinfo.ko $(RELEASE_DIR)/lib/modules/
	cp -f $(SKEL_ROOT)/release/fstab_ipbox $(RELEASE_DIR)/etc/fstab
	cp $(SKEL_ROOT)/boot/video_7109.elf $(RELEASE_DIR)/boot/video.elf
	cp $(SKEL_ROOT)/boot/audio_7100.elf $(RELEASE_DIR)/boot/audio.elf
	cp -dp $(SKEL_ROOT)/release/lircd_ipbox.conf $(RELEASE_DIR)/etc/lircd.conf
	cp -p $(TARGETPREFIX)/usr/sbin/lircd $(RELEASE_DIR)/usr/bin/
	mkdir -p $(RELEASE_DIR)/var/run/lirc
	rm -f $(RELEASE_DIR)/lib/firmware/*
	rm -f $(RELEASE_DIR)/lib/modules/boxtype.ko
	rm -f $(RELEASE_DIR)/lib/modules/lzo*.ko
	rm -f $(RELEASE_DIR)/lib/modules/ramzswap.ko
	rm -f $(RELEASE_DIR)/lib/modules/stmvbi.ko
	rm -f $(RELEASE_DIR)/lib/modules/stmvout.ko
	rm -f $(RELEASE_DIR)/etc/network/interfaces
	echo "config.usage.hdd_standby=0" >> $(RELEASE_DIR)/etc/enigma2/settings

#
# release_ipbox9900
#
release_enigma2_ipbox9900: release_enigma2_common_ipbox
	echo "ipbox9900" > $(RELEASE_DIR)/etc/hostname
	cp $(TARGETPREFIX)/lib/modules/$(KERNEL_VERSION)/extra/frontcontroller/ipbox99xx/micom.ko $(RELEASE_DIR)/lib/modules/
	cp $(TARGETPREFIX)/lib/modules/$(KERNEL_VERSION)/extra/rmu/rmu.ko $(RELEASE_DIR)/lib/modules/
	cp $(TARGETPREFIX)/lib/modules/$(KERNEL_VERSION)/extra/ipbox99xx_fan/ipbox_fan.ko $(RELEASE_DIR)/lib/modules/
	cp -f $(SKEL_ROOT)/root_enigma2/usr/local/share/enigma2/keymap_ipbox.xml $(RELEASE_DIR)/usr/local/share/enigma2/keymap.xml
	cp -p $(SKEL_ROOT)/release/tvmode_ipbox $(RELEASE_DIR)/usr/bin/tvmode

#
# release_ipbox99
#
release_enigma2_ipbox99: release_enigma2_common_ipbox
	echo "ipbox99" > $(RELEASE_DIR)/etc/hostname
	cp $(TARGETPREFIX)/lib/modules/$(KERNEL_VERSION)/extra/frontcontroller/ipbox99xx/micom.ko $(RELEASE_DIR)/lib/modules/
	cp $(TARGETPREFIX)/lib/modules/$(KERNEL_VERSION)/extra/ipbox99xx_fan/ipbox_fan.ko $(RELEASE_DIR)/lib/modules/
	cp -f $(SKEL_ROOT)/root_enigma2/usr/local/share/enigma2/keymap_ipbox.xml $(RELEASE_DIR)/usr/local/share/enigma2/keymap.xml
	cp -p $(SKEL_ROOT)/release/tvmode_ipbox $(RELEASE_DIR)/usr/bin/tvmode

#
# release_ipbox55
#
release_enigma2_ipbox55: release_enigma2_common_ipbox
	echo "ipbox55" > $(RELEASE_DIR)/etc/hostname
	cp $(TARGETPREFIX)/lib/modules/$(KERNEL_VERSION)/extra/frontcontroller/ipbox55/front.ko $(RELEASE_DIR)/lib/modules/
	cp -f $(SKEL_ROOT)/root_enigma2/usr/local/share/enigma2/keymap_ipbox.xml $(RELEASE_DIR)/usr/local/share/enigma2/keymap.xml
	cp -p $(SKEL_ROOT)/release/tvmode_ipbox55 $(RELEASE_DIR)/usr/bin/tvmode

#
# release_ufs910
#
release_enigma2_ufs910:
	echo "ufs910" > $(RELEASE_DIR)/etc/hostname
	install -m 0755 $(SKEL_ROOT)/release/halt_ufs $(RELEASE_DIR)/etc/init.d/halt
	cp $(TARGETPREFIX)/lib/modules/$(KERNEL_VERSION)/extra/frontcontroller/vfd/vfd.ko $(RELEASE_DIR)/lib/modules/
	cp $(TARGETPREFIX)/lib/modules/$(KERNEL_VERSION)/extra/frontends/*.ko $(RELEASE_DIR)/lib/modules/
	cp $(TARGETPREFIX)/lib/modules/$(KERNEL_VERSION)/extra/stgfb/stmfb/stmcore-display-stx7100.ko $(RELEASE_DIR)/lib/modules/
	cp $(SKEL_ROOT)/boot/video_7100.elf $(RELEASE_DIR)/boot/video.elf
	cp $(SKEL_ROOT)/boot/audio_7100.elf $(RELEASE_DIR)/boot/audio.elf
	cp $(SKEL_ROOT)/firmware/dvb-fe-cx21143.fw $(RELEASE_DIR)/lib/firmware/dvb-fe-cx24116.fw
	cp -dp $(SKEL_ROOT)/release/lircd_ufs910.conf $(RELEASE_DIR)/etc/lircd.conf
	cp -p $(TARGETPREFIX)/usr/sbin/lircd $(RELEASE_DIR)/usr/bin/
	mkdir -p $(RELEASE_DIR)/var/run/lirc
	rm -f $(RELEASE_DIR)/bin/vdstandby
	cp -f $(SKEL_ROOT)/root_enigma2/usr/local/share/enigma2/keymap_ufs910.xml $(RELEASE_DIR)/usr/local/share/enigma2/keymap.xml

#
# release_ufs912
#
release_enigma2_ufs912:
	echo "ufs912" > $(RELEASE_DIR)/etc/hostname
	install -m 0755 $(SKEL_ROOT)/release/halt_ufs912 $(RELEASE_DIR)/etc/init.d/halt
	cp $(TARGETPREFIX)/lib/modules/$(KERNEL_VERSION)/extra/frontcontroller/micom/micom.ko $(RELEASE_DIR)/lib/modules/
	cp $(TARGETPREFIX)/lib/modules/$(KERNEL_VERSION)/extra/frontends/*.ko $(RELEASE_DIR)/lib/modules/
	cp $(TARGETPREFIX)/lib/modules/$(KERNEL_VERSION)/extra/stgfb/stmfb/stmcore-display-sti7111.ko $(RELEASE_DIR)/lib/modules/
	cp $(SKEL_ROOT)/boot/video_7111.elf $(RELEASE_DIR)/boot/video.elf
	cp $(SKEL_ROOT)/boot/audio_7111.elf $(RELEASE_DIR)/boot/audio.elf
	cp $(SKEL_ROOT)/firmware/component_7111_mb618.fw $(RELEASE_DIR)/lib/firmware/component.fw
	cp -f $(SKEL_ROOT)/root_enigma2/usr/local/share/enigma2/keymap_ufs912.xml $(RELEASE_DIR)/usr/local/share/enigma2/keymap.xml

#
# release_ufs913
#
release_enigma2_ufs913:
	echo "ufs913" > $(RELEASE_DIR)/etc/hostname
	install -m 0755 $(SKEL_ROOT)/release/halt_ufs912 $(RELEASE_DIR)/etc/init.d/halt
	cp $(TARGETPREFIX)/lib/modules/$(KERNEL_VERSION)/extra/frontcontroller/micom/micom.ko $(RELEASE_DIR)/lib/modules/
	cp $(TARGETPREFIX)/lib/modules/$(KERNEL_VERSION)/extra/frontends/multituner/*.ko $(RELEASE_DIR)/lib/modules/
	cp $(TARGETPREFIX)/lib/modules/$(KERNEL_VERSION)/extra/stgfb/stmfb/stmcore-display-sti7105.ko $(RELEASE_DIR)/lib/modules/
	cp $(SKEL_ROOT)/boot/video_7105.elf $(RELEASE_DIR)/boot/video.elf
	cp $(SKEL_ROOT)/boot/audio_7105.elf $(RELEASE_DIR)/boot/audio.elf
	cp $(SKEL_ROOT)/firmware/component_7105_pdk7105.fw $(RELEASE_DIR)/lib/firmware/component.fw
	cp $(SKEL_ROOT)/firmware/dvb-fe-avl6222.fw $(RELEASE_DIR)/lib/firmware/
	cp -f $(SKEL_ROOT)/root_enigma2/usr/local/share/enigma2/keymap_ufs912.xml $(RELEASE_DIR)/usr/local/share/enigma2/keymap.xml

#
# release_ufs922
#
release_enigma2_ufs922:
	echo "ufs922" > $(RELEASE_DIR)/etc/hostname
	install -m 0755 $(SKEL_ROOT)/release/halt_ufs $(RELEASE_DIR)/etc/init.d/halt
	cp $(TARGETPREFIX)/lib/modules/$(KERNEL_VERSION)/extra/frontcontroller/micom/micom.ko $(RELEASE_DIR)/lib/modules/
	cp $(TARGETPREFIX)/lib/modules/$(KERNEL_VERSION)/extra/frontends/*.ko $(RELEASE_DIR)/lib/modules/
	cp $(TARGETPREFIX)/lib/modules/$(KERNEL_VERSION)/extra/stgfb/stmfb/stmcore-display-stx7109c3.ko $(RELEASE_DIR)/lib/modules/
	cp $(TARGETPREFIX)/lib/modules/$(KERNEL_VERSION)/extra/ufs922_fan/fan_ctrl.ko $(RELEASE_DIR)/lib/modules/
	cp $(SKEL_ROOT)/boot/video_7109.elf $(RELEASE_DIR)/boot/video.elf
	cp $(SKEL_ROOT)/boot/audio_7100.elf $(RELEASE_DIR)/boot/audio.elf
	cp $(SKEL_ROOT)/firmware/dvb-fe-avl2108.fw $(RELEASE_DIR)/lib/firmware/
	cp $(SKEL_ROOT)/firmware/dvb-fe-avl6222.fw $(RELEASE_DIR)/lib/firmware/
	cp $(SKEL_ROOT)/firmware/dvb-fe-cx21143.fw $(RELEASE_DIR)/lib/firmware/
	cp $(SKEL_ROOT)/firmware/dvb-fe-stv6306.fw $(RELEASE_DIR)/lib/firmware/
	cp -f $(SKEL_ROOT)/root_enigma2/usr/local/share/enigma2/keymap_ufs910.xml $(RELEASE_DIR)/usr/local/share/enigma2/keymap.xml

#
# release_ufc960
#
release_enigma2_ufc960:
	echo "ufc960" > $(RELEASE_DIR)/etc/hostname
	install -m 0755 $(SKEL_ROOT)/release/halt_ufs $(RELEASE_DIR)/etc/init.d/halt
	cp $(TARGETPREFIX)/lib/modules/$(KERNEL_VERSION)/extra/frontcontroller/micom/micom.ko $(RELEASE_DIR)/lib/modules/
	cp $(TARGETPREFIX)/lib/modules/$(KERNEL_VERSION)/extra/frontends/*.ko $(RELEASE_DIR)/lib/modules/
	cp $(TARGETPREFIX)/lib/modules/$(KERNEL_VERSION)/extra/stgfb/stmfb/stmcore-display-stx7109c3.ko $(RELEASE_DIR)/lib/modules/
	cp $(SKEL_ROOT)/boot/video_7109.elf $(RELEASE_DIR)/boot/video.elf
	cp $(SKEL_ROOT)/boot/audio_7100.elf $(RELEASE_DIR)/boot/audio.elf
	cp $(SKEL_ROOT)/firmware/dvb-fe-cx21143.fw $(RELEASE_DIR)/lib/firmware/
	cp $(SKEL_ROOT)/firmware/dvb-fe-stv6306.fw $(RELEASE_DIR)/lib/firmware/
	cp -f $(SKEL_ROOT)/root_enigma2/usr/local/share/enigma2/keymap_ufs910.xml $(RELEASE_DIR)/usr/local/share/enigma2/keymap.xml

#
# release_spark
#
release_enigma2_spark:
	echo "spark" > $(RELEASE_DIR)/etc/hostname
	install -m 0755 $(SKEL_ROOT)/release/halt_spark $(RELEASE_DIR)/etc/init.d/halt
	cp $(TARGETPREFIX)/lib/modules/$(KERNEL_VERSION)/extra/frontcontroller/aotom_spark/aotom.ko $(RELEASE_DIR)/lib/modules/
	cp $(TARGETPREFIX)/lib/modules/$(KERNEL_VERSION)/extra/frontends/lnb/lnb.ko $(RELEASE_DIR)/lib/modules/
	cp $(TARGETPREFIX)/lib/modules/$(KERNEL_VERSION)/extra/frontends/*.ko $(RELEASE_DIR)/lib/modules/
	cp $(TARGETPREFIX)/lib/modules/$(KERNEL_VERSION)/extra/stgfb/stmfb/stmcore-display-sti7111.ko $(RELEASE_DIR)/lib/modules/
	cp $(SKEL_ROOT)/boot/video_7111.elf $(RELEASE_DIR)/boot/video.elf
	cp $(SKEL_ROOT)/boot/audio_7111.elf $(RELEASE_DIR)/boot/audio.elf
	cp $(SKEL_ROOT)/firmware/component_7111_mb618.fw $(RELEASE_DIR)/lib/firmware/component.fw
	rm -f $(RELEASE_DIR)/bin/vdstandby
	cp -dp $(SKEL_ROOT)/release/lircd_spark.conf $(RELEASE_DIR)/etc/lircd.conf
	cp -p $(TARGETPREFIX)/usr/sbin/lircd $(RELEASE_DIR)/usr/bin/
	mkdir -p $(RELEASE_DIR)/var/run/lirc
	cp -f $(SKEL_ROOT)/release/rc_spark.png $(RELEASE_DIR)/usr/local/share/enigma2/skin_default/rc.png
	if [ -e $(TARGETPREFIX)/usr/lib/enigma2/python/Plugins/Extensions/sparkVFD/plugin.py ]; then \
		rm -f $(RELEASE_DIR)/usr/lib/enigma2/python/Plugins/SystemPlugins/VFD-Icons/*; \
		cp -f $(SKEL_ROOT)/release/leddisplay.png $(TARGETPREFIX)/usr/lib/enigma2/python/Plugins/Extensions/sparkVFD; \
		cp -rf $(TARGETPREFIX)/usr/lib/enigma2/python/Plugins/Extensions/sparkVFD/* $(RELEASE_DIR)/usr/lib/enigma2/python/Plugins/SystemPlugins/VFD-Icons; \
		rm -rf $(RELEASE_DIR)/usr/lib/enigma2/python/Plugins/Extensions/sparkVFD; \
	fi
	cp -f $(SKEL_ROOT)/root_enigma2/usr/local/share/enigma2/keymap_spark.xml $(RELEASE_DIR)/usr/local/share/enigma2/keymap.xml

#
# release_spark7162
#
release_enigma2_spark7162:
	echo "spark7162" > $(RELEASE_DIR)/etc/hostname
	install -m 0755 $(SKEL_ROOT)/release/halt_spark7162 $(RELEASE_DIR)/etc/init.d/halt
	cp $(TARGETPREFIX)/lib/modules/$(KERNEL_VERSION)/extra/frontcontroller/aotom_spark/aotom.ko $(RELEASE_DIR)/lib/modules/
	cp $(TARGETPREFIX)/lib/modules/$(KERNEL_VERSION)/extra/stgfb/stmfb/stmcore-display-sti7105.ko $(RELEASE_DIR)/lib/modules/
	cp $(TARGETPREFIX)/lib/modules/$(KERNEL_VERSION)/extra/frontends/*.ko $(RELEASE_DIR)/lib/modules/
	cp -f $(TARGETPREFIX)/lib/modules/$(KERNEL_VERSION)/extra/i2c_spi/i2s.ko $(RELEASE_DIR)/lib/modules/
	cp -f $(SKEL_ROOT)/release/fstab_spark7162 $(RELEASE_DIR)/etc/fstab
	cp $(SKEL_ROOT)/boot/video_7105.elf $(RELEASE_DIR)/boot/video.elf
	cp $(SKEL_ROOT)/boot/audio_7105.elf $(RELEASE_DIR)/boot/audio.elf
	cp $(SKEL_ROOT)/firmware/component_7105_pdk7105.fw $(RELEASE_DIR)/lib/firmware/component.fw
	rm -f $(RELEASE_DIR)/bin/vdstandby
	cp -dp $(SKEL_ROOT)/release/lircd_spark7162.conf $(RELEASE_DIR)/etc/lircd.conf
	cp -p $(TARGETPREFIX)/usr/sbin/lircd $(RELEASE_DIR)/usr/bin/
	mkdir -p $(RELEASE_DIR)/var/run/lirc
	cp -f $(SKEL_ROOT)/release/rc_spark.png $(RELEASE_DIR)/usr/local/share/enigma2/skin_default/rc.png
	if [ -e $(TARGETPREFIX)/usr/lib/enigma2/python/Plugins/Extensions/sparkVFD/plugin.py ]; then \
		rm -f $(RELEASE_DIR)/usr/lib/enigma2/python/Plugins/SystemPlugins/VFD-Icons/*; \
		cp -f $(SKEL_ROOT)/release/vfddisplay.png $(TARGETPREFIX)/usr/lib/enigma2/python/Plugins/Extensions/sparkVFD; \
		cp -rf $(TARGETPREFIX)/usr/lib/enigma2/python/Plugins/Extensions/sparkVFD/* $(RELEASE_DIR)/usr/lib/enigma2/python/Plugins/SystemPlugins/VFD-Icons; \
		rm -rf $(RELEASE_DIR)/usr/lib/enigma2/python/Plugins/Extensions/sparkVFD; \
	fi
	cp -f $(SKEL_ROOT)/root_enigma2/usr/local/share/enigma2/keymap_spark.xml $(RELEASE_DIR)/usr/local/share/enigma2/keymap.xml

#
# release_fortis_hdbox
#
release_enigma2_fortis_hdbox:
	echo "fortis" > $(RELEASE_DIR)/etc/hostname
	install -m 0755 $(SKEL_ROOT)/release/halt_fortis_hdbox $(RELEASE_DIR)/etc/init.d/halt
	cp $(TARGETPREFIX)/lib/modules/$(KERNEL_VERSION)/extra/frontcontroller/nuvoton/nuvoton.ko $(RELEASE_DIR)/lib/modules/
	cp $(TARGETPREFIX)/lib/modules/$(KERNEL_VERSION)/extra/frontends/*.ko $(RELEASE_DIR)/lib/modules/
	cp $(TARGETPREFIX)/lib/modules/$(KERNEL_VERSION)/extra/stgfb/stmfb/stmcore-display-stx7109c3.ko $(RELEASE_DIR)/lib/modules/
	cp $(SKEL_ROOT)/boot/video_7109.elf $(RELEASE_DIR)/boot/video.elf
	cp $(SKEL_ROOT)/boot/audio_7100.elf $(RELEASE_DIR)/boot/audio.elf
	cp -f $(SKEL_ROOT)/release/rc_fs9000.png $(RELEASE_DIR)/usr/local/share/enigma2/skin_default/rc.png
	if [ -e $(TARGETPREFIX)/usr/lib/enigma2/python/Plugins/Extensions/fs9000VFD/plugin.py ]; then \
		rm -f $(RELEASE_DIR)/usr/lib/enigma2/python/Plugins/SystemPlugins/VFD-Icons/*; \
		cp -f $(SKEL_ROOT)/release/vfddisplay.png $(TARGETPREFIX)/usr/lib/enigma2/python/Plugins/Extensions/fs9000VFD; \
		cp -rf $(TARGETPREFIX)/usr/lib/enigma2/python/Plugins/Extensions/fs9000VFD/* $(RELEASE_DIR)/usr/lib/enigma2/python/Plugins/SystemPlugins/VFD-Icons; \
		rm -rf $(RELEASE_DIR)/usr/lib/enigma2/python/Plugins/Extensions/fs9000VFD; \
	fi
	cp -f $(SKEL_ROOT)/root_enigma2/usr/local/share/enigma2/keymap_fortis.xml $(RELEASE_DIR)/usr/local/share/enigma2/keymap.xml

#
# release_atevio7500
#
release_enigma2_atevio7500:
	echo "atevio7500" > $(RELEASE_DIR)/etc/hostname
	install -m 0755 $(SKEL_ROOT)/release/halt_fortis_hdbox $(RELEASE_DIR)/etc/init.d/halt
	cp $(TARGETPREFIX)/lib/modules/$(KERNEL_VERSION)/extra/frontcontroller/nuvoton/nuvoton.ko $(RELEASE_DIR)/lib/modules/
	cp $(TARGETPREFIX)/lib/modules/$(KERNEL_VERSION)/extra/frontends/multituner/*.ko $(RELEASE_DIR)/lib/modules/
	cp $(TARGETPREFIX)/lib/modules/$(KERNEL_VERSION)/extra/stgfb/stmfb/stmcore-display-sti7105.ko $(RELEASE_DIR)/lib/modules/
	cp $(SKEL_ROOT)/boot/video_7105.elf $(RELEASE_DIR)/boot/video.elf
	cp $(SKEL_ROOT)/boot/audio_7105.elf $(RELEASE_DIR)/boot/audio.elf
	cp $(SKEL_ROOT)/firmware/component_7105_pdk7105.fw $(RELEASE_DIR)/lib/firmware/component.fw
	cp $(SKEL_ROOT)/firmware/dvb-fe-avl2108.fw $(RELEASE_DIR)/lib/firmware/
	cp $(SKEL_ROOT)/firmware/dvb-fe-stv6306.fw $(RELEASE_DIR)/lib/firmware/
	rm -f $(RELEASE_DIR)/lib/modules/boxtype.ko
	rm -f $(RELEASE_DIR)/lib/modules/mpeg2hw.ko
	cp -f $(SKEL_ROOT)/release/rc_fs9000.png $(RELEASE_DIR)/usr/local/share/enigma2/skin_default/rc.png
	if [ -e $(TARGETPREFIX)/usr/lib/enigma2/python/Plugins/Extensions/hs8200VFD/plugin.py ]; then \
		rm -f $(RELEASE_DIR)/usr/lib/enigma2/python/Plugins/SystemPlugins/VFD-Icons/*; \
		cp -f $(SKEL_ROOT)/release/vfddisplay.png $(TARGETPREFIX)/usr/lib/enigma2/python/Plugins/Extensions/hs8200VFD; \
		cp -rf $(TARGETPREFIX)/usr/lib/enigma2/python/Plugins/Extensions/hs8200VFD/* $(RELEASE_DIR)/usr/lib/enigma2/python/Plugins/SystemPlugins/VFD-Icons; \
		rm -rf $(RELEASE_DIR)/usr/lib/enigma2/python/Plugins/Extensions/hs8200VFD; \
	fi
	cp -f $(SKEL_ROOT)/root_enigma2/usr/local/share/enigma2/keymap_fortis.xml $(RELEASE_DIR)/usr/local/share/enigma2/keymap.xml

#
# release_octagon1008
#
release_enigma2_octagon1008:
	echo "octagon1008" > $(RELEASE_DIR)/etc/hostname
	install -m 0755 $(SKEL_ROOT)/release/halt_octagon1008 $(RELEASE_DIR)/etc/init.d/halt
	cp $(TARGETPREFIX)/lib/modules/$(KERNEL_VERSION)/extra/frontcontroller/nuvoton/nuvoton.ko $(RELEASE_DIR)/lib/modules/
	cp $(TARGETPREFIX)/lib/modules/$(KERNEL_VERSION)/extra/frontends/*.ko $(RELEASE_DIR)/lib/modules/
	cp $(TARGETPREFIX)/lib/modules/$(KERNEL_VERSION)/extra/stgfb/stmfb/stmcore-display-stx7109c3.ko $(RELEASE_DIR)/lib/modules/
	cp $(SKEL_ROOT)/boot/video_7109.elf $(RELEASE_DIR)/boot/video.elf
	cp $(SKEL_ROOT)/boot/audio_7100.elf $(RELEASE_DIR)/boot/audio.elf
	cp $(SKEL_ROOT)/firmware/dvb-fe-avl2108.fw $(RELEASE_DIR)/lib/firmware/
	cp $(SKEL_ROOT)/firmware/dvb-fe-stv6306.fw $(RELEASE_DIR)/lib/firmware/
	cp -f $(SKEL_ROOT)/release/rc_hs9510.png $(RELEASE_DIR)/usr/local/share/enigma2/skin_default/rc.png
	if [ -e $(TARGETPREFIX)/usr/lib/enigma2/python/Plugins/Extensions/hs9510VFD/plugin.py ]; then \
		rm -f $(RELEASE_DIR)/usr/lib/enigma2/python/Plugins/SystemPlugins/VFD-Icons/*; \
		cp -f $(SKEL_ROOT)/release/vfddisplay.png $(TARGETPREFIX)/usr/lib/enigma2/python/Plugins/Extensions/hs9510VFD; \
		cp -rf $(TARGETPREFIX)/usr/lib/enigma2/python/Plugins/Extensions/hs9510VFD/* $(RELEASE_DIR)/usr/lib/enigma2/python/Plugins/SystemPlugins/VFD-Icons; \
		rm -rf $(RELEASE_DIR)/usr/lib/enigma2/python/Plugins/Extensions/hs9510VFD; \
	fi
	cp -f $(SKEL_ROOT)/root_enigma2/usr/local/share/enigma2/keymap_fortis.xml $(RELEASE_DIR)/usr/local/share/enigma2/keymap.xml

#
# release_hs7110
#
release_enigma2_hs7110:
	echo "hs7110" > $(RELEASE_DIR)/etc/hostname
	install -m 0755 $(SKEL_ROOT)/release/halt_hs7110 $(RELEASE_DIR)/etc/init.d/halt
	cp $(TARGETPREFIX)/lib/modules/$(KERNEL_VERSION)/extra/frontcontroller/nuvoton/nuvoton.ko $(RELEASE_DIR)/lib/modules/
	cp $(TARGETPREFIX)/lib/modules/$(KERNEL_VERSION)/extra/frontends/lnb/lnb.ko $(RELEASE_DIR)/lib/modules/
	cp $(TARGETPREFIX)/lib/modules/$(KERNEL_VERSION)/extra/frontends/*.ko $(RELEASE_DIR)/lib/modules/
	cp $(TARGETPREFIX)/lib/modules/$(KERNEL_VERSION)/extra/stgfb/stmfb/stmcore-display-sti7111.ko $(RELEASE_DIR)/lib/modules/
	cp $(SKEL_ROOT)/boot/video_7111.elf $(RELEASE_DIR)/boot/video.elf
	cp $(SKEL_ROOT)/boot/audio_7111.elf $(RELEASE_DIR)/boot/audio.elf
	cp $(SKEL_ROOT)/firmware/component_7111_mb618.fw $(RELEASE_DIR)/lib/firmware/component.fw
	cp -f $(SKEL_ROOT)/release/rc_hs7110.png $(RELEASE_DIR)/usr/local/share/enigma2/skin_default/rc.png
	cp -f $(SKEL_ROOT)/root_enigma2/usr/local/share/enigma2/keymap_fortis.xml $(RELEASE_DIR)/usr/local/share/enigma2/keymap.xml

#
# release_hs7420
#
release_enigma2_hs7420:
	echo "hs7420" > $(RELEASE_DIR)/etc/hostname
	install -m 0755 $(SKEL_ROOT)/release/halt_hs742x $(RELEASE_DIR)/etc/init.d/halt
	chmod 755 $(RELEASE_DIR)/etc/init.d/halt
	cp $(TARGETPREFIX)/lib/modules/$(KERNEL_VERSION)/extra/frontcontroller/nuvoton/nuvoton.ko $(RELEASE_DIR)/lib/modules/
	cp $(TARGETPREFIX)/lib/modules/$(KERNEL_VERSION)/extra/frontends/lnb/lnb.ko $(RELEASE_DIR)/lib/modules/
	cp $(TARGETPREFIX)/lib/modules/$(KERNEL_VERSION)/extra/frontends/*.ko $(RELEASE_DIR)/lib/modules/
	cp $(TARGETPREFIX)/lib/modules/$(KERNEL_VERSION)/extra/stgfb/stmfb/stmcore-display-sti7111.ko $(RELEASE_DIR)/lib/modules/
	cp $(SKEL_ROOT)/boot/video_7111.elf $(RELEASE_DIR)/boot/video.elf
	cp $(SKEL_ROOT)/boot/audio_7111.elf $(RELEASE_DIR)/boot/audio.elf
	cp $(SKEL_ROOT)/firmware/component_7111_mb618.fw $(RELEASE_DIR)/lib/firmware/component.fw
	cp -f $(SKEL_ROOT)/release/rc_hs9510.png $(RELEASE_DIR)/usr/local/share/enigma2/skin_default/rc.png
	if [ -e $(TARGETPREFIX)/usr/lib/enigma2/python/Plugins/Extensions/hs9510VFD/plugin.py ]; then \
		rm -f $(RELEASE_DIR)/usr/lib/enigma2/python/Plugins/SystemPlugins/VFD-Icons/*; \
		cp -f $(SKEL_ROOT)/release/vfddisplay.png $(TARGETPREFIX)/usr/lib/enigma2/python/Plugins/Extensions/hs9510VFD; \
		cp -rf $(TARGETPREFIX)/usr/lib/enigma2/python/Plugins/Extensions/hs9510VFD/* $(RELEASE_DIR)/usr/lib/enigma2/python/Plugins/SystemPlugins/VFD-Icons; \
		rm -rf $(RELEASE_DIR)/usr/lib/enigma2/python/Plugins/Extensions/hs9510VFD; \
	fi
	cp -f $(SKEL_ROOT)/root_enigma2/usr/local/share/enigma2/keymap_fortis.xml $(RELEASE_DIR)/usr/local/share/enigma2/keymap.xml

#
# release_hs7429
#
release_enigma2_hs7429:
	echo "hs7429" > $(RELEASE_DIR)/etc/hostname
	install -m 0755 $(SKEL_ROOT)/release/halt_hs742x $(RELEASE_DIR)/etc/init.d/halt
	chmod 755 $(RELEASE_DIR)/etc/init.d/halt
	cp $(TARGETPREFIX)/lib/modules/$(KERNEL_VERSION)/extra/frontcontroller/nuvoton/nuvoton.ko $(RELEASE_DIR)/lib/modules/
	cp $(TARGETPREFIX)/lib/modules/$(KERNEL_VERSION)/extra/frontends/lnb/lnb.ko $(RELEASE_DIR)/lib/modules/
	cp $(TARGETPREFIX)/lib/modules/$(KERNEL_VERSION)/extra/frontends/*.ko $(RELEASE_DIR)/lib/modules/
	cp $(TARGETPREFIX)/lib/modules/$(KERNEL_VERSION)/extra/stgfb/stmfb/stmcore-display-sti7111.ko $(RELEASE_DIR)/lib/modules/
	cp $(SKEL_ROOT)/boot/video_7111.elf $(RELEASE_DIR)/boot/video.elf
	cp $(SKEL_ROOT)/boot/audio_7111.elf $(RELEASE_DIR)/boot/audio.elf
	cp $(SKEL_ROOT)/firmware/component_7111_mb618.fw $(RELEASE_DIR)/lib/firmware/component.fw
	cp -f $(SKEL_ROOT)/release/rc_hs9510.png $(RELEASE_DIR)/usr/local/share/enigma2/skin_default/rc.png
	if [ -e $(TARGETPREFIX)/usr/lib/enigma2/python/Plugins/Extensions/hs9510VFD/plugin.py ]; then \
		rm -f $(RELEASE_DIR)/usr/lib/enigma2/python/Plugins/SystemPlugins/VFD-Icons/*; \
		cp -f $(SKEL_ROOT)/release/vfddisplay.png $(TARGETPREFIX)/usr/lib/enigma2/python/Plugins/Extensions/hs9510VFD; \
		cp -rf $(TARGETPREFIX)/usr/lib/enigma2/python/Plugins/Extensions/hs9510VFD/* $(RELEASE_DIR)/usr/lib/enigma2/python/Plugins/SystemPlugins/VFD-Icons; \
		rm -rf $(RELEASE_DIR)/usr/lib/enigma2/python/Plugins/Extensions/hs9510VFD; \
	fi
	cp -f $(SKEL_ROOT)/root_enigma2/usr/local/share/enigma2/keymap_fortis.xml $(RELEASE_DIR)/usr/local/share/enigma2/keymap.xml

#
# release_hs7810a
#
release_enigma2_hs7810a:
	echo "hs7810a" > $(RELEASE_DIR)/etc/hostname
	install -m 0755 $(SKEL_ROOT)/release/halt_hs7810a $(RELEASE_DIR)/etc/init.d/halt
	cp $(TARGETPREFIX)/lib/modules/$(KERNEL_VERSION)/extra/frontcontroller/nuvoton/nuvoton.ko $(RELEASE_DIR)/lib/modules/
	cp $(TARGETPREFIX)/lib/modules/$(KERNEL_VERSION)/extra/frontends/lnb/lnb.ko $(RELEASE_DIR)/lib/modules/
	cp $(TARGETPREFIX)/lib/modules/$(KERNEL_VERSION)/extra/frontends/*.ko $(RELEASE_DIR)/lib/modules/
	cp $(TARGETPREFIX)/lib/modules/$(KERNEL_VERSION)/extra/stgfb/stmfb/stmcore-display-sti7111.ko $(RELEASE_DIR)/lib/modules/
	cp $(SKEL_ROOT)/boot/video_7111.elf $(RELEASE_DIR)/boot/video.elf
	cp $(SKEL_ROOT)/boot/audio_7111.elf $(RELEASE_DIR)/boot/audio.elf
	cp $(SKEL_ROOT)/firmware/component_7111_mb618.fw $(RELEASE_DIR)/lib/firmware/component.fww
	cp -f $(SKEL_ROOT)/release/rc_hs9510.png $(RELEASE_DIR)/usr/local/share/enigma2/skin_default/rc.png
	if [ -e $(TARGETPREFIX)/usr/lib/enigma2/python/Plugins/Extensions/hs7810aVFD/plugin.py ]; then \
		rm -f $(RELEASE_DIR)/usr/lib/enigma2/python/Plugins/SystemPlugins/VFD-Icons/*; \
		cp -f $(SKEL_ROOT)/release/vfddisplay.png $(TARGETPREFIX)/usr/lib/enigma2/python/Plugins/Extensions/hs7810aVFD; \
		cp -rf $(TARGETPREFIX)/usr/lib/enigma2/python/Plugins/Extensions/hs7810aVFD/* $(RELEASE_DIR)/usr/lib/enigma2/python/Plugins/SystemPlugins/VFD-Icons; \
		rm -rf $(RELEASE_DIR)/usr/lib/enigma2/python/Plugins/Extensions/hs7810aVFD; \
	fi
	cp -f $(SKEL_ROOT)/root_enigma2/usr/local/share/enigma2/keymap_fortis.xml $(RELEASE_DIR)/usr/local/share/enigma2/keymap.xml

#
# release_hs7119
#
release_enigma2_hs7119:
	echo "hs7119" > $(RELEASE_DIR)/etc/hostname
	install -m 0755 $(SKEL_ROOT)/release/halt_hs7119 $(RELEASE_DIR)/etc/init.d/halt
	cp $(TARGETPREFIX)/lib/modules/$(KERNEL_VERSION)/extra/frontcontroller/nuvoton/nuvoton.ko $(RELEASE_DIR)/lib/modules/
	cp $(TARGETPREFIX)/lib/modules/$(KERNEL_VERSION)/extra/frontends/lnb/lnb.ko $(RELEASE_DIR)/lib/modules/
	cp $(TARGETPREFIX)/lib/modules/$(KERNEL_VERSION)/extra/frontends/*.ko $(RELEASE_DIR)/lib/modules/
	cp $(TARGETPREFIX)/lib/modules/$(KERNEL_VERSION)/extra/stgfb/stmfb/stmcore-display-sti7111.ko $(RELEASE_DIR)/lib/modules/
	cp $(SKEL_ROOT)/boot/video_7111.elf $(RELEASE_DIR)/boot/video.elf
	cp $(SKEL_ROOT)/boot/audio_7111.elf $(RELEASE_DIR)/boot/audio.elf
	cp $(SKEL_ROOT)/firmware/component_7111_mb618.fw $(RELEASE_DIR)/lib/firmware/component.fw
	cp -f $(SKEL_ROOT)/release/rc_hs7110.png $(RELEASE_DIR)/usr/local/share/enigma2/skin_default/rc.png
	if [ -e $(TARGETPREFIX)/usr/lib/enigma2/python/Plugins/Extensions/hs7810aVFD/plugin.py ]; then \
		rm -f $(RELEASE_DIR)/usr/lib/enigma2/python/Plugins/SystemPlugins/VFD-Icons/*; \
		cp -f $(SKEL_ROOT)/release/vfddisplay.png $(TARGETPREFIX)/usr/lib/enigma2/python/Plugins/Extensions/hs7810aVFD; \
		cp -rf $(TARGETPREFIX)/usr/lib/enigma2/python/Plugins/Extensions/hs7810aVFD/* $(RELEASE_DIR)/usr/lib/enigma2/python/Plugins/SystemPlugins/VFD-Icons; \
		rm -rf $(RELEASE_DIR)/usr/lib/enigma2/python/Plugins/Extensions/hs7810aVFD; \
	fi
	cp -f $(SKEL_ROOT)/root_enigma2/usr/local/share/enigma2/keymap_fortis.xml $(RELEASE_DIR)/usr/local/share/enigma2/keymap.xml

#
# release_hs7819
#
release_enigma2_hs7819:
	echo "hs7819" > $(RELEASE_DIR)/etc/hostname
	install -m 0755 $(SKEL_ROOT)/release/halt_hs7819 $(RELEASE_DIR)/etc/init.d/halt
	cp $(TARGETPREFIX)/lib/modules/$(KERNEL_VERSION)/extra/frontcontroller/nuvoton/nuvoton.ko $(RELEASE_DIR)/lib/modules/
	cp $(TARGETPREFIX)/lib/modules/$(KERNEL_VERSION)/extra/frontends/lnb/lnb.ko $(RELEASE_DIR)/lib/modules/
	cp $(TARGETPREFIX)/lib/modules/$(KERNEL_VERSION)/extra/frontends/*.ko $(RELEASE_DIR)/lib/modules/
	cp $(TARGETPREFIX)/lib/modules/$(KERNEL_VERSION)/extra/stgfb/stmfb/stmcore-display-sti7111.ko $(RELEASE_DIR)/lib/modules/
	cp $(SKEL_ROOT)/boot/video_7111.elf $(RELEASE_DIR)/boot/video.elf
	cp $(SKEL_ROOT)/boot/audio_7111.elf $(RELEASE_DIR)/boot/audio.elf
	cp $(SKEL_ROOT)/firmware/component_7111_mb618.fw $(RELEASE_DIR)/lib/firmware/component.fw
	cp -f $(SKEL_ROOT)/release/rc_hs9510.png $(RELEASE_DIR)/usr/local/share/enigma2/skin_default/rc.png
	if [ -e $(TARGETPREFIX)/usr/lib/enigma2/python/Plugins/Extensions/hs7810aVFD/plugin.py ]; then \
		rm -f $(RELEASE_DIR)/usr/lib/enigma2/python/Plugins/SystemPlugins/VFD-Icons/*; \
		cp -f $(SKEL_ROOT)/release/vfddisplay.png $(TARGETPREFIX)/usr/lib/enigma2/python/Plugins/Extensions/hs7810aVFD; \
		cp -rf $(TARGETPREFIX)/usr/lib/enigma2/python/Plugins/Extensions/hs7810aVFD/* $(RELEASE_DIR)/usr/lib/enigma2/python/Plugins/SystemPlugins/VFD-Icons; \
		rm -rf $(RELEASE_DIR)/usr/lib/enigma2/python/Plugins/Extensions/hs7810aVFD; \
	fi
	cp -f $(SKEL_ROOT)/root_enigma2/usr/local/share/enigma2/keymap_fortis.xml $(RELEASE_DIR)/usr/local/share/enigma2/keymap.xml

#
# release_atemio520
#
release_enigma2_atemio520:
	echo "atemio520" > $(RELEASE_DIR)/etc/hostname
	install -m 0755 $(SKEL_ROOT)/release/halt_atemio520 $(RELEASE_DIR)/etc/init.d/halt
	cp $(TARGETPREFIX)/lib/modules/$(KERNEL_VERSION)/extra/frontcontroller/cn_micom/cn_micom.ko $(RELEASE_DIR)/lib/modules/
	cp $(TARGETPREFIX)/lib/modules/$(KERNEL_VERSION)/extra/frontends/lnb/lnb.ko $(RELEASE_DIR)/lib/modules/
	cp $(TARGETPREFIX)/lib/modules/$(KERNEL_VERSION)/extra/frontends/*.ko $(RELEASE_DIR)/lib/modules/
	cp $(TARGETPREFIX)/lib/modules/$(KERNEL_VERSION)/extra/stgfb/stmfb/stmcore-display-sti7111.ko $(RELEASE_DIR)/lib/modules/
	cp $(SKEL_ROOT)/boot/video_7111.elf $(RELEASE_DIR)/boot/video.elf
	cp $(SKEL_ROOT)/boot/audio_7111.elf $(RELEASE_DIR)/boot/audio.elf
	cp $(SKEL_ROOT)/firmware/component_7111_mb618.fw $(RELEASE_DIR)/lib/firmware/component.fw
	cp -f $(SKEL_ROOT)/root_enigma2/usr/local/share/enigma2/keymap_ufs910.xml $(RELEASE_DIR)/usr/local/share/enigma2/keymap.xml

#
# release_atemio530
#
release_enigma2_atemio530:
	echo "atemio530" > $(RELEASE_DIR)/etc/hostname
	install -m 0755 $(SKEL_ROOT)/release/halt_atemio530 $(RELEASE_DIR)/etc/init.d/halt
	cp $(TARGETPREFIX)/lib/modules/$(KERNEL_VERSION)/extra/frontcontroller/cn_micom/cn_micom.ko $(RELEASE_DIR)/lib/modules/
	cp $(TARGETPREFIX)/lib/modules/$(KERNEL_VERSION)/extra/frontends/lnb/lnb.ko $(RELEASE_DIR)/lib/modules/
	cp $(TARGETPREFIX)/lib/modules/$(KERNEL_VERSION)/extra/frontends/*.ko $(RELEASE_DIR)/lib/modules/
	cp $(TARGETPREFIX)/lib/modules/$(KERNEL_VERSION)/extra/stgfb/stmfb/stmcore-display-sti7111.ko $(RELEASE_DIR)/lib/modules/
	cp $(SKEL_ROOT)/boot/video_7111.elf $(RELEASE_DIR)/boot/video.elf
	cp $(SKEL_ROOT)/boot/audio_7111.elf $(RELEASE_DIR)/boot/audio.elf
	cp $(SKEL_ROOT)/firmware/component_7111_mb618.fw $(RELEASE_DIR)/lib/firmware/component.fw
	cp -f $(SKEL_ROOT)/root_enigma2/usr/local/share/enigma2/keymap_ufs910.xml $(RELEASE_DIR)/usr/local/share/enigma2/keymap.xml

#
# release_hl101
#
release_enigma2_hl101:
	echo "hl101" > $(RELEASE_DIR)/etc/hostname
	install -m 0755 $(SKEL_ROOT)/release/halt_hl101 $(RELEASE_DIR)/etc/init.d/halt
	cp $(TARGETPREFIX)/lib/modules/$(KERNEL_VERSION)/extra/frontcontroller/proton/proton.ko $(RELEASE_DIR)/lib/modules/
	cp $(TARGETPREFIX)/lib/modules/$(KERNEL_VERSION)/extra/frontends/*.ko $(RELEASE_DIR)/lib/modules/
	cp $(TARGETPREFIX)/lib/modules/$(KERNEL_VERSION)/extra/stgfb/stmfb/stmcore-display-stx7109c3.ko $(RELEASE_DIR)/lib/modules/
	cp $(SKEL_ROOT)/boot/video_7109.elf $(RELEASE_DIR)/boot/video.elf
	cp $(SKEL_ROOT)/boot/audio_7109.elf $(RELEASE_DIR)/boot/audio.elf
	cp $(SKEL_ROOT)/firmware/dvb-fe-avl2108.fw $(RELEASE_DIR)/lib/firmware/
	cp $(SKEL_ROOT)/firmware/dvb-fe-stv6306.fw $(RELEASE_DIR)/lib/firmware/
	cp -dp $(SKEL_ROOT)/release/lircd_hl101.conf $(RELEASE_DIR)/etc/lircd.conf
	cp -p $(TARGETPREFIX)/usr/sbin/lircd $(RELEASE_DIR)/usr/bin/
	mkdir -p $(RELEASE_DIR)/var/run/lirc
	rm -f $(RELEASE_DIR)/bin/vdstandby
	cp -f $(SKEL_ROOT)/root_enigma2/usr/local/share/enigma2/keymap_hl101.xml $(RELEASE_DIR)/usr/local/share/enigma2/keymap.xml

#
# release_adb_box
#
release_enigma2_adb_box:
	echo "Adb_Box" > $(RELEASE_DIR)/etc/hostname
	install -m 0755 $(SKEL_ROOT)/release/halt_adb_box $(RELEASE_DIR)/etc/init.d/halt
	cp $(TARGETPREFIX)/lib/modules/$(KERNEL_VERSION)/extra/frontcontroller/adb_box_vfd/vfd.ko $(RELEASE_DIR)/lib/modules/
	cp $(TARGETPREFIX)/lib/modules/$(KERNEL_VERSION)/extra/frontends/*.ko $(RELEASE_DIR)/lib/modules/
	cp $(TARGETPREFIX)/lib/modules/$(KERNEL_VERSION)/extra/stgfb/stmfb/stmcore-display-stx7100.ko $(RELEASE_DIR)/lib/modules/
	cp $(TARGETPREFIX)/lib/modules/$(KERNEL_VERSION)/extra/adb_box_fan/cooler.ko $(RELEASE_DIR)/lib/modules/
	cp $(TARGETPREFIX)/lib/modules/$(KERNEL_VERSION)/extra/cec_adb_box/cec_ctrl.ko $(RELEASE_DIR)/lib/modules/
	cp $(TARGETPREFIX)/lib/modules/$(KERNEL_VERSION)/extra/dvbt/as102/dvb-as102.ko $(RELEASE_DIR)/lib/modules/
	cp $(SKEL_ROOT)/boot/video_7100.elf $(RELEASE_DIR)/boot/video.elf
	cp $(SKEL_ROOT)/boot/audio_7100.elf $(RELEASE_DIR)/boot/audio.elf
	cp $(SKEL_ROOT)/firmware/as102_data1_st.hex $(RELEASE_DIR)/lib/firmware/
	cp $(SKEL_ROOT)/firmware/as102_data2_st.hex $(RELEASE_DIR)/lib/firmware/
	cp $(SKEL_ROOT)/firmware/dvb-fe-avl2108.fw $(RELEASE_DIR)/lib/firmware/
	cp $(SKEL_ROOT)/firmware/dvb-fe-avl6222.fw $(RELEASE_DIR)/lib/firmware/
	cp -f $(SKEL_ROOT)/release/fstab_adb_box $(RELEASE_DIR)/etc/fstab
	cp -dp $(SKEL_ROOT)/release/lircd_adb_box.conf $(RELEASE_DIR)/etc/lircd.conf
	cp -p $(TARGETPREFIX)/usr/sbin/lircd $(RELEASE_DIR)/usr/bin/lircd
	mkdir -p $(RELEASE_DIR)/var/run/lirc
	rm -f $(RELEASE_DIR)/bin/vdstandby
	cp -f $(SKEL_ROOT)/root_enigma2/usr/local/share/enigma2/keymap_adb_box.xml $(RELEASE_DIR)/usr/local/share/enigma2/keymap.xml

#
# release_tf7700
#
release_enigma2_tf7700:
	echo "tf7700" > $(RELEASE_DIR)/etc/hostname
	install -m 0755 $(SKEL_ROOT)/release/halt_tf7700 $(RELEASE_DIR)/etc/init.d/halt
	cp $(TARGETPREFIX)/lib/modules/$(KERNEL_VERSION)/extra/frontcontroller/tffp/tffp.ko $(RELEASE_DIR)/lib/modules/
	cp $(TARGETPREFIX)/lib/modules/$(KERNEL_VERSION)/extra/frontends/*.ko $(RELEASE_DIR)/lib/modules/
	cp $(TARGETPREFIX)/lib/modules/$(KERNEL_VERSION)/extra/stgfb/stmfb/stmcore-display-stx7109c3.ko $(RELEASE_DIR)/lib/modules/
	cp $(SKEL_ROOT)/boot/video_7109.elf $(RELEASE_DIR)/boot/video.elf
	cp $(SKEL_ROOT)/boot/audio_7100.elf $(RELEASE_DIR)/boot/audio.elf
	cp -f $(SKEL_ROOT)/release/fstab_tf7700 $(RELEASE_DIR)/etc/fstab
	cp -f $(TARGETPREFIX)/sbin/shutdown $(RELEASE_DIR)/sbin/
	rm -f $(RELEASE_DIR)/bin/vdstandby
	cp -f $(SKEL_ROOT)/release/rc_tf7700.png $(RELEASE_DIR)/usr/local/share/enigma2/skin_default/rc.png
	cp -f $(SKEL_ROOT)/root_enigma2/usr/local/share/enigma2/keymap_tf7700.xml $(RELEASE_DIR)/usr/local/share/enigma2/keymap.xml

#
# release_vitamin_hd5000
#
release_enigma2_vitamin_hd5000:
	echo "vitamin_hd5000" > $(RELEASE_DIR)/etc/hostname
	install -m 0755 $(SKEL_ROOT)/release/halt_ufs912 $(RELEASE_DIR)/etc/init.d/halt
	cp $(TARGETPREFIX)/lib/modules/$(KERNEL_VERSION)/extra/stgfb/stmfb/stmcore-display-sti7111.ko $(RELEASE_DIR)/lib/modules/
	cp $(TARGETPREFIX)/lib/modules/$(KERNEL_VERSION)/extra/frontcontroller/vitamin_hd5000/micom.ko $(RELEASE_DIR)/lib/modules/
	cp $(TARGETPREFIX)/lib/modules/$(KERNEL_VERSION)/extra/smartcard/smartcard.ko $(RELEASE_DIR)/lib/modules/
	cp $(SKEL_ROOT)/boot/video_7111.elf $(RELEASE_DIR)/boot/video.elf
	cp $(SKEL_ROOT)/boot/audio_7111.elf $(RELEASE_DIR)/boot/audio.elf
	cp $(SKEL_ROOT)/firmware/dvb-fe-avl6222.fw $(RELEASE_DIR)/lib/firmware/
	cp $(SKEL_ROOT)/firmware/component_7111_mb618.fw $(RELEASE_DIR)/lib/firmware/component.fw
	cp -f $(SKEL_ROOT)/root_enigma2/usr/local/share/enigma2/keymap_vitamin_hd5000.xml $(RELEASE_DIR)/usr/local/share/enigma2/keymap.xml

#
# release_sagemcom88
#
release_enigma2_sagemcom88:
	echo "sagemcom88" > $(RELEASE_DIR)/etc/hostname
	install -m 0755 $(SKEL_ROOT)/release/halt_ufs912 $(RELEASE_DIR)/etc/init.d/halt
	cp $(TARGETPREFIX)/lib/modules/$(KERNEL_VERSION)/extra/stgfb/stmfb/stmcore-display-sti7105.ko $(RELEASE_DIR)/lib/modules/
	cp $(TARGETPREFIX)/lib/modules/$(KERNEL_VERSION)/extra/frontcontroller/front_led/front_led.ko $(RELEASE_DIR)/lib/modules/
	cp $(TARGETPREFIX)/lib/modules/$(KERNEL_VERSION)/extra/frontcontroller/front_vfd/front_vfd.ko $(RELEASE_DIR)/lib/modules/
	cp $(TARGETPREFIX)/lib/modules/$(KERNEL_VERSION)/extra/sagemcomtype/boxtype.ko $(RELEASE_DIR)/lib/modules/
	[ -e $(SKEL_ROOT)/release/fe_core_sagemcom88$(KERNEL_STM_LABEL).ko ] && cp $(SKEL_ROOT)/release/fe_core_sagemcom88$(KERNEL_STM_LABEL).ko $(RELEASE_DIR)/lib/modules/fe_core.ko || true
	cp $(SKEL_ROOT)/boot/video_7105.elf $(RELEASE_DIR)/boot/video.elf
	cp $(SKEL_ROOT)/boot/audio_7105.elf $(RELEASE_DIR)/boot/audio.elf
	cp $(SKEL_ROOT)/firmware/dvb-fe-avl6222.fw $(RELEASE_DIR)/lib/firmware/
	cp $(SKEL_ROOT)/firmware/component_7105_pdk7105.fw $(RELEASE_DIR)/lib/firmware/component.fw
	cp -f $(SKEL_ROOT)/root_enigma2/usr/local/share/enigma2/keymap_sagemcom88.xml $(RELEASE_DIR)/usr/local/share/enigma2/keymap.xml
	cp -p $(TARGETPREFIX)/usr/sbin/lircd $(RELEASE_DIR)/usr/bin/
	cp -p $(TARGETPREFIX)/usr/sbin/lircmd $(RELEASE_DIR)/usr/bin/
	cp -p $(TARGETPREFIX)/usr/bin/irexec $(RELEASE_DIR)/usr/bin/
	cp -p $(TARGETPREFIX)/usr/bin/irrecord $(RELEASE_DIR)/usr/bin/
	cp -p $(TARGETPREFIX)/usr/bin/irsend $(RELEASE_DIR)/usr/bin/
	cp -p $(TARGETPREFIX)/usr/bin/irw $(RELEASE_DIR)/usr/bin/
	cp -dp $(SKEL_ROOT)/release/lircd_sagemcom88.conf $(RELEASE_DIR)/etc/lircd.conf

#
# release_arivalink200
#
release_enigma2_arivalink200:
	echo "Ariva@Link200" > $(RELEASE_DIR)/etc/hostname
	cp $(TARGETPREFIX)/lib/modules/$(KERNEL_VERSION)/extra/stgfb/stmfb/stmcore-display-stx7109c3.ko $(RELEASE_DIR)/lib/modules/
	cp $(TARGETPREFIX)/lib/modules/$(KERNEL_VERSION)/extra/frontends/*.ko $(RELEASE_DIR)/lib/modules/
	[ -e $(TARGETPREFIX)/lib/modules/$(KERNEL_VERSION)/extra/frontcontroller/front_ArivaLink200/vfd.ko ] && cp $(TARGETPREFIX)/lib/modules/$(KERNEL_VERSION)/extra/frontcontroller/front_ArivaLink200/vfd.ko $(RELEASE_DIR)/lib/modules/ || true
	cp $(SKEL_ROOT)/boot/video_7109.elf $(RELEASE_DIR)/boot/video.elf
	cp $(SKEL_ROOT)/boot/audio_7100.elf $(RELEASE_DIR)/boot/audio.elf
	cp $(SKEL_ROOT)/firmware/dvb-fe-avl6222.fw $(RELEASE_DIR)/lib/firmware/
	cp $(SKEL_ROOT)/firmware/dvb-fe-cx24116.fw $(RELEASE_DIR)/lib/firmware/
	cp -f $(SKEL_ROOT)/root_enigma2/usr/local/share/enigma2/keymap_arivalink200.xml $(RELEASE_DIR)/usr/local/share/enigma2/keymap.xml
	cp -p $(TARGETPREFIX)/usr/sbin/lircd $(RELEASE_DIR)/usr/bin/
	cp -p $(TARGETPREFIX)/usr/sbin/lircmd $(RELEASE_DIR)/usr/bin/
	cp -p $(TARGETPREFIX)/usr/bin/irexec $(RELEASE_DIR)/usr/bin/
	cp -p $(TARGETPREFIX)/usr/bin/irrecord $(RELEASE_DIR)/usr/bin/
	cp -p $(TARGETPREFIX)/usr/bin/irsend $(RELEASE_DIR)/usr/bin/
	cp -p $(TARGETPREFIX)/usr/bin/irw $(RELEASE_DIR)/usr/bin/
	mkdir -p $(RELEASE_DIR)/var/run/lirc
	cp -dp $(SKEL_ROOT)/release/lircd_arivalink200.conf $(RELEASE_DIR)/etc/lircd.conf

#
# release_base
#
# the following target creates the common file base
release_enigma2_base:
	$(START_BUILD)
	rm -rf $(RELEASE_DIR) || true
	install -d $(RELEASE_DIR)
	install -d $(RELEASE_DIR)/{autofs,bin,boot,dev,dev.static,etc,lib,media,mnt,proc,ram,root,sbin,share,sys,tmp,usr,var}
	install -d $(RELEASE_DIR)/etc/{enigma2,init.d,network,mdev,tuxbox,tuxtxt}
	install -d $(RELEASE_DIR)/etc/network/if-{post-{up,down},pre-{up,down},up,down}.d
	install -d $(RELEASE_DIR)/lib/{modules,udev,firmware}
	install -d $(RELEASE_DIR)/media/{dvd,hdd,net}
	ln -sf /media/hdd $(RELEASE_DIR)/hdd
	install -d $(RELEASE_DIR)/mnt/{hdd,nfs,usb}
	install -d $(RELEASE_DIR)/usr/{bin,lib,local,sbin,share}
	install -d $(RELEASE_DIR)/usr/local/{bin,share}
	ln -sf /etc $(RELEASE_DIR)/usr/local/etc
	install -d $(RELEASE_DIR)/usr/local/share/{enigma2,keymaps}
	ln -s /usr/local/share/keymaps $(RELEASE_DIR)/usr/share/keymaps
	install -d $(RELEASE_DIR)/usr/share/{fonts,zoneinfo,udhcpc}
	install -d $(RELEASE_DIR)/var/{etc,opkg}
	export CROSS_COMPILE=$(TARGET)- && $(MAKE) install -C $(BUILD_TMP)/busybox-$(BUSYBOX_VER) CONFIG_PREFIX=$(RELEASE_DIR)
#	remove the slink to busybox
	rm -f $(RELEASE_DIR)/sbin/halt
	cp -f $(TARGETPREFIX)/sbin/halt $(RELEASE_DIR)/sbin/
	ln -fs halt $(RELEASE_DIR)/sbin/reboot
	ln -fs halt $(RELEASE_DIR)/sbin/poweroff
	mkdir -p $(RELEASE_DIR)/etc/rc.d/rc0.d
	ln -s ../init.d/sendsigs $(RELEASE_DIR)/etc/rc.d/rc0.d/S20sendsigs
	ln -s ../init.d/umountfs $(RELEASE_DIR)/etc/rc.d/rc0.d/S40umountfs
	ln -s ../init.d/halt $(RELEASE_DIR)/etc/rc.d/rc0.d/S90halt
	mkdir -p $(RELEASE_DIR)/etc/rc.d/rc6.d
	ln -s ../init.d/sendsigs $(RELEASE_DIR)/etc/rc.d/rc6.d/S20sendsigs
	ln -s ../init.d/umountfs $(RELEASE_DIR)/etc/rc.d/rc6.d/S40umountfs
	ln -s ../init.d/reboot $(RELEASE_DIR)/etc/rc.d/rc6.d/S90reboot
	touch $(RELEASE_DIR)/var/etc/.firstboot
	cp -a $(TARGETPREFIX)/bin/* $(RELEASE_DIR)/bin/
	cp -a $(TARGETPREFIX)/sbin/* $(RELEASE_DIR)/sbin/
	ln -sf /bin/showiframe $(RELEASE_DIR)/usr/bin/showiframe
	cp $(SKEL_ROOT)/etc/image-version $(RELEASE_DIR)/etc/
	cp $(TARGETPREFIX)/boot/uImage $(RELEASE_DIR)/boot/
	ln -sf /proc/mounts $(RELEASE_DIR)/etc/mtab
	cp -dp $(SKEL_ROOT)/sbin/MAKEDEV $(RELEASE_DIR)/sbin/
	ln -sf ../sbin/MAKEDEV $(RELEASE_DIR)/dev/MAKEDEV
	ln -sf ../../sbin/MAKEDEV $(RELEASE_DIR)/lib/udev/MAKEDEV
	cp -aR $(SKEL_ROOT)/etc/mdev/* $(RELEASE_DIR)/etc/mdev/
	cp -aR $(SKEL_ROOT)/usr/share/udhcpc/* $(RELEASE_DIR)/usr/share/udhcpc/
	cp -aR $(SKEL_ROOT)/usr/share/zoneinfo/* $(RELEASE_DIR)/usr/share/zoneinfo/
	cp $(SKEL_ROOT)/bin/autologin $(RELEASE_DIR)/bin/
	cp $(SKEL_ROOT)/bin/vdstandby $(RELEASE_DIR)/bin/
	cp $(SKEL_ROOT)/usr/sbin/fw_printenv $(RELEASE_DIR)/usr/sbin/
	ln -sf ../../usr/sbin/fw_printenv $(RELEASE_DIR)/usr/sbin/fw_setenv
	echo "720p50" > $(RELEASE_DIR)/etc/videomode
	cp -dp $(TARGETPREFIX)/usr/bin/vsftpd $(RELEASE_DIR)/usr/bin/
	cp -dp $(TARGETPREFIX)/usr/bin/irexec $(RELEASE_DIR)/usr/bin/
	cp -p $(TARGETPREFIX)/usr/bin/ffmpeg $(RELEASE_DIR)/sbin/
	cp -aR $(TARGETPREFIX)/etc/init.d/* $(RELEASE_DIR)/etc/init.d/
	cp -aR $(TARGETPREFIX)/etc/* $(RELEASE_DIR)/etc/
	ln -sf /bin/grab $(RELEASE_DIR)/usr/bin/grab
	cp -dp $(TARGETPREFIX)/usr/bin/sdparm $(RELEASE_DIR)/sbin/
	cp -p $(TARGETPREFIX)/usr/bin/opkg-cl $(RELEASE_DIR)/usr/bin/opkg
	cp -dp $(TARGETPREFIX)/usr/bin/python* $(RELEASE_DIR)/usr/bin/
	cp -p $(TARGETPREFIX)/usr/sbin/ethtool $(RELEASE_DIR)/usr/sbin/
	cp -p $(TARGETPREFIX)/usr/sbin/livestreamersrv $(RELEASE_DIR)/usr/sbin/
ifeq ($(BOXTYPE), $(filter $(BOXTYPE), atevio7500 fortis_hdbox octagon1008 ufs910 ufs912 ufs913 ufs922 ufs960 spark spark7162 ipbox55 ipbox99 ipbox9900 cuberevo cuberevo_mini cuberevo_mini2 cuberevo_250 hd cuberevo_2000hd cuberevo_3000hd adb_box tf7700 vitamin_hd5000))
	cp $(SKEL_ROOT)/release/fw_env.config_$(BOXTYPE) $(RELEASE_DIR)/etc/fw_env.config
endif
	install -m 0755 $(SKEL_ROOT)/release/rcS_enigma2_$(BOXTYPE) $(RELEASE_DIR)/etc/init.d/rcS
#
# player
#
	[ -e $(TARGETPREFIX)/lib/modules/$(KERNEL_VERSION)/extra/stgfb/stmfb/stm_v4l2.ko ] && cp $(TARGETPREFIX)/lib/modules/$(KERNEL_VERSION)/extra/stgfb/stmfb/stm_v4l2.ko $(RELEASE_DIR)/lib/modules/ || true
	[ -e $(TARGETPREFIX)/lib/modules/$(KERNEL_VERSION)/extra/stgfb/stmfb/stmvbi.ko ] && cp $(TARGETPREFIX)/lib/modules/$(KERNEL_VERSION)/extra/stgfb/stmfb/stmvbi.ko $(RELEASE_DIR)/lib/modules/ || true
	[ -e $(TARGETPREFIX)/lib/modules/$(KERNEL_VERSION)/extra/stgfb/stmfb/stmvout.ko ] && cp $(TARGETPREFIX)/lib/modules/$(KERNEL_VERSION)/extra/stgfb/stmfb/stmvout.ko $(RELEASE_DIR)/lib/modules/ || true
	[ -e $(TARGETPREFIX)/lib/modules/$(KERNEL_VERSION)/extra/stgfb/stmfb/stmfb.ko ] && cp $(TARGETPREFIX)/lib/modules/$(KERNEL_VERSION)/extra/stgfb/stmfb/stmfb.ko $(RELEASE_DIR)/lib/modules/ || true
	cd $(TARGETPREFIX)/lib/modules/$(KERNEL_VERSION)/extra && \
	for mod in \
		sound/pseudocard/pseudocard.ko \
		sound/silencegen/silencegen.ko \
		stm/mmelog/mmelog.ko \
		stm/monitor/stm_monitor.ko \
		media/dvb/stm/dvb/stmdvb.ko \
		sound/ksound/ksound.ko \
		media/dvb/stm/mpeg2_hard_host_transformer/mpeg2hw.ko \
		media/dvb/stm/backend/player2.ko \
		media/dvb/stm/h264_preprocessor/sth264pp.ko \
		media/dvb/stm/allocator/stmalloc.ko \
		stm/platform/platform.ko \
		stm/platform/p2div64.ko \
		media/sysfs/stm/stmsysfs.ko \
	;do \
		echo `pwd` player2/linux/drivers/$$mod; \
		if [ -e player2/linux/drivers/$$mod ]; then \
			cp player2/linux/drivers/$$mod $(RELEASE_DIR)/lib/modules/; \
			$(TARGET)-strip --strip-unneeded $(RELEASE_DIR)/lib/modules/`basename $$mod`; \
		else \
			touch $(RELEASE_DIR)/lib/modules/`basename $$mod`; \
		fi; \
		echo "."; \
	done
	echo "touched";
#
# modules
#
	[ -e $(TARGETPREFIX)/lib/modules/$(KERNEL_VERSION)/extra/avs/avs.ko ] && cp $(TARGETPREFIX)/lib/modules/$(KERNEL_VERSION)/extra/avs/avs.ko $(RELEASE_DIR)/lib/modules/ || true
	[ -e $(TARGETPREFIX)/lib/modules/$(KERNEL_VERSION)/extra/bpamem/bpamem.ko ] && cp $(TARGETPREFIX)/lib/modules/$(KERNEL_VERSION)/extra/bpamem/bpamem.ko $(RELEASE_DIR)/lib/modules/ || true
	[ -e $(TARGETPREFIX)/lib/modules/$(KERNEL_VERSION)/extra/boxtype/boxtype.ko ] && cp $(TARGETPREFIX)/lib/modules/$(KERNEL_VERSION)/extra/boxtype/boxtype.ko $(RELEASE_DIR)/lib/modules/ || true
	[ -e $(TARGETPREFIX)/lib/modules/$(KERNEL_VERSION)/extra/compcache/ramzswap.ko ] && cp $(TARGETPREFIX)/lib/modules/$(KERNEL_VERSION)/extra/compcache/ramzswap.ko $(RELEASE_DIR)/lib/modules/ || true
	[ -e $(TARGETPREFIX)/lib/modules/$(KERNEL_VERSION)/extra/e2_proc/e2_proc.ko ] && cp $(TARGETPREFIX)/lib/modules/$(KERNEL_VERSION)/extra/e2_proc/e2_proc.ko $(RELEASE_DIR)/lib/modules/ || true
	[ -e $(TARGETPREFIX)/lib/modules/$(KERNEL_VERSION)/kernel/net/ipv6/ipv6.ko ] && cp $(TARGETPREFIX)/lib/modules/$(KERNEL_VERSION)/kernel/net/ipv6/ipv6.ko $(RELEASE_DIR)/lib/modules/ || true
#
# multicom 324
#
	[ -e $(TARGETPREFIX)/lib/modules/$(KERNEL_VERSION)/extra/multicom/embxshell/embxshell.ko ] && cp $(TARGETPREFIX)/lib/modules/$(KERNEL_VERSION)/extra/multicom/embxshell/embxshell.ko $(RELEASE_DIR)/lib/modules/ || true
	[ -e $(TARGETPREFIX)/lib/modules/$(KERNEL_VERSION)/extra/multicom/embxmailbox/embxmailbox.ko ] && cp $(TARGETPREFIX)/lib/modules/$(KERNEL_VERSION)/extra/multicom/embxmailbox/embxmailbox.ko $(RELEASE_DIR)/lib/modules/ || true
	[ -e $(TARGETPREFIX)/lib/modules/$(KERNEL_VERSION)/extra/multicom/embxshm/embxshm.ko ] && cp $(TARGETPREFIX)/lib/modules/$(KERNEL_VERSION)/extra/multicom/embxshm/embxshm.ko $(RELEASE_DIR)/lib/modules/ || true
	[ -e $(TARGETPREFIX)/lib/modules/$(KERNEL_VERSION)/extra/multicom/mme/mme_host.ko ] && cp $(TARGETPREFIX)/lib/modules/$(KERNEL_VERSION)/extra/multicom/mme/mme_host.ko $(RELEASE_DIR)/lib/modules/ || true
#
# multicom 406
#
	[ -e $(TARGETPREFIX)/lib/modules/$(KERNEL_VERSION)/extra/multicom/src/embx/embx.ko ] && cp $(TARGETPREFIX)/lib/modules/$(KERNEL_VERSION)/extra/multicom/src/embx/embx.ko $(RELEASE_DIR)/lib/modules/ || true
	[ -e $(TARGETPREFIX)/lib/modules/$(KERNEL_VERSION)/extra/multicom/src/embxmailbox/embxmailbox.ko ] && cp $(TARGETPREFIX)/lib/modules/$(KERNEL_VERSION)/extra/multicom/src/embxmailbox/embxmailbox.ko $(RELEASE_DIR)/lib/modules/ || true
	[ -e $(TARGETPREFIX)/lib/modules/$(KERNEL_VERSION)/extra/multicom/src/embxshm/embxshm.ko ] && cp $(TARGETPREFIX)/lib/modules/$(KERNEL_VERSION)/extra/multicom/src/embxshm/embxshm.ko $(RELEASE_DIR)/lib/modules/ || true
	[ -e $(TARGETPREFIX)/lib/modules/$(KERNEL_VERSION)/extra/multicom/src/ics/ics.ko ] && cp $(TARGETPREFIX)/lib/modules/$(KERNEL_VERSION)/extra/multicom/src/ics/ics.ko $(RELEASE_DIR)/lib/modules/ || true
	[ -e $(TARGETPREFIX)/lib/modules/$(KERNEL_VERSION)/extra/multicom/src/ics/ics_user.ko ] && cp $(TARGETPREFIX)/lib/modules/$(KERNEL_VERSION)/extra/multicom/src/ics/ics_user.ko $(RELEASE_DIR)/lib/modules/ || true
	[ -e $(TARGETPREFIX)/lib/modules/$(KERNEL_VERSION)/extra/multicom/src/mme/mme.ko ] && cp $(TARGETPREFIX)/lib/modules/$(KERNEL_VERSION)/extra/multicom/src/mme/mme.ko $(RELEASE_DIR)/lib/modules/ || true
	[ -e $(TARGETPREFIX)/lib/modules/$(KERNEL_VERSION)/extra/multicom/src/mme/mme_user.ko ] && cp $(TARGETPREFIX)/lib/modules/$(KERNEL_VERSION)/extra/multicom/src/mme/mme_user.ko $(RELEASE_DIR)/lib/modules/ || true
	cp $(TARGETPREFIX)/lib/modules/$(KERNEL_VERSION)/extra/simu_button/simu_button.ko $(RELEASE_DIR)/lib/modules/
ifneq ($(BOXTYPE), $(filter $(BOXTYPE), vip2_v1 spark spark7162))
	cp $(TARGETPREFIX)/lib/modules/$(KERNEL_VERSION)/extra/cic/*.ko $(RELEASE_DIR)/lib/modules/
endif
	[ -e $(TARGETPREFIX)/lib/modules/$(KERNEL_VERSION)/extra/button/button.ko ] && cp $(TARGETPREFIX)/lib/modules/$(KERNEL_VERSION)/extra/button/button.ko $(RELEASE_DIR)/lib/modules/ || true
	[ -e $(TARGETPREFIX)/lib/modules/$(KERNEL_VERSION)/extra/cec/cec.ko ] && cp $(TARGETPREFIX)/lib/modules/$(KERNEL_VERSION)/extra/cec/cec.ko $(RELEASE_DIR)/lib/modules/ || true
	[ -e $(TARGETPREFIX)/lib/modules/$(KERNEL_VERSION)/extra/cpu_frequ/cpu_frequ.ko ] && cp $(TARGETPREFIX)/lib/modules/$(KERNEL_VERSION)/extra/cpu_frequ/cpu_frequ.ko $(RELEASE_DIR)/lib/modules/ || true
	[ -e $(TARGETPREFIX)/lib/modules/$(KERNEL_VERSION)/extra/led/led.ko ] && cp $(TARGETPREFIX)/lib/modules/$(KERNEL_VERSION)/extra/led/led.ko $(RELEASE_DIR)/lib/modules/ || true
	[ -e $(TARGETPREFIX)/lib/modules/$(KERNEL_VERSION)/extra/pti/pti.ko ] && cp $(TARGETPREFIX)/lib/modules/$(KERNEL_VERSION)/extra/pti/pti.ko $(RELEASE_DIR)/lib/modules/ || true
	[ -e $(TARGETPREFIX)/lib/modules/$(KERNEL_VERSION)/extra/pti_np/pti.ko ] && cp $(TARGETPREFIX)/lib/modules/$(KERNEL_VERSION)/extra/pti_np/pti.ko $(RELEASE_DIR)/lib/modules/ || true
	[ -e $(TARGETPREFIX)/lib/modules/$(KERNEL_VERSION)/extra/smartcard/smartcard.ko ] && cp $(TARGETPREFIX)/lib/modules/$(KERNEL_VERSION)/extra/smartcard/smartcard.ko $(RELEASE_DIR)/lib/modules/ || true
	[ -e $(TARGETPREFIX)/lib/modules/$(KERNEL_VERSION)/kernel/fs/autofs4/autofs4.ko ] && cp $(TARGETPREFIX)/lib/modules/$(KERNEL_VERSION)/kernel/fs/autofs4/autofs4.ko $(RELEASE_DIR)/lib/modules/ || true
	[ -e $(TARGETPREFIX)/lib/modules/$(KERNEL_VERSION)/kernel/drivers/net/tun.ko ] && cp $(TARGETPREFIX)/lib/modules/$(KERNEL_VERSION)/kernel/drivers/net/tun.ko $(RELEASE_DIR)/lib/modules/ || true
	[ -e $(TARGETPREFIX)/lib/modules/$(KERNEL_VERSION)/kernel/drivers/usb/serial/ftdi_sio.ko ] && cp $(TARGETPREFIX)/lib/modules/$(KERNEL_VERSION)/kernel/drivers/usb/serial/ftdi_sio.ko $(RELEASE_DIR)/lib/modules/ftdi.ko || true
	[ -e $(TARGETPREFIX)/lib/modules/$(KERNEL_VERSION)/kernel/drivers/usb/serial/pl2303.ko ] && cp $(TARGETPREFIX)/lib/modules/$(KERNEL_VERSION)/kernel/drivers/usb/serial/pl2303.ko $(RELEASE_DIR)/lib/modules/ || true
	[ -e $(TARGETPREFIX)/lib/modules/$(KERNEL_VERSION)/kernel/drivers/usb/serial/usbserial.ko ] && cp $(TARGETPREFIX)/lib/modules/$(KERNEL_VERSION)/kernel/drivers/usb/serial/usbserial.ko $(RELEASE_DIR)/lib/modules/ || true
	[ -e $(TARGETPREFIX)/lib/modules/$(KERNEL_VERSION)/kernel/fs/fuse/fuse.ko ] && cp $(TARGETPREFIX)/lib/modules/$(KERNEL_VERSION)/kernel/fs/fuse/fuse.ko $(RELEASE_DIR)/lib/modules/ || true
	[ -e $(TARGETPREFIX)/lib/modules/$(KERNEL_VERSION)/kernel/fs/ntfs/ntfs.ko ] && cp $(TARGETPREFIX)/lib/modules/$(KERNEL_VERSION)/kernel/fs/ntfs/ntfs.ko $(RELEASE_DIR)/lib/modules/ || true
	[ -e $(TARGETPREFIX)/lib/modules/$(KERNEL_VERSION)/kernel/fs/cifs/cifs.ko ] && cp $(TARGETPREFIX)/lib/modules/$(KERNEL_VERSION)/kernel/fs/cifs/cifs.ko $(RELEASE_DIR)/lib/modules/ || true
ifneq ($(BOXTYPE), $(filter $(BOXTYPE), ufs910 ufs922))
	[ -e $(TARGETPREFIX)/lib/modules/$(KERNEL_VERSION)/kernel/fs/jfs/jfs.ko ] && cp $(TARGETPREFIX)/lib/modules/$(KERNEL_VERSION)/kernel/fs/jfs/jfs.ko $(RELEASE_DIR)/lib/modules/ || true
endif
	[ -e $(TARGETPREFIX)/lib/modules/$(KERNEL_VERSION)/kernel/fs/nfsd/nfsd.ko ] && cp $(TARGETPREFIX)/lib/modules/$(KERNEL_VERSION)/kernel/fs/nfsd/nfsd.ko $(RELEASE_DIR)/lib/modules/ || true
	[ -e $(TARGETPREFIX)/lib/modules/$(KERNEL_VERSION)/kernel/fs/exportfs/exportfs.ko ] && cp $(TARGETPREFIX)/lib/modules/$(KERNEL_VERSION)/kernel/fs/exportfs/exportfs.ko $(RELEASE_DIR)/lib/modules/ || true
	[ -e $(TARGETPREFIX)/lib/modules/$(KERNEL_VERSION)/kernel/fs/nfs_common/nfs_acl.ko ] && cp $(TARGETPREFIX)/lib/modules/$(KERNEL_VERSION)/kernel/fs/nfs_common/nfs_acl.ko $(RELEASE_DIR)/lib/modules/ || true
	[ -e $(TARGETPREFIX)/lib/modules/$(KERNEL_VERSION)/kernel/fs/nfs/nfs.ko ] && cp $(TARGETPREFIX)/lib/modules/$(KERNEL_VERSION)/kernel/fs/nfs/nfs.ko $(RELEASE_DIR)/lib/modules/ || true
	[ -e $(TARGETPREFIX)/lib/modules/$(KERNEL_VERSION)/extra/sata_switch/sata.ko ] && cp $(TARGETPREFIX)/lib/modules/$(KERNEL_VERSION)/extra/sata_switch/sata.ko $(RELEASE_DIR)/lib/modules/ || true
	[ -e $(TARGETPREFIX)/lib/modules/$(KERNEL_VERSION)/kernel/fs/mini_fo/mini_fo.ko ] && cp $(TARGETPREFIX)/lib/modules/$(KERNEL_VERSION)/kernel/fs/mini_fo/mini_fo.ko $(RELEASE_DIR)/lib/modules/ || true
#
# wlan
#
	[ -e $(TARGETPREFIX)/lib/modules/$(KERNEL_VERSION)/extra/wireless/rt2870sta/rt2870sta.ko ] && cp $(TARGETPREFIX)/lib/modules/$(KERNEL_VERSION)/extra/wireless/rt2870sta/rt2870sta.ko $(RELEASE_DIR)/lib/modules/ || true
	[ -e $(TARGETPREFIX)/lib/modules/$(KERNEL_VERSION)/extra/wireless/rt3070sta/rt3070sta.ko ] && cp $(TARGETPREFIX)/lib/modules/$(KERNEL_VERSION)/extra/wireless/rt3070sta/rt3070sta.ko $(RELEASE_DIR)/lib/modules/ || true
	[ -e $(TARGETPREFIX)/lib/modules/$(KERNEL_VERSION)/extra/wireless/rt5370sta/rt5370sta.ko ] && cp $(TARGETPREFIX)/lib/modules/$(KERNEL_VERSION)/extra/wireless/rt5370sta/rt5370sta.ko $(RELEASE_DIR)/lib/modules/ || true
	[ -e $(TARGETPREFIX)/lib/modules/$(KERNEL_VERSION)/extra/wireless/rtl871x/8712u.ko ] && cp $(TARGETPREFIX)/lib/modules/$(KERNEL_VERSION)/extra/wireless/rtl871x/8712u.ko $(RELEASE_DIR)/lib/modules/ || true
	[ -e $(TARGETPREFIX)/lib/modules/$(KERNEL_VERSION)/extra/wireless/rtl8188eu/8188eu.ko ] && cp $(TARGETPREFIX)/lib/modules/$(KERNEL_VERSION)/extra/wireless/rtl8188eu/8188eu.ko $(RELEASE_DIR)/lib/modules/ || true
	[ -e $(TARGETPREFIX)/lib/modules/$(KERNEL_VERSION)/extra/wireless/rtl8192cu/8192cu.ko ] && cp $(TARGETPREFIX)/lib/modules/$(KERNEL_VERSION)/extra/wireless/rtl8192cu/8192cu.ko $(RELEASE_DIR)/lib/modules/ || true
	[ -e $(TARGETPREFIX)/lib/modules/$(KERNEL_VERSION)/extra/wireless/rtl8192du/8192du.ko ] && cp $(TARGETPREFIX)/lib/modules/$(KERNEL_VERSION)/extra/wireless/rtl8192du/8192du.ko $(RELEASE_DIR)/release/lib/modules || true
ifeq ($(IMAGE), $(filter $(IMAGE), enigma2-wlandriver neutrino-wlandriver))
	install -d $(RELEASE_DIR)/etc/Wireless
	cp -aR $(SKEL_ROOT)/firmware/Wireless/* $(RELEASE_DIR)/etc/Wireless/
	cp -dp $(TARGETPREFIX)/usr/sbin/ifrename $(RELEASE_DIR)/usr/sbin/
	cp -dp $(TARGETPREFIX)/usr/sbin/iwconfig $(RELEASE_DIR)/usr/sbin/
	cp -dp $(TARGETPREFIX)/usr/sbin/iwevent $(RELEASE_DIR)/usr/sbin/
	cp -dp $(TARGETPREFIX)/usr/sbin/iwgetid $(RELEASE_DIR)/usr/sbin/
	cp -dp $(TARGETPREFIX)/usr/sbin/iwlist $(RELEASE_DIR)/usr/sbin/
	cp -dp $(TARGETPREFIX)/usr/sbin/iwpriv $(RELEASE_DIR)/usr/sbin/
	cp -dp $(TARGETPREFIX)/usr/sbin/iwspy $(RELEASE_DIR)/usr/sbin/
	cp -dp $(TARGETPREFIX)/usr/sbin/wpa_cli $(RELEASE_DIR)/usr/sbin/
	cp -dp $(TARGETPREFIX)/usr/sbin/wpa_passphrase $(RELEASE_DIR)/usr/sbin/
	cp -dp $(TARGETPREFIX)/usr/sbin/wpa_supplicant $(RELEASE_DIR)/usr/sbin/
endif
#
# lib usr/lib
#
	cp -R $(TARGETPREFIX)/lib/* $(RELEASE_DIR)/lib/
	rm -f $(RELEASE_DIR)/lib/*.{a,o,la}
	chmod 755 $(RELEASE_DIR)/lib/*
	cp -R $(TARGETPREFIX)/usr/lib/* $(RELEASE_DIR)/usr/lib/
	rm -rf $(RELEASE_DIR)/usr/lib/{engines,enigma2,gconv,libxslt-plugins,pkgconfig,python$(PYTHON_VERSION),sigc++-1.2,sigc++-2.0}
	rm -f $(RELEASE_DIR)/usr/lib/*.{a,o,la}
	chmod 755 $(RELEASE_DIR)/usr/lib/*
#
# fonts
#
	cp $(SKEL_ROOT)/root_enigma2/usr/share/fonts/* $(RELEASE_DIR)/usr/share/fonts/
	cp $(TARGETPREFIX)/usr/local/share/fonts/* $(RELEASE_DIR)/usr/share/fonts/
	ln -s /usr/share/fonts $(RELEASE_DIR)/usr/local/share/fonts
#
# enigma2
#
	if [ -e $(TARGETPREFIX)/usr/bin/enigma2 ]; then \
		cp -f $(TARGETPREFIX)/usr/bin/enigma2 $(RELEASE_DIR)/usr/local/bin/enigma2; \
	fi
	if [ -e $(TARGETPREFIX)/usr/local/bin/enigma2 ]; then \
		cp -f $(TARGETPREFIX)/usr/local/bin/enigma2 $(RELEASE_DIR)/usr/local/bin/enigma2; \
	fi
	cp -a $(TARGETPREFIX)/usr/local/share/enigma2/* $(RELEASE_DIR)/usr/local/share/enigma2
	cp $(SKEL_ROOT)/root_enigma2/etc/enigma2/* $(RELEASE_DIR)/etc/enigma2
	ln -s /usr/local/share/enigma2 $(RELEASE_DIR)/usr/share/enigma2
	ln -sf /etc/timezone.xml $(RELEASE_DIR)/etc/tuxbox/timezone.xml
	install -d $(RELEASE_DIR)/usr/lib/enigma2
	cp -a $(TARGETPREFIX)/usr/lib/enigma2/* $(RELEASE_DIR)/usr/lib/enigma2/
	if test -d $(TARGETPREFIX)/usr/local/lib/enigma2; then \
		cp -a $(TARGETPREFIX)/usr/local/lib/enigma2/* $(RELEASE_DIR)/usr/lib/enigma2; \
	fi
#
# copy root_enigma2
#
	cp -aR $(SKEL_ROOT)/root_enigma2/etc/* $(RELEASE_DIR)/etc/
#
# python2.7
#
	if [ $(PYTHON_VERSION) == 2.7 ]; then \
		install -d $(RELEASE_DIR)/usr/include; \
		install -d $(RELEASE_DIR)$(PYTHON_INCLUDE_DIR); \
		cp $(TARGETPREFIX)$(PYTHON_INCLUDE_DIR)/pyconfig.h $(RELEASE_DIR)$(PYTHON_INCLUDE_DIR); \
	fi
#
# tuxtxt
#
	if [ -e $(TARGETPREFIX)/usr/bin/tuxtxt ]; then \
		cp -p $(TARGETPREFIX)/usr/bin/tuxtxt $(RELEASE_DIR)/usr/bin/; \
	fi
#
# hotplug
#
	if [ -e $(TARGETPREFIX)/usr/bin/hotplug_e2_helper ]; then \
		cp -dp $(TARGETPREFIX)/usr/bin/hotplug_e2_helper $(RELEASE_DIR)/sbin/hotplug; \
		cp -dp $(TARGETPREFIX)/usr/bin/bdpoll $(RELEASE_DIR)/sbin/; \
	else \
		cp -dp $(TARGETPREFIX)/sbin/hotplug $(RELEASE_DIR)/sbin/; \
	fi
#
# alsa
#
	if [ -e $(TARGETPREFIX)/usr/share/alsa ]; then \
		mkdir -p $(RELEASE_DIR)/usr/share/alsa/; \
		mkdir $(RELEASE_DIR)/usr/share/alsa/cards/; \
		mkdir $(RELEASE_DIR)/usr/share/alsa/pcm/; \
		cp -dp $(TARGETPREFIX)/usr/share/alsa/alsa.conf $(RELEASE_DIR)/usr/share/alsa/alsa.conf; \
		cp $(TARGETPREFIX)/usr/share/alsa/cards/aliases.conf $(RELEASE_DIR)/usr/share/alsa/cards/; \
		cp $(TARGETPREFIX)/usr/share/alsa/pcm/default.conf $(RELEASE_DIR)/usr/share/alsa/pcm/; \
		cp $(TARGETPREFIX)/usr/share/alsa/pcm/dmix.conf $(RELEASE_DIR)/usr/share/alsa/pcm/; \
		cp $(TARGETPREFIX)/usr/bin/amixer $(RELEASE_DIR)/usr/bin/; \
	fi
#
# nfs-utils
#
	if [ -e $(TARGETPREFIX)/usr/sbin/rpc.nfsd ]; then \
		cp -f $(TARGETPREFIX)/usr/sbin/exportfs $(RELEASE_DIR)/usr/sbin/; \
		cp -f $(TARGETPREFIX)/usr/sbin/rpc.nfsd $(RELEASE_DIR)/usr/sbin/; \
		cp -f $(TARGETPREFIX)/usr/sbin/rpc.mountd $(RELEASE_DIR)/usr/sbin/; \
		cp -f $(TARGETPREFIX)/usr/sbin/rpc.statd $(RELEASE_DIR)/usr/sbin/; \
	fi
#
# autofs
#
	if [ -d $(RELEASE_DIR)/usr/lib/autofs ]; then \
		cp -f $(TARGETPREFIX)/usr/sbin/automount $(RELEASE_DIR)/usr/sbin/; \
		ln -s /usr/sbin/automount $(RELEASE_DIR)/sbin/automount; \
	fi
#
# gstreamer
#
	if [ -d $(RELEASE_DIR)/usr/lib/gstreamer-1.0 ]; then \
		rm -rf $(RELEASE_DIR)/usr/lib/gstreamer-1.0/*; \
		cp -a $(TARGETPREFIX)/usr/bin/gst-* $(RELEASE_DIR)/usr/bin/; \
		sh4-linux-strip --strip-unneeded $(RELEASE_DIR)/usr/bin/gst-launch*; \
		cp -a $(TARGETPREFIX)/usr/lib/gstreamer-1.0/libgst*.so $(RELEASE_DIR)/usr/lib/gstreamer-1.0/; \
		sh4-linux-strip --strip-unneeded $(RELEASE_DIR)/usr/lib/gstreamer-1.0/*; \
	fi
#
# graphlcd
#
	if [ -e $(RELEASE_DIR)/usr/lib/libglcddrivers.so ]; then \
		cp -f $(TARGETPREFIX)/etc/graphlcd.conf $(RELEASE_DIR)/etc/; \
	fi
#
# lcd4linux
#
	if [ -e $(TARGETPREFIX)/usr/bin/lcd4linux ]; then \
		cp -f $(TARGETPREFIX)/usr/bin/lcd4linux $(RELEASE_DIR)/usr/bin/; \
		cp -f $(TARGETPREFIX)/etc/init.d/lcd4linux $(RELEASE_DIR)/etc/init.d/; \
		cp -a $(TARGETPREFIX)/etc/lcd4linux.conf $(RELEASE_DIR)/etc/; \
	fi
#
# minidlna
#
	if [ -e $(TARGETPREFIX)/usr/sbin/minidlnad ]; then \
		cp -f $(TARGETPREFIX)/usr/sbin/minidlnad $(RELEASE_DIR)/usr/sbin/; \
	fi
#
# openvpn
#
	if [ -e $(TARGETPREFIX)/usr/sbin/openvpn ]; then \
		cp -f $(TARGETPREFIX)/usr/sbin/openvpn $(RELEASE_DIR)/usr/sbin; \
		install -d $(RELEASE_DIR)/etc/openvpn; \
	fi
#
# udpxy
#
	if [ -e $(TARGETPREFIX)/usr/bin/udpxy ]; then \
		cp -f $(TARGETPREFIX)/usr/bin/udpxy $(RELEASE_DIR)/usr/bin; \
		cp -a $(TARGETPREFIX)/usr/bin/udpxrec $(RELEASE_DIR)/usr/bin; \
	fi
#
# directfb
#
	if [ -d $(RELEASE_DIR)/usr/lib/directfb-1.4-5 ]; then \
		rm -rf $(RELEASE_DIR)/usr/lib/directfb-1.4-5/gfxdrivers/*.{a,o,la}; \
		rm -rf $(RELEASE_DIR)/usr/lib/directfb-1.4-5/inputdrivers/*; \
		cp -a $(TARGETPREFIX)/usr/lib/directfb-1.4-5/inputdrivers/libdirectfb_enigma2remote.so $(RELEASE_DIR)/usr/lib/directfb-1.4-5/inputdrivers/; \
		cp -a $(TARGETPREFIX)/usr/lib/directfb-1.4-5/inputdrivers/libdirectfb_linux_input.so $(RELEASE_DIR)/usr/lib/directfb-1.4-5/inputdrivers/; \
		rm -rf $(RELEASE_DIR)/usr/lib/directfb-1.4-5/systems/*.{a,o,la}; \
		rm -rf $(RELEASE_DIR)/usr/lib/directfb-1.4-5/systems/libdirectfb_dummy.so; \
		rm -rf $(RELEASE_DIR)/usr/lib/directfb-1.4-5/systems/libdirectfb_fbdev.so; \
		rm -rf $(RELEASE_DIR)/usr/lib/directfb-1.4-5/wm/*.{a,o,la}; \
		rm -rf $(RELEASE_DIR)/usr/lib/directfb-1.4-5/interfaces/IDirectFBFont/*.{a,o,la}; \
		rm -rf $(RELEASE_DIR)/usr/lib/directfb-1.4-5/interfaces/IDirectFBImageProvider/*.{a,o,la}; \
		rm -rf $(RELEASE_DIR)/usr/lib/directfb-1.4-5/interfaces/IDirectFBVideoProvider/*.{a,o,la}; \
	fi
	if [ -d $(RELEASE_DIR)/usr/lib/icu ]; then \
		rm -rf $(RELEASE_DIR)/usr/lib/icu; \
	fi
	if [ -d $(RELEASE_DIR)/usr/lib/glib-2.0 ]; then \
		rm -rf $(RELEASE_DIR)/usr/lib/glib-2.0; \
	fi
	if [ -d $(RELEASE_DIR)/usr/lib/enchant ]; then \
		rm -rf $(RELEASE_DIR)/usr/lib/enchant; \
	fi
#
# DVB-T USB
#
	if [ -e $(TARGETPREFIX)/lib/modules/$(KERNEL_VERSION)/extra/dvbt/as102/dvb-as102.ko ]; then \
		cp $(TARGETPREFIX)/lib/modules/$(KERNEL_VERSION)/extra/dvbt/as102/dvb-as102.ko $(RELEASE_DIR)/lib/modules/; \
		cp $(SKEL_ROOT)/firmware/as102_data1_st.hex $(RELEASE_DIR)/lib/firmware/; \
		cp $(SKEL_ROOT)/firmware/as102_data2_st.hex $(RELEASE_DIR)/lib/firmware/; \
	fi
	if [ -e $(TARGETPREFIX)/lib/modules/$(KERNEL_VERSION)/extra/dvbt/siano/ ]; then \
		cp $(TARGETPREFIX)/lib/modules/$(KERNEL_VERSION)/extra/dvbt/siano/* $(RELEASE_DIR)/lib/modules/; \
		cp $(SKEL_ROOT)/firmware/dvb_nova_12mhz_b0.inp $(RELEASE_DIR)/lib/firmware/; \
	fi
#
# delete unnecessary files
#
ifeq ($(BOXTYPE), $(filter $(BOXTYPE), ufs910 ufs922))
	rm -f $(RELEASE_DIR)/sbin/jfs_fsck
	rm -f $(RELEASE_DIR)/sbin/fsck.jfs
	rm -f $(RELEASE_DIR)/sbin/jfs_mkfs
	rm -f $(RELEASE_DIR)/sbin/mkfs.jfs
	rm -f $(RELEASE_DIR)/sbin/jfs_tune
endif
	rm -rf $(RELEASE_DIR)/lib/autofs
	rm -rf $(RELEASE_DIR)/usr/lib/m4-nofpu/
	rm -rf $(RELEASE_DIR)/lib/modules/$(KERNEL_VERSION)
	rm -rf $(RELEASE_DIR)/usr/lib/gcc
	rm -f $(RELEASE_DIR)/usr/lib/libc.so
	rm -rf $(RELEASE_DIR)/usr/lib/enigma2/python/Plugins/DemoPlugins
	rm -rf $(RELEASE_DIR)/usr/lib/enigma2/python/Plugins/SystemPlugins/FrontprocessorUpgrade
	rm -rf $(RELEASE_DIR)/usr/lib/enigma2/python/Plugins/SystemPlugins/NFIFlash
	rm -rf $(RELEASE_DIR)/usr/lib/enigma2/python/Plugins/Extensions/FileManager
	rm -rf $(RELEASE_DIR)/usr/lib/enigma2/python/Plugins/Extensions/TuxboxPlugins
	install -d $(RELEASE_DIR)$(PYTHON_DIR)
	cp -a $(TARGETPREFIX)$(PYTHON_DIR)/* $(RELEASE_DIR)$(PYTHON_DIR)/
	rm -rf $(RELEASE_DIR)$(PYTHON_DIR)/{bsddb,compiler,curses,distutils,lib-old,lib-tk,plat-linux3,test}
	rm -rf $(RELEASE_DIR)$(PYTHON_DIR)/ctypes/test
	rm -rf $(RELEASE_DIR)$(PYTHON_DIR)/email/test
	rm -rf $(RELEASE_DIR)$(PYTHON_DIR)/json/tests
	rm -rf $(RELEASE_DIR)$(PYTHON_DIR)/lib2to3/tests
	rm -rf $(RELEASE_DIR)$(PYTHON_DIR)/sqlite3/test
	rm -rf $(RELEASE_DIR)$(PYTHON_DIR)/unittest/test
	rm -rf $(RELEASE_DIR)$(PYTHON_DIR)/site-packages/twisted/{test,conch,mail,names,news,words,flow,lore,pair,runner}
	rm -rf $(RELEASE_DIR)$(PYTHON_DIR)/site-packages/Cheetah/Tests
	rm -rf $(RELEASE_DIR)$(PYTHON_DIR)/site-packages/livestreamer_cli
	rm -rf $(RELEASE_DIR)$(PYTHON_DIR)/site-packages/lxml
	rm -f $(RELEASE_DIR)$(PYTHON_DIR)/site-packages/libxml2mod.so
	rm -f $(RELEASE_DIR)$(PYTHON_DIR)/site-packages/libxsltmod.so
	rm -rf $(RELEASE_DIR)$(PYTHON_DIR)/site-packages/OpenSSL/test
	rm -rf $(RELEASE_DIR)$(PYTHON_DIR)/site-packages/setuptools
	rm -rf $(RELEASE_DIR)$(PYTHON_DIR)/site-packages/zope/interface/tests
	rm -rf $(RELEASE_DIR)$(PYTHON_DIR)/site-packages/twisted/application/test
	rm -rf $(RELEASE_DIR)$(PYTHON_DIR)/site-packages/twisted/conch/test
	rm -rf $(RELEASE_DIR)$(PYTHON_DIR)/site-packages/twisted/internet/test
	rm -rf $(RELEASE_DIR)$(PYTHON_DIR)/site-packages/twisted/lore/test
	rm -rf $(RELEASE_DIR)$(PYTHON_DIR)/site-packages/twisted/mail/test
	rm -rf $(RELEASE_DIR)$(PYTHON_DIR)/site-packages/twisted/manhole/test
	rm -rf $(RELEASE_DIR)$(PYTHON_DIR)/site-packages/twisted/names/test
	rm -rf $(RELEASE_DIR)$(PYTHON_DIR)/site-packages/twisted/news/test
	rm -rf $(RELEASE_DIR)$(PYTHON_DIR)/site-packages/twisted/pair/test
	rm -rf $(RELEASE_DIR)$(PYTHON_DIR)/site-packages/twisted/persisted/test
	rm -rf $(RELEASE_DIR)$(PYTHON_DIR)/site-packages/twisted/protocols/test
	rm -rf $(RELEASE_DIR)$(PYTHON_DIR)/site-packages/twisted/python/test
	rm -rf $(RELEASE_DIR)$(PYTHON_DIR)/site-packages/twisted/runner/test
	rm -rf $(RELEASE_DIR)$(PYTHON_DIR)/site-packages/twisted/scripts/test
	rm -rf $(RELEASE_DIR)$(PYTHON_DIR)/site-packages/twisted/test
	rm -rf $(RELEASE_DIR)$(PYTHON_DIR)/site-packages/twisted/trial/test
	rm -rf $(RELEASE_DIR)$(PYTHON_DIR)/site-packages/twisted/web/test
	rm -rf $(RELEASE_DIR)$(PYTHON_DIR)/site-packages/twisted/words/test
	rm -rf $(RELEASE_DIR)$(PYTHON_DIR)/site-packages/*-py$(PYTHON_VERSION).egg-info
#
# delete unnecessary remote control files and VFD plugins
#
	cp -f $(SKEL_ROOT)/release/rc_spark.png $(RELEASE_DIR)/usr/local/share/enigma2/rc_models/spark.png
	cp -f $(SKEL_ROOT)/release/rc_fs9000.png $(RELEASE_DIR)/usr/local/share/enigma2/rc_models/fs9000.png
	cp -f $(SKEL_ROOT)/release/rc_hs9510.png $(RELEASE_DIR)/usr/local/share/enigma2/rc_models/hs9510.png
	cp -f $(SKEL_ROOT)/release/rc_hs7110.png $(RELEASE_DIR)/usr/local/share/enigma2/rc_models/hs7110.png
	cp -f $(SKEL_ROOT)/release/rc_tf7700.png $(RELEASE_DIR)/usr/local/share/enigma2/rc_models/tf7700.png
# delete mips remote control files
	rm -rf $(RELEASE_DIR)/usr/local/share/enigma2/rc_models/et4x00.*
	rm -rf $(RELEASE_DIR)/usr/local/share/enigma2/rc_models/et6x00.*
	rm -rf $(RELEASE_DIR)/usr/local/share/enigma2/rc_models/et7x00.*
	rm -rf $(RELEASE_DIR)/usr/local/share/enigma2/rc_models/et8000.*
	rm -rf $(RELEASE_DIR)/usr/local/share/enigma2/rc_models/et9x00.*
	rm -rf $(RELEASE_DIR)/usr/local/share/enigma2/rc_models/et9500.*
	rm -rf $(RELEASE_DIR)/usr/local/share/enigma2/rc_models/formuler1.*
	rm -rf $(RELEASE_DIR)/usr/local/share/enigma2/rc_models/hd1100.*
	rm -rf $(RELEASE_DIR)/usr/local/share/enigma2/rc_models/hd2400.*
	rm -rf $(RELEASE_DIR)/usr/local/share/enigma2/rc_models/vu*.*
	rm -rf $(RELEASE_DIR)/usr/local/share/enigma2/rc_models/xp1000.*

	if [[ ! ENABLE_SPARK7162 && ! ENABLE_SPARK ]]; then \
		rm -rf $(RELEASE_DIR)/usr/local/share/enigma2/rc_models/spark/*; \
		rmdir $(RELEASE_DIR)/usr/local/share/enigma2/rc_models/spark; \
	fi
	if [[ ! ENABLE_HDBOX && ! ENABLE_ATEVIO7500 ]]; then \
		rm -rf $(RELEASE_DIR)/usr/local/share/enigma2/rc_models/fs9000/*; \
		rmdir $(RELEASE_DIR)/usr/local/share/enigma2/rc_models/fs9000; \
	fi
	if [[ ! ENABLE_OCTAGON1008 && ! ENABLE_HS7420 && ! ENABLE_HS7810A && ! ENABLE_HS7429 && ! ENABLE_HS7819 ]]; then \
		rm -rf $(RELEASE_DIR)/usr/local/share/enigma2/rc_models/hs9510/*; \
		rmdir $(RELEASE_DIR)/usr/local/share/enigma2/rc_models/hs9510; \
	fi
	if [[ ! ENABLE_HS7110 && ! ENABLE_HS7119 ]]; then \
		rm -rf $(RELEASE_DIR)/usr/local/share/enigma2/rc_models/hs7110/*; \
		rmdir $(RELEASE_DIR)/usr/local/share/enigma2/rc_models/hs7110; \
	fi
	if [[ ! ENABLE_TF7700 ]]; then \
		rm -rf $(RELEASE_DIR)/usr/local/share/enigma2/rc_models/tf7700/*; \
		rmdir $(RELEASE_DIR)/usr/local/share/enigma2/rc_models/tf7700; \
	fi
#
# Complete the videomode selection picture set
#
	if [ -e $(TARGETPREFIX)/usr/lib/enigma2/python/Plugins/SystemPlugins/Videomode/YPbPr.png ]; then \
		cp -rf $(TARGETPREFIX)/usr/lib/enigma2/python/Plugins/SystemPlugins/Videomode/YPbPr.png $(RELEASE_DIR)/usr/lib/enigma2/python/Plugins/SystemPlugins/Videomode/Component.png; \
		cp -rf $(TARGETPREFIX)/usr/lib/enigma2/python/Plugins/SystemPlugins/Videomode/lcd_YPbPr.png $(RELEASE_DIR)/usr/lib/enigma2/python/Plugins/SystemPlugins/Videomode/lcd_Component.png; \
	fi
	echo "$(BOXTYPE)" > $(RELEASE_DIR)/etc/model
#
# The main target depends on the model.
#
$(D)/release_enigma2: \
$(D)/%release_enigma2: release_enigma2_base release_enigma2_$(BOXTYPE)
#
# Do not remove pyo files, remove pyc instead
#
	find $(RELEASE_DIR)/usr/lib/enigma2/ -name '*.pyc' -exec rm -f {} \;
ifeq ($(OPTIMIZATIONS), size)
ifneq ($(BOXTYPE), atevio7500)
	find $(RELEASE_DIR)/usr/lib/enigma2/ -not -name 'mytest.py' -name '*.py' -exec rm -f {} \;
else
	find $(RELEASE_DIR)/usr/lib/enigma2/ -not -name 'mytest.py' -not -name 'Language.py' -name '*.py' -exec rm -f {} \;
endif
endif
	find $(RELEASE_DIR)/usr/lib/enigma2/ -name '*.a' -exec rm -f {} \;
	find $(RELEASE_DIR)/usr/lib/enigma2/ -name '*.o' -exec rm -f {} \;
	find $(RELEASE_DIR)/usr/lib/enigma2/ -name '*.la' -exec rm -f {} \;
	find $(RELEASE_DIR)$(PYTHON_DIR)/ -name '*.pyc' -exec rm -f {} \;
ifeq ($(OPTIMIZATIONS), size)
	find $(RELEASE_DIR)$(PYTHON_DIR)/ -name '*.py' -exec rm -f {} \;
endif
	find $(RELEASE_DIR)$(PYTHON_DIR)/ -name '*.a' -exec rm -f {} \;
	find $(RELEASE_DIR)$(PYTHON_DIR)/ -name '*.c' -exec rm -f {} \;
	find $(RELEASE_DIR)$(PYTHON_DIR)/ -name '*.pyx' -exec rm -f {} \;
	find $(RELEASE_DIR)$(PYTHON_DIR)/ -name '*.o' -exec rm -f {} \;
	find $(RELEASE_DIR)$(PYTHON_DIR)/ -name '*.la' -exec rm -f {} \;
	$(TUXBOX_CUSTOMIZE)
	$(TOUCH)
#
# FOR YOUR OWN CHANGES use these folder in cdk/own_build/enigma2
#
#	default for all receiver
	find $(CDK_DIR)/own_build/enigma2/ -mindepth 1 -maxdepth 1 -exec cp -at$(RELEASE_DIR)/ -- {} +
#	receiver specific (only if directory exist)
	[ -d "$(CDK_DIR)/own_build/enigma2.$(BOXTYPE)" ] && find $(CDK_DIR)/own_build/enigma2.$(BOXTYPE)/ -mindepth 1 -maxdepth 1 -exec cp -at$(RELEASE_DIR)/ -- {} + || true
	rm -f $(RELEASE_DIR)/for_your_own_changes
#
# sh4-linux-strip all
#
ifneq ($(OPTIMIZATIONS), $(filter $(OPTIMIZATIONS), kerneldebug debug))
	find $(RELEASE_DIR)/ -name '*' -exec $(TARGET)-strip --strip-unneeded {} &>/dev/null \;
endif
#
# release-clean
#
release-enigma2-clean:
	rm -f $(D)/release
