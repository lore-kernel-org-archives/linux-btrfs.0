From: Josef Bacik <josef@redhat.com>
Subject: [PATCH] Btrfs: use cluster->window_start when allocating from a cluster bitmap
Date: Mon, 23 Jan 2012 16:33:31 -0500
Message-ID: <1327354411-6205-1-git-send-email-josef@redhat.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

We specifically set window_start in the cluster struct to indicate where the
cluster starts in a bitmap, but we've been using min_start to indicate where
we're searching from.  This is usually the start of the blockgroup, so
essentially means we're constantly searching from the start of any bitmap we
find, which completely negates all the trouble we go to in order to setup a
cluster.  So start using window_start to make sure we actually use the area we
found.  Thanks,

Signed-off-by: Josef Bacik <josef@redhat.com>
---
 fs/btrfs/free-space-cache.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index 35bfe3c..43e75f2 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -2242,7 +2242,7 @@ u64 btrfs_alloc_from_cluster(struct btrfs_block_group_cache *block_group,
 		if (entry->bitmap) {
 			ret = btrfs_alloc_from_bitmap(block_group,
 						      cluster, entry, bytes,
-						      min_start);
+						      cluster->window_start);
 			if (ret == 0) {
 				node = rb_next(&entry->offset_index);
 				if (!node)
-- 
1.7.5.2

