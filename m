Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:36799 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751300AbaHUC5O (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 20 Aug 2014 22:57:14 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s7L2vARo008198
	for <linux-btrfs@vger.kernel.org>; Thu, 21 Aug 2014 10:57:10 +0800
From: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
Subject: [PATCH 2/2] btrfs-progs: remove unused flags for btrfs_path
Date: Thu, 21 Aug 2014 10:56:53 +0800
Message-ID: <1408589813-5575-2-git-send-email-guihc.fnst@cn.fujitsu.com>
In-Reply-To: <1408589813-5575-1-git-send-email-guihc.fnst@cn.fujitsu.com>
References: <1408589813-5575-1-git-send-email-guihc.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The three flags of @btrfs_path:
	btrfs_path {
		unsigned int keep_locks:1;
		unsigned int skip_locking:1;
		unsigned int leave_spinning:1;
	}
have little meaning, because the userspace @btrfs_search_slot()
is free of locking and no other routines will decide their behavior
on these. So just remove them.

Signed-off-by: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
---
 cmds-restore.c | 2 --
 ctree.h        | 3 ---
 extent-tree.c  | 6 ------
 3 files changed, 11 deletions(-)

diff --git a/cmds-restore.c b/cmds-restore.c
index f417e0b..bfd883d 100644
--- a/cmds-restore.c
+++ b/cmds-restore.c
@@ -566,7 +566,6 @@ static int copy_file(struct btrfs_root *root, int fd, struct btrfs_key *key,
 		fprintf(stderr, "Ran out of memory\n");
 		return -ENOMEM;
 	}
-	path->skip_locking = 1;
 
 	ret = btrfs_lookup_inode(NULL, root, path, key, 0);
 	if (ret == 0) {
@@ -704,7 +703,6 @@ static int search_dir(struct btrfs_root *root, struct btrfs_key *key,
 		fprintf(stderr, "Ran out of memory\n");
 		return -ENOMEM;
 	}
-	path->skip_locking = 1;
 
 	key->offset = 0;
 	key->type = BTRFS_DIR_INDEX_KEY;
diff --git a/ctree.h b/ctree.h
index 35d3633..fe1cd53 100644
--- a/ctree.h
+++ b/ctree.h
@@ -552,9 +552,6 @@ struct btrfs_path {
 	 * and to force calls to keep space in the nodes
 	 */
 	unsigned int search_for_split:1;
-	unsigned int keep_locks:1;
-	unsigned int skip_locking:1;
-	unsigned int leave_spinning:1;
 	unsigned int skip_check_block:1;
 };
 
diff --git a/extent-tree.c b/extent-tree.c
index c46c92b..5443ec8 100644
--- a/extent-tree.c
+++ b/extent-tree.c
@@ -1418,7 +1418,6 @@ int btrfs_inc_extent_ref(struct btrfs_trans_handle *trans,
 		return -ENOMEM;
 
 	path->reada = 1;
-	path->leave_spinning = 1;
 
 	ret = insert_inline_extent_backref(trans, root->fs_info->extent_root,
 					   path, bytenr, num_bytes, parent,
@@ -1440,7 +1439,6 @@ int btrfs_inc_extent_ref(struct btrfs_trans_handle *trans,
 	btrfs_release_path(path);
 
 	path->reada = 1;
-	path->leave_spinning = 1;
 
 	/* now insert the actual backref */
 	ret = insert_extent_backref(trans, root->fs_info->extent_root,
@@ -2195,7 +2193,6 @@ static int __free_extent(struct btrfs_trans_handle *trans,
 		return -ENOMEM;
 
 	path->reada = 1;
-	path->leave_spinning = 1;
 
 	is_data = owner_objectid >= BTRFS_FIRST_FREE_OBJECTID;
 	if (is_data)
@@ -2239,7 +2236,6 @@ static int __free_extent(struct btrfs_trans_handle *trans,
 						    is_data);
 			BUG_ON(ret);
 			btrfs_release_path(path);
-			path->leave_spinning = 1;
 
 			key.objectid = bytenr;
 
@@ -2304,7 +2300,6 @@ static int __free_extent(struct btrfs_trans_handle *trans,
 		BUG_ON(ret < 0);
 
 		btrfs_release_path(path);
-		path->leave_spinning = 1;
 
 		key.objectid = bytenr;
 		key.type = BTRFS_EXTENT_ITEM_KEY;
@@ -2711,7 +2706,6 @@ static int alloc_reserved_tree_block(struct btrfs_trans_handle *trans,
 	path = btrfs_alloc_path();
 	BUG_ON(!path);
 
-	path->leave_spinning = 1;
 	ret = btrfs_insert_empty_item(trans, fs_info->extent_root, path,
 				      ins, size);
 	BUG_ON(ret);
-- 
1.8.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo
