Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:22220 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1755023AbdERDjG (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 17 May 2017 23:39:06 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>, <dsterba@suse.cz>
Subject: [PATCH 07/32] btrfs-progs: Refactor block sizes users in chunk-recover.c
Date: Thu, 18 May 2017 11:38:32 +0800
Message-ID: <20170518033857.15002-8-quwenruo@cn.fujitsu.com>
In-Reply-To: <20170518033857.15002-1-quwenruo@cn.fujitsu.com>
References: <20170518033857.15002-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 chunk-recover.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/chunk-recover.c b/chunk-recover.c
index 96b939a3..08d2f07e 100644
--- a/chunk-recover.c
+++ b/chunk-recover.c
@@ -1070,7 +1070,7 @@ again:
 		    key.type == BTRFS_METADATA_ITEM_KEY) {
 			old_val = btrfs_super_bytes_used(fs_info->super_copy);
 			if (key.type == BTRFS_METADATA_ITEM_KEY)
-				old_val += root->nodesize;
+				old_val += fs_info->nodesize;
 			else
 				old_val += key.offset;
 			btrfs_set_super_bytes_used(fs_info->super_copy,
@@ -1086,7 +1086,7 @@ again:
 
 	if (key.objectid < end) {
 		if (key.type == BTRFS_BLOCK_GROUP_ITEM_KEY) {
-			key.objectid += root->sectorsize;
+			key.objectid += fs_info->sectorsize;
 			key.type = BTRFS_EXTENT_ITEM_KEY;
 			key.offset = 0;
 		}
@@ -1163,7 +1163,7 @@ static int __rebuild_chunk_root(struct btrfs_trans_handle *trans,
 	btrfs_set_disk_key_type(&disk_key, BTRFS_DEV_ITEM_KEY);
 	btrfs_set_disk_key_offset(&disk_key, min_devid);
 
-	cow = btrfs_alloc_free_block(trans, root, root->nodesize,
+	cow = btrfs_alloc_free_block(trans, root, root->fs_info->nodesize,
 				     BTRFS_CHUNK_TREE_OBJECTID,
 				     &disk_key, 0, 0, 0);
 	btrfs_set_header_bytenr(cow, cow->start);
@@ -1340,7 +1340,7 @@ static int calculate_bg_used(struct btrfs_root *extent_root,
 		    found_key.type != BTRFS_EXTENT_DATA_KEY)
 			goto next;
 		if (found_key.type == BTRFS_METADATA_ITEM_KEY)
-			used_ret += extent_root->nodesize;
+			used_ret += extent_root->fs_info->nodesize;
 		else
 			used_ret += found_key.offset;
 next:
@@ -1833,7 +1833,7 @@ static int next_csum(struct btrfs_root *root,
 	int ret = 0;
 	struct btrfs_root *csum_root = root->fs_info->csum_root;
 	struct btrfs_csum_item *csum_item;
-	u32 blocksize = root->sectorsize;
+	u32 blocksize = root->fs_info->sectorsize;
 	u16 csum_size = btrfs_super_csum_size(root->fs_info->super_copy);
 	int csums_in_item = btrfs_item_size_nr(*leaf, *slot) / csum_size;
 
@@ -1916,7 +1916,7 @@ out:
 
 static u64 item_end_offset(struct btrfs_root *root, struct btrfs_key *key,
 			   struct extent_buffer *leaf, int slot) {
-	u32 blocksize = root->sectorsize;
+	u32 blocksize = root->fs_info->sectorsize;
 	u16 csum_size = btrfs_super_csum_size(root->fs_info->super_copy);
 
 	u64 offset = btrfs_item_size_nr(leaf, slot);
@@ -2006,7 +2006,7 @@ static int rebuild_raid_data_chunk_stripes(struct recover_control *rc,
 	u64 chunk_end = chunk->offset + chunk->length;
 	u64 csum_offset = 0;
 	u64 data_offset;
-	u32 blocksize = root->sectorsize;
+	u32 blocksize = root->fs_info->sectorsize;
 	u32 tree_csum;
 	int index = 0;
 	int num_unordered = 0;
-- 
2.13.0



