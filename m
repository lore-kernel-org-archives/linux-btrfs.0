From: Li Zefan <lizf@cn.fujitsu.com>
Subject: [PATCH v2 2/7] Btrfs: Use bitmap_set/clear()
Date: Mon, 25 Apr 2011 16:58:42 +0800
Message-ID: <4DB537C2.3020205@cn.fujitsu.com>
References: <4DB5378B.2070904@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4DB5378B.2070904@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

No functional change.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 fs/btrfs/free-space-cache.c |   20 ++++++++------------
 1 files changed, 8 insertions(+), 12 deletions(-)

diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index 3af64c6..0e23bba 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -1134,15 +1134,13 @@ static void bitmap_clear_bits(struct btrfs_block_group_cache *block_group,
 			      struct btrfs_free_space *info, u64 offset,
 			      u64 bytes)
 {
-	unsigned long start, end;
-	unsigned long i;
+	unsigned long start, count;
 
 	start = offset_to_bit(info->offset, block_group->sectorsize, offset);
-	end = start + bytes_to_bits(bytes, block_group->sectorsize);
-	BUG_ON(end > BITS_PER_BITMAP);
+	count = bytes_to_bits(bytes, block_group->sectorsize);
+	BUG_ON(start + count > BITS_PER_BITMAP);
 
-	for (i = start; i < end; i++)
-		clear_bit(i, info->bitmap);
+	bitmap_clear(info->bitmap, start, count);
 
 	info->bytes -= bytes;
 	block_group->free_space -= bytes;
@@ -1152,15 +1150,13 @@ static void bitmap_set_bits(struct btrfs_block_group_cache *block_group,
 			    struct btrfs_free_space *info, u64 offset,
 			    u64 bytes)
 {
-	unsigned long start, end;
-	unsigned long i;
+	unsigned long start, count;
 
 	start = offset_to_bit(info->offset, block_group->sectorsize, offset);
-	end = start + bytes_to_bits(bytes, block_group->sectorsize);
-	BUG_ON(end > BITS_PER_BITMAP);
+	count = bytes_to_bits(bytes, block_group->sectorsize);
+	BUG_ON(start + count > BITS_PER_BITMAP);
 
-	for (i = start; i < end; i++)
-		set_bit(i, info->bitmap);
+	bitmap_set(info->bitmap, start, count);
 
 	info->bytes += bytes;
 	block_group->free_space += bytes;
-- 
1.7.3.1
