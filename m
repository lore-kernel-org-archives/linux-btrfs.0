Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:42491 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755769AbcE0BZP (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 26 May 2016 21:25:15 -0400
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH 2/2] Btrfs-progs: convert: add hint bytenr when allocating free space
Date: Thu, 26 May 2016 18:26:50 -0700
Message-Id: <1464312410-10999-2-git-send-email-bo.li.liu@oracle.com>
In-Reply-To: <1464312410-10999-1-git-send-email-bo.li.liu@oracle.com>
References: <1464312410-10999-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Without proper hint, btrfs-convert always starts searching
from the very first available block which usually belongs
to SYSTEM block group, but we're not allowed to use any
block in SYSTEM block group for metadata/data.

This adds hint to make convert smarter.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 btrfs-convert.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/btrfs-convert.c b/btrfs-convert.c
index 550aa8f..fd807ef 100644
--- a/btrfs-convert.c
+++ b/btrfs-convert.c
@@ -1399,6 +1399,7 @@ static int create_image(struct btrfs_convert_context *cctx,
 	u64 total_bytes;
 	u64 flags = BTRFS_INODE_READONLY;
 	u32 sectorsize = root->sectorsize;
+	u64 hint = 0;
 
 	total_bytes = btrfs_super_total_bytes(fs_info->super_copy);
 	first_free =  BTRFS_SUPER_INFO_OFFSET + sectorsize * 2 - 1;
@@ -1427,9 +1428,11 @@ static int create_image(struct btrfs_convert_context *cctx,
 	 * special, we can't rely on relocate_extents_range to relocate it.
 	 */
 	for (last_byte = 0; last_byte < first_free; last_byte += sectorsize) {
-		ret = custom_alloc_extent(root, sectorsize, 0, &key, 0);
+		ret = custom_alloc_extent(root, sectorsize, hint, &key, 0);
 		if (ret)
 			goto fail;
+
+		hint = key.objectid;
 		ret = copy_disk_extent(root, key.objectid, last_byte,
 				       sectorsize);
 		if (ret)
@@ -2085,7 +2088,7 @@ static int relocate_one_reference(struct btrfs_trans_handle *trans,
 			ret = get_state_private(reloc_tree, bytenr, &new_pos);
 			BUG_ON(ret);
 		} else {
-			ret = custom_alloc_extent(root, sectorsize, 0, &key, 0);
+			ret = custom_alloc_extent(root, sectorsize, new_pos, &key, 0);
 			if (ret)
 				goto fail;
 			new_pos = key.objectid;
-- 
2.5.0

