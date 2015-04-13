Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:33824 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754545AbbDMTXB (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 13 Apr 2015 15:23:01 -0400
Received: from pps.filterd (m0044008 [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.14.5/8.14.5) with SMTP id t3DJLAlJ007523
	for <linux-btrfs@vger.kernel.org>; Mon, 13 Apr 2015 12:23:00 -0700
Received: from mail.thefacebook.com ([199.201.64.23])
	by mx0a-00082601.pphosted.com with ESMTP id 1trf9e0p09-1
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=NOT)
	for <linux-btrfs@vger.kernel.org>; Mon, 13 Apr 2015 12:23:00 -0700
Received: from facebook.com (2401:db00:20:702c:face:0:2f:0)	by
 mx-out.facebook.com (10.212.232.59) with ESMTP	id
 7dec09d4e21211e4af370002c991e86a-333a32c0 for <linux-btrfs@vger.kernel.org>;
	Mon, 13 Apr 2015 12:22:57 -0700
From: Chris Mason <clm@fb.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 2/5] Btrfs: refill block reserves during truncate
Date: Mon, 13 Apr 2015 12:22:49 -0700
Message-ID: <1428952972-1266934-3-git-send-email-clm@fb.com>
In-Reply-To: <1428952972-1266934-1-git-send-email-clm@fb.com>
References: <1428952972-1266934-1-git-send-email-clm@fb.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When truncate starts, it allocates some space in the block reserves so
that we'll have enough to update metadata along the way.

For very large files, we can easily go through all of that space as we
loop through the extents.  This changes truncate to refill the space
reservation as it progresses through the file.

Signed-off-by: Chris Mason <clm@fb.com>
---
 fs/btrfs/ctree.h       |  3 +++
 fs/btrfs/extent-tree.c |  9 ++++-----
 fs/btrfs/inode.c       | 45 +++++++++++++++++++++++++++++++++++++++------
 3 files changed, 46 insertions(+), 11 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 95944b8..6bf16d5 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -3297,6 +3297,9 @@ static inline gfp_t btrfs_alloc_write_mask(struct address_space *mapping)
 }
 
 /* extent-tree.c */
