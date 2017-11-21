Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:35509 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751766AbdKUKLy (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 21 Nov 2017 05:11:54 -0500
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (unknown [10.167.33.83])
        by cn.fujitsu.com (Postfix) with ESMTP id EDF5E487F165
        for <linux-btrfs@vger.kernel.org>; Tue, 21 Nov 2017 18:11:49 +0800 (CST)
From: Su Yue <suy.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 3/3] btrfs-progs: check: record last checked root_item in original mode
Date: Tue, 21 Nov 2017 18:15:24 +0800
Message-ID: <20171121101524.2014-3-suy.fnst@cn.fujitsu.com>
In-Reply-To: <20171121101524.2014-1-suy.fnst@cn.fujitsu.com>
References: <20171121101524.2014-1-suy.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

check_fs_roots() will check all fs trees again if fs_info->tree_root
have been cowed.
It is inefficient if there are many subvolumes in filesystem.

And it also causes dead loop while repairing
fuzz-tests/images/bko-161811.raw:
=============================
ERROR: DIR_ITEM[256 1167283096] name  namelen 32 filetype 1 mismatch with its hash, wanted 1167283096 have 709597396
invalid location in dir item 0
root 5 root dir 256 error
root 5 inode 256 errors 10, odd dir item
Failed to reset nlink for inode 18446744073709551361: No such file or directory
        unresolved ref dir 256 index 0 namelen 32 name  filetype 1 errors 106, no dir index, no inode ref, name too long
ERROR: DIR_ITEM[256 1167283096] name  namelen 32 filetype 1 mismatch with its hash, wanted 1167283096 have 709597396
invalid location in dir item 0
root 5 root dir 256 error
root 5 inode 256 errors 10, odd dir item
Failed to reset nlink for inode 18446744073709551361: No such file or directory
        unresolved ref dir 256 index 0 namelen 32 name  filetype 1 errors 106, no dir index, no inode ref, name too long
ERROR: DIR_ITEM[256 1167283096] name  namelen 32 filetype 1 mismatch with its hash, wanted 1167283
...
==============================

Process of the dead loop:
1) check_fs_root() failed to repair the inode.
2) btrfs_commit_transaction() did cow of the fs_info->tree_root
3) check_fs_roots() restarted to check fs tree.
4) goto 1).

Introduce a variable @prev_key to record last checked root_item.
If check_fs_root() failed, go to check the next fs_tree instead of
trying it again and again.

Signed-off-by: Su Yue <suy.fnst@cn.fujitsu.com>
---
 cmds-check.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/cmds-check.c b/cmds-check.c
index 68348ae94c8b..d149608acde2 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -4587,6 +4587,7 @@ static int check_fs_roots(struct btrfs_fs_info *fs_info,
 {
 	struct btrfs_path path;
 	struct btrfs_key key;
+	struct btrfs_key prev_key;
 	struct walk_control wc;
 	struct extent_buffer *leaf, *tree_node;
 	struct btrfs_root *tmp_root;
@@ -4609,19 +4610,21 @@ static int check_fs_roots(struct btrfs_fs_info *fs_info,
 	cache_tree_init(&wc.shared);
 	btrfs_init_path(&path);
 
+	prev_key.offset = 0;
+	prev_key.objectid = 0;
+	prev_key.type = BTRFS_ROOT_ITEM_KEY;
 again:
-	key.offset = 0;
-	key.objectid = 0;
-	key.type = BTRFS_ROOT_ITEM_KEY;
+	key = prev_key;
 	ret = btrfs_search_slot(NULL, tree_root, &key, &path, 0, 0);
 	if (ret < 0) {
 		err = 1;
 		goto out;
 	}
+	if (!ret)
+		path.slots[0]++;
 	tree_node = tree_root->node;
 	while (1) {
 		if (tree_node != tree_root->node) {
-			free_root_recs_tree(root_cache);
 			btrfs_release_path(&path);
 			goto again;
 		}
@@ -4636,6 +4639,9 @@ again:
 			leaf = path.nodes[0];
 		}
 		btrfs_item_key_to_cpu(leaf, &key, path.slots[0]);
+		/* save key */
+		prev_key = key;
+
 		if (key.type == BTRFS_ROOT_ITEM_KEY &&
 		    fs_root_objectid(key.objectid)) {
 			if (key.objectid == BTRFS_TREE_RELOC_OBJECTID) {
@@ -4654,6 +4660,8 @@ again:
 			if (ret == -EAGAIN) {
 				free_root_recs_tree(root_cache);
 				btrfs_release_path(&path);
+				prev_key.objectid = 0;
+				prev_key.offset = 0;
 				goto again;
 			}
 			if (ret)
-- 
2.15.0



