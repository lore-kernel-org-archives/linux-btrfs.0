Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:1604 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751303AbaAJN1C (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 10 Jan 2014 08:27:02 -0500
From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Cc: Wang Shilong <wangsl.fnst@cn.fujitsu.com>, Liu Bo <bo.li.liu@oracle.com>
Subject: [PATCH] Btrfs: optimize to remove unnecessary removal with ulist reallocation
Date: Fri, 10 Jan 2014 21:25:46 +0800
Message-Id: <1389360346-23842-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Here we are not going to free memory, no need to remove every node
one by one, just init root node here is ok.

Cc:  Liu Bo <bo.li.liu@oracle.com>
Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
---
 fs/btrfs/ulist.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/fs/btrfs/ulist.c b/fs/btrfs/ulist.c
index b0a523b2..35f5de9 100644
--- a/fs/btrfs/ulist.c
+++ b/fs/btrfs/ulist.c
@@ -207,9 +207,6 @@ int ulist_add_merge(struct ulist *ulist, u64 val, u64 aux,
 		void *old = NULL;
 		int i;
 
-		for (i = 0; i < ulist->nnodes; i++)
-			rb_erase(&ulist->nodes[i].rb_node, &ulist->root);
-
 		/*
 		 * if nodes_alloced == ULIST_SIZE no memory has been allocated
 		 * yet, so pass NULL to krealloc
@@ -234,6 +231,7 @@ int ulist_add_merge(struct ulist *ulist, u64 val, u64 aux,
 		 * pointers, so we have to do it ourselves.  Otherwise we may
 		 * be bitten by crashes.
 		 */
+		ulist->root = RB_ROOT;
 		for (i = 0; i < ulist->nnodes; i++) {
 			ret = ulist_rbtree_insert(ulist, &ulist->nodes[i]);
 			if (ret < 0)
-- 
1.8.3.1

