Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:48288 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755892Ab3I3UPZ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 30 Sep 2013 16:15:25 -0400
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id 4F68E7C0445
	for <linux-btrfs@vger.kernel.org>; Mon, 30 Sep 2013 14:15:25 -0600 (MDT)
Received: from CAS1.int.fusionio.com (cas1.int.fusionio.com [10.101.1.40]) by mx1.fusionio.com with ESMTP id bHXbfJOkbJ3Py9wJ (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-btrfs@vger.kernel.org>; Mon, 30 Sep 2013 14:15:24 -0600 (MDT)
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs-progs: make the repair option a global static var
Date: Mon, 30 Sep 2013 16:15:22 -0400
Message-ID: <1380572122-1291-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

It's just annoying to have to pass it around everywhere.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
 cmds-check.c | 23 +++++++++++------------
 1 file changed, 11 insertions(+), 12 deletions(-)

diff --git a/cmds-check.c b/cmds-check.c
index f05c73e..6da35ea 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -49,6 +49,7 @@ static u64 data_bytes_allocated = 0;
 static u64 data_bytes_referenced = 0;
 static int found_old_backref = 0;
 static LIST_HEAD(duplicate_extents);
+static int repair = 0;
 
 struct extent_backref {
 	struct list_head list;
@@ -1404,7 +1405,7 @@ out:
 }
 
 static int check_inode_recs(struct btrfs_root *root,
-			    struct cache_tree *inode_cache, int repair)
+			    struct cache_tree *inode_cache)
 {
 	struct cache_extent *cache;
 	struct ptr_node *node;
@@ -1809,7 +1810,7 @@ static int process_root_ref(struct extent_buffer *eb, int slot,
 
 static int check_fs_root(struct btrfs_root *root,
 			 struct cache_tree *root_cache,
-			 struct walk_control *wc, int repair)
+			 struct walk_control *wc)
 {
 	int ret = 0;
 	int wret;
@@ -1879,7 +1880,7 @@ static int check_fs_root(struct btrfs_root *root,
 				root_node.current);
 	}
 
-	ret = check_inode_recs(root, &root_node.inode_cache, repair);
+	ret = check_inode_recs(root, &root_node.inode_cache);
 	return ret;
 }
 
@@ -1895,8 +1896,7 @@ static int fs_root_objectid(u64 objectid)
 }
 
 static int check_fs_roots(struct btrfs_root *root,
-			  struct cache_tree *root_cache,
-			  int repair)
+			  struct cache_tree *root_cache)
 {
 	struct btrfs_path path;
 	struct btrfs_key key;
@@ -1939,7 +1939,7 @@ static int check_fs_roots(struct btrfs_root *root,
 				err = 1;
 				goto next;
 			}
-			ret = check_fs_root(tmp_root, root_cache, &wc, repair);
+			ret = check_fs_root(tmp_root, root_cache, &wc);
 			if (ret)
 				err = 1;
 			btrfs_free_fs_root(tmp_root);
@@ -5009,7 +5009,7 @@ static void reset_cached_block_groups(struct btrfs_fs_info *fs_info)
 
 static int check_extent_refs(struct btrfs_trans_handle *trans,
 			     struct btrfs_root *root,
-			     struct cache_tree *extent_cache, int repair)
+			     struct cache_tree *extent_cache)
 {
 	struct extent_record *rec;
 	struct cache_extent *cache;
@@ -5403,7 +5403,7 @@ static int check_devices(struct rb_root *dev_cache,
 	return ret;
 }
 
-static int check_chunks_and_extents(struct btrfs_root *root, int repair)
+static int check_chunks_and_extents(struct btrfs_root *root)
 {
 	struct rb_root dev_cache;
 	struct cache_tree chunk_cache;
@@ -5510,7 +5510,7 @@ again:
 			break;
 	}
 
-	ret = check_extent_refs(trans, root, &extent_cache, repair);
+	ret = check_extent_refs(trans, root, &extent_cache);
 	if (ret == -EAGAIN) {
 		ret = btrfs_commit_transaction(trans, root);
 		if (ret)
@@ -5982,7 +5982,6 @@ int cmd_check(int argc, char **argv)
 	char uuidbuf[37];
 	int ret;
 	int num;
-	int repair = 0;
 	int option_index = 0;
 	int init_csum_tree = 0;
 	int init_extent_tree = 0;
@@ -6084,7 +6083,7 @@ int cmd_check(int argc, char **argv)
 			exit(1);
 		goto out;
 	}
-	ret = check_chunks_and_extents(root, repair);
+	ret = check_chunks_and_extents(root);
 	if (ret)
 		fprintf(stderr, "Errors found in extent allocation tree or chunk allocation\n");
 
@@ -6094,7 +6093,7 @@ int cmd_check(int argc, char **argv)
 		goto out;
 
 	fprintf(stderr, "checking fs roots\n");
-	ret = check_fs_roots(root, &root_cache, repair);
+	ret = check_fs_roots(root, &root_cache);
 	if (ret)
 		goto out;
 
-- 
1.8.3.1

