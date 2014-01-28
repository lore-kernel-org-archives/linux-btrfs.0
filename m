Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pd0-f182.google.com ([209.85.192.182]:50216 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754714AbaA1QZg (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 28 Jan 2014 11:25:36 -0500
Received: by mail-pd0-f182.google.com with SMTP id v10so537055pde.13
        for <linux-btrfs@vger.kernel.org>; Tue, 28 Jan 2014 08:25:36 -0800 (PST)
Received: from promote.localdomain ([112.2.80.174])
        by mx.google.com with ESMTPSA id e6sm44034738pbg.4.2014.01.28.08.25.34
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 28 Jan 2014 08:25:35 -0800 (PST)
From: Wang Shilong <wangshilong1991@gmail.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v4 2/2] Btrfs: do not export ulist functions
Date: Wed, 29 Jan 2014 00:25:35 +0800
Message-Id: <1390926335-6100-2-git-send-email-wangshilong1991@gmail.com>
In-Reply-To: <1390926335-6100-1-git-send-email-wangshilong1991@gmail.com>
References: <1390926335-6100-1-git-send-email-wangshilong1991@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>

There are not any users that use ulist except Btrfs,don't
export them.

Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
Reviewed-by: David Sterba <dsterba@suse.cz>
---
v3->v4: none
v2->v3: none
v1->v2: make ulist_fini static
---
 fs/btrfs/ulist.c | 10 +---------
 fs/btrfs/ulist.h |  1 -
 2 files changed, 1 insertion(+), 10 deletions(-)

diff --git a/fs/btrfs/ulist.c b/fs/btrfs/ulist.c
index 8dd0e8d..840a38b 100644
--- a/fs/btrfs/ulist.c
+++ b/fs/btrfs/ulist.c
@@ -5,7 +5,6 @@
  */
 
 #include <linux/slab.h>
-#include <linux/export.h>
 #include "ulist.h"
 #include "ctree.h"
 
@@ -51,7 +50,6 @@ void ulist_init(struct ulist *ulist)
 	ulist->root = RB_ROOT;
 	ulist->nnodes = 0;
 }
-EXPORT_SYMBOL(ulist_init);
 
 /**
  * ulist_fini - free up additionally allocated memory for the ulist
@@ -60,7 +58,7 @@ EXPORT_SYMBOL(ulist_init);
  * This is useful in cases where the base 'struct ulist' has been statically
  * allocated.
  */
-void ulist_fini(struct ulist *ulist)
+static void ulist_fini(struct ulist *ulist)
 {
 	struct ulist_node *node;
 	struct ulist_node *next;
@@ -71,7 +69,6 @@ void ulist_fini(struct ulist *ulist)
 	ulist->root = RB_ROOT;
 	INIT_LIST_HEAD(&ulist->nodes);
 }
-EXPORT_SYMBOL(ulist_fini);
 
 /**
  * ulist_reinit - prepare a ulist for reuse
@@ -85,7 +82,6 @@ void ulist_reinit(struct ulist *ulist)
 	ulist_fini(ulist);
 	ulist_init(ulist);
 }
-EXPORT_SYMBOL(ulist_reinit);
 
 /**
  * ulist_alloc - dynamically allocate a ulist
@@ -104,7 +100,6 @@ struct ulist *ulist_alloc(gfp_t gfp_mask)
 
 	return ulist;
 }
-EXPORT_SYMBOL(ulist_alloc);
 
 /**
  * ulist_free - free dynamically allocated ulist
@@ -119,7 +114,6 @@ void ulist_free(struct ulist *ulist)
 	ulist_fini(ulist);
 	kfree(ulist);
 }
-EXPORT_SYMBOL(ulist_free);
 
 static struct ulist_node *ulist_rbtree_search(struct ulist *ulist, u64 val)
 {
@@ -214,7 +208,6 @@ int ulist_add_merge(struct ulist *ulist, u64 val, u64 aux,
 
 	return 1;
 }
-EXPORT_SYMBOL(ulist_add);
 
 /**
  * ulist_next - iterate ulist
@@ -256,4 +249,3 @@ struct ulist_node *ulist_next(struct ulist *ulist, struct ulist_iterator *uiter)
 #endif
 	return node;
 }
-EXPORT_SYMBOL(ulist_next);
diff --git a/fs/btrfs/ulist.h b/fs/btrfs/ulist.h
index 2be7102..7f78cbf 100644
--- a/fs/btrfs/ulist.h
+++ b/fs/btrfs/ulist.h
@@ -51,7 +51,6 @@ struct ulist {
 };
 
 void ulist_init(struct ulist *ulist);
-void ulist_fini(struct ulist *ulist);
 void ulist_reinit(struct ulist *ulist);
 struct ulist *ulist_alloc(gfp_t gfp_mask);
 void ulist_free(struct ulist *ulist);
-- 
1.8.4

