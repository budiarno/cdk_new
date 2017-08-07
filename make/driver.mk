#
# driver
#
driver-clean:
	$(MAKE) -C $(DRIVER_DIR) ARCH=sh KERNEL_LOCATION=$(KERNEL_DIR) distclean
	rm -f $(D)/driver
#	rm -f $(D)/driver-symlink

driver-symlink:
	$(SILENT)set -e; cd $(DRIVER_DIR); \
		rm -f player2 multicom; \
		ln -s $(PLAYER2_LINK) player2; \
		ln -s $(MULTICOM_LINK) multicom; \
		rm -f .config; printf "export CONFIG_PLAYER_$(PLAYER_VER)=y\nexport CONFIG_MULTICOM$(MULTICOM_VER)=y\n" > .config; \
		cd include; \
		rm -f stmfb player2 multicom; \
		ln -s stmfb-3.1_stm24_0104 stmfb; \
		ln -s $(PLAYER2_LINK) player2; \
		ln -s ../$(MULTICOM_LINK)/include multicom; \
		cd ../stgfb; \
		rm -f stmfb; \
		ln -s stmfb-3.1_stm24_0104 stmfb
	$(SILENT)cp $(DRIVER_DIR)/stgfb/stmfb/linux/drivers/video/stmfb.h $(TARGET_DIR)/usr/include/linux
	$(SILENT)cp $(DRIVER_DIR)/player2/linux/include/linux/dvb/stm_ioctls.h $(TARGET_DIR)/usr/include/linux/dvb
	$(if $(PLAYERXXX),cp $(DRIVER_DIR)/player2/linux/include/linux/dvb/stm_audio.h $(TARGET_DIR)/usr/include/linux/dvb)
	$(if $(PLAYERXXX),cp $(DRIVER_DIR)/player2/linux/include/linux/dvb/stm_dvb.h $(TARGET_DIR)/usr/include/linux/dvb)
	$(if $(PLAYERXXX),cp $(DRIVER_DIR)/player2/linux/include/linux/dvb/stm_video.h $(TARGET_DIR)/usr/include/linux/dvb)
	$(SILENT)touch $(D)/$(notdir $@)

$(D)/driver: $(DRIVER_DIR)/Makefile $(D)/bootstrap $(D)/linux-kernel
	$(START_BUILD)
	$(MAKE) -C $(DRIVER_DIR) ARCH=sh CONFIG_DEBUG_SECTION_MISMATCH=y \
		CONFIG_MODULES_PATH=$(CROSS_DIR)/target \
		KERNEL_LOCATION=$(KERNEL_DIR) \
		DRIVER_TOPDIR=$(DRIVER_DIR) \
		$(DRIVER_PLATFORM) \
		CROSS_COMPILE=$(TARGET)-
	$(MAKE) -C $(DRIVER_DIR) ARCH=sh CONFIG_DEBUG_SECTION_MISMATCH=y \
		CONFIG_MODULES_PATH=$(CROSS_DIR)/target \
		KERNEL_LOCATION=$(KERNEL_DIR) \
		DRIVER_TOPDIR=$(DRIVER_DIR) \
		$(DRIVER_PLATFORM) \
		CROSS_COMPILE=$(TARGET)- \
		BIN_DEST=$(TARGET_DIR)/bin \
		INSTALL_MOD_PATH=$(TARGET_DIR) \
		install
	$(DEPMOD) -ae -b $(TARGET_DIR) -F $(KERNEL_DIR)/System.map -r $(KERNEL_VERSION)
	$(TOUCH)
