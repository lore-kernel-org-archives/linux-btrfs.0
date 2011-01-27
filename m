From: Li Zefan <lizf@cn.fujitsu.com>
Subject: [PATCH 01/12] btrfs: Fix threshold calculation for block groups smaller
 than 1GB
Date: Thu, 27 Jan 2011 16:42:37 +0800
Message-ID: <4D412FFD.3090906@cn.fujitsu.com>
References: <4D412FE6.7050101@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
	Josef Bacik <josef@redhat.com>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4D412FE6.7050101@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

If a block group is smaller than 1GB, the extent entry threadhold
calculation will always set the threshold to 0.

So as free space gets fragmented, btrfs will switch to use bitmap
to manage free space, but then will never switch back to extents
due to this bug.

Reviewed-by: Josef Bacik <josef@redhat.com>
Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 fs/btrfs/free-space-cache.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index 60d6842..42f4015 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -1016,14 +1016,18 @@ static void recalculate_thresholds(struct btrfs_block_group_cache *block_group)
 	u64 max_bytes;
 	u64 bitmap_bytes;
 	u64 extent_bytes;
+	u64 size = block_group->key.offset;
 
 	/*
 	 * The goal is to keep the total amount of memory used per 1gb of space
 	 * at or below 32k, so we need to adjust how much memory we allow to be
 	 * used by extent based free space tracking
 	 */
-	max_bytes = MAX_CACHE_BYTES_PER_GIG *
-		(div64_u64(block_group->key.offset, 1024 * 1024 * 1024));
+	if (size < 1024 * 1024 * 1024)
+		max_bytes = MAX_CACHE_BYTES_PER_GIG;
+	else
+		max_bytes = MAX_CACHE_BYTES_PER_GIG *
+			div64_u64(size, 1024 * 1024 * 1024);
 
 	/*
 	 * we want to account for 1 more bitmap than what we have so we can make
-- 
1.6.3

