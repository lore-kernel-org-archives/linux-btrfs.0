Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:29057 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757899AbbDWDDE (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 22 Apr 2015 23:03:04 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <lukas.lueg@gmail.com>
Subject: [PATCH] btrfs: Add extra check for sub_stripes to avoid hostile 0 division attack.
Date: Thu, 23 Apr 2015 11:00:45 +0800
Message-ID: <1429758045-27027-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Although only RAID10 use sub_stripes, a hostile attack can modify chunk
tree and just add RAID10 bit to a single chunk.
Then btrfs_map_block will trigger a 0 division in kernel and destroy
everything.

Just add extra check when reading chunk from disk.

Reported-by: Lukas Lueg <lukas.lueg@gmail.com>
Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 fs/btrfs/volumes.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 8222f6f..a764726 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -6061,6 +6061,14 @@ static int read_one_chunk(struct btrfs_root *root, struct btrfs_key *key,
 	map->stripe_len = btrfs_chunk_stripe_len(leaf, chunk);
 	map->type = btrfs_chunk_type(leaf, chunk);
 	map->sub_stripes = btrfs_chunk_sub_stripes(leaf, chunk);
+
+	/* Add extra check to avoid hostile 0 division attack */
+	if (map->type & BTRFS_BLOCK_GROUP_RAID10 &&
+	    map->sub_stripes == 0) {
+		free_extent_map(em);
+		return -EINVAL;
+	}
+
 	for (i = 0; i < num_stripes; i++) {
 		map->stripes[i].physical =
 			btrfs_stripe_offset_nr(leaf, chunk, i);
-- 
2.3.5

