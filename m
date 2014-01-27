Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:32849 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753138AbaA0KBL (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 27 Jan 2014 05:01:11 -0500
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s0RA1750013224
	for <linux-btrfs@vger.kernel.org>; Mon, 27 Jan 2014 18:01:08 +0800
From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v3 2/2] Btrfs: do not export ulist functions
Date: Mon, 27 Jan 2014 17:59:48 +0800
Message-Id: <1390816789-3901-2-git-send-email-wangsl.fnst@cn.fujitsu.com>
In-Reply-To: <1390816789-3901-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
References: <1390816789-3901-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

There are not any users that use ulist except Btrfs,don't
export them.

Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
---
v2->v3: none.
v1->v2: make ulist_fini() static since it is not called anywhere.
---
 fs/btrfs/ulist.c | 10 +---------
 fs/btrfs/ulist.h |  1 -
 2 files changed, 1 insertion(+), 10 deletions(-)

diff --git a/fs/btrfs/ulist.c b/fs/btrfs/ulist.c
index 1c9e2c9..84ea442 100644
--- a/fs/btrfs/ulist.c
+++ b/fs/btrfs/ulist.c
@@ -5,7 +5,6 @@
  */
 
 #include <linux/slab.h>
-#include <linux/export.h>
 #include "ulist.h"
 #include "ctree.h"
 
@@ -53,7 +52,6 @@ void ulist_init(struct ulist *ulist)
 	ulist->nnodes = 0;
 #endif
 }
-EXPORT_SYMBOL(ulist_init);
 
 /**
  * ulist_fini - free up additionally allocated memory for the ulist
@@ -62,7 +60,7 @@ EXPORT_SYMBOL(ulist_init);
  * This is useful in cases where the base 'struct ulist' has been statically
  * allocated.
  */
-void ulist_fini(struct ulist *ulist)
+static void ulist_fini(struct ulist *ulist)
 {
 	struct ulist_node *node;
 	struct ulist_node *next;
@@ -73,7 +71,6 @@ void ulist_fini(struct ulist *ulist)
 	ulist->root = RB_ROOT;
 	INIT_LIST_HEAD(&ulist->nodes);
 }
-EXPORT_SYMBOL(ulist_fini);
 
 /**
  * ulist_reinit - prepare a ulist for reuse
@@ -87,7 +84,6 @@ void ulist_reinit(struct ulist *ulist)
 	ulist_fini(ulist);
 	ulist_init(ulist);
 }
-EXPORT_SYMBOL(ulist_reinit);
 
 /**
  * ulist_alloc - dynamically allocate a ulist
@@ -106,7 +102,6 @@ struct ulist *ulist_alloc(gfp_t gfp_mask)
 
 	return ulist;
 }
-EXPORT_SYMBOL(ulist_alloc);
 
 /**
  * ulist_free - free dynamically allocated ulist
@@ -121,7 +116,6 @@ void ulist_free(struct ulist *ulist)
 	ulist_fini(ulist);
 	kfree(ulist);
 }
-EXPORT_SYMBOL(ulist_free);
 
 static struct ulist_node *ulist_rbtree_search(struct ulist *ulist, u64 val)
 {
@@ -218,7 +212,6 @@ int ulist_add_merge(struct ulist *ulist, u64 val, u64 aux,
 
 	return 1;
 }
-EXPORT_SYMBOL(ulist_add);
 
 /**
  * ulist_next - iterate ulist
@@ -260,4 +253,3 @@ struct ulist_node *ulist_next(struct ulist *ulist, struct ulist_iterator *uiter)
 #endif
 	return node;
 }
-EXPORT_SYMBOL(ulist_next);
diff --git a/fs/btrfs/ulist.h b/fs/btrfs/ulist.h
index 7be97fc..154117d 100644
--- a/fs/btrfs/ulist.h
+++ b/fs/btrfs/ulist.h
@@ -52,7 +52,6 @@ struct ulist {
 };
 
 void ulist_init(struct ulist *ulist);
-void ulist_fini(struct ulist *ulist);
 void ulist_reinit(struct ulist *ulist);
 struct ulist *ulist_alloc(gfp_t gfp_mask);
 void ulist_free(struct ulist *ulist);
-- 
1.8.3.1

