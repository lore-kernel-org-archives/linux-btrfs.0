Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pb0-f44.google.com ([209.85.160.44]:37903 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750889AbaAYG76 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 25 Jan 2014 01:59:58 -0500
Received: by mail-pb0-f44.google.com with SMTP id rq2so4042402pbb.17
        for <linux-btrfs@vger.kernel.org>; Fri, 24 Jan 2014 22:59:57 -0800 (PST)
From: Wang Shilong <wangshilong1991@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
Subject: [PATCH v2 2/2] Btrfs: do not export ulist functions
Date: Sat, 25 Jan 2014 14:59:38 +0800
Message-Id: <1390633178-2104-2-git-send-email-wangshilong1991@gmail.com>
In-Reply-To: <1390633178-2104-1-git-send-email-wangshilong1991@gmail.com>
References: <1390633178-2104-1-git-send-email-wangshilong1991@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>

There are not any users that use ulist except Btrfs,don't
export them.

Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
---
changelog v1->v2:
	make ulist_fini() static since it is not called anywhere.
---
 fs/btrfs/ulist.c | 10 +---------
 fs/btrfs/ulist.h |  1 -
 2 files changed, 1 insertion(+), 10 deletions(-)

diff --git a/fs/btrfs/ulist.c b/fs/btrfs/ulist.c
index c2307c4..accc04d 100644
--- a/fs/btrfs/ulist.c
+++ b/fs/btrfs/ulist.c
@@ -5,7 +5,6 @@
  */
 
 #include <linux/slab.h>
-#include <linux/export.h>
 #include "ulist.h"
 #include "ctree.h"
 
@@ -55,7 +54,6 @@ void ulist_init(struct ulist *ulist)
 	INIT_LIST_HEAD(&ulist->nodes);
 	ulist->root = RB_ROOT;
 }
-EXPORT_SYMBOL(ulist_init);
 
 /**
  * ulist_fini - free up additionally allocated memory for the ulist
@@ -64,7 +62,7 @@ EXPORT_SYMBOL(ulist_init);
  * This is useful in cases where the base 'struct ulist' has been statically
  * allocated.
  */
-void ulist_fini(struct ulist *ulist)
+static void ulist_fini(struct ulist *ulist)
 {
 	struct ulist_node *node;
 	struct ulist_node *next;
@@ -75,7 +73,6 @@ void ulist_fini(struct ulist *ulist)
 	ulist->root = RB_ROOT;
 	INIT_LIST_HEAD(&ulist->nodes);
 }
-EXPORT_SYMBOL(ulist_fini);
 
 /**
  * ulist_reinit - prepare a ulist for reuse
@@ -89,7 +86,6 @@ void ulist_reinit(struct ulist *ulist)
 	ulist_fini(ulist);
 	ulist_init(ulist);
 }
-EXPORT_SYMBOL(ulist_reinit);
 
 /**
  * ulist_alloc - dynamically allocate a ulist
@@ -108,7 +104,6 @@ struct ulist *ulist_alloc(gfp_t gfp_mask)
 
 	return ulist;
 }
-EXPORT_SYMBOL(ulist_alloc);
 
 /**
  * ulist_free - free dynamically allocated ulist
@@ -123,7 +118,6 @@ void ulist_free(struct ulist *ulist)
 	ulist_fini(ulist);
 	kfree(ulist);
 }
-EXPORT_SYMBOL(ulist_free);
 
 static struct ulist_node *ulist_rbtree_search(struct ulist *ulist, u64 val)
 {
@@ -215,7 +209,6 @@ int ulist_add_merge(struct ulist *ulist, u64 val, u64 aux,
 
 	return 1;
 }
-EXPORT_SYMBOL(ulist_add);
 
 /**
  * ulist_next - iterate ulist
@@ -253,4 +246,3 @@ struct ulist_node *ulist_next(struct ulist *ulist, struct ulist_iterator *uiter)
 
 	return node;
 }
-EXPORT_SYMBOL(ulist_next);
diff --git a/fs/btrfs/ulist.h b/fs/btrfs/ulist.h
index 03c6a3d..59057bd 100644
--- a/fs/btrfs/ulist.h
+++ b/fs/btrfs/ulist.h
@@ -57,7 +57,6 @@ struct ulist {
 };
 
 void ulist_init(struct ulist *ulist);
-void ulist_fini(struct ulist *ulist);
 void ulist_reinit(struct ulist *ulist);
 struct ulist *ulist_alloc(gfp_t gfp_mask);
 void ulist_free(struct ulist *ulist);
-- 
1.8.4

