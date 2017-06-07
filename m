Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f180.google.com ([209.85.223.180]:35857 "EHLO
        mail-io0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751491AbdFGSJg (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 7 Jun 2017 14:09:36 -0400
Received: by mail-io0-f180.google.com with SMTP id y77so10456333ioe.3
        for <linux-btrfs@vger.kernel.org>; Wed, 07 Jun 2017 11:09:35 -0700 (PDT)
Received: from ircssh-2.c.rugged-nimbus-611.internal (80.60.198.104.bc.googleusercontent.com. [104.198.60.80])
        by smtp.gmail.com with ESMTPSA id l16sm1263931itb.20.2017.06.07.11.09.34
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 07 Jun 2017 11:09:34 -0700 (PDT)
Date: Wed, 7 Jun 2017 18:09:33 +0000
From: Sargun Dhillon <sargun@sargun.me>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs: Convert btrfs_fs_info's free_chunk_space to an
 atomic64_t
Message-ID: <20170607180930.GA12551@ircssh-2.c.rugged-nimbus-611.internal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This patch is a small performance optimization to get rid of a spin
lock, where instead an atomic64_t can be used.

Signed-off-by: Sargun Dhillon <sargun@sargun.me>
---
 fs/btrfs/ctree.h       |  4 ++--
 fs/btrfs/disk-io.c     |  3 +--
 fs/btrfs/extent-tree.c |  4 +---
 fs/btrfs/volumes.c     | 26 +++++++-------------------
 4 files changed, 11 insertions(+), 26 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 643c70d..01bf42c 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -40,6 +40,7 @@
 #include <linux/sizes.h>
 #include <linux/dynamic_debug.h>
 #include <linux/refcount.h>
+#include <linux/types.h>
 #include "extent_io.h"
 #include "extent_map.h"
 #include "async-thread.h"
@@ -748,8 +749,7 @@ struct btrfs_fs_info {
 	struct rb_root block_group_cache_tree;
 
 	/* keep track of unallocated space */
-	spinlock_t free_chunk_lock;
-	u64 free_chunk_space;
+	atomic64_t free_chunk_space;
 
 	struct extent_io_tree freed_extents[2];
 	struct extent_io_tree *pinned_extents;
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 8685d67..3700b68 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -2626,7 +2626,6 @@ int open_ctree(struct super_block *sb,
 	spin_lock_init(&fs_info->fs_roots_radix_lock);
 	spin_lock_init(&fs_info->delayed_iput_lock);
 	spin_lock_init(&fs_info->defrag_inodes_lock);
-	spin_lock_init(&fs_info->free_chunk_lock);
 	spin_lock_init(&fs_info->tree_mod_seq_lock);
 	spin_lock_init(&fs_info->super_lock);
 	spin_lock_init(&fs_info->qgroup_op_lock);
@@ -2667,7 +2666,7 @@ int open_ctree(struct super_block *sb,
 	fs_info->max_inline = BTRFS_DEFAULT_MAX_INLINE;
 	fs_info->metadata_ratio = 0;
 	fs_info->defrag_inodes = RB_ROOT;
-	fs_info->free_chunk_space = 0;
+	atomic64_set(&fs_info->free_chunk_space, 0);
 	fs_info->tree_mod_log = RB_ROOT;
 	fs_info->commit_interval = BTRFS_DEFAULT_COMMIT_INTERVAL;
 	fs_info->avg_delayed_ref_runtime = NSEC_PER_SEC >> 6; /* div by 64 */
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index e390451..955733c 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -4645,9 +4645,7 @@ static int can_overcommit(struct btrfs_root *root,
 
 	used += space_info->bytes_may_use;
 
-	spin_lock(&fs_info->free_chunk_lock);
-	avail = fs_info->free_chunk_space;
-	spin_unlock(&fs_info->free_chunk_lock);
+	avail = atomic64_read(&fs_info->free_chunk_space);
 
 	/*
 	 * If we have dup, raid1 or raid10 then only half of the free
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 017b67d..0123974 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -2417,9 +2417,7 @@ int btrfs_init_new_device(struct btrfs_fs_info *fs_info, const char *device_path
 	fs_info->fs_devices->total_devices++;
 	fs_info->fs_devices->total_rw_bytes += device->total_bytes;
 
-	spin_lock(&fs_info->free_chunk_lock);
-	fs_info->free_chunk_space += device->total_bytes;
-	spin_unlock(&fs_info->free_chunk_lock);
+	atomic64_add(device->total_bytes, &fs_info->free_chunk_space);
 
 	if (!blk_queue_nonrot(q))
 		fs_info->fs_devices->rotating = 1;
@@ -2874,9 +2872,7 @@ int btrfs_remove_chunk(struct btrfs_trans_handle *trans,
 			mutex_lock(&fs_info->chunk_mutex);
 			btrfs_device_set_bytes_used(device,
 					device->bytes_used - dev_extent_len);
-			spin_lock(&fs_info->free_chunk_lock);
-			fs_info->free_chunk_space += dev_extent_len;
-			spin_unlock(&fs_info->free_chunk_lock);
+			atomic64_add(dev_extent_len, &fs_info->free_chunk_space);
 			btrfs_clear_space_info_full(fs_info);
 			mutex_unlock(&fs_info->chunk_mutex);
 		}
@@ -4409,9 +4405,7 @@ int btrfs_shrink_device(struct btrfs_device *device, u64 new_size)
 	btrfs_device_set_total_bytes(device, new_size);
 	if (device->writeable) {
 		device->fs_devices->total_rw_bytes -= diff;
-		spin_lock(&fs_info->free_chunk_lock);
-		fs_info->free_chunk_space -= diff;
-		spin_unlock(&fs_info->free_chunk_lock);
+		atomic64_sub(diff, &fs_info->free_chunk_space);
 	}
 	mutex_unlock(&fs_info->chunk_mutex);
 
@@ -4535,9 +4529,7 @@ int btrfs_shrink_device(struct btrfs_device *device, u64 new_size)
 		btrfs_device_set_total_bytes(device, old_size);
 		if (device->writeable)
 			device->fs_devices->total_rw_bytes += diff;
-		spin_lock(&fs_info->free_chunk_lock);
-		fs_info->free_chunk_space += diff;
-		spin_unlock(&fs_info->free_chunk_lock);
+		atomic64_add(diff, &fs_info->free_chunk_space);
 		mutex_unlock(&fs_info->chunk_mutex);
 	}
 	return ret;
@@ -4882,9 +4874,7 @@ static int __btrfs_alloc_chunk(struct btrfs_trans_handle *trans,
 		btrfs_device_set_bytes_used(map->stripes[i].dev, num_bytes);
 	}
 
-	spin_lock(&info->free_chunk_lock);
-	info->free_chunk_space -= (stripe_size * map->num_stripes);
-	spin_unlock(&info->free_chunk_lock);
+	atomic64_sub((stripe_size * map->num_stripes), &info->free_chunk_space);
 
 	free_extent_map(em);
 	check_raid56_incompat_flag(info, type);
@@ -6684,10 +6674,8 @@ static int read_one_dev(struct btrfs_fs_info *fs_info,
 	device->in_fs_metadata = 1;
 	if (device->writeable && !device->is_tgtdev_for_dev_replace) {
 		device->fs_devices->total_rw_bytes += device->total_bytes;
-		spin_lock(&fs_info->free_chunk_lock);
-		fs_info->free_chunk_space += device->total_bytes -
-			device->bytes_used;
-		spin_unlock(&fs_info->free_chunk_lock);
+		atomic64_add(device->total_bytes - device->bytes_used,
+			     &fs_info->free_chunk_space);
 	}
 	ret = 0;
 	return ret;
-- 
2.9.3

