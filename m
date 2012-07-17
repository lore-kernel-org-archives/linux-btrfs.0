Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from xp-ob.rzone.de ([81.169.146.137]:59737 "EHLO xp-ob.rzone.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755259Ab2GQPCR (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 17 Jul 2012 11:02:17 -0400
Received: from pizpot.store ([192.168.43.236])
	by jorabe.store (jorabe xp1) (RZmta 29.19 OK)
	with ESMTP id X00d61o6HDGkze for <linux-btrfs@vger.kernel.org>;
	Tue, 17 Jul 2012 17:02:15 +0200 (CEST)
From: Stefan Behrens <sbehrens@giantdisaster.de>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 1/2] Btrfs: remove unwanted printk() for btrfs device I/O stats
Date: Tue, 17 Jul 2012 17:02:10 +0200
Message-Id: <ba532f03efd6045efe5f71625529abe04d03b5fc.1342534465.git.sbehrens@giantdisaster.de>
In-Reply-To: <cover.1342534465.git.sbehrens@giantdisaster.de>
References: <cover.1342534465.git.sbehrens@giantdisaster.de>
In-Reply-To: <cover.1342534465.git.sbehrens@giantdisaster.de>
References: <cover.1342534465.git.sbehrens@giantdisaster.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

People complained about the annoying kernel log message
"btrfs: no dev_stats entry found ... (OK on first mount after mkfs)"
everytime a filesystem is mounted for the first time after running
mkfs. Since the distribution of the btrfs-progs is not synchronized
to the kernel version, mkfs like it is now will be used also in the
future. Then this message is not useful to find errors, it is just
annoying. This commit removes the printk().

Signed-off-by: Stefan Behrens <sbehrens@giantdisaster.de>
---
 fs/btrfs/volumes.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index ecaad40..6f04dae 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -4736,9 +4736,6 @@ int btrfs_init_dev_stats(struct btrfs_fs_info *fs_info)
 		key.offset = device->devid;
 		ret = btrfs_search_slot(NULL, dev_root, &key, path, 0, 0);
 		if (ret) {
-			printk_in_rcu(KERN_WARNING "btrfs: no dev_stats entry found for device %s (devid %llu) (OK on first mount after mkfs)\n",
-				      rcu_str_deref(device->name),
-				      (unsigned long long)device->devid);
 			__btrfs_reset_dev_stats(device);
 			device->dev_stats_valid = 1;
 			btrfs_release_path(path);
-- 
1.7.11.2

