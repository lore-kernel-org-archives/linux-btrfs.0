Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:58832 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754888AbaJJU5f (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 10 Oct 2014 16:57:35 -0400
Received: from pps.filterd (m0004077 [127.0.0.1])
	by mx0b-00082601.pphosted.com (8.14.5/8.14.5) with SMTP id s9AKr7V4012223
	for <linux-btrfs@vger.kernel.org>; Fri, 10 Oct 2014 13:57:34 -0700
Received: from mail.thefacebook.com (mailwest.thefacebook.com [173.252.71.148])
	by mx0b-00082601.pphosted.com with ESMTP id 1pxnf7gagp-1
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Fri, 10 Oct 2014 13:57:34 -0700
From: Josef Bacik <jbacik@fb.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 05/12] Btrfs-progs: lookup all roots that point to a corrupt block
Date: Fri, 10 Oct 2014 16:57:10 -0400
Message-ID: <1412974637-31334-6-git-send-email-jbacik@fb.com>
In-Reply-To: <1412974637-31334-1-git-send-email-jbacik@fb.com>
References: <1412974637-31334-1-git-send-email-jbacik@fb.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

If we have a corrupt block that multiple snapshots point to we will only fix the
guy who originally pointed to the block, and then simply loop forever because we
keep finding the same bad block.  So instead lookup all roots that point to this
block, and then search down to the block for each root and fix the block in all
snapshots.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fb.com>
---
 cmds-check.c | 143 +++++++++++++++++++++++++++++------------------------------
 1 file changed, 70 insertions(+), 73 deletions(-)

diff --git a/cmds-check.c b/cmds-check.c
index ff9c0d5..1deef77 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -40,6 +40,8 @@
 #include "btrfsck.h"
 #include "qgroup-verify.h"
 #include "rbtree-utils.h"
+#include "backref.h"
+#include "ulist.h"
 
 static u64 bytes_used = 0;
 static u64 total_csum_bytes = 0;
