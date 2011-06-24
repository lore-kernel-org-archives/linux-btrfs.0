From: Josef Bacik <josef@redhat.com>
Subject: [PATCH] Btrfs: make sure to update total_bitmaps when freeing cache V3
Date: Fri, 24 Jun 2011 12:02:51 -0400
Message-ID: <1308931371-1880-1-git-send-email-josef@redhat.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

A user reported this bug again where we have more bitmaps than we are supposed
to.  This is because we failed to load the free space cache, but don't update
the ctl->total_bitmaps counter when we remove entries from the tree.  This patch
fixes this problem and we should be good to go again.  Thanks,

Signed-off-by: Josef Bacik <josef@redhat.com>
---
V2->V3: use the free_bitmap helper instead of open coding the total bitmaps
change
 fs/btrfs/free-space-cache.c |    9 ++++++---
 1 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index 3c1a047..fd7fa2a 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -1842,9 +1842,12 @@ void __btrfs_remove_free_space_cache_locked(struct btrfs_free_space_ctl *ctl)
 
 	while ((node = rb_last(&ctl->free_space_offset)) != NULL) {
 		info = rb_entry(node, struct btrfs_free_space, offset_index);
-		unlink_free_space(ctl, info);
-		kfree(info->bitmap);
-		kmem_cache_free(btrfs_free_space_cachep, info);
+		if (!info->bitmap) {
+			unlink_free_space(ctl, info);
+			kmem_cache_free(btrfs_free_space_cachep, info);
+		} else {
+			free_bitmap(ctl, info);
+		}
 		if (need_resched()) {
 			spin_unlock(&ctl->tree_lock);
 			cond_resched();
-- 
1.7.2.3

