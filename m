Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ie0-f180.google.com ([209.85.223.180]:35446 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751120Ab3JaFAR (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 31 Oct 2013 01:00:17 -0400
Received: by mail-ie0-f180.google.com with SMTP id e14so3964257iej.39
        for <linux-btrfs@vger.kernel.org>; Wed, 30 Oct 2013 22:00:17 -0700 (PDT)
Received: from dshgna ([124.43.179.229])
        by mx.google.com with ESMTPSA id ka1sm1674917igb.7.2013.10.30.22.00.14
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1.2 cipher=RC4-SHA bits=128/128);
        Wed, 30 Oct 2013 22:00:16 -0700 (PDT)
Date: Thu, 31 Oct 2013 10:30:08 +0530
From: Dulshani Gunawardhana <dulshani.gunawardhana89@gmail.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 3/6] btrfs: Use WARN_ON()'s return value in place of
 WARN_ON(1)
Message-ID: <dd02f9e063557cbd68a048e32a496f728035de70.1383193392.git.dulshani.gunawardhana89@gmail.com>
References: <5b7cf598562052b708988056bfea67a9913ac660.1383193392.git.dulshani.gunawardhana89@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <5b7cf598562052b708988056bfea67a9913ac660.1383193392.git.dulshani.gunawardhana89@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Use WARN_ON()'s return value in place of WARN_ON(1) for cleaner source
code that outputs a more descriptive warnings. Also fix the styling
warning of redundant braces that came up as a result of this fix.

Signed-off-by: Dulshani Gunawardhana <dulshani.gunawardhana89@gmail.com>
Reviewed-by: Zach Brown <zab@redhat.com>
---
 fs/btrfs/backref.c         |  3 +--
 fs/btrfs/check-integrity.c |  7 ++-----
 fs/btrfs/ctree.c           |  6 ++----
 fs/btrfs/delayed-inode.c   |  3 +--
 fs/btrfs/disk-io.c         |  8 +-------
 fs/btrfs/extent-tree.c     | 11 ++++-------
 fs/btrfs/extent_io.c       |  7 ++-----
 fs/btrfs/file-item.c       |  4 +---
 fs/btrfs/inode-map.c       |  4 +---
 fs/btrfs/inode.c           | 10 +++-------
 fs/btrfs/relocation.c      | 16 +++++-----------
 fs/btrfs/send.c            |  4 +---
 fs/btrfs/tree-log.c        |  7 ++-----
 fs/btrfs/volumes.c         | 11 +++--------
 14 files changed, 29 insertions(+), 72 deletions(-)

