Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:44251 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752692AbeFHMsD (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 8 Jun 2018 08:48:03 -0400
Received: from relay1.suse.de (charybdis-ext-too.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id E097FAF91
        for <linux-btrfs@vger.kernel.org>; Fri,  8 Jun 2018 12:48:01 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 02/15] btrfs-progs: Remove root argument from btrfs_del_csums
Date: Fri,  8 Jun 2018 15:47:45 +0300
Message-Id: <1528462078-24490-3-git-send-email-nborisov@suse.com>
In-Reply-To: <1528462078-24490-1-git-send-email-nborisov@suse.com>
References: <1528462078-24490-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

It's not needed, since we can obtain a reference to fs_info from the
passed transaction handle. This is needed by delayed refs code.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 btrfs-corrupt-block.c |  2 +-
 ctree.h               |  3 +--
 extent-tree.c         |  2 +-
 file-item.c           | 20 ++++++++++----------
 4 files changed, 13 insertions(+), 14 deletions(-)

diff --git a/btrfs-corrupt-block.c b/btrfs-corrupt-block.c
index 4fbea26cda20..3add8e63b7bb 100644
--- a/btrfs-corrupt-block.c
+++ b/btrfs-corrupt-block.c
@@ -926,7 +926,7 @@ static int delete_csum(struct btrfs_root *root, u64 bytenr, u64 bytes)
 		return PTR_ERR(trans);
 	}
 
-	ret = btrfs_del_csums(trans, root, bytenr, bytes);
+	ret = btrfs_del_csums(trans, bytenr, bytes);
 	if (ret)
 		fprintf(stderr, "Error deleting csums %d\n", ret);
 	btrfs_commit_transaction(trans, root);
diff --git a/ctree.h b/ctree.h
index de4b1b7e6416..082726238b91 100644
--- a/ctree.h
+++ b/ctree.h
@@ -2752,8 +2752,7 @@ int btrfs_del_inode_ref(struct btrfs_trans_handle *trans,
 			u64 ino, u64 parent_ino, u64 *index);
 
 /* file-item.c */
-int btrfs_del_csums(struct btrfs_trans_handle *trans,
-		    struct btrfs_root *root, u64 bytenr, u64 len);
+int btrfs_del_csums(struct btrfs_trans_handle *trans, u64 bytenr, u64 len);
 int btrfs_insert_file_extent(struct btrfs_trans_handle *trans,
 			     struct btrfs_root *root,
 			     u64 objectid, u64 pos, u64 offset,
diff --git a/extent-tree.c b/extent-tree.c
index cbc022f6cef6..c6f09b52800f 100644
--- a/extent-tree.c
+++ b/extent-tree.c
@@ -2372,7 +2372,7 @@ static int __free_extent(struct btrfs_trans_handle *trans,
 		btrfs_release_path(path);
 
 		if (is_data) {
-			ret = btrfs_del_csums(trans, root, bytenr, num_bytes);
+			ret = btrfs_del_csums(trans, bytenr, num_bytes);
 			BUG_ON(ret);
 		}
 
diff --git a/file-item.c b/file-item.c
index 7b0ff3585509..71d4e89f78d1 100644
--- a/file-item.c
+++ b/file-item.c
@@ -394,8 +394,7 @@ static noinline int truncate_one_csum(struct btrfs_root *root,
  * deletes the csum items from the csum tree for a given
  * range of bytes.
  */
-int btrfs_del_csums(struct btrfs_trans_handle *trans,
-		    struct btrfs_root *root, u64 bytenr, u64 len)
+int btrfs_del_csums(struct btrfs_trans_handle *trans, u64 bytenr, u64 len)
 {
 	struct btrfs_path *path;
 	struct btrfs_key key;
@@ -403,11 +402,10 @@ int btrfs_del_csums(struct btrfs_trans_handle *trans,
 	u64 csum_end;
 	struct extent_buffer *leaf;
 	int ret;
-	u16 csum_size =
-		btrfs_super_csum_size(root->fs_info->super_copy);
-	int blocksize = root->fs_info->sectorsize;
+	u16 csum_size = btrfs_super_csum_size(trans->fs_info->super_copy);
+	int blocksize = trans->fs_info->sectorsize;
+	struct btrfs_root *csum_root = trans->fs_info->csum_root;
 
-	root = root->fs_info->csum_root;
 
 	path = btrfs_alloc_path();
 	if (!path)
@@ -418,7 +416,7 @@ int btrfs_del_csums(struct btrfs_trans_handle *trans,
 		key.offset = end_byte - 1;
 		key.type = BTRFS_EXTENT_CSUM_KEY;
 
-		ret = btrfs_search_slot(trans, root, &key, path, -1, 1);
+		ret = btrfs_search_slot(trans, csum_root, &key, path, -1, 1);
 		if (ret > 0) {
 			if (path->slots[0] == 0)
 				goto out;
@@ -445,7 +443,7 @@ int btrfs_del_csums(struct btrfs_trans_handle *trans,
 
 		/* delete the entire item, it is inside our range */
 		if (key.offset >= bytenr && csum_end <= end_byte) {
-			ret = btrfs_del_item(trans, root, path);
+			ret = btrfs_del_item(trans, csum_root, path);
 			BUG_ON(ret);
 		} else if (key.offset < bytenr && csum_end > end_byte) {
 			unsigned long offset;
@@ -485,12 +483,14 @@ int btrfs_del_csums(struct btrfs_trans_handle *trans,
 			 * btrfs_split_item returns -EAGAIN when the
 			 * item changed size or key
 			 */
-			ret = btrfs_split_item(trans, root, path, &key, offset);
+			ret = btrfs_split_item(trans, csum_root, path, &key,
+					       offset);
 			BUG_ON(ret && ret != -EAGAIN);
 
 			key.offset = end_byte - 1;
 		} else {
-			ret = truncate_one_csum(root, path, &key, bytenr, len);
+			ret = truncate_one_csum(csum_root, path, &key, bytenr,
+						len);
 			BUG_ON(ret);
 		}
 		btrfs_release_path(path);
-- 
2.7.4

