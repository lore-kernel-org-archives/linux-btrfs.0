Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pl1-f196.google.com ([209.85.214.196]:38130 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727477AbeIACq1 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 31 Aug 2018 22:46:27 -0400
Received: by mail-pl1-f196.google.com with SMTP id u11-v6so6068080plq.5
        for <linux-btrfs@vger.kernel.org>; Fri, 31 Aug 2018 15:36:52 -0700 (PDT)
From: Omar Sandoval <osandov@osandov.com>
To: linux-btrfs@vger.kernel.org
Cc: kernel-team@fb.com
Subject: [PATCH v5 5/6] Btrfs: rename get_chunk_map() and make it non-static
Date: Fri, 31 Aug 2018 15:36:40 -0700
Message-Id: <f5fc673814ace25a208ddfe8613cb675ae561cc6.1535754957.git.osandov@fb.com>
In-Reply-To: <cover.1535754957.git.osandov@fb.com>
References: <cover.1535754957.git.osandov@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Omar Sandoval <osandov@fb.com>

The Btrfs swap code is going to need it, so give it a btrfs_ prefix and
make it non-static.

Signed-off-by: Omar Sandoval <osandov@fb.com>
---
 fs/btrfs/volumes.c | 22 +++++++++++-----------
 fs/btrfs/volumes.h |  9 +++++++++
 2 files changed, 20 insertions(+), 11 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index c03ef5322689..0aa8aff6774b 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -2712,8 +2712,8 @@ static int btrfs_del_sys_chunk(struct btrfs_fs_info *fs_info, u64 chunk_offset)
 	return ret;
 }
 
-static struct extent_map *get_chunk_map(struct btrfs_fs_info *fs_info,
-					u64 logical, u64 length)
+struct extent_map *btrfs_get_chunk_map(struct btrfs_fs_info *fs_info,
+				       u64 logical, u64 length)
 {
 	struct extent_map_tree *em_tree;
 	struct extent_map *em;
@@ -2750,7 +2750,7 @@ int btrfs_remove_chunk(struct btrfs_trans_handle *trans, u64 chunk_offset)
 	int i, ret = 0;
 	struct btrfs_fs_devices *fs_devices = fs_info->fs_devices;
 
-	em = get_chunk_map(fs_info, chunk_offset, 1);
+	em = btrfs_get_chunk_map(fs_info, chunk_offset, 1);
 	if (IS_ERR(em)) {
 		/*
 		 * This is a logic error, but we don't want to just rely on the
@@ -4884,7 +4884,7 @@ int btrfs_finish_chunk_alloc(struct btrfs_trans_handle *trans,
 	int i = 0;
 	int ret = 0;
 
-	em = get_chunk_map(fs_info, chunk_offset, chunk_size);
+	em = btrfs_get_chunk_map(fs_info, chunk_offset, chunk_size);
 	if (IS_ERR(em))
 		return PTR_ERR(em);
 
@@ -5026,7 +5026,7 @@ int btrfs_chunk_readonly(struct btrfs_fs_info *fs_info, u64 chunk_offset)
 	int miss_ndevs = 0;
 	int i;
 
-	em = get_chunk_map(fs_info, chunk_offset, 1);
+	em = btrfs_get_chunk_map(fs_info, chunk_offset, 1);
 	if (IS_ERR(em))
 		return 1;
 
@@ -5086,7 +5086,7 @@ int btrfs_num_copies(struct btrfs_fs_info *fs_info, u64 logical, u64 len)
 	struct map_lookup *map;
 	int ret;
 
-	em = get_chunk_map(fs_info, logical, len);
+	em = btrfs_get_chunk_map(fs_info, logical, len);
 	if (IS_ERR(em))
 		/*
 		 * We could return errors for these cases, but that could get
@@ -5132,7 +5132,7 @@ unsigned long btrfs_full_stripe_len(struct btrfs_fs_info *fs_info,
 	struct map_lookup *map;
 	unsigned long len = fs_info->sectorsize;
 
-	em = get_chunk_map(fs_info, logical, len);
+	em = btrfs_get_chunk_map(fs_info, logical, len);
 
 	if (!WARN_ON(IS_ERR(em))) {
 		map = em->map_lookup;
@@ -5149,7 +5149,7 @@ int btrfs_is_parity_mirror(struct btrfs_fs_info *fs_info, u64 logical, u64 len)
 	struct map_lookup *map;
 	int ret = 0;
 
-	em = get_chunk_map(fs_info, logical, len);
+	em = btrfs_get_chunk_map(fs_info, logical, len);
 
 	if(!WARN_ON(IS_ERR(em))) {
 		map = em->map_lookup;
@@ -5308,7 +5308,7 @@ static int __btrfs_map_block_for_discard(struct btrfs_fs_info *fs_info,
 	/* discard always return a bbio */
 	ASSERT(bbio_ret);
 
-	em = get_chunk_map(fs_info, logical, length);
+	em = btrfs_get_chunk_map(fs_info, logical, length);
 	if (IS_ERR(em))
 		return PTR_ERR(em);
 
@@ -5634,7 +5634,7 @@ static int __btrfs_map_block(struct btrfs_fs_info *fs_info,
 		return __btrfs_map_block_for_discard(fs_info, logical,
 						     *length, bbio_ret);
 
-	em = get_chunk_map(fs_info, logical, *length);
+	em = btrfs_get_chunk_map(fs_info, logical, *length);
 	if (IS_ERR(em))
 		return PTR_ERR(em);
 
@@ -5933,7 +5933,7 @@ int btrfs_rmap_block(struct btrfs_fs_info *fs_info, u64 chunk_start,
 	u64 rmap_len;
 	int i, j, nr = 0;
 
-	em = get_chunk_map(fs_info, chunk_start, 1);
+	em = btrfs_get_chunk_map(fs_info, chunk_start, 1);
 	if (IS_ERR(em))
 		return -EIO;
 
diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index 23e9285d88de..d68c8a05a774 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -465,6 +465,15 @@ unsigned long btrfs_full_stripe_len(struct btrfs_fs_info *fs_info,
 int btrfs_finish_chunk_alloc(struct btrfs_trans_handle *trans,
 			     u64 chunk_offset, u64 chunk_size);
 int btrfs_remove_chunk(struct btrfs_trans_handle *trans, u64 chunk_offset);
+/**
+ * btrfs_get_chunk_map() - Find the mapping containing the given logical extent.
+ * @logical: Logical block offset in bytes.
+ * @length: Length of extent in bytes.
+ *
+ * Return: Chunk mapping or ERR_PTR.
+ */
+struct extent_map *btrfs_get_chunk_map(struct btrfs_fs_info *fs_info,
+				       u64 logical, u64 length);
 
 static inline void btrfs_dev_stat_inc(struct btrfs_device *dev,
 				      int index)
-- 
2.18.0
