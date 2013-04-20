Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f42.google.com ([209.85.220.42]:51131 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754848Ab3DTOoL (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 20 Apr 2013 10:44:11 -0400
Received: by mail-pa0-f42.google.com with SMTP id kq13so2796621pab.15
        for <linux-btrfs@vger.kernel.org>; Sat, 20 Apr 2013 07:44:11 -0700 (PDT)
From: Wang Shilong <wangshilong1991@gmail.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: make ulist_{init,fin}() static and not exported as symbol
Date: Sat, 20 Apr 2013 22:43:43 +0800
Message-Id: <1366469023-10449-1-git-send-email-wangshilong1991@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Wang Shilong <wangsl-fnst@cn.fujitsu.com>

ulist is a generic structure to iterate tree. we export them
just in the hope it may be used by other modules. However, until
now, it is just used by btrfs. The main point is that ulist_{init,fin}()
should be only called by ulist_{alloc,reinit,free}().So we don't need
to export them and make them staic will be best choice.

Signed-off-by: Wang Shilong <wangsl-fnst@cn.fujitsu.com>
---
 fs/btrfs/ulist.c | 6 ++----
 fs/btrfs/ulist.h | 2 --
 2 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/ulist.c b/fs/btrfs/ulist.c
index ddc61ca..50fc1c4 100644
--- a/fs/btrfs/ulist.c
+++ b/fs/btrfs/ulist.c
@@ -48,13 +48,12 @@
  * Note: don't use this function to init an already used ulist, use
  * ulist_reinit instead.
  */
-void ulist_init(struct ulist *ulist)
+static void ulist_init(struct ulist *ulist)
 {
 	ulist->nnodes = 0;
 	ulist->nodes = ulist->int_nodes;
 	ulist->nodes_alloced = ULIST_SIZE;
 }
-EXPORT_SYMBOL(ulist_init);
 
 /**
  * ulist_fini - free up additionally allocated memory for the ulist
@@ -63,7 +62,7 @@ EXPORT_SYMBOL(ulist_init);
  * This is useful in cases where the base 'struct ulist' has been statically
  * allocated.
  */
-void ulist_fini(struct ulist *ulist)
+static void ulist_fini(struct ulist *ulist)
 {
 	/*
 	 * The first ULIST_SIZE elements are stored inline in struct ulist.
@@ -73,7 +72,6 @@ void ulist_fini(struct ulist *ulist)
 		kfree(ulist->nodes);
 	ulist->nodes_alloced = 0;	/* in case ulist_fini is called twice */
 }
-EXPORT_SYMBOL(ulist_fini);
 
 /**
  * ulist_reinit - prepare a ulist for reuse
diff --git a/fs/btrfs/ulist.h b/fs/btrfs/ulist.h
index 21a1963..e05db47 100644
--- a/fs/btrfs/ulist.h
+++ b/fs/btrfs/ulist.h
@@ -60,8 +60,6 @@ struct ulist {
 	struct ulist_node int_nodes[ULIST_SIZE];
 };
 
-void ulist_init(struct ulist *ulist);
-void ulist_fini(struct ulist *ulist);
 void ulist_reinit(struct ulist *ulist);
 struct ulist *ulist_alloc(gfp_t gfp_mask);
 void ulist_free(struct ulist *ulist);
-- 
1.7.11.7

