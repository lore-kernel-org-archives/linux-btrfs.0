Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.windriver.com ([147.11.1.11]:64698 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754103Ab3ICBwF (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 2 Sep 2013 21:52:05 -0400
Received: from ALA-HCB.corp.ad.wrs.com (ala-hcb.corp.ad.wrs.com [147.11.189.41])
	by mail.windriver.com (8.14.5/8.14.3) with ESMTP id r831q3IZ016578
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=FAIL)
	for <linux-btrfs@vger.kernel.org>; Mon, 2 Sep 2013 18:52:04 -0700 (PDT)
From: <rongqing.li@windriver.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] btrfs-progs: fix parallel build
Date: Tue, 3 Sep 2013 09:52:12 +0800
Message-ID: <1378173132-15270-1-git-send-email-rongqing.li@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: "Roy.Li" <rongqing.li@windriver.com>

Parallel execution of "make install" may fail due to late creation of
version.h, fix it by adding the dependence on version.h.

The fix is similar to 7aaf00fc[btrfs-progs: fix parallel build]

Signed-off-by: Roy.Li <rongqing.li@windriver.com>
---
 Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Makefile b/Makefile
index c43cb68..40ef205 100644
--- a/Makefile
+++ b/Makefile
@@ -190,7 +190,7 @@ clean :
 	      $(libs) $(lib_links)
 	$(Q)$(MAKE) $(MAKEOPTS) -C man $@
 
-install: $(libs) $(progs) install-man
+install: version.h $(libs) $(progs) install-man
 	$(INSTALL) -m755 -d $(DESTDIR)$(bindir)
 	$(INSTALL) $(progs) $(DESTDIR)$(bindir)
 	$(INSTALL) -m755 -d $(DESTDIR)$(libdir)
-- 
1.7.10.4

