Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:31138 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1161815AbbKTD1U (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 19 Nov 2015 22:27:20 -0500
Received: from localhost.localdomain (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id tAK3PqdV022290
	for <linux-btrfs@vger.kernel.org>; Fri, 20 Nov 2015 11:26:34 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 22/25] btrfs-progs: Introduce do_convert_v2 function
Date: Fri, 20 Nov 2015 11:24:26 +0800
Message-Id: <1447989869-24739-23-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1447989869-24739-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1447989869-24739-1-git-send-email-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Introduce new function do_convert_v2() to do new convert.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 btrfs-convert.c | 187 ++++++++++++++++++++++++++++++++++++++++++++++++++++++--
 utils.c         |   3 +
 2 files changed, 186 insertions(+), 4 deletions(-)

diff --git a/btrfs-convert.c b/btrfs-convert.c
index 9e8158d..8079aea 100644
--- a/btrfs-convert.c
+++ b/btrfs-convert.c
@@ -1217,7 +1217,8 @@ fail:
  * scan ext2's inode bitmap and copy all used inodes.
  */
 static int copy_inodes(struct btrfs_root *root, ext2_filsys ext2_fs,
-		       int datacsum, int packing, int noxattr, struct task_ctx *p)
+		       int datacsum, int packing, int noxattr, int skip_root,
+		       struct task_ctx *p)
 {
 	int ret;
 	errcode_t err;
@@ -1242,7 +1243,7 @@ static int copy_inodes(struct btrfs_root *root, ext2_filsys ext2_fs,
 			break;
 		/* skip special inode in ext2fs */
 		if (ext2_ino < EXT2_GOOD_OLD_FIRST_INO &&
-		    ext2_ino != EXT2_ROOT_INO)
+		    (ext2_ino != EXT2_ROOT_INO || skip_root))
 			continue;
 		objectid = ext2_ino + INO_OFFSET;
 		ret = copy_single_inode(trans, root,
@@ -2857,6 +2858,183 @@ static int read_ext2_used_space(ext2_filsys fs, struct cache_tree *used_tree)
 	return ret;
 }
 
+static int do_convert_v2(const char *devname, int datacsum, int packing,
+		int noxattr, u64 nodesize, int copylabel, const char *fslabel,
+		int progress, u64 features)
+{
+	int ret;
+	int fd = -1;
+	int is_btrfs = 0;
+	u32 blocksize;
+	u64 blocks[7];
+	u64 total_bytes;
+	ext2_filsys ext2_fs;
+	struct btrfs_root *root;
+	struct btrfs_root *image_root;
+	struct task_ctx ctx;
+	char features_buf[64];
+	struct btrfs_mkfs_config mkfs_cfg;
+
+	ret = open_ext2fs(devname, &ext2_fs);
+	if (ret) {
+		fprintf(stderr, "unable to open the Ext2fs\n");
+		goto fail;
+	}
+	blocksize = ext2_fs->blocksize;
+	total_bytes = (u64)ext2_fs->super->s_blocks_count * blocksize;
+	if (blocksize < 4096) {
+		fprintf(stderr, "block size is too small\n");
+		goto fail;
+	}
+	if (!(ext2_fs->super->s_feature_incompat &
+	      EXT2_FEATURE_INCOMPAT_FILETYPE)) {
+		fprintf(stderr, "filetype feature is missing\n");
+		goto fail;
+	}
+	if (btrfs_check_nodesize(nodesize, blocksize, features))
+		goto fail;
+
+	/* Build the used space tree first */
+	init_mkfs_config(&mkfs_cfg);
+	ret = read_ext2_used_space(ext2_fs, &mkfs_cfg.convert_used);
+	if (ret < 0) {
+		error("fail to read ext2 block bitmap\n");
+		goto fail;
+	}
+
+	fd = open(devname, O_RDWR);
+	if (fd < 0) {
+		fprintf(stderr, "unable to open %s\n", devname);
+		goto fail;
+	}
+	btrfs_parse_features_to_string(features_buf, features);
+	if (features == BTRFS_MKFS_DEFAULT_FEATURES)
+		strcat(features_buf, " (default)");
+
+	printf("create btrfs filesystem:\n");
+	printf("\tblocksize: %u\n", blocksize);
+	printf("\tnodesize:  %llu\n", nodesize);
+	printf("\tfeatures:  %s\n", features_buf);
+
+	mkfs_cfg.label = ext2_fs->super->s_volume_name;
+	mkfs_cfg.fs_uuid = malloc(BTRFS_UUID_UNPARSED_SIZE);
+	if (!mkfs_cfg.fs_uuid) {
+		ret = -ENOMEM;
+		goto fail;
+	}
+	*(mkfs_cfg.fs_uuid) = '\0';
+	mkfs_cfg.chunk_uuid = malloc(BTRFS_UUID_UNPARSED_SIZE);
+	if (!mkfs_cfg.chunk_uuid) {
+		ret = -ENOMEM;
+		goto fail;
+	}
+	*(mkfs_cfg.chunk_uuid) = '\0';
+	memcpy(mkfs_cfg.blocks, blocks, sizeof(blocks));
+	mkfs_cfg.num_bytes = total_bytes;
+	mkfs_cfg.nodesize = nodesize;
+	mkfs_cfg.sectorsize = blocksize;
+	mkfs_cfg.stripesize = blocksize;
+	mkfs_cfg.features = features;
+
+	ret = make_btrfs(fd, &mkfs_cfg);
+	if (ret) {
+		fprintf(stderr, "unable to create initial ctree: %s\n",
+			strerror(-ret));
+		goto fail;
+	}
+	root = open_ctree_fd(fd, devname, mkfs_cfg.super_bytenr,
+			     OPEN_CTREE_WRITES);
+	if (!root) {
+		fprintf(stderr, "unable to open ctree\n");
+		goto fail;
+	}
+	ret = init_btrfs_v2(&mkfs_cfg, ext2_fs, root, datacsum, packing, 
+			    noxattr);
+	if (ret) {
+		fprintf(stderr, "unable to setup the root tree\n");
+		goto fail;
+	}
+	printf("creating ext2fs image file.\n");
+	image_root = link_subvol(root, "ext2_saved", CONV_IMAGE_SUBVOL_OBJECTID);
+	if (!image_root) {
+		fprintf(stderr, "unable to create subvol\n");
+		goto fail;
+	}
+	ret = create_ext2_image_v2(image_root, &mkfs_cfg, fd, total_bytes,
+				   "image", datacsum);
+	if (ret) {
+		fprintf(stderr, "error during create_ext2_image %d\n", ret);
+		goto fail;
+	}
+	printf("creating btrfs metadata.\n");
+	ctx.max_copy_inodes = (ext2_fs->super->s_inodes_count
+			- ext2_fs->super->s_free_inodes_count);
+	ctx.cur_copy_inodes = 0;
+
+	if (progress) {
+		ctx.info = task_init(print_copied_inodes, after_copied_inodes, &ctx);
+		task_start(ctx.info);
+	}
+	ret = copy_inodes(root, ext2_fs, datacsum, packing, noxattr, 1, &ctx);
+	if (ret) {
+		fprintf(stderr, "error during copy_inodes %d\n", ret);
+		goto fail;
+	}
+	if (progress) {
+		task_stop(ctx.info);
+		task_deinit(ctx.info);
+	}
+	memset(root->fs_info->super_copy->label, 0, BTRFS_LABEL_SIZE);
+	if (copylabel == 1) {
+		strncpy(root->fs_info->super_copy->label,
+				ext2_fs->super->s_volume_name, 16);
+		fprintf(stderr, "copy label '%s'\n",
+				root->fs_info->super_copy->label);
+	} else if (copylabel == -1) {
+		strcpy(root->fs_info->super_copy->label, fslabel);
+		fprintf(stderr, "set label to '%s'\n", fslabel);
+	}
+
+	ret = close_ctree(root);
+	if (ret) {
+		fprintf(stderr, "error during close_ctree %d\n", ret);
+		goto fail;
+	}
+	close_ext2fs(ext2_fs);
+
+	/*
+	 * If this step succeed, we get a mountable btrfs. Otherwise
+	 * the ext2fs is left unchanged.
+	 */
+	ret = migrate_super_block(fd, mkfs_cfg.super_bytenr, blocksize);
+	if (ret) {
+		fprintf(stderr, "unable to migrate super block\n");
+		goto fail;
+	}
+	is_btrfs = 1;
+
+	root = open_ctree_fd(fd, devname, 0, OPEN_CTREE_WRITES);
+	if (!root) {
+		fprintf(stderr, "unable to open ctree\n");
+		goto fail;
+	}
+	close(fd);
+
+	printf("conversion complete.\n");
+	return 0;
+fail:
+	free_mkfs_config(&mkfs_cfg);
+
+	if (fd != -1)
+		close(fd);
+	if (is_btrfs)
+		fprintf(stderr,
+			"WARNING: an error occured during chunk mapping fixup, filesystem mountable but not finalized\n");
+	else
+		fprintf(stderr, "conversion aborted\n");
+	return -1;
+}
+
 static int do_convert(const char *devname, int datacsum, int packing, int noxattr,
 		u32 nodesize, int copylabel, const char *fslabel, int progress,
 		u64 features)
@@ -2933,6 +3111,7 @@ static int do_convert(const char *devname, int datacsum, int packing, int noxatt
 	printf("\tfeatures:  %s\n", features_buf);
 
 	mkfs_cfg.label = ext2_fs->super->s_volume_name;
+	mkfs_cfg.chunk_uuid = NULL;
 	mkfs_cfg.fs_uuid = NULL;
 	memcpy(mkfs_cfg.blocks, blocks, sizeof(blocks));
 	mkfs_cfg.num_bytes = total_bytes;
@@ -2987,7 +3166,7 @@ static int do_convert(const char *devname, int datacsum, int packing, int noxatt
 		ctx.info = task_init(print_copied_inodes, after_copied_inodes, &ctx);
 		task_start(ctx.info);
 	}
-	ret = copy_inodes(root, ext2_fs, datacsum, packing, noxattr, &ctx);
+	ret = copy_inodes(root, ext2_fs, datacsum, packing, noxattr, 0, &ctx);
 	if (ret) {
 		fprintf(stderr, "error during copy_inodes %d\n", ret);
 		goto fail;
@@ -3606,7 +3785,7 @@ int main(int argc, char *argv[])
 	if (rollback) {
 		ret = do_rollback(file);
 	} else {
-		ret = do_convert(file, datacsum, packing, noxattr, nodesize,
+		ret = do_convert_v2(file, datacsum, packing, noxattr, nodesize,
 				copylabel, fslabel, progress, features);
 	}
 	if (ret)
diff --git a/utils.c b/utils.c
index f5fadb1..6c5b17a 100644
--- a/utils.c
+++ b/utils.c
@@ -1214,6 +1214,9 @@ int make_btrfs(int fd, struct btrfs_mkfs_config *cfg)
 				 BTRFS_FEATURE_INCOMPAT_SKINNY_METADATA);
 	u64 num_bytes;
 
+	if (!cache_tree_empty(&cfg->convert_used))
+		return make_btrfs_v2(fd, cfg);
+
 	buf = malloc(sizeof(*buf) + max(cfg->sectorsize, cfg->nodesize));
 	if (!buf)
 		return -ENOMEM;
-- 
2.6.2

