Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from xp-ob.rzone.de ([81.169.146.137]:13151 "EHLO xp-ob.rzone.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933972Ab3HIPIn (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 9 Aug 2013 11:08:43 -0400
Received: from pizpot.store ([192.168.43.236])
 by josoe.store (RZmta 31.37 OK) with ESMTP id g03147p78NhPzx
 for <linux-btrfs@vger.kernel.org>;
 Fri, 9 Aug 2013 17:08:40 +0200 (CEST)
From: Stefan Behrens <sbehrens@giantdisaster.de>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: get rid of one BUG() in write_all_supers()
Date: Fri,  9 Aug 2013 17:08:40 +0200
Message-Id: <1376060920-568-1-git-send-email-sbehrens@giantdisaster.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The second round uses btrfs_error() and return -EIO, the first round
can handle write errors the same way.

Signed-off-by: Stefan Behrens <sbehrens@giantdisaster.de>
---
 fs/btrfs/disk-io.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index e76554b..d79b506 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -3414,8 +3414,10 @@ static int write_all_supers(struct btrfs_root *root, int max_mirrors)
 		printk(KERN_ERR "btrfs: %d errors while writing supers\n",
 		       total_errors);
 
-		/* This shouldn't happen. FUA is masked off if unsupported */
-		BUG();
+		/* FUA is masked off if unsupported and can't be the reason */
+		btrfs_error(root->fs_info, -EIO,
+			    "%d errors while writing supers", total_errors);
+		return -EIO;
 	}
 
 	total_errors = 0;
-- 
1.8.3.4

