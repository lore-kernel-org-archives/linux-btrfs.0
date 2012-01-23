From: Josef Bacik <josef@redhat.com>
Subject: [PATCH] Btrfs: make sure a bitmap has enough bytes
Date: Mon, 23 Jan 2012 16:30:24 -0500
Message-ID: <1327354224-6121-1-git-send-email-josef@redhat.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

We have only been checking for min_bytes available in bitmap entries, but we
won't successfully setup a bitmap cluster unless it has at least bytes in the
bitmap, so in the common case min_bytes is 4k and we want something like 2MB, so
if there are a bunch of bitmap entries with less than 2mb's in them, we'll
search all them anyway, which is suboptimal.  Fix this check.  Thanks,

Signed-off-by: Josef Bacik <josef@redhat.com>
---
 fs/btrfs/free-space-cache.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index d20ff87..35bfe3c 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -2475,7 +2475,7 @@ setup_cluster_bitmap(struct btrfs_block_group_cache *block_group,
 	}
 
 	list_for_each_entry(entry, bitmaps, list) {
-		if (entry->bytes < min_bytes)
+		if (entry->bytes < bytes)
 			continue;
 		ret = btrfs_bitmap_cluster(block_group, entry, cluster, offset,
 					   bytes, cont1_bytes, min_bytes);
-- 
1.7.5.2

