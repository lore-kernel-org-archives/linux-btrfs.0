Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from bastet.se.axis.com ([195.60.68.11]:42668 "EHLO
        bastet.se.axis.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751178AbeDDOFR (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 4 Apr 2018 10:05:17 -0400
Received: from localhost (localhost [127.0.0.1])
        by bastet.se.axis.com (Postfix) with ESMTP id 1539A18483
        for <linux-btrfs@vger.kernel.org>; Wed,  4 Apr 2018 16:05:16 +0200 (CEST)
Received: from bastet.se.axis.com ([IPv6:::ffff:127.0.0.1])
        by localhost (bastet.se.axis.com [::ffff:127.0.0.1]) (amavisd-new, port 10024)
        with LMTP id 1jRGFbGdJK55 for <linux-btrfs@vger.kernel.org>;
        Wed,  4 Apr 2018 16:05:15 +0200 (CEST)
Received: from boulder03.se.axis.com (boulder03.se.axis.com [10.0.8.17])
        by bastet.se.axis.com (Postfix) with ESMTPS id 335F31847E
        for <linux-btrfs@vger.kernel.org>; Wed,  4 Apr 2018 16:05:15 +0200 (CEST)
Received: from boulder03.se.axis.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BEB5C1E07C
        for <linux-btrfs@vger.kernel.org>; Wed,  4 Apr 2018 16:05:14 +0200 (CEST)
Received: from boulder03.se.axis.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B25C31E06C
        for <linux-btrfs@vger.kernel.org>; Wed,  4 Apr 2018 16:05:14 +0200 (CEST)
Received: from thoth.se.axis.com (unknown [10.0.2.173])
        by boulder03.se.axis.com (Postfix) with ESMTP
        for <linux-btrfs@vger.kernel.org>; Wed,  4 Apr 2018 16:05:14 +0200 (CEST)
From: Peter Kjellerstedt <peter.kjellerstedt@axis.com>
To: linux-btrfs@vger.kernel.org
Cc: pkj@axis.com
Subject: [PATCH] btrfs-progs: build: Do not use cp -a to install files
Date: Wed,  4 Apr 2018 16:04:59 +0200
Message-Id: <20180404140459.20644-1-pkj@axis.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Using cp -a to install files will preserve the ownership of the
original files (if possible), which is typically not wanted. E.g., if
the files were built by a normal user, but are being installed by
root, then the installed files would maintain the UIDs/GIDs of the
user that built the files rather than be owned by root.

Signed-off-by: Peter Kjellerstedt <peter.kjellerstedt@axis.com>
---
 Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Makefile b/Makefile
index 92cfe7b5..0e8bfd98 100644
--- a/Makefile
+++ b/Makefile
@@ -578,7 +578,7 @@ install: $(libs) $(progs_install) $(INSTALLDIRS)
 	$(LN_S) -f btrfs $(DESTDIR)$(bindir)/btrfsck
 	$(INSTALL) -m755 -d $(DESTDIR)$(libdir)
 	$(INSTALL) $(libs) $(DESTDIR)$(libdir)
-	cp -a $(lib_links) $(DESTDIR)$(libdir)
+	cp -d $(lib_links) $(DESTDIR)$(libdir)
 	$(INSTALL) -m755 -d $(DESTDIR)$(incdir)
 	$(INSTALL) -m644 $(headers) $(DESTDIR)$(incdir)
 ifneq ($(udevdir),)
-- 
2.12.0

