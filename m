Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:17927 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760159Ab3GaPiN (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 31 Jul 2013 11:38:13 -0400
Received: from ucsinet22.oracle.com (ucsinet22.oracle.com [156.151.31.94])
	by aserp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with ESMTP id r6VFcBdI014464
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Wed, 31 Jul 2013 15:38:12 GMT
Received: from aserz7022.oracle.com (aserz7022.oracle.com [141.146.126.231])
	by ucsinet22.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r6VFcAnq028724
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Wed, 31 Jul 2013 15:38:11 GMT
Received: from abhmt104.oracle.com (abhmt104.oracle.com [141.146.116.56])
	by aserz7022.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r6VFcAin027775
	for <linux-btrfs@vger.kernel.org>; Wed, 31 Jul 2013 15:38:10 GMT
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [RFC PATCH v5 5/5] Btrfs: online data deduplication
Date: Wed, 31 Jul 2013 23:37:45 +0800
Message-Id: <1375285066-14173-6-git-send-email-bo.li.liu@oracle.com>
In-Reply-To: <1375285066-14173-1-git-send-email-bo.li.liu@oracle.com>
References: <1375285066-14173-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This introduces the online data deduplication feature for btrfs.

(1) WHY do we need deduplication?
    To improve our storage effiency.

(2) WHAT is deduplication?
    Two key ways for practical deduplication implementations,
    *  When the data is deduplicated
       (inband vs background)
    *  The granularity of the deduplication.
       (block level vs file level)

    For btrfs, we choose
    *  inband(synchronous)
    *  block level

    We choose them because of the same reason as how zfs does.
    a)  To get an immediate benefit.
    b)  To remove redundant parts within a file.

    So we have an inband, block level data deduplication here.

(3) HOW does deduplication works?
    This makes full use of file extent back reference, the same way as
    IOCTL_CLONE, which lets us easily store multiple copies of a set of
    data as a single copy along with an index of references to the copy.

    Here we have
    a)  a new dedicated tree(DEDUP tree) and
    b)  a new key(BTRFS_DEDUP_ITEM_KEY), which consists of
        (stop 64bits of hash, type, disk offset),
        *  stop 64bits of hash
           We take the stop 64bits of the sha256 as the index.
           Also we store the whole 256bits of sha256 in its item, which is
           very helpful on avoiding collision.
        *  disk offset
           It helps to find where the data is stored.

    So the whole deduplication process works as,
    1) write something,
    2) calculate the hash of this "something" based on the deduplication unit,
    3) try to find the match of hash value by searching DEDUP keys in
       a dedicated tree, DEDUP tree.
    4) if found, skip real IO and link to the existing copy
       if not, do real IO and insert a DEDUP key to the DEDUP tree.

    Right now, we can
    a) enable deduplication with mount option "-o dedup",
    b) control the deduplication unit with mount options '-o dedup_bs=xxx'.

    The dedault deduplication unit is 8192, and the largest allowed dedup
    blocksize is 128k because of compression range limit.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
v5:
- go back to one dedup key with a special backref for dedup tree because
  the disk format understands backref well.
- fix a fsync hang with dedup enabled.
- rebase onto the latest btrfs.

v4:
- add INCOMPAT flag so that old kernel won't mount with a dedup btrfs.
- elaborate error handling.
- address a compress bug.
- address an issue of dedup flag on extent state tree.
- add new dedup ioctl interface.

v3:
- add compress support
- add a real ioctl to enable dedup feature
- change the maximum allowed dedup blocksize to 128k because of compressed range
  limit

v2:
- Make changelog more clearly.
- To avoid enlarging the file extent item's size, add another index key used for
  freeing dedup extent.
- Freeing dedup extent is now like how we delete checksum.
- Add support for alternative deduplicatin blocksize larger than PAGESIZE.
- Add a mount option to set deduplication blocksize.
- Add support for those writes that are smaller than deduplication blocksize.
- Cleanups

 fs/btrfs/backref.c         |    9 +
 fs/btrfs/ctree.h           |   59 ++++
 fs/btrfs/disk-io.c         |   27 ++
 fs/btrfs/extent-tree.c     |  152 +++++++++--
 fs/btrfs/extent_io.c       |   29 ++-
 fs/btrfs/extent_io.h       |   16 ++
 fs/btrfs/file-item.c       |  217 +++++++++++++++
 fs/btrfs/inode.c           |  637 ++++++++++++++++++++++++++++++++++++++------
 fs/btrfs/ioctl.c           |   93 +++++++
 fs/btrfs/ordered-data.c    |   36 ++-
 fs/btrfs/ordered-data.h    |   11 +-
 fs/btrfs/relocation.c      |    3 +
 fs/btrfs/super.c           |   27 ++-
 include/uapi/linux/btrfs.h |    5 +
 14 files changed, 1210 insertions(+), 111 deletions(-)

