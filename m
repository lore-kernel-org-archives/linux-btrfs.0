Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim2.fusionio.com ([66.114.96.54]:57974 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933166Ab3CLRb0 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 12 Mar 2013 13:31:26 -0400
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id B00279A0370
	for <linux-btrfs@vger.kernel.org>; Tue, 12 Mar 2013 11:31:25 -0600 (MDT)
Received: from mail1.int.fusionio.com (mail1.int.fusionio.com [10.101.1.21]) by mx2.fusionio.com with ESMTP id iWqH5ZVQCRyzg7bm (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-btrfs@vger.kernel.org>; Tue, 12 Mar 2013 11:31:24 -0600 (MDT)
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 10/10] Btrfs-progs: make restore deal with really broken file systems
Date: Tue, 12 Mar 2013 13:38:17 -0400
Message-ID: <1363109897-7931-11-git-send-email-jbacik@fusionio.com>
In-Reply-To: <1363109897-7931-1-git-send-email-jbacik@fusionio.com>
References: <1363109897-7931-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

All we need for restore to work is the chunk root, the tree root and the fs root
we want to restore from.  So to do this we need to make a few adjustments

1) Make open_ctree_fs_info fail completely if it can't read the chunk tree.
There is no sense in continuing if we can't read the chunk tree since we won't
be able to translate logical to physical blocks.

2) Use open_ctree_fs_info in restore, and if we didn't load a tree root or
fs root go ahead and try to set those up manually ourselves.

This is related to work I did last year on restore, but it uses the
open_ctree_fs_info instead of my open coded open_ctree.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
 cmds-check.c   |    2 +-
 cmds-restore.c |   52 ++++++++++++++++++++++++++++++++++++++++++++++------
 debug-tree.c   |    2 +-
 disk-io.c      |   37 ++++++++++---------------------------
 disk-io.h      |    6 ++----
 5 files changed, 60 insertions(+), 39 deletions(-)

diff --git a/cmds-check.c b/cmds-check.c
index 12192fa..bdf74ba 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -3609,7 +3609,7 @@ int cmd_check(int argc, char **argv)
 		return -EBUSY;
 	}
 
-	info = open_ctree_fs_info(argv[optind], bytenr, rw, 1);
+	info = open_ctree_fs_info(argv[optind], bytenr, 0, rw, 1);
 	if (info == NULL)
 		return 1;
 
