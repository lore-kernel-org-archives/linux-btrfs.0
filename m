Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:62321 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751326Ab3A2KMd (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 29 Jan 2013 05:12:33 -0500
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id r0TACV16020857
	for <linux-btrfs@vger.kernel.org>; Tue, 29 Jan 2013 18:12:31 +0800
Message-ID: <5107A0B8.5090200@cn.fujitsu.com>
Date: Tue, 29 Jan 2013 18:13:12 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
MIME-Version: 1.0
To: Linux Btrfs <linux-btrfs@vger.kernel.org>
Subject: [PATCH V2 09/10] Btrfs: use seqlock to protect fs_info->avail_{data,
 metadata, system}_alloc_bits
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
In-Reply-To: <51079D72.7000301@cn.fujitsu.com>

There is no lock to protect
  fs_info->avail_{data, metadata, system}_alloc_bits,
it may introduce some problem, such as the wrong profile
information, so we add a seqlock to protect them.

Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
Changelog v1 -> v2:
- none.
---
 fs/btrfs/ctree.h       |  2 ++
 fs/btrfs/disk-io.c     |  1 +
 fs/btrfs/extent-tree.c | 22 ++++++++++++++------
 fs/btrfs/volumes.c     | 56 +++++++++++++++++++++++++++-----------------------
 4 files changed, 49 insertions(+), 32 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 51515a3..c95b539 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -1474,6 +1474,8 @@ struct btrfs_fs_info {
 	struct rb_root defrag_inodes;
 	atomic_t defrag_running;
 
+	/* Used to protect avail_{data, metadata, system}_alloc_bits */
+	seqlock_t profiles_lock;
 	/*
 	 * these three are in extended format (availability of single
 	 * chunks is denoted by BTRFS_AVAIL_ALLOC_BIT_SINGLE bit, other
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index abf1f10..a7797ed 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -2036,6 +2036,7 @@ int open_ctree(struct super_block *sb,
 	spin_lock_init(&fs_info->tree_mod_seq_lock);
 	rwlock_init(&fs_info->tree_mod_log_lock);
 	mutex_init(&fs_info->reloc_mutex);
+	seqlock_init(&fs_info->profiles_lock);
 
 	init_completion(&fs_info->kobj_unregister);
 	INIT_LIST_HEAD(&fs_info->dirty_cowonly_roots);
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index f4f0b1e..bbbfa72 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -3223,12 +3223,14 @@ static void set_avail_alloc_bits(struct btrfs_fs_info *fs_info, u64 flags)
 	u64 extra_flags = chunk_to_extended(flags) &
 				BTRFS_EXTENDED_PROFILE_MASK;
 
+	write_seqlock(&fs_info->profiles_lock);
 	if (flags & BTRFS_BLOCK_GROUP_DATA)
 		fs_info->avail_data_alloc_bits |= extra_flags;
 	if (flags & BTRFS_BLOCK_GROUP_METADATA)
 		fs_info->avail_metadata_alloc_bits |= extra_flags;
 	if (flags & BTRFS_BLOCK_GROUP_SYSTEM)
 		fs_info->avail_system_alloc_bits |= extra_flags;
+	write_sequnlock(&fs_info->profiles_lock);
 }
 
 /*
@@ -3320,12 +3322,18 @@ u64 btrfs_reduce_alloc_profile(struct btrfs_root *root, u64 flags)
 
 static u64 get_alloc_profile(struct btrfs_root *root, u64 flags)
 {
-	if (flags & BTRFS_BLOCK_GROUP_DATA)
-		flags |= root->fs_info->avail_data_alloc_bits;
-	else if (flags & BTRFS_BLOCK_GROUP_SYSTEM)
-		flags |= root->fs_info->avail_system_alloc_bits;
-	else if (flags & BTRFS_BLOCK_GROUP_METADATA)
-		flags |= root->fs_info->avail_metadata_alloc_bits;
+	unsigned seq;
+
+	do {
+		seq = read_seqbegin(&root->fs_info->profiles_lock);
+
+		if (flags & BTRFS_BLOCK_GROUP_DATA)
+			flags |= root->fs_info->avail_data_alloc_bits;
+		else if (flags & BTRFS_BLOCK_GROUP_SYSTEM)
+			flags |= root->fs_info->avail_system_alloc_bits;
+		else if (flags & BTRFS_BLOCK_GROUP_METADATA)
+			flags |= root->fs_info->avail_metadata_alloc_bits;
+	} while (read_seqretry(&root->fs_info->profiles_lock, seq));
 
 	return btrfs_reduce_alloc_profile(root, flags);
 }
@@ -7937,12 +7945,14 @@ static void clear_avail_alloc_bits(struct btrfs_fs_info *fs_info, u64 flags)
 	u64 extra_flags = chunk_to_extended(flags) &
 				BTRFS_EXTENDED_PROFILE_MASK;
 
+	write_seqlock(&fs_info->profiles_lock);
 	if (flags & BTRFS_BLOCK_GROUP_DATA)
 		fs_info->avail_data_alloc_bits &= ~extra_flags;
 	if (flags & BTRFS_BLOCK_GROUP_METADATA)
 		fs_info->avail_metadata_alloc_bits &= ~extra_flags;
 	if (flags & BTRFS_BLOCK_GROUP_SYSTEM)
 		fs_info->avail_system_alloc_bits &= ~extra_flags;
+	write_sequnlock(&fs_info->profiles_lock);
 }
 
 int btrfs_remove_block_group(struct btrfs_trans_handle *trans,
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 15f6efd..65f22c2 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -1372,14 +1372,19 @@ int btrfs_rm_device(struct btrfs_root *root, char *device_path)
 	u64 devid;
 	u64 num_devices;
 	u8 *dev_uuid;
+	unsigned seq;
 	int ret = 0;
 	bool clear_super = false;
 
 	mutex_lock(&uuid_mutex);
 
-	all_avail = root->fs_info->avail_data_alloc_bits |
-		root->fs_info->avail_system_alloc_bits |
-		root->fs_info->avail_metadata_alloc_bits;
+	do {
+		seq = read_seqbegin(&root->fs_info->profiles_lock);
+
+		all_avail = root->fs_info->avail_data_alloc_bits |
+			    root->fs_info->avail_system_alloc_bits |
+			    root->fs_info->avail_metadata_alloc_bits;
+	} while (read_seqretry(&root->fs_info->profiles_lock, seq));
 
 	num_devices = root->fs_info->fs_devices->num_devices;
 	btrfs_dev_replace_lock(&root->fs_info->dev_replace);
@@ -2984,6 +2989,7 @@ int btrfs_balance(struct btrfs_balance_control *bctl,
 	int mixed = 0;
 	int ret;
 	u64 num_devices;
+	unsigned seq;
 
 	if (btrfs_fs_closing(fs_info) ||
 	    atomic_read(&fs_info->balance_pause_req) ||
@@ -3067,22 +3073,26 @@ int btrfs_balance(struct btrfs_balance_control *bctl,
 	/* allow to reduce meta or sys integrity only if force set */
 	allowed = BTRFS_BLOCK_GROUP_DUP | BTRFS_BLOCK_GROUP_RAID1 |
 			BTRFS_BLOCK_GROUP_RAID10;
-	if (((bctl->sys.flags & BTRFS_BALANCE_ARGS_CONVERT) &&
-	     (fs_info->avail_system_alloc_bits & allowed) &&
-	     !(bctl->sys.target & allowed)) ||
-	    ((bctl->meta.flags & BTRFS_BALANCE_ARGS_CONVERT) &&
-	     (fs_info->avail_metadata_alloc_bits & allowed) &&
-	     !(bctl->meta.target & allowed))) {
-		if (bctl->flags & BTRFS_BALANCE_FORCE) {
-			printk(KERN_INFO "btrfs: force reducing metadata "
-			       "integrity\n");
-		} else {
-			printk(KERN_ERR "btrfs: balance will reduce metadata "
-			       "integrity, use force if you want this\n");
-			ret = -EINVAL;
-			goto out;
+	do {
+		seq = read_seqbegin(&fs_info->profiles_lock);
+
+		if (((bctl->sys.flags & BTRFS_BALANCE_ARGS_CONVERT) &&
+		     (fs_info->avail_system_alloc_bits & allowed) &&
+		     !(bctl->sys.target & allowed)) ||
+		    ((bctl->meta.flags & BTRFS_BALANCE_ARGS_CONVERT) &&
+		     (fs_info->avail_metadata_alloc_bits & allowed) &&
+		     !(bctl->meta.target & allowed))) {
+			if (bctl->flags & BTRFS_BALANCE_FORCE) {
+				printk(KERN_INFO "btrfs: force reducing metadata "
+				       "integrity\n");
+			} else {
+				printk(KERN_ERR "btrfs: balance will reduce metadata "
+				       "integrity, use force if you want this\n");
+				ret = -EINVAL;
+				goto out;
+			}
 		}
-	}
+	} while (read_seqretry(&fs_info->profiles_lock, seq));
 
 	if (bctl->sys.flags & BTRFS_BALANCE_ARGS_CONVERT) {
 		int num_tolerated_disk_barrier_failures;
@@ -3886,10 +3896,7 @@ static noinline int init_first_rw_device(struct btrfs_trans_handle *trans,
 	if (ret)
 		return ret;
 
-	alloc_profile = BTRFS_BLOCK_GROUP_METADATA |
-				fs_info->avail_metadata_alloc_bits;
-	alloc_profile = btrfs_reduce_alloc_profile(root, alloc_profile);
-
+	alloc_profile = btrfs_get_alloc_profile(extent_root, 0);
 	ret = __btrfs_alloc_chunk(trans, extent_root, &map, &chunk_size,
 				  &stripe_size, chunk_offset, alloc_profile);
 	if (ret)
@@ -3897,10 +3904,7 @@ static noinline int init_first_rw_device(struct btrfs_trans_handle *trans,
 
 	sys_chunk_offset = chunk_offset + chunk_size;
 
-	alloc_profile = BTRFS_BLOCK_GROUP_SYSTEM |
-				fs_info->avail_system_alloc_bits;
-	alloc_profile = btrfs_reduce_alloc_profile(root, alloc_profile);
-
+	alloc_profile = btrfs_get_alloc_profile(fs_info->chunk_root, 0);
 	ret = __btrfs_alloc_chunk(trans, extent_root, &sys_map,
 				  &sys_chunk_size, &sys_stripe_size,
 				  sys_chunk_offset, alloc_profile);
-- 
1.7.11.7

