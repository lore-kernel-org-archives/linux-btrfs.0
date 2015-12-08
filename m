Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:45098 "EHLO heian.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S933214AbbLHHht (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 8 Dec 2015 02:37:49 -0500
Received: from localhost.localdomain (unknown [10.167.226.34])
	by cn.fujitsu.com (Postfix) with ESMTP id 57ABA405640A
	for <linux-btrfs@vger.kernel.org>; Tue,  8 Dec 2015 15:36:05 +0800 (CST)
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2 2/2] btrfs: Enhance chunk validation check
Date: Tue,  8 Dec 2015 15:35:58 +0800
Message-Id: <1449560158-32577-2-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1449560158-32577-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1449560158-32577-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Enhance chunk validation:
1) Num_stripes
   We already have such check but it's only in super block sys chunk
   array.
   Now check all on-disk chunks.

2) Chunk logical
   It should be aligned to sector size.
   This behavior should be *DOUBLE CHECKED* for 64K sector size like
   PPC64 or AArch64.
   Maybe we can found some hidden bugs.

3) Chunk length
   Same as chunk logical, should be aligned to sector size.

4) Stripe length
   It should be power of 2.

5) Chunk type
   Any bit out of TYPE_MAS | PROFILE_MASK is invalid.

With all these much restrict rules, several fuzzed image reported in
mail list should no longer cause kernel panic.

Reported-by: Vegard Nossum <vegard.nossum@oracle.com>
Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 fs/btrfs/volumes.c | 32 +++++++++++++++++++++++++++++++-
 1 file changed, 31 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 9ea345f..4af6f30 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -6199,6 +6199,7 @@ static int read_one_chunk(struct btrfs_root *root, struct btrfs_key *key,
 	struct extent_map *em;
 	u64 logical;
 	u64 length;
+	u64 stripe_len;
 	u64 devid;
 	u8 uuid[BTRFS_UUID_SIZE];
 	int num_stripes;
@@ -6207,6 +6208,36 @@ static int read_one_chunk(struct btrfs_root *root, struct btrfs_key *key,
 
 	logical = key->offset;
 	length = btrfs_chunk_length(leaf, chunk);
+	stripe_len = btrfs_chunk_stripe_len(leaf, chunk);
+	num_stripes = btrfs_chunk_num_stripes(leaf, chunk);
+	/* Validation check */
+	if (!num_stripes) {
+		btrfs_err(root->fs_info, "invalid chunk num_stripes: %u",
+			  num_stripes);
+	}
+	if (!IS_ALIGNED(logical, root->sectorsize)) {
+		btrfs_err(root->fs_info,
+			  "invalid chunk logical %llu", logical);
+		return -EIO;
+	}
+	if (!length || !IS_ALIGNED(length, root->sectorsize)) {
+		btrfs_err(root->fs_info,
+			"invalid chunk length %llu", length);
+		return -EIO;
+	}
+	if (!is_power_of_2(stripe_len)) {
+		btrfs_err(root->fs_info, "invalid chunk stripe length: %llu",
+			  stripe_len);
+		return -EIO;
+	}
+	if (~(BTRFS_BLOCK_GROUP_TYPE_MASK | BTRFS_BLOCK_GROUP_PROFILE_MASK) &
+	    btrfs_chunk_type(leaf, chunk)) {
+		btrfs_err(root->fs_info, "unrecognized chunk type: %llu",
+			  ~(BTRFS_BLOCK_GROUP_TYPE_MASK |
+			    BTRFS_BLOCK_GROUP_PROFILE_MASK) &
+			  btrfs_chunk_type(leaf, chunk));
+		return -EIO;
+	}
 
 	read_lock(&map_tree->map_tree.lock);
 	em = lookup_extent_mapping(&map_tree->map_tree, logical, 1);
@@ -6223,7 +6254,6 @@ static int read_one_chunk(struct btrfs_root *root, struct btrfs_key *key,
 	em = alloc_extent_map();
 	if (!em)
 		return -ENOMEM;
-	num_stripes = btrfs_chunk_num_stripes(leaf, chunk);
 	map = kmalloc(map_lookup_size(num_stripes), GFP_NOFS);
 	if (!map) {
 		free_extent_map(em);
-- 
2.6.3



