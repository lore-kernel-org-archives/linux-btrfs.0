Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:28062 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754785Ab3GaBea (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 30 Jul 2013 21:34:30 -0400
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org, stable@vger.kernel.org
Subject: [PATCH RESEND] Btrfs: fix crash regarding to ulist_add_merge
Date: Wed, 31 Jul 2013 09:34:14 +0800
Message-Id: <1375234454-6061-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Several users reported this crash of NULL pointer or general protection,
the story is that we add a rbtree for speedup ulist iteration, and we
use krealloc() to address ulist growth, and krealloc() use memcpy to copy
old data to new memory area, so it's OK for an array as it doesn't use
pointers while it's not OK for a rbtree as it uses pointers.

So krealloc() will mess up our rbtree and it ends up with crash.

Cc: stable@vger.kernel.org
Reviewed-by: Wang Shilong <wangsl-fnst@cn.fujitsu.com>
Reviewed-by: Jan Schmidt <list.btrfs@jan-o-sch.net>
Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
Cc -stable!

 fs/btrfs/ulist.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/fs/btrfs/ulist.c b/fs/btrfs/ulist.c
index 7b417e2..b0a523b2 100644
--- a/fs/btrfs/ulist.c
+++ b/fs/btrfs/ulist.c
@@ -205,6 +205,10 @@ int ulist_add_merge(struct ulist *ulist, u64 val, u64 aux,
 		u64 new_alloced = ulist->nodes_alloced + 128;
 		struct ulist_node *new_nodes;
 		void *old = NULL;
+		int i;
+
+		for (i = 0; i < ulist->nnodes; i++)
+			rb_erase(&ulist->nodes[i].rb_node, &ulist->root);
 
 		/*
 		 * if nodes_alloced == ULIST_SIZE no memory has been allocated
@@ -224,6 +228,17 @@ int ulist_add_merge(struct ulist *ulist, u64 val, u64 aux,
 
 		ulist->nodes = new_nodes;
 		ulist->nodes_alloced = new_alloced;
+
+		/*
+		 * krealloc actually uses memcpy, which does not copy rb_node
+		 * pointers, so we have to do it ourselves.  Otherwise we may
+		 * be bitten by crashes.
+		 */
+		for (i = 0; i < ulist->nnodes; i++) {
+			ret = ulist_rbtree_insert(ulist, &ulist->nodes[i]);
+			if (ret < 0)
+				return ret;
+		}
 	}
 	ulist->nodes[ulist->nnodes].val = val;
 	ulist->nodes[ulist->nnodes].aux = aux;
-- 
1.8.1.4

