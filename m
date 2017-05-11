Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41647 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752826AbdEKGRy (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 11 May 2017 02:17:54 -0400
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.com, jeffm@suse.com, clm@fb.com,
        Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH] btrfs: Convert fs_info->free_chunk_space to atomic64_t
Date: Thu, 11 May 2017 09:17:46 +0300
Message-Id: <1494483466-22342-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The ->free_chunk_space variable is used to track the unallocated space and
access to it is protected by a spinlock, which is not used for anything else.
Make the code a bit self-explanatory by switching the variable to an atomic64_t
type and kill the spinlock.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/ctree.h       |  3 +--
 fs/btrfs/disk-io.c     |  3 +--
 fs/btrfs/extent-tree.c |  4 +---
 fs/btrfs/volumes.c     | 26 +++++++-------------------
 4 files changed, 10 insertions(+), 26 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 3e21211e99c3..2202dfdc7888 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -729,8 +729,7 @@ struct btrfs_fs_info {
 	struct rb_root block_group_cache_tree;
 
 	/* keep track of unallocated space */
-	spinlock_t free_chunk_lock;
-	u64 free_chunk_space;
+	atomic64_t free_chunk_space;
 
 	struct extent_io_tree freed_extents[2];
 	struct extent_io_tree *pinned_extents;
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 061c1d1f774f..2ef80d562a54 100644
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
index 3ab1f88af038..f913c25b9a54 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -4626,9 +4626,7 @@ static int can_overcommit(struct btrfs_root *root,
 
 	used += space_info->bytes_may_use;
 
-	spin_lock(&fs_info->free_chunk_lock);
-	avail = fs_info->free_chunk_space;
-	spin_unlock(&fs_info->free_chunk_lock);
+	avail = atomic64_read(&fs_info->free_chunk_space);
 
 	/*
 	 * If we have dup, raid1 or raid10 then only half of the free
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index ab8a66d852f9..923a3591265c 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -2413,9 +2413,7 @@ int btrfs_init_new_device(struct btrfs_fs_info *fs_info, const char *device_path
 	fs_info->fs_devices->total_devices++;
 	fs_info->fs_devices->total_rw_bytes += device->total_bytes;
 
-	spin_lock(&fs_info->free_chunk_lock);
-	fs_info->free_chunk_space += device->total_bytes;
-	spin_unlock(&fs_info->free_chunk_lock);
+	atomic64_add(device->total_bytes, &fs_info->free_chunk_space);
 
 	if (!blk_queue_nonrot(bdev_get_queue(bdev)))
 		fs_info->fs_devices->rotating = 1;
@@ -2850,9 +2848,7 @@ int btrfs_remove_chunk(struct btrfs_trans_handle *trans,
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
@@ -4379,9 +4375,7 @@ int btrfs_shrink_device(struct btrfs_device *device, u64 new_size)
 	btrfs_device_set_total_bytes(device, new_size);
 	if (device->writeable) {
 		device->fs_devices->total_rw_bytes -= diff;
-		spin_lock(&fs_info->free_chunk_lock);
-		fs_info->free_chunk_space -= diff;
-		spin_unlock(&fs_info->free_chunk_lock);
+		atomic64_sub(diff, &fs_info->free_chunk_space);
 	}
 	mutex_unlock(&fs_info->chunk_mutex);
 
@@ -4505,9 +4499,7 @@ int btrfs_shrink_device(struct btrfs_device *device, u64 new_size)
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
@@ -4852,9 +4844,7 @@ static int __btrfs_alloc_chunk(struct btrfs_trans_handle *trans,
 		btrfs_device_set_bytes_used(map->stripes[i].dev, num_bytes);
 	}
 
-	spin_lock(&info->free_chunk_lock);
-	info->free_chunk_space -= (stripe_size * map->num_stripes);
-	spin_unlock(&info->free_chunk_lock);
+	atomic64_sub(stripe_size * map->num_stripes, &info->free_chunk_space);
 
 	free_extent_map(em);
 	check_raid56_incompat_flag(info, type);
@@ -6636,10 +6626,8 @@ static int read_one_dev(struct btrfs_fs_info *fs_info,
 	device->in_fs_metadata = 1;
 	if (device->writeable && !device->is_tgtdev_for_dev_replace) {
 		device->fs_devices->total_rw_bytes += device->total_bytes;
-		spin_lock(&fs_info->free_chunk_lock);
-		fs_info->free_chunk_space += device->total_bytes -
-			device->bytes_used;
-		spin_unlock(&fs_info->free_chunk_lock);
+		atomic64_add(device->total_bytes - device->bytes_used,
+				&fs_info->free_chunk_space);
 	}
 	ret = 0;
 	return ret;
-- 
2.7.4

