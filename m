Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:64522 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755006AbbLAHOQ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 1 Dec 2015 02:14:16 -0500
Received: from localhost.localdomain (unknown [10.167.226.34])
	by cn.fujitsu.com (Postfix) with ESMTP id AA7BF40444C6
	for <linux-btrfs@vger.kernel.org>; Tue,  1 Dec 2015 15:14:00 +0800 (CST)
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2 03/25] btrfs-progs: Introduce new members for btrfs_convert_context
Date: Tue,  1 Dec 2015 15:11:23 +0800
Message-Id: <1448953905-28673-4-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1448953905-28673-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1448953905-28673-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Introduce 3 new members for btrfs_convert_context:

1) struct cache_tree used
Records accurate byte ranges which are used by old filesystem.
This will be used to create old filesystem image.

2) struct cache_tree data_chunks
Records batched ranges which must be covered by data chunks.
The bytenr range is optimized to meet all the chunk requirement.

3) u64 total_bytenr
Records how large the filesystem is in bytenr.
Yes, we can calculate it easy, but that's for old blocks based
filesystem.
This will make it more friendly for extent based filesystem.
And later cctx->block_counts and may be removed

And 2 for mkfs_config:
1) char *chunk_uuid.
Used as temporary chunk_uuid (unparsed) string for later
make_convert_btrfs()

2) u64 super_bytenr
Records the new temporary super bytenr after make_btrfs().

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 btrfs-convert.c | 29 +++++++++++++++++++++++++++++
 utils.h         |  4 ++++
 2 files changed, 33 insertions(+)

diff --git a/btrfs-convert.c b/btrfs-convert.c
index 00bac51..4baa68e 100644
--- a/btrfs-convert.c
+++ b/btrfs-convert.c
@@ -101,11 +101,36 @@ struct btrfs_convert_context {
 	u32 block_count;
 	u32 inodes_count;
 	u32 free_inodes_count;
+	u64 total_bytes;
 	char *volume_name;
 	const struct btrfs_convert_operations *convert_ops;
+
+	/* The accurate used space of old filesystem */
+	struct cache_tree used;
+
+	/* Batched ranges which must be covered by data chunks */
+	struct cache_tree data_chunks;
+
+	/* Free space which is not covered by data_chunks */
+	struct cache_tree free;
+
 	void *fs_data;
 };
 
+static void init_convert_context(struct btrfs_convert_context *cctx)
+{
+	cache_tree_init(&cctx->used);
+	cache_tree_init(&cctx->data_chunks);
+	cache_tree_init(&cctx->free);
+}
+
+static void clean_convert_context(struct btrfs_convert_context *cctx)
+{
+	free_extent_cache_tree(&cctx->used);
+	free_extent_cache_tree(&cctx->data_chunks);
+	free_extent_cache_tree(&cctx->free);
+}
+
 static inline int convert_alloc_block(struct btrfs_convert_context *cctx,
 				      u64 goal, u64 *ret)
 {
@@ -195,6 +220,7 @@ static int ext2_open_fs(struct btrfs_convert_context *cctx, const char *name)
 	cctx->fs_data = ext2_fs;
 	cctx->blocksize = ext2_fs->blocksize;
 	cctx->block_count = ext2_fs->super->s_blocks_count;
+	cctx->total_bytes = ext2_fs->blocksize * ext2_fs->super->s_blocks_count;
 	cctx->volume_name = strndup(ext2_fs->super->s_volume_name, 16);
 	cctx->first_data_block = ext2_fs->super->s_first_data_block;
 	cctx->inodes_count = ext2_fs->super->s_inodes_count;
@@ -2444,6 +2470,7 @@ static int do_convert(const char *devname, int datacsum, int packing, int noxatt
 	char features_buf[64];
 	struct btrfs_mkfs_config mkfs_cfg;
 
+	init_convert_context(&cctx);
 	ret = convert_open_fs(devname, &cctx);
 	if (ret)
 		goto fail;
@@ -2594,6 +2621,7 @@ static int do_convert(const char *devname, int datacsum, int packing, int noxatt
 		goto fail;
 	}
 	convert_close_fs(&cctx);
+	clean_convert_context(&cctx);
 
 	/*
 	 * If this step succeed, we get a mountable btrfs. Otherwise
@@ -2623,6 +2651,7 @@ static int do_convert(const char *devname, int datacsum, int packing, int noxatt
 	printf("conversion complete.\n");
 	return 0;
 fail:
+	clean_convert_context(&cctx);
 	if (fd != -1)
 		close(fd);
 	if (is_btrfs)
diff --git a/utils.h b/utils.h
index 6f3824c..493c2e4 100644
--- a/utils.h
+++ b/utils.h
@@ -109,12 +109,16 @@ void btrfs_parse_features_to_string(char *buf, u64 flags);
 struct btrfs_mkfs_config {
 	char *label;
 	char *fs_uuid;
+	char *chunk_uuid;
 	u64 blocks[8];
 	u64 num_bytes;
 	u32 nodesize;
 	u32 sectorsize;
 	u32 stripesize;
 	u64 features;
+
+	/* Super bytenr after make_btrfs */
+	u64 super_bytenr;
 };
 
 int make_btrfs(int fd, struct btrfs_mkfs_config *cfg);
-- 
2.6.2



