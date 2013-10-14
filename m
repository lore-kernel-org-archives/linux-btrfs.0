Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:24413 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750854Ab3JNFBQ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 14 Oct 2013 01:01:16 -0400
Received: from acsinet22.oracle.com (acsinet22.oracle.com [141.146.126.238])
	by aserp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with ESMTP id r9E51F8j006547
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Mon, 14 Oct 2013 05:01:15 GMT
Received: from userz7022.oracle.com (userz7022.oracle.com [156.151.31.86])
	by acsinet22.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r9E51E2n016499
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Mon, 14 Oct 2013 05:01:14 GMT
Received: from abhmt102.oracle.com (abhmt102.oracle.com [141.146.116.54])
	by userz7022.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r9E51DHV007070
	for <linux-btrfs@vger.kernel.org>; Mon, 14 Oct 2013 05:01:13 GMT
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v7 09/13] Btrfs: online(inband) data dedup
Date: Mon, 14 Oct 2013 12:59:51 +0800
Message-Id: <1381726796-27191-10-git-send-email-bo.li.liu@oracle.com>
In-Reply-To: <1381726796-27191-1-git-send-email-bo.li.liu@oracle.com>
References: <1381726796-27191-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The main part of data dedup.

This introduces a FORMAT CHANGE.

Btrfs provides online(inband/synchronous) and block-level dedup.

It maps naturally to btrfs's block back-reference, which enables us
to store multiple copies of data as single copy with references
on that copy.

The workflow is
(1) write some data,
(2) get the hash of these data based on btrfs's dedup blocksize.
(3) find matched extents by hash and decide whether to mark it
    as a duplicate one or not.  If no, write the data onto disk,
    otherwise, add a reference to the matched extent.

Btrfs's built-in dedup supports normal writes and compressed writes.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/extent-tree.c |  150 ++++++++++--
 fs/btrfs/extent_io.c   |    8 +-
 fs/btrfs/extent_io.h   |   10 +
 fs/btrfs/inode.c       |  640 ++++++++++++++++++++++++++++++++++++++++++------
 4 files changed, 711 insertions(+), 97 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index ee97f3a..812f512 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -1122,8 +1122,16 @@ static noinline int lookup_extent_data_ref(struct btrfs_trans_handle *trans,
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
+			key.offset = (u64)-1;
+		else
+			key.offset = hash_extent_data_ref(root_objectid,
+							  owner, offset);
 	}
 again:
 	recow = 0;
@@ -1150,6 +1158,10 @@ again:
 		goto fail;
 	}
 
