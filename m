Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:17671 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754713Ab3L3INd (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 30 Dec 2013 03:13:33 -0500
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: Marcel Ritter <ritter.marcel@gmail.com>,
        Christian Robert <christian.robert@polymtl.ca>,
        "alanqk@gmail.com" <alanqk@gmail.com>
Subject: [PATCH v8 14/14] Btrfs: fix a crash of dedup ref
Date: Mon, 30 Dec 2013 16:12:54 +0800
Message-Id: <1388391175-29539-15-git-send-email-bo.li.liu@oracle.com>
In-Reply-To: <1388391175-29539-1-git-send-email-bo.li.liu@oracle.com>
References: <1388391175-29539-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The dedup reference is a special kind of delayed refs, and the delayed refs
are batched to be processed later.

If we find a matched dedup extent, then we queue an ADD delayed ref on it within
endio work, but there is already a DROP delayed ref queued,

   t1                             t2                          t3
->writepage                                             commit transaction
  ->run_delalloc_dedup
     find_dedup
------------------------------------------------------------------------------
                                                       process_delayed refs
                                                    (it deletes the dedup extent)
     add ordered extent                                        |
     submit pages                                              |
                              finish ordered io                |
                                insert file extents            |
                                queue delayed refs             |
                                queue dedup ref                |
                                                     "process delayed refs" continues
                                                     (insert a ref on an extent
                                                      deleted by the above)

This senario ends up with a crash because we're going to insert a ref on
a deleted extent.

To avoid the race, we need to check if there is a ADD delayed ref on deleting
the extent and protect this job with lock.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/ctree.h       |  3 ++-
 fs/btrfs/extent-tree.c | 35 +++++++++++++++++++----------------
 fs/btrfs/file-item.c   | 36 +++++++++++++++++++++++++++++++++++-
 fs/btrfs/inode.c       | 10 ++--------
 4 files changed, 58 insertions(+), 26 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 1b89d6c..8a35cdf 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -3692,7 +3692,8 @@ int btrfs_lookup_csums_range(struct btrfs_root *root, u64 start, u64 end,
 			     struct list_head *list, int search_commit);
 
 int noinline_for_stack
-btrfs_find_dedup_extent(struct btrfs_root *root, struct btrfs_dedup_hash *hash);
+btrfs_find_dedup_extent(struct btrfs_root *root, struct btrfs_dedup_hash *hash,
+			struct inode *inode, u64 file_pos);
 int noinline_for_stack
 btrfs_insert_dedup_extent(struct btrfs_trans_handle *trans,
 			  struct btrfs_root *root,
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index df3a645..a140ea9 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -5996,9 +5996,23 @@ again:
 			goto again;
 		}
 	} else {
-		if (!dedup_hash && is_data &&
-		    root_objectid == BTRFS_DEDUP_TREE_OBJECTID)
-			dedup_hash = extent_data_ref_offset(root, path, iref);
+		if (is_data && root_objectid == BTRFS_DEDUP_TREE_OBJECTID) {
+			if (!dedup_hash)
+				dedup_hash = extent_data_ref_offset(root,
+								    path, iref);
+
+			ret = btrfs_free_dedup_extent(trans, root,
+						      dedup_hash, bytenr);
+			if (ret) {
+				if (ret == -EAGAIN)
+					ret = 0;
+				else
+					btrfs_abort_transaction(trans,
+								extent_root,
+								ret);
+				goto out;
+			}
+		}
 
 		if (found_extent) {
 			BUG_ON(is_data && refs_to_drop !=
@@ -6023,21 +6037,10 @@ again:
 		if (is_data) {
 			ret = btrfs_del_csums(trans, root, bytenr, num_bytes);
 			if (ret) {
-				btrfs_abort_transaction(trans, extent_root, ret);
+				btrfs_abort_transaction(trans,
+							extent_root, ret);
 				goto out;
 			}
-
-			if (root_objectid == BTRFS_DEDUP_TREE_OBJECTID) {
-				ret = btrfs_free_dedup_extent(trans, root,
-							      dedup_hash,
-							      bytenr);
-				if (ret) {
-					btrfs_abort_transaction(trans,
-								extent_root,
-								ret);
-					goto out;
-				}
-			}
 		}
 
 		ret = update_block_group(root, bytenr, num_bytes, 0);
diff --git a/fs/btrfs/file-item.c b/fs/btrfs/file-item.c
index fd95692..a804071 100644
--- a/fs/btrfs/file-item.c
+++ b/fs/btrfs/file-item.c
@@ -887,13 +887,15 @@ fail_unlock:
 
 /* 1 means we find one, 0 means we dont. */
 int noinline_for_stack
-btrfs_find_dedup_extent(struct btrfs_root *root, struct btrfs_dedup_hash *hash)
+btrfs_find_dedup_extent(struct btrfs_root *root, struct btrfs_dedup_hash *hash,
+			struct inode *inode, u64 file_pos)
 {
 	struct btrfs_key key;
 	struct btrfs_path *path;
 	struct extent_buffer *leaf;
 	struct btrfs_root *dedup_root;
 	struct btrfs_dedup_item *item;
+	struct btrfs_trans_handle *trans;
 	u64 hash_value;
 	u64 length;
 	u64 dedup_size;
@@ -916,6 +918,12 @@ btrfs_find_dedup_extent(struct btrfs_root *root, struct btrfs_dedup_hash *hash)
 	if (!path)
 		return 0;
 
+	trans = btrfs_join_transaction(root);
+	if (IS_ERR(trans)) {
+		trans = NULL;
+		goto out;
+	}
+
 	/*
 	 * For SHA256 dedup algorithm, we store the last 64bit as the
 	 * key.objectid, and the rest in the tree item.
@@ -972,7 +980,15 @@ prev_slot:
 	hash->num_bytes = length;
 	hash->compression = compression;
 	found = 1;
+
+	ret = btrfs_inc_extent_ref(trans, root, key.offset, length, 0,
+				   BTRFS_I(inode)->root->root_key.objectid,
+				   btrfs_ino(inode),
+				   file_pos, /* file_pos - 0 */
+				   0);
 out:
+	if (trans)
+		btrfs_end_transaction(trans, root);
 	btrfs_free_path(path);
 	return found;
 }
@@ -1055,6 +1071,8 @@ btrfs_free_dedup_extent(struct btrfs_trans_handle *trans,
 	struct btrfs_path *path;
 	struct extent_buffer *leaf;
 	struct btrfs_root *dedup_root;
+	struct btrfs_delayed_ref_root *delayed_refs;
+	struct btrfs_delayed_ref_head *head;
 	int ret = 0;
 
 	if (!root->fs_info->dedup_root)
@@ -1088,6 +1106,22 @@ btrfs_free_dedup_extent(struct btrfs_trans_handle *trans,
 	if (key.objectid != hash || key.offset != bytenr)
 		goto out;
 
+	ret = 0;
+
+	/* check if ADD_DELAYED delayed refs exist */
+	delayed_refs = &trans->transaction->delayed_refs;
+
+	spin_lock(&delayed_refs->lock);
+	head = btrfs_find_delayed_ref_head(trans, bytenr);
+
+	/* the mutex has been acquired by the caller */
+	if (head && head->add_cnt) {
+		spin_unlock(&delayed_refs->lock);
+		ret = -EAGAIN;
+		goto out;
+	}
+	spin_unlock(&delayed_refs->lock);
+
 	ret = btrfs_del_item(trans, dedup_root, path);
 	WARN_ON(ret);
 out:
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 4363e1e..b40ec29 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -969,7 +969,8 @@ run_delalloc_dedup(struct inode *inode, struct page *locked_page, u64 start,
 			found = 0;
 			compr = BTRFS_COMPRESS_NONE;
 		} else {
-			found = btrfs_find_dedup_extent(root, hash);
+			found = btrfs_find_dedup_extent(root, hash,
+							inode, start);
 			compr = hash->compression;
 		}
 
@@ -2364,13 +2365,6 @@ static int __insert_reserved_file_extent(struct btrfs_trans_handle *trans,
 					   btrfs_ino(inode),
 					   hash->hash[index], 0);
 		}
-	} else {
-		ret = btrfs_inc_extent_ref(trans, root, ins.objectid,
-					   ins.offset, 0,
-					   root->root_key.objectid,
-					   btrfs_ino(inode),
-					   file_pos, /* file_pos - 0 */
-					   0);
 	}
 out:
 	btrfs_free_path(path);
-- 
1.8.2.1

