Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim2.fusionio.com ([66.114.96.54]:48690 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751085Ab3HSRbC (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 19 Aug 2013 13:31:02 -0400
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id 960949A069F
	for <linux-btrfs@vger.kernel.org>; Mon, 19 Aug 2013 11:31:01 -0600 (MDT)
Received: from CAS2.int.fusionio.com (cas2.int.fusionio.com [10.101.1.41]) by mx1.fusionio.com with ESMTP id sT94e3qsoPHMI0t1 (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-btrfs@vger.kernel.org>; Mon, 19 Aug 2013 11:31:00 -0600 (MDT)
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs-progs: allow fsck to fix directory isize errors
Date: Mon, 19 Aug 2013 13:30:58 -0400
Message-ID: <1376933458-5323-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

A user reported a problem where he was unable to rmdir an empty directory.  This
is because his isize was wrong.  This patch will fix this sort of corruption and
allow him to rmdir his directory.  Thanks

Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
 cmds-check.c |   86 +++++++++++++++++++++++++++++++++++++++++++++++++++++----
 1 files changed, 80 insertions(+), 6 deletions(-)

diff --git a/cmds-check.c b/cmds-check.c
index dbb41e5..64712fa 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -221,6 +221,8 @@ struct walk_control {
 	int root_level;
 };
 
+static void reset_cached_block_groups(struct btrfs_fs_info *fs_info);
+
 static u8 imode_to_type(u32 imode)
 {
 #define S_SHIFT 12
@@ -1336,8 +1338,64 @@ out:
 	return ret;
 }
 
+static int try_repair_inode(struct btrfs_root *root, struct inode_record *rec)
+{
+	struct btrfs_trans_handle *trans;
+	struct btrfs_path *path;
+	struct btrfs_inode_item *ei;
+	struct btrfs_key key;
+	int ret;
+
+	/* So far we just fix dir isize wrong */
+	if (!(rec->errors & I_ERR_DIR_ISIZE_WRONG))
+		return 1;
+
+	path = btrfs_alloc_path();
+	if (!path)
+		return -ENOMEM;
+
+	trans = btrfs_start_transaction(root, 1);
+	if (IS_ERR(trans)) {
+		btrfs_free_path(path);
+		return PTR_ERR(trans);
+	}
+
+	key.objectid = rec->ino;
+	key.type = BTRFS_INODE_ITEM_KEY;
+	key.offset = (u64)-1;
+
+	ret = btrfs_search_slot(trans, root, &key, path, 0, 1);
+	if (ret < 0)
+		goto out;
+	if (ret) {
+		if (!path->slots[0]) {
+			ret = -ENOENT;
+			goto out;
+		}
+		path->slots[0]--;
+		ret = 0;
+	}
+	btrfs_item_key_to_cpu(path->nodes[0], &key, path->slots[0]);
+	if (key.objectid != rec->ino) {
+		ret = -ENOENT;
+		goto out;
+	}
+
+	ei = btrfs_item_ptr(path->nodes[0], path->slots[0],
+			    struct btrfs_inode_item);
+	btrfs_set_inode_size(path->nodes[0], ei, rec->found_size);
+	btrfs_mark_buffer_dirty(path->nodes[0]);
+	rec->errors &= ~I_ERR_DIR_ISIZE_WRONG;
+	printf("reset isize for dir %Lu root %Lu\n", rec->ino,
+	       root->root_key.objectid);
+out:
+	btrfs_commit_transaction(trans, root);
+	btrfs_free_path(path);
+	return ret;
+}
+
 static int check_inode_recs(struct btrfs_root *root,
-			    struct cache_tree *inode_cache)
+			    struct cache_tree *inode_cache, int repair)
 {
 	struct cache_extent *cache;
 	struct ptr_node *node;
@@ -1392,6 +1450,15 @@ static int check_inode_recs(struct btrfs_root *root,
 			}
 		}
 
+		if (repair) {
+			ret = try_repair_inode(root, rec);
+			if (ret == 0 && can_free_inode_rec(rec)) {
+				free_inode_rec(rec);
+				continue;
+			}
+			ret = 0;
+		}
+
 		error++;
 		if (!rec->found_inode_item)
 			rec->errors |= I_ERR_NO_INODE_ITEM;
@@ -1733,7 +1800,7 @@ static int process_root_ref(struct extent_buffer *eb, int slot,
 
 static int check_fs_root(struct btrfs_root *root,
 			 struct cache_tree *root_cache,
-			 struct walk_control *wc)
+			 struct walk_control *wc, int repair)
 {
 	int ret = 0;
 	int wret;
@@ -1803,7 +1870,7 @@ static int check_fs_root(struct btrfs_root *root,
 				root_node.current);
 	}
 
-	ret = check_inode_recs(root, &root_node.inode_cache);
+	ret = check_inode_recs(root, &root_node.inode_cache, repair);
 	return ret;
 }
 
@@ -1819,7 +1886,8 @@ static int fs_root_objectid(u64 objectid)
 }
 
 static int check_fs_roots(struct btrfs_root *root,
-			  struct cache_tree *root_cache)
+			  struct cache_tree *root_cache,
+			  int repair)
 {
 	struct btrfs_path path;
 	struct btrfs_key key;
@@ -1830,6 +1898,12 @@ static int check_fs_roots(struct btrfs_root *root,
 	int ret;
 	int err = 0;
 
+	/*
+	 * Just in case we made any changes to the extent tree that weren't
+	 * reflected into the free space cache yet.
+	 */
+	if (repair)
+		reset_cached_block_groups(root->fs_info);
 	memset(&wc, 0, sizeof(wc));
 	cache_tree_init(&wc.shared);
 	btrfs_init_path(&path);
@@ -1856,7 +1930,7 @@ static int check_fs_roots(struct btrfs_root *root,
 				err = 1;
 				goto next;
 			}
-			ret = check_fs_root(tmp_root, root_cache, &wc);
+			ret = check_fs_root(tmp_root, root_cache, &wc, repair);
 			if (ret)
 				err = 1;
 			btrfs_free_fs_root(tmp_root);
@@ -5815,7 +5889,7 @@ int cmd_check(int argc, char **argv)
 		goto out;
 
 	fprintf(stderr, "checking fs roots\n");
-	ret = check_fs_roots(root, &root_cache);
+	ret = check_fs_roots(root, &root_cache, repair);
 	if (ret)
 		goto out;
 
-- 
1.7.7.6