diff --git a/cmds-restore.c b/cmds-restore.c
index f4e75cf..4760672 100644
--- a/cmds-restore.c
+++ b/cmds-restore.c
@@ -839,27 +839,67 @@ static int do_list_roots(struct btrfs_root *root)
 static struct btrfs_root *open_fs(const char *dev, u64 root_location,
 				  int super_mirror, int list_roots)
 {
+	struct btrfs_fs_info *fs_info = NULL;
 	struct btrfs_root *root = NULL;
 	u64 bytenr;
 	int i;
 
 	for (i = super_mirror; i < BTRFS_SUPER_MIRROR_MAX; i++) {
 		bytenr = btrfs_sb_offset(i);
-		root = open_ctree_recovery(dev, bytenr, root_location);
-		if (root)
+		fs_info = open_ctree_fs_info(dev, bytenr, root_location, 0, 1);
+		if (fs_info)
 			break;
 		fprintf(stderr, "Could not open root, trying backup super\n");
 	}
 
-	if (root && list_roots) {
-		int ret = do_list_roots(root);
-		if (ret) {
+	if (!fs_info)
+		return NULL;
+
+	/*
+	 * All we really need to succeed is reading the chunk tree, everything
+	 * else we can do by hand, since we only need to read the tree root and
+	 * the fs_root.
+	 */
+	if (!extent_buffer_uptodate(fs_info->tree_root->node)) {
+		u64 generation;
+
+		root = fs_info->tree_root;
+		if (!root_location)
+			root_location = btrfs_super_root(fs_info->super_copy);
+		generation = btrfs_super_generation(fs_info->super_copy);
+		root->node = read_tree_block(root, root_location,
+					     root->leafsize, generation);
+		if (!extent_buffer_uptodate(root->node)) {
+			fprintf(stderr, "Error opening tree root\n");
 			close_ctree(root);
+			return NULL;
+		}
+	}
+
+	if (!list_roots && !fs_info->fs_root) {
+		struct btrfs_key key;
+
+		key.objectid = BTRFS_FS_TREE_OBJECTID;
+		key.type = BTRFS_ROOT_ITEM_KEY;
+		key.offset = (u64)-1;
+		fs_info->fs_root = btrfs_read_fs_root_no_cache(fs_info, &key);
+		if (IS_ERR(fs_info->fs_root)) {
+			fprintf(stderr, "Couldn't read fs root: %ld\n",
+				PTR_ERR(fs_info->fs_root));
+			close_ctree(fs_info->tree_root);
+			return NULL;
+		}
+	}
+
+	if (list_roots) {
+		int ret = do_list_roots(fs_info->tree_root);
+		if (ret) {
+			close_ctree(fs_info->tree_root);
 			root = NULL;
 		}
 	}
 
-	return root;
+	return fs_info->fs_root;
 }
 
 static int find_first_dir(struct btrfs_root *root, u64 *objectid)
diff --git a/debug-tree.c b/debug-tree.c
index 0fc0ecd..bae7f94 100644
--- a/debug-tree.c
+++ b/debug-tree.c
@@ -166,7 +166,7 @@ int main(int ac, char **av)
 	if (ac != 1)
 		print_usage();
 
-	info = open_ctree_fs_info(av[optind], 0, 0, 1);
+	info = open_ctree_fs_info(av[optind], 0, 0, 0, 1);
 	if (!info) {
 		fprintf(stderr, "unable to open %s\n", av[optind]);
 		exit(1);
diff --git a/disk-io.c b/disk-io.c
index a9fd374..5265c3c 100644
--- a/disk-io.c
+++ b/disk-io.c
@@ -944,8 +944,10 @@ static struct btrfs_fs_info *__open_ctree_fd(int fp, const char *path,
 
 	if (!(btrfs_super_flags(disk_super) & BTRFS_SUPER_FLAG_METADUMP)) {
 		ret = btrfs_read_chunk_tree(chunk_root);
-		if (ret)
-			goto out_failed;
+		if (ret) {
+			printk("Couldn't read chunk tree\n");
+			goto out_chunk;
+		}
 	}
 
 	blocksize = btrfs_level_size(tree_root,
@@ -1018,6 +1020,7 @@ out_failed:
 		free_extent_buffer(fs_info->extent_root->node);
 	if (fs_info->tree_root)
 		free_extent_buffer(fs_info->tree_root->node);
+out_chunk:
 	if (fs_info->chunk_root)
 		free_extent_buffer(fs_info->chunk_root->node);
 out_devices:
@@ -1040,8 +1043,8 @@ out:
 }
 
 struct btrfs_fs_info *open_ctree_fs_info(const char *filename,
-					 u64 sb_bytenr, int writes,
-					 int partial)
+					 u64 sb_bytenr, u64 root_tree_bytenr,
+					 int writes, int partial)
 {
 	int fp;
 	struct btrfs_fs_info *info;
@@ -1055,7 +1058,8 @@ struct btrfs_fs_info *open_ctree_fs_info(const char *filename,
 		fprintf (stderr, "Could not open %s\n", filename);
 		return NULL;
 	}
-	info = __open_ctree_fd(fp, filename, sb_bytenr, 0, writes, partial);
+	info = __open_ctree_fd(fp, filename, sb_bytenr, root_tree_bytenr,
+			       writes, partial);
 	close(fp);
 	return info;
 }
@@ -1064,28 +1068,7 @@ struct btrfs_root *open_ctree(const char *filename, u64 sb_bytenr, int writes)
 {
 	struct btrfs_fs_info *info;
 
-	info = open_ctree_fs_info(filename, sb_bytenr, writes, 0);
-	if (!info)
-		return NULL;
-	return info->fs_root;
-}
-
-struct btrfs_root *open_ctree_recovery(const char *filename, u64 sb_bytenr,
-				       u64 root_tree_bytenr)
-{
-	int fp;
-	struct btrfs_fs_info *info;
-
-
-	fp = open(filename, O_RDONLY);
-	if (fp < 0) {
-		fprintf (stderr, "Could not open %s\n", filename);
-		return NULL;
-	}
-	info = __open_ctree_fd(fp, filename, sb_bytenr,
-			       root_tree_bytenr, 0, 0);
-	close(fp);
-
+	info = open_ctree_fs_info(filename, sb_bytenr, 0, writes, 0);
 	if (!info)
 		return NULL;
 	return info->fs_root;
diff --git a/disk-io.h b/disk-io.h
index ff87958..c29ee8e 100644
--- a/disk-io.h
+++ b/disk-io.h
@@ -50,11 +50,9 @@ int clean_tree_block(struct btrfs_trans_handle *trans,
 struct btrfs_root *open_ctree(const char *filename, u64 sb_bytenr, int writes);
 struct btrfs_root *open_ctree_fd(int fp, const char *path, u64 sb_bytenr,
 				 int writes);
-struct btrfs_root *open_ctree_recovery(const char *filename, u64 sb_bytenr,
-				       u64 root_tree_bytenr);
 struct btrfs_fs_info *open_ctree_fs_info(const char *filename,
-					 u64 sb_bytenr, int writes,
-					 int partial);
+					 u64 sb_bytenr, u64 root_tree_bytenr,
+					 int writes, int partial);
 int close_ctree(struct btrfs_root *root);
 int write_all_supers(struct btrfs_root *root);
 int write_ctree_super(struct btrfs_trans_handle *trans,
-- 
1.7.7.6

