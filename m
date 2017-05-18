Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:43366 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S932185AbdERDjX (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 17 May 2017 23:39:23 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>, <dsterba@suse.cz>
Subject: [PATCH 23/32] btrfs-progs: Refactor sectorsize users in volumes.c
Date: Thu, 18 May 2017 11:38:48 +0800
Message-ID: <20170518033857.15002-24-quwenruo@cn.fujitsu.com>
In-Reply-To: <20170518033857.15002-1-quwenruo@cn.fujitsu.com>
References: <20170518033857.15002-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 volumes.c | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/volumes.c b/volumes.c
index b350e259..3fc5a624 100644
--- a/volumes.c
+++ b/volumes.c
@@ -1060,9 +1060,9 @@ again:
 	btrfs_set_stack_chunk_num_stripes(chunk, num_stripes);
 	btrfs_set_stack_chunk_io_align(chunk, stripe_len);
 	btrfs_set_stack_chunk_io_width(chunk, stripe_len);
-	btrfs_set_stack_chunk_sector_size(chunk, extent_root->sectorsize);
+	btrfs_set_stack_chunk_sector_size(chunk, info->sectorsize);
 	btrfs_set_stack_chunk_sub_stripes(chunk, sub_stripes);
-	map->sector_size = extent_root->sectorsize;
+	map->sector_size = info->sectorsize;
 	map->stripe_len = stripe_len;
 	map->io_align = stripe_len;
 	map->io_width = stripe_len;
@@ -1123,7 +1123,7 @@ int btrfs_alloc_data_chunk(struct btrfs_trans_handle *trans,
 	key.objectid = BTRFS_FIRST_CHUNK_TREE_OBJECTID;
 	key.type = BTRFS_CHUNK_ITEM_KEY;
 	if (convert) {
-		if (*start != round_down(*start, extent_root->sectorsize)) {
+		if (*start != round_down(*start, info->sectorsize)) {
 			error("DATA chunk start not sectorsize aligned: %llu",
 					(unsigned long long)*start);
 			return -EINVAL;
@@ -1188,9 +1188,9 @@ int btrfs_alloc_data_chunk(struct btrfs_trans_handle *trans,
 	btrfs_set_stack_chunk_num_stripes(chunk, num_stripes);
 	btrfs_set_stack_chunk_io_align(chunk, stripe_len);
 	btrfs_set_stack_chunk_io_width(chunk, stripe_len);
-	btrfs_set_stack_chunk_sector_size(chunk, extent_root->sectorsize);
+	btrfs_set_stack_chunk_sector_size(chunk, info->sectorsize);
 	btrfs_set_stack_chunk_sub_stripes(chunk, sub_stripes);
-	map->sector_size = extent_root->sectorsize;
+	map->sector_size = info->sectorsize;
 	map->stripe_len = stripe_len;
 	map->io_align = stripe_len;
 	map->io_width = stripe_len;
@@ -1685,6 +1685,7 @@ int btrfs_check_chunk_valid(struct btrfs_root *root,
 	u16 num_stripes;
 	u16 sub_stripes;
 	u64 type;
+	u32 sectorsize = root->fs_info->sectorsize;
 
 	length = btrfs_chunk_length(leaf, chunk);
 	stripe_len = btrfs_chunk_stripe_len(leaf, chunk);
@@ -1695,16 +1696,16 @@ int btrfs_check_chunk_valid(struct btrfs_root *root,
 	/*
 	 * These valid checks may be insufficient to cover every corner cases.
 	 */
-	if (!IS_ALIGNED(logical, root->sectorsize)) {
+	if (!IS_ALIGNED(logical, sectorsize)) {
 		error("invalid chunk logical %llu",  logical);
 		return -EIO;
 	}
-	if (btrfs_chunk_sector_size(leaf, chunk) != root->sectorsize) {
+	if (btrfs_chunk_sector_size(leaf, chunk) != sectorsize) {
 		error("invalid chunk sectorsize %llu", 
 		      (unsigned long long)btrfs_chunk_sector_size(leaf, chunk));
 		return -EIO;
 	}
-	if (!length || !IS_ALIGNED(length, root->sectorsize)) {
+	if (!length || !IS_ALIGNED(length, sectorsize)) {
 		error("invalid chunk length %llu",  length);
 		return -EIO;
 	}
-- 
2.13.0