diff --git a/fs/btrfs/backref.c b/fs/btrfs/backref.c
index 0552a59..408b7d1 100644
--- a/fs/btrfs/backref.c
+++ b/fs/btrfs/backref.c
@@ -323,8 +323,7 @@ static int __resolve_indirect_ref(struct btrfs_fs_info *fs_info,
 
 	eb = path->nodes[level];
 	while (!eb) {
-		if (!level) {
-			WARN_ON(1);
+		if (WARN_ON(!level)) {
 			ret = 1;
 			goto out;
 		}
diff --git a/fs/btrfs/check-integrity.c b/fs/btrfs/check-integrity.c
index 1c47be1..96d1557 100644
--- a/fs/btrfs/check-integrity.c
+++ b/fs/btrfs/check-integrity.c
@@ -2463,10 +2463,8 @@ static int btrfsic_process_written_superblock(
 		}
 	}
 
-	if (-1 == btrfsic_check_all_ref_blocks(state, superblock, 0)) {
-		WARN_ON(1);
+	if (WARN_ON(-1 == btrfsic_check_all_ref_blocks(state, superblock, 0)))
 		btrfsic_dump_tree(state);
-	}
 
 	return 0;
 }
@@ -2906,7 +2904,7 @@ static void btrfsic_cmp_log_and_dev_bytenr(struct btrfsic_state *state,
 		btrfsic_release_block_ctx(&block_ctx);
 	}
 
-	if (!match) {
+	if (WARN_ON(!match)) {
 		printk(KERN_INFO "btrfs: attempt to write M-block which contains logical bytenr that doesn't map to dev+physical bytenr of submit_bio,"
 		       " buffer->log_bytenr=%llu, submit_bio(bdev=%s,"
 		       " phys_bytenr=%llu)!\n",
@@ -2923,7 +2921,6 @@ static void btrfsic_cmp_log_and_dev_bytenr(struct btrfsic_state *state,
 			       bytenr, block_ctx.dev->name,
 			       block_ctx.dev_bytenr, mirror_num);
 		}
-		WARN_ON(1);
 	}
 }
 
diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index 61b5bcd..0039dde 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -1285,11 +1285,10 @@ get_old_root(struct btrfs_root *root, u64 time_seq)
 		free_extent_buffer(eb_root);
 		blocksize = btrfs_level_size(root, old_root->level);
 		old = read_tree_block(root, logical, blocksize, 0);
-		if (!old || !extent_buffer_uptodate(old)) {
+		if (WARN_ON(!old || !extent_buffer_uptodate(old))) {
 			free_extent_buffer(old);
 			pr_warn("btrfs: failed to read tree block %llu from get_old_root\n",
 				logical);
-			WARN_ON(1);
 		} else {
 			eb = btrfs_clone_extent_buffer(old);
 			free_extent_buffer(old);
@@ -3639,8 +3638,7 @@ static noinline int __push_leaf_left(struct btrfs_trans_handle *trans,
 		ret = 1;
 		goto out;
 	}
-	if (!empty && push_items == btrfs_header_nritems(right))
-		WARN_ON(1);
+	WARN_ON(!empty && push_items == btrfs_header_nritems(right));
 
 	/* push data from right to left */
 	copy_extent_buffer(left, right,
diff --git a/fs/btrfs/delayed-inode.c b/fs/btrfs/delayed-inode.c
index cbd9523..207e2d0 100644
--- a/fs/btrfs/delayed-inode.c
+++ b/fs/btrfs/delayed-inode.c
@@ -649,14 +649,13 @@ static int btrfs_delayed_inode_reserve_metadata(
 			goto out;
 
 		ret = btrfs_block_rsv_migrate(src_rsv, dst_rsv, num_bytes);
-		if (!ret)
+		if (!WARN_ON(ret))
 			goto out;
 
 		/*
 		 * Ok this is a problem, let's just steal from the global rsv
 		 * since this really shouldn't happen that often.
 		 */
-		WARN_ON(1);
 		ret = btrfs_block_rsv_migrate(&root->fs_info->global_block_rsv,
 					      dst_rsv, num_bytes);
 		goto out;
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 62176ad..1979122 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -477,14 +477,8 @@ static int csum_dirty_buffer(struct btrfs_root *root, struct page *page)
 	if (page != eb->pages[0])
 		return 0;
 	found_start = btrfs_header_bytenr(eb);
-	if (found_start != start) {
-		WARN_ON(1);
+	if (WARN_ON(found_start != start || !PageUptodate(page)))
 		return 0;
-	}
-	if (!PageUptodate(page)) {
-		WARN_ON(1);
-		return 0;
-	}
 	csum_tree_block(root, eb, 0);
 	return 0;
 }
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index d58bef1..c135f1c 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -1551,9 +1551,8 @@ again:
 	if (ret && !insert) {
 		err = -ENOENT;
 		goto out;
-	} else if (ret) {
+	} else if (WARN_ON(ret)) {
 		err = -EIO;
-		WARN_ON(1);
 		goto out;
 	}
 
@@ -5718,9 +5717,8 @@ static int __btrfs_free_extent(struct btrfs_trans_handle *trans,
 			}
 			extent_slot = path->slots[0];
 		}
-	} else if (ret == -ENOENT) {
+	} else if (WARN_ON(ret == -ENOENT)) {
 		btrfs_print_leaf(extent_root, path->nodes[0]);
-		WARN_ON(1);
 		btrfs_err(info,
 			"unable to find ref byte nr %llu parent %llu root %llu  owner %llu offset %llu",
 			bytenr, parent, root_objectid, owner_objectid,
@@ -8276,10 +8274,9 @@ int btrfs_free_block_groups(struct btrfs_fs_info *info)
 					struct btrfs_space_info,
 					list);
 		if (btrfs_test_opt(info->tree_root, ENOSPC_DEBUG)) {
-			if (space_info->bytes_pinned > 0 ||
+			if (WARN_ON(space_info->bytes_pinned > 0 ||
 			    space_info->bytes_reserved > 0 ||
-			    space_info->bytes_may_use > 0) {
-				WARN_ON(1);
+			    space_info->bytes_may_use > 0)) {
 				dump_space_info(space_info, 0, 0);
 			}
 		}
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 51731b7..a4592f4 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -1740,10 +1740,8 @@ u64 count_range_bits(struct extent_io_tree *tree,
 	u64 last = 0;
 	int found = 0;
 
-	if (search_end <= cur_start) {
-		WARN_ON(1);
+	if (WARN_ON(search_end <= cur_start))
 		return 0;
-	}
 
 	spin_lock(&tree->lock);
 	if (cur_start == 0 && bits == EXTENT_DIRTY) {
@@ -3569,9 +3567,8 @@ retry:
 			 * but no sense in crashing the users box for something
 			 * we can survive anyway.
 			 */
-			if (!eb) {
+			if (WARN_ON(!eb)) {
 				spin_unlock(&mapping->private_lock);
-				WARN_ON(1);
 				continue;
 			}
 
diff --git a/fs/btrfs/file-item.c b/fs/btrfs/file-item.c
index 4f53159..40ff35e 100644
--- a/fs/btrfs/file-item.c
+++ b/fs/btrfs/file-item.c
@@ -846,10 +846,8 @@ insert:
 	path->leave_spinning = 0;
 	if (ret < 0)
 		goto fail_unlock;
-	if (ret != 0) {
-		WARN_ON(1);
+	if (WARN_ON(ret != 0))
 		goto fail_unlock;
-	}
 	leaf = path->nodes[0];
 csum:
 	item = btrfs_item_ptr(leaf, path->slots[0], struct btrfs_csum_item);
diff --git a/fs/btrfs/inode-map.c b/fs/btrfs/inode-map.c
index 2c66ddb..c169433 100644
--- a/fs/btrfs/inode-map.c
+++ b/fs/btrfs/inode-map.c
@@ -78,10 +78,8 @@ again:
 			    btrfs_transaction_in_commit(fs_info)) {
 				leaf = path->nodes[0];
 
-				if (btrfs_header_nritems(leaf) == 0) {
-					WARN_ON(1);
+				if (WARN_ON(btrfs_header_nritems(leaf) == 0))
 					break;
-				}
 
 				/*
 				 * Save the key so we can advances forward
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 51e3afa..c3fa038 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -2041,10 +2041,8 @@ static noinline int record_one_backref(u64 inum, u64 offset, u64 root_id,
 		key.offset = offset;
 
 	ret = btrfs_search_slot(NULL, root, &key, path, 0, 0);
-	if (ret < 0) {
-		WARN_ON(1);
+	if (WARN_ON(ret < 0))
 		return ret;
-	}
 	ret = 0;
 
 	while (1) {
@@ -3172,8 +3170,7 @@ int btrfs_orphan_cleanup(struct btrfs_root *root)
 
 		/* if we have links, this was a truncate, lets do that */
 		if (inode->i_nlink) {
-			if (!S_ISREG(inode->i_mode)) {
-				WARN_ON(1);
+			if (WARN_ON(!S_ISREG(inode->i_mode))) {
 				iput(inode);
 				continue;
 			}
@@ -7995,8 +7992,7 @@ static int btrfs_rename(struct inode *old_dir, struct dentry *old_dentry,
 		if (ret == -EEXIST) {
 			/* we shouldn't get
 			 * eexist without a new_inode */
-			if (!new_inode) {
-				WARN_ON(1);
+			if (WARN_ON(!new_inode)) {
 				return ret;
 			}
 		} else {
diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index 4a35572..6a981ac 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -1775,8 +1775,7 @@ again:
 			new_ptr_gen = 0;
 		}
 
-		if (new_bytenr > 0 && new_bytenr == old_bytenr) {
-			WARN_ON(1);
+		if (WARN_ON(new_bytenr > 0 && new_bytenr == old_bytenr)) {
 			ret = level;
 			break;
 		}
@@ -3549,10 +3548,8 @@ static int find_data_references(struct reloc_control *rc,
 				err = ret;
 				goto out;
 			}
-			if (ret > 0) {
-				WARN_ON(1);
+			if (WARN_ON(ret > 0))
 				goto out;
-			}
 
 			leaf = path->nodes[0];
 			nritems = btrfs_header_nritems(leaf);
@@ -3572,11 +3569,9 @@ static int find_data_references(struct reloc_control *rc,
 		}
 
 		btrfs_item_key_to_cpu(leaf, &key, path->slots[0]);
-		if (key.objectid != ref_objectid ||
-		    key.type != BTRFS_EXTENT_DATA_KEY) {
-			WARN_ON(1);
+		if (WARN_ON(key.objectid != ref_objectid ||
+		    key.type != BTRFS_EXTENT_DATA_KEY))
 			break;
-		}
 
 		fi = btrfs_item_ptr(leaf, path->slots[0],
 				    struct btrfs_file_extent_item);
@@ -4003,9 +3998,8 @@ restart:
 
 		ret = btrfs_block_rsv_check(rc->extent_root, rc->block_rsv, 5);
 		if (ret < 0) {
-			if (ret != -ENOSPC) {
+			if (WARN_ON(ret != -ENOSPC)) {
 				err = ret;
-				WARN_ON(1);
 				break;
 			}
 			rc->commit_transaction = 1;
diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
index e46e0ed..72765f0 100644
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -565,10 +565,8 @@ static int begin_cmd(struct send_ctx *sctx, int cmd)
 {
 	struct btrfs_cmd_header *hdr;
 
-	if (!sctx->send_buf) {
-		WARN_ON(1);
+	if (WARN_ON(!sctx->send_buf))
 		return -EINVAL;
-	}
 
 	BUG_ON(sctx->send_size);
 
diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index 79f057c..305fcb7 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -2118,8 +2118,7 @@ static noinline int walk_down_log_tree(struct btrfs_trans_handle *trans,
 		WARN_ON(*level >= BTRFS_MAX_LEVEL);
 		cur = path->nodes[*level];
 
-		if (btrfs_header_level(cur) != *level)
-			WARN_ON(1);
+		WARN_ON(btrfs_header_level(cur) != *level);
 
 		if (path->slots[*level] >=
 		    btrfs_header_nritems(cur))
@@ -2943,10 +2942,8 @@ static noinline int log_dir_items(struct btrfs_trans_handle *trans,
 
 	/* find the first key from this transaction again */
 	ret = btrfs_search_slot(NULL, root, &min_key, path, 0, 0);
-	if (ret != 0) {
-		WARN_ON(1);
+	if (WARN_ON(ret != 0))
 		goto done;
-	}
 
 	/*
 	 * we have a block from this transaction, log every item in it
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 043b215..2430918 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -2550,8 +2550,7 @@ again:
 		failed = 0;
 		retried = true;
 		goto again;
-	} else if (failed && retried) {
-		WARN_ON(1);
+	} else if (WARN_ON(failed && retried)) {
 		ret = -ENOSPC;
 	}
 error:
@@ -5395,10 +5394,8 @@ static int bio_size_ok(struct block_device *bdev, struct bio *bio,
 		.bi_rw = bio->bi_rw,
 	};
 
-	if (bio->bi_vcnt == 0) {
-		WARN_ON(1);
+	if (WARN_ON(bio->bi_vcnt == 0))
 		return 1;
-	}
 
 	prev = &bio->bi_io_vec[bio->bi_vcnt - 1];
 	if (bio_sectors(bio) > max_sectors)
@@ -5631,10 +5628,8 @@ struct btrfs_device *btrfs_alloc_device(struct btrfs_fs_info *fs_info,
 	struct btrfs_device *dev;
 	u64 tmp;
 
-	if (!devid && !fs_info) {
-		WARN_ON(1);
+	if (WARN_ON(!devid && !fs_info))
 		return ERR_PTR(-EINVAL);
-	}
 
 	dev = __alloc_device();
 	if (IS_ERR(dev))
-- 
1.8.1.2

