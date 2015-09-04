Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail2.unitix.de ([176.9.125.4]:48987 "EHLO mail2.unitix.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933992AbbIDXMw (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 4 Sep 2015 19:12:52 -0400
From: Arnd Hannemann <arnd@arndnet.de>
To: linux-btrfs@vger.kernel.org
Cc: Arnd Hannemann <arnd@arndnet.de>
Subject: [PATCH] btrfs-progs: makefile: drop u option from ar invocation
Date: Sat,  5 Sep 2015 01:06:18 +0200
Message-Id: <1441407978-23061-1-git-send-email-arnd@arndnet.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

In newer distros (ubuntu 15.10, fedora rawhide) the binutils
ar uses the new D flag per default to build deterministic
binaries.
Without this patch the following warning is issued, when
building btrfs-progs:

    [AR]     libbtrfs.a
/usr/bin/ar: `u' modifier ignored since `D' is the default (see `U')

For libtrfs.a performance benefit of the u option can be neglected,
so drop the u option and silence the warning.

In the future one might want to explicitly add the D option anyway.

Signed-off-by: Arnd Hannemann <arnd@arndnet.de>
---
 Makefile.in | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Makefile.in b/Makefile.in
index 665f83c..514a76f 100644
--- a/Makefile.in
+++ b/Makefile.in
@@ -199,7 +199,7 @@ $(libs_shared): $(libbtrfs_objects) $(lib_links) send.h
 
 $(libs_static): $(libbtrfs_objects)
 	@echo "    [AR]     $@"
-	$(Q)$(AR) cru libbtrfs.a $(libbtrfs_objects)
+	$(Q)$(AR) cr libbtrfs.a $(libbtrfs_objects)
 
 $(lib_links):
 	@echo "    [LN]     $@"
-- 
2.5.0

