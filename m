Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from xp-ob.rzone.de ([81.169.146.141]:60249 "EHLO xp-ob.rzone.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753003Ab2FHSae (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 8 Jun 2012 14:30:34 -0400
Received: from pizpot.store ([192.168.43.236])
	by jored.store (jored xp4) (RZmta 29.10 OK)
	with ESMTP id 600d4eo589N255 for <linux-btrfs@vger.kernel.org>;
	Fri, 8 Jun 2012 20:00:18 +0200 (CEST)
From: Stefan Behrens <sbehrens@giantdisaster.de>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs-progs: remove btrfsctl, btrfs-show and btrfs-vol from default build
Date: Fri,  8 Jun 2012 20:00:17 +0200
Message-Id: <1339178417-26051-1-git-send-email-sbehrens@giantdisaster.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Remove btrfsctl, btrfs-show and btrfs-vol from "all" target of Makefile.

Signed-off-by: Stefan Behrens <sbehrens@giantdisaster.de>
---
 Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Makefile b/Makefile
index aaf1381..79e7a56 100644
--- a/Makefile
+++ b/Makefile
@@ -18,7 +18,7 @@ bindir = $(prefix)/bin
 LIBS=-luuid
 RESTORE_LIBS=-lz
 
-progs = btrfsctl mkfs.btrfs btrfs-debug-tree btrfs-show btrfs-vol btrfsck \
+progs = mkfs.btrfs btrfs-debug-tree btrfsck \
 	btrfs btrfs-map-logical btrfs-image btrfs-zero-log btrfs-convert \
 	btrfs-find-root btrfs-restore btrfstune
 
-- 
1.7.10.4

