Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:46077 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S932172AbdERDjX (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 17 May 2017 23:39:23 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>, <dsterba@suse.cz>
Subject: [PATCH 26/32] btrfs-progs: Refactor sectorsize users in convert/main.c
Date: Thu, 18 May 2017 11:38:51 +0800
Message-ID: <20170518033857.15002-27-quwenruo@cn.fujitsu.com>
In-Reply-To: <20170518033857.15002-1-quwenruo@cn.fujitsu.com>
References: <20170518033857.15002-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 convert/main.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/convert/main.c b/convert/main.c
index c56382e9..bf050132 100644
--- a/convert/main.c
+++ b/convert/main.c
@@ -159,7 +159,7 @@ static int csum_disk_extent(struct btrfs_trans_handle *trans,
 			    struct btrfs_root *root,
 			    u64 disk_bytenr, u64 num_bytes)
 {
-	u32 blocksize = root->sectorsize;
+	u32 blocksize = root->fs_info->sectorsize;
 	u64 offset;
 	char *buffer;
 	int ret = 0;
@@ -199,12 +199,12 @@ static int create_image_file_range(struct btrfs_trans_handle *trans,
 	int ret;
 	u32 datacsum = convert_flags & CONVERT_FLAG_DATACSUM;
 
-	if (bytenr != round_down(bytenr, root->sectorsize)) {
+	if (bytenr != round_down(bytenr, root->fs_info->sectorsize)) {
 		error("bytenr not sectorsize aligned: %llu",
 				(unsigned long long)bytenr);
 		return -EINVAL;
 	}
-	if (len != round_down(len, root->sectorsize)) {
+	if (len != round_down(len, root->fs_info->sectorsize)) {
 		error("length not sectorsize aligned: %llu",
 				(unsigned long long)len);
 		return -EINVAL;
@@ -293,7 +293,7 @@ static int create_image_file_range(struct btrfs_trans_handle *trans,
 			    bg_cache->key.offset - bytenr);
 	}
 
-	if (len != round_down(len, root->sectorsize)) {
+	if (len != round_down(len, root->fs_info->sectorsize)) {
 		error("remaining length not sectorsize aligned: %llu",
 				(unsigned long long)len);
 		return -EINVAL;
@@ -346,7 +346,7 @@ static int migrate_one_reserved_range(struct btrfs_trans_handle *trans,
 		cur_off = max(cache->start, cur_off);
 		cur_len = min(cache->start + cache->size, range_end(range)) -
 			  cur_off;
-		BUG_ON(cur_len < root->sectorsize);
+		BUG_ON(cur_len < root->fs_info->sectorsize);
 
 		/* reserve extent for the data */
 		ret = btrfs_reserve_extent(trans, root, cur_len, 0, 0, (u64)-1,
@@ -1011,7 +1011,8 @@ static int make_convert_data_block_groups(struct btrfs_trans_handle *trans,
 	 */
 	max_chunk_size = cfg->num_bytes / 10;
 	max_chunk_size = min((u64)(1024 * 1024 * 1024), max_chunk_size);
-	max_chunk_size = round_down(max_chunk_size, extent_root->sectorsize);
+	max_chunk_size = round_down(max_chunk_size,
+				    extent_root->fs_info->sectorsize);
 
 	for (cache = first_cache_extent(data_chunks); cache;
 	     cache = next_cache_extent(cache)) {
-- 
2.13.0



