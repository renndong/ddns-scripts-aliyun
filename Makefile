include $(TOPDIR)/rules.mk

PKG_NAME:=ddns-scripts-aliyun
PKG_VERSION:=1.0.1
PKG_RELEASE:=1

PKG_LICENSE:=GPL-2.0

include $(INCLUDE_DIR)/package.mk

define Package/ddns-scripts-aliyun
  SECTION:=net
  CATEGORY:=Network
  SUBMENU:=IP Addresses and Names
  PKGARCH:=all
  TITLE:=Extension for aliyun.com DNS API
  DEPENDS:=ddns-scripts +curl +openssl-util
endef

define Package/ddns-scripts-aliyun/description
  Dynamic DNS Client scripts extension for aliyun.com API
endef

define Build/Configure
endef

define Build/Compile
endef

define Package/ddns-scripts-aliyun/install
	$(INSTALL_DIR) $(1)/usr/lib/ddns
	$(INSTALL_BIN) ./files/usr/lib/ddns/update_aliyun_com.sh \
		$(1)/usr/lib/ddns

	$(INSTALL_DIR) $(1)/usr/share/ddns/default
	$(INSTALL_DATA) ./files/usr/share/ddns/default/aliyun.com.json \
		$(1)/usr/share/ddns/default/
endef

define Package/ddns-scripts-aliyun/prerm
#!/bin/sh
if [ -z "$${IPKG_INSTROOT}" ]; then
	/etc/init.d/ddns stop
fi
exit 0
endef

$(eval $(call BuildPackage,ddns-scripts-aliyun))