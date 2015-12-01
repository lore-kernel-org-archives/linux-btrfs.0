Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:25708 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755291AbbLAHOg (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 1 Dec 2015 02:14:36 -0500
Received: from localhost.localdomain (unknown [10.167.226.34])
	by cn.fujitsu.com (Postfix) with ESMTP id 98A1740444C3
	for <linux-btrfs@vger.kernel.org>; Tue,  1 Dec 2015 15:14:14 +0800 (CST)
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2 22/25] btrfs-progs: Introduce do_convert_v2 function
Date: Tue,  1 Dec 2015 15:11:42 +0800
Message-Id: <1448953905-28673-23-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1448953905-28673-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1448953905-28673-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Introduce new function do_convert_v2() to do new convert.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 btrfs-convert.c | 177 +++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 176 insertions(+), 1 deletion(-)

diff --git a/btrfs-convert.c b/btrfs-convert.c
index ce6c59b..17ce8ac 100644
--- a/btrfs-convert.c
+++ b/btrfs-convert.c
@@ -3211,6 +3211,181 @@ static int convert_read_used_space(struct btrfs_convert_context *cctx)
 	return ret;
 }
 
+static int do_convert_v2(const char *devname, int datacsum, int packing,
+		int noxattr, u32 nodesize, int copylabel, const char *fslabel,
+		int progress, u64 features)
+{
+	int ret;
+	int fd = -1;
+	int is_btrfs = 0;
+	u32 blocksize;
+	u64 total_bytes;
+	struct btrfs_root *root;
+	struct btrfs_root *image_root;
+	struct btrfs_convert_context cctx;
+	struct btrfs_key key;
+	char *subvol_name = NULL;
+	struct task_ctx ctx;
+	char features_buf[64];
+	struct btrfs_mkfs_config mkfs_cfg;
+
+	init_convert_context(&cctx);
+	ret = convert_open_fs(devname, &cctx);
+	if (ret)
+		goto fail;
+	ret = convert_read_used_space(&cctx);
+	if (ret)
+		goto fail;
+
+	blocksize = cctx.blocksize;
+	total_bytes = (u64)blocksize * (u64)cctx.block_count;
+	if (blocksize < 4096) {
+		fprintf(stderr, "block size is too small\n");
+		goto fail;
+	}
+	if (btrfs_check_nodesize(nodesize, blocksize, features))
+		goto fail;
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
+	printf("\tnodesize:  %u\n", nodesize);
+	printf("\tfeatures:  %s\n", features_buf);
+
+	mkfs_cfg.label = cctx.volume_name;
+	mkfs_cfg.num_bytes = total_bytes;
+	mkfs_cfg.nodesize = nodesize;
+	mkfs_cfg.sectorsize = blocksize;
+	mkfs_cfg.stripesize = blocksize;
+	mkfs_cfg.features = features;
+	/* New convert need these space */
+	mkfs_cfg.fs_uuid = malloc(BTRFS_UUID_UNPARSED_SIZE);
+	mkfs_cfg.chunk_uuid = malloc(BTRFS_UUID_UNPARSED_SIZE);
+	*(mkfs_cfg.fs_uuid) = '\0';
+	*(mkfs_cfg.chunk_uuid) = '\0';
+
+	ret = make_btrfs(fd, &mkfs_cfg, &cctx);
+	if (ret) {
+		fprintf(stderr, "unable to create initial ctree: %s\n",
+			strerror(-ret));
+		goto fail;
+	}
+
+	root = open_ctree_fd(fd, devname, mkfs_cfg.super_bytenr,
+			     OPEN_CTREE_WRITES);
+	if (!root) {
+		fprintf(stderr, "unable to open ctree\n");
+		goto fail;
+	}
+	ret = init_btrfs_v2(&mkfs_cfg, root, &cctx, datacsum, packing, noxattr);
+	if (ret) {
+		fprintf(stderr, "unable to setup the root tree\n");
+		goto fail;
+	}
+
+	printf("creating %s image file.\n", cctx.convert_ops->name);
+	ret = asprintf(&subvol_name, "%s_saved", cctx.convert_ops->name);
+	if (ret < 0) {
+		fprintf(stderr, "error allocating subvolume name: %s_saved\n",
+			cctx.convert_ops->name);
+		goto fail;
+	}
+	key.objectid = CONV_IMAGE_SUBVOL_OBJECTID;
+	key.offset = (u64)-1;
+	key.type = BTRFS_ROOT_ITEM_KEY;
+	image_root = btrfs_read_fs_root(root->fs_info, &key);
+	if (!image_root) {
+		fprintf(stderr, "unable to create subvol\n");
+		goto fail;
+	}
+	ret = create_image_v2(image_root, &mkfs_cfg, &cctx, fd,
+			      mkfs_cfg.num_bytes, "image", datacsum);
+	if (ret) {
+		fprintf(stderr, "error during create_image %d\n", ret);
+		goto fail;
+	}
+
+	printf("creating btrfs metadata.\n");
+	ctx.max_copy_inodes = (cctx.inodes_count - cctx.free_inodes_count);
+	ctx.cur_copy_inodes = 0;
+
+	if (progress) {
+		ctx.info = task_init(print_copied_inodes, after_copied_inodes,
+				     &ctx);
+		task_start(ctx.info);
+	}
+	ret = copy_inodes(&cctx, root, datacsum, packing, noxattr, &ctx);
+	if (ret) {
+		fprintf(stderr, "error during copy_inodes %d\n", ret);
+		goto fail;
+	}
+	if (progress) {
+		task_stop(ctx.info);
+		task_deinit(ctx.info);
+	}
+
+	image_root = link_subvol(root, subvol_name, CONV_IMAGE_SUBVOL_OBJECTID);
+
+	free(subvol_name);
+
+	memset(root->fs_info->super_copy->label, 0, BTRFS_LABEL_SIZE);
+	if (copylabel == 1) {
+		strncpy(root->fs_info->super_copy->label,
+				cctx.volume_name, BTRFS_LABEL_SIZE);
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
+	convert_close_fs(&cctx);
+	clean_convert_context(&cctx);
+
+	/*
+	 * If this step succeed, we get a mountable btrfs. Otherwise
+	 * the source fs is left unchanged.
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
+	clean_convert_context(&cctx);
+	if (fd != -1)
+		close(fd);
+	if (is_btrfs)
+		fprintf(stderr,
+			"WARNING: an error occurred during chunk mapping fixup, filesystem mountable but not finalized\n");
+	else
+		fprintf(stderr, "conversion aborted\n");
+	return -1;
+}
+
 static int do_convert(const char *devname, int datacsum, int packing, int noxattr,
 		u32 nodesize, int copylabel, const char *fslabel, int progress,
 		u64 features)
@@ -3960,7 +4135,7 @@ int main(int argc, char *argv[])
 	if (rollback) {
 		ret = do_rollback(file);
 	} else {
-		ret = do_convert(file, datacsum, packing, noxattr, nodesize,
+		ret = do_convert_v2(file, datacsum, packing, noxattr, nodesize,
 				copylabel, fslabel, progress, features);
 	}
 	if (ret)
-- 
2.6.2



