From: David Sterba <dsterba@suse.cz>
Subject: [PATCH 06/12] btrfs: make functions static when possible
Date: Fri, 22 Apr 2011 11:41:57 +0200
Message-ID: <426bfe73de7bb7f56f7d39193ffdb89b3bc048e6.1303398927.git.dsterba@suse.cz>
References: <cover.1303398927.git.dsterba@suse.cz>
Cc: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <cover.1303398927.git.dsterba@suse.cz>
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: David Sterba <dsterba@suse.cz>
---
 fs/btrfs/ctree.c            |    4 ++--
 fs/btrfs/extent-tree.c      |    6 +++---
 fs/btrfs/free-space-cache.c |    4 ++--
 3 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index c60197b..a36c87db 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -74,8 +74,8 @@ noinline void btrfs_set_path_blocking(struct btrfs_path *p)
  * retake all the spinlocks in the path.  You can safely use NULL
  * for held
  */
-noinline void btrfs_clear_path_blocking(struct btrfs_path *p,
-					struct extent_buffer *held)
+static noinline void btrfs_clear_path_blocking(struct btrfs_path *p,
+					       struct extent_buffer *held)
 {
 	int i;
 
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index c97ceab..9e94f8b 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -94,7 +94,7 @@ static int block_group_bits(struct btrfs_block_group_cache *cache, u64 bits)
 	return (cache->flags & bits) == bits;
 }
 
-void btrfs_get_block_group(struct btrfs_block_group_cache *cache)
+static void btrfs_get_block_group(struct btrfs_block_group_cache *cache)
 {
 	atomic_inc(&cache->count);
 }
@@ -3645,8 +3645,8 @@ static void block_rsv_add_bytes(struct btrfs_block_rsv *block_rsv,
 	spin_unlock(&block_rsv->lock);
 }
 
-void block_rsv_release_bytes(struct btrfs_block_rsv *block_rsv,
-			     struct btrfs_block_rsv *dest, u64 num_bytes)
+static void block_rsv_release_bytes(struct btrfs_block_rsv *block_rsv,
+				    struct btrfs_block_rsv *dest, u64 num_bytes)
 {
 	struct btrfs_space_info *space_info = block_rsv->space_info;
 
diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index eb7c3cd..5ae7a6d 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -1455,8 +1455,8 @@ out:
 	return ret;
 }
 
-bool try_merge_free_space(struct btrfs_block_group_cache *block_group,
-			  struct btrfs_free_space *info, bool update_stat)
+static bool try_merge_free_space(struct btrfs_block_group_cache *block_group,
+				 struct btrfs_free_space *info, bool update_stat)
 {
 	struct btrfs_free_space *left_info;
 	struct btrfs_free_space *right_info;
-- 
1.7.5.rc3