+
+u64 btrfs_csum_bytes_to_leaves(struct btrfs_root *root, u64 csum_bytes);
+
 static inline u64 btrfs_calc_trans_metadata_size(struct btrfs_root *root,
 						 unsigned num_items)
 {
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index a6f88eb..75f4bed 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -2636,7 +2636,7 @@ static inline u64 heads_to_leaves(struct btrfs_root *root, u64 heads)
  * Takes the number of bytes to be csumm'ed and figures out how many leaves it
  * would require to store the csums for that many bytes.
  */
-static u64 csum_bytes_to_leaves(struct btrfs_root *root, u64 csum_bytes)
+u64 btrfs_csum_bytes_to_leaves(struct btrfs_root *root, u64 csum_bytes)
 {
 	u64 csum_size;
 	u64 num_csums_per_leaf;
@@ -2665,7 +2665,7 @@ int btrfs_check_space_for_delayed_refs(struct btrfs_trans_handle *trans,
 	if (num_heads > 1)
 		num_bytes += (num_heads - 1) * root->nodesize;
 	num_bytes <<= 1;
-	num_bytes += csum_bytes_to_leaves(root, csum_bytes) * root->nodesize;
+	num_bytes += btrfs_csum_bytes_to_leaves(root, csum_bytes) * root->nodesize;
 	global_rsv = &root->fs_info->global_block_rsv;
 
 	/*
@@ -5098,13 +5098,12 @@ static u64 calc_csum_metadata_size(struct inode *inode, u64 num_bytes,
 	    BTRFS_I(inode)->csum_bytes == 0)
 		return 0;
 
-	old_csums = csum_bytes_to_leaves(root, BTRFS_I(inode)->csum_bytes);
-
+	old_csums = btrfs_csum_bytes_to_leaves(root, BTRFS_I(inode)->csum_bytes);
 	if (reserve)
 		BTRFS_I(inode)->csum_bytes += num_bytes;
 	else
 		BTRFS_I(inode)->csum_bytes -= num_bytes;
-	num_csums = csum_bytes_to_leaves(root, BTRFS_I(inode)->csum_bytes);
+	num_csums = btrfs_csum_bytes_to_leaves(root, BTRFS_I(inode)->csum_bytes);
 
 	/* No change, no need to reserve more */
 	if (old_csums == num_csums)
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index cec23cf..88537c5 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -4163,6 +4163,21 @@ out:
 	return err;
 }
 
+static int truncate_space_check(struct btrfs_trans_handle *trans,
+				struct btrfs_root *root,
+				u64 bytes_deleted)
+{
+	int ret;
+
+	bytes_deleted = btrfs_csum_bytes_to_leaves(root, bytes_deleted);
+	ret = btrfs_block_rsv_add(root, &root->fs_info->trans_block_rsv,
+				  bytes_deleted, BTRFS_RESERVE_NO_FLUSH);
+	if (!ret)
+		trans->bytes_reserved += bytes_deleted;
+	return ret;
+
+}
+
 /*
  * this can truncate away extent items, csum items and directory items.
  * It starts at a high offset and removes keys until it can't find
@@ -4201,6 +4216,7 @@ int btrfs_truncate_inode_items(struct btrfs_trans_handle *trans,
 	u64 bytes_deleted = 0;
 	bool be_nice = 0;
 	bool should_throttle = 0;
+	bool should_end = 0;
 
 	BUG_ON(new_size > 0 && min_type != BTRFS_EXTENT_DATA_KEY);
 
@@ -4396,6 +4412,8 @@ delete:
 		} else {
 			break;
 		}
+		should_throttle = 0;
+
 		if (found_extent &&
 		    (test_bit(BTRFS_ROOT_REF_COWS, &root->state) ||
 		     root == root->fs_info->tree_root)) {
@@ -4409,17 +4427,24 @@ delete:
 			if (btrfs_should_throttle_delayed_refs(trans, root))
 				btrfs_async_run_delayed_refs(root,
 					trans->delayed_ref_updates * 2, 0);
+			if (be_nice) {
+				if (truncate_space_check(trans, root,
+							 extent_num_bytes)) {
+					should_end = 1;
+				}
+				if (btrfs_should_throttle_delayed_refs(trans,
+								       root)) {
+					should_throttle = 1;
+				}
+			}
 		}
 
 		if (found_type == BTRFS_INODE_ITEM_KEY)
 			break;
 
-		should_throttle =
-			btrfs_should_throttle_delayed_refs(trans, root);
-
 		if (path->slots[0] == 0 ||
 		    path->slots[0] != pending_del_slot ||
-		    (be_nice && should_throttle)) {
+		    should_throttle || should_end) {
 			if (pending_del_nr) {
 				ret = btrfs_del_items(trans, root, path,
 						pending_del_slot,
@@ -4432,7 +4457,7 @@ delete:
 				pending_del_nr = 0;
 			}
 			btrfs_release_path(path);
-			if (be_nice && should_throttle) {
+			if (should_throttle) {
 				unsigned long updates = trans->delayed_ref_updates;
 				if (updates) {
 					trans->delayed_ref_updates = 0;
@@ -4441,6 +4466,14 @@ delete:
 						err = ret;
 				}
 			}
+			/*
+			 * if we failed to refill our space rsv, bail out
+			 * and let the transaction restart
+			 */
+			if (should_end) {
+				err = -EAGAIN;
+				goto error;
+			}
 			goto search_again;
 		} else {
 			path->slots[0]--;
@@ -4460,7 +4493,7 @@ error:
 
 	btrfs_free_path(path);
 
-	if (be_nice && btrfs_should_throttle_delayed_refs(trans, root)) {
+	if (be_nice && bytes_deleted > 32 * 1024 * 1024) {
 		unsigned long updates = trans->delayed_ref_updates;
 		if (updates) {
 			trans->delayed_ref_updates = 0;
-- 
1.8.1

