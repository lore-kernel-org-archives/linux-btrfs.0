Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim2.fusionio.com ([66.114.96.54]:45118 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751972Ab3JWUYG (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 23 Oct 2013 16:24:06 -0400
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id B8CEC9A041F
	for <linux-btrfs@vger.kernel.org>; Wed, 23 Oct 2013 14:24:05 -0600 (MDT)
Received: from CAS2.int.fusionio.com (cas2.int.fusionio.com [10.101.1.41]) by mx1.fusionio.com with ESMTP id xERFjI4TDQJrvHMP (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-btrfs@vger.kernel.org>; Wed, 23 Oct 2013 14:24:04 -0600 (MDT)
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs-progs: add -b to btrfsck to look at backup roots
Date: Wed, 23 Oct 2013 16:24:03 -0400
Message-ID: <1382559843-13624-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

In some cases the tree root is so hosed we can't get anything useful out of it.
So add the -b option to btrfsck to make us look for the most recent backup tree
root to use for repair.  Then we can hopefully get ourselves into a working
state.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
 btrfs-debug-tree.c |  2 +-
 cmds-check.c       | 10 ++++++++--
 disk-io.c          | 54 ++++++++++++++++++++++++++++++++++++++++++++----------
 disk-io.h          |  5 +++--
 4 files changed, 56 insertions(+), 15 deletions(-)

diff --git a/btrfs-debug-tree.c b/btrfs-debug-tree.c
index 078dac5..4a9d89d 100644
--- a/btrfs-debug-tree.c
+++ b/btrfs-debug-tree.c
@@ -171,7 +171,7 @@ int main(int ac, char **av)
 	if (ac != 1)
 		print_usage();
 
-	info = open_ctree_fs_info(av[optind], 0, 0, 0, 1);
+	info = open_ctree_fs_info(av[optind], 0, 0, 0, 1, 0);
 	if (!info) {
 		fprintf(stderr, "unable to open %s\n", av[optind]);
 		exit(1);
diff --git a/cmds-check.c b/cmds-check.c
index a6047ea..69b0327 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -6024,6 +6024,7 @@ static struct option long_options[] = {
 	{ "repair", 0, NULL, 0 },
 	{ "init-csum-tree", 0, NULL, 0 },
 	{ "init-extent-tree", 0, NULL, 0 },
+	{ "backup", 0, NULL, 0 },
 	{ NULL, 0, NULL, 0}
 };
 
@@ -6032,6 +6033,7 @@ const char * const cmd_check_usage[] = {
 	"Check an unmounted btrfs filesystem.",
 	"",
 	"-s|--super <superblock>     use this superblock copy",
+	"-b|--backup                 use the backup root copy",
 	"--repair                    try to repair the filesystem",
 	"--init-csum-tree            create a new CRC tree",
 	"--init-extent-tree          create a new extent tree",
@@ -6045,6 +6047,7 @@ int cmd_check(int argc, char **argv)
 	struct btrfs_fs_info *info;
 	u64 bytenr = 0;
 	char uuidbuf[37];
+	int backup_root = 0;
 	int ret;
 	int num;
 	int option_index = 0;
@@ -6054,12 +6057,15 @@ int cmd_check(int argc, char **argv)
 
 	while(1) {
 		int c;
-		c = getopt_long(argc, argv, "as:", long_options,
+		c = getopt_long(argc, argv, "as:b", long_options,
 				&option_index);
 		if (c < 0)
 			break;
 		switch(c) {
 			case 'a': /* ignored */ break;
+			case 'b':
+				backup_root = 1;
+				break;
 			case 's':
 				num = atol(optarg);
 				bytenr = btrfs_sb_offset(num);
@@ -6101,7 +6107,7 @@ int cmd_check(int argc, char **argv)
 		return -EBUSY;
 	}
 
-	info = open_ctree_fs_info(argv[optind], bytenr, 0, rw, 1);
+	info = open_ctree_fs_info(argv[optind], bytenr, 0, rw, 1, backup_root);
 	if (!info) {
 		fprintf(stderr, "Couldn't open file system\n");
 		return -EIO;
diff --git a/disk-io.c b/disk-io.c
index ca76c42..733714d 100644
--- a/disk-io.c
+++ b/disk-io.c
@@ -808,8 +808,27 @@ int btrfs_check_fs_compatibility(struct btrfs_super_block *sb, int writable)
 	return 0;
 }
 
+static int find_best_backup_root(struct btrfs_super_block *super)
+{
+	struct btrfs_root_backup *backup;
+	u64 orig_gen = btrfs_super_generation(super);
+	u64 gen = 0;
+	int best_index = 0;
+	int i;
+
+	for (i = 0; i < BTRFS_NUM_BACKUP_ROOTS; i++) {
+		backup = super->super_roots + i;
+		if (btrfs_backup_tree_root_gen(backup) != orig_gen &&
+		    btrfs_backup_tree_root_gen(backup) > gen) {
+			best_index = i;
+			gen = btrfs_backup_tree_root_gen(backup);
+		}
+	}
+	return best_index;
+}
+
 int btrfs_setup_all_roots(struct btrfs_fs_info *fs_info,
-			  u64 root_tree_bytenr, int partial)
+			  u64 root_tree_bytenr, int partial, int backup_root)
 {
 	struct btrfs_super_block *sb = fs_info->super_copy;
 	struct btrfs_root *root;
@@ -833,8 +852,20 @@ int btrfs_setup_all_roots(struct btrfs_fs_info *fs_info,
 	blocksize = btrfs_level_size(root, btrfs_super_root_level(sb));
 	generation = btrfs_super_generation(sb);
 
-	if (!root_tree_bytenr)
+	if (!root_tree_bytenr && !backup_root) {
 		root_tree_bytenr = btrfs_super_root(sb);
+	} else if (backup_root) {
+		struct btrfs_root_backup *backup;
+		int index = find_best_backup_root(sb);
+		if (index >= BTRFS_NUM_BACKUP_ROOTS) {
+			fprintf(stderr, "Invalid backup root number\n");
+			return -EIO;
+		}
+		backup = fs_info->super_copy->super_roots + index;
+		root_tree_bytenr = btrfs_backup_tree_root(backup);
+		generation = btrfs_backup_tree_root_gen(backup);
+	}
+
 	root->node = read_tree_block(root, root_tree_bytenr, blocksize,
 				     generation);
 	if (!extent_buffer_uptodate(root->node)) {
@@ -1005,7 +1036,8 @@ static struct btrfs_fs_info *__open_ctree_fd(int fp, const char *path,
 					     u64 sb_bytenr,
 					     u64 root_tree_bytenr, int writes,
 					     int partial, int restore,
-					     int recover_super)
+					     int recover_super,
+					     int backup_root)
 {
 	struct btrfs_fs_info *fs_info;
 	struct btrfs_super_block *disk_super;
@@ -1068,7 +1100,8 @@ static struct btrfs_fs_info *__open_ctree_fd(int fp, const char *path,
 			   (unsigned long)btrfs_header_chunk_tree_uuid(eb),
 			   BTRFS_UUID_SIZE);
 
-	ret = btrfs_setup_all_roots(fs_info, root_tree_bytenr, partial);
+	ret = btrfs_setup_all_roots(fs_info, root_tree_bytenr, partial,
+				    backup_root);
 	if (ret)
 		goto out_failed;
 
@@ -1105,14 +1138,15 @@ struct btrfs_fs_info *open_ctree_fs_info_restore(const char *filename,
 		return NULL;
 	}
 	info = __open_ctree_fd(fp, filename, sb_bytenr, root_tree_bytenr,
-			       writes, partial, restore, 0);
+			       writes, partial, restore, 0, 0);
 	close(fp);
 	return info;
 }
 
 struct btrfs_fs_info *open_ctree_fs_info(const char *filename,
 					 u64 sb_bytenr, u64 root_tree_bytenr,
-					 int writes, int partial)
+					 int writes, int partial,
+					 int backup_root)
 {
 	int fp;
 	struct btrfs_fs_info *info;
@@ -1127,7 +1161,7 @@ struct btrfs_fs_info *open_ctree_fs_info(const char *filename,
 		return NULL;
 	}
 	info = __open_ctree_fd(fp, filename, sb_bytenr, root_tree_bytenr,
-			       writes, partial, 0, 0);
+			       writes, partial, 0, 0, backup_root);
 	close(fp);
 	return info;
 }
@@ -1148,7 +1182,7 @@ struct btrfs_root *open_ctree_with_broken_super(const char *filename,
 		return NULL;
 	}
 	info = __open_ctree_fd(fp, filename, sb_bytenr, 0,
-			       writes, 0, 0, 1);
+			       writes, 0, 0, 1, 0);
 	close(fp);
 	if (info)
 		return info->fs_root;
@@ -1159,7 +1193,7 @@ struct btrfs_root *open_ctree(const char *filename, u64 sb_bytenr, int writes)
 {
 	struct btrfs_fs_info *info;
 
-	info = open_ctree_fs_info(filename, sb_bytenr, 0, writes, 0);
+	info = open_ctree_fs_info(filename, sb_bytenr, 0, writes, 0, 0);
 	if (!info)
 		return NULL;
 	return info->fs_root;
@@ -1169,7 +1203,7 @@ struct btrfs_root *open_ctree_fd(int fp, const char *path, u64 sb_bytenr,
 				 int writes)
 {
 	struct btrfs_fs_info *info;
-	info = __open_ctree_fd(fp, path, sb_bytenr, 0, writes, 0, 0, 0);
+	info = __open_ctree_fd(fp, path, sb_bytenr, 0, writes, 0, 0, 0, 0);
 	if (!info)
 		return NULL;
 	return info->fs_root;
diff --git a/disk-io.h b/disk-io.h
index 6f2d4f4..b0292db 100644
--- a/disk-io.h
+++ b/disk-io.h
@@ -53,7 +53,7 @@ void btrfs_free_fs_info(struct btrfs_fs_info *fs_info);
 struct btrfs_fs_info *btrfs_new_fs_info(int writable, u64 sb_bytenr);
 int btrfs_check_fs_compatibility(struct btrfs_super_block *sb, int writable);
 int btrfs_setup_all_roots(struct btrfs_fs_info *fs_info,
-			  u64 root_tree_bytenr, int partial);
+			  u64 root_tree_bytenr, int partial, int backup_root);
 void btrfs_release_all_roots(struct btrfs_fs_info *fs_info);
 void btrfs_cleanup_all_caches(struct btrfs_fs_info *fs_info);
 int btrfs_scan_fs_devices(int fd, const char *path,
@@ -69,7 +69,8 @@ struct btrfs_fs_info *open_ctree_fs_info_restore(const char *filename,
 					 int writes, int partial);
 struct btrfs_fs_info *open_ctree_fs_info(const char *filename,
 					 u64 sb_bytenr, u64 root_tree_bytenr,
-					 int writes, int partial);
+					 int writes, int partial,
+					 int backup_root);
 struct btrfs_root *open_ctree_with_broken_super(const char *filename,
 					u64 sb_bytenr, int writes);
 int close_ctree(struct btrfs_root *root);
-- 
1.8.3.1

