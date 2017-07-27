Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:50512 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751726AbdG0IRF (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 27 Jul 2017 04:17:05 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 7C97AABBC
        for <linux-btrfs@vger.kernel.org>; Thu, 27 Jul 2017 08:17:03 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 2/2] btrfs-progs: Use named constants for common sizes
Date: Thu, 27 Jul 2017 11:17:00 +0300
Message-Id: <1501143420-28062-2-git-send-email-nborisov@suse.com>
In-Reply-To: <1501143420-28062-1-git-send-email-nborisov@suse.com>
References: <1501143420-28062-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

There multiple places where we use well-known sizes - 1,8,16,32 megabytes. We
also have them defined as constants in the sizes.h header. So let's use them.
No functional changes.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 convert/main.c |  8 ++++----
 mkfs/common.c  |  2 +-
 mkfs/main.c    | 10 +++++-----
 3 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/convert/main.c b/convert/main.c
index c56382e915fd..49ab829b5641 100644
--- a/convert/main.c
+++ b/convert/main.c
@@ -630,7 +630,7 @@ static int calculate_available_space(struct btrfs_convert_context *cctx)
 	 * Twice the minimal chunk size, to allow later wipe_reserved_ranges()
 	 * works without need to consider overlap
 	 */
-	u64 min_stripe_size = 2 * 16 * 1024 * 1024;
+	u64 min_stripe_size = SZ_32M;
 	int ret;
 
 	/* Calculate data_chunks */
@@ -795,7 +795,7 @@ static int create_image(struct btrfs_root *root,
 	 * Start from 1M, as 0~1M is reserved, and create_image_file_range()
 	 * can't handle bytenr 0(will consider it as a hole)
 	 */
-	cur = 1024 * 1024;
+	cur = SZ_1M;
 	while (cur < size) {
 		u64 len = size - cur;
 
@@ -1010,7 +1010,7 @@ static int make_convert_data_block_groups(struct btrfs_trans_handle *trans,
 	 * And for single chunk, don't create chunk larger than 1G.
 	 */
 	max_chunk_size = cfg->num_bytes / 10;
-	max_chunk_size = min((u64)(1024 * 1024 * 1024), max_chunk_size);
+	max_chunk_size = min((u64)(SZ_1G), max_chunk_size);
 	max_chunk_size = round_down(max_chunk_size, extent_root->sectorsize);
 
 	for (cache = first_cache_extent(data_chunks); cache;
@@ -1586,7 +1586,7 @@ next:
  * |   RSV 1   |  | Old  |   |    RSV 2  | | Old  | |   RSV 3   |
  * |   0~1M    |  | Fs   |   | SB2 + 64K | | Fs   | | SB3 + 64K |
  *
- * On the other hande, the converted fs image in btrfs is a completely 
+ * On the other hande, the converted fs image in btrfs is a completely
  * valid old fs.
  *
  * |<-----------------Converted fs image in btrfs-------------------->|
diff --git a/mkfs/common.c b/mkfs/common.c
index 1e8f26ea4dda..5fbd38c1230b 100644
--- a/mkfs/common.c
+++ b/mkfs/common.c
@@ -95,7 +95,7 @@ int make_btrfs(int fd, struct btrfs_mkfs_config *cfg)
 
 	cfg->blocks[0] = BTRFS_SUPER_INFO_OFFSET;
 	for (i = 1; i < 7; i++) {
-		cfg->blocks[i] = BTRFS_SUPER_INFO_OFFSET + 1024 * 1024 +
+		cfg->blocks[i] = BTRFS_SUPER_INFO_OFFSET + SZ_1M +
 			cfg->nodesize * i;
 	}
 
diff --git a/mkfs/main.c b/mkfs/main.c
index 61f746b30e7c..b89f7d1af903 100644
--- a/mkfs/main.c
+++ b/mkfs/main.c
@@ -716,7 +716,7 @@ again:
 	 * keep our extent size at 1MB max, this makes it easier to work inside
 	 * the tiny block groups created during mkfs
 	 */
-	cur_bytes = min(total_bytes, 1024ULL * 1024);
+	cur_bytes = min(total_bytes, (u64)SZ_1M);
 	ret = btrfs_reserve_extent(trans, root, cur_bytes, 0, 0, (u64)-1,
 				   &key, 1);
 	if (ret)
@@ -988,7 +988,7 @@ static int create_chunks(struct btrfs_trans_handle *trans,
 	u64 chunk_size;
 	u64 meta_type = BTRFS_BLOCK_GROUP_METADATA;
 	u64 data_type = BTRFS_BLOCK_GROUP_DATA;
-	u64 minimum_data_chunk_size = 8 * 1024 * 1024;
+	u64 minimum_data_chunk_size = SZ_8M;
 	u64 i;
 	int ret;
 
@@ -1092,9 +1092,9 @@ static u64 size_sourcedir(const char *dir_name, u64 sectorsize,
 	u64 dir_size = 0;
 	u64 total_size = 0;
 	int ret;
-	u64 default_chunk_size = 8 * 1024 * 1024;	/* 8MB */
-	u64 allocated_meta_size = 8 * 1024 * 1024;	/* 8MB */
-	u64 allocated_total_size = 20 * 1024 * 1024;	/* 20MB */
+	u64 default_chunk_size = SZ_8M;
+	u64 allocated_meta_size = SZ_8M;
+	u64 allocated_total_size = 20 * SZ_1M;	/* 20MB */
 	u64 num_of_meta_chunks = 0;
 	u64 num_of_data_chunks = 0;
 	u64 num_of_allocated_meta_chunks =
-- 
2.7.4

