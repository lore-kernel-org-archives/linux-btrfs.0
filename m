From: Miao Xie <miaox@cn.fujitsu.com>
Subject: [PATCH 1/2] Btrfs: fix wrong free space information
Date: Fri, 05 Aug 2011 17:32:35 +0800
Message-ID: <4E3BB8B3.4080705@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
Mime-Version: 1.0
Content-Type: text/plain; charset=GB2312
Cc: Liu Bo <liubo2009@cn.fujitsu.com>
To: Linux Btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Btrfs subtracted the size of the allocated space twice when it allocated
the space from the bitmap in the cluster, it broke the free space information
and led to oops finally.

And this patch also fixes the bug that ctl->free_space was subtracted
without lock.

Reported-by: Liu Bo <liubo2009@cn.fujitsu.com>
Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/free-space-cache.c |   16 +++++++++++-----
 1 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index 6377713..6a265b9 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -1168,9 +1168,9 @@ static void recalculate_thresholds(struct btrfs_free_space_ctl *ctl)
 		div64_u64(extent_bytes, (sizeof(struct btrfs_free_space)));
 }
 
-static void bitmap_clear_bits(struct btrfs_free_space_ctl *ctl,
-			      struct btrfs_free_space *info, u64 offset,
-			      u64 bytes)
+static inline void __bitmap_clear_bits(struct btrfs_free_space_ctl *ctl,
+				       struct btrfs_free_space *info,
+				       u64 offset, u64 bytes)
 {
 	unsigned long start, count;
 
@@ -1181,6 +1181,13 @@ static void bitmap_clear_bits(struct btrfs_free_space_ctl *ctl,
 	bitmap_clear(info->bitmap, start, count);
 
 	info->bytes -= bytes;
+}
+
+static void bitmap_clear_bits(struct btrfs_free_space_ctl *ctl,
+			      struct btrfs_free_space *info, u64 offset,
+			      u64 bytes)
+{
+	__bitmap_clear_bits(ctl, info, offset, bytes);
 	ctl->free_space -= bytes;
 }
 
@@ -1984,7 +1991,7 @@ static u64 btrfs_alloc_from_bitmap(struct btrfs_block_group_cache *block_group,
 		return 0;
 
 	ret = search_start;
-	bitmap_clear_bits(ctl, entry, ret, bytes);
+	__bitmap_clear_bits(ctl, entry, ret, bytes);
 
 	return ret;
 }
@@ -2039,7 +2046,6 @@ u64 btrfs_alloc_from_cluster(struct btrfs_block_group_cache *block_group,
 				continue;
 			}
 		} else {
-
 			ret = entry->offset;
 
 			entry->offset += bytes;
-- 
1.7.4
