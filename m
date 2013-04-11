Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:7490 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S934043Ab3DKK3D (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 11 Apr 2013 06:29:03 -0400
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id r3BAStQQ008484
	for <linux-btrfs@vger.kernel.org>; Thu, 11 Apr 2013 18:28:55 +0800
Message-ID: <516690B8.8020904@cn.fujitsu.com>
Date: Thu, 11 Apr 2013 18:30:16 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
MIME-Version: 1.0
To: Linux Btrfs <linux-btrfs@vger.kernel.org>
Subject: [PATCH 2/2] Btrfs: use a lock to protect incompat/compat flag of
 the super block
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The following case will make the incompat/compat flag of the super block
be recovered.
 Task1					|Task2
 flags = btrfs_super_incompat_flags();	|
					|flags = btrfs_super_incompat_flags();
 flags |= new_flag1;			|
					|flags |= new_flag2;
 btrfs_set_super_incompat_flags(flags);	|
					|btrfs_set_super_incompat_flags(flags);
the new_flag1 is recovered.

In order to avoid this problem, we introduce a lock named super_lock into
the btrfs_fs_info structure. If we want to update incompat/compat flags
of the super block, we must hold it.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/ctree.h   | 22 ++++++++++++++++++++--
 fs/btrfs/disk-io.c |  5 +++++
 fs/btrfs/volumes.c | 10 +---------
 3 files changed, 26 insertions(+), 11 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 0d82922..a883e47 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -1360,6 +1360,17 @@ struct btrfs_fs_info {
 	wait_queue_head_t transaction_blocked_wait;
 	wait_queue_head_t async_submit_wait;
 
+	/*
+	 * Used to protect the incompat_flags, compat_flags, compat_ro_flags
+	 * when they are updated.
+	 *
+	 * Because we do not clear the flags for ever, so we needn't use
+	 * the lock on the read side.
+	 *
+	 * We also needn't use the lock when we mount the fs, because
+	 * there is no other task which will update the flag.
+	 */
+	spinlock_t super_lock;
 	struct btrfs_super_block *super_copy;
 	struct btrfs_super_block *super_for_commit;
 	struct block_device *__bdev;
@@ -3663,8 +3674,15 @@ static inline void __btrfs_set_fs_incompat(struct btrfs_fs_info *fs_info,
 	disk_super = fs_info->super_copy;
 	features = btrfs_super_incompat_flags(disk_super);
 	if (!(features & flag)) {
-		features |= flag;
-		btrfs_set_super_incompat_flags(disk_super, features);
+		spin_lock(&fs_info->super_lock);
+		features = btrfs_super_incompat_flags(disk_super);
+		if (!(features & flag)) {
+			features |= flag;
+			btrfs_set_super_incompat_flags(disk_super, features);
+			printk(KERN_INFO "btrfs: setting %llu feature flag\n",
+					 flag);
+		}
+		spin_unlock(&fs_info->super_lock);
 	}
 }
 
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 6d19a0a..ab8ef37 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -2060,6 +2060,7 @@ int open_ctree(struct super_block *sb,
 	spin_lock_init(&fs_info->defrag_inodes_lock);
 	spin_lock_init(&fs_info->free_chunk_lock);
 	spin_lock_init(&fs_info->tree_mod_seq_lock);
+	spin_lock_init(&fs_info->super_lock);
 	rwlock_init(&fs_info->tree_mod_log_lock);
 	mutex_init(&fs_info->reloc_mutex);
 	seqlock_init(&fs_info->profiles_lock);
@@ -2319,6 +2320,10 @@ int open_ctree(struct super_block *sb,
 		goto fail_alloc;
 	}
 
+	/*
+	 * Needn't use the lock because there is no other task which will
+	 * update the flag.
+	 */
 	btrfs_set_super_incompat_flags(disk_super, features);
 
 	features = btrfs_super_compat_ro_flags(disk_super) &
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 2854c82..e710db4 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -3674,18 +3674,10 @@ static u32 find_raid56_stripe_len(u32 data_devices, u32 dev_stripe_target)
 
 static void check_raid56_incompat_flag(struct btrfs_fs_info *info, u64 type)
 {
-	u64 features;
-
 	if (!(type & (BTRFS_BLOCK_GROUP_RAID5 | BTRFS_BLOCK_GROUP_RAID6)))
 		return;
 
-	features = btrfs_super_incompat_flags(info->super_copy);
-	if (features & BTRFS_FEATURE_INCOMPAT_RAID56)
-		return;
-
-	features |= BTRFS_FEATURE_INCOMPAT_RAID56;
-	btrfs_set_super_incompat_flags(info->super_copy, features);
-	printk(KERN_INFO "btrfs: setting RAID5/6 feature flag\n");
+	btrfs_set_fs_incompat(info, RAID56);
 }
 
 static int __btrfs_alloc_chunk(struct btrfs_trans_handle *trans,
-- 
1.8.0.1
