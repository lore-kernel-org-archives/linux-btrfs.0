Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from xp-ob.rzone.de ([81.169.146.137]:52625 "EHLO xp-ob.rzone.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752773Ab2KFQiu (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 6 Nov 2012 11:38:50 -0500
Received: from pizpot.store ([192.168.43.236])
	by josoe.store (josoe xp3) (RZmta 30.22 OK)
	with ESMTP id p03dd3oA6AspSV for <linux-btrfs@vger.kernel.org>;
	Tue, 6 Nov 2012 17:38:44 +0100 (CET)
From: Stefan Behrens <sbehrens@giantdisaster.de>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 10/26] Btrfs: add btrfs_scratch_superblock() function
Date: Tue,  6 Nov 2012 17:38:28 +0100
Message-Id: <c4dbe3181160547a0064dcaeaf7b38718db666c5.1352217243.git.sbehrens@giantdisaster.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
In-Reply-To: <cover.1352214751.git.sbehrens@giantdisaster.de>

This new function is used by the device replace procedure in
a later patch.

Signed-off-by: Stefan Behrens <sbehrens@giantdisaster.de>
---
 fs/btrfs/volumes.c | 18 ++++++++++++++++++
 fs/btrfs/volumes.h |  1 +
 2 files changed, 19 insertions(+)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index c79f8db..bf5e68b 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -5111,3 +5111,21 @@ int btrfs_get_dev_stats(struct btrfs_root *root,
 		stats->nr_items = BTRFS_DEV_STAT_VALUES_MAX;
 	return 0;
 }
+
+int btrfs_scratch_superblock(struct btrfs_device *device)
+{
+	struct buffer_head *bh;
+	struct btrfs_super_block *disk_super;
+
+	bh = btrfs_read_dev_super(device->bdev);
+	if (!bh)
+		return -EINVAL;
+	disk_super = (struct btrfs_super_block *)bh->b_data;
+
+	memset(&disk_super->magic, 0, sizeof(disk_super->magic));
+	set_buffer_dirty(bh);
+	sync_dirty_buffer(bh);
+	brelse(bh);
+
+	return 0;
+}
diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index ad5566d..7eaaf4e 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -301,6 +301,7 @@ int btrfs_get_dev_stats(struct btrfs_root *root,
 int btrfs_init_dev_stats(struct btrfs_fs_info *fs_info);
 int btrfs_run_dev_stats(struct btrfs_trans_handle *trans,
 			struct btrfs_fs_info *fs_info);
+int btrfs_scratch_superblock(struct btrfs_device *device);
 
 static inline void btrfs_dev_stat_inc(struct btrfs_device *dev,
 				      int index)
-- 
1.8.0

