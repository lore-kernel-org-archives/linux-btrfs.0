From: Josef Bacik <josef@redhat.com>
Subject: [PATCH] Btrfs: check for duplicate entries in the free space cache
Date: Fri, 13 May 2011 14:50:28 -0400
Message-ID: <1305312628-6432-1-git-send-email-josef@redhat.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

If there are duplicate entries in the free space cache, discard the entire cache
and load it the old fashioned way.  Thanks,

Signed-off-by: Josef Bacik <josef@redhat.com>
---
 fs/btrfs/free-space-cache.c |   27 ++++++++++++++++++++++++---
 1 files changed, 24 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index 1bcbe76..46c575c 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -420,7 +420,14 @@ int load_free_space_cache(struct btrfs_fs_info *fs_info,
 				spin_lock(&block_group->tree_lock);
 				ret = link_free_space(block_group, e);
 				spin_unlock(&block_group->tree_lock);
-				BUG_ON(ret);
+				if (ret) {
+					printk(KERN_ERR "Duplicate entries in "
+					       "free space cache, dumping\n");
+					kunmap(page);
+					unlock_page(page);
+					page_cache_release(page);
+					goto free_cache;
+				}
 			} else {
 				e->bitmap = kzalloc(PAGE_CACHE_SIZE, GFP_NOFS);
 				if (!e->bitmap) {
@@ -437,6 +444,14 @@ int load_free_space_cache(struct btrfs_fs_info *fs_info,
 				recalculate_thresholds(block_group);
 				spin_unlock(&block_group->tree_lock);
 				list_add_tail(&e->list, &bitmaps);
+				if (ret) {
+					printk(KERN_ERR "Duplicate entries in "
+					       "free space cache, dumping\n");
+					kunmap(page);
+					unlock_page(page);
+					page_cache_release(page);
+					goto free_cache;
+				}
 			}
 
 			num_entries--;
@@ -909,10 +924,16 @@ static int tree_insert_offset(struct rb_root *root, u64 offset,
 			 * logically.
 			 */
 			if (bitmap) {
-				WARN_ON(info->bitmap);
+				if (info->bitmap) {
+					WARN_ON_ONCE(1);
+					return -EEXIST;
+				}
 				p = &(*p)->rb_right;
 			} else {
-				WARN_ON(!info->bitmap);
+				if (!info->bitmap) {
+					WARN_ON_ONCE(1);
+					return -EEXIST;
+				}
 				p = &(*p)->rb_left;
 			}
 		}
-- 
1.7.2.3

