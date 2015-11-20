Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:38125 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S934929AbbKTD0n (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 19 Nov 2015 22:26:43 -0500
Received: from localhost.localdomain (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id tAK3PqdD022290
	for <linux-btrfs@vger.kernel.org>; Fri, 20 Nov 2015 11:25:57 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 04/25] btrfs-progs: convert: Read and build up used space tree
Date: Fri, 20 Nov 2015 11:24:08 +0800
Message-Id: <1447989869-24739-5-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1447989869-24739-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1447989869-24739-1-git-send-email-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Before we do real convert, we'd better read and build up used space
cache tree for later data/meta chunk layout calculation.

This patch will iterate all used blocks in ext2 filesystem and record it
into mkfs_cfg.used cache tree for later used.

This provides the basis for later btrfs-convert rework.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 btrfs-convert.c | 77 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 77 insertions(+)

diff --git a/btrfs-convert.c b/btrfs-convert.c
index f66affd..3bee049 100644
--- a/btrfs-convert.c
+++ b/btrfs-convert.c
@@ -2286,6 +2286,77 @@ err:
 	return ret;
 }
 
+static int add_one_used_block(ext2_filsys fs, char *bitmap,
+			      unsigned long group_nr, struct cache_tree *used)
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
+ * This function will iterate through all the ext2 block groups to fill used
+ * space tree.
+ * Which will later be used to build data chunk layout to ensure all ext2 used
+ * data will be covered by data chunk.
+ */
+static int read_ext2_used_space(ext2_filsys fs, struct cache_tree *used_tree)
+{
+	blk64_t blk_itr = EXT2FS_B2C(fs, fs->super->s_first_data_block);
+	char *block_bitmap = NULL;
+	unsigned long i;
+	int block_nbytes;
+	int ret = 0;
+
+	block_nbytes = EXT2_CLUSTERS_PER_GROUP(fs->super) / 8;
+	ret = ext2fs_read_bitmaps(fs);
+	if (ret < 0)
+		return ret;
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
+		ret = add_one_used_block(fs, block_bitmap, i, used_tree);
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
 static int do_convert(const char *devname, int datacsum, int packing, int noxattr,
 		u32 nodesize, int copylabel, const char *fslabel, int progress,
 		u64 features)
@@ -2323,7 +2394,13 @@ static int do_convert(const char *devname, int datacsum, int packing, int noxatt
 	if (btrfs_check_nodesize(nodesize, blocksize, features))
 		goto fail;
 
+	/* Build the used space tree first */
 	init_mkfs_config(&mkfs_cfg);
+	ret = read_ext2_used_space(ext2_fs, &mkfs_cfg.convert_used);
+	if (ret < 0) {
+		error("fail to read ext2 block bitmap\n");
+		goto fail;
+	}
 
 	blocks_per_node = nodesize / blocksize;
 	ret = -blocks_per_node;
-- 
2.6.2

