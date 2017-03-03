Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:27392 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751394AbdCCI5v (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 3 Mar 2017 03:57:51 -0500
From: Elena Reshetova <elena.reshetova@intel.com>
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org,
        peterz@infradead.org, gregkh@linuxfoundation.org, jbacik@fb.com,
        clm@fb.com, dsterba@suse.com,
        Elena Reshetova <elena.reshetova@intel.com>,
        Hans Liljestrand <ishkamiel@gmail.com>,
        Kees Cook <keescook@chromium.org>, David Windsor <dwindsor@gmail.com>
Subject: [PATCH 05/17] fs, btrfs: convert btrfs_caching_control.count from atomic_t to refcount_t
Date: Fri,  3 Mar 2017 10:55:14 +0200
Message-Id: <1488531326-21271-6-git-send-email-elena.reshetova@intel.com>
In-Reply-To: <1488531326-21271-1-git-send-email-elena.reshetova@intel.com>
References: <1488531326-21271-1-git-send-email-elena.reshetova@intel.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

refcount_t type and corresponding API should be
used instead of atomic_t when the variable is used as
a reference counter. This allows to avoid accidental
refcounter overflows that might lead to use-after-free
situations.

Signed-off-by: Elena Reshetova <elena.reshetova@intel.com>
Signed-off-by: Hans Liljestrand <ishkamiel@gmail.com>
Signed-off-by: Kees Cook <keescook@chromium.org>
Signed-off-by: David Windsor <dwindsor@gmail.com>
---
 fs/btrfs/ctree.h       |  3 ++-
 fs/btrfs/extent-tree.c | 12 ++++++------
 2 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 00e3518..557af39 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -38,6 +38,7 @@
 #include <linux/security.h>
 #include <linux/sizes.h>
 #include <linux/dynamic_debug.h>
+#include <linux/refcount.h>
 #include "extent_io.h"
 #include "extent_map.h"
 #include "async-thread.h"
@@ -517,7 +518,7 @@ struct btrfs_caching_control {
 	struct btrfs_work work;
 	struct btrfs_block_group_cache *block_group;
 	u64 progress;
-	atomic_t count;
+	refcount_t count;
 };
 
 /* Once caching_thread() finds this much free space, it will wake up waiters. */
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 63ba295..796001b 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -315,14 +315,14 @@ get_caching_control(struct btrfs_block_group_cache *cache)
 	}
 
 	ctl = cache->caching_ctl;
-	atomic_inc(&ctl->count);
+	refcount_inc(&ctl->count);
 	spin_unlock(&cache->lock);
 	return ctl;
 }
 
 static void put_caching_control(struct btrfs_caching_control *ctl)
 {
-	if (atomic_dec_and_test(&ctl->count))
+	if (refcount_dec_and_test(&ctl->count))
 		kfree(ctl);
 }
 
@@ -598,7 +598,7 @@ static int cache_block_group(struct btrfs_block_group_cache *cache,
 	init_waitqueue_head(&caching_ctl->wait);
 	caching_ctl->block_group = cache;
 	caching_ctl->progress = cache->key.objectid;
-	atomic_set(&caching_ctl->count, 1);
+	refcount_set(&caching_ctl->count, 1);
 	btrfs_init_work(&caching_ctl->work, btrfs_cache_helper,
 			caching_thread, NULL, NULL);
 
@@ -619,7 +619,7 @@ static int cache_block_group(struct btrfs_block_group_cache *cache,
 		struct btrfs_caching_control *ctl;
 
 		ctl = cache->caching_ctl;
-		atomic_inc(&ctl->count);
+		refcount_inc(&ctl->count);
 		prepare_to_wait(&ctl->wait, &wait, TASK_UNINTERRUPTIBLE);
 		spin_unlock(&cache->lock);
 
@@ -706,7 +706,7 @@ static int cache_block_group(struct btrfs_block_group_cache *cache,
 	}
 
 	down_write(&fs_info->commit_root_sem);
-	atomic_inc(&caching_ctl->count);
+	refcount_inc(&caching_ctl->count);
 	list_add_tail(&caching_ctl->list, &fs_info->caching_block_groups);
 	up_write(&fs_info->commit_root_sem);
 
@@ -10415,7 +10415,7 @@ int btrfs_remove_block_group(struct btrfs_trans_handle *trans,
 				    &fs_info->caching_block_groups, list)
 				if (ctl->block_group == block_group) {
 					caching_ctl = ctl;
-					atomic_inc(&caching_ctl->count);
+					refcount_inc(&caching_ctl->count);
 					break;
 				}
 		}
-- 
2.7.4

