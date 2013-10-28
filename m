Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:51866 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757426Ab3J1S2q (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 28 Oct 2013 14:28:46 -0400
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id 1C3FC7C0348
	for <linux-btrfs@vger.kernel.org>; Mon, 28 Oct 2013 12:28:46 -0600 (MDT)
Received: from CAS1.int.fusionio.com (cas1.int.fusionio.com [10.101.1.40]) by mx1.fusionio.com with ESMTP id CbYpl0FbXt0yCDc9 (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-btrfs@vger.kernel.org>; Mon, 28 Oct 2013 12:28:44 -0600 (MDT)
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs-progs: rework open_ctree to take flags, add a new one V2
Date: Mon, 28 Oct 2013 14:28:43 -0400
Message-ID: <1382984923-29797-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

So I needed to add a flag to not try to read block groups when doing
--init-extent-tree since we could hang there, but that meant adding a whole
other 0/1 type flag to open_ctree_fs_info.  So instead I've converted it all
over to using a flags setting and added the flag that I needed.  This has been
tested with xfstests and make test.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
V1->V2: forgot to make clean first, I missed converting one of the users

 btrfs-convert.c       |   6 +--
 btrfs-corrupt-block.c |   2 +-
 btrfs-debug-tree.c    |   2 +-
 btrfs-image.c         |   9 ++++-
 btrfs-zero-log.c      |   2 +-
 btrfstune.c           |   2 +-
 cmds-check.c          |  14 +++----
 cmds-restore.c        |   3 +-
 disk-io.c             | 107 ++++++++++++++------------------------------------
 disk-io.h             |  26 ++++++------
 mkfs.c                |   2 +-
 quick-test.c          |  10 ++---
 super-recover.c       |   4 +-
 utils.c               |   2 +-
 14 files changed, 77 insertions(+), 114 deletions(-)

diff --git a/btrfs-convert.c b/btrfs-convert.c
index 26c7b5f..ae10eed 100644
--- a/btrfs-convert.c
+++ b/btrfs-convert.c
@@ -2256,7 +2256,7 @@ static int do_convert(const char *devname, int datacsum, int packing,
 		fprintf(stderr, "unable to update system chunk\n");
 		goto fail;
 	}
-	root = open_ctree_fd(fd, devname, super_bytenr, O_RDWR);
+	root = open_ctree_fd(fd, devname, super_bytenr, OPEN_CTREE_WRITES);
 	if (!root) {
 		fprintf(stderr, "unable to open ctree\n");
 		goto fail;
@@ -2317,7 +2317,7 @@ static int do_convert(const char *devname, int datacsum, int packing,
 		goto fail;
 	}
 
-	root = open_ctree_fd(fd, devname, 0, O_RDWR);
+	root = open_ctree_fd(fd, devname, 0, OPEN_CTREE_WRITES);
 	if (!root) {
 		fprintf(stderr, "unable to open ctree\n");
 		goto fail;
@@ -2418,7 +2418,7 @@ static int do_rollback(const char *devname, int force)
 		fprintf(stderr, "unable to open %s\n", devname);
 		goto fail;
 	}
-	root = open_ctree_fd(fd, devname, 0, O_RDWR);
+	root = open_ctree_fd(fd, devname, 0, OPEN_CTREE_WRITES);
 	if (!root) {
 		fprintf(stderr, "unable to open ctree\n");
 		goto fail;
diff --git a/btrfs-corrupt-block.c b/btrfs-corrupt-block.c
index b40a529..f0c14a9 100644
--- a/btrfs-corrupt-block.c
+++ b/btrfs-corrupt-block.c
@@ -799,7 +799,7 @@ int main(int ac, char **av)
 	radix_tree_init();
 	cache_tree_init(&root_cache);
 
-	root = open_ctree(dev, 0, 1);
+	root = open_ctree(dev, 0, OPEN_CTREE_WRITES);
 	if (!root) {
 		fprintf(stderr, "Open ctree failed\n");
 		exit(1);
diff --git a/btrfs-debug-tree.c b/btrfs-debug-tree.c
index 4a9d89d..4a83770 100644
--- a/btrfs-debug-tree.c
+++ b/btrfs-debug-tree.c
@@ -171,7 +171,7 @@ int main(int ac, char **av)
 	if (ac != 1)
 		print_usage();
 
-	info = open_ctree_fs_info(av[optind], 0, 0, 0, 1, 0);
+	info = open_ctree_fs_info(av[optind], 0, 0, OPEN_CTREE_PARTIAL);
 	if (!info) {
 		fprintf(stderr, "unable to open %s\n", av[optind]);
 		exit(1);
diff --git a/btrfs-image.c b/btrfs-image.c
index 40ed483..7bcfc06 100644
--- a/btrfs-image.c
+++ b/btrfs-image.c
@@ -2267,7 +2267,10 @@ static int __restore_metadump(const char *input, FILE *out, int old_restore,
 	/* NOTE: open with write mode */
 	if (fixup_offset) {
 		BUG_ON(!target);
-		info = open_ctree_fs_info_restore(target, 0, 0, 1, 1);
+		info = open_ctree_fs_info(target, 0, 0,
+					  OPEN_CTREE_WRITES |
+					  OPEN_CTREE_RESTORE |
+					  OPEN_CTREE_PARTIAL);
 		if (!info) {
 			fprintf(stderr, "%s: open ctree failed\n", __func__);
 			ret = -EIO;
@@ -2555,7 +2558,9 @@ int main(int argc, char *argv[])
 		u64 total_devs;
 		int i;
 
-		info = open_ctree_fs_info_restore(target, 0, 0, 0, 1);
+		info = open_ctree_fs_info(target, 0, 0,
+					  OPEN_CTREE_PARTIAL |
+					  OPEN_CTREE_RESTORE);
 		if (!info) {
 			int e = errno;
 			fprintf(stderr, "unable to open %s error = %s\n",
diff --git a/btrfs-zero-log.c b/btrfs-zero-log.c
index 432adff..ab7f418 100644
--- a/btrfs-zero-log.c
+++ b/btrfs-zero-log.c
@@ -60,7 +60,7 @@ int main(int ac, char **av)
 		goto out;
 	}
 
-	root = open_ctree(av[1], 0, 1);
+	root = open_ctree(av[1], 0, OPEN_CTREE_WRITES);
 
 	if (root == NULL)
 		return 1;
diff --git a/btrfstune.c b/btrfstune.c
index 1cf6a68..50724ba 100644
--- a/btrfstune.c
+++ b/btrfstune.c
@@ -148,7 +148,7 @@ int main(int argc, char *argv[])
 		return 1;
 	}
 
-	root = open_ctree(device, 0, 1);
+	root = open_ctree(device, 0, OPEN_CTREE_WRITES);
 
 	if (!root) {
 		fprintf(stderr, "Open ctree failed\n");
diff --git a/cmds-check.c b/cmds-check.c
index 8ed7baa..b27154f 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -6047,13 +6047,12 @@ int cmd_check(int argc, char **argv)
 	struct btrfs_fs_info *info;
 	u64 bytenr = 0;
 	char uuidbuf[37];
-	int backup_root = 0;
 	int ret;
 	int num;
 	int option_index = 0;
 	int init_csum_tree = 0;
 	int init_extent_tree = 0;
-	int rw = 0;
+	enum btrfs_open_ctree_flags ctree_flags = OPEN_CTREE_PARTIAL;
 
 	while(1) {
 		int c;
@@ -6064,7 +6063,7 @@ int cmd_check(int argc, char **argv)
 		switch(c) {
 			case 'a': /* ignored */ break;
 			case 'b':
-				backup_root = 1;
+				ctree_flags |= OPEN_CTREE_BACKUP_ROOT;
 				break;
 			case 's':
 				num = atol(optarg);
@@ -6079,14 +6078,15 @@ int cmd_check(int argc, char **argv)
 		if (option_index == 1) {
 			printf("enabling repair mode\n");
 			repair = 1;
-			rw = 1;
+			ctree_flags |= OPEN_CTREE_WRITES;
 		} else if (option_index == 2) {
 			printf("Creating a new CRC tree\n");
 			init_csum_tree = 1;
-			rw = 1;
+			ctree_flags |= OPEN_CTREE_WRITES;
 		} else if (option_index == 3) {
 			init_extent_tree = 1;
-			rw = 1;
+			ctree_flags |= (OPEN_CTREE_WRITES |
+					OPEN_CTREE_NO_BLOCK_GROUPS);
 			repair = 1;
 		}
 
@@ -6107,7 +6107,7 @@ int cmd_check(int argc, char **argv)
 		return -EBUSY;
 	}
 
-	info = open_ctree_fs_info(argv[optind], bytenr, 0, rw, 1, backup_root);
+	info = open_ctree_fs_info(argv[optind], bytenr, 0, ctree_flags);
 	if (!info) {
 		fprintf(stderr, "Couldn't open file system\n");
 		return -EIO;
diff --git a/cmds-restore.c b/cmds-restore.c
index ae0527b..1748262 100644
--- a/cmds-restore.c
+++ b/cmds-restore.c
@@ -974,7 +974,8 @@ static struct btrfs_root *open_fs(const char *dev, u64 root_location,
 
 	for (i = super_mirror; i < BTRFS_SUPER_MIRROR_MAX; i++) {
 		bytenr = btrfs_sb_offset(i);
-		fs_info = open_ctree_fs_info(dev, bytenr, root_location, 0, 1);
+		fs_info = open_ctree_fs_info(dev, bytenr, root_location,
+					     OPEN_CTREE_PARTIAL);
 		if (fs_info)
 			break;
 		fprintf(stderr, "Could not open root, trying backup super\n");
diff --git a/disk-io.c b/disk-io.c
index c5ee33a..3d855d2 100644
--- a/disk-io.c
+++ b/disk-io.c
@@ -827,8 +827,8 @@ static int find_best_backup_root(struct btrfs_super_block *super)
 	return best_index;
 }
 
-int btrfs_setup_all_roots(struct btrfs_fs_info *fs_info,
-			  u64 root_tree_bytenr, int partial, int backup_root)
+int btrfs_setup_all_roots(struct btrfs_fs_info *fs_info, u64 root_tree_bytenr,
+			  enum btrfs_open_ctree_flags flags)
 {
 	struct btrfs_super_block *sb = fs_info->super_copy;
 	struct btrfs_root *root;
@@ -852,9 +852,9 @@ int btrfs_setup_all_roots(struct btrfs_fs_info *fs_info,
 	blocksize = btrfs_level_size(root, btrfs_super_root_level(sb));
 	generation = btrfs_super_generation(sb);
 
-	if (!root_tree_bytenr && !backup_root) {
+	if (!root_tree_bytenr && !(flags & OPEN_CTREE_BACKUP_ROOT)) {
 		root_tree_bytenr = btrfs_super_root(sb);
-	} else if (backup_root) {
+	} else if (flags & OPEN_CTREE_BACKUP_ROOT) {
 		struct btrfs_root_backup *backup;
 		int index = find_best_backup_root(sb);
 		if (index >= BTRFS_NUM_BACKUP_ROOTS) {
@@ -877,7 +877,7 @@ int btrfs_setup_all_roots(struct btrfs_fs_info *fs_info,
 				  fs_info->extent_root);
 	if (ret) {
 		printk("Couldn't setup extent tree\n");
-		if (!partial)
+		if (!(flags & OPEN_CTREE_PARTIAL))
 			return -EIO;
 		/* Need a blank node here just so we don't screw up in the
 		 * million of places that assume a root has a valid ->node
@@ -903,7 +903,7 @@ int btrfs_setup_all_roots(struct btrfs_fs_info *fs_info,
 				  fs_info->csum_root);
 	if (ret) {
 		printk("Couldn't setup csum tree\n");
-		if (!partial)
+		if (!(flags & OPEN_CTREE_PARTIAL))
 			return -EIO;
 	}
 	fs_info->csum_root->track_dirty = 1;
@@ -917,7 +917,8 @@ int btrfs_setup_all_roots(struct btrfs_fs_info *fs_info,
 	fs_info->generation = generation;
 	fs_info->last_trans_committed = generation;
 
-	if (extent_buffer_uptodate(fs_info->extent_root->node))
+	if (extent_buffer_uptodate(fs_info->extent_root->node) &&
+	    !(flags & OPEN_CTREE_NO_BLOCK_GROUPS))
 		btrfs_read_block_groups(fs_info->tree_root);
 
 	key.objectid = BTRFS_FS_TREE_OBJECTID;
@@ -1046,10 +1047,8 @@ int btrfs_setup_chunk_tree_and_device_map(struct btrfs_fs_info *fs_info)
 
 static struct btrfs_fs_info *__open_ctree_fd(int fp, const char *path,
 					     u64 sb_bytenr,
-					     u64 root_tree_bytenr, int writes,
-					     int partial, int restore,
-					     int recover_super,
-					     int backup_root)
+					     u64 root_tree_bytenr,
+					     enum btrfs_open_ctree_flags flags)
 {
 	struct btrfs_fs_info *fs_info;
 	struct btrfs_super_block *disk_super;
@@ -1064,21 +1063,21 @@ static struct btrfs_fs_info *__open_ctree_fd(int fp, const char *path,
 	if (posix_fadvise(fp, 0, 0, POSIX_FADV_DONTNEED))
 		fprintf(stderr, "Warning, could not drop caches\n");
 
-	fs_info = btrfs_new_fs_info(writes, sb_bytenr);
+	fs_info = btrfs_new_fs_info(flags & OPEN_CTREE_WRITES, sb_bytenr);
 	if (!fs_info) {
 		fprintf(stderr, "Failed to allocate memory for fs_info\n");
 		return NULL;
 	}
-	if (restore)
+	if (flags & OPEN_CTREE_RESTORE)
 		fs_info->on_restoring = 1;
 
 	ret = btrfs_scan_fs_devices(fp, path, &fs_devices, sb_bytenr,
-				    !recover_super);
+				    !(flags & OPEN_CTREE_RECOVER_SUPER));
 	if (ret)
 		goto out;
 
 	fs_info->fs_devices = fs_devices;
-	if (writes)
+	if (flags & OPEN_CTREE_WRITES)
 		ret = btrfs_open_devices(fs_devices, O_RDWR);
 	else
 		ret = btrfs_open_devices(fs_devices, O_RDONLY);
@@ -1087,7 +1086,7 @@ static struct btrfs_fs_info *__open_ctree_fd(int fp, const char *path,
 
 
 	disk_super = fs_info->super_copy;
-	if (!recover_super)
+	if (!(flags & OPEN_CTREE_RECOVER_SUPER))
 		ret = btrfs_read_dev_super(fs_devices->latest_bdev,
 					   disk_super, sb_bytenr);
 	else
@@ -1099,7 +1098,8 @@ static struct btrfs_fs_info *__open_ctree_fd(int fp, const char *path,
 
 	memcpy(fs_info->fsid, &disk_super->fsid, BTRFS_FSID_SIZE);
 
-	ret = btrfs_check_fs_compatibility(fs_info->super_copy, writes);
+	ret = btrfs_check_fs_compatibility(fs_info->super_copy,
+					   flags & OPEN_CTREE_WRITES);
 	if (ret)
 		goto out_devices;
 
@@ -1112,15 +1112,14 @@ static struct btrfs_fs_info *__open_ctree_fd(int fp, const char *path,
 			   (unsigned long)btrfs_header_chunk_tree_uuid(eb),
 			   BTRFS_UUID_SIZE);
 
-	ret = btrfs_setup_all_roots(fs_info, root_tree_bytenr, partial,
-				    backup_root);
+	ret = btrfs_setup_all_roots(fs_info, root_tree_bytenr, flags);
 	if (ret)
 		goto out_failed;
 
 	return fs_info;
 
 out_failed:
-	if (partial)
+	if (flags & OPEN_CTREE_PARTIAL)
 		return fs_info;
 out_chunk:
 	btrfs_release_all_roots(fs_info);
@@ -1132,90 +1131,44 @@ out:
 	return NULL;
 }
 
-struct btrfs_fs_info *open_ctree_fs_info_restore(const char *filename,
-					 u64 sb_bytenr, u64 root_tree_bytenr,
-					 int writes, int partial)
-{
-	int fp;
-	struct btrfs_fs_info *info;
-	int flags = O_CREAT | O_RDWR;
-	int restore = 1;
-
-	if (!writes)
-		flags = O_RDONLY;
-
-	fp = open(filename, flags, 0600);
-	if (fp < 0) {
-		fprintf (stderr, "Could not open %s\n", filename);
-		return NULL;
-	}
-	info = __open_ctree_fd(fp, filename, sb_bytenr, root_tree_bytenr,
-			       writes, partial, restore, 0, 0);
-	close(fp);
-	return info;
-}
-
 struct btrfs_fs_info *open_ctree_fs_info(const char *filename,
 					 u64 sb_bytenr, u64 root_tree_bytenr,
-					 int writes, int partial,
-					 int backup_root)
+					 enum btrfs_open_ctree_flags flags)
 {
 	int fp;
 	struct btrfs_fs_info *info;
-	int flags = O_CREAT | O_RDWR;
+	int oflags = O_CREAT | O_RDWR;
 
-	if (!writes)
-		flags = O_RDONLY;
+	if (!(flags & OPEN_CTREE_WRITES))
+		oflags = O_RDONLY;
 
-	fp = open(filename, flags, 0600);
+	fp = open(filename, oflags, 0600);
 	if (fp < 0) {
 		fprintf (stderr, "Could not open %s\n", filename);
 		return NULL;
 	}
 	info = __open_ctree_fd(fp, filename, sb_bytenr, root_tree_bytenr,
-			       writes, partial, 0, 0, backup_root);
+			       flags);
 	close(fp);
 	return info;
 }
 
-struct btrfs_root *open_ctree_with_broken_super(const char *filename,
-					u64 sb_bytenr, int writes)
-{
-	int fp;
-	struct btrfs_fs_info *info;
-	int flags = O_CREAT | O_RDWR;
-
-	if (!writes)
-		flags = O_RDONLY;
-
-	fp = open(filename, flags, 0600);
-	if (fp < 0) {
-		fprintf(stderr, "Could not open %s\n", filename);
-		return NULL;
-	}
-	info = __open_ctree_fd(fp, filename, sb_bytenr, 0,
-			       writes, 0, 0, 1, 0);
-	close(fp);
-	if (info)
-		return info->fs_root;
-	return NULL;
-}
-
-struct btrfs_root *open_ctree(const char *filename, u64 sb_bytenr, int writes)
+struct btrfs_root *open_ctree(const char *filename, u64 sb_bytenr,
+			      enum btrfs_open_ctree_flags flags)
 {
 	struct btrfs_fs_info *info;
 
-	info = open_ctree_fs_info(filename, sb_bytenr, 0, writes, 0, 0);
+	info = open_ctree_fs_info(filename, sb_bytenr, 0, flags);
 	if (!info)
 		return NULL;
 	return info->fs_root;
 }
 
 struct btrfs_root *open_ctree_fd(int fp, const char *path, u64 sb_bytenr,
-				 int writes)
+				 enum btrfs_open_ctree_flags flags)
 {
 	struct btrfs_fs_info *info;
-	info = __open_ctree_fd(fp, path, sb_bytenr, 0, writes, 0, 0, 0, 0);
+	info = __open_ctree_fd(fp, path, sb_bytenr, 0, flags);
 	if (!info)
 		return NULL;
 	return info->fs_root;
diff --git a/disk-io.h b/disk-io.h
index b0292db..ca6af2d 100644
--- a/disk-io.h
+++ b/disk-io.h
@@ -25,6 +25,15 @@
 #define BTRFS_SUPER_MIRROR_MAX	 3
 #define BTRFS_SUPER_MIRROR_SHIFT 12
 
+enum btrfs_open_ctree_flags {
+	OPEN_CTREE_WRITES		= 1,
+	OPEN_CTREE_PARTIAL		= 2,
+	OPEN_CTREE_BACKUP_ROOT		= 4,
+	OPEN_CTREE_RECOVER_SUPER	= 8,
+	OPEN_CTREE_RESTORE		= 16,
+	OPEN_CTREE_NO_BLOCK_GROUPS	= 32,
+};
+
 static inline u64 btrfs_sb_offset(int mirror)
 {
 	u64 start = 16 * 1024;
@@ -52,8 +61,8 @@ int clean_tree_block(struct btrfs_trans_handle *trans,
 void btrfs_free_fs_info(struct btrfs_fs_info *fs_info);
 struct btrfs_fs_info *btrfs_new_fs_info(int writable, u64 sb_bytenr);
 int btrfs_check_fs_compatibility(struct btrfs_super_block *sb, int writable);
-int btrfs_setup_all_roots(struct btrfs_fs_info *fs_info,
-			  u64 root_tree_bytenr, int partial, int backup_root);
+int btrfs_setup_all_roots(struct btrfs_fs_info *fs_info, u64 root_tree_bytenr,
+			  enum btrfs_open_ctree_flags flags);
 void btrfs_release_all_roots(struct btrfs_fs_info *fs_info);
 void btrfs_cleanup_all_caches(struct btrfs_fs_info *fs_info);
 int btrfs_scan_fs_devices(int fd, const char *path,
@@ -61,18 +70,13 @@ int btrfs_scan_fs_devices(int fd, const char *path,
 			  int run_ioctl);
 int btrfs_setup_chunk_tree_and_device_map(struct btrfs_fs_info *fs_info);
 
-struct btrfs_root *open_ctree(const char *filename, u64 sb_bytenr, int writes);
+struct btrfs_root *open_ctree(const char *filename, u64 sb_bytenr,
+			      enum btrfs_open_ctree_flags flags);
 struct btrfs_root *open_ctree_fd(int fp, const char *path, u64 sb_bytenr,
-				 int writes);
-struct btrfs_fs_info *open_ctree_fs_info_restore(const char *filename,
-					 u64 sb_bytenr, u64 root_tree_bytenr,
-					 int writes, int partial);
+				 enum btrfs_open_ctree_flags flags);
 struct btrfs_fs_info *open_ctree_fs_info(const char *filename,
 					 u64 sb_bytenr, u64 root_tree_bytenr,
-					 int writes, int partial,
-					 int backup_root);
-struct btrfs_root *open_ctree_with_broken_super(const char *filename,
-					u64 sb_bytenr, int writes);
+					 enum btrfs_open_ctree_flags flags);
 int close_ctree(struct btrfs_root *root);
 int write_all_supers(struct btrfs_root *root);
 int write_ctree_super(struct btrfs_trans_handle *trans,
diff --git a/mkfs.c b/mkfs.c
index 770a4c0..ec717be 100644
--- a/mkfs.c
+++ b/mkfs.c
@@ -1478,7 +1478,7 @@ int main(int ac, char **av)
 		exit(1);
 	}
 
-	root = open_ctree(file, 0, O_RDWR);
+	root = open_ctree(file, 0, OPEN_CTREE_WRITES);
 	if (!root) {
 		fprintf(stderr, "Open ctree failed\n");
 		close(fd);
diff --git a/quick-test.c b/quick-test.c
index b12b9ef..5dfb2fe 100644
--- a/quick-test.c
+++ b/quick-test.c
@@ -51,7 +51,7 @@ int main(int ac, char **av) {
 
 	radix_tree_init();
 
-	root = open_ctree(av[1], BTRFS_SUPER_INFO_OFFSET, O_RDWR);
+	root = open_ctree(av[1], BTRFS_SUPER_INFO_OFFSET, OPEN_CTREE_WRITES);
 	if (!root) {
 		fprintf(stderr, "Open ctree failed\n");
 		exit(1);
@@ -78,7 +78,7 @@ int main(int ac, char **av) {
 	btrfs_commit_transaction(trans, root);
 	close_ctree(root);
 	exit(1);
-	root = open_ctree(av[1], BTRFS_SUPER_INFO_OFFSET, O_RDWR);
+	root = open_ctree(av[1], BTRFS_SUPER_INFO_OFFSET, OPEN_CTREE_WRITES);
 	if (!root) {
 		fprintf(stderr, "Open ctree failed\n");
 		exit(1);
@@ -101,7 +101,7 @@ int main(int ac, char **av) {
 	}
 	close_ctree(root);
 
-	root = open_ctree(av[1], BTRFS_SUPER_INFO_OFFSET, O_RDWR);
+	root = open_ctree(av[1], BTRFS_SUPER_INFO_OFFSET, OPEN_CTREE_WRITES);
 	if (!root) {
 		fprintf(stderr, "Open ctree failed\n");
 		exit(1);
@@ -133,7 +133,7 @@ int main(int ac, char **av) {
 	btrfs_commit_transaction(trans, root);
 	close_ctree(root);
 
-	root = open_ctree(av[1], BTRFS_SUPER_INFO_OFFSET, O_RDWR);
+	root = open_ctree(av[1], BTRFS_SUPER_INFO_OFFSET, OPEN_CTREE_WRITES);
 	if (!root) {
 		fprintf(stderr, "Open ctree failed\n");
 		exit(1);
@@ -153,7 +153,7 @@ int main(int ac, char **av) {
 	btrfs_commit_transaction(trans, root);
 	close_ctree(root);
 
-	root = open_ctree(av[1], BTRFS_SUPER_INFO_OFFSET, O_RDWR);
+	root = open_ctree(av[1], BTRFS_SUPER_INFO_OFFSET, OPEN_CTREE_WRITES);
 	if (!root) {
 		fprintf(stderr, "Open ctree failed\n");
 		exit(1);
diff --git a/super-recover.c b/super-recover.c
index 5920ea6..a6271a2 100644
--- a/super-recover.c
+++ b/super-recover.c
@@ -323,8 +323,8 @@ int btrfs_recover_superblocks(const char *dname,
 		}
 	}
 	record = recover_get_good_super(&recover);
-	root = open_ctree_with_broken_super(record->device_name,
-					record->bytenr, 1);
+	root = open_ctree(record->device_name, record->bytenr,
+			  OPEN_CTREE_RECOVER_SUPER | OPEN_CTREE_WRITES);
 	if (!root) {
 		ret = 3;
 		goto no_recover;
diff --git a/utils.c b/utils.c
index f8bc94f..0b23af4 100644
--- a/utils.c
+++ b/utils.c
@@ -1279,7 +1279,7 @@ static int set_label_unmounted(const char *dev, const char *label)
 	/* Open the super_block at the default location
 	 * and as read-write.
 	 */
-	root = open_ctree(dev, 0, 1);
+	root = open_ctree(dev, 0, OPEN_CTREE_WRITES);
 	if (!root) /* errors are printed by open_ctree() */
 		return -1;
 
-- 
1.8.3.1

