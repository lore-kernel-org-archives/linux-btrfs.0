Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:34365 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965304AbaDJDtx (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 9 Apr 2014 23:49:53 -0400
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: Marcel Ritter <ritter.marcel@gmail.com>,
        Christian Robert <christian.robert@polymtl.ca>, <alanqk@gmail.com>,
        Konstantinos Skarlatos <k.skarlatos@gmail.com>,
        David Sterba <dsterba@suse.cz>,
        Martin Steigerwald <Martin@lichtvoll.de>, Josef Bacik <jbacik@fb.com>,
        Chris Mason <clm@fb.com>
Subject: [PATCH v10 11/16] Btrfs: fix a crash of dedup ref
Date: Thu, 10 Apr 2014 11:48:41 +0800
Message-Id: <1397101727-20806-12-git-send-email-bo.li.liu@oracle.com>
In-Reply-To: <1397101727-20806-1-git-send-email-bo.li.liu@oracle.com>
References: <1397101727-20806-1-git-send-email-bo.li.liu@oracle.com>
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
index feebfab..2e8c443 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -3764,7 +3764,8 @@ int btrfs_lookup_csums_range(struct btrfs_root *root, u64 start, u64 end,
 			     struct list_head *list, int search_commit);
 
 int noinline_for_stack
-btrfs_find_dedup_extent(struct btrfs_root *root, struct btrfs_dedup_hash *hash);
+btrfs_find_dedup_extent(struct btrfs_root *root, struct btrfs_dedup_hash *hash,
+			struct inode *inode, u64 file_pos);
 int noinline_for_stack
 btrfs_insert_dedup_extent(struct btrfs_trans_handle *trans,
 			  struct btrfs_root *root,
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 191f0a7..a8da7aa 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -5937,9 +5937,23 @@ again:
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
@@ -5964,21 +5978,10 @@ again:
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
index 6437ebe..4ae383b 100644
--- a/fs/btrfs/file-item.c
+++ b/fs/btrfs/file-item.c
@@ -888,13 +888,15 @@ fail_unlock:
 
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
@@ -917,6 +919,12 @@ btrfs_find_dedup_extent(struct btrfs_root *root, struct btrfs_dedup_hash *hash)
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
@@ -973,8 +981,16 @@ prev_slot:
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
 	btrfs_free_path(path);
+	if (trans)
+		btrfs_end_transaction(trans, root);
 	return found;
 }
 
@@ -1056,6 +1072,8 @@ btrfs_free_dedup_extent(struct btrfs_trans_handle *trans,
 	struct btrfs_path *path;
 	struct extent_buffer *leaf;
 	struct btrfs_root *dedup_root;
+	struct btrfs_delayed_ref_root *delayed_refs;
+	struct btrfs_delayed_ref_head *head;
 	int ret = 0;
 
 	if (!root->fs_info->dedup_root)
@@ -1089,6 +1107,22 @@ btrfs_free_dedup_extent(struct btrfs_trans_handle *trans,
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
index 0c1a43e..ed92ef3 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -988,7 +988,8 @@ run_delalloc_dedup(struct inode *inode, struct page *locked_page, u64 start,
 			found = 0;
 			compr = BTRFS_COMPRESS_NONE;
 		} else {
-			found = btrfs_find_dedup_extent(root, hash);
+			found = btrfs_find_dedup_extent(root, hash,
+							inode, start);
 			compr = hash->compression;
 		}
 
@@ -2388,13 +2389,6 @@ static int __insert_reserved_file_extent(struct btrfs_trans_handle *trans,
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
1.8.1.4

