Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from e39.co.us.ibm.com ([32.97.110.160]:42265 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753093Ab3EFIxL (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 6 May 2013 04:53:11 -0400
Received: from /spool/local
	by e39.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <zwu.kernel@gmail.com>;
	Mon, 6 May 2013 02:53:11 -0600
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by d01dlp02.pok.ibm.com (Postfix) with ESMTP id DB2406E803A
	for <linux-btrfs@vger.kernel.org>; Mon,  6 May 2013 04:53:04 -0400 (EDT)
Received: from d01av01.pok.ibm.com (d01av01.pok.ibm.com [9.56.224.215])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id r468r7hE301034
	for <linux-btrfs@vger.kernel.org>; Mon, 6 May 2013 04:53:07 -0400
Received: from d01av01.pok.ibm.com (loopback [127.0.0.1])
	by d01av01.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id r468r7LO003977
	for <linux-btrfs@vger.kernel.org>; Mon, 6 May 2013 04:53:07 -0400
From: zwu.kernel@gmail.com
To: linux-btrfs@vger.kernel.org
Cc: sekharan@us.ibm.com, chris.mason@fusionio.com, idryomov@gmail.com,
        Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
Subject: [RFC 2/5] btrfs: add one new block group
Date: Mon,  6 May 2013 16:53:35 +0800
Message-Id: <1367830418-26865-3-git-send-email-zwu.kernel@gmail.com>
In-Reply-To: <1367830418-26865-1-git-send-email-zwu.kernel@gmail.com>
References: <1367830418-26865-1-git-send-email-zwu.kernel@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>

  Introduce one new block group BTRFS_BLOCK_GROUP_DATA_SSD,
which is used to differentiate if the block space is reserved
and allocated from one HDD disk or SSD disk.

Signed-off-by: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
---
 fs/btrfs/Makefile       |   3 +-
 fs/btrfs/ctree.h        |  24 ++++++++++-
 fs/btrfs/extent-tree.c  | 107 +++++++++++++++++++++++++++++++++++++++++++-----
 fs/btrfs/extent_io.c    |  31 ++++++++++++--
 fs/btrfs/extent_io.h    |   4 ++
 fs/btrfs/file.c         |  36 +++++++++++++---
 fs/btrfs/hot_relocate.c |  78 +++++++++++++++++++++++++++++++++++
 fs/btrfs/hot_relocate.h |  31 ++++++++++++++
 fs/btrfs/inode-map.c    |  13 +++++-
 fs/btrfs/inode.c        |  92 +++++++++++++++++++++++++++++++++--------
 fs/btrfs/ioctl.c        |  23 +++++++++--
 fs/btrfs/relocation.c   |  14 ++++++-
 fs/btrfs/super.c        |   3 +-
 fs/btrfs/volumes.c      |  28 ++++++++++++-
 14 files changed, 439 insertions(+), 48 deletions(-)
 create mode 100644 fs/btrfs/hot_relocate.c
 create mode 100644 fs/btrfs/hot_relocate.h

diff --git a/fs/btrfs/Makefile b/fs/btrfs/Makefile
index 3932224..94f1ea5 100644
--- a/fs/btrfs/Makefile
+++ b/fs/btrfs/Makefile
@@ -8,7 +8,8 @@ btrfs-y += super.o ctree.o extent-tree.o print-tree.o root-tree.o dir-item.o \
 	   extent_io.o volumes.o async-thread.o ioctl.o locking.o orphan.o \
 	   export.o tree-log.o free-space-cache.o zlib.o lzo.o \
 	   compression.o delayed-ref.o relocation.o delayed-inode.o scrub.o \
-	   reada.o backref.o ulist.o qgroup.o send.o dev-replace.o raid56.o
+	   reada.o backref.o ulist.o qgroup.o send.o dev-replace.o raid56.o \
+	   hot_relocate.o
 
 btrfs-$(CONFIG_BTRFS_FS_POSIX_ACL) += acl.o
 btrfs-$(CONFIG_BTRFS_FS_CHECK_INTEGRITY) += check-integrity.o
diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 701dec5..f4c4419 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -961,6 +961,16 @@ struct btrfs_dev_replace_item {
 #define BTRFS_BLOCK_GROUP_RAID10	(1ULL << 6)
 #define BTRFS_BLOCK_GROUP_RAID5    (1 << 7)
 #define BTRFS_BLOCK_GROUP_RAID6    (1 << 8)
+/*
+ * New block groups for use with hot data relocation feature. When hot data
+ * relocation is on, *_SSD block groups are forced to nonrotating drives and
+ * the plain DATA and METADATA block groups are forced to rotating drives.
+ *
+ * This should be further optimized, i.e. force metadata to SSD or relocate
+ * inode metadata to SSD when any of its subfile ranges are relocated to SSD
+ * so that reads and writes aren't delayed by HDD seeks.
+ */
+#define BTRFS_BLOCK_GROUP_DATA_SSD	(1ULL << 9)
 #define BTRFS_BLOCK_GROUP_RESERVED	BTRFS_AVAIL_ALLOC_BIT_SINGLE
 
 enum btrfs_raid_types {
@@ -976,7 +986,8 @@ enum btrfs_raid_types {
 
 #define BTRFS_BLOCK_GROUP_TYPE_MASK	(BTRFS_BLOCK_GROUP_DATA |    \
 					 BTRFS_BLOCK_GROUP_SYSTEM |  \
-					 BTRFS_BLOCK_GROUP_METADATA)
+					 BTRFS_BLOCK_GROUP_METADATA | \
+					 BTRFS_BLOCK_GROUP_DATA_SSD)
 
 #define BTRFS_BLOCK_GROUP_PROFILE_MASK	(BTRFS_BLOCK_GROUP_RAID0 |   \
 					 BTRFS_BLOCK_GROUP_RAID1 |   \
@@ -1508,6 +1519,7 @@ struct btrfs_fs_info {
 	struct list_head space_info;
 
 	struct btrfs_space_info *data_sinfo;
+	struct btrfs_space_info *hot_data_sinfo;
 
 	struct reloc_control *reloc_ctl;
 
@@ -1532,6 +1544,7 @@ struct btrfs_fs_info {
 	u64 avail_data_alloc_bits;
 	u64 avail_metadata_alloc_bits;
 	u64 avail_system_alloc_bits;
+	u64 avail_data_ssd_alloc_bits;
 
 	/* restriper state */
 	spinlock_t balance_lock;
@@ -1544,6 +1557,7 @@ struct btrfs_fs_info {
 
 	unsigned data_chunk_allocations;
 	unsigned metadata_ratio;
+	unsigned data_ssd_chunk_allocations;
 
 	void *bdev_holder;
 
@@ -1901,6 +1915,7 @@ struct btrfs_ioctl_defrag_range_args {
 #define BTRFS_MOUNT_CHECK_INTEGRITY_INCLUDING_EXTENT_DATA (1 << 21)
 #define BTRFS_MOUNT_PANIC_ON_FATAL_ERROR	(1 << 22)
 #define BTRFS_MOUNT_HOT_TRACK		(1 << 23)
+#define BTRFS_MOUNT_HOT_MOVE		(1 << 24)
 
 #define btrfs_clear_opt(o, opt)		((o) &= ~BTRFS_MOUNT_##opt)
 #define btrfs_set_opt(o, opt)		((o) |= BTRFS_MOUNT_##opt)
@@ -1922,6 +1937,7 @@ struct btrfs_ioctl_defrag_range_args {
 #define BTRFS_INODE_NOATIME		(1 << 9)
 #define BTRFS_INODE_DIRSYNC		(1 << 10)
 #define BTRFS_INODE_COMPRESS		(1 << 11)
+#define BTRFS_INODE_HOT			(1 << 12)
 
 #define BTRFS_INODE_ROOT_ITEM_INIT	(1 << 31)
 
@@ -3014,6 +3030,8 @@ int btrfs_pin_extent_for_log_replay(struct btrfs_root *root,
 int btrfs_cross_ref_exist(struct btrfs_trans_handle *trans,
 			  struct btrfs_root *root,
 			  u64 objectid, u64 offset, u64 bytenr);
+struct btrfs_block_group_cache *btrfs_lookup_first_block_group(
+				struct btrfs_fs_info *info, u64 bytenr);
 struct btrfs_block_group_cache *btrfs_lookup_block_group(
 						 struct btrfs_fs_info *info,
 						 u64 bytenr);
@@ -3070,6 +3088,8 @@ int btrfs_inc_extent_ref(struct btrfs_trans_handle *trans,
 			 struct btrfs_root *root,
 			 u64 bytenr, u64 num_bytes, u64 parent,
 			 u64 root_objectid, u64 owner, u64 offset, int for_cow);
+struct btrfs_block_group_cache *next_block_group(struct btrfs_root *root,
+			 struct btrfs_block_group_cache *cache);
 
 int btrfs_write_dirty_block_groups(struct btrfs_trans_handle *trans,
 				    struct btrfs_root *root);
@@ -3102,6 +3122,7 @@ enum btrfs_reserve_flush_enum {
 
 int btrfs_check_data_free_space(struct inode *inode, u64 bytes);
 void btrfs_free_reserved_data_space(struct inode *inode, u64 bytes);
+void btrfs_free_reserved_ssd_data_space(struct inode *inode, u64 bytes);
 void btrfs_trans_release_metadata(struct btrfs_trans_handle *trans,
 				struct btrfs_root *root);
 int btrfs_orphan_reserve_metadata(struct btrfs_trans_handle *trans,
@@ -3118,6 +3139,7 @@ int btrfs_delalloc_reserve_metadata(struct inode *inode, u64 num_bytes);
 void btrfs_delalloc_release_metadata(struct inode *inode, u64 num_bytes);
 int btrfs_delalloc_reserve_space(struct inode *inode, u64 num_bytes);
 void btrfs_delalloc_release_space(struct inode *inode, u64 num_bytes);
+void btrfs_delalloc_release_ssd_space(struct inode *inode, u64 num_bytes);
 void btrfs_init_block_rsv(struct btrfs_block_rsv *rsv, unsigned short type);
 struct btrfs_block_rsv *btrfs_alloc_block_rsv(struct btrfs_root *root,
 					      unsigned short type);
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 3d55123..676b08e 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -598,7 +598,7 @@ static int cache_block_group(struct btrfs_block_group_cache *cache,
 /*
  * return the block group that starts at or after bytenr
  */
-static struct btrfs_block_group_cache *
+struct btrfs_block_group_cache *
 btrfs_lookup_first_block_group(struct btrfs_fs_info *info, u64 bytenr)
 {
 	struct btrfs_block_group_cache *cache;
@@ -2961,7 +2961,7 @@ fail:
 
 }
 
-static struct btrfs_block_group_cache *
+struct btrfs_block_group_cache *
 next_block_group(struct btrfs_root *root,
 		 struct btrfs_block_group_cache *cache)
 {
@@ -3082,7 +3082,12 @@ again:
 					      &alloc_hint);
 	if (!ret)
 		dcs = BTRFS_DC_SETUP;
-	btrfs_free_reserved_data_space(inode, num_pages);
+
+	if (BTRFS_I(inode)->flags & BTRFS_INODE_HOT) {
+		BTRFS_I(inode)->flags &= ~BTRFS_INODE_HOT;
+		btrfs_free_reserved_ssd_data_space(inode, num_pages);
+	} else
+		btrfs_free_reserved_data_space(inode, num_pages);
 
 out_put:
 	iput(inode);
@@ -3284,6 +3289,8 @@ static int update_space_info(struct btrfs_fs_info *info, u64 flags,
 	list_add_rcu(&found->list, &info->space_info);
 	if (flags & BTRFS_BLOCK_GROUP_DATA)
 		info->data_sinfo = found;
+	else if (flags & BTRFS_BLOCK_GROUP_DATA_SSD)
+		info->hot_data_sinfo = found;
 	return 0;
 }
 
@@ -3299,6 +3306,8 @@ static void set_avail_alloc_bits(struct btrfs_fs_info *fs_info, u64 flags)
 		fs_info->avail_metadata_alloc_bits |= extra_flags;
 	if (flags & BTRFS_BLOCK_GROUP_SYSTEM)
 		fs_info->avail_system_alloc_bits |= extra_flags;
+	if (flags & BTRFS_BLOCK_GROUP_DATA_SSD)
+		fs_info->avail_data_ssd_alloc_bits |= extra_flags;
 	write_sequnlock(&fs_info->profiles_lock);
 }
 
@@ -3405,18 +3414,27 @@ static u64 get_alloc_profile(struct btrfs_root *root, u64 flags)
 			flags |= root->fs_info->avail_system_alloc_bits;
 		else if (flags & BTRFS_BLOCK_GROUP_METADATA)
 			flags |= root->fs_info->avail_metadata_alloc_bits;
+		else if (flags & BTRFS_BLOCK_GROUP_DATA_SSD)
+			flags |= root->fs_info->avail_data_ssd_alloc_bits;
 	} while (read_seqretry(&root->fs_info->profiles_lock, seq));
 
 	return btrfs_reduce_alloc_profile(root, flags);
 }
 
+/*
+ * Turns a chunk_type integer into set of block group flags (a profile).
+ * Hot data relocation code adds chunk_types 2 and 3 for hot data specific
+ * block group types.
+ */
 u64 btrfs_get_alloc_profile(struct btrfs_root *root, int data)
 {
 	u64 flags;
 	u64 ret;
 
-	if (data)
+	if (data == 1)
 		flags = BTRFS_BLOCK_GROUP_DATA;
+	else if (data == 2)
+		flags = BTRFS_BLOCK_GROUP_DATA_SSD;
 	else if (root == root->fs_info->chunk_root)
 		flags = BTRFS_BLOCK_GROUP_SYSTEM;
 	else
@@ -3437,6 +3455,7 @@ int btrfs_check_data_free_space(struct inode *inode, u64 bytes)
 	struct btrfs_fs_info *fs_info = root->fs_info;
 	u64 used;
 	int ret = 0, committed = 0, alloc_chunk = 1;
+	int data, tried = 0;
 
 	/* make sure bytes are sectorsize aligned */
 	bytes = ALIGN(bytes, root->sectorsize);
@@ -3447,7 +3466,15 @@ int btrfs_check_data_free_space(struct inode *inode, u64 bytes)
 		committed = 1;
 	}
 
-	data_sinfo = fs_info->data_sinfo;
+	if (BTRFS_I(inode)->flags & BTRFS_INODE_HOT) {
+try_hot:
+		data = 2;
+		data_sinfo = fs_info->hot_data_sinfo;
+	} else {
+		data = 1;
+		data_sinfo = fs_info->data_sinfo;
+	}
+
 	if (!data_sinfo)
 		goto alloc;
 
@@ -3465,13 +3492,22 @@ again:
 		 * if we don't have enough free bytes in this space then we need
 		 * to alloc a new chunk.
 		 */
-		if (!data_sinfo->full && alloc_chunk) {
+		if (alloc_chunk) {
 			u64 alloc_target;
 
+			if (data_sinfo->full) {
+				if (!tried) {
+					tried = 1;
+					spin_unlock(&data_sinfo->lock);
+					goto try_hot;
+				} else
+					goto non_alloc;
+			}
+
 			data_sinfo->force_alloc = CHUNK_ALLOC_FORCE;
 			spin_unlock(&data_sinfo->lock);
 alloc:
-			alloc_target = btrfs_get_alloc_profile(root, 1);
+			alloc_target = btrfs_get_alloc_profile(root, data);
 			trans = btrfs_join_transaction(root);
 			if (IS_ERR(trans))
 				return PTR_ERR(trans);
@@ -3488,11 +3524,13 @@ alloc:
 			}
 
 			if (!data_sinfo)
-				data_sinfo = fs_info->data_sinfo;
+				data_sinfo = (data == 1) ? fs_info->data_sinfo :
+						fs_info->hot_data_sinfo;
 
 			goto again;
 		}
 
+non_alloc:
 		/*
 		 * If we have less pinned bytes than we want to allocate then
 		 * don't bother committing the transaction, it won't help us.
@@ -3503,7 +3541,7 @@ alloc:
 
 		/* commit the current transaction and try again */
 commit_trans:
-		if (!committed &&
+		if (!committed && data_sinfo &&
 		    !atomic_read(&root->fs_info->open_ioctl_trans)) {
 			committed = 1;
 			trans = btrfs_join_transaction(root);
@@ -3517,6 +3555,10 @@ commit_trans:
 
 		return -ENOSPC;
 	}
+
+	if (tried)
+		BTRFS_I(inode)->flags |= BTRFS_INODE_HOT;
+
 	data_sinfo->bytes_may_use += bytes;
 	trace_btrfs_space_reservation(root->fs_info, "space_info",
 				      data_sinfo->flags, bytes, 1);
@@ -3544,6 +3586,22 @@ void btrfs_free_reserved_data_space(struct inode *inode, u64 bytes)
 	spin_unlock(&data_sinfo->lock);
 }
 
+void btrfs_free_reserved_ssd_data_space(struct inode *inode, u64 bytes)
+{
+	struct btrfs_root *root = BTRFS_I(inode)->root;
+	struct btrfs_space_info *data_sinfo;
+
+	/* make sure bytes are sectorsize aligned */
+	bytes = ALIGN(bytes, root->sectorsize);
+
+	data_sinfo = root->fs_info->hot_data_sinfo;
+	spin_lock(&data_sinfo->lock);
+	data_sinfo->bytes_may_use -= bytes;
+	trace_btrfs_space_reservation(root->fs_info, "space_info",
+				      data_sinfo->flags, bytes, 0);
+	spin_unlock(&data_sinfo->lock);
+}
+
 static void force_metadata_allocation(struct btrfs_fs_info *info)
 {
 	struct list_head *head = &info->space_info;
@@ -3715,6 +3773,13 @@ again:
 			force_metadata_allocation(fs_info);
 	}
 
+	if (flags & BTRFS_BLOCK_GROUP_DATA_SSD && fs_info->metadata_ratio) {
+		fs_info->data_ssd_chunk_allocations++;
+		if (!(fs_info->data_ssd_chunk_allocations %
+			fs_info->metadata_ratio))
+				force_metadata_allocation(fs_info);
+	}
+
 	/*
 	 * Check if we have enough space in SYSTEM chunk because we may need
 	 * to update devices.
@@ -4422,6 +4487,13 @@ static u64 calc_global_metadata_size(struct btrfs_fs_info *fs_info)
 	meta_used = sinfo->bytes_used;
 	spin_unlock(&sinfo->lock);
 
+	sinfo = __find_space_info(fs_info, BTRFS_BLOCK_GROUP_DATA_SSD);
+	if (sinfo) {
+		spin_lock(&sinfo->lock);
+		data_used += sinfo->bytes_used;
+		spin_unlock(&sinfo->lock);
+	}
+
 	num_bytes = (data_used >> fs_info->sb->s_blocksize_bits) *
 		    csum_size * 2;
 	num_bytes += div64_u64(data_used + meta_used, 50);
@@ -4916,7 +4988,11 @@ int btrfs_delalloc_reserve_space(struct inode *inode, u64 num_bytes)
 
 	ret = btrfs_delalloc_reserve_metadata(inode, num_bytes);
 	if (ret) {
-		btrfs_free_reserved_data_space(inode, num_bytes);
+		if (BTRFS_I(inode)->flags & BTRFS_INODE_HOT) {
+			BTRFS_I(inode)->flags &= ~BTRFS_INODE_HOT;
+			btrfs_free_reserved_ssd_data_space(inode, num_bytes);
+		} else
+			btrfs_free_reserved_data_space(inode, num_bytes);
 		return ret;
 	}
 
@@ -4942,6 +5018,12 @@ void btrfs_delalloc_release_space(struct inode *inode, u64 num_bytes)
 	btrfs_free_reserved_data_space(inode, num_bytes);
 }
 
+void btrfs_delalloc_release_ssd_space(struct inode *inode, u64 num_bytes)
+{
+	btrfs_delalloc_release_metadata(inode, num_bytes);
+	btrfs_free_reserved_ssd_data_space(inode, num_bytes);
+}
+
 static int update_block_group(struct btrfs_root *root,
 			      u64 bytenr, u64 num_bytes, int alloc)
 {
@@ -5770,7 +5852,8 @@ static noinline int find_free_extent(struct btrfs_trans_handle *trans,
 	struct btrfs_space_info *space_info;
 	int loop = 0;
 	int index = __get_raid_index(data);
-	int alloc_type = (data & BTRFS_BLOCK_GROUP_DATA) ?
+	int alloc_type = ((data & BTRFS_BLOCK_GROUP_DATA)
+		|| (data & BTRFS_BLOCK_GROUP_DATA_SSD)) ?
 		RESERVE_ALLOC_NO_ACCOUNT : RESERVE_ALLOC;
 	bool found_uncached_bg = false;
 	bool failed_cluster_refill = false;
@@ -8189,6 +8272,8 @@ static void clear_avail_alloc_bits(struct btrfs_fs_info *fs_info, u64 flags)
 		fs_info->avail_metadata_alloc_bits &= ~extra_flags;
 	if (flags & BTRFS_BLOCK_GROUP_SYSTEM)
 		fs_info->avail_system_alloc_bits &= ~extra_flags;
+	if (flags & BTRFS_BLOCK_GROUP_DATA_SSD)
+		fs_info->avail_data_ssd_alloc_bits &= ~extra_flags;
 	write_sequnlock(&fs_info->profiles_lock);
 }
 
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index cdee391..608b7a8 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -1400,9 +1400,11 @@ static noinline u64 find_delalloc_range(struct extent_io_tree *tree,
 {
 	struct rb_node *node;
 	struct extent_state *state;
+	struct btrfs_root *root;
 	u64 cur_start = *start;
 	u64 found = 0;
 	u64 total_bytes = 0;
+	int flag = EXTENT_DELALLOC;
 
 	spin_lock(&tree->lock);
 
@@ -1417,13 +1419,27 @@ static noinline u64 find_delalloc_range(struct extent_io_tree *tree,
 		goto out;
 	}
 
+	root = BTRFS_I(tree->mapping->host)->root;
 	while (1) {
 		state = rb_entry(node, struct extent_state, rb_node);
 		if (found && (state->start != cur_start ||
 			      (state->state & EXTENT_BOUNDARY))) {
 			goto out;
 		}
-		if (!(state->state & EXTENT_DELALLOC)) {
+		if (btrfs_test_opt(root, HOT_MOVE)) {
+			if (!(state->state & EXTENT_DELALLOC) ||
+				(!(state->state & EXTENT_HOT) &&
+				!(state->state & EXTENT_COLD))) {
+				if (!found)
+					*end = state->end;
+				goto out;
+			} else {
+				if (!found)
+					flag = (state->state & EXTENT_HOT) ?
+						EXTENT_HOT : EXTENT_COLD;
+			}
+		}
+		if (!(state->state & flag)) {
 			if (!found)
 				*end = state->end;
 			goto out;
@@ -1610,7 +1626,13 @@ again:
 	lock_extent_bits(tree, delalloc_start, delalloc_end, 0, &cached_state);
 
 	/* then test to make sure it is all still delalloc */
-	ret = test_range_bit(tree, delalloc_start, delalloc_end,
+	if (btrfs_test_opt(BTRFS_I(inode)->root, HOT_MOVE)) {
+		ret = test_range_bit(tree, delalloc_start, delalloc_end,
+			     EXTENT_DELALLOC | EXTENT_HOT, 1, cached_state);
+		ret |= test_range_bit(tree, delalloc_start, delalloc_end,
+			     EXTENT_DELALLOC | EXTENT_COLD, 1, cached_state);
+	} else
+		ret = test_range_bit(tree, delalloc_start, delalloc_end,
 			     EXTENT_DELALLOC, 1, cached_state);
 	if (!ret) {
 		unlock_extent_cached(tree, delalloc_start, delalloc_end,
@@ -1644,7 +1666,10 @@ int extent_clear_unlock_delalloc(struct inode *inode,
 		clear_bits |= EXTENT_LOCKED;
 	if (op & EXTENT_CLEAR_DIRTY)
 		clear_bits |= EXTENT_DIRTY;
-
+	if (op & EXTENT_CLEAR_HOT)
+		clear_bits |= EXTENT_HOT;
+	if (op & EXTENT_CLEAR_COLD)
+		clear_bits |= EXTENT_COLD;
 	if (op & EXTENT_CLEAR_DELALLOC)
 		clear_bits |= EXTENT_DELALLOC;
 
diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
index 258c921..35e155f 100644
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -19,6 +19,8 @@
 #define EXTENT_FIRST_DELALLOC (1 << 12)
 #define EXTENT_NEED_WAIT (1 << 13)
 #define EXTENT_DAMAGED (1 << 14)
+#define EXTENT_HOT (1 << 15)
+#define EXTENT_COLD (1 << 16)
 #define EXTENT_IOBITS (EXTENT_LOCKED | EXTENT_WRITEBACK)
 #define EXTENT_CTLBITS (EXTENT_DO_ACCOUNTING | EXTENT_FIRST_DELALLOC)
 
@@ -51,6 +53,8 @@
 #define EXTENT_END_WRITEBACK	 0x20
 #define EXTENT_SET_PRIVATE2	 0x40
 #define EXTENT_CLEAR_ACCOUNTING  0x80
+#define EXTENT_CLEAR_HOT	 0x100
+#define EXTENT_CLEAR_COLD	 0x200
 
 /*
  * page->private values.  Every page that is controlled by the extent
diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index ade03e6..941b50e 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -40,6 +40,7 @@
 #include "locking.h"
 #include "compat.h"
 #include "volumes.h"
+#include "hot_relocate.h"
 
 static struct kmem_cache *btrfs_inode_defrag_cachep;
 /*
@@ -513,6 +514,10 @@ int btrfs_dirty_pages(struct btrfs_root *root, struct inode *inode,
 	num_bytes = ALIGN(write_bytes + pos - start_pos, root->sectorsize);
 
 	end_of_last_block = start_pos + num_bytes - 1;
+
+	if (btrfs_test_opt(root, HOT_MOVE))
+		hot_set_extent(inode, start_pos, end_of_last_block, cached, 1);
+
 	err = btrfs_set_extent_delalloc(inode, start_pos, end_of_last_block,
 					cached);
 	if (err)
@@ -1372,7 +1377,12 @@ static noinline ssize_t __btrfs_buffered_write(struct file *file,
 				    pos, first_index, write_bytes,
 				    force_page_uptodate);
 		if (ret) {
-			btrfs_delalloc_release_space(inode,
+			if (BTRFS_I(inode)->flags & BTRFS_INODE_HOT) {
+				BTRFS_I(inode)->flags &= ~BTRFS_INODE_HOT;
+				btrfs_delalloc_release_ssd_space(inode,
+					num_pages << PAGE_CACHE_SHIFT);
+			} else
+				btrfs_delalloc_release_space(inode,
 					num_pages << PAGE_CACHE_SHIFT);
 			break;
 		}
@@ -1410,7 +1420,12 @@ static noinline ssize_t __btrfs_buffered_write(struct file *file,
 				BTRFS_I(inode)->outstanding_extents++;
 				spin_unlock(&BTRFS_I(inode)->lock);
 			}
-			btrfs_delalloc_release_space(inode,
+			if (BTRFS_I(inode)->flags & BTRFS_INODE_HOT)
+				btrfs_delalloc_release_ssd_space(inode,
+					(num_pages - dirty_pages) <<
+					PAGE_CACHE_SHIFT);
+			else
+				btrfs_delalloc_release_space(inode,
 					(num_pages - dirty_pages) <<
 					PAGE_CACHE_SHIFT);
 		}
@@ -1420,8 +1435,13 @@ static noinline ssize_t __btrfs_buffered_write(struct file *file,
 						dirty_pages, pos, copied,
 						NULL);
 			if (ret) {
-				btrfs_delalloc_release_space(inode,
-					dirty_pages << PAGE_CACHE_SHIFT);
+				if (BTRFS_I(inode)->flags & BTRFS_INODE_HOT) {
+					BTRFS_I(inode)->flags &= ~BTRFS_INODE_HOT;
+					btrfs_delalloc_release_ssd_space(inode,
+						dirty_pages << PAGE_CACHE_SHIFT);
+				} else
+					btrfs_delalloc_release_space(inode,
+						dirty_pages << PAGE_CACHE_SHIFT);
 				btrfs_drop_pages(pages, num_pages);
 				break;
 			}
@@ -2282,7 +2302,13 @@ out:
 		btrfs_qgroup_free(root, alloc_end - alloc_start);
 out_reserve_fail:
 	/* Let go of our reservation. */
-	btrfs_free_reserved_data_space(inode, alloc_end - alloc_start);
+	if (BTRFS_I(inode)->flags & BTRFS_INODE_HOT) {
+		BTRFS_I(inode)->flags &= ~BTRFS_INODE_HOT;
+		btrfs_free_reserved_ssd_data_space(inode,
+					alloc_end - alloc_start);
+	} else
+		btrfs_free_reserved_data_space(inode,
+					alloc_end - alloc_start);
 	return ret;
 }
 
diff --git a/fs/btrfs/hot_relocate.c b/fs/btrfs/hot_relocate.c
new file mode 100644
index 0000000..1effd14
--- /dev/null
+++ b/fs/btrfs/hot_relocate.c
@@ -0,0 +1,78 @@
+/*
+ * fs/btrfs/hot_relocate.c
+ *
+ * Copyright (C) 2013 IBM Corp. All rights reserved.
+ * Written by Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
+ *            Ben Chociej <bchociej@gmail.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public
+ * License v2 as published by the Free Software Foundation.
+ */
+
+#include <linux/list.h>
+#include <linux/spinlock.h>
+#include "hot_relocate.h"
+
+static void hot_set_extent_bits(struct extent_io_tree *tree, u64 start,
+		u64 end, struct extent_state **cached_state,
+		gfp_t mask, int storage_type, int flag)
+{
+	int set_bits = 0, clear_bits = 0;
+
+	if (flag) {
+		set_bits = EXTENT_DELALLOC | EXTENT_UPTODATE;
+		clear_bits = EXTENT_DIRTY | EXTENT_DELALLOC |
+				EXTENT_DO_ACCOUNTING;
+	}
+
+	if (storage_type == ON_ROT_DISK) {
+		set_bits |= EXTENT_COLD;
+		clear_bits |= EXTENT_HOT;
+	} else if (storage_type == ON_NONROT_DISK) {
+		set_bits |= EXTENT_HOT;
+		clear_bits |= EXTENT_COLD;
+	}
+
+	clear_extent_bit(tree, start, end, clear_bits,
+			0, 0, cached_state, mask);
+	set_extent_bit(tree, start, end, set_bits, NULL,
+			cached_state, mask);
+}
+
+void hot_set_extent(struct inode *inode, u64 start, u64 end,
+		struct extent_state **cached_state, int flag)
+{
+	int storage_type;
+
+	if (BTRFS_I(inode)->flags & BTRFS_INODE_HOT) {
+		if (flag)
+			BTRFS_I(inode)->flags &= ~BTRFS_INODE_HOT;
+		storage_type = TYPE_NONROT;
+	} else
+		storage_type = TYPE_ROT;
+
+	hot_set_extent_bits(&BTRFS_I(inode)->io_tree, start,
+			end, cached_state, GFP_NOFS, storage_type, 0);
+}
+
+int hot_get_chunk_type(struct inode *inode, u64 start, u64 end)
+{
+	int hot, cold, ret = 1;
+
+	hot = test_range_bit(&BTRFS_I(inode)->io_tree,
+				start, end, EXTENT_HOT, 1, NULL);
+	cold = test_range_bit(&BTRFS_I(inode)->io_tree,
+				start, end, EXTENT_COLD, 1, NULL);
+
+	WARN_ON(hot && cold);
+
+	if (hot)
+		ret = 2;
+	else if (cold)
+		ret = 1;
+	else
+		WARN_ON(1);
+
+	return ret;
+}
diff --git a/fs/btrfs/hot_relocate.h b/fs/btrfs/hot_relocate.h
new file mode 100644
index 0000000..b8427ba
--- /dev/null
+++ b/fs/btrfs/hot_relocate.h
@@ -0,0 +1,31 @@
+/*
+ * fs/btrfs/hot_relocate.h
+ *
+ * Copyright (C) 2013 IBM Corp. All rights reserved.
+ * Written by Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
+ *	      Ben Chociej <bchociej@gmail.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public
+ * License v2 as published by the Free Software Foundation.
+ */
+
+#ifndef __HOT_RELOCATE__
+#define __HOT_RELOCATE__
+
+#include <linux/hot_tracking.h>
+#include "ctree.h"
+#include "btrfs_inode.h"
+#include "volumes.h"
+
+enum {
+	TYPE_ROT,       /* rot -> rotating */
+	TYPE_NONROT,    /* nonrot -> nonrotating */
+	MAX_RELOC_TYPES
+};
+
+void hot_set_extent(struct inode *inode, u64 start, u64 end,
+		struct extent_state **cached_state, int flag);
+int hot_get_chunk_type(struct inode *inode, u64 start, u64 end);
+
+#endif /* __HOT_RELOCATE__ */
diff --git a/fs/btrfs/inode-map.c b/fs/btrfs/inode-map.c
index d26f67a..a720135 100644
--- a/fs/btrfs/inode-map.c
+++ b/fs/btrfs/inode-map.c
@@ -497,10 +497,19 @@ again:
 	ret = btrfs_prealloc_file_range_trans(inode, trans, 0, 0, prealloc,
 					      prealloc, prealloc, &alloc_hint);
 	if (ret) {
-		btrfs_delalloc_release_space(inode, prealloc);
+		if (BTRFS_I(inode)->flags & BTRFS_INODE_HOT) {
+			BTRFS_I(inode)->flags &= ~BTRFS_INODE_HOT;
+			btrfs_delalloc_release_ssd_space(inode, prealloc);
+		} else
+			btrfs_delalloc_release_space(inode, prealloc);
 		goto out_put;
 	}
-	btrfs_free_reserved_data_space(inode, prealloc);
+
+	if (BTRFS_I(inode)->flags & BTRFS_INODE_HOT) {
+		BTRFS_I(inode)->flags &= ~BTRFS_INODE_HOT;
+		btrfs_free_reserved_ssd_data_space(inode, prealloc);
+	} else
+		btrfs_free_reserved_data_space(inode, prealloc);
 
 	ret = btrfs_write_out_ino_cache(root, trans, path);
 out_put:
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 09c58a3..77eda44 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -56,6 +56,7 @@
 #include "free-space-cache.h"
 #include "inode-map.h"
 #include "backref.h"
+#include "hot_relocate.h"
 
 struct btrfs_iget_args {
 	u64 ino;
@@ -857,13 +858,14 @@ static noinline int __cow_file_range(struct btrfs_trans_handle *trans,
 {
 	u64 alloc_hint = 0;
 	u64 num_bytes;
-	unsigned long ram_size;
+	unsigned long ram_size, hot_flag = 0;
 	u64 disk_num_bytes;
 	u64 cur_alloc_size;
 	u64 blocksize = root->sectorsize;
 	struct btrfs_key ins;
 	struct extent_map *em;
 	struct extent_map_tree *em_tree = &BTRFS_I(inode)->extent_tree;
+	int chunk_type = 1;
 	int ret = 0;
 
 	BUG_ON(btrfs_is_free_space_inode(inode));
@@ -871,6 +873,7 @@ static noinline int __cow_file_range(struct btrfs_trans_handle *trans,
 	num_bytes = ALIGN(end - start + 1, blocksize);
 	num_bytes = max(blocksize,  num_bytes);
 	disk_num_bytes = num_bytes;
+	ret = 0;
 
 	/* if this is a small write inside eof, kick off defrag */
 	if (num_bytes < 64 * 1024 &&
@@ -890,7 +893,8 @@ static noinline int __cow_file_range(struct btrfs_trans_handle *trans,
 				     EXTENT_CLEAR_DELALLOC |
 				     EXTENT_CLEAR_DIRTY |
 				     EXTENT_SET_WRITEBACK |
-				     EXTENT_END_WRITEBACK);
+				     EXTENT_END_WRITEBACK |
+				     hot_flag);
 
 			*nr_written = *nr_written +
 			     (end - start + PAGE_CACHE_SIZE) / PAGE_CACHE_SIZE;
@@ -912,9 +916,25 @@ static noinline int __cow_file_range(struct btrfs_trans_handle *trans,
 		unsigned long op;
 
 		cur_alloc_size = disk_num_bytes;
+
+		/*
+		 * Use COW operations to move hot data to SSD and cold data
+		 * back to rotating disk. Sets chunk_type to 1 to indicate
+		 * to write to BTRFS_BLOCK_GROUP_DATA or 2 to indicate
+		 * BTRFS_BLOCK_GROUP_DATA_SSD.
+		 */
+		if (btrfs_test_opt(root, HOT_MOVE)) {
+			chunk_type = hot_get_chunk_type(inode, start,
+						start + cur_alloc_size - 1);
+			if (chunk_type == 1)
+				hot_flag = EXTENT_CLEAR_COLD;
+			if (chunk_type == 2)
+				hot_flag = EXTENT_CLEAR_HOT;
+		}
+
 		ret = btrfs_reserve_extent(trans, root, cur_alloc_size,
 					   root->sectorsize, 0, alloc_hint,
-					   &ins, 1);
+					   &ins, chunk_type);
 		if (ret < 0) {
 			btrfs_abort_transaction(trans, root, ret);
 			goto out_unlock;
@@ -978,7 +998,7 @@ static noinline int __cow_file_range(struct btrfs_trans_handle *trans,
 		 */
 		op = unlock ? EXTENT_CLEAR_UNLOCK_PAGE : 0;
 		op |= EXTENT_CLEAR_UNLOCK | EXTENT_CLEAR_DELALLOC |
-			EXTENT_SET_PRIVATE2;
+			EXTENT_SET_PRIVATE2 | hot_flag;
 
 		extent_clear_unlock_delalloc(inode, &BTRFS_I(inode)->io_tree,
 					     start, start + ram_size - 1,
@@ -1000,7 +1020,8 @@ out_unlock:
 		     EXTENT_CLEAR_DELALLOC |
 		     EXTENT_CLEAR_DIRTY |
 		     EXTENT_SET_WRITEBACK |
-		     EXTENT_END_WRITEBACK);
+		     EXTENT_END_WRITEBACK |
+		     hot_flag);
 
 	goto out;
 }
@@ -1593,8 +1614,12 @@ static void btrfs_clear_bit_hook(struct inode *inode,
 			btrfs_delalloc_release_metadata(inode, len);
 
 		if (root->root_key.objectid != BTRFS_DATA_RELOC_TREE_OBJECTID
-		    && do_list)
-			btrfs_free_reserved_data_space(inode, len);
+		    && do_list) {
+			if ((state->state & EXTENT_HOT) && (*bits & EXTENT_HOT))
+				btrfs_free_reserved_ssd_data_space(inode, len);
+			else
+				btrfs_free_reserved_data_space(inode, len);
+		}
 
 		__percpu_counter_add(&root->fs_info->delalloc_bytes, -len,
 				     root->fs_info->delalloc_batch);
@@ -1828,6 +1853,9 @@ again:
 		goto out;
 	 }
 
+	if (btrfs_test_opt(BTRFS_I(inode)->root, HOT_MOVE))
+		hot_set_extent(inode, page_start, page_end, &cached_state, 1);
+
 	btrfs_set_extent_delalloc(inode, page_start, page_end, &cached_state);
 	ClearPageChecked(page);
 	set_page_dirty(page);
@@ -4282,7 +4310,12 @@ int btrfs_truncate_page(struct inode *inode, loff_t from, loff_t len,
 again:
 	page = find_or_create_page(mapping, index, mask);
 	if (!page) {
-		btrfs_delalloc_release_space(inode, PAGE_CACHE_SIZE);
+		if (BTRFS_I(inode)->flags & BTRFS_INODE_HOT) {
+			BTRFS_I(inode)->flags &= ~BTRFS_INODE_HOT;
+			btrfs_delalloc_release_ssd_space(inode,
+							PAGE_CACHE_SIZE);
+		} else
+			btrfs_delalloc_release_space(inode, PAGE_CACHE_SIZE);
 		ret = -ENOMEM;
 		goto out;
 	}
@@ -4324,6 +4357,9 @@ again:
 			  EXTENT_DO_ACCOUNTING | EXTENT_DEFRAG,
 			  0, 0, &cached_state, GFP_NOFS);
 
+	if (btrfs_test_opt(root, HOT_MOVE))
+		hot_set_extent(inode, page_start, page_end, &cached_state, 0);
+
 	ret = btrfs_set_extent_delalloc(inode, page_start, page_end,
 					&cached_state);
 	if (ret) {
@@ -4332,6 +4368,8 @@ again:
 		goto out_unlock;
 	}
 
+	BTRFS_I(inode)->flags &= ~BTRFS_INODE_HOT;
+
 	if (offset != PAGE_CACHE_SIZE) {
 		if (!len)
 			len = PAGE_CACHE_SIZE - offset;
@@ -4349,8 +4387,14 @@ again:
 			     GFP_NOFS);
 
 out_unlock:
-	if (ret)
-		btrfs_delalloc_release_space(inode, PAGE_CACHE_SIZE);
+	if (ret) {
+		if (BTRFS_I(inode)->flags & BTRFS_INODE_HOT) {
+			BTRFS_I(inode)->flags &= ~BTRFS_INODE_HOT;
+			btrfs_delalloc_release_ssd_space(inode,
+							PAGE_CACHE_SIZE);
+		} else
+			btrfs_delalloc_release_space(inode, PAGE_CACHE_SIZE);
+	}
 	unlock_page(page);
 	page_cache_release(page);
 out:
@@ -7373,12 +7417,21 @@ static ssize_t btrfs_direct_IO(int rw, struct kiocb *iocb,
 			iov, offset, nr_segs, btrfs_get_blocks_direct, NULL,
 			btrfs_submit_direct, flags);
 	if (rw & WRITE) {
-		if (ret < 0 && ret != -EIOCBQUEUED)
-			btrfs_delalloc_release_space(inode, count);
-		else if (ret >= 0 && (size_t)ret < count)
-			btrfs_delalloc_release_space(inode,
+		if (ret < 0 && ret != -EIOCBQUEUED) {
+			if (BTRFS_I(inode)->flags & BTRFS_INODE_HOT) {
+				BTRFS_I(inode)->flags &= ~BTRFS_INODE_HOT;
+				btrfs_delalloc_release_ssd_space(inode, count);
+			} else
+				btrfs_delalloc_release_space(inode, count);
+		} else if (ret >= 0 && (size_t)ret < count) {
+			if (BTRFS_I(inode)->flags & BTRFS_INODE_HOT) {
+				BTRFS_I(inode)->flags &= ~BTRFS_INODE_HOT;
+				btrfs_delalloc_release_ssd_space(inode,
 						     count - (size_t)ret);
-		else
+			} else
+				btrfs_delalloc_release_space(inode,
+						     count - (size_t)ret);
+		} else
 			btrfs_delalloc_release_metadata(inode, 0);
 	}
 out:
@@ -7618,6 +7671,9 @@ again:
 			  EXTENT_DO_ACCOUNTING | EXTENT_DEFRAG,
 			  0, 0, &cached_state, GFP_NOFS);
 
+	if (btrfs_test_opt(root, HOT_MOVE))
+		hot_set_extent(inode, page_start, page_end, &cached_state, 0);
+
 	ret = btrfs_set_extent_delalloc(inode, page_start, page_end,
 					&cached_state);
 	if (ret) {
@@ -7657,7 +7713,11 @@ out_unlock:
 	}
 	unlock_page(page);
 out:
-	btrfs_delalloc_release_space(inode, PAGE_CACHE_SIZE);
+	if (BTRFS_I(inode)->flags & BTRFS_INODE_HOT) {
+		BTRFS_I(inode)->flags &= ~BTRFS_INODE_HOT;
+		btrfs_delalloc_release_ssd_space(inode, PAGE_CACHE_SIZE);
+	} else
+		btrfs_delalloc_release_space(inode, PAGE_CACHE_SIZE);
 out_noreserve:
 	sb_end_pagefault(inode->i_sb);
 	return ret;
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 2c02310..b9925fd 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -56,6 +56,7 @@
 #include "rcu-string.h"
 #include "send.h"
 #include "dev-replace.h"
+#include "hot_relocate.h"
 
 /* Mask out flags that are inappropriate for the given type of inode. */
 static inline __u32 btrfs_mask_flags(umode_t mode, __u32 flags)
@@ -1098,10 +1099,17 @@ again:
 		spin_lock(&BTRFS_I(inode)->lock);
 		BTRFS_I(inode)->outstanding_extents++;
 		spin_unlock(&BTRFS_I(inode)->lock);
-		btrfs_delalloc_release_space(inode,
+		if (BTRFS_I(inode)->flags & BTRFS_INODE_HOT) {
+			btrfs_delalloc_release_ssd_space(inode,
+				     (page_cnt - i_done) << PAGE_CACHE_SHIFT);
+		} else
+			btrfs_delalloc_release_space(inode,
 				     (page_cnt - i_done) << PAGE_CACHE_SHIFT);
 	}
 
+	if (btrfs_test_opt(BTRFS_I(inode)->root, HOT_MOVE))
+		hot_set_extent(inode, page_start,
+				page_end - 1, &cached_state, 1);
 
 	set_extent_defrag(&BTRFS_I(inode)->io_tree, page_start, page_end - 1,
 			  &cached_state, GFP_NOFS);
@@ -1124,7 +1132,13 @@ out:
 		unlock_page(pages[i]);
 		page_cache_release(pages[i]);
 	}
-	btrfs_delalloc_release_space(inode, page_cnt << PAGE_CACHE_SHIFT);
+	if (BTRFS_I(inode)->flags & BTRFS_INODE_HOT) {
+		BTRFS_I(inode)->flags &= ~BTRFS_INODE_HOT;
+		btrfs_delalloc_release_ssd_space(inode,
+				page_cnt << PAGE_CACHE_SHIFT);
+	} else
+		btrfs_delalloc_release_space(inode,
+				page_cnt << PAGE_CACHE_SHIFT);
 	return ret;
 
 }
@@ -3014,8 +3028,9 @@ long btrfs_ioctl_space_info(struct btrfs_root *root, void __user *arg)
 	u64 types[] = {BTRFS_BLOCK_GROUP_DATA,
 		       BTRFS_BLOCK_GROUP_SYSTEM,
 		       BTRFS_BLOCK_GROUP_METADATA,
-		       BTRFS_BLOCK_GROUP_DATA | BTRFS_BLOCK_GROUP_METADATA};
-	int num_types = 4;
+		       BTRFS_BLOCK_GROUP_DATA | BTRFS_BLOCK_GROUP_METADATA,
+		       BTRFS_BLOCK_GROUP_DATA_SSD};
+	int num_types = 5;
 	int alloc_size;
 	int ret = 0;
 	u64 slot_count = 0;
diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index b67171e..5d44488 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -31,6 +31,7 @@
 #include "async-thread.h"
 #include "free-space-cache.h"
 #include "inode-map.h"
+#include "hot_relocate.h"
 
 /*
  * backref_node, mapping_node and tree_block start with this
@@ -2935,8 +2936,14 @@ int prealloc_file_extent_cluster(struct inode *inode,
 			break;
 		nr++;
 	}
-	btrfs_free_reserved_data_space(inode, cluster->end +
-				       1 - cluster->start);
+
+	if (BTRFS_I(inode)->flags & BTRFS_INODE_HOT) {
+		BTRFS_I(inode)->flags &= ~BTRFS_INODE_HOT;
+		btrfs_free_reserved_ssd_data_space(inode,
+				cluster->end + 1 - cluster->start);
+	} else
+		btrfs_free_reserved_data_space(inode,
+				cluster->end + 1 - cluster->start);
 out:
 	mutex_unlock(&inode->i_mutex);
 	return ret;
@@ -3065,6 +3072,9 @@ static int relocate_file_extent_cluster(struct inode *inode,
 			nr++;
 		}
 
+		if (btrfs_test_opt(BTRFS_I(inode)->root, HOT_MOVE))
+			hot_set_extent(inode, page_start, page_end, NULL, 1);
+
 		btrfs_set_extent_delalloc(inode, page_start, page_end, NULL);
 		set_page_dirty(page);
 
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index b1bab1c..bdd8850 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -1527,7 +1527,8 @@ static int btrfs_statfs(struct dentry *dentry, struct kstatfs *buf)
 	mutex_lock(&fs_info->chunk_mutex);
 	rcu_read_lock();
 	list_for_each_entry_rcu(found, head, list) {
-		if (found->flags & BTRFS_BLOCK_GROUP_DATA) {
+		if ((found->flags & BTRFS_BLOCK_GROUP_DATA) ||
+			(found->flags & BTRFS_BLOCK_GROUP_DATA_SSD)) {
 			total_free_data += found->disk_total - found->disk_used;
 			total_free_data -=
 				btrfs_account_ro_block_groups_free_space(found);
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 2854c82..d516557 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -1450,6 +1450,8 @@ int btrfs_rm_device(struct btrfs_root *root, char *device_path)
 		all_avail = root->fs_info->avail_data_alloc_bits |
 			    root->fs_info->avail_system_alloc_bits |
 			    root->fs_info->avail_metadata_alloc_bits;
+		if (btrfs_test_opt(root, HOT_MOVE))
+			all_avail |= root->fs_info->avail_data_ssd_alloc_bits;
 	} while (read_seqretry(&root->fs_info->profiles_lock, seq));
 
 	num_devices = root->fs_info->fs_devices->num_devices;
@@ -3736,7 +3738,8 @@ static int __btrfs_alloc_chunk(struct btrfs_trans_handle *trans,
 	devs_increment = btrfs_raid_array[index].devs_increment;
 	ncopies = btrfs_raid_array[index].ncopies;
 
-	if (type & BTRFS_BLOCK_GROUP_DATA) {
+	if (type & BTRFS_BLOCK_GROUP_DATA ||
+		type & BTRFS_BLOCK_GROUP_DATA_SSD) {
 		max_stripe_size = 1024 * 1024 * 1024;
 		max_chunk_size = 10 * max_stripe_size;
 	} else if (type & BTRFS_BLOCK_GROUP_METADATA) {
@@ -3775,9 +3778,30 @@ static int __btrfs_alloc_chunk(struct btrfs_trans_handle *trans,
 		struct btrfs_device *device;
 		u64 max_avail;
 		u64 dev_offset;
+		int dev_rot;
+		int skip = 0;
 
 		device = list_entry(cur, struct btrfs_device, dev_alloc_list);
 
+		/*
+		 * If HOT_MOVE is set, the chunk type being allocated
+		 * determines which disks the data may be allocated on.
+		 * This can cause problems if, for example, the data alloc
+		 * profile is RAID0 and there are only two devices, 1 SSD +
+		 * 1 HDD. All allocations to BTRFS_BLOCK_GROUP_DATA_SSD
+		 * in this config will return -ENOSPC as the allocation code
+		 * can't find allowable space for the second stripe.
+		 */
+		dev_rot = !blk_queue_nonrot(bdev_get_queue(device->bdev));
+		if (btrfs_test_opt(extent_root, HOT_MOVE)) {
+			int ret1 = type & (BTRFS_BLOCK_GROUP_DATA |
+				BTRFS_BLOCK_GROUP_METADATA |
+				BTRFS_BLOCK_GROUP_SYSTEM) && !dev_rot;
+			int ret2 = type & BTRFS_BLOCK_GROUP_DATA_SSD && dev_rot;
+			if (ret1 || ret2)
+				skip = 1;
+		}
+
 		cur = cur->next;
 
 		if (!device->writeable) {
@@ -3786,7 +3810,7 @@ static int __btrfs_alloc_chunk(struct btrfs_trans_handle *trans,
 			continue;
 		}
 
-		if (!device->in_fs_metadata ||
+		if (skip || !device->in_fs_metadata ||
 		    device->is_tgtdev_for_dev_replace)
 			continue;
 
-- 
1.7.11.7

