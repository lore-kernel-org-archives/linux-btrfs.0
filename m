Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:42132 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750948AbdFON1K (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 15 Jun 2017 09:27:10 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 736BAAAB9
        for <linux-btrfs@vger.kernel.org>; Thu, 15 Jun 2017 13:27:09 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH] btrfs: obsolete and remove mount option alloc_start
Date: Thu, 15 Jun 2017 15:26:02 +0200
Message-Id: <20170615132602.7109-1-dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The mount option alloc_start was used in the past for debugging and
stressing the chunk allocator. Not meant to be used by users, so we're
not breaking anybody's setup.

There was some added complexity handling changes of the value and when
it was not same as default. Such code has likely been untested and I
think it's better to remove it.

This patch kills all use of alloc_start, and by doing that also fixes
a bug when alloc_size is set, potentially called from statfs:

in btrfs_calc_avail_data_space, traversing the list in RCU, the RCU
protection is temporarily dropped so btrfs_account_dev_extents_size can
be called and then RCU is locked again! Doing that inside
list_for_each_entry_rcu is just asking for trouble, but unlikely to be
observed in practice.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/ctree.h   | 12 +----------
 fs/btrfs/super.c   | 61 +++++-------------------------------------------------
 fs/btrfs/volumes.c |  4 +---
 3 files changed, 7 insertions(+), 70 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index f0f5f28784b6..55180c5f746e 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -797,17 +797,7 @@ struct btrfs_fs_info {
 	 * so it is also safe.
 	 */
 	u64 max_inline;
-	/*
-	 * Protected by ->chunk_mutex and sb->s_umount.
-	 *
-	 * The reason that we use two lock to protect it is because only
-	 * remount and mount operations can change it and these two operations
-	 * are under sb->s_umount, but the read side (chunk allocation) can not
-	 * acquire sb->s_umount or the deadlock would happen. So we use two
-	 * locks to protect it. On the write side, we must acquire two locks,
-	 * and on the read side, we just need acquire one of them.
-	 */
-	u64 alloc_start;
+
 	struct btrfs_transaction *running_transaction;
 	wait_queue_head_t transaction_throttle;
 	wait_queue_head_t transaction_wait;
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 3371213924bd..eb355dc5afc5 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -601,18 +601,8 @@ int btrfs_parse_options(struct btrfs_fs_info *info, char *options,
 			}
 			break;
 		case Opt_alloc_start:
-			num = match_strdup(&args[0]);
-			if (num) {
-				mutex_lock(&info->chunk_mutex);
-				info->alloc_start = memparse(num, NULL);
-				mutex_unlock(&info->chunk_mutex);
-				kfree(num);
-				btrfs_info(info, "allocations start at %llu",
-					   info->alloc_start);
-			} else {
-				ret = -ENOMEM;
-				goto out;
-			}
+			btrfs_info(info,
+				"option alloc_start is obsolete, ignored");
 			break;
 		case Opt_acl:
 #ifdef CONFIG_BTRFS_FS_POSIX_ACL
@@ -1232,8 +1222,6 @@ static int btrfs_show_options(struct seq_file *seq, struct dentry *dentry)
 		seq_puts(seq, ",nobarrier");
 	if (info->max_inline != BTRFS_DEFAULT_MAX_INLINE)
 		seq_printf(seq, ",max_inline=%llu", info->max_inline);
-	if (info->alloc_start != 0)
-		seq_printf(seq, ",alloc_start=%llu", info->alloc_start);
 	if (info->thread_pool_size !=  min_t(unsigned long,
 					     num_online_cpus() + 2, 8))
 		seq_printf(seq, ",thread_pool=%d", info->thread_pool_size);
@@ -1716,7 +1704,6 @@ static int btrfs_remount(struct super_block *sb, int *flags, char *data)
 	unsigned long old_opts = fs_info->mount_opt;
 	unsigned long old_compress_type = fs_info->compress_type;
 	u64 old_max_inline = fs_info->max_inline;
-	u64 old_alloc_start = fs_info->alloc_start;
 	int old_thread_pool_size = fs_info->thread_pool_size;
 	unsigned int old_metadata_ratio = fs_info->metadata_ratio;
 	int ret;
@@ -1855,9 +1842,6 @@ static int btrfs_remount(struct super_block *sb, int *flags, char *data)
 	fs_info->mount_opt = old_opts;
 	fs_info->compress_type = old_compress_type;
 	fs_info->max_inline = old_max_inline;
-	mutex_lock(&fs_info->chunk_mutex);
-	fs_info->alloc_start = old_alloc_start;
-	mutex_unlock(&fs_info->chunk_mutex);
 	btrfs_resize_thread_pool(fs_info,
 		old_thread_pool_size, fs_info->thread_pool_size);
 	fs_info->metadata_ratio = old_metadata_ratio;
@@ -1904,11 +1888,9 @@ static int btrfs_calc_avail_data_space(struct btrfs_fs_info *fs_info,
 	u64 skip_space;
 	u64 type;
 	u64 avail_space;
-	u64 used_space;
 	u64 min_stripe_size;
 	int min_stripes = 1, num_stripes = 1;
 	int i = 0, nr_devices;
-	int ret;
 
 	/*
 	 * We aren't under the device list lock, so this is racy-ish, but good
@@ -1948,8 +1930,6 @@ static int btrfs_calc_avail_data_space(struct btrfs_fs_info *fs_info,
 	else
 		min_stripe_size = BTRFS_STRIPE_LEN;
 
-	if (fs_info->alloc_start)
-		mutex_lock(&fs_devices->device_list_mutex);
 	rcu_read_lock();
 	list_for_each_entry_rcu(device, &fs_devices->devices, dev_list) {
 		if (!device->in_fs_metadata || !device->bdev ||
@@ -1972,34 +1952,6 @@ static int btrfs_calc_avail_data_space(struct btrfs_fs_info *fs_info,
 		 */
 		skip_space = SZ_1M;
 
-		/* user can set the offset in fs_info->alloc_start. */
-		if (fs_info->alloc_start &&
-		    fs_info->alloc_start + BTRFS_STRIPE_LEN <=
-		    device->total_bytes) {
-			rcu_read_unlock();
-			skip_space = max(fs_info->alloc_start, skip_space);
-
-			/*
-			 * btrfs can not use the free space in
-			 * [0, skip_space - 1], we must subtract it from the
-			 * total. In order to implement it, we account the used
-			 * space in this range first.
-			 */
-			ret = btrfs_account_dev_extents_size(device, 0,
-							     skip_space - 1,
-							     &used_space);
-			if (ret) {
-				kfree(devices_info);
-				mutex_unlock(&fs_devices->device_list_mutex);
-				return ret;
-			}
-
-			rcu_read_lock();
-
-			/* calc the free space in [0, skip_space - 1] */
-			skip_space -= used_space;
-		}
-
 		/*
 		 * we can use the free space in [0, skip_space - 1], subtract
 		 * it from the total.
@@ -2018,8 +1970,6 @@ static int btrfs_calc_avail_data_space(struct btrfs_fs_info *fs_info,
 		i++;
 	}
 	rcu_read_unlock();
-	if (fs_info->alloc_start)
-		mutex_unlock(&fs_devices->device_list_mutex);
 
 	nr_devices = i;
 
@@ -2056,10 +2006,9 @@ static int btrfs_calc_avail_data_space(struct btrfs_fs_info *fs_info,
  * multiplier to scale the sizes.
  *
  * Unused device space usage is based on simulating the chunk allocator
- * algorithm that respects the device sizes, order of allocations and the
- * 'alloc_start' value, this is a close approximation of the actual use but
- * there are other factors that may change the result (like a new metadata
- * chunk).
+ * algorithm that respects the device sizes and order of allocations.  This is
+ * a close approximation of the actual use but there are other factors that may
+ * change the result (like a new metadata chunk).
  *
  * If metadata is exhausted, f_bavail will be 0.
  */
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index c10d75fb2202..c4e9142b57f0 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -1353,15 +1353,13 @@ int find_free_dev_extent_start(struct btrfs_transaction *transaction,
 	int ret;
 	int slot;
 	struct extent_buffer *l;
-	u64 min_search_start;
 
 	/*
 	 * We don't want to overwrite the superblock on the drive nor any area
 	 * used by the boot loader (grub for example), so we make sure to start
 	 * at an offset of at least 1MB.
 	 */
-	min_search_start = max(fs_info->alloc_start, 1024ull * 1024);
-	search_start = max(search_start, min_search_start);
+	search_start = max(search_start, SZ_1M);
 
 	path = btrfs_alloc_path();
 	if (!path)
-- 
2.13.0

