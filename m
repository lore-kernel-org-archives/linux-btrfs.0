From: Josef Bacik <josef@redhat.com>
Subject: [PATCH] Btrfs: make sure to update total_bitmaps when freeing cache V2
Date: Thu, 23 Jun 2011 15:54:26 -0400
Message-ID: <1308858866-24124-1-git-send-email-josef@redhat.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

A user reported this bug again where we have more bitmaps than we are supposed
to.  This is because we failed to load the free space cache, but don't update
the ctl->total_bitmaps counter when we remove entries from the tree.  This patch
fixes this problem and we should be good to go again.  Thanks,

Signed-off-by: Josef Bacik <josef@redhat.com>
---
V1->V2: made the patch actually correct
 fs/btrfs/free-space-cache.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index 3c1a047..e7987f9 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -1843,7 +1843,11 @@ void __btrfs_remove_free_space_cache_locked(struct btrfs_free_space_ctl *ctl)
 	while ((node = rb_last(&ctl->free_space_offset)) != NULL) {
 		info = rb_entry(node, struct btrfs_free_space, offset_index);
 		unlink_free_space(ctl, info);
-		kfree(info->bitmap);
+		if (info->bitmap) {
+			kfree(info->bitmap);
+			ctl->total_bitmaps--;
+			ctl->op->recalc_thresholds(ctl);
+		}
 		kmem_cache_free(btrfs_free_space_cachep, info);
 		if (need_resched()) {
 			spin_unlock(&ctl->tree_lock);
-- 
1.7.2.3

