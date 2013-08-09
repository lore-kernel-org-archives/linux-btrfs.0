Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:31980 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S966766Ab3HIF1L (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 9 Aug 2013 01:27:11 -0400
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id r795R6Re008848
	for <linux-btrfs@vger.kernel.org>; Fri, 9 Aug 2013 13:27:07 +0800
From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [patch v2 2/2] Btrfs: allocate prelim_ref with a slab allocater
Date: Fri, 9 Aug 2013 13:25:36 +0800
Message-Id: <1376025936-21652-2-git-send-email-wangsl.fnst@cn.fujitsu.com>
In-Reply-To: <1376025936-21652-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
References: <1376025936-21652-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

struct __prelim_ref is allocated and freed frequently when
walking backref tree, using slab allocater can not only
speed up allocating but also detect memory leaks.

Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
Reviewed-by: Miao Xie <miaox@cn.fujitsu.com>
---
V1->V2:	
	1.fix a missing allocating case that should be used by kmem_cache_alloc()
	  spotted by Jan Schmidt
	2.rename prelim_ref to btrfs_prelim_ref addressed by David
---
 fs/btrfs/backref.c | 33 +++++++++++++++++++++++++++------
 fs/btrfs/backref.h |  2 ++
 fs/btrfs/super.c   |  8 ++++++++
 3 files changed, 37 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/backref.c b/fs/btrfs/backref.c
index 7b55c95..b352d15 100644
--- a/fs/btrfs/backref.c
+++ b/fs/btrfs/backref.c
@@ -119,6 +119,26 @@ struct __prelim_ref {
 	u64 wanted_disk_byte;
 };
 
+static struct kmem_cache *btrfs_prelim_ref_cache;
+
+int __init btrfs_prelim_ref_init(void)
+{
+	btrfs_prelim_ref_cache = kmem_cache_create("btrfs_prelim_ref",
+					sizeof(struct __prelim_ref),
+					0,
+					SLAB_RECLAIM_ACCOUNT | SLAB_MEM_SPREAD,
+					NULL);
+	if (!btrfs_prelim_ref_cache)
+		return -ENOMEM;
+	return 0;
+}
+
+void btrfs_prelim_ref_exit(void)
+{
+	if (btrfs_prelim_ref_cache)
+		kmem_cache_destroy(btrfs_prelim_ref_cache);
+}
+
 /*
  * the rules for all callers of this function are:
  * - obtaining the parent is the goal
@@ -165,7 +185,7 @@ static int __add_prelim_ref(struct list_head *head, u64 root_id,
 {
 	struct __prelim_ref *ref;
 
-	ref = kmalloc(sizeof(*ref), gfp_mask);
+	ref = kmem_cache_alloc(btrfs_prelim_ref_cache, gfp_mask);
 	if (!ref)
 		return -ENOMEM;
 
@@ -369,7 +389,8 @@ static int __resolve_indirect_refs(struct btrfs_fs_info *fs_info,
 
 		/* additional parents require new refs being added here */
 		while ((node = ulist_next(parents, &uiter))) {
-			new_ref = kmalloc(sizeof(*new_ref), GFP_NOFS);
+			new_ref = kmem_cache_alloc(btrfs_prelim_ref_cache,
+						   GFP_NOFS);
 			if (!new_ref) {
 				ret = -ENOMEM;
 				goto out;
@@ -493,7 +514,7 @@ static void __merge_refs(struct list_head *head, int mode)
 			ref1->count += ref2->count;
 
 			list_del(&ref2->list);
-			kfree(ref2);
+			kmem_cache_free(btrfs_prelim_ref_cache, ref2);
 		}
 
 	}
@@ -956,7 +977,7 @@ again:
 			}
 		}
 		list_del(&ref->list);
-		kfree(ref);
+		kmem_cache_free(btrfs_prelim_ref_cache, ref);
 	}
 
 out:
@@ -964,13 +985,13 @@ out:
 	while (!list_empty(&prefs)) {
 		ref = list_first_entry(&prefs, struct __prelim_ref, list);
 		list_del(&ref->list);
-		kfree(ref);
+		kmem_cache_free(btrfs_prelim_ref_cache, ref);
 	}
 	while (!list_empty(&prefs_delayed)) {
 		ref = list_first_entry(&prefs_delayed, struct __prelim_ref,
 				       list);
 		list_del(&ref->list);
-		kfree(ref);
+		kmem_cache_free(btrfs_prelim_ref_cache, ref);
 	}
 
 	return ret;
diff --git a/fs/btrfs/backref.h b/fs/btrfs/backref.h
index 8f2e767..a910b27 100644
--- a/fs/btrfs/backref.h
+++ b/fs/btrfs/backref.h
@@ -72,4 +72,6 @@ int btrfs_find_one_extref(struct btrfs_root *root, u64 inode_objectid,
 			  struct btrfs_inode_extref **ret_extref,
 			  u64 *found_off);
 
+int __init btrfs_prelim_ref_init(void);
+void btrfs_prelim_ref_exit(void);
 #endif
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 1967903..812ab3d 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -56,6 +56,7 @@
 #include "rcu-string.h"
 #include "dev-replace.h"
 #include "free-space-cache.h"
+#include "backref.h"
 
 #define CREATE_TRACE_POINTS
 #include <trace/events/btrfs.h>
@@ -1800,6 +1801,10 @@ static int __init init_btrfs_fs(void)
 	if (err)
 		goto free_auto_defrag;
 
+	err = btrfs_prelim_ref_init();
+	if (err)
+		goto free_prelim_ref;
+
 	err = btrfs_interface_init();
 	if (err)
 		goto free_delayed_ref;
@@ -1817,6 +1822,8 @@ static int __init init_btrfs_fs(void)
 
 unregister_ioctl:
 	btrfs_interface_exit();
+free_prelim_ref:
+	btrfs_prelim_ref_exit();
 free_delayed_ref:
 	btrfs_delayed_ref_exit();
 free_auto_defrag:
@@ -1843,6 +1850,7 @@ static void __exit exit_btrfs_fs(void)
 	btrfs_delayed_ref_exit();
 	btrfs_auto_defrag_exit();
 	btrfs_delayed_inode_exit();
+	btrfs_prelim_ref_exit();
 	ordered_data_exit();
 	extent_map_exit();
 	extent_io_exit();
-- 
1.8.0.1

