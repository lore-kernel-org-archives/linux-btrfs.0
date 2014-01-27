Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:55609 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753347AbaA0KBL (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 27 Jan 2014 05:01:11 -0500
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s0RA17mv013223
	for <linux-btrfs@vger.kernel.org>; Mon, 27 Jan 2014 18:01:08 +0800
From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: allocate ulist with a slab allocator
Date: Mon, 27 Jan 2014 17:59:49 +0800
Message-Id: <1390816789-3901-3-git-send-email-wangsl.fnst@cn.fujitsu.com>
In-Reply-To: <1390816789-3901-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
References: <1390816789-3901-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Walking backrefs is heavily relying on ulist, so it is better
to allocate ulist with a slab allocator especially with autodefrag
and quota enabled.

Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
---
 fs/btrfs/super.c |  7 +++++++
 fs/btrfs/ulist.c | 22 ++++++++++++++++++++--
 fs/btrfs/ulist.h |  2 ++
 3 files changed, 29 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 461e41c..1a9ac6d 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -1906,6 +1906,10 @@ static int __init init_btrfs_fs(void)
 	if (err)
 		goto free_prelim_ref;
 
+	err = btrfs_ulist_init();
+	if (err)
+		goto free_ulist;
+
 	err = btrfs_interface_init();
 	if (err)
 		goto free_delayed_ref;
@@ -1926,6 +1930,8 @@ static int __init init_btrfs_fs(void)
 
 unregister_ioctl:
 	btrfs_interface_exit();
+free_ulist:
+	btrfs_ulist_exit();
 free_prelim_ref:
 	btrfs_prelim_ref_exit();
 free_delayed_ref:
@@ -1955,6 +1961,7 @@ static void __exit exit_btrfs_fs(void)
 	btrfs_auto_defrag_exit();
 	btrfs_delayed_inode_exit();
 	btrfs_prelim_ref_exit();
+	btrfs_ulist_exit();
 	ordered_data_exit();
 	extent_map_exit();
 	extent_io_exit();
diff --git a/fs/btrfs/ulist.c b/fs/btrfs/ulist.c
index 84ea442..bf9127d 100644
--- a/fs/btrfs/ulist.c
+++ b/fs/btrfs/ulist.c
@@ -8,6 +8,7 @@
 #include "ulist.h"
 #include "ctree.h"
 
+static struct kmem_cache *btrfs_ulist_cache;
 /*
  * ulist is a generic data structure to hold a collection of unique u64
  * values. The only operations it supports is adding to the list and
@@ -66,7 +67,7 @@ static void ulist_fini(struct ulist *ulist)
 	struct ulist_node *next;
 
 	list_for_each_entry_safe(node, next, &ulist->nodes, list) {
-		kfree(node);
+		kmem_cache_free(btrfs_ulist_cache, node);
 	}
 	ulist->root = RB_ROOT;
 	INIT_LIST_HEAD(&ulist->nodes);
@@ -156,6 +157,23 @@ static int ulist_rbtree_insert(struct ulist *ulist, struct ulist_node *ins)
 	return 0;
 }
 
+int __init btrfs_ulist_init(void)
+{
+	btrfs_ulist_cache = kmem_cache_create("btrfs_ulist_cache",
+					sizeof(struct ulist_node), 0,
+					SLAB_RECLAIM_ACCOUNT | SLAB_MEM_SPREAD,
+					NULL);
+	if (!btrfs_ulist_cache)
+		return -ENOMEM;
+	return 0;
+}
+
+void btrfs_ulist_exit(void)
+{
+	if (btrfs_ulist_cache)
+		kmem_cache_destroy(btrfs_ulist_cache);
+}
+
 /**
  * ulist_add - add an element to the ulist
  * @ulist:	ulist to add the element to
@@ -193,7 +211,7 @@ int ulist_add_merge(struct ulist *ulist, u64 val, u64 aux,
 			*old_aux = node->aux;
 		return 0;
 	}
-	node = kmalloc(sizeof(*node), gfp_mask);
+	node = kmem_cache_alloc(btrfs_ulist_cache, gfp_mask);
 	if (!node)
 		return -ENOMEM;
 
diff --git a/fs/btrfs/ulist.h b/fs/btrfs/ulist.h
index 154117d..d094621 100644
--- a/fs/btrfs/ulist.h
+++ b/fs/btrfs/ulist.h
@@ -51,6 +51,8 @@ struct ulist {
 	struct rb_root root;
 };
 
+int __init btrfs_ulist_init(void);
+void btrfs_ulist_exit(void);
 void ulist_init(struct ulist *ulist);
 void ulist_reinit(struct ulist *ulist);
 struct ulist *ulist_alloc(gfp_t gfp_mask);
-- 
1.8.3.1