diff --git a/fs/btrfs/backref.c b/fs/btrfs/backref.c
index eaf1333..92f3737 100644
--- a/fs/btrfs/backref.c
+++ b/fs/btrfs/backref.c
@@ -558,6 +558,9 @@ static int __add_delayed_refs(struct btrfs_delayed_ref_head *head, u64 seq,
 			key.objectid = ref->objectid;
 			key.type = BTRFS_EXTENT_DATA_KEY;
 			key.offset = ref->offset;
+			if (ref->root == BTRFS_DEDUP_TREE_OBJECTID)
+				break;
+
 			ret = __add_prelim_ref(prefs, ref->root, &key, 0, 0,
 					       node->bytenr,
 					       node->ref_mod * sgn);
@@ -676,6 +679,9 @@ static int __add_inline_refs(struct btrfs_fs_info *fs_info,
 			key.type = BTRFS_EXTENT_DATA_KEY;
 			key.offset = btrfs_extent_data_ref_offset(leaf, dref);
 			root = btrfs_extent_data_ref_root(leaf, dref);
+			if (root == BTRFS_DEDUP_TREE_OBJECTID)
+				break;
+
 			ret = __add_prelim_ref(prefs, root, &key, 0, 0,
 					       bytenr, count);
 			break;
@@ -759,6 +765,9 @@ static int __add_keyed_refs(struct btrfs_fs_info *fs_info,
 			key.type = BTRFS_EXTENT_DATA_KEY;
 			key.offset = btrfs_extent_data_ref_offset(leaf, dref);
 			root = btrfs_extent_data_ref_root(leaf, dref);
+			if (root == BTRFS_DEDUP_TREE_OBJECTID)
+				break;
+
 			ret = __add_prelim_ref(prefs, root, &key, 0, 0,
 					       bytenr, count);
 			break;
diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index e795bf1..92b463f 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -32,6 +32,7 @@
 #include <asm/kmap_types.h>
 #include <linux/pagemap.h>
 #include <linux/btrfs.h>
+#include <crypto/hash.h>
 #include "extent_io.h"
 #include "extent_map.h"
 #include "async-thread.h"
@@ -94,6 +95,9 @@ struct btrfs_ordered_sum;
 /* for storing balance parameters in the root tree */
 #define BTRFS_BALANCE_OBJECTID -4ULL
 
+/* dedup tree(experimental) */
+#define BTRFS_DEDUP_TREE_OBJECTID 9ULL
+
 /* orhpan objectid for tracking unlinked/truncated files */
 #define BTRFS_ORPHAN_OBJECTID -5ULL
 
@@ -510,6 +514,7 @@ struct btrfs_super_block {
 #define BTRFS_FEATURE_INCOMPAT_EXTENDED_IREF	(1ULL << 6)
 #define BTRFS_FEATURE_INCOMPAT_RAID56		(1ULL << 7)
 #define BTRFS_FEATURE_INCOMPAT_SKINNY_METADATA	(1ULL << 8)
+#define BTRFS_FEATURE_INCOMPAT_DEDUP           (1ULL << 9)
 
 #define BTRFS_FEATURE_COMPAT_SUPP		0ULL
 #define BTRFS_FEATURE_COMPAT_RO_SUPP		0ULL
@@ -521,6 +526,7 @@ struct btrfs_super_block {
 	 BTRFS_FEATURE_INCOMPAT_COMPRESS_LZO |		\
 	 BTRFS_FEATURE_INCOMPAT_RAID56 |		\
 	 BTRFS_FEATURE_INCOMPAT_EXTENDED_IREF |		\
+	 BTRFS_FEATURE_INCOMPAT_DEDUP |			\
 	 BTRFS_FEATURE_INCOMPAT_SKINNY_METADATA)
 
 /*
@@ -892,6 +898,24 @@ struct btrfs_csum_item {
 	u8 csum;
 } __attribute__ ((__packed__));
 
+/* dedup */
+struct btrfs_dedup_item {
+	__le64 len;	/* disk length of dedup range */
+
+	u8 compression;
+	u8 encryption;
+	__le16 other_encoding; /* spare for later use */
+} __attribute__ ((__packed__));
+
+#define BTRFS_DEDUP_HASH_SIZE 32	/* 256bit = 32 * 8bit */
+#define BTRFS_DEDUP_HASH_LEN 4
+
+struct btrfs_dedup_hash_item {
+	/* FIXME: put a hash type field here */
+
+	__le64 hash[BTRFS_DEDUP_HASH_LEN];
+} __attribute__ ((__packed__));
+
 struct btrfs_dev_stats_item {
 	/*
 	 * grow this item struct at the end for future enhancements and keep
@@ -1301,6 +1325,7 @@ struct btrfs_fs_info {
 	struct btrfs_root *dev_root;
 	struct btrfs_root *fs_root;
 	struct btrfs_root *csum_root;
+	struct btrfs_root *dedup_root;
 	struct btrfs_root *quota_root;
 
 	/* the log root tree is a directory of all the other log roots */
@@ -1641,6 +1666,16 @@ struct btrfs_fs_info {
 	struct btrfs_dev_replace dev_replace;
 
 	atomic_t mutually_exclusive_operation_running;
+
+	/* reference to deduplication algorithm drvier via cryptoapi */
+	struct crypto_shash *dedup_driver;
+
+	/* dedup blocksize */
+	u64 dedup_bs;
+
+	/* protect user change for dedup operations */
+	struct mutex dedup_ioctl_mutex;
+
 };
 
 /*
@@ -1933,6 +1968,8 @@ struct btrfs_ioctl_defrag_range_args {
  */
 #define BTRFS_DEV_REPLACE_KEY	250
 
+#define BTRFS_DEDUP_ITEM_KEY	251
+
 /*
  * string items are for debugging.  They just store a short string of
  * data in the FS
@@ -1967,6 +2004,7 @@ struct btrfs_ioctl_defrag_range_args {
 #define BTRFS_MOUNT_CHECK_INTEGRITY	(1 << 20)
 #define BTRFS_MOUNT_CHECK_INTEGRITY_INCLUDING_EXTENT_DATA (1 << 21)
 #define BTRFS_MOUNT_PANIC_ON_FATAL_ERROR	(1 << 22)
+#define BTRFS_MOUNT_DEDUP		(1 << 24)
 
 #define btrfs_clear_opt(o, opt)		((o) &= ~BTRFS_MOUNT_##opt)
 #define btrfs_set_opt(o, opt)		((o) |= BTRFS_MOUNT_##opt)
@@ -2902,6 +2940,13 @@ static inline u32 btrfs_file_extent_inline_item_len(struct extent_buffer *eb,
 	return btrfs_item_size(eb, e) - offset;
 }
 
+/* btrfs_dedup_item */
+BTRFS_SETGET_FUNCS(dedup_len, struct btrfs_dedup_item, len, 64);
+BTRFS_SETGET_FUNCS(dedup_compression, struct btrfs_dedup_item, compression, 8);
+BTRFS_SETGET_FUNCS(dedup_encryption, struct btrfs_dedup_item, encryption, 8);
+BTRFS_SETGET_FUNCS(dedup_other_encoding, struct btrfs_dedup_item,
+		   other_encoding, 16);
+
 /* btrfs_dev_stats_item */
 static inline u64 btrfs_dev_stats_value(struct extent_buffer *eb,
 					struct btrfs_dev_stats_item *ptr,
@@ -3372,6 +3417,8 @@ static inline int btrfs_need_cleaner_sleep(struct btrfs_root *root)
 
 static inline void free_fs_info(struct btrfs_fs_info *fs_info)
 {
+	if (fs_info->dedup_driver)
+		crypto_free_shash(fs_info->dedup_driver);
 	kfree(fs_info->balance_ctl);
 	kfree(fs_info->delayed_root);
 	kfree(fs_info->extent_root);
@@ -3535,6 +3582,18 @@ int btrfs_csum_truncate(struct btrfs_trans_handle *trans,
 			u64 isize);
 int btrfs_lookup_csums_range(struct btrfs_root *root, u64 start, u64 end,
 			     struct list_head *list, int search_commit);
+
+int noinline_for_stack
+btrfs_find_dedup_extent(struct btrfs_trans_handle *trans,
+			struct btrfs_root *root, u64 *hash, u64 *bytenr_ret,
+			u64 *num_bytes_ret, int *compr_ret);
+int noinline_for_stack
+btrfs_insert_dedup_extent(struct btrfs_trans_handle *trans,
+			  struct btrfs_root *root, u64 *hash, u64 bytenr,
+			  u64 num_bytes, int compr);
+int noinline_for_stack
+btrfs_free_dedup_extent(struct btrfs_trans_handle *trans,
+			struct btrfs_root *root, u64 hash, u64 bytenr);
 /* inode.c */
 struct btrfs_delalloc_work {
 	struct inode *inode;
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index b6d597a..72d470c 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1580,6 +1580,9 @@ struct btrfs_root *btrfs_read_fs_root_no_name(struct btrfs_fs_info *fs_info,
 	if (location->objectid == BTRFS_QUOTA_TREE_OBJECTID)
 		return fs_info->quota_root ? fs_info->quota_root :
 					     ERR_PTR(-ENOENT);
+	if (location->objectid == BTRFS_DEDUP_TREE_OBJECTID)
+		return fs_info->dedup_root ? fs_info->dedup_root :
+					     ERR_PTR(-ENOENT);
 again:
 	root = btrfs_lookup_fs_root(fs_info, location->objectid);
 	if (root)
@@ -2037,6 +2040,12 @@ static void free_root_pointers(struct btrfs_fs_info *info, int chunk_root)
 		info->quota_root->node = NULL;
 		info->quota_root->commit_root = NULL;
 	}
+	if (info->dedup_root) {
+		free_extent_buffer(info->dedup_root->node);
+		free_extent_buffer(info->dedup_root->commit_root);
+		info->dedup_root->node = NULL;
+		info->dedup_root->commit_root = NULL;
+	}
 	if (chunk_root) {
 		free_extent_buffer(info->chunk_root->node);
 		free_extent_buffer(info->chunk_root->commit_root);
@@ -2097,6 +2106,7 @@ int open_ctree(struct super_block *sb,
 	struct btrfs_root *chunk_root;
 	struct btrfs_root *dev_root;
 	struct btrfs_root *quota_root;
+	struct btrfs_root *dedup_root;
 	struct btrfs_root *log_tree_root;
 	int ret;
 	int err = -EINVAL;
@@ -2184,6 +2194,7 @@ int open_ctree(struct super_block *sb,
 	atomic64_set(&fs_info->tree_mod_seq, 0);
 	fs_info->sb = sb;
 	fs_info->max_inline = 8192 * 1024;
+	fs_info->dedup_bs = 8192;
 	fs_info->metadata_ratio = 0;
 	fs_info->defrag_inodes = RB_ROOT;
 	fs_info->free_chunk_space = 0;
@@ -2282,6 +2293,7 @@ int open_ctree(struct super_block *sb,
 	mutex_init(&fs_info->dev_replace.lock_finishing_cancel_unmount);
 	mutex_init(&fs_info->dev_replace.lock_management_lock);
 	mutex_init(&fs_info->dev_replace.lock);
+	mutex_init(&fs_info->dedup_ioctl_mutex);
 
 	spin_lock_init(&fs_info->qgroup_lock);
 	mutex_init(&fs_info->qgroup_ioctl_lock);
@@ -2457,6 +2469,14 @@ int open_ctree(struct super_block *sb,
 		goto fail_alloc;
 	}
 
+	fs_info->dedup_driver = crypto_alloc_shash("sha256", 0, 0);
+	if (IS_ERR(fs_info->dedup_driver)) {
+		pr_info("Cannot load sha256 driver\n");
+		err = PTR_ERR(fs_info->dedup_driver);
+		fs_info->dedup_driver = NULL;
+		goto fail_alloc;
+	}
+
 	btrfs_init_workers(&fs_info->generic_worker,
 			   "genwork", 1, NULL);
 
@@ -2695,6 +2715,13 @@ retry_root_backup:
 		fs_info->quota_root = quota_root;
 	}
 
+	location.objectid = BTRFS_DEDUP_TREE_OBJECTID;
+	dedup_root = btrfs_read_tree_root(tree_root, &location);
+	if (!IS_ERR(dedup_root)) {
+		dedup_root->track_dirty = 1;
+		fs_info->dedup_root = dedup_root;
+	}
+
 	fs_info->generation = generation;
 	fs_info->last_trans_committed = generation;
 
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index c6612f5..36d658d 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -1102,8 +1102,16 @@ static noinline int lookup_extent_data_ref(struct btrfs_trans_handle *trans,
 		key.offset = parent;
 	} else {
 		key.type = BTRFS_EXTENT_DATA_REF_KEY;
-		key.offset = hash_extent_data_ref(root_objectid,
-						  owner, offset);
+
+		/*
+		 * we've not got the right offset and owner, so search by -1
+		 * here.
+		 */
+		if (root_objectid == BTRFS_DEDUP_TREE_OBJECTID)
+			key.offset = -1;
+		else
+			key.offset = hash_extent_data_ref(root_objectid,
+							  owner, offset);
 	}
 again:
 	recow = 0;
@@ -1130,6 +1138,10 @@ again:
 		goto fail;
 	}
 
+	if (ret > 0 && root_objectid == BTRFS_DEDUP_TREE_OBJECTID &&
+	    path->slots[0] > 0)
+		path->slots[0]--;
+
 	leaf = path->nodes[0];
 	nritems = btrfs_header_nritems(leaf);
 	while (1) {
@@ -1153,14 +1165,22 @@ again:
 		ref = btrfs_item_ptr(leaf, path->slots[0],
 				     struct btrfs_extent_data_ref);
 
-		if (match_extent_data_ref(leaf, ref, root_objectid,
-					  owner, offset)) {
-			if (recow) {
-				btrfs_release_path(path);
-				goto again;
+		if (root_objectid == BTRFS_DEDUP_TREE_OBJECTID) {
+			if (btrfs_extent_data_ref_root(leaf, ref) ==
+			    root_objectid) {
+				err = 0;
+				break;
+			}
+		} else {
+			if (match_extent_data_ref(leaf, ref, root_objectid,
+						  owner, offset)) {
+				if (recow) {
+					btrfs_release_path(path);
+					goto again;
+				}
+				err = 0;
+				break;
 			}
-			err = 0;
-			break;
 		}
 		path->slots[0]++;
 	}
@@ -1304,6 +1324,32 @@ static noinline int remove_extent_data_ref(struct btrfs_trans_handle *trans,
 	return ret;
 }
 
+static noinline u64 extent_data_ref_offset(struct btrfs_root *root,
+					  struct btrfs_path *path,
+					  struct btrfs_extent_inline_ref *iref)
+{
+	struct btrfs_key key;
+	struct extent_buffer *leaf;
+	struct btrfs_extent_data_ref *ref1;
+	u64 offset = 0;
+
+	leaf = path->nodes[0];
+	btrfs_item_key_to_cpu(leaf, &key, path->slots[0]);
+	if (iref) {
+		BUG_ON(btrfs_extent_inline_ref_type(leaf, iref) !=
+		    BTRFS_EXTENT_DATA_REF_KEY);
+		ref1 = (struct btrfs_extent_data_ref *)(&iref->offset);
+		offset = btrfs_extent_data_ref_offset(leaf, ref1);
+	} else if (key.type == BTRFS_EXTENT_DATA_REF_KEY) {
+		ref1 = btrfs_item_ptr(leaf, path->slots[0],
+				      struct btrfs_extent_data_ref);
+		offset = btrfs_extent_data_ref_offset(leaf, ref1);
+	} else {
+		WARN_ON(1);
+	}
+	return offset;
+}
+
 static noinline u32 extent_data_ref_count(struct btrfs_root *root,
 					  struct btrfs_path *path,
 					  struct btrfs_extent_inline_ref *iref)
@@ -1571,7 +1617,8 @@ again:
 	err = -ENOENT;
 	while (1) {
 		if (ptr >= end) {
-			WARN_ON(ptr > end);
+			WARN_ON(ptr > end &&
+				root_objectid != BTRFS_DEDUP_TREE_OBJECTID);
 			break;
 		}
 		iref = (struct btrfs_extent_inline_ref *)ptr;
@@ -1586,14 +1633,25 @@ again:
 		if (type == BTRFS_EXTENT_DATA_REF_KEY) {
 			struct btrfs_extent_data_ref *dref;
 			dref = (struct btrfs_extent_data_ref *)(&iref->offset);
-			if (match_extent_data_ref(leaf, dref, root_objectid,
-						  owner, offset)) {
-				err = 0;
-				break;
+
+			if (root_objectid == BTRFS_DEDUP_TREE_OBJECTID) {
+				if (btrfs_extent_data_ref_root(leaf, dref) ==
+				    root_objectid) {
+					err = 0;
+					break;
+				}
+			} else {
+				if (match_extent_data_ref(leaf, dref,
+							  root_objectid, owner,
+							  offset)) {
+					err = 0;
+					break;
+				}
+				if (hash_extent_data_ref_item(leaf, dref) <
+				    hash_extent_data_ref(root_objectid, owner,
+							 offset))
+					break;
 			}
-			if (hash_extent_data_ref_item(leaf, dref) <
-			    hash_extent_data_ref(root_objectid, owner, offset))
-				break;
 		} else {
 			u64 ref_offset;
 			ref_offset = btrfs_extent_inline_ref_offset(leaf, iref);
@@ -4695,6 +4753,8 @@ static void init_global_block_rsv(struct btrfs_fs_info *fs_info)
 	if (fs_info->quota_root)
 		fs_info->quota_root->block_rsv = &fs_info->global_block_rsv;
 	fs_info->chunk_root->block_rsv = &fs_info->chunk_block_rsv;
+	if (fs_info->dedup_root)
+		fs_info->dedup_root->block_rsv = &fs_info->global_block_rsv;
 
 	update_global_block_rsv(fs_info);
 }
@@ -5613,11 +5673,13 @@ static int __btrfs_free_extent(struct btrfs_trans_handle *trans,
 	struct btrfs_extent_inline_ref *iref;
 	int ret;
 	int is_data;
-	int extent_slot = 0;
-	int found_extent = 0;
-	int num_to_del = 1;
+	int extent_slot;
+	int found_extent;
+	int num_to_del;
 	u32 item_size;
 	u64 refs;
+	u64 orig_root_obj;
+	u64 dedup_hash;
 	bool skinny_metadata = btrfs_fs_incompat(root->fs_info,
 						 SKINNY_METADATA);
 
@@ -5625,6 +5687,13 @@ static int __btrfs_free_extent(struct btrfs_trans_handle *trans,
 	if (!path)
 		return -ENOMEM;
 
+again:
+	extent_slot = 0;
+	found_extent = 0;
+	num_to_del = 1;
+	orig_root_obj = root_objectid;
+	dedup_hash = 0;
+
 	path->reada = 1;
 	path->leave_spinning = 1;
 
@@ -5666,6 +5735,12 @@ static int __btrfs_free_extent(struct btrfs_trans_handle *trans,
 #endif
 		if (!found_extent) {
 			BUG_ON(iref);
+
+			if (is_data &&
+			    root_objectid == BTRFS_DEDUP_TREE_OBJECTID) {
+				dedup_hash = extent_data_ref_offset(root, path,
+								    NULL);
+			}
 			ret = remove_extent_backref(trans, extent_root, path,
 						    NULL, refs_to_drop,
 						    is_data);
@@ -5723,6 +5798,10 @@ static int __btrfs_free_extent(struct btrfs_trans_handle *trans,
 			}
 			extent_slot = path->slots[0];
 		}
+	} else if (ret == -ENOENT &&
+		   root_objectid == BTRFS_DEDUP_TREE_OBJECTID) {
+		ret = 0;
+		goto out;
 	} else if (ret == -ENOENT) {
 		btrfs_print_leaf(extent_root, path->nodes[0]);
 		WARN_ON(1);
@@ -5819,7 +5898,28 @@ static int __btrfs_free_extent(struct btrfs_trans_handle *trans,
 		}
 		add_pinned_bytes(root->fs_info, -num_bytes, owner_objectid,
 				 root_objectid);
+
+		/*
+		 * special case for dedup
+		 *
+		 * We assume the last ref(ref==1) is backref pointing to dedup.
+		 *
+		 * root_obj == 1 means that it's a free space cache inode,
+		 * and it always uses PREALLOC, so it never has dedup extent.
+		 */
+		if (is_data && root->fs_info->dedup_root &&
+		    orig_root_obj != BTRFS_ROOT_TREE_OBJECTID && refs == 1) {
+			btrfs_release_path(path);
+			root_objectid = BTRFS_DEDUP_TREE_OBJECTID;
+			parent = 0;
+
+			goto again;
+		}
 	} else {
+		if (!dedup_hash && is_data &&
+		    root_objectid == BTRFS_DEDUP_TREE_OBJECTID)
+			dedup_hash = extent_data_ref_offset(root, path, iref);
+
 		if (found_extent) {
 			BUG_ON(is_data && refs_to_drop !=
 			       extent_data_ref_count(root, path, iref));
@@ -5846,6 +5946,18 @@ static int __btrfs_free_extent(struct btrfs_trans_handle *trans,
 				btrfs_abort_transaction(trans, extent_root, ret);
 				goto out;
 			}
+
+			if (root_objectid == BTRFS_DEDUP_TREE_OBJECTID) {
+				ret = btrfs_free_dedup_extent(trans, root,
+							      dedup_hash,
+							      bytenr);
+				if (ret) {
+					btrfs_abort_transaction(trans,
+								extent_root,
+								ret);
+					goto out;
+				}
+			}
 		}
 
 		ret = update_block_group(root, bytenr, num_bytes, 0);
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index f8586a9..663aed5c 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -1259,6 +1259,20 @@ int clear_extent_uptodate(struct extent_io_tree *tree, u64 start, u64 end,
 				cached_state, mask);
 }
 
+int set_extent_dedup(struct extent_io_tree *tree, u64 start, u64 end,
+		     struct extent_state **cached_state, gfp_t mask)
+{
+	return set_extent_bit(tree, start, end, EXTENT_DEDUP, 0,
+			      cached_state, mask);
+}
+
+int clear_extent_dedup(struct extent_io_tree *tree, u64 start, u64 end,
+			  struct extent_state **cached_state, gfp_t mask)
+{
+	return clear_extent_bit(tree, start, end, EXTENT_DEDUP, 0, 0,
+				cached_state, mask);
+}
+
 /*
  * either insert or lock state struct between start and end use mask to tell
  * us if waiting is desired.
@@ -1704,6 +1718,8 @@ int extent_clear_unlock_delalloc(struct inode *inode,
 		clear_bits |= EXTENT_LOCKED;
 	if (op & EXTENT_CLEAR_DIRTY)
 		clear_bits |= EXTENT_DIRTY;
+	if (op & EXTENT_CLEAR_DEDUP)
+		clear_bits |= EXTENT_DEDUP;
 
 	if (op & EXTENT_CLEAR_DELALLOC)
 		clear_bits |= EXTENT_DELALLOC;
@@ -2413,7 +2429,7 @@ int end_extent_writepage(struct page *page, int err, u64 start, u64 end)
  * Scheduling is not allowed, so the extent state tree is expected
  * to have one and only one object corresponding to this IO.
  */
-static void end_bio_extent_writepage(struct bio *bio, int err)
+void end_bio_extent_writepage(struct bio *bio, int err)
 {
 	struct bio_vec *bvec = bio->bi_io_vec + bio->bi_vcnt - 1;
 	struct extent_io_tree *tree;
@@ -2618,8 +2634,8 @@ struct bio *btrfs_io_bio_alloc(gfp_t gfp_mask, unsigned int nr_iovecs)
 }
 
 
-static int __must_check submit_one_bio(int rw, struct bio *bio,
-				       int mirror_num, unsigned long bio_flags)
+int __must_check submit_one_bio(int rw, struct bio *bio, int mirror_num,
+				unsigned long bio_flags)
 {
 	int ret = 0;
 	struct bio_vec *bvec = bio->bi_io_vec + bio->bi_vcnt - 1;
@@ -2658,7 +2674,7 @@ static int merge_bio(int rw, struct extent_io_tree *tree, struct page *page,
 
 }
 
-static int submit_extent_page(int rw, struct extent_io_tree *tree,
+int submit_extent_page(int rw, struct extent_io_tree *tree,
 			      struct page *page, sector_t sector,
 			      size_t size, unsigned long offset,
 			      struct block_device *bdev,
@@ -3721,9 +3737,10 @@ int extent_write_locked_range(struct extent_io_tree *tree, struct inode *inode,
 
 	while (start <= end) {
 		page = find_get_page(mapping, start >> PAGE_CACHE_SHIFT);
-		if (clear_page_dirty_for_io(page))
+
+		if (clear_page_dirty_for_io(page)) {
 			ret = __extent_writepage(page, &wbc_writepages, &epd);
-		else {
+		} else {
 			if (tree->ops && tree->ops->writepage_end_io_hook)
 				tree->ops->writepage_end_io_hook(page, start,
 						 start + PAGE_CACHE_SIZE - 1,
diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
index 3b8c4e2..874d743 100644
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -20,6 +20,7 @@
 #define EXTENT_NEED_WAIT (1 << 13)
 #define EXTENT_DAMAGED (1 << 14)
 #define EXTENT_NORESERVE (1 << 15)
+#define EXTENT_DEDUP (1 << 16)
 #define EXTENT_IOBITS (EXTENT_LOCKED | EXTENT_WRITEBACK)
 #define EXTENT_CTLBITS (EXTENT_DO_ACCOUNTING | EXTENT_FIRST_DELALLOC)
 
@@ -52,6 +53,7 @@
 #define EXTENT_END_WRITEBACK	 0x20
 #define EXTENT_SET_PRIVATE2	 0x40
 #define EXTENT_CLEAR_ACCOUNTING  0x80
+#define EXTENT_CLEAR_DEDUP	 0x100
 
 /*
  * page->private values.  Every page that is controlled by the extent
@@ -225,6 +227,10 @@ int set_extent_uptodate(struct extent_io_tree *tree, u64 start, u64 end,
 			struct extent_state **cached_state, gfp_t mask);
 int clear_extent_uptodate(struct extent_io_tree *tree, u64 start, u64 end,
 			  struct extent_state **cached_state, gfp_t mask);
+int set_extent_dedup(struct extent_io_tree *tree, u64 start, u64 end,
+		     struct extent_state **cached_state, gfp_t mask);
+int clear_extent_dedup(struct extent_io_tree *tree, u64 start, u64 end,
+		       struct extent_state **cached_state, gfp_t mask);
 int set_extent_new(struct extent_io_tree *tree, u64 start, u64 end,
 		   gfp_t mask);
 int set_extent_dirty(struct extent_io_tree *tree, u64 start, u64 end,
@@ -348,4 +354,14 @@ int repair_io_failure(struct btrfs_fs_info *fs_info, u64 start,
 int end_extent_writepage(struct page *page, int err, u64 start, u64 end);
 int repair_eb_io_failure(struct btrfs_root *root, struct extent_buffer *eb,
 			 int mirror_num);
+int submit_extent_page(int rw, struct extent_io_tree *tree, struct page *page,
+		       sector_t sector, size_t size, unsigned long offset,
+		       struct block_device *bdev, struct bio **bio_ret,
+		       unsigned long max_pages, bio_end_io_t end_io_func,
+		       int mirror_num, unsigned long prev_bio_flags,
+		       unsigned long bio_flags);
+void end_bio_extent_writepage(struct bio *bio, int err);
+int __must_check submit_one_bio(int rw, struct bio *bio, int mirror_num,
+				unsigned long bio_flags);
+
 #endif
diff --git a/fs/btrfs/file-item.c b/fs/btrfs/file-item.c
index a7bfc95..088858a 100644
--- a/fs/btrfs/file-item.c
+++ b/fs/btrfs/file-item.c
@@ -858,3 +858,220 @@ out:
 fail_unlock:
 	goto out;
 }
+
+/* 1 means we find one, 0 means we dont. */
+int noinline_for_stack
+btrfs_find_dedup_extent(struct btrfs_trans_handle *trans,
+			struct btrfs_root *root, u64 *hash, u64 *bytenr_ret,
+			u64 *num_bytes_ret, int *compr_ret)
+{
+	struct btrfs_key key;
+	struct btrfs_path *path;
+	struct extent_buffer *leaf;
+	struct btrfs_root *dedup_root;
+	struct btrfs_dedup_item *item;
+	struct btrfs_dedup_hash_item *hash_item;
+	u64 *hash_in_item[4];
+	u64 hash_value;
+	u64 length;
+	int compression;
+	int found = 0;
+	int ret;
+
+	if (!root->fs_info->dedup_root) {
+		WARN(1, KERN_INFO "dedup not enabled\n");
+		return 0;
+	}
+
+	dedup_root = root->fs_info->dedup_root;
+
+	path = btrfs_alloc_path();
+	if (!path)
+		return found;
+
+	hash_value = hash[BTRFS_DEDUP_HASH_LEN - 1];
+
+	key.objectid = hash_value;
+	key.offset = -1;
+	btrfs_set_key_type(&key, BTRFS_DEDUP_ITEM_KEY);
+
+	ret = btrfs_search_slot(trans, dedup_root, &key, path, 0, 0);
+	if (ret < 0)
+		goto out;
+	if (ret == 0) {
+		WARN_ON(1);
+		goto out;
+	}
+
+prev_slot:
+	/* this will do match checks. */
+	ret = btrfs_previous_item(dedup_root, path, hash_value,
+				  BTRFS_DEDUP_ITEM_KEY);
+	if (ret)
+		goto out;
+
+	leaf = path->nodes[0];
+
+	item = btrfs_item_ptr(leaf, path->slots[0], struct btrfs_dedup_item);
+	/* disk length of dedup range */
+	length = btrfs_dedup_len(leaf, item);
+	if (length > root->fs_info->dedup_bs) {
+		WARN_ON(1);
+		goto out;
+	}
+
+	compression = btrfs_dedup_compression(leaf, item);
+	if (compression > BTRFS_COMPRESS_TYPES) {
+		WARN_ON(1);
+		goto out;
+	}
+
+	hash_item = (struct btrfs_dedup_hash_item *)(item + 1);
+	if (sizeof(*hash_item) != BTRFS_DEDUP_HASH_SIZE) {
+		WARN_ON(1);
+		goto out;
+	}
+
+	read_extent_buffer(leaf, hash_in_item, ((unsigned long)hash_item),
+			   BTRFS_DEDUP_HASH_SIZE);
+	if (memcmp((char *)hash_in_item, (char *)hash, sizeof(*hash_item))) {
+		pr_info("goto prev\n");
+		goto prev_slot;
+	}
+
+	btrfs_item_key_to_cpu(leaf, &key, path->slots[0]);
+
+	/* bytenr_ret should exist as we need to return it to caller */
+	BUG_ON(!bytenr_ret);
+	*bytenr_ret = key.offset;
+	*num_bytes_ret = length;
+	*compr_ret = compression;
+	found = 1;
+out:
+	btrfs_free_path(path);
+	return found;
+}
+
+int noinline_for_stack
+btrfs_insert_dedup_extent(struct btrfs_trans_handle *trans,
+			  struct btrfs_root *root, u64 *hash, u64 bytenr,
+			  u64 num_bytes, int compr)
+{
+	struct btrfs_key key;
+	struct btrfs_path *path;
+	struct extent_buffer *leaf;
+	struct btrfs_root *dedup_root;
+	struct btrfs_dedup_item *dedup_item;
+	struct btrfs_dedup_hash_item *hash_item;
+	u64 ins_size;
+	int ret;
+
+	if (!root->fs_info->dedup_root) {
+		WARN(1, KERN_INFO "dedup not enabled\n");
+		return 0;
+	}
+
+	dedup_root = root->fs_info->dedup_root;
+
+	path = btrfs_alloc_path();
+	if (!path)
+		return -ENOMEM;
+
+	/* insert index by hash */
+	ins_size = sizeof(*dedup_item) + sizeof(*hash_item);
+
+	key.objectid = hash[BTRFS_DEDUP_HASH_LEN - 1];
+	key.offset = bytenr;
+	btrfs_set_key_type(&key, BTRFS_DEDUP_ITEM_KEY);
+
+	path->leave_spinning = 1;
+	ret = btrfs_insert_empty_item(trans, dedup_root, path, &key, ins_size);
+	if (ret < 0)
+		goto out;
+	leaf = path->nodes[0];
+
+	dedup_item = btrfs_item_ptr(leaf, path->slots[0],
+				    struct btrfs_dedup_item);
+	/* disk length of dedup range */
+	BUG_ON(num_bytes > root->fs_info->dedup_bs);
+	btrfs_set_dedup_len(leaf, dedup_item, num_bytes);
+	btrfs_set_dedup_compression(leaf, dedup_item, compr);
+	btrfs_set_dedup_encryption(leaf, dedup_item, 0);
+	btrfs_set_dedup_other_encoding(leaf, dedup_item, 0);
+
+	hash_item = (struct btrfs_dedup_hash_item *)(dedup_item + 1);
+	if (sizeof(*hash_item) != BTRFS_DEDUP_HASH_SIZE) {
+		WARN_ON(1);
+		goto out;
+	}
+
+	write_extent_buffer(leaf, hash, (unsigned long)hash_item,
+			    BTRFS_DEDUP_HASH_SIZE);
+
+	btrfs_mark_buffer_dirty(leaf);
+out:
+	/* TODO: EEXIST means that we need to mark it as a dup one */
+	WARN_ON(ret == -EEXIST);
+	btrfs_free_path(path);
+	return ret;
+}
+
+int noinline_for_stack
+btrfs_free_dedup_extent(struct btrfs_trans_handle *trans,
+			struct btrfs_root *root, u64 hash, u64 bytenr)
+{
+	struct btrfs_key key;
+	struct btrfs_path *path;
+	struct extent_buffer *leaf;
+	struct btrfs_root *dedup_root;
+	struct btrfs_dedup_item *dedup_item;
+	struct btrfs_dedup_hash_item *hash_item;
+	u64 hash_in_item[4];
+	int ret = 0;
+
+	if (!root->fs_info->dedup_root)
+		return 0;
+
+	dedup_root = root->fs_info->dedup_root;
+
+	path = btrfs_alloc_path();
+	if (!path)
+		return ret;
+
+	/* index by hash */
+	key.objectid = hash;
+	key.offset = bytenr;
+	btrfs_set_key_type(&key, BTRFS_DEDUP_ITEM_KEY);
+
+	ret = btrfs_search_slot(trans, dedup_root, &key, path, -1, 1);
+	if (ret < 0)
+		goto out;
+	if (ret) {
+		WARN_ON(1);
+		ret = -ENOENT;
+		goto out;
+	}
+
+	leaf = path->nodes[0];
+
+	ret = -ENOENT;
+	btrfs_item_key_to_cpu(leaf, &key, path->slots[0]);
+	if (btrfs_key_type(&key) != BTRFS_DEDUP_ITEM_KEY)
+		goto out;
+	if (key.objectid != hash || key.offset != bytenr)
+		goto out;
+
+	dedup_item = btrfs_item_ptr(leaf, path->slots[0],
+				    struct btrfs_dedup_item);
+	hash_item = (struct btrfs_dedup_hash_item *)(dedup_item + 1);
+	read_extent_buffer(leaf, hash_in_item, ((unsigned long)hash_item),
+			   BTRFS_DEDUP_HASH_SIZE);
+	if (hash_in_item[BTRFS_DEDUP_HASH_LEN - 1] != hash)
+		BUG_ON(1);
+
+	ret = btrfs_del_item(trans, dedup_root, path);
+	WARN_ON(ret);
+out:
+	btrfs_free_path(path);
+	return ret;
+}
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index d0544bf..a3041ec 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -104,6 +104,16 @@ static struct extent_map *create_pinned_em(struct inode *inode, u64 start,
 					   u64 block_start, u64 block_len,
 					   u64 orig_block_len, u64 ram_bytes,
 					   int type);
+static noinline int cow_file_range_dedup(struct inode *inode,
+					 struct page *locked_page,
+					 u64 start, u64 end, int *page_started,
+					 unsigned long *nr_written, int unlock,
+					 u64 *hash);
+static int run_locked_range(struct extent_io_tree *tree, struct inode *inode,
+			    struct page *locked_page, u64 start, u64 end,
+			    get_extent_t *get_extent, int mode, u64 *hash);
+static int btrfs_inode_test_compress(struct inode *inode);
+
 
 static int btrfs_dirty_inode(struct inode *inode);
 
@@ -285,6 +295,7 @@ struct async_extent {
 	unsigned long nr_pages;
 	int compress_type;
 	struct list_head list;
+	u64 *hash;	/* dedup hash of sha256 */
 };
 
 struct async_cow {
@@ -302,22 +313,40 @@ static noinline int add_async_extent(struct async_cow *cow,
 				     u64 compressed_size,
 				     struct page **pages,
 				     unsigned long nr_pages,
-				     int compress_type)
+				     int compress_type, u64 *dedup_hash)
 {
 	struct async_extent *async_extent;
 
 	async_extent = kmalloc(sizeof(*async_extent), GFP_NOFS);
-	BUG_ON(!async_extent); /* -ENOMEM */
+	if (!async_extent)
+		return -ENOMEM;
 	async_extent->start = start;
 	async_extent->ram_size = ram_size;
 	async_extent->compressed_size = compressed_size;
 	async_extent->pages = pages;
 	async_extent->nr_pages = nr_pages;
 	async_extent->compress_type = compress_type;
+	async_extent->hash = NULL;
+	if (dedup_hash) {
+		async_extent->hash = kmalloc(sizeof(u64) * BTRFS_DEDUP_HASH_LEN,
+					     GFP_NOFS);
+		if (!async_extent->hash) {
+			kfree(async_extent);
+			return -ENOMEM;
+		}
+		memcpy(async_extent->hash, dedup_hash, BTRFS_DEDUP_HASH_SIZE);
+	}
+
 	list_add_tail(&async_extent->list, &cow->extents);
 	return 0;
 }
 
+static noinline void free_async_extent(struct async_extent *p)
+{
+	kfree(p->hash);
+	kfree(p);
+}
+
 /*
  * we create compressed extents in two phases.  The first
  * phase compresses a range of pages that have already been
@@ -339,10 +368,10 @@ static noinline int compress_file_range(struct inode *inode,
 					struct page *locked_page,
 					u64 start, u64 end,
 					struct async_cow *async_cow,
-					int *num_added)
+					int *num_added, u64 *dedup_hash)
 {
 	struct btrfs_root *root = BTRFS_I(inode)->root;
-	struct btrfs_trans_handle *trans;
+	struct btrfs_trans_handle *trans = NULL;
 	u64 num_bytes;
 	u64 blocksize = root->sectorsize;
 	u64 actual_end;
@@ -408,9 +437,7 @@ again:
 	 * change at any time if we discover bad compression ratios.
 	 */
 	if (!(BTRFS_I(inode)->flags & BTRFS_INODE_NOCOMPRESS) &&
-	    (btrfs_test_opt(root, COMPRESS) ||
-	     (BTRFS_I(inode)->force_compress) ||
-	     (BTRFS_I(inode)->flags & BTRFS_INODE_COMPRESS))) {
+	    btrfs_inode_test_compress(inode)) {
 		WARN_ON(pages);
 		pages = kzalloc(sizeof(struct page *) * nr_pages, GFP_NOFS);
 		if (!pages) {
@@ -547,9 +574,11 @@ cont:
 		 * allocation on disk for these compressed pages,
 		 * and will submit them to the elevator.
 		 */
-		add_async_extent(async_cow, start, num_bytes,
-				 total_compressed, pages, nr_pages_ret,
-				 compress_type);
+		ret = add_async_extent(async_cow, start, num_bytes,
+				       total_compressed, pages, nr_pages_ret,
+				       compress_type, dedup_hash);
+		if (ret)
+			goto cleanup_and_out;
 
 		if (start + num_bytes < end) {
 			start += num_bytes;
@@ -573,8 +602,11 @@ cleanup_and_bail_uncompressed:
 		}
 		if (redirty)
 			extent_range_redirty_for_io(inode, start, end);
-		add_async_extent(async_cow, start, end - start + 1,
-				 0, NULL, 0, BTRFS_COMPRESS_NONE);
+		ret = add_async_extent(async_cow, start, end - start + 1,
+				 0, NULL, 0, BTRFS_COMPRESS_NONE, dedup_hash);
+		if (ret)
+			goto cleanup_and_out;
+
 		*num_added += 1;
 	}
 
@@ -638,38 +670,15 @@ again:
 retry:
 		/* did the compression code fall back to uncompressed IO? */
 		if (!async_extent->pages) {
-			int page_started = 0;
-			unsigned long nr_written = 0;
-
-			lock_extent(io_tree, async_extent->start,
-					 async_extent->start +
-					 async_extent->ram_size - 1);
-
-			/* allocate blocks */
-			ret = cow_file_range(inode, async_cow->locked_page,
-					     async_extent->start,
-					     async_extent->start +
-					     async_extent->ram_size - 1,
-					     &page_started, &nr_written, 0);
-
-			/* JDM XXX */
+			ret = run_locked_range(io_tree, inode,
+						async_cow->locked_page,
+						async_extent->start,
+						async_extent->start +
+						async_extent->ram_size - 1,
+						btrfs_get_extent, WB_SYNC_ALL,
+						async_extent->hash);
 
-			/*
-			 * if page_started, cow_file_range inserted an
-			 * inline extent and took care of all the unlocking
-			 * and IO for us.  Otherwise, we need to submit
-			 * all those pages down to the drive.
-			 */
-			if (!page_started && !ret)
-				extent_write_locked_range(io_tree,
-						  inode, async_extent->start,
-						  async_extent->start +
-						  async_extent->ram_size - 1,
-						  btrfs_get_extent,
-						  WB_SYNC_ALL);
-			else if (ret)
-				unlock_page(async_cow->locked_page);
-			kfree(async_extent);
+			free_async_extent(async_extent);
 			cond_resched();
 			continue;
 		}
@@ -762,7 +771,8 @@ retry:
 						async_extent->ram_size,
 						ins.offset,
 						BTRFS_ORDERED_COMPRESSED,
-						async_extent->compress_type);
+						async_extent->compress_type,
+						async_extent->hash);
 		if (ret)
 			goto out_free_reserve;
 
@@ -786,7 +796,7 @@ retry:
 				    ins.offset, async_extent->pages,
 				    async_extent->nr_pages);
 		alloc_hint = ins.objectid + ins.offset;
-		kfree(async_extent);
+		free_async_extent(async_extent);
 		if (ret)
 			goto out;
 		cond_resched();
@@ -807,10 +817,351 @@ out_free:
 				     EXTENT_CLEAR_DIRTY |
 				     EXTENT_SET_WRITEBACK |
 				     EXTENT_END_WRITEBACK);
-	kfree(async_extent);
+	free_async_extent(async_extent);
 	goto again;
 }
 
+static int btrfs_dedup_hash_digest(struct btrfs_root *root, const char *data,
+				   u64 length, u64 *hash)
+{
+	struct crypto_shash *tfm = root->fs_info->dedup_driver;
+	struct {
+		struct shash_desc desc;
+		char ctx[crypto_shash_descsize(tfm)];
+	} sdesc;
+
+	sdesc.desc.tfm = tfm;
+	sdesc.desc.flags = 0;
+
+	return crypto_shash_digest(&sdesc.desc, data, length, (char *)hash);
+}
+
+static int btrfs_calc_dedup_hash(struct btrfs_root *root, struct inode *inode,
+				 u64 start, u64 *hash)
+{
+	struct page *p;
+	char *data;
+	u64 length = root->fs_info->dedup_bs;
+	u64 blocksize = root->sectorsize;
+	int err;
+
+	if (length == blocksize) {
+		p = find_get_page(inode->i_mapping,
+				  (start >> PAGE_CACHE_SHIFT));
+		BUG_ON(!p);	/* page should be here */
+		data = kmap_atomic(p);
+		err = btrfs_dedup_hash_digest(root, data, length, hash);
+		kunmap_atomic(data);
+		page_cache_release(p);
+	} else {
+		char *d;
+		int i = 0;
+
+		data = kmalloc(length, GFP_NOFS);
+		if (!data)
+			return -ENOMEM;
+
+		while (blocksize * i < length) {
+			p = find_get_page(inode->i_mapping,
+					  (start >> PAGE_CACHE_SHIFT) + i);
+			BUG_ON(!p);	/* page should be here */
+			d = kmap_atomic(p);
+			memcpy((data + blocksize * i), d, blocksize);
+			kunmap_atomic(d);
+			page_cache_release(p);
+			i++;
+		}
+
+		err = btrfs_dedup_hash_digest(root, data, length, hash);
+		kfree(data);
+	}
+	return err;
+}
+
+static noinline int
+run_delalloc_dedup(struct inode *inode, struct page *locked_page, u64 start,
+		   u64 end, struct async_cow *async_cow)
+{
+	struct btrfs_root *root = BTRFS_I(inode)->root;
+	struct btrfs_trans_handle *trans = NULL;
+	struct bio *bio = NULL;
+	struct extent_map_tree *em_tree = &BTRFS_I(inode)->extent_tree;
+	struct extent_io_tree *tree = &BTRFS_I(inode)->io_tree;
+	struct extent_map *em;
+	struct page *page = NULL;
+	struct block_device *bdev;
+	struct btrfs_key ins;
+	u64 blocksize = root->sectorsize;
+	u64 num_bytes;
+	u64 cur_alloc_size;
+	u64 cur_end;
+	u64 alloc_hint = 0;
+	u64 iosize;
+	u64 dedup_bs = root->fs_info->dedup_bs;
+	u64 dedup_bytenr;
+	u64 dedup_len;
+	u64 hash[4];
+	int compr;
+	int found;
+	int type = 0;
+	sector_t sector;
+	int ret = 0;
+	struct extent_state *cached_state = NULL;
+
+	BUG_ON(btrfs_is_free_space_inode(inode));
+
+	num_bytes = ALIGN(end - start + 1, blocksize);
+	num_bytes = max(blocksize,  num_bytes);
+
+	trans = btrfs_join_transaction(root);
+	if (IS_ERR(trans)) {
+		ret = PTR_ERR(trans);
+		goto out;
+	}
+
+	btrfs_drop_extent_cache(inode, start, start + num_bytes - 1, 0);
+
+	while (num_bytes > 0) {
+		unsigned long op = 0;
+
+		/* page has been locked by caller */
+		page = find_get_page(inode->i_mapping,
+				     start >> PAGE_CACHE_SHIFT);
+		BUG_ON(!page);	/* page should be here */
+
+		/* already ordered */
+		if (PagePrivate2(page))
+			goto submit;
+
+		/* too small data, go for normal path */
+		if (num_bytes < dedup_bs) {
+			cur_end = start + num_bytes - 1;
+
+			if (btrfs_inode_test_compress(inode)) {
+				int num_added = 0;
+				compress_file_range(inode, page, start, cur_end,
+						    async_cow, &num_added,
+						    NULL);
+			} else {
+				/* Now locked_page is not dirty. */
+				if (page_offset(locked_page) >= start &&
+				    page_offset(locked_page) <= cur_end) {
+					__set_page_dirty_nobuffers(locked_page);
+				}
+
+				ret = run_locked_range(tree, inode, page, start,
+						       cur_end,
+						       btrfs_get_extent,
+						       WB_SYNC_ALL, NULL);
+				if (ret)
+					SetPageError(page);
+			}
+
+			page_cache_release(page);
+			page = NULL;
+
+			num_bytes -= num_bytes;
+			start += num_bytes;
+			cond_resched();
+			continue;
+		}
+
+		cur_alloc_size = min_t(u64, num_bytes, dedup_bs);
+		BUG_ON(cur_alloc_size < dedup_bs);	/* shouldn't happen */
+		cur_end = start + cur_alloc_size - 1;
+
+		/* see comments in compress_file_range */
+		extent_range_clear_dirty_for_io(inode, start, cur_end);
+
+		memset(hash, 0, sizeof(u64) * 4);
+		ret = btrfs_calc_dedup_hash(root, inode, start, hash);
+
+		compr = BTRFS_COMPRESS_NONE;
+		if (ret)
+			found = 0;
+		else
+			found = btrfs_find_dedup_extent(trans, root, hash,
+						&dedup_bytenr, &dedup_len,
+						&compr);
+
+		if (found == 0) {
+			/*
+			 * compress fastpath.
+			 * so we take the original data as dedup string instead
+			 * of compressed data since compression methods and data
+			 * from them vary a lot.
+			 */
+			if (btrfs_inode_test_compress(inode)) {
+				int num_added = 0;
+
+				extent_range_redirty_for_io(inode, start,
+							    cur_end);
+
+				compress_file_range(inode, page, start, cur_end,
+						    async_cow, &num_added,
+						    hash);
+
+				page_cache_release(page);
+				page = NULL;
+
+				num_bytes -= cur_alloc_size;
+				start += cur_alloc_size;
+				cond_resched();
+				continue;
+			}
+
+			/* no compress */
+			ret = btrfs_reserve_extent(trans, root, cur_alloc_size,
+					   cur_alloc_size, 0, alloc_hint,
+					   &ins, 1);
+			if (ret < 0) {
+				btrfs_abort_transaction(trans, root, ret);
+				goto out_unlock;
+			}
+		} else { /* found same hash */
+			ins.objectid = dedup_bytenr;
+			ins.offset = dedup_len;
+
+			set_extent_dedup(tree, start, cur_end, &cached_state,
+					 GFP_NOFS);
+		}
+
+		lock_extent(tree, start, cur_end);
+
+		em = alloc_extent_map();
+		if (!em) {
+			ret = -ENOMEM;
+			goto out_reserve;
+		}
+		em->start = start;
+		em->orig_start = em->start;
+		em->len = cur_alloc_size;
+		em->mod_start = em->start;
+		em->mod_len = em->len;
+
+		em->block_start = ins.objectid;
+		em->block_len = ins.offset;
+		em->orig_block_len = ins.offset;
+		em->bdev = root->fs_info->fs_devices->latest_bdev;
+		set_bit(EXTENT_FLAG_PINNED, &em->flags);
+		em->generation = -1;
+		if (compr > BTRFS_COMPRESS_NONE) {
+			em->compress_type = compr;
+			set_bit(EXTENT_FLAG_COMPRESSED, &em->flags);
+			type = BTRFS_ORDERED_COMPRESSED;
+		}
+
+		while (1) {
+			write_lock(&em_tree->lock);
+			ret = add_extent_mapping(em_tree, em, 1);
+			write_unlock(&em_tree->lock);
+			if (ret != -EEXIST) {
+				free_extent_map(em);
+				break;
+			}
+			btrfs_drop_extent_cache(inode, start, cur_end, 0);
+		}
+		if (ret)
+			goto out_reserve;
+
+		ret = btrfs_add_ordered_extent_dedup(inode, start, ins.objectid,
+						     cur_alloc_size, ins.offset,
+						     type, found, hash, compr);
+		if (ret)
+			goto out_reserve;
+
+		/*
+		 * Do set the Private2 bit so we know this page was properly
+		 * setup for writepage
+		 */
+		op |= EXTENT_CLEAR_UNLOCK | EXTENT_CLEAR_DELALLOC |
+		      EXTENT_SET_PRIVATE2 | EXTENT_CLEAR_DIRTY |
+		      EXTENT_SET_WRITEBACK;
+		extent_clear_unlock_delalloc(inode, tree, start, cur_end,
+					     NULL, op);
+
+submit:
+		iosize = blocksize;
+
+		found = test_range_bit(tree, start, start + iosize - 1,
+				       EXTENT_DEDUP, 0, cached_state);
+		if (found == 0) {
+			em = btrfs_get_extent(inode, page, 0, start, blocksize,
+					      1);
+			if (IS_ERR(em)) {
+				/* btrfs_get_extent will not return NULL */
+				ret = PTR_ERR(em);
+				goto out_reserve;
+			}
+
+			sector = (em->block_start + start - em->start) >> 9;
+			bdev = em->bdev;
+			free_extent_map(em);
+			em = NULL;
+
+			/* TODO: rw can be WRTIE_SYNC */
+			ret = submit_extent_page(WRITE, tree, page, sector,
+						 iosize, 0, bdev, &bio,
+						 0, /* max_nr is no used */
+						 end_bio_extent_writepage,
+						 0, 0, 0);
+			if (ret)
+				break;
+		} else {
+			clear_extent_dedup(tree, start, start + iosize - 1,
+					   &cached_state, GFP_NOFS);
+
+			end_extent_writepage(page, 0, start,
+					     start + iosize - 1);
+			/* we need to do this ourselves because we skip IO */
+			end_page_writeback(page);
+		}
+
+		unlock_page(page);
+		page_cache_release(page);
+		page = NULL;
+
+		num_bytes -= blocksize;
+		alloc_hint = ins.objectid + blocksize;
+		start += blocksize;
+		cond_resched();
+	}
+
+out_unlock:
+	if (bio) {
+		if (ret)
+			bio_put(bio);
+		else
+			ret = submit_one_bio(WRITE, bio, 0, 0);
+		bio = NULL;
+	}
+
+	if (ret && page)
+		SetPageError(page);
+	if (page) {
+		unlock_page(page);
+		page_cache_release(page);
+	}
+
+	btrfs_end_transaction(trans, root);
+out:
+	if (ret && num_bytes > 0)
+		extent_clear_unlock_delalloc(inode, tree,
+			     start, start + num_bytes - 1,
+			     NULL, EXTENT_CLEAR_UNLOCK_PAGE |
+			     EXTENT_CLEAR_UNLOCK | EXTENT_CLEAR_DELALLOC |
+			     EXTENT_CLEAR_DIRTY | EXTENT_SET_WRITEBACK |
+			     EXTENT_END_WRITEBACK | EXTENT_CLEAR_DEDUP);
+
+	free_extent_state(cached_state);
+	return ret;
+
+out_reserve:
+	if (found == 0)
+		btrfs_free_reserved_extent(root, ins.objectid, ins.offset);
+	goto out_unlock;
+}
+
 static u64 get_extent_allocation_hint(struct inode *inode, u64 start,
 				      u64 num_bytes)
 {
@@ -862,7 +1213,7 @@ static noinline int __cow_file_range(struct btrfs_trans_handle *trans,
 				     struct page *locked_page,
 				     u64 start, u64 end, int *page_started,
 				     unsigned long *nr_written,
-				     int unlock)
+				     int unlock, u64 *hash)
 {
 	u64 alloc_hint = 0;
 	u64 num_bytes;
@@ -964,8 +1315,16 @@ static noinline int __cow_file_range(struct btrfs_trans_handle *trans,
 			goto out_reserve;
 
 		cur_alloc_size = ins.offset;
-		ret = btrfs_add_ordered_extent(inode, start, ins.objectid,
-					       ram_size, cur_alloc_size, 0);
+		if (!hash)
+			ret = btrfs_add_ordered_extent(inode, start,
+						       ins.objectid, ram_size,
+						       cur_alloc_size, 0);
+		else
+			ret = btrfs_add_ordered_extent_dedup(inode, start,
+						       ins.objectid, ram_size,
+						       cur_alloc_size, 0, 0,
+						       hash,
+						       BTRFS_COMPRESS_NONE);
 		if (ret)
 			goto out_reserve;
 
@@ -1046,28 +1405,97 @@ static noinline int cow_file_range(struct inode *inode,
 	trans->block_rsv = &root->fs_info->delalloc_block_rsv;
 
 	ret = __cow_file_range(trans, inode, root, locked_page, start, end,
-			       page_started, nr_written, unlock);
+			       page_started, nr_written, unlock, NULL);
+
+	btrfs_end_transaction(trans, root);
+
+	return ret;
+}
+
+static noinline int cow_file_range_dedup(struct inode *inode,
+					 struct page *locked_page,
+					 u64 start, u64 end, int *page_started,
+					 unsigned long *nr_written,
+					 int unlock, u64 *hash)
+{
+	struct btrfs_trans_handle *trans;
+	struct btrfs_root *root = BTRFS_I(inode)->root;
+	int ret;
+
+	trans = btrfs_join_transaction(root);
+	if (IS_ERR(trans)) {
+		extent_clear_unlock_delalloc(inode,
+			     &BTRFS_I(inode)->io_tree,
+			     start, end, locked_page,
+			     EXTENT_CLEAR_UNLOCK_PAGE |
+			     EXTENT_CLEAR_UNLOCK |
+			     EXTENT_CLEAR_DELALLOC |
+			     EXTENT_CLEAR_DIRTY |
+			     EXTENT_SET_WRITEBACK |
+			     EXTENT_END_WRITEBACK);
+		return PTR_ERR(trans);
+	}
+	trans->block_rsv = &root->fs_info->delalloc_block_rsv;
+
+	ret = __cow_file_range(trans, inode, root, locked_page, start, end,
+			       page_started, nr_written, unlock, hash);
 
 	btrfs_end_transaction(trans, root);
 
 	return ret;
 }
 
+static int run_locked_range(struct extent_io_tree *tree, struct inode *inode,
+			    struct page *locked_page, u64 start, u64 end,
+			    get_extent_t *get_extent, int mode, u64 *hash)
+{
+	int page_started = 0;
+	unsigned long nr_written = 0;
+	int ret;
+
+	lock_extent(tree, start, end);
+
+	/* allocate blocks */
+	ret = cow_file_range_dedup(inode, locked_page, start, end,
+				   &page_started, &nr_written, 0, hash);
+
+	/* JDM XXX */
+
+	/*
+	 * if page_started, cow_file_range inserted an
+	 * inline extent and took care of all the unlocking
+	 * and IO for us.  Otherwise, we need to submit
+	 * all those pages down to the drive.
+	 */
+	if (!page_started && !ret)
+		extent_write_locked_range(tree, inode, start, end, get_extent,
+					  mode);
+	else if (ret)
+		unlock_page(locked_page);
+
+	return ret;
+}
+
 /*
  * work queue call back to started compression on a file and pages
  */
 static noinline void async_cow_start(struct btrfs_work *work)
 {
 	struct async_cow *async_cow;
-	int num_added = 0;
 	async_cow = container_of(work, struct async_cow, work);
 
-	compress_file_range(async_cow->inode, async_cow->locked_page,
-			    async_cow->start, async_cow->end, async_cow,
-			    &num_added);
-	if (num_added == 0) {
-		btrfs_add_delayed_iput(async_cow->inode);
-		async_cow->inode = NULL;
+	if (btrfs_test_opt(async_cow->root, DEDUP)) {
+		run_delalloc_dedup(async_cow->inode, async_cow->locked_page,
+				   async_cow->start, async_cow->end, async_cow);
+	} else {
+		int num_added = 0;
+		compress_file_range(async_cow->inode, async_cow->locked_page,
+				    async_cow->start, async_cow->end, async_cow,
+				    &num_added, NULL);
+		if (num_added == 0) {
+			btrfs_add_delayed_iput(async_cow->inode);
+			async_cow->inode = NULL;
+		}
 	}
 }
 
@@ -1370,7 +1798,8 @@ out_check:
 		if (cow_start != (u64)-1) {
 			ret = __cow_file_range(trans, inode, root, locked_page,
 					       cow_start, found_key.offset - 1,
-					       page_started, nr_written, 1);
+					       page_started, nr_written, 1,
+					       NULL);
 			if (ret) {
 				btrfs_abort_transaction(trans, root, ret);
 				goto error;
@@ -1445,8 +1874,8 @@ out_check:
 
 	if (cow_start != (u64)-1) {
 		ret = __cow_file_range(trans, inode, root, locked_page,
-				       cow_start, end,
-				       page_started, nr_written, 1);
+				       cow_start, end, page_started, nr_written,
+				       1, NULL);
 		if (ret) {
 			btrfs_abort_transaction(trans, root, ret);
 			goto error;
@@ -1473,6 +1902,19 @@ error:
 	return ret;
 }
 
+static int btrfs_inode_test_compress(struct inode *inode)
+{
+	struct btrfs_inode *bi = BTRFS_I(inode);
+	struct btrfs_root *root = BTRFS_I(inode)->root;
+
+	if (btrfs_test_opt(root, COMPRESS) ||
+	    bi->force_compress ||
+	    bi->flags & BTRFS_INODE_COMPRESS)
+		return 1;
+
+	return 0;
+}
+
 /*
  * extent_io.c call back to do delayed allocation processing
  */
@@ -1482,21 +1924,21 @@ static int run_delalloc_range(struct inode *inode, struct page *locked_page,
 {
 	int ret;
 	struct btrfs_root *root = BTRFS_I(inode)->root;
+	struct btrfs_inode *bi = BTRFS_I(inode);
 
-	if (BTRFS_I(inode)->flags & BTRFS_INODE_NODATACOW) {
+	if (bi->flags & BTRFS_INODE_NODATACOW) {
 		ret = run_delalloc_nocow(inode, locked_page, start, end,
 					 page_started, 1, nr_written);
-	} else if (BTRFS_I(inode)->flags & BTRFS_INODE_PREALLOC) {
+	} else if (bi->flags & BTRFS_INODE_PREALLOC) {
 		ret = run_delalloc_nocow(inode, locked_page, start, end,
 					 page_started, 0, nr_written);
-	} else if (!btrfs_test_opt(root, COMPRESS) &&
-		   !(BTRFS_I(inode)->force_compress) &&
-		   !(BTRFS_I(inode)->flags & BTRFS_INODE_COMPRESS)) {
+	} else if (!btrfs_inode_test_compress(inode) &&
+		   !btrfs_test_opt(root, DEDUP)) {
 		ret = cow_file_range(inode, locked_page, start, end,
 				      page_started, nr_written, 1);
 	} else {
 		set_bit(BTRFS_INODE_HAS_ASYNC_EXTENT,
-			&BTRFS_I(inode)->runtime_flags);
+			&bi->runtime_flags);
 		ret = cow_file_range_async(inode, locked_page, start, end,
 					   page_started, nr_written);
 	}
@@ -1917,12 +2359,13 @@ static int btrfs_writepage_start_hook(struct page *page, u64 start, u64 end)
 	return -EBUSY;
 }
 
-static int insert_reserved_file_extent(struct btrfs_trans_handle *trans,
-				       struct inode *inode, u64 file_pos,
-				       u64 disk_bytenr, u64 disk_num_bytes,
-				       u64 num_bytes, u64 ram_bytes,
-				       u8 compression, u8 encryption,
-				       u16 other_encoding, int extent_type)
+static int __insert_reserved_file_extent(struct btrfs_trans_handle *trans,
+					 struct inode *inode, u64 file_pos,
+					 u64 disk_bytenr, u64 disk_num_bytes,
+					 u64 num_bytes, u64 ram_bytes,
+					 u8 compression, u8 encryption,
+					 u16 other_encoding, int extent_type,
+					 int dedup, u64 *hash)
 {
 	struct btrfs_root *root = BTRFS_I(inode)->root;
 	struct btrfs_file_extent_item *fi;
@@ -1979,15 +2422,53 @@ static int insert_reserved_file_extent(struct btrfs_trans_handle *trans,
 	ins.objectid = disk_bytenr;
 	ins.offset = disk_num_bytes;
 	ins.type = BTRFS_EXTENT_ITEM_KEY;
-	ret = btrfs_alloc_reserved_file_extent(trans, root,
-					root->root_key.objectid,
-					btrfs_ino(inode), file_pos, &ins);
+
+	if (!dedup) {
+		ret = btrfs_alloc_reserved_file_extent(trans, root,
+						       root->root_key.objectid,
+						       btrfs_ino(inode),
+						       file_pos, &ins);
+
+		if (hash) {
+			ret = btrfs_insert_dedup_extent(trans, root, hash,
+							ins.objectid,
+							ins.offset,
+							compression);
+
+			ret = btrfs_inc_extent_ref(trans, root, ins.objectid,
+					   ins.offset, 0,
+					   BTRFS_DEDUP_TREE_OBJECTID,
+					   btrfs_ino(inode),
+					   hash[BTRFS_DEDUP_HASH_LEN - 1], 0);
+		}
+	} else {
+		ret = btrfs_inc_extent_ref(trans, root, ins.objectid,
+					   ins.offset, 0,
+					   root->root_key.objectid,
+					   btrfs_ino(inode),
+					   file_pos, /* file_pos - 0 */
+					   0);
+	}
 out:
 	btrfs_free_path(path);
 
 	return ret;
 }
 
+static int insert_reserved_file_extent(struct btrfs_trans_handle *trans,
+				       struct inode *inode, u64 file_pos,
+				       u64 disk_bytenr, u64 disk_num_bytes,
+				       u64 num_bytes, u64 ram_bytes,
+				       u8 compression, u8 encryption,
+				       u16 other_encoding, int extent_type)
+{
+	return __insert_reserved_file_extent(trans, inode, file_pos,
+					     disk_bytenr, disk_num_bytes,
+					     num_bytes, ram_bytes, compression,
+					     encryption, other_encoding,
+					     extent_type, 0, NULL);
+}
+
 /* snapshot-aware defrag */
 struct sa_defrag_extent_backref {
 	struct rb_node node;
@@ -2715,14 +3196,16 @@ static int btrfs_finish_ordered_io(struct btrfs_ordered_extent *ordered_extent)
 						ordered_extent->len);
 	} else {
 		BUG_ON(root == root->fs_info->tree_root);
-		ret = insert_reserved_file_extent(trans, inode,
+		ret = __insert_reserved_file_extent(trans, inode,
 						ordered_extent->file_offset,
 						ordered_extent->start,
 						ordered_extent->disk_len,
 						ordered_extent->len,
 						ordered_extent->len,
 						compress_type, 0, 0,
-						BTRFS_FILE_EXTENT_REG);
+						BTRFS_FILE_EXTENT_REG,
+						ordered_extent->dedup,
+						ordered_extent->hash);
 	}
 	unpin_extent_cache(&BTRFS_I(inode)->extent_tree,
 			   ordered_extent->file_offset, ordered_extent->len,
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 0e17a30..1a4752e 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -4097,6 +4097,97 @@ out_unlock:
 	return ret;
 }
 
+static long btrfs_register_dedup(struct btrfs_root *root)
+{
+	struct btrfs_fs_info *fs_info = root->fs_info;
+	struct btrfs_trans_handle *trans = NULL;
+	struct btrfs_root *dedup_root;
+	int ret = 0;
+
+	mutex_lock(&fs_info->dedup_ioctl_mutex);
+	if (fs_info->dedup_root) {
+		pr_info("dedup has already been enabled\n");
+		mutex_unlock(&fs_info->dedup_ioctl_mutex);
+		return 0;
+	}
+
+	trans = btrfs_start_transaction(root, 2);
+	if (IS_ERR(trans)) {
+		ret = PTR_ERR(trans);
+		pr_info("trans error %d\n", ret);
+		mutex_unlock(&fs_info->dedup_ioctl_mutex);
+		return ret;
+	}
+
+	dedup_root = btrfs_create_tree(trans, fs_info,
+				       BTRFS_DEDUP_TREE_OBJECTID);
+	if (IS_ERR(dedup_root))
+		ret = PTR_ERR(dedup_root);
+
+	if (ret)
+		btrfs_end_transaction(trans, root);
+	else
+		ret = btrfs_commit_transaction(trans, root);
+
+	if (!ret) {
+		pr_info("dedup enabled\n");
+		fs_info->dedup_root = dedup_root;
+		fs_info->dedup_root->block_rsv = &fs_info->global_block_rsv;
+		btrfs_set_fs_incompat(fs_info, DEDUP);
+	}
+
+	mutex_unlock(&fs_info->dedup_ioctl_mutex);
+	return ret;
+}
+
+static long btrfs_unregister_dedup(struct btrfs_root *root)
+{
+	struct btrfs_fs_info *fs_info = root->fs_info;
+	struct btrfs_root *dedup_root;
+	int ret;
+
+	mutex_lock(&fs_info->dedup_ioctl_mutex);
+	if (!fs_info->dedup_root) {
+		pr_info("dedup has been disabled\n");
+		mutex_unlock(&fs_info->dedup_ioctl_mutex);
+		return 0;
+	}
+
+	if (btrfs_test_opt(root, DEDUP)) {
+		pr_info("Cannot disable dedup until clearing dedup mount options!\n");
+		mutex_unlock(&fs_info->dedup_ioctl_mutex);
+		return -EBUSY;
+	}
+
+	dedup_root = fs_info->dedup_root;
+
+	ret = btrfs_drop_snapshot(dedup_root, NULL, 1, 0);
+
+	if (!ret) {
+		fs_info->dedup_root = NULL;
+		pr_info("dedup disabled\n");
+	}
+
+	mutex_unlock(&fs_info->dedup_ioctl_mutex);
+	BUG_ON(ret < 0 && ret != -EAGAIN && ret != -EROFS);
+	return ret;
+}
+
+static long btrfs_ioctl_dedup_ctl(struct btrfs_root *root, int cmd)
+{
+	if (!capable(CAP_SYS_ADMIN))
+		return -EPERM;
+
+	switch (cmd) {
+	case BTRFS_DEDUP_CTL_REG:
+		return btrfs_register_dedup(root);
+	case BTRFS_DEDUP_CTL_UNREG:
+		return btrfs_unregister_dedup(root);
+	}
+
+	return -EINVAL;
+}
+
 long btrfs_ioctl(struct file *file, unsigned int
 		cmd, unsigned long arg)
 {
@@ -4207,6 +4298,8 @@ long btrfs_ioctl(struct file *file, unsigned int
 		return btrfs_ioctl_get_fslabel(file, argp);
 	case BTRFS_IOC_SET_FSLABEL:
 		return btrfs_ioctl_set_fslabel(file, argp);
+	case BTRFS_IOC_DEDUP_CTL:
+		return btrfs_ioctl_dedup_ctl(root, arg);
 	}
 
 	return -ENOTTY;
diff --git a/fs/btrfs/ordered-data.c b/fs/btrfs/ordered-data.c
index 8136982..adc818b 100644
--- a/fs/btrfs/ordered-data.c
+++ b/fs/btrfs/ordered-data.c
@@ -183,7 +183,8 @@ static inline struct rb_node *tree_search(struct btrfs_ordered_inode_tree *tree,
  */
 static int __btrfs_add_ordered_extent(struct inode *inode, u64 file_offset,
 				      u64 start, u64 len, u64 disk_len,
-				      int type, int dio, int compress_type)
+				      int type, int dio, int compress_type,
+				      int dedup, u64 *hash)
 {
 	struct btrfs_root *root = BTRFS_I(inode)->root;
 	struct btrfs_ordered_inode_tree *tree;
@@ -199,10 +200,23 @@ static int __btrfs_add_ordered_extent(struct inode *inode, u64 file_offset,
 	entry->start = start;
 	entry->len = len;
 	if (!(BTRFS_I(inode)->flags & BTRFS_INODE_NODATASUM) &&
-	    !(type == BTRFS_ORDERED_NOCOW))
+	    !(type == BTRFS_ORDERED_NOCOW) && !dedup)
 		entry->csum_bytes_left = disk_len;
 	entry->disk_len = disk_len;
 	entry->bytes_left = len;
+	entry->dedup = dedup;
+	entry->hash = NULL;
+
+	if (!dedup && hash) {
+		entry->hash = kmalloc(sizeof(u64) * BTRFS_DEDUP_HASH_LEN,
+				      GFP_NOFS);
+		if (!entry->hash) {
+			kmem_cache_free(btrfs_ordered_extent_cache, entry);
+			return -ENOMEM;
+		}
+		memcpy(entry->hash, hash, BTRFS_DEDUP_HASH_SIZE);
+	}
+
 	entry->inode = igrab(inode);
 	entry->compress_type = compress_type;
 	if (type != BTRFS_ORDERED_IO_DONE && type != BTRFS_ORDERED_COMPLETE)
@@ -250,7 +264,16 @@ int btrfs_add_ordered_extent(struct inode *inode, u64 file_offset,
 {
 	return __btrfs_add_ordered_extent(inode, file_offset, start, len,
 					  disk_len, type, 0,
-					  BTRFS_COMPRESS_NONE);
+					  BTRFS_COMPRESS_NONE, 0, NULL);
+}
+
+int btrfs_add_ordered_extent_dedup(struct inode *inode, u64 file_offset,
+			     u64 start, u64 len, u64 disk_len, int type,
+			     int dedup, u64 *hash, int compress_type)
+{
+	return __btrfs_add_ordered_extent(inode, file_offset, start, len,
+					  disk_len, type, 0,
+					  compress_type, dedup, hash);
 }
 
 int btrfs_add_ordered_extent_dio(struct inode *inode, u64 file_offset,
@@ -258,16 +281,16 @@ int btrfs_add_ordered_extent_dio(struct inode *inode, u64 file_offset,
 {
 	return __btrfs_add_ordered_extent(inode, file_offset, start, len,
 					  disk_len, type, 1,
-					  BTRFS_COMPRESS_NONE);
+					  BTRFS_COMPRESS_NONE, 0, NULL);
 }
 
 int btrfs_add_ordered_extent_compress(struct inode *inode, u64 file_offset,
 				      u64 start, u64 len, u64 disk_len,
-				      int type, int compress_type)
+				      int type, int compress_type, u64 *hash)
 {
 	return __btrfs_add_ordered_extent(inode, file_offset, start, len,
 					  disk_len, type, 0,
-					  compress_type);
+					  compress_type, 0, hash);
 }
 
 /*
@@ -503,6 +526,7 @@ void btrfs_put_ordered_extent(struct btrfs_ordered_extent *entry)
 			list_del(&sum->list);
 			kfree(sum);
 		}
+		kfree(entry->hash);
 		kmem_cache_free(btrfs_ordered_extent_cache, entry);
 	}
 }
diff --git a/fs/btrfs/ordered-data.h b/fs/btrfs/ordered-data.h
index 68844d5..4969bb8 100644
--- a/fs/btrfs/ordered-data.h
+++ b/fs/btrfs/ordered-data.h
@@ -102,6 +102,9 @@ struct btrfs_ordered_extent {
 	/* compression algorithm */
 	int compress_type;
 
+	/* if this is for dedup or not */
+	int dedup;
+
 	/* reference count */
 	atomic_t refs;
 
@@ -128,6 +131,9 @@ struct btrfs_ordered_extent {
 	struct completion completion;
 	struct btrfs_work flush_work;
 	struct list_head work_list;
+
+	/* dedup hash of sha256 type */
+	u64 *hash;
 };
 
 /*
@@ -161,11 +167,14 @@ int btrfs_dec_test_first_ordered_pending(struct inode *inode,
 				   int uptodate);
 int btrfs_add_ordered_extent(struct inode *inode, u64 file_offset,
 			     u64 start, u64 len, u64 disk_len, int type);
+int btrfs_add_ordered_extent_dedup(struct inode *inode, u64 file_offset,
+				   u64 start, u64 len, u64 disk_len, int type,
+				   int dedup, u64 *hash, int compress_type);
 int btrfs_add_ordered_extent_dio(struct inode *inode, u64 file_offset,
 				 u64 start, u64 len, u64 disk_len, int type);
 int btrfs_add_ordered_extent_compress(struct inode *inode, u64 file_offset,
 				      u64 start, u64 len, u64 disk_len,
-				      int type, int compress_type);
+				      int type, int compress_type, u64 *hash);
 void btrfs_add_ordered_sum(struct inode *inode,
 			   struct btrfs_ordered_extent *entry,
 			   struct btrfs_ordered_sum *sum);
diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index 1209649..5d44887 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -3471,6 +3471,9 @@ static int find_data_references(struct reloc_control *rc,
 	ref_offset = btrfs_extent_data_ref_offset(leaf, ref);
 	ref_count = btrfs_extent_data_ref_count(leaf, ref);
 
+	if (ref_root == BTRFS_DEDUP_TREE_OBJECTID)
+		return 0;
+
 	/*
 	 * This is an extent belonging to the free space cache, lets just delete
 	 * it and redo the search.
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 8eb6191..ef3140c 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -320,7 +320,8 @@ enum {
 	Opt_enospc_debug, Opt_subvolrootid, Opt_defrag, Opt_inode_cache,
 	Opt_no_space_cache, Opt_recovery, Opt_skip_balance,
 	Opt_check_integrity, Opt_check_integrity_including_extent_data,
-	Opt_check_integrity_print_mask, Opt_fatal_errors,
+	Opt_check_integrity_print_mask, Opt_fatal_errors, Opt_dedup,
+	Opt_dedup_bs,
 	Opt_err,
 };
 
@@ -361,6 +362,8 @@ static match_table_t tokens = {
 	{Opt_check_integrity_including_extent_data, "check_int_data"},
 	{Opt_check_integrity_print_mask, "check_int_print_mask=%d"},
 	{Opt_fatal_errors, "fatal_errors=%s"},
+	{Opt_dedup_bs, "dedup_bs=%s"},
+	{Opt_dedup, "dedup"},
 	{Opt_err, NULL},
 };
 
@@ -626,6 +629,25 @@ int btrfs_parse_options(struct btrfs_root *root, char *options)
 				goto out;
 			}
 			break;
+		case Opt_dedup_bs:
+			num = match_strdup(&args[0]);
+			if (num) {
+				info->dedup_bs = memparse(num, NULL);
+				kfree(num);
+
+				if (info->dedup_bs) {
+					info->dedup_bs = ALIGN(info->dedup_bs,
+							      root->sectorsize);
+					info->dedup_bs = min_t(u64,
+							       info->dedup_bs,
+							       (128 * 1024ULL));
+				}
+			}
+		case Opt_dedup:
+			pr_info("btrfs: use deduplication(dedup blocksize %llu)\n",
+				(unsigned long long)info->dedup_bs);
+			btrfs_set_opt(info->mount_opt, DEDUP);
+			break;
 		case Opt_err:
 			printk(KERN_INFO "btrfs: unrecognized mount option "
 			       "'%s'\n", p);
@@ -942,6 +964,9 @@ static int btrfs_show_options(struct seq_file *seq, struct dentry *dentry)
 		seq_puts(seq, ",skip_balance");
 	if (btrfs_test_opt(root, PANIC_ON_FATAL_ERROR))
 		seq_puts(seq, ",fatal_errors=panic");
+	if (btrfs_test_opt(root, DEDUP))
+		seq_printf(seq, ",dedup_bs=%llu",
+			   (unsigned long long)info->dedup_bs);
 	return 0;
 }
 
diff --git a/include/uapi/linux/btrfs.h b/include/uapi/linux/btrfs.h
index 05aed70..5408e60 100644
--- a/include/uapi/linux/btrfs.h
+++ b/include/uapi/linux/btrfs.h
@@ -374,6 +374,10 @@ struct btrfs_ioctl_get_dev_stats {
 	__u64 unused[128 - 2 - BTRFS_DEV_STAT_VALUES_MAX]; /* pad to 1k */
 };
 
+/* deduplication control ioctl modes */
+#define BTRFS_DEDUP_CTL_REG 1
+#define BTRFS_DEDUP_CTL_UNREG 2
+
 #define BTRFS_QUOTA_CTL_ENABLE	1
 #define BTRFS_QUOTA_CTL_DISABLE	2
 #define BTRFS_QUOTA_CTL_RESCAN__NOTUSED	3
@@ -579,4 +583,5 @@ static inline char *btrfs_err_str(enum btrfs_err_code err_code)
 				      struct btrfs_ioctl_get_dev_stats)
 #define BTRFS_IOC_DEV_REPLACE _IOWR(BTRFS_IOCTL_MAGIC, 53, \
 				    struct btrfs_ioctl_dev_replace_args)
+#define BTRFS_IOC_DEDUP_CTL _IOW(BTRFS_IOCTL_MAGIC, 55, int)
 #endif /* _UAPI_LINUX_BTRFS_H */
-- 
1.7.7

