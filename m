Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from xp-ob.rzone.de ([81.169.146.141]:11289 "EHLO xp-ob.rzone.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751181Ab3IKH7Z (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 11 Sep 2013 03:59:25 -0400
Received: from pizpot.store ([192.168.43.236])
	by josoe.store (RZmta 32.1 OK) with ESMTP id p0047fp8AKhYwG
	for <linux-btrfs@vger.kernel.org>;
	Wed, 11 Sep 2013 09:59:22 +0200 (CEST)
From: Stefan Behrens <sbehrens@giantdisaster.de>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: add the missing mutex unlock in write_all_supers()
Date: Wed, 11 Sep 2013 09:59:22 +0200
Message-Id: <71e14f170c832bce9e8c0b457462bb56eb6309ed.1378886212.git.sbehrens@giantdisaster.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The BUG() was replaced by btrfs_error() and return -EIO with the
patch "get rid of one BUG() in write_all_supers()", but the missing
mutex_unlock() was overlooked.

The 0-DAY kernel build service from Intel reported the missing
unlock which was found by the coccinelle tool:

    fs/btrfs/disk-io.c:3422:2-8: preceding lock on line 3374

Signed-off-by: Stefan Behrens <sbehrens@giantdisaster.de>
---
This patch was also included in the v2 of "Btrfs: get rid of one BUG()
in write_all_supers()", but the v1 made it into the repository,
therefore this incremental send.

 fs/btrfs/disk-io.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 3032a67..17618b8 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -3417,6 +3417,7 @@ static int write_all_supers(struct btrfs_root *root, int max_mirrors)
 	if (total_errors > max_errors) {
 		printk(KERN_ERR "btrfs: %d errors while writing supers\n",
 		       total_errors);
+		mutex_unlock(&root->fs_info->fs_devices->device_list_mutex);
 
 		/* FUA is masked off if unsupported and can't be the reason */
 		btrfs_error(root->fs_info, -EIO,
-- 
1.8.4

