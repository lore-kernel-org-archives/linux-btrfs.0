Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:54141 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S932765AbbLOCEU (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 14 Dec 2015 21:04:20 -0500
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (unknown [10.167.33.83])
	by cn.fujitsu.com (Postfix) with ESMTP id 7E42A40427C5
	for <linux-btrfs@vger.kernel.org>; Tue, 15 Dec 2015 10:04:03 +0800 (CST)
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH v2] btrfs-progs: Enhance chunk validation check
Date: Tue, 15 Dec 2015 10:04:01 +0800
Message-ID: <1450145041-13267-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
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
v2:
  Move some macros to kerncompat.h
---
 disk-io.c    |  2 --
 kerncompat.h |  8 ++++++++
 volumes.c    | 29 ++++++++++++++++++++++++++++-
 3 files changed, 36 insertions(+), 3 deletions(-)

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
diff --git a/kerncompat.h b/kerncompat.h
index 7c627ba..0f207b7 100644
--- a/kerncompat.h
+++ b/kerncompat.h
@@ -310,6 +310,14 @@ static inline long IS_ERR(const void *ptr)
 #define __bitwise
 #endif
 
+/* Alignment check */
+#define IS_ALIGNED(x, a)                (((x) & ((typeof(x))(a) - 1)) == 0)
+
+static inline int is_power_of_2(unsigned long n)
+{
+	return (n != 0 && ((n & (n - 1)) == 0));
+}
+
 typedef u16 __bitwise __le16;
 typedef u16 __bitwise __be16;
 typedef u32 __bitwise __le32;
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
2.6.4



