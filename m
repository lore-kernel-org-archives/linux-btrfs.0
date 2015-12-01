Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:15517 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755285AbbLAHOg (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 1 Dec 2015 02:14:36 -0500
Received: from localhost.localdomain (unknown [10.167.226.34])
	by cn.fujitsu.com (Postfix) with ESMTP id 4984F40444CF
	for <linux-btrfs@vger.kernel.org>; Tue,  1 Dec 2015 15:14:15 +0800 (CST)
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2 23/25] btrfs-progs: Convert: Add support for rollback new convert behavior
Date: Tue,  1 Dec 2015 15:11:43 +0800
Message-Id: <1448953905-28673-24-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1448953905-28673-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1448953905-28673-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Add support to rollback new btrfs-convert.

The support is quite easy unlike the new convert behavior, which in fact
makes the rollback less restricted.

The core is, rollback must support both old and new convert result.

For old convert, all fs image extents can be covered by any chunk type.
But any extents inside reserved range must be covered by chunk.
For new convert, all fs image extents are covered by data chunk.

Allowing any condition will just make another fail to pass.
So make the convert condition a little less restricted to allow both can
be converted.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 btrfs-convert.c | 19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)

diff --git a/btrfs-convert.c b/btrfs-convert.c
index 17ce8ac..efa3b02 100644
--- a/btrfs-convert.c
+++ b/btrfs-convert.c
@@ -3801,11 +3801,19 @@ static int do_rollback(const char *devname)
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
+		 * For old convert case, sign, there is no consist chunk type
+		 * that will cover the extent. META/DATA/SYS are all possible.
+		 * Just ensure relocate one is in SYS chunk.
+		 * For new convert case, they are all covered by DATA chunk.
+		 *
+		 * So, there is not valid chunk type check for it now.
+		 */
+		if (cache1 != cache2)
 			break;
 
 		set_extent_bits(&io_tree, offset, offset + num_bytes - 1,
@@ -3819,6 +3827,7 @@ next_extent:
 
 	if (offset < total_bytes) {
 		fprintf(stderr, "unable to build extent mapping\n");
+		fprintf(stderr, "converted filesystem after balance is unable to rollback\n");
 		goto fail;
 	}
 
-- 
2.6.2



