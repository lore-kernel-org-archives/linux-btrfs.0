Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:8878 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1161927AbbKTD1V (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 19 Nov 2015 22:27:21 -0500
Received: from localhost.localdomain (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id tAK3PqdW022290
	for <linux-btrfs@vger.kernel.org>; Fri, 20 Nov 2015 11:26:35 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 23/25] btrfs-progs: Convert: Add support for rollback new convert behavior
Date: Fri, 20 Nov 2015 11:24:27 +0800
Message-Id: <1447989869-24739-24-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1447989869-24739-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1447989869-24739-1-git-send-email-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Add support to rollback new btrfs-convert.

The support is quite easy unlike the new convert behavior, which only
needs to check if there is block group covering the reserved ranges.

Old convert behavior ensure there is always a system chunk covering
reserved ranges.
The new one ensure there is no chunk covering them.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 btrfs-convert.c | 23 ++++++++++++++++++-----
 1 file changed, 18 insertions(+), 5 deletions(-)

diff --git a/btrfs-convert.c b/btrfs-convert.c
index 8079aea..1d09141 100644
--- a/btrfs-convert.c
+++ b/btrfs-convert.c
@@ -3451,11 +3451,23 @@ static int do_rollback(const char *devname)
 		num_bytes = btrfs_file_extent_num_bytes(leaf, fi);
 
 		cache1 = btrfs_lookup_block_group(root->fs_info, offset);
-		cache2 =  btrfs_lookup_block_group(root->fs_info,
-						   offset + num_bytes - 1);
-		if (!cache1 || cache1 != cache2 ||
-		    (!(cache1->flags & BTRFS_BLOCK_GROUP_SYSTEM) &&
-		     !intersect_with_sb(offset, num_bytes)))
+		cache2 = btrfs_lookup_block_group(root->fs_info,
+						  offset + num_bytes - 1);
+		/*
+		 * Here we must take consideration of old and new convert
+		 * behavior.
+		 * For old convert case, there should be a SYSTEM chunk
+		 * covering the relocated extents
+		 * For new convert case, all reserved range or sb block
+		 * is not and should not be covered by any chunk.
+		 * Or we are unable to rebuild the extent map
+		 * Anyway, they should be covered by the same chunk
+		 */
+		if (cache1 != cache2)
+			break;
+		/* Old convert behavior, should be covered by SYS chunk*/
+		if (cache1 && !(cache1->flags & BTRFS_BLOCK_GROUP_SYSTEM) &&
+		    !intersect_with_sb(offset, num_bytes))
 			break;
 
 		set_extent_bits(&io_tree, offset, offset + num_bytes - 1,
@@ -3469,6 +3481,7 @@ next_extent:
 
 	if (offset < total_bytes) {
 		fprintf(stderr, "unable to build extent mapping\n");
+		fprintf(stderr, "converted filesystem after balance is unable to rollback\n");
 		goto fail;
 	}
 
-- 
2.6.2

