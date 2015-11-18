Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:62127 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753709AbbKRHYl (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 18 Nov 2015 02:24:41 -0500
Received: from localhost.localdomain (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id tAI7NoRw007932
	for <linux-btrfs@vger.kernel.org>; Wed, 18 Nov 2015 15:23:52 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [RFC PATCH 03/22] btrfs-progs: Add new init/free function and member for mkfs_config
Date: Wed, 18 Nov 2015 15:22:03 +0800
Message-Id: <1447831342-15056-4-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1447831342-15056-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1447831342-15056-1-git-send-email-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Add new members for mkfs_config:
1. super_bytenr
   For convert case to restore where super block is allocated.
   Has no use for normal mkfs case.

2. convert_used
   A cache tree to record which ranges are used in original filesystem.
   This will gives the guide for later convert implement to provide better
   system/meta chunk allocation, other than just allocating them into
   range covered by DATA chunk.

3. chunk_uuid
   Chunk tree uuid, used for later per tree root initialization.

Since convert_used is a cache_tree, it needs to be initialized and freed
properly, add new init/free function for it too.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 btrfs-convert.c |  5 +++++
 mkfs.c          |  2 ++
 utils.h         | 29 +++++++++++++++++++++++++++++
 3 files changed, 36 insertions(+)

diff --git a/btrfs-convert.c b/btrfs-convert.c
index 02e5cdb..f66affd 100644
--- a/btrfs-convert.c
+++ b/btrfs-convert.c
@@ -2322,6 +2322,9 @@ static int do_convert(const char *devname, int datacsum, int packing, int noxatt
 	}
 	if (btrfs_check_nodesize(nodesize, blocksize, features))
 		goto fail;
+
+	init_mkfs_config(&mkfs_cfg);
+
 	blocks_per_node = nodesize / blocksize;
 	ret = -blocks_per_node;
 	for (i = 0; i < 7; i++) {
@@ -2479,6 +2482,8 @@ static int do_convert(const char *devname, int datacsum, int packing, int noxatt
 	printf("conversion complete.\n");
 	return 0;
 fail:
+	free_mkfs_config(&mkfs_cfg);
+
 	if (fd != -1)
 		close(fd);
 	if (is_btrfs)
diff --git a/mkfs.c b/mkfs.c
index 5f1411f..306be51 100644
--- a/mkfs.c
+++ b/mkfs.c
@@ -1669,6 +1669,7 @@ int main(int ac, char **av)
 			"WARNING: metatdata has lower redundancy than data!\n\n");
 	}
 
+	init_mkfs_config(&mkfs_cfg);
 	mkfs_cfg.label = label;
 	mkfs_cfg.fs_uuid = fs_uuid;
 	memcpy(mkfs_cfg.blocks, blocks, sizeof(blocks));
@@ -1839,6 +1840,7 @@ raid_groups:
 	}
 
 out:
+	free_mkfs_config(&mkfs_cfg);
 	ret = close_ctree(root);
 	BUG_ON(ret);
 	btrfs_close_all_devices();
diff --git a/utils.h b/utils.h
index b625330..dff2633 100644
--- a/utils.h
+++ b/utils.h
@@ -109,14 +109,43 @@ void btrfs_parse_features_to_string(char *buf, u64 flags);
 struct btrfs_mkfs_config {
 	char *label;
 	char *fs_uuid;
+	char *chunk_uuid;
+
 	u64 blocks[8];
 	u64 num_bytes;
 	u32 nodesize;
 	u32 sectorsize;
 	u32 stripesize;
 	u64 features;
+
+	/*
+	 * Already used space in original filesystem before convert.
+	 * For normal mkfs case, it should be empty.
+	 */
+	struct cache_tree convert_used;
+
+	/*
+	 * Super block bytenr.
+	 * For normal mkfs case, it shouldn't be used as mkfs doesn't support
+	 * change super block bytenr anymore.
+	 *
+	 * For convert use, it restore the superblock bytenr from the temporary
+	 * btrfs fs.
+	 */
+	u64 super_bytenr;
 };
 
+static inline void init_mkfs_config(struct btrfs_mkfs_config *cfg)
+{
+	memset(cfg, 0, sizeof(*cfg));
+	cache_tree_init(&cfg->convert_used);
+}
+
+static inline void free_mkfs_config(struct btrfs_mkfs_config *cfg)
+{
+	free_extent_cache_tree(&cfg->convert_used);
+}
+
 int make_btrfs(int fd, struct btrfs_mkfs_config *cfg);
 int btrfs_make_root_dir(struct btrfs_trans_handle *trans,
 			struct btrfs_root *root, u64 objectid);
-- 
2.6.2

