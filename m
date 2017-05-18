Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:46077 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S932199AbdERDj0 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 17 May 2017 23:39:26 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>, <dsterba@suse.cz>
Subject: [PATCH 20/32] btrfs-progs: Refactor sectorsizes users in file-item.c
Date: Thu, 18 May 2017 11:38:45 +0800
Message-ID: <20170518033857.15002-21-quwenruo@cn.fujitsu.com>
In-Reply-To: <20170518033857.15002-1-quwenruo@cn.fujitsu.com>
References: <20170518033857.15002-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 file-item.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/file-item.c b/file-item.c
index 333fa339..6877a1a9 100644
--- a/file-item.c
+++ b/file-item.c
@@ -162,7 +162,8 @@ btrfs_lookup_csum(struct btrfs_trans_handle *trans,
 		if (found_key.type != BTRFS_EXTENT_CSUM_KEY)
 			goto fail;
 
-		csum_offset = (bytenr - found_key.offset) / root->sectorsize;
+		csum_offset = (bytenr - found_key.offset) /
+				root->fs_info->sectorsize;
 		csums_in_item = btrfs_item_size_nr(leaf, path->slots[0]);
 		csums_in_item /= csum_size;
 
@@ -195,6 +196,7 @@ int btrfs_csum_file_block(struct btrfs_trans_handle *trans,
 	struct extent_buffer *leaf = NULL;
 	u64 csum_offset;
 	u32 csum_result = ~(u32)0;
+	u32 sectorsize = root->fs_info->sectorsize;
 	u32 nritems;
 	u32 ins_size;
 	u16 csum_size =
@@ -265,7 +267,7 @@ int btrfs_csum_file_block(struct btrfs_trans_handle *trans,
 	path->slots[0]--;
 	leaf = path->nodes[0];
 	btrfs_item_key_to_cpu(leaf, &found_key, path->slots[0]);
-	csum_offset = (file_key.offset - found_key.offset) / root->sectorsize;
+	csum_offset = (file_key.offset - found_key.offset) / sectorsize;
 	if (found_key.objectid != BTRFS_EXTENT_CSUM_OBJECTID ||
 	    found_key.type != BTRFS_EXTENT_CSUM_KEY ||
 	    csum_offset >= MAX_CSUM_ITEMS(root, csum_size)) {
@@ -288,7 +290,7 @@ insert:
 	if (found_next) {
 		u64 tmp = min(alloc_end, next_offset);
 		tmp -= file_key.offset;
-		tmp /= root->sectorsize;
+		tmp /= sectorsize;
 		tmp = max((u64)1, tmp);
 		tmp = min(tmp, (u64)MAX_CSUM_ITEMS(root, csum_size));
 		ins_size = csum_size * tmp;
@@ -346,12 +348,12 @@ static noinline int truncate_one_csum(struct btrfs_root *root,
 		btrfs_super_csum_size(root->fs_info->super_copy);
 	u64 csum_end;
 	u64 end_byte = bytenr + len;
-	u32 blocksize = root->sectorsize;
+	u32 blocksize = root->fs_info->sectorsize;
 	int ret;
 
 	leaf = path->nodes[0];
 	csum_end = btrfs_item_size_nr(leaf, path->slots[0]) / csum_size;
-	csum_end *= root->sectorsize;
+	csum_end *= root->fs_info->sectorsize;
 	csum_end += key->offset;
 
 	if (key->offset < bytenr && csum_end <= end_byte) {
@@ -403,7 +405,7 @@ int btrfs_del_csums(struct btrfs_trans_handle *trans,
 	int ret;
 	u16 csum_size =
 		btrfs_super_csum_size(root->fs_info->super_copy);
-	int blocksize = root->sectorsize;
+	int blocksize = root->fs_info->sectorsize;
 
 	root = root->fs_info->csum_root;
 
-- 
2.13.0



