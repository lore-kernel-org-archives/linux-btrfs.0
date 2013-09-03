Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from xp-ob.rzone.de ([81.169.146.139]:46245 "EHLO xp-ob.rzone.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759692Ab3ICHT6 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 3 Sep 2013 03:19:58 -0400
Received: from pizpot.store ([192.168.43.236])
 by jored.store (RZmta 31.47 OK) with ESMTP id p04509p8370g4I
 for <linux-btrfs@vger.kernel.org>;
 Tue, 3 Sep 2013 09:19:55 +0200 (CEST)
From: Stefan Behrens <sbehrens@giantdisaster.de>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2] Btrfs: get rid of one BUG() in write_all_supers()
Date: Tue,  3 Sep 2013 09:19:55 +0200
Message-Id: <422d140220dd6d9cf4b3a92ca12913c15a02ee3f.1378192370.git.sbehrens@giantdisaster.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The second round uses btrfs_error() and return -EIO, the first round
can handle write errors the same way.

Signed-off-by: Stefan Behrens <sbehrens@giantdisaster.de>
---
v1 -> v2:
Add the missing mutex_unlock().
This missing unlock was reported by the 0-DAY kernel build service
from Intel and found by the coccinelle tool. Thanks!

 fs/btrfs/disk-io.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 195c078..69864dd 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -3414,9 +3414,12 @@ static int write_all_supers(struct btrfs_root *root, int max_mirrors)
 	if (total_errors > max_errors) {
 		printk(KERN_ERR "btrfs: %d errors while writing supers\n",
 		       total_errors);
+		mutex_unlock(&root->fs_info->fs_devices->device_list_mutex);
 
-		/* This shouldn't happen. FUA is masked off if unsupported */
-		BUG();
+		/* FUA is masked off if unsupported and can't be the reason */
+		btrfs_error(root->fs_info, -EIO,
+			    "%d errors while writing supers", total_errors);
+		return -EIO;
 	}
 
 	total_errors = 0;
-- 
1.8.4

