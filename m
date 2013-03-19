Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp.gentoo.org ([140.211.166.183]:54128 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753347Ab3CSFdz (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 19 Mar 2013 01:33:55 -0400
From: Sergei Trofimovich <slyich@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>, Chris Mason <chris.mason@fusionio.com>,
        Sergei Trofimovich <slyfox@gentoo.org>
Subject: [PATCH] Makefile: allow user set LDFLAGS for libbtrfs.so as well
Date: Tue, 19 Mar 2013 08:33:24 +0300
Message-Id: <1363671204-20307-1-git-send-email-slyich@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Sergei Trofimovich <slyfox@gentoo.org>

Detected by gentoo's QA checker:

 * QA Notice: Files built without respecting LDFLAGS have been detected
 *  Please include the following list of files in your report:
 * /usr/lib/libbtrfs.so.0.1

Signed-off-by: Sergei Trofimovich <slyfox@gentoo.org>
---
 Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Makefile b/Makefile
index 9c195b3..460cca7 100644
--- a/Makefile
+++ b/Makefile
@@ -93,7 +93,7 @@ version.h:
 
 $(libs_shared): $(libbtrfs_objects) $(lib_links) send.h
 	@echo "    [LD]     $@"
-	$(Q)$(CC) $(CFLAGS) $(libbtrfs_objects) $(lib_LIBS) -shared -Wl,-soname,libbtrfs.so -o libbtrfs.so.0.1
+	$(Q)$(CC) $(CFLAGS) $(libbtrfs_objects) $(LDFLAGS) $(lib_LIBS) -shared -Wl,-soname,libbtrfs.so -o libbtrfs.so.0.1
 
 $(libs_static): $(libbtrfs_objects)
 	@echo "    [AR]     $@"
-- 
1.8.1.2

