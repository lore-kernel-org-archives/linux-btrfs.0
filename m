From: Josef Bacik <josef@redhat.com>
Subject: [PATCH] Btrfs: noinline the cluster searching functions
Date: Wed, 25 May 2011 13:08:59 -0400
Message-ID: <1306343339-25979-1-git-send-email-josef@redhat.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

When profiling the find cluster code it's hard to tell where we are spending our
time because the bitmap and non-bitmap functions get inlined by the compiler, so
make that not happen.  Thanks,

Signed-off-by: Josef Bacik <josef@redhat.com>
---
 fs/btrfs/free-space-cache.c |   18 ++++++++++--------
 1 files changed, 10 insertions(+), 8 deletions(-)

diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index 0bfea7b..a827c97 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -2060,10 +2060,11 @@ again:
 /*
  * This searches the block group for just extents to fill the cluster with.
  */
-static int setup_cluster_no_bitmap(struct btrfs_block_group_cache *block_group,
-				   struct btrfs_free_cluster *cluster,
-				   struct list_head *bitmaps,
-				   u64 offset, u64 bytes, u64 min_bytes)
+static noinline int
+setup_cluster_no_bitmap(struct btrfs_block_group_cache *block_group,
+			struct btrfs_free_cluster *cluster,
+			struct list_head *bitmaps, u64 offset, u64 bytes,
+			u64 min_bytes)
 {
 	struct btrfs_free_space *first = NULL;
 	struct btrfs_free_space *entry = NULL;
@@ -2162,10 +2163,11 @@ static int setup_cluster_no_bitmap(struct btrfs_block_group_cache *block_group,
  * This specifically looks for bitmaps that may work in the cluster, we assume
  * that we have already failed to find extents that will work.
  */
-static int setup_cluster_bitmap(struct btrfs_block_group_cache *block_group,
-				struct btrfs_free_cluster *cluster,
-				struct list_head *bitmaps,
-				u64 offset, u64 bytes, u64 min_bytes)
+static noinline int
+setup_cluster_bitmap(struct btrfs_block_group_cache *block_group,
+		     struct btrfs_free_cluster *cluster,
+		     struct list_head *bitmaps, u64 offset, u64 bytes,
+		     u64 min_bytes)
 {
 	struct btrfs_free_space *entry;
 	struct rb_node *node;
-- 
1.7.2.3

