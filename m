Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:11793 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751127AbcCGFAK (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 7 Mar 2016 00:00:10 -0500
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (unknown [10.167.33.80])
	by cn.fujitsu.com (Postfix) with ESMTP id C135342AC84B
	for <linux-btrfs@vger.kernel.org>; Mon,  7 Mar 2016 12:59:23 +0800 (CST)
From: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
Subject: [PATCH] btrfs-progs: Add new option for specify chunk root bytenr
Date: Mon, 7 Mar 2016 12:57:41 +0800
Message-ID: <1457326661-9646-2-git-send-email-lufq.fnst@cn.fujitsu.com>
In-Reply-To: <1457326661-9646-1-git-send-email-lufq.fnst@cn.fujitsu.com>
References: <1457326661-9646-1-git-send-email-lufq.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Add new btrfsck option, '--chunk-root', to specify chunk root bytenr.And
allow open_ctree_fs_info() function accept chunk_root_bytenr to override
the bytenr in superblock.This will be mainly used when chunk tree
corruption.

Signed-off-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
---
 btrfs-debug-tree.c |  2 +-
 btrfs-find-root.c  |  2 +-
 btrfs-image.c      |  4 ++--
 cmds-check.c       | 10 ++++++++--
 cmds-filesystem.c  |  2 +-
 cmds-restore.c     |  2 +-
 disk-io.c          | 27 +++++++++++++++++++++------
 disk-io.h          |  4 +++-
 8 files changed, 38 insertions(+), 15 deletions(-)

diff --git a/btrfs-debug-tree.c b/btrfs-debug-tree.c
index 266176f..206a52d 100644
--- a/btrfs-debug-tree.c
+++ b/btrfs-debug-tree.c
@@ -196,7 +196,7 @@ int main(int ac, char **av)
 		exit(1);
 	}
 
-	info = open_ctree_fs_info(av[optind], 0, 0, OPEN_CTREE_PARTIAL);
+	info = open_ctree_fs_info(av[optind], 0, 0, 0, OPEN_CTREE_PARTIAL);
 	if (!info) {
 		fprintf(stderr, "unable to open %s\n", av[optind]);
 		exit(1);
diff --git a/btrfs-find-root.c b/btrfs-find-root.c
index 2d5bbb2..4319b24 100644
--- a/btrfs-find-root.c
+++ b/btrfs-find-root.c
@@ -191,7 +191,7 @@ int main(int argc, char **argv)
 		exit(1);
 	}
 
