Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:38924 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751281AbaAYF3E (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 25 Jan 2014 00:29:04 -0500
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s0P5SwkH021070
	for <linux-btrfs@vger.kernel.org>; Sat, 25 Jan 2014 13:28:58 +0800
From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 2/2] Btrfs: do not export ulist functions
Date: Sat, 25 Jan 2014 13:27:43 +0800
Message-Id: <1390627663-2924-2-git-send-email-wangsl.fnst@cn.fujitsu.com>
In-Reply-To: <1390627663-2924-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
References: <1390627663-2924-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

There are not any users that use ulist except Btrfs,don't
export them.

Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
---
 fs/btrfs/ulist.c | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/fs/btrfs/ulist.c b/fs/btrfs/ulist.c
index 674430b..02bfbec 100644
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
@@ -73,7 +71,6 @@ void ulist_fini(struct ulist *ulist)
 	}
 	ulist->root = RB_ROOT;
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
@@ -213,7 +207,6 @@ int ulist_add_merge(struct ulist *ulist, u64 val, u64 aux,
 
 	return 1;
 }
-EXPORT_SYMBOL(ulist_add);
 
 /**
  * ulist_next - iterate ulist
@@ -251,4 +244,3 @@ struct ulist_node *ulist_next(struct ulist *ulist, struct ulist_iterator *uiter)
 
 	return node;
 }
-EXPORT_SYMBOL(ulist_next);
-- 
1.8.3.1