+	if (ret > 0 && root_objectid == BTRFS_DEDUP_TREE_OBJECTID &&
+	    path->slots[0] > 0)
+		path->slots[0]--;
+
 	leaf = path->nodes[0];
 	nritems = btrfs_header_nritems(leaf);
 	while (1) {
@@ -1173,14 +1185,22 @@ again:
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
@@ -1324,6 +1344,32 @@ static noinline int remove_extent_data_ref(struct btrfs_trans_handle *trans,
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
+		WARN_ON(btrfs_extent_inline_ref_type(leaf, iref) !=
+			BTRFS_EXTENT_DATA_REF_KEY);
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
@@ -1591,7 +1637,8 @@ again:
 	err = -ENOENT;
 	while (1) {
 		if (ptr >= end) {
-			WARN_ON(ptr > end);
+			WARN_ON(ptr > end &&
+				root_objectid != BTRFS_DEDUP_TREE_OBJECTID);
 			break;
 		}
 		iref = (struct btrfs_extent_inline_ref *)ptr;
@@ -1606,14 +1653,25 @@ again:
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
@@ -5631,11 +5689,13 @@ static int __btrfs_free_extent(struct btrfs_trans_handle *trans,
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
 
@@ -5643,6 +5703,13 @@ static int __btrfs_free_extent(struct btrfs_trans_handle *trans,
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
 
@@ -5684,6 +5751,12 @@ static int __btrfs_free_extent(struct btrfs_trans_handle *trans,
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
@@ -5741,6 +5814,10 @@ static int __btrfs_free_extent(struct btrfs_trans_handle *trans,
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
@@ -5834,7 +5911,28 @@ static int __btrfs_free_extent(struct btrfs_trans_handle *trans,
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
+		if (is_data && refs == 1 &&
+		    orig_root_obj != BTRFS_ROOT_TREE_OBJECTID) {
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
@@ -5861,6 +5959,18 @@ static int __btrfs_free_extent(struct btrfs_trans_handle *trans,
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
index f566d0c..13a7908 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -2356,7 +2356,7 @@ int end_extent_writepage(struct page *page, int err, u64 start, u64 end)
  * Scheduling is not allowed, so the extent state tree is expected
  * to have one and only one object corresponding to this IO.
  */
-static void end_bio_extent_writepage(struct bio *bio, int err)
+void end_bio_extent_writepage(struct bio *bio, int err)
 {
 	struct bio_vec *bvec = bio->bi_io_vec + bio->bi_vcnt - 1;
 	struct extent_io_tree *tree;
@@ -2607,8 +2607,8 @@ struct bio *btrfs_io_bio_alloc(gfp_t gfp_mask, unsigned int nr_iovecs)
 }
 
 
-static int __must_check submit_one_bio(int rw, struct bio *bio,
-				       int mirror_num, unsigned long bio_flags)
+int __must_check submit_one_bio(int rw, struct bio *bio, int mirror_num,
+				unsigned long bio_flags)
 {
 	int ret = 0;
 	struct bio_vec *bvec = bio->bi_io_vec + bio->bi_vcnt - 1;
@@ -2647,7 +2647,7 @@ static int merge_bio(int rw, struct extent_io_tree *tree, struct page *page,
 
 }
 
-static int submit_extent_page(int rw, struct extent_io_tree *tree,
+int submit_extent_page(int rw, struct extent_io_tree *tree,
 			      struct page *page, sector_t sector,
 			      size_t size, unsigned long offset,
 			      struct block_device *bdev,
diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
index 979aadb..f2b87f2 100644
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -350,4 +350,14 @@ int repair_io_failure(struct btrfs_fs_info *fs_info, u64 start,
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
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 22ebc13..00fd6e9 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -43,6 +43,7 @@
 #include <linux/btrfs.h>
 #include <linux/blkdev.h>
 #include <linux/posix_acl_xattr.h>
+#include <asm/unaligned.h>
 #include "compat.h"
 #include "ctree.h"
 #include "disk-io.h"
@@ -105,6 +106,17 @@ static struct extent_map *create_pinned_em(struct inode *inode, u64 start,
 					   u64 block_start, u64 block_len,
 					   u64 orig_block_len, u64 ram_bytes,
 					   int type);
+static noinline int cow_file_range_dedup(struct inode *inode,
+					 struct page *locked_page,
+					 u64 start, u64 end, int *page_started,
+					 unsigned long *nr_written, int unlock,
+					 struct btrfs_dedup_hash *hash);
+static int run_locked_range(struct extent_io_tree *tree, struct inode *inode,
+			    struct page *locked_page, u64 start, u64 end,
+			    get_extent_t *get_extent, int mode,
+			    struct btrfs_dedup_hash *hash);
+static int btrfs_inode_test_compress(struct inode *inode);
+
 
 static int btrfs_dirty_inode(struct inode *inode);
 
@@ -297,6 +309,7 @@ struct async_extent {
 	unsigned long nr_pages;
 	int compress_type;
 	struct list_head list;
+	struct btrfs_dedup_hash *hash;	/* dedup hash of sha256 */
 };
 
 struct async_cow {
@@ -314,22 +327,41 @@ static noinline int add_async_extent(struct async_cow *cow,
 				     u64 compressed_size,
 				     struct page **pages,
 				     unsigned long nr_pages,
-				     int compress_type)
+				     int compress_type,
+				     struct btrfs_dedup_hash *h)
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
+	if (h) {
+		async_extent->hash = kmalloc(btrfs_dedup_hash_size(h->type),
+					     GFP_NOFS);
+		if (!async_extent->hash) {
+			kfree(async_extent);
+			return -ENOMEM;
+		}
+		memcpy(async_extent->hash, h, btrfs_dedup_hash_size(h->type));
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
@@ -351,7 +383,8 @@ static noinline int compress_file_range(struct inode *inode,
 					struct page *locked_page,
 					u64 start, u64 end,
 					struct async_cow *async_cow,
-					int *num_added)
+					int *num_added,
+					struct btrfs_dedup_hash *dedup_hash)
 {
 	struct btrfs_root *root = BTRFS_I(inode)->root;
 	u64 num_bytes;
@@ -419,9 +452,7 @@ again:
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
@@ -549,9 +580,11 @@ cont:
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
+			goto free_pages_out;
 
 		if (start + num_bytes < end) {
 			start += num_bytes;
@@ -575,8 +608,11 @@ cleanup_and_bail_uncompressed:
 		}
 		if (redirty)
 			extent_range_redirty_for_io(inode, start, end);
-		add_async_extent(async_cow, start, end - start + 1,
-				 0, NULL, 0, BTRFS_COMPRESS_NONE);
+		ret = add_async_extent(async_cow, start, end - start + 1,
+				 0, NULL, 0, BTRFS_COMPRESS_NONE, dedup_hash);
+		if (ret)
+			goto free_pages_out;
+
 		*num_added += 1;
 	}
 
@@ -625,38 +661,15 @@ again:
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
@@ -739,7 +752,8 @@ retry:
 						async_extent->ram_size,
 						ins.offset,
 						BTRFS_ORDERED_COMPRESSED,
-						async_extent->compress_type);
+						async_extent->compress_type,
+						async_extent->hash);
 		if (ret)
 			goto out_free_reserve;
 
@@ -759,7 +773,7 @@ retry:
 				    ins.offset, async_extent->pages,
 				    async_extent->nr_pages);
 		alloc_hint = ins.objectid + ins.offset;
-		kfree(async_extent);
+		free_async_extent(async_extent);
 		if (ret)
 			goto out;
 		cond_resched();
@@ -777,10 +791,366 @@ out_free:
 				     EXTENT_DEFRAG | EXTENT_DO_ACCOUNTING,
 				     PAGE_UNLOCK | PAGE_CLEAR_DIRTY |
 				     PAGE_SET_WRITEBACK | PAGE_END_WRITEBACK);
-	kfree(async_extent);
+	free_async_extent(async_extent);
 	goto again;
 }
 
+static void btrfs_dedup_hash_final(struct btrfs_dedup_hash *hash);
+
+static int btrfs_dedup_hash_digest(struct btrfs_root *root, const char *data,
+				   u64 length, struct btrfs_dedup_hash *hash)
+{
+	struct crypto_shash *tfm = root->fs_info->dedup_driver;
+	struct {
+		struct shash_desc desc;
+		char ctx[crypto_shash_descsize(tfm)];
+	} sdesc;
+	int ret;
+
+	sdesc.desc.tfm = tfm;
+	sdesc.desc.flags = 0;
+
+	ret = crypto_shash_digest(&sdesc.desc, data, length,
+				  (char *)(hash->hash));
+	if (!ret)
+		btrfs_dedup_hash_final(hash);
+	return ret;
+}
+
+static void btrfs_dedup_hash_final(struct btrfs_dedup_hash *hash)
+{
+	int num, i;
+
+	num = btrfs_dedup_lens[hash->type] - 1;
+	for (i = 0; i < num; i++)
+		put_unaligned_le64(hash->hash[i], (char *)(hash->hash + i));
+}
+
+static int btrfs_calc_dedup_hash(struct btrfs_root *root, struct inode *inode,
+				 u64 start, struct btrfs_dedup_hash *hash)
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
+		WARN_ON(!p);	/* page should be here */
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
+			WARN_ON(!p);	/* page should be here */
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
+	int compr;
+	int found;
+	int type = 0;
+	sector_t sector;
+	int ret = 0;
+	struct extent_state *cached_state = NULL;
+	struct btrfs_dedup_hash *hash;
+	int dedup_type = root->fs_info->dedup_type;
+
+	WARN_ON(btrfs_is_free_space_inode(inode));
+
+	num_bytes = ALIGN(end - start + 1, blocksize);
+	num_bytes = max(blocksize, num_bytes);
+
+	hash = kzalloc(btrfs_dedup_hash_size(dedup_type), GFP_NOFS);
+	if (!hash) {
+		ret = -ENOMEM;
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
+		WARN_ON(!page);	/* page should be here */
+
+		/* already ordered? */
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
+		WARN_ON(cur_alloc_size < dedup_bs);	/* shouldn't happen */
+		cur_end = start + cur_alloc_size - 1;
+
+		/* see comments in compress_file_range */
+		extent_range_clear_dirty_for_io(inode, start, cur_end);
+
+		memset(hash, 0, btrfs_dedup_hash_size(dedup_type));
+		hash->type = dedup_type;
+
+		ret = btrfs_calc_dedup_hash(root, inode, start, hash);
+
+		if (ret) {
+			found = 0;
+			compr = BTRFS_COMPRESS_NONE;
+		} else {
+			found = btrfs_find_dedup_extent(root, hash);
+			compr = hash->compression;
+		}
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
+			ret = btrfs_reserve_extent(root, cur_alloc_size,
+					   cur_alloc_size, 0, alloc_hint,
+					   &ins, 1);
+			if (ret < 0)
+				goto out_unlock;
+		} else { /* found same hash */
+			ins.objectid = hash->bytenr;
+			ins.offset = hash->num_bytes;
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
+		op |= PAGE_SET_PRIVATE2 | PAGE_SET_WRITEBACK | PAGE_CLEAR_DIRTY;
+		extent_clear_unlock_delalloc(inode, start, cur_end,
+					     NULL,
+					     EXTENT_LOCKED | EXTENT_DELALLOC,
+					     op);
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
+out:
+	if (ret && num_bytes > 0)
+		extent_clear_unlock_delalloc(inode,
+			     start, start + num_bytes - 1,
+			     NULL,
+			     EXTENT_DELALLOC | EXTENT_LOCKED |
+			     EXTENT_DEDUP | EXTENT_DEFRAG,
+			     PAGE_UNLOCK | PAGE_SET_WRITEBACK |
+			     PAGE_END_WRITEBACK | PAGE_CLEAR_DIRTY);
+
+	kfree(hash);
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
@@ -826,11 +1196,11 @@ static u64 get_extent_allocation_hint(struct inode *inode, u64 start,
  * required to start IO on it.  It may be clean and already done with
  * IO when we return.
  */
-static noinline int cow_file_range(struct inode *inode,
+static noinline int __cow_file_range(struct inode *inode,
 				   struct page *locked_page,
 				   u64 start, u64 end, int *page_started,
 				   unsigned long *nr_written,
-				   int unlock)
+				   int unlock, struct btrfs_dedup_hash *hash)
 {
 	struct btrfs_root *root = BTRFS_I(inode)->root;
 	u64 alloc_hint = 0;
@@ -926,8 +1296,16 @@ static noinline int cow_file_range(struct inode *inode,
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
 
@@ -975,21 +1353,76 @@ out_unlock:
 	goto out;
 }
 
+static noinline int cow_file_range(struct inode *inode,
+				   struct page *locked_page,
+				   u64 start, u64 end, int *page_started,
+				   unsigned long *nr_written,
+				   int unlock)
+{
+	return __cow_file_range(inode, locked_page, start, end, page_started,
+				nr_written, unlock, NULL);
+}
+
+static noinline int cow_file_range_dedup(struct inode *inode,
+				   struct page *locked_page,
+				   u64 start, u64 end, int *page_started,
+				   unsigned long *nr_written,
+				   int unlock, struct btrfs_dedup_hash *hash)
+{
+	return __cow_file_range(inode, locked_page, start, end, page_started,
+				nr_written, unlock, hash);
+}
+
+static int run_locked_range(struct extent_io_tree *tree, struct inode *inode,
+			    struct page *locked_page, u64 start, u64 end,
+			    get_extent_t *get_extent, int mode,
+			    struct btrfs_dedup_hash *hash)
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
+	if (async_cow->root->fs_info->dedup_bs != 0) {
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
 
@@ -1387,6 +1820,19 @@ error:
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
@@ -1396,21 +1842,21 @@ static int run_delalloc_range(struct inode *inode, struct page *locked_page,
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
+		   root->fs_info->dedup_bs == 0) {
 		ret = cow_file_range(inode, locked_page, start, end,
 				      page_started, nr_written, 1);
 	} else {
 		set_bit(BTRFS_INODE_HAS_ASYNC_EXTENT,
-			&BTRFS_I(inode)->runtime_flags);
+			&bi->runtime_flags);
 		ret = cow_file_range_async(inode, locked_page, start, end,
 					   page_started, nr_written);
 	}
@@ -1831,12 +2277,14 @@ static int btrfs_writepage_start_hook(struct page *page, u64 start, u64 end)
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
+					 int dedup,
+					 struct btrfs_dedup_hash *hash)
 {
 	struct btrfs_root *root = BTRFS_I(inode)->root;
 	struct btrfs_file_extent_item *fi;
@@ -1893,15 +2341,59 @@ static int insert_reserved_file_extent(struct btrfs_trans_handle *trans,
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
+		if (ret)
+			goto out;
+
+		if (hash) {
+			int index = btrfs_dedup_lens[hash->type] - 1;
+
+			hash->bytenr = ins.objectid;
+			hash->num_bytes = ins.offset;
+			hash->compression = compression;
+			ret = btrfs_insert_dedup_extent(trans, root, hash);
+			if (ret)
+				goto out;
+
+			ret = btrfs_inc_extent_ref(trans, root, ins.objectid,
+					   ins.offset, 0,
+					   BTRFS_DEDUP_TREE_OBJECTID,
+					   btrfs_ino(inode),
+					   hash->hash[index], 0);
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
@@ -2640,13 +3132,15 @@ static int btrfs_finish_ordered_io(struct btrfs_ordered_extent *ordered_extent)
 						logical_len);
 	} else {
 		BUG_ON(root == root->fs_info->tree_root);
-		ret = insert_reserved_file_extent(trans, inode,
+		ret = __insert_reserved_file_extent(trans, inode,
 						ordered_extent->file_offset,
 						ordered_extent->start,
 						ordered_extent->disk_len,
 						logical_len, logical_len,
 						compress_type, 0, 0,
-						BTRFS_FILE_EXTENT_REG);
+						BTRFS_FILE_EXTENT_REG,
+						ordered_extent->dedup,
+						ordered_extent->hash);
 	}
 	unpin_extent_cache(&BTRFS_I(inode)->extent_tree,
 			   ordered_extent->file_offset, ordered_extent->len,
-- 
1.7.7

