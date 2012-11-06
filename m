Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from xp-ob.rzone.de ([81.169.146.136]:14344 "EHLO xp-ob.rzone.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752735Ab2KFQit (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 6 Nov 2012 11:38:49 -0500
Received: from pizpot.store ([192.168.43.236])
	by jorabe.store (jorabe xp3) (RZmta 31.1 OK)
	with ESMTP id p02bbcoA6CtOFI for <linux-btrfs@vger.kernel.org>;
	Tue, 6 Nov 2012 17:38:45 +0100 (CET)
From: Stefan Behrens <sbehrens@giantdisaster.de>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 24/26] Btrfs: increase BTRFS_MAX_MIRRORS by one for dev replace
Date: Tue,  6 Nov 2012 17:38:42 +0100
Message-Id: <38ed30105397e5c706e38c95f52007a2c156fefb.1352217244.git.sbehrens@giantdisaster.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
In-Reply-To: <cover.1352214751.git.sbehrens@giantdisaster.de>

This change of the define is effective in all modes, it
is required and used only in the case when a device replace
procedure is running. The reason is that during an active
device replace procedure, the target device of the copy
operation is a mirror for the filesystem data as well that
can be used to read data in order to repair read errors on
other disks.

Signed-off-by: Stefan Behrens <sbehrens@giantdisaster.de>
---
 fs/btrfs/ctree.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 01fcfcb..133e5c4 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -48,7 +48,7 @@ struct btrfs_ordered_sum;
 
 #define BTRFS_MAGIC "_BHRfS_M"
 
-#define BTRFS_MAX_MIRRORS 2
+#define BTRFS_MAX_MIRRORS 3
 
 #define BTRFS_MAX_LEVEL 8
 
-- 
1.8.0

