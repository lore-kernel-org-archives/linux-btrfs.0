From: Josef Bacik <josef@redhat.com>
Subject: [PATCH] Btrfs: don't be as aggressive about using bitmaps V2
Date: Mon, 21 Mar 2011 10:24:16 -0400
Message-ID: <1300717456-24235-1-git-send-email-josef@redhat.com>
References: <4D86B937.7080905@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4D86B937.7080905@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

We have been creating bitmaps for small extents unconditionally forever.  This
was great when testing to make sure the bitmap stuff was working, but is
overkill normally.  So instead of always adding small chunks of free space to
bitmaps, only start doing it if we go past half of our extent threshold.  This
will keeps us from creating a bitmap for just one small free extent at the front
of the block group, and will make the allocator a little faster as a result.
Thanks,

Signed-off-by: Josef Bacik <josef@redhat.com>
---
V1->V2:
-fix a formatting problem
-make the small extent threshold to be <= 4 sectors, not < 4 sectors

 fs/btrfs/free-space-cache.c |   19 ++++++++++++++++---
 1 files changed, 16 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index 63776ae..4ab35ea 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -1287,9 +1287,22 @@ static int insert_into_bitmap(struct btrfs_block_group_cache *block_group,
 	 * If we are below the extents threshold then we can add this as an
 	 * extent, and don't have to deal with the bitmap
 	 */
-	if (block_group->free_extents < block_group->extents_thresh &&
-	    info->bytes > block_group->sectorsize * 4)
-		return 0;
+	if (block_group->free_extents < block_group->extents_thresh) {
+		/*
+		 * If this block group has some small extents we don't want to
+		 * use up all of our free slots in the cache with them, we want
+		 * to reserve them to larger extents, however if we have plent
+		 * of cache left then go ahead an dadd them, no sense in adding
+		 * the overhead of a bitmap if we don't have to.
+		 */
+		if (info->bytes <= block_group->sectorsize * 4) {
+			if (block_group->free_extents * 2 <=
+			    block_group->extents_thresh)
+				return 0;
+		} else {
+			return 0;
+		}
+	}
 
 	/*
 	 * some block groups are so tiny they can't be enveloped by a bitmap, so
-- 
1.7.2.3

