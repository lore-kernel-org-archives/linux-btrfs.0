Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:24755 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752794AbbDXBOr (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 23 Apr 2015 21:14:47 -0400
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t3O1DVWD023801
	for <linux-btrfs@vger.kernel.org>; Fri, 24 Apr 2015 09:13:32 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH v2 2/2] btrfs: Add extra check for sub_stripes to avoid hostile 0 division attack.
Date: Fri, 24 Apr 2015 09:12:41 +0800
Message-ID: <1429837961-2255-2-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1429837961-2255-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1429837961-2255-1-git-send-email-quwenruo@cn.fujitsu.com>
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
v2:
   Return -EIO, and add kernel message output.
---
 fs/btrfs/volumes.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 8222f6f..fdcecf7 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -6061,6 +6061,17 @@ static int read_one_chunk(struct btrfs_root *root, struct btrfs_key *key,
 	map->stripe_len = btrfs_chunk_stripe_len(leaf, chunk);
 	map->type = btrfs_chunk_type(leaf, chunk);
 	map->sub_stripes = btrfs_chunk_sub_stripes(leaf, chunk);
+
+	/* Add extra check to avoid hostile 0 division attack */
+	if (map->type & BTRFS_BLOCK_GROUP_RAID10 &&
+	    map->sub_stripes == 0) {
+		btrfs_warn(root->fs_info,
+			   "RAID10 chunk found but with no sub stripe for bytenr: %llu\n",
+			   logical);
+		free_extent_map(em);
+		return -EIO;
+	}
+
 	for (i = 0; i < num_stripes; i++) {
 		map->stripes[i].physical =
 			btrfs_stripe_offset_nr(leaf, chunk, i);
-- 
2.3.5

