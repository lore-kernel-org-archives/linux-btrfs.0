Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pg0-f67.google.com ([74.125.83.67]:44802 "EHLO
        mail-pg0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S971637AbeEXVlp (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 24 May 2018 17:41:45 -0400
Received: by mail-pg0-f67.google.com with SMTP id p21-v6so1347642pgd.11
        for <linux-btrfs@vger.kernel.org>; Thu, 24 May 2018 14:41:45 -0700 (PDT)
From: Omar Sandoval <osandov@osandov.com>
To: linux-btrfs@vger.kernel.org
Cc: kernel-team@fb.com, linux-fsdevel@vger.kernel.org,
        Tejun Heo <tj@kernel.org>
Subject: [RFC PATCH v4 5/6] Btrfs: rename get_chunk_map() and make it non-static
Date: Thu, 24 May 2018 14:41:29 -0700
Message-Id: <ad156ee9fa4c91c2760a60745f42773d0032824b.1527197312.git.osandov@fb.com>
In-Reply-To: <cover.1527197312.git.osandov@fb.com>
References: <cover.1527197312.git.osandov@fb.com>
In-Reply-To: <cover.1527197312.git.osandov@fb.com>
References: <cover.1527197312.git.osandov@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Omar Sandoval <osandov@fb.com>

The Btrfs swap code is going to need it, so give it a btrfs_ prefix and
make it non-static.

Signed-off-by: Omar Sandoval <osandov@fb.com>
---
 fs/btrfs/volumes.c | 22 +++++++++++-----------
 fs/btrfs/volumes.h |  2 ++
 2 files changed, 13 insertions(+), 11 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 33b3d329ebb9..6e1a89c6b362 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -2789,8 +2789,8 @@ static int btrfs_del_sys_chunk(struct btrfs_fs_info *fs_info, u64 chunk_offset)
 	return ret;
 }
 
-static struct extent_map *get_chunk_map(struct btrfs_fs_info *fs_info,
-					u64 logical, u64 length)
+struct extent_map *btrfs_get_chunk_map(struct btrfs_fs_info *fs_info,
+				       u64 logical, u64 length)
 {
 	struct extent_map_tree *em_tree;
 	struct extent_map *em;
@@ -2827,7 +2827,7 @@ int btrfs_remove_chunk(struct btrfs_trans_handle *trans,
 	int i, ret = 0;
 	struct btrfs_fs_devices *fs_devices = fs_info->fs_devices;
 
-	em = get_chunk_map(fs_info, chunk_offset, 1);
+	em = btrfs_get_chunk_map(fs_info, chunk_offset, 1);
 	if (IS_ERR(em)) {
 		/*
 		 * This is a logic error, but we don't want to just rely on the
@@ -4962,7 +4962,7 @@ int btrfs_finish_chunk_alloc(struct btrfs_trans_handle *trans,
 	int i = 0;
 	int ret = 0;
 
-	em = get_chunk_map(fs_info, chunk_offset, chunk_size);
+	em = btrfs_get_chunk_map(fs_info, chunk_offset, chunk_size);
 	if (IS_ERR(em))
 		return PTR_ERR(em);
 
@@ -5105,7 +5105,7 @@ int btrfs_chunk_readonly(struct btrfs_fs_info *fs_info, u64 chunk_offset)
 	int miss_ndevs = 0;
 	int i;
 
-	em = get_chunk_map(fs_info, chunk_offset, 1);
+	em = btrfs_get_chunk_map(fs_info, chunk_offset, 1);
 	if (IS_ERR(em))
 		return 1;
 
@@ -5165,7 +5165,7 @@ int btrfs_num_copies(struct btrfs_fs_info *fs_info, u64 logical, u64 len)
 	struct map_lookup *map;
 	int ret;
 
-	em = get_chunk_map(fs_info, logical, len);
+	em = btrfs_get_chunk_map(fs_info, logical, len);
 	if (IS_ERR(em))
 		/*
 		 * We could return errors for these cases, but that could get
@@ -5211,7 +5211,7 @@ unsigned long btrfs_full_stripe_len(struct btrfs_fs_info *fs_info,
 	struct map_lookup *map;
 	unsigned long len = fs_info->sectorsize;
 
-	em = get_chunk_map(fs_info, logical, len);
+	em = btrfs_get_chunk_map(fs_info, logical, len);
 
 	if (!WARN_ON(IS_ERR(em))) {
 		map = em->map_lookup;
@@ -5228,7 +5228,7 @@ int btrfs_is_parity_mirror(struct btrfs_fs_info *fs_info, u64 logical, u64 len)
 	struct map_lookup *map;
 	int ret = 0;
 
-	em = get_chunk_map(fs_info, logical, len);
+	em = btrfs_get_chunk_map(fs_info, logical, len);
 
 	if(!WARN_ON(IS_ERR(em))) {
 		map = em->map_lookup;
@@ -5387,7 +5387,7 @@ static int __btrfs_map_block_for_discard(struct btrfs_fs_info *fs_info,
 	/* discard always return a bbio */
 	ASSERT(bbio_ret);
 
-	em = get_chunk_map(fs_info, logical, length);
+	em = btrfs_get_chunk_map(fs_info, logical, length);
 	if (IS_ERR(em))
 		return PTR_ERR(em);
 
@@ -5713,7 +5713,7 @@ static int __btrfs_map_block(struct btrfs_fs_info *fs_info,
 		return __btrfs_map_block_for_discard(fs_info, logical,
 						     *length, bbio_ret);
 
-	em = get_chunk_map(fs_info, logical, *length);
+	em = btrfs_get_chunk_map(fs_info, logical, *length);
 	if (IS_ERR(em))
 		return PTR_ERR(em);
 
@@ -6012,7 +6012,7 @@ int btrfs_rmap_block(struct btrfs_fs_info *fs_info, u64 chunk_start,
 	u64 rmap_len;
 	int i, j, nr = 0;
 
-	em = get_chunk_map(fs_info, chunk_start, 1);
+	em = btrfs_get_chunk_map(fs_info, chunk_start, 1);
 	if (IS_ERR(em))
 		return -EIO;
 
diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index 5139ec8daf4c..d3dedfd1324b 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -467,6 +467,8 @@ unsigned long btrfs_full_stripe_len(struct btrfs_fs_info *fs_info,
 int btrfs_finish_chunk_alloc(struct btrfs_trans_handle *trans,
 				struct btrfs_fs_info *fs_info,
 				u64 chunk_offset, u64 chunk_size);
+struct extent_map *btrfs_get_chunk_map(struct btrfs_fs_info *fs_info,
+				       u64 logical, u64 length);
 int btrfs_remove_chunk(struct btrfs_trans_handle *trans,
 		       struct btrfs_fs_info *fs_info, u64 chunk_offset);
 
-- 
2.17.0