-	fs_info = open_ctree_fs_info(argv[optind], 0, 0,
+	fs_info = open_ctree_fs_info(argv[optind], 0, 0, 0,
 			OPEN_CTREE_CHUNK_ROOT_ONLY |
 			OPEN_CTREE_IGNORE_CHUNK_TREE_ERROR);
 	if (!fs_info) {
diff --git a/btrfs-image.c b/btrfs-image.c
index c7fa18f..685ac3a 100644
--- a/btrfs-image.c
+++ b/btrfs-image.c
@@ -2471,7 +2471,7 @@ static int restore_metadump(const char *input, FILE *out, int old_restore,
 	/* NOTE: open with write mode */
 	if (fixup_offset) {
 		BUG_ON(!target);
-		info = open_ctree_fs_info(target, 0, 0,
+		info = open_ctree_fs_info(target, 0, 0, 0,
 					  OPEN_CTREE_WRITES |
 					  OPEN_CTREE_RESTORE |
 					  OPEN_CTREE_PARTIAL);
@@ -2818,7 +2818,7 @@ int main(int argc, char *argv[])
 		u64 total_devs;
 		int i;
 
-		info = open_ctree_fs_info(target, 0, 0,
+		info = open_ctree_fs_info(target, 0, 0, 0,
 					  OPEN_CTREE_PARTIAL |
 					  OPEN_CTREE_RESTORE);
 		if (!info) {
diff --git a/cmds-check.c b/cmds-check.c
index 0165fba..cb12efa 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -9480,6 +9480,7 @@ const char * const cmd_check_usage[] = {
 	"-E|--subvol-extents <subvolid>",
 	"                            print subvolume extents and sharing state",
 	"-r|--tree-root <bytenr>     use the given bytenr for the tree root",
+	"-c|--chunk-root <bytenr>    use the given bytenr for the chunk tree root",
 	"-p|--progress               indicate progress",
 	NULL
 };
@@ -9492,6 +9493,7 @@ int cmd_check(int argc, char **argv)
 	u64 bytenr = 0;
 	u64 subvolid = 0;
 	u64 tree_root_bytenr = 0;
+	u64 chunk_root_bytenr = 0;
 	char uuidbuf[BTRFS_UUID_UNPARSED_SIZE];
 	int ret;
 	u64 num;
@@ -9515,11 +9517,12 @@ int cmd_check(int argc, char **argv)
 			{ "subvol-extents", required_argument, NULL, 'E' },
 			{ "qgroup-report", no_argument, NULL, 'Q' },
 			{ "tree-root", required_argument, NULL, 'r' },
+			{ "chunk-root", required_argument, NULL, 'c' },
 			{ "progress", no_argument, NULL, 'p' },
 			{ NULL, 0, NULL, 0}
 		};
 
-		c = getopt_long(argc, argv, "as:br:p", long_options, NULL);
+		c = getopt_long(argc, argv, "as:br:pc:", long_options, NULL);
 		if (c < 0)
 			break;
 		switch(c) {
@@ -9548,6 +9551,9 @@ int cmd_check(int argc, char **argv)
 			case 'r':
 				tree_root_bytenr = arg_strtou64(optarg);
 				break;
+			case 'c':
+				chunk_root_bytenr = arg_strtou64(optarg);
+				break;
 			case 'p':
 				ctx.progress_enabled = true;
 				break;
@@ -9612,7 +9618,7 @@ int cmd_check(int argc, char **argv)
 		ctree_flags |= OPEN_CTREE_PARTIAL;
 
 	info = open_ctree_fs_info(argv[optind], bytenr, tree_root_bytenr,
-				  ctree_flags);
+				  chunk_root_bytenr, ctree_flags);
 	if (!info) {
 		fprintf(stderr, "Couldn't open file system\n");
 		ret = -EIO;
diff --git a/cmds-filesystem.c b/cmds-filesystem.c
index 4c6e856..6a0d9d3 100644
--- a/cmds-filesystem.c
+++ b/cmds-filesystem.c
@@ -718,7 +718,7 @@ static int map_seed_devices(struct list_head *all_uuids)
 		/*
 		 * open_ctree_* detects seed/sprout mapping
 		 */
-		fs_info = open_ctree_fs_info(device->name, 0, 0,
+		fs_info = open_ctree_fs_info(device->name, 0, 0, 0,
 						OPEN_CTREE_PARTIAL);
 		if (!fs_info)
 			continue;
diff --git a/cmds-restore.c b/cmds-restore.c
index dd0b242..3b3c855 100644
--- a/cmds-restore.c
+++ b/cmds-restore.c
@@ -1265,7 +1265,7 @@ static struct btrfs_root *open_fs(const char *dev, u64 root_location,
 
 	for (i = super_mirror; i < BTRFS_SUPER_MIRROR_MAX; i++) {
 		bytenr = btrfs_sb_offset(i);
-		fs_info = open_ctree_fs_info(dev, bytenr, root_location,
+		fs_info = open_ctree_fs_info(dev, bytenr, root_location, 0,
 					     OPEN_CTREE_PARTIAL);
 		if (fs_info)
 			break;
diff --git a/disk-io.c b/disk-io.c
index e520d80..88015b7 100644
--- a/disk-io.c
+++ b/disk-io.c
@@ -1146,7 +1146,8 @@ int btrfs_scan_fs_devices(int fd, const char *path,
 	return 0;
 }
 
-int btrfs_setup_chunk_tree_and_device_map(struct btrfs_fs_info *fs_info)
+int btrfs_setup_chunk_tree_and_device_map(struct btrfs_fs_info *fs_info,
+					  u64 chunk_root_bytenr)
 {
 	struct btrfs_super_block *sb = fs_info->super_copy;
 	u32 sectorsize;
@@ -1173,8 +1174,20 @@ int btrfs_setup_chunk_tree_and_device_map(struct btrfs_fs_info *fs_info)
 				     btrfs_super_chunk_root_level(sb));
 	generation = btrfs_super_chunk_root_generation(sb);
 
+	if (chunk_root_bytenr && !IS_ALIGNED(chunk_root_bytenr,
+					    btrfs_super_sectorsize(sb))) {
+		warning("chunk_root_bytenr %llu is unaligned to %u, ignore it",
+			chunk_root_bytenr, btrfs_super_sectorsize(sb));
+		chunk_root_bytenr = 0;
+	}
+
+	if (!chunk_root_bytenr)
+		chunk_root_bytenr = btrfs_super_chunk_root(sb);
+	else
+		generation = 0;
+
 	fs_info->chunk_root->node = read_tree_block(fs_info->chunk_root,
-						    btrfs_super_chunk_root(sb),
+						    chunk_root_bytenr,
 						    blocksize, generation);
 	if (!extent_buffer_uptodate(fs_info->chunk_root->node)) {
 		if (fs_info->ignore_chunk_tree_error) {
@@ -1200,6 +1213,7 @@ int btrfs_setup_chunk_tree_and_device_map(struct btrfs_fs_info *fs_info)
 static struct btrfs_fs_info *__open_ctree_fd(int fp, const char *path,
 					     u64 sb_bytenr,
 					     u64 root_tree_bytenr,
+					     u64 chunk_root_bytenr,
 					     enum btrfs_open_ctree_flags flags)
 {
 	struct btrfs_fs_info *fs_info;
@@ -1273,7 +1287,7 @@ static struct btrfs_fs_info *__open_ctree_fd(int fp, const char *path,
 	if (ret)
 		goto out_devices;
 
-	ret = btrfs_setup_chunk_tree_and_device_map(fs_info);
+	ret = btrfs_setup_chunk_tree_and_device_map(fs_info, chunk_root_bytenr);
 	if (ret)
 		goto out_chunk;
 
@@ -1305,6 +1319,7 @@ out:
 
 struct btrfs_fs_info *open_ctree_fs_info(const char *filename,
 					 u64 sb_bytenr, u64 root_tree_bytenr,
+					 u64 chunk_root_bytenr,
 					 enum btrfs_open_ctree_flags flags)
 {
 	int fp;
@@ -1320,7 +1335,7 @@ struct btrfs_fs_info *open_ctree_fs_info(const char *filename,
 		return NULL;
 	}
 	info = __open_ctree_fd(fp, filename, sb_bytenr, root_tree_bytenr,
-			       flags);
+			       chunk_root_bytenr, flags);
 	close(fp);
 	return info;
 }
@@ -1332,7 +1347,7 @@ struct btrfs_root *open_ctree(const char *filename, u64 sb_bytenr,
 
 	/* This flags may not return fs_info with any valid root */
 	BUG_ON(flags & OPEN_CTREE_IGNORE_CHUNK_TREE_ERROR);
-	info = open_ctree_fs_info(filename, sb_bytenr, 0, flags);
+	info = open_ctree_fs_info(filename, sb_bytenr, 0, 0, flags);
 	if (!info)
 		return NULL;
 	if (flags & __OPEN_CTREE_RETURN_CHUNK_ROOT)
@@ -1347,7 +1362,7 @@ struct btrfs_root *open_ctree_fd(int fp, const char *path, u64 sb_bytenr,
 
 	/* This flags may not return fs_info with any valid root */
 	BUG_ON(flags & OPEN_CTREE_IGNORE_CHUNK_TREE_ERROR);
-	info = __open_ctree_fd(fp, path, sb_bytenr, 0, flags);
+	info = __open_ctree_fd(fp, path, sb_bytenr, 0, 0, flags);
 	if (!info)
 		return NULL;
 	if (flags & __OPEN_CTREE_RETURN_CHUNK_ROOT)
diff --git a/disk-io.h b/disk-io.h
index 30ccb2b..b97b90b 100644
--- a/disk-io.h
+++ b/disk-io.h
@@ -109,7 +109,8 @@ void btrfs_cleanup_all_caches(struct btrfs_fs_info *fs_info);
 int btrfs_scan_fs_devices(int fd, const char *path,
 			  struct btrfs_fs_devices **fs_devices, u64 sb_bytenr,
 			  int super_recover, int skip_devices);
-int btrfs_setup_chunk_tree_and_device_map(struct btrfs_fs_info *fs_info);
+int btrfs_setup_chunk_tree_and_device_map(struct btrfs_fs_info *fs_info,
+			  u64 chunk_root_bytenr);
 
 struct btrfs_root *open_ctree(const char *filename, u64 sb_bytenr,
 			      enum btrfs_open_ctree_flags flags);
@@ -117,6 +118,7 @@ struct btrfs_root *open_ctree_fd(int fp, const char *path, u64 sb_bytenr,
 				 enum btrfs_open_ctree_flags flags);
 struct btrfs_fs_info *open_ctree_fs_info(const char *filename,
 					 u64 sb_bytenr, u64 root_tree_bytenr,
+					 u64 chunk_root_bytenr,
 					 enum btrfs_open_ctree_flags flags);
 int close_ctree_fs_info(struct btrfs_fs_info *fs_info);
 static inline int close_ctree(struct btrfs_root *root)
-- 
2.5.0



