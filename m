Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:40757 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751085AbcESFNX (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 19 May 2016 01:13:23 -0400
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz, Anand Jain <anand.jain@oracle.com>
Subject: [PATCH 1/3] btrfs-progs: fix make install failure
Date: Thu, 19 May 2016 13:13:12 +0800
Message-Id: <1463634794-591-2-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1463634794-591-1-git-send-email-anand.jain@oracle.com>
References: <1463634794-591-1-git-send-email-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

/usr/bin/install -c -m644 -d 64-btrfs-dm.rules /usr/lib/udev/rules.d
/usr/bin/install: cannot create directory ‘64-btrfs-dm.rules’: File exists
Makefile:400: recipe for target 'install' failed
make: *** [install] Error 1

fixes: btrfs-progs: udev: add rules for dm devices

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 Makefile.in | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Makefile.in b/Makefile.in
index 47e73c9fbc4e..238dd59badaf 100644
--- a/Makefile.in
+++ b/Makefile.in
@@ -408,7 +408,7 @@ install: $(libs) $(progs_install) $(INSTALLDIRS)
 	$(INSTALL) -m755 -d $(DESTDIR)$(incdir)
 	$(INSTALL) -m644 $(headers) $(DESTDIR)$(incdir)
 ifneq ($(udevdir),)
-	$(INSTALL) -m644 -d $(udev_rules) $(DESTDIR)$(udevruledir)
+	$(INSTALL) -m644 $(udev_rules) $(DESTDIR)$(udevruledir)
 endif
 
 install-static: $(progs_static) $(INSTALLDIRS)
-- 
2.7.0