@@ -2554,42 +2556,14 @@ static int swap_values(struct btrfs_root *root, struct btrfs_path *path,
 
 static int fix_key_order(struct btrfs_trans_handle *trans,
 			 struct btrfs_root *root,
-			 struct extent_buffer *buf)
+			 struct btrfs_path *path)
 {
-	struct btrfs_path *path;
+	struct extent_buffer *buf;
 	struct btrfs_key k1, k2;
 	int i;
-	int level;
+	int level = path->lowest_level;
 	int ret;
 
-	k1.objectid = btrfs_header_owner(buf);
-	k1.type = BTRFS_ROOT_ITEM_KEY;
-	k1.offset = (u64)-1;
-
-	root = btrfs_read_fs_root(root->fs_info, &k1);
-	if (IS_ERR(root))
-		return -EIO;
-
-	record_root_in_trans(trans, root);
-
-	path = btrfs_alloc_path();
-	if (!path)
-		return -EIO;
-
-	level = btrfs_header_level(buf);
-	path->lowest_level = level;
-	path->skip_check_block = 1;
-	if (level)
-		btrfs_node_key_to_cpu(buf, &k1, 0);
-	else
-		btrfs_item_key_to_cpu(buf, &k1, 0);
-
-	ret = btrfs_search_slot(trans, root, &k1, path, 0, 1);
-	if (ret) {
-		btrfs_free_path(path);
-		return -EIO;
-	}
-
 	buf = path->nodes[level];
 	for (i = 0; i < btrfs_header_nritems(buf) - 1; i++) {
 		if (level) {
@@ -2607,8 +2581,6 @@ static int fix_key_order(struct btrfs_trans_handle *trans,
 		btrfs_mark_buffer_dirty(buf);
 		i = 0;
 	}
-
-	btrfs_free_path(path);
 	return ret;
 }
 
@@ -2650,43 +2622,15 @@ static int delete_bogus_item(struct btrfs_trans_handle *trans,
 
 static int fix_item_offset(struct btrfs_trans_handle *trans,
 			   struct btrfs_root *root,
-			   struct extent_buffer *buf)
+			   struct btrfs_path *path)
 {
-	struct btrfs_path *path;
-	struct btrfs_key k1;
+	struct extent_buffer *buf;
 	int i;
-	int level;
-	int ret;
-
-	k1.objectid = btrfs_header_owner(buf);
-	k1.type = BTRFS_ROOT_ITEM_KEY;
-	k1.offset = (u64)-1;
-
-	root = btrfs_read_fs_root(root->fs_info, &k1);
-	if (IS_ERR(root))
-		return -EIO;
-
-	record_root_in_trans(trans, root);
-
-	path = btrfs_alloc_path();
-	if (!path)
-		return -EIO;
-
-	level = btrfs_header_level(buf);
-	path->lowest_level = level;
-	path->skip_check_block = 1;
-	if (level)
-		btrfs_node_key_to_cpu(buf, &k1, 0);
-	else
-		btrfs_item_key_to_cpu(buf, &k1, 0);
-
-	ret = btrfs_search_slot(trans, root, &k1, path, 0, 1);
-	if (ret) {
-		btrfs_free_path(path);
-		return -EIO;
-	}
+	int ret = 0;
 
-	buf = path->nodes[level];
+	/* We should only get this for leaves */
+	BUG_ON(path->lowest_level);
+	buf = path->nodes[0];
 again:
 	for (i = 0; i < btrfs_header_nritems(buf); i++) {
 		unsigned int shift = 0, offset;
@@ -2742,7 +2686,6 @@ again:
 	 * progs this can be changed to something nicer.
 	 */
 	BUG_ON(ret);
-	btrfs_free_path(path);
 	return ret;
 }
 
@@ -2755,11 +2698,65 @@ static int try_to_fix_bad_block(struct btrfs_trans_handle *trans,
 				struct extent_buffer *buf,
 				enum btrfs_tree_block_status status)
 {
-	if (status == BTRFS_TREE_BLOCK_BAD_KEY_ORDER)
-		return fix_key_order(trans, root, buf);
-	if (status == BTRFS_TREE_BLOCK_INVALID_OFFSETS)
-		return fix_item_offset(trans, root, buf);
-	return -EIO;
+	struct ulist *roots;
+	struct ulist_node *node;
+	struct btrfs_root *search_root;
+	struct btrfs_path *path;
+	struct ulist_iterator iter;
+	struct btrfs_key root_key, key;
+	int ret;
+
+	if (status != BTRFS_TREE_BLOCK_BAD_KEY_ORDER &&
+	    status != BTRFS_TREE_BLOCK_INVALID_OFFSETS)
+		return -EIO;
+
+	path = btrfs_alloc_path();
+	if (!path)
+		return -EIO;
+
+	ret = btrfs_find_all_roots(trans, root->fs_info, buf->start,
+				   0, &roots);
+	if (ret) {
+		btrfs_free_path(path);
+		return -EIO;
+	}
+
+	ULIST_ITER_INIT(&iter);
+	while ((node = ulist_next(roots, &iter))) {
+		root_key.objectid = node->val;
+		root_key.type = BTRFS_ROOT_ITEM_KEY;
+		root_key.offset = (u64)-1;
+
+		search_root = btrfs_read_fs_root(root->fs_info, &root_key);
+		if (IS_ERR(root)) {
+			ret = -EIO;
+			break;
+		}
+
+		record_root_in_trans(trans, search_root);
+
+		path->lowest_level = btrfs_header_level(buf);
+		path->skip_check_block = 1;
+		if (path->lowest_level)
+			btrfs_node_key_to_cpu(buf, &key, 0);
+		else
+			btrfs_item_key_to_cpu(buf, &key, 0);
+		ret = btrfs_search_slot(trans, search_root, &key, path, 0, 1);
+		if (ret) {
+			ret = -EIO;
+			break;
+		}
+		if (status == BTRFS_TREE_BLOCK_BAD_KEY_ORDER)
+			ret = fix_key_order(trans, search_root, path);
+		else if (status == BTRFS_TREE_BLOCK_INVALID_OFFSETS)
+			ret = fix_item_offset(trans, search_root, path);
+		if (ret)
+			break;
+		btrfs_release_path(path);
+	}
+	ulist_free(roots);
+	btrfs_free_path(path);
+	return ret;
 }
 
 static int check_block(struct btrfs_trans_handle *trans,
-- 
1.8.3.1

