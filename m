Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:64522 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755117AbbLAHOS (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 1 Dec 2015 02:14:18 -0500
Received: from localhost.localdomain (unknown [10.167.226.34])
	by cn.fujitsu.com (Postfix) with ESMTP id 0237340444C8
	for <linux-btrfs@vger.kernel.org>; Tue,  1 Dec 2015 15:14:00 +0800 (CST)
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2 04/25] btrfs-progs: convert: Introduce functions to read used space
Date: Tue,  1 Dec 2015 15:11:24 +0800
Message-Id: <1448953905-28673-5-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1448953905-28673-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1448953905-28673-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Before we do real convert, we need to read and build up used space cache
tree for later data/meta separate chunk layout.

This patch will iterate all used blocks in ext2 filesystem and record it
into cctx->used cache tree, for later use.

This provides the very basic of later btrfs-convert rework.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 btrfs-convert.c | 80 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 80 insertions(+)

diff --git a/btrfs-convert.c b/btrfs-convert.c
index 4baa68e..65841bd 100644
--- a/btrfs-convert.c
+++ b/btrfs-convert.c
@@ -81,6 +81,7 @@ struct btrfs_convert_context;
 struct btrfs_convert_operations {
 	const char *name;
 	int (*open_fs)(struct btrfs_convert_context *cctx, const char *devname);
+	int (*read_used_space)(struct btrfs_convert_context *cctx);
 	int (*alloc_block)(struct btrfs_convert_context *cctx, u64 goal,
 			   u64 *block_ret);
 	int (*alloc_block_range)(struct btrfs_convert_context *cctx, u64 goal,
@@ -230,6 +231,73 @@ fail:
 	return -1;
 }
 
+static int __ext2_add_one_block(ext2_filsys fs, char *bitmap,
+				unsigned long group_nr, struct cache_tree *used)
+{
+	unsigned long offset;
+	unsigned i;
+	int ret = 0;
+
+	offset = fs->super->s_first_data_block;
+	offset /= EXT2FS_CLUSTER_RATIO(fs);
+	offset += group_nr * fs->super->s_clusters_per_group;
+	for (i = 0; i < fs->super->s_clusters_per_group; i++) {
+		if (ext2fs_test_bit(i, bitmap)) {
+			u64 start;
+
+			start = (i + offset) * EXT2FS_CLUSTER_RATIO(fs);
+			start *= fs->blocksize;
+			ret = add_merge_cache_extent(used, start,
+						     fs->blocksize);
+			if (ret < 0)
+				break;
+		}
+	}
+	return ret;
+}
+
+/*
+ * Read all used ext2 space into cctx->used cache tree
+ */
+static int ext2_read_used_space(struct btrfs_convert_context *cctx)
+{
+	ext2_filsys fs = (ext2_filsys)cctx->fs_data;
+	blk64_t blk_itr = EXT2FS_B2C(fs, fs->super->s_first_data_block);
+	struct cache_tree *used_tree = &cctx->used;
+	char *block_bitmap = NULL;
+	unsigned long i;
+	int block_nbytes;
+	int ret = 0;
+
+	block_nbytes = EXT2_CLUSTERS_PER_GROUP(fs->super) / 8;
+	/* Shouldn't happen */
+	BUG_ON(!fs->block_map);
+
+	block_bitmap = malloc(block_nbytes);
+	if (!block_bitmap)
+		return -ENOMEM;
+
+	for (i = 0; i < fs->group_desc_count; i++) {
+		ret = ext2fs_get_block_bitmap_range2(fs->block_map, blk_itr,
+						block_nbytes * 8, block_bitmap);
+		if (ret) {
+			error("fail to get bitmap from ext2, %s",
+			      strerror(-ret));
+			break;
+		}
+		ret = __ext2_add_one_block(fs, block_bitmap, i, used_tree);
+		if (ret < 0) {
+			error("fail to build used space tree, %s",
+			      strerror(-ret));
+			break;
+		}
+		blk_itr += fs->super->s_clusters_per_group;
+	}
+
+	free(block_bitmap);
+	return ret;
+}
+
 static void ext2_close_fs(struct btrfs_convert_context *cctx)
 {
 	if (cctx->volume_name) {
@@ -2418,6 +2486,7 @@ err:
 static const struct btrfs_convert_operations ext2_convert_ops = {
 	.name			= "ext2",
 	.open_fs		= ext2_open_fs,
+	.read_used_space	= ext2_read_used_space,
 	.alloc_block		= ext2_alloc_block,
 	.alloc_block_range	= ext2_alloc_block_range,
 	.copy_inodes		= ext2_copy_inodes,
@@ -2451,6 +2520,14 @@ static int convert_open_fs(const char *devname,
 	return -1;
 }
 
+/*
+ * Read used space
+ */
+static int convert_read_used_space(struct btrfs_convert_context *cctx)
+{
+	return cctx->convert_ops->read_used_space(cctx);
+}
+
 static int do_convert(const char *devname, int datacsum, int packing, int noxattr,
 		u32 nodesize, int copylabel, const char *fslabel, int progress,
 		u64 features)
@@ -2474,6 +2551,9 @@ static int do_convert(const char *devname, int datacsum, int packing, int noxatt
 	ret = convert_open_fs(devname, &cctx);
 	if (ret)
 		goto fail;
+	ret = convert_read_used_space(&cctx);
+	if (ret)
+		goto fail;
 
 	blocksize = cctx.blocksize;
 	total_bytes = (u64)blocksize * (u64)cctx.block_count;
-- 
2.6.2



