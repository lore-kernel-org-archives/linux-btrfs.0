From: Josef Bacik <josef@redhat.com>
Subject: [PATCH] Btrfs: make sure to update total_bitmaps when freeing cache
Date: Thu, 23 Jun 2011 15:51:37 -0400
Message-ID: <1308858697-24067-1-git-send-email-josef@redhat.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

A user reported this bug again where we have more bitmaps than we are supposed
to.  This is because we failed to load the free space cache, but don't update
the ctl->total_bitmaps counter when we remove entries from the tree.  This patch
fixes this problem and we should be good to go again.  Thanks,

Signed-off-by: Josef Bacik <josef@redhat.com>
---
 fs/btrfs/free-space-cache.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index 3c1a047..aa62448 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -1844,6 +1844,8 @@ void __btrfs_remove_free_space_cache_locked(struct btrfs_free_space_ctl *ctl)
 		info = rb_entry(node, struct btrfs_free_space, offset_index);
 		unlink_free_space(ctl, info);
 		kfree(info->bitmap);
+		ctl->total_bitmaps--;
+		ctl->op->recalc_thresholds(ctl);
 		kmem_cache_free(btrfs_free_space_cachep, info);
 		if (need_resched()) {
 			spin_unlock(&ctl->tree_lock);
-- 
1.7.2.3

