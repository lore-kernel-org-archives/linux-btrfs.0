Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:32261 "EHLO heian.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751219AbbLHJFf (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 8 Dec 2015 04:05:35 -0500
Received: from localhost.localdomain (unknown [10.167.226.34])
	by cn.fujitsu.com (Postfix) with ESMTP id 100AF4043CE7
	for <linux-btrfs@vger.kernel.org>; Tue,  8 Dec 2015 17:05:23 +0800 (CST)
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs-progs: Enhance chunk validation check
Date: Tue,  8 Dec 2015 17:05:22 +0800
Message-Id: <1449565522-7736-1-git-send-email-quwenruo@cn.fujitsu.com>
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
mail list should no longer cause btrfsck error.

Reported-by: Vegard Nossum <vegard.nossum@oracle.com>
Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 disk-io.c |  2 --
 utils.h   |  7 +++++++
 volumes.c | 29 ++++++++++++++++++++++++++++-
 3 files changed, 35 insertions(+), 3 deletions(-)

diff --git a/disk-io.c b/disk-io.c
index 7a63b91..83bdb27 100644
--- a/disk-io.c
+++ b/disk-io.c
@@ -40,8 +40,6 @@
 #define BTRFS_BAD_LEVEL			(-3)
 #define BTRFS_BAD_NRITEMS		(-4)
 
-#define IS_ALIGNED(x, a)                (((x) & ((typeof(x))(a) - 1)) == 0)
-
 /* Calculate max possible nritems for a leaf/node */
 static u32 max_nritems(u8 level, u32 nodesize)
 {
diff --git a/utils.h b/utils.h
index 493c2e4..7740fc2 100644
--- a/utils.h
+++ b/utils.h
@@ -24,6 +24,8 @@
 #include <dirent.h>
 #include <stdarg.h>
 
+#define IS_ALIGNED(x, a)                (((x) & ((typeof(x))(a) - 1)) == 0)
+
 #define BTRFS_MKFS_SYSTEM_GROUP_SIZE (4 * 1024 * 1024)
 #define BTRFS_MKFS_SMALL_VOLUME_SIZE (1024 * 1024 * 1024)
 #define BTRFS_MKFS_DEFAULT_NODE_SIZE 16384
@@ -246,6 +248,11 @@ static inline u64 div_factor(u64 num, int factor)
 	return num;
 }
 
+static inline int is_power_of_2(unsigned long n)
+{
+	return (n != 0 && ((n & (n - 1)) == 0));
+}
+
 int btrfs_tree_search2_ioctl_supported(int fd);
 int btrfs_check_nodesize(u32 nodesize, u32 sectorsize, u64 features);
 
diff --git a/volumes.c b/volumes.c
index 492dcd2..a94be0e 100644
--- a/volumes.c
+++ b/volumes.c
@@ -1591,6 +1591,7 @@ static int read_one_chunk(struct btrfs_root *root, struct btrfs_key *key,
 	struct cache_extent *ce;
 	u64 logical;
 	u64 length;
+	u64 stripe_len;
 	u64 devid;
 	u8 uuid[BTRFS_UUID_SIZE];
 	int num_stripes;
@@ -1599,6 +1600,33 @@ static int read_one_chunk(struct btrfs_root *root, struct btrfs_key *key,
 
 	logical = key->offset;
 	length = btrfs_chunk_length(leaf, chunk);
+	stripe_len = btrfs_chunk_stripe_len(leaf, chunk);
+	num_stripes = btrfs_chunk_num_stripes(leaf, chunk);
+	/* Validation check */
+	if (!num_stripes) {
+		error("invalid chunk num_stripes: %u", num_stripes);
+		return -EIO;
+	}
+	if (!IS_ALIGNED(logical, root->sectorsize)) {
+		error("invalid chunk logical %llu", logical);
+		return -EIO;
+	}
+	if (!length || !IS_ALIGNED(length, root->sectorsize)) {
+		error("invalid chunk length %llu", length);
+		return -EIO;
+	}
+	if (!is_power_of_2(stripe_len)) {
+		error("invalid chunk stripe length: %llu", stripe_len);
+		return -EIO;
+	}
+	if (~(BTRFS_BLOCK_GROUP_TYPE_MASK | BTRFS_BLOCK_GROUP_PROFILE_MASK) &
+	    btrfs_chunk_type(leaf, chunk)) {
+		error("unrecognized chunk type: %llu",
+		      ~(BTRFS_BLOCK_GROUP_TYPE_MASK |
+			BTRFS_BLOCK_GROUP_PROFILE_MASK) &
+		      btrfs_chunk_type(leaf, chunk));
+		return -EIO;
+	}
 
 	ce = search_cache_extent(&map_tree->cache_tree, logical);
 
@@ -1607,7 +1635,6 @@ static int read_one_chunk(struct btrfs_root *root, struct btrfs_key *key,
 		return 0;
 	}
 
-	num_stripes = btrfs_chunk_num_stripes(leaf, chunk);
 	map = kmalloc(btrfs_map_lookup_size(num_stripes), GFP_NOFS);
 	if (!map)
 		return -ENOMEM;
-- 
2.6.3



