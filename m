Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from e39.co.us.ibm.com ([32.97.110.160]:44714 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757215Ab3ETPKt (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 20 May 2013 11:10:49 -0400
Received: from /spool/local
	by e39.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <zwu.kernel@gmail.com>;
	Mon, 20 May 2013 09:10:49 -0600
From: zwu.kernel@gmail.com
To: linux-btrfs@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
Subject: [RFC PATCH v1 2/5] BTRFS hot reloc: add one new block group
Date: Mon, 20 May 2013 23:11:24 +0800
Message-Id: <1369062687-23544-3-git-send-email-zwu.kernel@gmail.com>
In-Reply-To: <1369062687-23544-1-git-send-email-zwu.kernel@gmail.com>
References: <1369062687-23544-1-git-send-email-zwu.kernel@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>

  Introduce one new block group BTRFS_BLOCK_GROUP_DATA_NONROT,
which is used to differentiate if the block space is reserved
and allocated from one rotating disk or nonrotating disk.

Signed-off-by: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
---
 fs/btrfs/ctree.h            | 33 ++++++++++++---
 fs/btrfs/extent-tree.c      | 99 ++++++++++++++++++++++++++++++++++++---------
 fs/btrfs/extent_io.c        | 59 ++++++++++++++++++++++++++-
 fs/btrfs/extent_io.h        |  7 ++++
 fs/btrfs/file.c             | 24 +++++++----
 fs/btrfs/free-space-cache.c |  2 +-
 fs/btrfs/inode-map.c        |  7 ++--
 fs/btrfs/inode.c            | 94 ++++++++++++++++++++++++++++++++++--------
 fs/btrfs/ioctl.c            | 17 +++++---
 fs/btrfs/relocation.c       |  6 ++-
 fs/btrfs/super.c            |  4 +-
 fs/btrfs/volumes.c          | 29 ++++++++++++-
 12 files changed, 316 insertions(+), 65 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 133a6ed..f7a3170 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -963,6 +963,12 @@ struct btrfs_dev_replace_item {
 #define BTRFS_BLOCK_GROUP_RAID10	(1ULL << 6)
 #define BTRFS_BLOCK_GROUP_RAID5    (1 << 7)
 #define BTRFS_BLOCK_GROUP_RAID6    (1 << 8)
+/*
+ * New block groups for use with BTRFS hot relocation feature.
+ * When BTRFS hot relocation is enabled, *_NONROT block group is
+ * forced to nonrotating drives.
+ */
+#define BTRFS_BLOCK_GROUP_DATA_NONROT	(1ULL << 9)
 #define BTRFS_BLOCK_GROUP_RESERVED	BTRFS_AVAIL_ALLOC_BIT_SINGLE
 
 enum btrfs_raid_types {
@@ -978,7 +984,8 @@ enum btrfs_raid_types {
 
 #define BTRFS_BLOCK_GROUP_TYPE_MASK	(BTRFS_BLOCK_GROUP_DATA |    \
 					 BTRFS_BLOCK_GROUP_SYSTEM |  \
-					 BTRFS_BLOCK_GROUP_METADATA)
+					 BTRFS_BLOCK_GROUP_METADATA | \
+					 BTRFS_BLOCK_GROUP_DATA_NONROT)
 
 #define BTRFS_BLOCK_GROUP_PROFILE_MASK	(BTRFS_BLOCK_GROUP_RAID0 |   \
 					 BTRFS_BLOCK_GROUP_RAID1 |   \
@@ -1521,6 +1528,7 @@ struct btrfs_fs_info {
 	struct list_head space_info;
 
 	struct btrfs_space_info *data_sinfo;
+	struct btrfs_space_info *nonrot_data_sinfo;
 
 	struct reloc_control *reloc_ctl;
 
@@ -1545,6 +1553,7 @@ struct btrfs_fs_info {
 	u64 avail_data_alloc_bits;
 	u64 avail_metadata_alloc_bits;
 	u64 avail_system_alloc_bits;
+	u64 avail_data_nonrot_alloc_bits;
 
 	/* restriper state */
 	spinlock_t balance_lock;
@@ -1557,6 +1566,7 @@ struct btrfs_fs_info {
 
 	unsigned data_chunk_allocations;
 	unsigned metadata_ratio;
+	unsigned data_nonrot_chunk_allocations;
 
 	void *bdev_holder;
 
@@ -1928,6 +1938,7 @@ struct btrfs_ioctl_defrag_range_args {
 #define BTRFS_MOUNT_CHECK_INTEGRITY_INCLUDING_EXTENT_DATA (1 << 21)
 #define BTRFS_MOUNT_PANIC_ON_FATAL_ERROR	(1 << 22)
 #define BTRFS_MOUNT_HOT_TRACK		(1 << 23)
+#define BTRFS_MOUNT_HOT_MOVE		(1 << 24)
 
 #define btrfs_clear_opt(o, opt)		((o) &= ~BTRFS_MOUNT_##opt)
 #define btrfs_set_opt(o, opt)		((o) |= BTRFS_MOUNT_##opt)
@@ -3043,6 +3054,8 @@ int btrfs_pin_extent_for_log_replay(struct btrfs_root *root,
 int btrfs_cross_ref_exist(struct btrfs_trans_handle *trans,
 			  struct btrfs_root *root,
 			  u64 objectid, u64 offset, u64 bytenr);
+struct btrfs_block_group_cache *btrfs_lookup_first_block_group(
+				struct btrfs_fs_info *info, u64 bytenr);
 struct btrfs_block_group_cache *btrfs_lookup_block_group(
 						 struct btrfs_fs_info *info,
 						 u64 bytenr);
@@ -3093,6 +3106,8 @@ int btrfs_inc_extent_ref(struct btrfs_trans_handle *trans,
 			 struct btrfs_root *root,
 			 u64 bytenr, u64 num_bytes, u64 parent,
 			 u64 root_objectid, u64 owner, u64 offset, int for_cow);
+struct btrfs_block_group_cache *next_block_group(struct btrfs_root *root,
+			 struct btrfs_block_group_cache *cache);
 
 int btrfs_write_dirty_block_groups(struct btrfs_trans_handle *trans,
 				    struct btrfs_root *root);
@@ -3122,8 +3137,14 @@ enum btrfs_reserve_flush_enum {
 	BTRFS_RESERVE_FLUSH_ALL,
 };
 
-int btrfs_check_data_free_space(struct inode *inode, u64 bytes);
-void btrfs_free_reserved_data_space(struct inode *inode, u64 bytes);
+enum {
+	TYPE_ROT,       /* rot -> rotating */
+	TYPE_NONROT,    /* nonrot -> nonrotating */
+	MAX_RELOC_TYPES,
+};
+
+int btrfs_check_data_free_space(struct inode *inode, u64 bytes, int *flag);
+void btrfs_free_reserved_data_space(struct inode *inode, u64 bytes, int flag);
 void btrfs_trans_release_metadata(struct btrfs_trans_handle *trans,
 				struct btrfs_root *root);
 int btrfs_orphan_reserve_metadata(struct btrfs_trans_handle *trans,
@@ -3138,8 +3159,8 @@ void btrfs_subvolume_release_metadata(struct btrfs_root *root,
 				      u64 qgroup_reserved);
 int btrfs_delalloc_reserve_metadata(struct inode *inode, u64 num_bytes);
 void btrfs_delalloc_release_metadata(struct inode *inode, u64 num_bytes);
-int btrfs_delalloc_reserve_space(struct inode *inode, u64 num_bytes);
-void btrfs_delalloc_release_space(struct inode *inode, u64 num_bytes);
+int btrfs_delalloc_reserve_space(struct inode *inode, u64 num_bytes, int *flag);
+void btrfs_delalloc_release_space(struct inode *inode, u64 num_bytes, int flag);
 void btrfs_init_block_rsv(struct btrfs_block_rsv *rsv, unsigned short type);
 struct btrfs_block_rsv *btrfs_alloc_block_rsv(struct btrfs_root *root,
 					      unsigned short type);
@@ -3612,7 +3633,7 @@ int btrfs_release_file(struct inode *inode, struct file *file);
 int btrfs_dirty_pages(struct btrfs_root *root, struct inode *inode,
 		      struct page **pages, size_t num_pages,
 		      loff_t pos, size_t write_bytes,
-		      struct extent_state **cached);
+		      struct extent_state **cached, int flag);
 
 /* tree-defrag.c */
 int btrfs_defrag_leaves(struct btrfs_trans_handle *trans,
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 2305b5c..afc9f77 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -628,7 +628,7 @@ static int cache_block_group(struct btrfs_block_group_cache *cache,
 /*
  * return the block group that starts at or after bytenr
  */
-static struct btrfs_block_group_cache *
+struct btrfs_block_group_cache *
 btrfs_lookup_first_block_group(struct btrfs_fs_info *info, u64 bytenr)
 {
 	struct btrfs_block_group_cache *cache;
@@ -3030,7 +3030,7 @@ fail:
 
 }
 
-static struct btrfs_block_group_cache *
+struct btrfs_block_group_cache *
 next_block_group(struct btrfs_root *root,
 		 struct btrfs_block_group_cache *cache)
 {
@@ -3059,6 +3059,7 @@ static int cache_save_setup(struct btrfs_block_group_cache *block_group,
 	int num_pages = 0;
 	int retries = 0;
 	int ret = 0;
+	int flag = TYPE_ROT;
 
 	/*
 	 * If this block group is smaller than 100 megs don't bother caching the
@@ -3142,7 +3143,7 @@ again:
 	num_pages *= 16;
 	num_pages *= PAGE_CACHE_SIZE;
 
-	ret = btrfs_check_data_free_space(inode, num_pages);
+	ret = btrfs_check_data_free_space(inode, num_pages, &flag);
 	if (ret)
 		goto out_put;
 
@@ -3151,7 +3152,8 @@ again:
 					      &alloc_hint);
 	if (!ret)
 		dcs = BTRFS_DC_SETUP;
-	btrfs_free_reserved_data_space(inode, num_pages);
+
+	btrfs_free_reserved_data_space(inode, num_pages, flag);
 
 out_put:
 	iput(inode);
@@ -3353,6 +3355,8 @@ static int update_space_info(struct btrfs_fs_info *info, u64 flags,
 	list_add_rcu(&found->list, &info->space_info);
 	if (flags & BTRFS_BLOCK_GROUP_DATA)
 		info->data_sinfo = found;
+	else if (flags & BTRFS_BLOCK_GROUP_DATA_NONROT)
+		info->nonrot_data_sinfo = found;
 	return 0;
 }
 
@@ -3368,6 +3372,8 @@ static void set_avail_alloc_bits(struct btrfs_fs_info *fs_info, u64 flags)
 		fs_info->avail_metadata_alloc_bits |= extra_flags;
 	if (flags & BTRFS_BLOCK_GROUP_SYSTEM)
 		fs_info->avail_system_alloc_bits |= extra_flags;
+	if (flags & BTRFS_BLOCK_GROUP_DATA_NONROT)
+		fs_info->avail_data_nonrot_alloc_bits |= extra_flags;
 	write_sequnlock(&fs_info->profiles_lock);
 }
 
@@ -3474,18 +3480,27 @@ static u64 get_alloc_profile(struct btrfs_root *root, u64 flags)
 			flags |= root->fs_info->avail_system_alloc_bits;
 		else if (flags & BTRFS_BLOCK_GROUP_METADATA)
 			flags |= root->fs_info->avail_metadata_alloc_bits;
+		else if (flags & BTRFS_BLOCK_GROUP_DATA_NONROT)
+			flags |= root->fs_info->avail_data_nonrot_alloc_bits;
 	} while (read_seqretry(&root->fs_info->profiles_lock, seq));
 
 	return btrfs_reduce_alloc_profile(root, flags);
 }
 
+/*
+ * Turns a chunk_type integer into set of block group flags (a profile).
+ * Hot relocation code adds chunk_type 2 for hot data specific block
+ * group type.
+ */
 u64 btrfs_get_alloc_profile(struct btrfs_root *root, int data)
 {
 	u64 flags;
 	u64 ret;
 
-	if (data)
+	if (data == 1)
 		flags = BTRFS_BLOCK_GROUP_DATA;
+	else if (data == 2)
+		flags = BTRFS_BLOCK_GROUP_DATA_NONROT;
 	else if (root == root->fs_info->chunk_root)
 		flags = BTRFS_BLOCK_GROUP_SYSTEM;
 	else
@@ -3499,13 +3514,14 @@ u64 btrfs_get_alloc_profile(struct btrfs_root *root, int data)
  * This will check the space that the inode allocates from to make sure we have
  * enough space for bytes.
  */
-int btrfs_check_data_free_space(struct inode *inode, u64 bytes)
+int btrfs_check_data_free_space(struct inode *inode, u64 bytes, int *flag)
 {
 	struct btrfs_space_info *data_sinfo;
 	struct btrfs_root *root = BTRFS_I(inode)->root;
 	struct btrfs_fs_info *fs_info = root->fs_info;
 	u64 used;
 	int ret = 0, committed = 0, alloc_chunk = 1;
+	int data, tried = 0;
 
 	/* make sure bytes are sectorsize aligned */
 	bytes = ALIGN(bytes, root->sectorsize);
@@ -3516,7 +3532,15 @@ int btrfs_check_data_free_space(struct inode *inode, u64 bytes)
 		committed = 1;
 	}
 
-	data_sinfo = fs_info->data_sinfo;
+	if (*flag == TYPE_NONROT) {
+try_nonrot:
+		data = 2;
+		data_sinfo = fs_info->nonrot_data_sinfo;
+	} else {
+		data = 1;
+		data_sinfo = fs_info->data_sinfo;
+	}
+
 	if (!data_sinfo)
 		goto alloc;
 
@@ -3534,13 +3558,22 @@ again:
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
+					goto try_nonrot;
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
@@ -3557,11 +3590,13 @@ alloc:
 			}
 
 			if (!data_sinfo)
-				data_sinfo = fs_info->data_sinfo;
+				data_sinfo = (data == 1) ? fs_info->data_sinfo :
+						fs_info->nonrot_data_sinfo;
 
 			goto again;
 		}
 
+non_alloc:
 		/*
 		 * If we have less pinned bytes than we want to allocate then
 		 * don't bother committing the transaction, it won't help us.
@@ -3572,7 +3607,7 @@ alloc:
 
 		/* commit the current transaction and try again */
 commit_trans:
-		if (!committed &&
+		if (!committed && data_sinfo &&
 		    !atomic_read(&root->fs_info->open_ioctl_trans)) {
 			committed = 1;
 			trans = btrfs_join_transaction(root);
@@ -3586,6 +3621,10 @@ commit_trans:
 
 		return -ENOSPC;
 	}
+
+	if (tried)
+		*flag = TYPE_NONROT;
+
 	data_sinfo->bytes_may_use += bytes;
 	trace_btrfs_space_reservation(root->fs_info, "space_info",
 				      data_sinfo->flags, bytes, 1);
@@ -3597,7 +3636,7 @@ commit_trans:
 /*
  * Called if we need to clear a data reservation for this inode.
  */
-void btrfs_free_reserved_data_space(struct inode *inode, u64 bytes)
+void btrfs_free_reserved_data_space(struct inode *inode, u64 bytes, int flag)
 {
 	struct btrfs_root *root = BTRFS_I(inode)->root;
 	struct btrfs_space_info *data_sinfo;
@@ -3605,7 +3644,10 @@ void btrfs_free_reserved_data_space(struct inode *inode, u64 bytes)
 	/* make sure bytes are sectorsize aligned */
 	bytes = ALIGN(bytes, root->sectorsize);
 
-	data_sinfo = root->fs_info->data_sinfo;
+	if (flag == TYPE_NONROT)
+		data_sinfo = root->fs_info->nonrot_data_sinfo;
+	else
+		data_sinfo = root->fs_info->data_sinfo;
 	spin_lock(&data_sinfo->lock);
 	data_sinfo->bytes_may_use -= bytes;
 	trace_btrfs_space_reservation(root->fs_info, "space_info",
@@ -3789,6 +3831,13 @@ again:
 			force_metadata_allocation(fs_info);
 	}
 
+	if (flags & BTRFS_BLOCK_GROUP_DATA_NONROT && fs_info->metadata_ratio) {
+		fs_info->data_nonrot_chunk_allocations++;
+		if (!(fs_info->data_nonrot_chunk_allocations %
+			fs_info->metadata_ratio))
+				force_metadata_allocation(fs_info);
+	}
+
 	/*
 	 * Check if we have enough space in SYSTEM chunk because we may need
 	 * to update devices.
@@ -4495,6 +4544,13 @@ static u64 calc_global_metadata_size(struct btrfs_fs_info *fs_info)
 	meta_used = sinfo->bytes_used;
 	spin_unlock(&sinfo->lock);
 
+	sinfo = __find_space_info(fs_info, BTRFS_BLOCK_GROUP_DATA_NONROT);
+	if (sinfo) {
+		spin_lock(&sinfo->lock);
+		data_used += sinfo->bytes_used;
+		spin_unlock(&sinfo->lock);
+	}
+
 	num_bytes = (data_used >> fs_info->sb->s_blocksize_bits) *
 		    csum_size * 2;
 	num_bytes += div64_u64(data_used + meta_used, 50);
@@ -4968,6 +5024,7 @@ void btrfs_delalloc_release_metadata(struct inode *inode, u64 num_bytes)
  * btrfs_delalloc_reserve_space - reserve data and metadata space for delalloc
  * @inode: inode we're writing to
  * @num_bytes: the number of bytes we want to allocate
+ * @flag: indicate if block space is reserved from rotating disk or not
  *
  * This will do the following things
  *
@@ -4979,17 +5036,17 @@ void btrfs_delalloc_release_metadata(struct inode *inode, u64 num_bytes)
  *
  * This will return 0 for success and -ENOSPC if there is no space left.
  */
-int btrfs_delalloc_reserve_space(struct inode *inode, u64 num_bytes)
+int btrfs_delalloc_reserve_space(struct inode *inode, u64 num_bytes, int *flag)
 {
 	int ret;
 
-	ret = btrfs_check_data_free_space(inode, num_bytes);
+	ret = btrfs_check_data_free_space(inode, num_bytes, flag);
 	if (ret)
 		return ret;
 
 	ret = btrfs_delalloc_reserve_metadata(inode, num_bytes);
 	if (ret) {
-		btrfs_free_reserved_data_space(inode, num_bytes);
+		btrfs_free_reserved_data_space(inode, num_bytes, *flag);
 		return ret;
 	}
 
@@ -5000,6 +5057,7 @@ int btrfs_delalloc_reserve_space(struct inode *inode, u64 num_bytes)
  * btrfs_delalloc_release_space - release data and metadata space for delalloc
  * @inode: inode we're releasing space for
  * @num_bytes: the number of bytes we want to free up
+ * @flag: indicate if block space is freed from rotating disk or not
  *
  * This must be matched with a call to btrfs_delalloc_reserve_space.  This is
  * called in the case that we don't need the metadata AND data reservations
@@ -5009,10 +5067,10 @@ int btrfs_delalloc_reserve_space(struct inode *inode, u64 num_bytes)
  * decrement ->delalloc_bytes and remove it from the fs_info delalloc_inodes
  * list if there are no delalloc bytes left.
  */
-void btrfs_delalloc_release_space(struct inode *inode, u64 num_bytes)
+void btrfs_delalloc_release_space(struct inode *inode, u64 num_bytes, int flag)
 {
 	btrfs_delalloc_release_metadata(inode, num_bytes);
-	btrfs_free_reserved_data_space(inode, num_bytes);
+	btrfs_free_reserved_data_space(inode, num_bytes, flag);
 }
 
 static int update_block_group(struct btrfs_root *root,
@@ -5888,7 +5946,8 @@ static noinline int find_free_extent(struct btrfs_trans_handle *trans,
 	struct btrfs_space_info *space_info;
 	int loop = 0;
 	int index = __get_raid_index(flags);
-	int alloc_type = (flags & BTRFS_BLOCK_GROUP_DATA) ?
+	int alloc_type = ((flags & BTRFS_BLOCK_GROUP_DATA)
+		|| (flags & BTRFS_BLOCK_GROUP_DATA_NONROT)) ?
 		RESERVE_ALLOC_NO_ACCOUNT : RESERVE_ALLOC;
 	bool found_uncached_bg = false;
 	bool failed_cluster_refill = false;
@@ -8360,6 +8419,8 @@ static void clear_avail_alloc_bits(struct btrfs_fs_info *fs_info, u64 flags)
 		fs_info->avail_metadata_alloc_bits &= ~extra_flags;
 	if (flags & BTRFS_BLOCK_GROUP_SYSTEM)
 		fs_info->avail_system_alloc_bits &= ~extra_flags;
+	if (flags & BTRFS_BLOCK_GROUP_DATA_NONROT)
+		fs_info->avail_data_nonrot_alloc_bits &= ~extra_flags;
 	write_sequnlock(&fs_info->profiles_lock);
 }
 
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 32d67a8..2b1f132 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -1216,6 +1216,34 @@ int clear_extent_uptodate(struct extent_io_tree *tree, u64 start, u64 end,
 				cached_state, mask);
 }
 
+void set_extent_hot(struct inode *inode, u64 start, u64 end,
+			struct extent_state **cached_state,
+			int type, int flag)
+{
+	int set_bits = 0, clear_bits = 0;
+
+	if (flag) {
+		set_bits = EXTENT_DELALLOC | EXTENT_UPTODATE;
+		clear_bits = EXTENT_DIRTY | EXTENT_DELALLOC |
+				EXTENT_DO_ACCOUNTING;
+	}
+
+	if (type == TYPE_NONROT) {
+		set_bits |= EXTENT_HOT;
+		clear_bits |= EXTENT_COLD;
+	} else {
+		set_bits |= EXTENT_COLD;
+		clear_bits |= EXTENT_HOT;
+	}
+
+	clear_extent_bit(&BTRFS_I(inode)->io_tree,
+			start, end, clear_bits,
+			0, 0, cached_state, GFP_NOFS);
+	set_extent_bit(&BTRFS_I(inode)->io_tree, start,
+			end, set_bits, NULL,
+			cached_state, GFP_NOFS);
+}
+
 /*
  * either insert or lock state struct between start and end use mask to tell
  * us if waiting is desired.
@@ -1417,9 +1445,11 @@ static noinline u64 find_delalloc_range(struct extent_io_tree *tree,
 {
 	struct rb_node *node;
 	struct extent_state *state;
+	struct btrfs_root *root;
 	u64 cur_start = *start;
 	u64 found = 0;
 	u64 total_bytes = 0;
+	int flag = EXTENT_DELALLOC;
 
 	spin_lock(&tree->lock);
 
@@ -1434,13 +1464,27 @@ static noinline u64 find_delalloc_range(struct extent_io_tree *tree,
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
@@ -1627,7 +1671,13 @@ again:
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
@@ -1665,6 +1715,11 @@ int extent_clear_unlock_delalloc(struct inode *inode,
 	if (op & EXTENT_CLEAR_DELALLOC)
 		clear_bits |= EXTENT_DELALLOC;
 
+	if (op & EXTENT_CLEAR_HOT)
+		clear_bits |= EXTENT_HOT;
+	if (op & EXTENT_CLEAR_COLD)
+		clear_bits |= EXTENT_COLD;
+
 	clear_extent_bit(tree, start, end, clear_bits, 1, 0, NULL, GFP_NOFS);
 	if (!(op & (EXTENT_CLEAR_UNLOCK_PAGE | EXTENT_CLEAR_DIRTY |
 		    EXTENT_SET_WRITEBACK | EXTENT_END_WRITEBACK |
diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
index a2c03a1..a3bfc9d 100644
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
@@ -237,6 +241,9 @@ int set_extent_delalloc(struct extent_io_tree *tree, u64 start, u64 end,
 			struct extent_state **cached_state, gfp_t mask);
 int set_extent_defrag(struct extent_io_tree *tree, u64 start, u64 end,
 		      struct extent_state **cached_state, gfp_t mask);
+void set_extent_hot(struct inode *inode, u64 start, u64 end,
+			struct extent_state **cached_state,
+			int type, int flag);
 int find_first_extent_bit(struct extent_io_tree *tree, u64 start,
 			  u64 *start_ret, u64 *end_ret, unsigned long bits,
 			  struct extent_state **cached_state);
diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 4205ba7..4cbf236 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -41,6 +41,7 @@
 #include "locking.h"
 #include "compat.h"
 #include "volumes.h"
+#include "hot_relocate.h"
 
 static struct kmem_cache *btrfs_inode_defrag_cachep;
 /*
@@ -500,7 +501,7 @@ static void btrfs_drop_pages(struct page **pages, size_t num_pages)
 int btrfs_dirty_pages(struct btrfs_root *root, struct inode *inode,
 			     struct page **pages, size_t num_pages,
 			     loff_t pos, size_t write_bytes,
-			     struct extent_state **cached)
+			     struct extent_state **cached, int flag)
 {
 	int err = 0;
 	int i;
@@ -514,6 +515,11 @@ int btrfs_dirty_pages(struct btrfs_root *root, struct inode *inode,
 	num_bytes = ALIGN(write_bytes + pos - start_pos, root->sectorsize);
 
 	end_of_last_block = start_pos + num_bytes - 1;
+
+	if (btrfs_test_opt(root, HOT_MOVE))
+		set_extent_hot(inode, start_pos, end_of_last_block,
+				cached, flag, 0);
+
 	err = btrfs_set_extent_delalloc(inode, start_pos, end_of_last_block,
 					cached);
 	if (err)
@@ -1350,6 +1356,7 @@ static noinline ssize_t __btrfs_buffered_write(struct file *file,
 				    PAGE_CACHE_SIZE - 1) >> PAGE_CACHE_SHIFT;
 		size_t dirty_pages;
 		size_t copied;
+		int flag = TYPE_ROT;
 
 		WARN_ON(num_pages > nrptrs);
 
@@ -1363,7 +1370,7 @@ static noinline ssize_t __btrfs_buffered_write(struct file *file,
 		}
 
 		ret = btrfs_delalloc_reserve_space(inode,
-					num_pages << PAGE_CACHE_SHIFT);
+					num_pages << PAGE_CACHE_SHIFT, &flag);
 		if (ret)
 			break;
 
@@ -1377,7 +1384,7 @@ static noinline ssize_t __btrfs_buffered_write(struct file *file,
 				    force_page_uptodate);
 		if (ret) {
 			btrfs_delalloc_release_space(inode,
-					num_pages << PAGE_CACHE_SHIFT);
+					num_pages << PAGE_CACHE_SHIFT, flag);
 			break;
 		}
 
@@ -1416,16 +1423,16 @@ static noinline ssize_t __btrfs_buffered_write(struct file *file,
 			}
 			btrfs_delalloc_release_space(inode,
 					(num_pages - dirty_pages) <<
-					PAGE_CACHE_SHIFT);
+					PAGE_CACHE_SHIFT, flag);
 		}
 
 		if (copied > 0) {
 			ret = btrfs_dirty_pages(root, inode, pages,
 						dirty_pages, pos, copied,
-						NULL);
+						NULL, flag);
 			if (ret) {
 				btrfs_delalloc_release_space(inode,
-					dirty_pages << PAGE_CACHE_SHIFT);
+					dirty_pages << PAGE_CACHE_SHIFT, flag);
 				btrfs_drop_pages(pages, num_pages);
 				break;
 			}
@@ -2150,6 +2157,7 @@ static long btrfs_fallocate(struct file *file, int mode,
 	u64 locked_end;
 	struct extent_map *em;
 	int blocksize = BTRFS_I(inode)->root->sectorsize;
+	int flag = TYPE_ROT;
 	int ret;
 
 	alloc_start = round_down(offset, blocksize);
@@ -2166,7 +2174,7 @@ static long btrfs_fallocate(struct file *file, int mode,
 	 * Make sure we have enough space before we do the
 	 * allocation.
 	 */
-	ret = btrfs_check_data_free_space(inode, alloc_end - alloc_start);
+	ret = btrfs_check_data_free_space(inode, alloc_end - alloc_start, &flag);
 	if (ret)
 		return ret;
 	if (root->fs_info->quota_enabled) {
@@ -2281,7 +2289,7 @@ out:
 		btrfs_qgroup_free(root, alloc_end - alloc_start);
 out_reserve_fail:
 	/* Let go of our reservation. */
-	btrfs_free_reserved_data_space(inode, alloc_end - alloc_start);
+	btrfs_free_reserved_data_space(inode, alloc_end - alloc_start, flag);
 	return ret;
 }
 
diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index ecca6c7..58a1cc3 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -1007,7 +1007,7 @@ static int __btrfs_write_out_cache(struct btrfs_root *root, struct inode *inode,
 	io_ctl_zero_remaining_pages(&io_ctl);
 
 	ret = btrfs_dirty_pages(root, inode, io_ctl.pages, io_ctl.num_pages,
-				0, i_size_read(inode), &cached_state);
+				0, i_size_read(inode), &cached_state, TYPE_ROT);
 	io_ctl_drop_pages(&io_ctl);
 	unlock_extent_cached(&BTRFS_I(inode)->io_tree, 0,
 			     i_size_read(inode) - 1, &cached_state, GFP_NOFS);
diff --git a/fs/btrfs/inode-map.c b/fs/btrfs/inode-map.c
index d26f67a..ef0c79d 100644
--- a/fs/btrfs/inode-map.c
+++ b/fs/btrfs/inode-map.c
@@ -403,6 +403,7 @@ int btrfs_save_ino_cache(struct btrfs_root *root,
 	u64 alloc_hint = 0;
 	int ret;
 	int prealloc;
+	int flag = TYPE_ROT;
 	bool retry = false;
 
 	/* only fs tree and subvol/snap needs ino cache */
@@ -490,17 +491,17 @@ again:
 	/* Just to make sure we have enough space */
 	prealloc += 8 * PAGE_CACHE_SIZE;
 
-	ret = btrfs_delalloc_reserve_space(inode, prealloc);
+	ret = btrfs_delalloc_reserve_space(inode, prealloc, &flag);
 	if (ret)
 		goto out_put;
 
 	ret = btrfs_prealloc_file_range_trans(inode, trans, 0, 0, prealloc,
 					      prealloc, prealloc, &alloc_hint);
 	if (ret) {
-		btrfs_delalloc_release_space(inode, prealloc);
+		btrfs_delalloc_release_space(inode, prealloc, flag);
 		goto out_put;
 	}
-	btrfs_free_reserved_data_space(inode, prealloc);
+	btrfs_free_reserved_data_space(inode, prealloc, flag);
 
 	ret = btrfs_write_out_ino_cache(root, trans, path);
 out_put:
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 9b31b3b..096f97f 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -57,6 +57,7 @@
 #include "free-space-cache.h"
 #include "inode-map.h"
 #include "backref.h"
+#include "hot_relocate.h"
 
 struct btrfs_iget_args {
 	u64 ino;
@@ -106,6 +107,27 @@ static struct extent_map *create_pinned_em(struct inode *inode, u64 start,
 
 static int btrfs_dirty_inode(struct inode *inode);
 
+static int get_chunk_type(struct inode *inode, u64 start, u64 end)
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
+
 static int btrfs_init_inode_security(struct btrfs_trans_handle *trans,
 				     struct inode *inode,  struct inode *dir,
 				     const struct qstr *qstr)
@@ -859,13 +881,14 @@ static noinline int __cow_file_range(struct btrfs_trans_handle *trans,
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
@@ -873,6 +896,7 @@ static noinline int __cow_file_range(struct btrfs_trans_handle *trans,
 	num_bytes = ALIGN(end - start + 1, blocksize);
 	num_bytes = max(blocksize,  num_bytes);
 	disk_num_bytes = num_bytes;
+	ret = 0;
 
 	/* if this is a small write inside eof, kick off defrag */
 	if (num_bytes < 64 * 1024 &&
@@ -892,7 +916,8 @@ static noinline int __cow_file_range(struct btrfs_trans_handle *trans,
 				     EXTENT_CLEAR_DELALLOC |
 				     EXTENT_CLEAR_DIRTY |
 				     EXTENT_SET_WRITEBACK |
-				     EXTENT_END_WRITEBACK);
+				     EXTENT_END_WRITEBACK |
+				     hot_flag);
 
 			*nr_written = *nr_written +
 			     (end - start + PAGE_CACHE_SIZE) / PAGE_CACHE_SIZE;
@@ -914,9 +939,25 @@ static noinline int __cow_file_range(struct btrfs_trans_handle *trans,
 		unsigned long op;
 
 		cur_alloc_size = disk_num_bytes;
+
+		/*
+		 * Use COW operations to move hot data to SSD and cold data
+		 * back to rotating disk. Sets chunk_type to 1 to indicate
+		 * to write to BTRFS_BLOCK_GROUP_DATA or 2 to indicate
+		 * BTRFS_BLOCK_GROUP_DATA_NONROT.
+		 */
+		if (btrfs_test_opt(root, HOT_MOVE)) {
+			chunk_type = get_chunk_type(inode, start,
+						start + cur_alloc_size - 1);
+			if (chunk_type == 2)
+				hot_flag = EXTENT_CLEAR_HOT;
+			else
+				hot_flag = EXTENT_CLEAR_COLD;
+		}
+
 		ret = btrfs_reserve_extent(trans, root, cur_alloc_size,
 					   root->sectorsize, 0, alloc_hint,
-					   &ins, 1);
+					   &ins, chunk_type);
 		if (ret < 0) {
 			btrfs_abort_transaction(trans, root, ret);
 			goto out_unlock;
@@ -982,7 +1023,7 @@ static noinline int __cow_file_range(struct btrfs_trans_handle *trans,
 		 */
 		op = unlock ? EXTENT_CLEAR_UNLOCK_PAGE : 0;
 		op |= EXTENT_CLEAR_UNLOCK | EXTENT_CLEAR_DELALLOC |
-			EXTENT_SET_PRIVATE2;
+			EXTENT_SET_PRIVATE2 | hot_flag;
 
 		extent_clear_unlock_delalloc(inode, &BTRFS_I(inode)->io_tree,
 					     start, start + ram_size - 1,
@@ -1006,7 +1047,8 @@ out_unlock:
 		     EXTENT_CLEAR_DELALLOC |
 		     EXTENT_CLEAR_DIRTY |
 		     EXTENT_SET_WRITEBACK |
-		     EXTENT_END_WRITEBACK);
+		     EXTENT_END_WRITEBACK |
+		     hot_flag);
 
 	goto out;
 }
@@ -1600,8 +1642,12 @@ static void btrfs_clear_bit_hook(struct inode *inode,
 			btrfs_delalloc_release_metadata(inode, len);
 
 		if (root->root_key.objectid != BTRFS_DATA_RELOC_TREE_OBJECTID
-		    && do_list)
-			btrfs_free_reserved_data_space(inode, len);
+		    && do_list) {
+			int flag = TYPE_ROT;
+			if ((state->state & EXTENT_HOT) && (*bits & EXTENT_HOT))
+				flag = TYPE_NONROT;
+			btrfs_free_reserved_data_space(inode, len, flag);
+		}
 
 		__percpu_counter_add(&root->fs_info->delalloc_bytes, -len,
 				     root->fs_info->delalloc_batch);
@@ -1796,6 +1842,7 @@ static void btrfs_writepage_fixup_worker(struct btrfs_work *work)
 	u64 page_start;
 	u64 page_end;
 	int ret;
+	int flag = TYPE_ROT;
 
 	fixup = container_of(work, struct btrfs_writepage_fixup, work);
 	page = fixup->page;
@@ -1827,7 +1874,7 @@ again:
 		goto again;
 	}
 
-	ret = btrfs_delalloc_reserve_space(inode, PAGE_CACHE_SIZE);
+	ret = btrfs_delalloc_reserve_space(inode, PAGE_CACHE_SIZE, &flag);
 	if (ret) {
 		mapping_set_error(page->mapping, ret);
 		end_extent_writepage(page, ret, page_start, page_end);
@@ -1835,6 +1882,10 @@ again:
 		goto out;
 	 }
 
+	if (btrfs_test_opt(BTRFS_I(inode)->root, HOT_MOVE))
+		set_extent_hot(inode, page_start, page_end,
+				&cached_state, flag, 0);
+
 	btrfs_set_extent_delalloc(inode, page_start, page_end, &cached_state);
 	ClearPageChecked(page);
 	set_page_dirty(page);
@@ -4282,20 +4333,21 @@ int btrfs_truncate_page(struct inode *inode, loff_t from, loff_t len,
 	struct page *page;
 	gfp_t mask = btrfs_alloc_write_mask(mapping);
 	int ret = 0;
+	int flag = TYPE_ROT;
 	u64 page_start;
 	u64 page_end;
 
 	if ((offset & (blocksize - 1)) == 0 &&
 	    (!len || ((len & (blocksize - 1)) == 0)))
 		goto out;
-	ret = btrfs_delalloc_reserve_space(inode, PAGE_CACHE_SIZE);
+	ret = btrfs_delalloc_reserve_space(inode, PAGE_CACHE_SIZE, &flag);
 	if (ret)
 		goto out;
 
 again:
 	page = find_or_create_page(mapping, index, mask);
 	if (!page) {
-		btrfs_delalloc_release_space(inode, PAGE_CACHE_SIZE);
+		btrfs_delalloc_release_space(inode, PAGE_CACHE_SIZE, flag);
 		ret = -ENOMEM;
 		goto out;
 	}
@@ -4337,6 +4389,10 @@ again:
 			  EXTENT_DO_ACCOUNTING | EXTENT_DEFRAG,
 			  0, 0, &cached_state, GFP_NOFS);
 
+	if (btrfs_test_opt(root, HOT_MOVE))
+		set_extent_hot(inode, page_start, page_end,
+				&cached_state, flag, 0);
+
 	ret = btrfs_set_extent_delalloc(inode, page_start, page_end,
 					&cached_state);
 	if (ret) {
@@ -4363,7 +4419,7 @@ again:
 
 out_unlock:
 	if (ret)
-		btrfs_delalloc_release_space(inode, PAGE_CACHE_SIZE);
+		btrfs_delalloc_release_space(inode, PAGE_CACHE_SIZE, flag);
 	unlock_page(page);
 	page_cache_release(page);
 out:
@@ -7353,6 +7409,7 @@ static ssize_t btrfs_direct_IO(int rw, struct kiocb *iocb,
 	struct inode *inode = file->f_mapping->host;
 	size_t count = 0;
 	int flags = 0;
+	int flag = TYPE_ROT;
 	bool wakeup = true;
 	bool relock = false;
 	ssize_t ret;
@@ -7375,7 +7432,7 @@ static ssize_t btrfs_direct_IO(int rw, struct kiocb *iocb,
 			mutex_unlock(&inode->i_mutex);
 			relock = true;
 		}
-		ret = btrfs_delalloc_reserve_space(inode, count);
+		ret = btrfs_delalloc_reserve_space(inode, count, &flag);
 		if (ret)
 			goto out;
 	} else if (unlikely(test_bit(BTRFS_INODE_READDIO_NEED_LOCK,
@@ -7391,10 +7448,10 @@ static ssize_t btrfs_direct_IO(int rw, struct kiocb *iocb,
 			btrfs_submit_direct, flags);
 	if (rw & WRITE) {
 		if (ret < 0 && ret != -EIOCBQUEUED)
-			btrfs_delalloc_release_space(inode, count);
+			btrfs_delalloc_release_space(inode, count, flag);
 		else if (ret >= 0 && (size_t)ret < count)
 			btrfs_delalloc_release_space(inode,
-						     count - (size_t)ret);
+						     count - (size_t)ret, flag);
 		else
 			btrfs_delalloc_release_metadata(inode, 0);
 	}
@@ -7573,11 +7630,12 @@ int btrfs_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf)
 	loff_t size;
 	int ret;
 	int reserved = 0;
+	int flag = TYPE_ROT;
 	u64 page_start;
 	u64 page_end;
 
 	sb_start_pagefault(inode->i_sb);
-	ret  = btrfs_delalloc_reserve_space(inode, PAGE_CACHE_SIZE);
+	ret  = btrfs_delalloc_reserve_space(inode, PAGE_CACHE_SIZE, &flag);
 	if (!ret) {
 		ret = file_update_time(vma->vm_file);
 		reserved = 1;
@@ -7635,6 +7693,10 @@ again:
 			  EXTENT_DO_ACCOUNTING | EXTENT_DEFRAG,
 			  0, 0, &cached_state, GFP_NOFS);
 
+	if (btrfs_test_opt(root, HOT_MOVE))
+		set_extent_hot(inode, page_start, page_end,
+				&cached_state, flag, 0);
+
 	ret = btrfs_set_extent_delalloc(inode, page_start, page_end,
 					&cached_state);
 	if (ret) {
@@ -7674,7 +7736,7 @@ out_unlock:
 	}
 	unlock_page(page);
 out:
-	btrfs_delalloc_release_space(inode, PAGE_CACHE_SIZE);
+	btrfs_delalloc_release_space(inode, PAGE_CACHE_SIZE, flag);
 out_noreserve:
 	sb_end_pagefault(inode->i_sb);
 	return ret;
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 0de4a2f..91da5ae 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -56,6 +56,7 @@
 #include "rcu-string.h"
 #include "send.h"
 #include "dev-replace.h"
+#include "hot_relocate.h"
 
 /* Mask out flags that are inappropriate for the given type of inode. */
 static inline __u32 btrfs_mask_flags(umode_t mode, __u32 flags)
@@ -1001,6 +1002,7 @@ static int cluster_pages_for_defrag(struct inode *inode,
 	int ret;
 	int i;
 	int i_done;
+	int flag = TYPE_ROT;
 	struct btrfs_ordered_extent *ordered;
 	struct extent_state *cached_state = NULL;
 	struct extent_io_tree *tree;
@@ -1013,7 +1015,7 @@ static int cluster_pages_for_defrag(struct inode *inode,
 	page_cnt = min_t(u64, (u64)num_pages, (u64)file_end - start_index + 1);
 
 	ret = btrfs_delalloc_reserve_space(inode,
-					   page_cnt << PAGE_CACHE_SHIFT);
+					   page_cnt << PAGE_CACHE_SHIFT, &flag);
 	if (ret)
 		return ret;
 	i_done = 0;
@@ -1101,9 +1103,12 @@ again:
 		BTRFS_I(inode)->outstanding_extents++;
 		spin_unlock(&BTRFS_I(inode)->lock);
 		btrfs_delalloc_release_space(inode,
-				     (page_cnt - i_done) << PAGE_CACHE_SHIFT);
+			     (page_cnt - i_done) << PAGE_CACHE_SHIFT, flag);
 	}
 
+	if (btrfs_test_opt(BTRFS_I(inode)->root, HOT_MOVE))
+		set_extent_hot(inode, page_start, page_end - 1,
+				&cached_state, flag, 0);
 
 	set_extent_defrag(&BTRFS_I(inode)->io_tree, page_start, page_end - 1,
 			  &cached_state, GFP_NOFS);
@@ -1126,7 +1131,8 @@ out:
 		unlock_page(pages[i]);
 		page_cache_release(pages[i]);
 	}
-	btrfs_delalloc_release_space(inode, page_cnt << PAGE_CACHE_SHIFT);
+	btrfs_delalloc_release_space(inode,
+				page_cnt << PAGE_CACHE_SHIFT, flag);
 	return ret;
 
 }
@@ -3021,8 +3027,9 @@ static long btrfs_ioctl_space_info(struct btrfs_root *root, void __user *arg)
 	u64 types[] = {BTRFS_BLOCK_GROUP_DATA,
 		       BTRFS_BLOCK_GROUP_SYSTEM,
 		       BTRFS_BLOCK_GROUP_METADATA,
-		       BTRFS_BLOCK_GROUP_DATA | BTRFS_BLOCK_GROUP_METADATA};
-	int num_types = 4;
+		       BTRFS_BLOCK_GROUP_DATA | BTRFS_BLOCK_GROUP_METADATA,
+		       BTRFS_BLOCK_GROUP_DATA_NONROT};
+	int num_types = 5;
 	int alloc_size;
 	int ret = 0;
 	u64 slot_count = 0;
diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index 704a1b8..62c5897 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -31,6 +31,7 @@
 #include "async-thread.h"
 #include "free-space-cache.h"
 #include "inode-map.h"
+#include "hot_relocate.h"
 
 /*
  * backref_node, mapping_node and tree_block start with this
@@ -2938,12 +2939,13 @@ int prealloc_file_extent_cluster(struct inode *inode,
 	u64 num_bytes;
 	int nr = 0;
 	int ret = 0;
+	int flag = TYPE_ROT;
 
 	BUG_ON(cluster->start != cluster->boundary[0]);
 	mutex_lock(&inode->i_mutex);
 
 	ret = btrfs_check_data_free_space(inode, cluster->end +
-					  1 - cluster->start);
+					  1 - cluster->start, &flag);
 	if (ret)
 		goto out;
 
@@ -2965,7 +2967,7 @@ int prealloc_file_extent_cluster(struct inode *inode,
 		nr++;
 	}
 	btrfs_free_reserved_data_space(inode, cluster->end +
-				       1 - cluster->start);
+				       1 - cluster->start, flag);
 out:
 	mutex_unlock(&inode->i_mutex);
 	return ret;
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 09fb9d2..c10477b 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -58,6 +58,7 @@
 #include "rcu-string.h"
 #include "dev-replace.h"
 #include "free-space-cache.h"
+#include "hot_relocate.h"
 
 #define CREATE_TRACE_POINTS
 #include <trace/events/btrfs.h>
@@ -1520,7 +1521,8 @@ static int btrfs_statfs(struct dentry *dentry, struct kstatfs *buf)
 	mutex_lock(&fs_info->chunk_mutex);
 	rcu_read_lock();
 	list_for_each_entry_rcu(found, head, list) {
-		if (found->flags & BTRFS_BLOCK_GROUP_DATA) {
+		if ((found->flags & BTRFS_BLOCK_GROUP_DATA) ||
+			(found->flags & BTRFS_BLOCK_GROUP_DATA_NONROT)) {
 			total_free_data += found->disk_total - found->disk_used;
 			total_free_data -=
 				btrfs_account_ro_block_groups_free_space(found);
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 0e925ce..29e416d 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -1451,6 +1451,9 @@ int btrfs_rm_device(struct btrfs_root *root, char *device_path)
 		all_avail = root->fs_info->avail_data_alloc_bits |
 			    root->fs_info->avail_system_alloc_bits |
 			    root->fs_info->avail_metadata_alloc_bits;
+		if (btrfs_test_opt(root, HOT_MOVE))
+			all_avail |=
+				root->fs_info->avail_data_nonrot_alloc_bits;
 	} while (read_seqretry(&root->fs_info->profiles_lock, seq));
 
 	num_devices = root->fs_info->fs_devices->num_devices;
@@ -3729,7 +3732,8 @@ static int __btrfs_alloc_chunk(struct btrfs_trans_handle *trans,
 	devs_increment = btrfs_raid_array[index].devs_increment;
 	ncopies = btrfs_raid_array[index].ncopies;
 
-	if (type & BTRFS_BLOCK_GROUP_DATA) {
+	if (type & BTRFS_BLOCK_GROUP_DATA ||
+		type & BTRFS_BLOCK_GROUP_DATA_NONROT) {
 		max_stripe_size = 1024 * 1024 * 1024;
 		max_chunk_size = 10 * max_stripe_size;
 	} else if (type & BTRFS_BLOCK_GROUP_METADATA) {
@@ -3768,9 +3772,30 @@ static int __btrfs_alloc_chunk(struct btrfs_trans_handle *trans,
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
+		 * 1 HDD. All allocations to BTRFS_BLOCK_GROUP_DATA_NONROT
+		 * in this config will return -ENOSPC as the allocation code
+		 * can't find allowable space for the second stripe.
+		 */
+		dev_rot = !blk_queue_nonrot(bdev_get_queue(device->bdev));
+		if (btrfs_test_opt(extent_root, HOT_MOVE)) {
+			int ret1 = type & (BTRFS_BLOCK_GROUP_DATA |
+				BTRFS_BLOCK_GROUP_METADATA |
+				BTRFS_BLOCK_GROUP_SYSTEM) && !dev_rot;
+			int ret2 = type & BTRFS_BLOCK_GROUP_DATA_NONROT && dev_rot;
+			if (ret1 || ret2)
+				skip = 1;
+		}
+
 		cur = cur->next;
 
 		if (!device->writeable) {
@@ -3779,7 +3804,7 @@ static int __btrfs_alloc_chunk(struct btrfs_trans_handle *trans,
 			continue;
 		}
 
-		if (!device->in_fs_metadata ||
+		if (skip || !device->in_fs_metadata ||
 		    device->is_tgtdev_for_dev_replace)
 			continue;
 
-- 
1.7.11.7

