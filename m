Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:46487 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1754321AbcH3D3p (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 29 Aug 2016 23:29:45 -0400
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (unknown [10.167.33.83])
        by cn.fujitsu.com (Postfix) with ESMTP id 8CEC342EB26E
        for <linux-btrfs@vger.kernel.org>; Tue, 30 Aug 2016 11:29:35 +0800 (CST)
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 1/2] btrfs-progs: fsck: Do early check for read_tree_block
Date: Tue, 30 Aug 2016 11:29:32 +0800
Message-ID: <20160830032933.22194-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Although we have enhanced read_tree_block() from a lot of different
aspects, it lacks the early bytenr/blocksize alignment check.

And the lack of such check can lead to strange use-after-free bugs, due
to the fact that alloc_extent_buffer() will free overlapping extent
buffers, and allocate new eb for the usage.

So we should not allow invalid bytenr/blocksize even passed to
btrfs_find_create_tree_block().

This patch will add such check so we won't trigger use-after-free bug
then.

Reported-by: Lukas Lueg <lukas.lueg@gmail.com>
Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 disk-io.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/disk-io.c b/disk-io.c
index ca4578f..f5340c3 100644
--- a/disk-io.c
+++ b/disk-io.c
@@ -313,11 +313,29 @@ struct extent_buffer* read_tree_block_fs_info(
 	int ret;
 	struct extent_buffer *eb;
 	u64 best_transid = 0;
+	u32 sectorsize = btrfs_super_sectorsize(fs_info->super_copy);
+	u32 nodesize = btrfs_super_nodesize(fs_info->super_copy);
 	int mirror_num = 0;
 	int good_mirror = 0;
 	int num_copies;
 	int ignore = 0;
 
+	/*
+	 * Don't even try to create tree block for unaligned tree block
+	 * bytenr.
+	 * Such unaligned tree block will free overlapping extent buffer,
+	 * causing use-after-free bugs for fuzzed images.
+	 */
+	if (!IS_ALIGNED(bytenr, sectorsize)) {
+		error("tree block bytenr %llu is not aligned to sectorsize %u",
+		      bytenr, sectorsize);
+		return ERR_PTR(-EIO);
+	}
+	if (!IS_ALIGNED(blocksize, nodesize)) {
+		error("tree block size %u is not aligned to nodesize %u",
+		      blocksize, nodesize);
+		return ERR_PTR(-EIO);
+	}
 	eb = btrfs_find_create_tree_block(fs_info, bytenr, blocksize);
 	if (!eb)
 		return ERR_PTR(-ENOMEM);
-- 
2.9.3



