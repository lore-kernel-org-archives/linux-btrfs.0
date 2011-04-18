From: Josef Bacik <josef@redhat.com>
Subject: [PATCH] Btrfs: free bitmaps properly when evicting the cache
Date: Mon, 18 Apr 2011 16:25:20 -0400
Message-ID: <1303158320-29058-1-git-send-email-josef@redhat.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

If our space cache is wrong, we do the right thing and free up everything that
we loaded, however we don't reset the total_bitmaps counter or the thresholds or
anything.  So in btrfs_remove_free_space_cache make sure to call free_bitmap()
if it's a bitmap, this will keep us from panicing when we check to make sure we
don't have too many bitmaps.  Thanks,

Signed-off-by: Josef Bacik <josef@redhat.com>
---
 fs/btrfs/free-space-cache.c |   11 +++++++----
 1 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index a3f420d..1bcbe76 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -1768,10 +1768,13 @@ void btrfs_remove_free_space_cache(struct btrfs_block_group_cache *block_group)
 
 	while ((node = rb_last(&block_group->free_space_offset)) != NULL) {
 		info = rb_entry(node, struct btrfs_free_space, offset_index);
-		unlink_free_space(block_group, info);
-		if (info->bitmap)
-			kfree(info->bitmap);
-		kmem_cache_free(btrfs_free_space_cachep, info);
+		if (!info->bitmap) {
+			unlink_free_space(block_group, info);
+			kmem_cache_free(btrfs_free_space_cachep, info);
+		} else {
+			free_bitmap(block_group, info);
+		}
+
 		if (need_resched()) {
 			spin_unlock(&block_group->tree_lock);
 			cond_resched();
-- 
1.7.2.3

