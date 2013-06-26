Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:45281 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750712Ab3FZEDE (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 26 Jun 2013 00:03:04 -0400
Received: from ucsinet22.oracle.com (ucsinet22.oracle.com [156.151.31.94])
	by userp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with ESMTP id r5Q3ujxX022848
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Wed, 26 Jun 2013 03:56:45 GMT
Received: from userz7022.oracle.com (userz7022.oracle.com [156.151.31.86])
	by ucsinet22.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r5Q433fZ007369
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Wed, 26 Jun 2013 04:03:03 GMT
Received: from abhmt110.oracle.com (abhmt110.oracle.com [141.146.116.62])
	by userz7022.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r5Q4326f007357
	for <linux-btrfs@vger.kernel.org>; Wed, 26 Jun 2013 04:03:03 GMT
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: fix crash regarding to ulist_add_merge
Date: Wed, 26 Jun 2013 12:02:51 +0800
Message-Id: <1372219371-15668-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Several users reported this crash of NULL pointer or general protection,
the story is that we add a rbtree for speedup ulist iteration, and we
use krealloc() to address ulist growth, and krealloc() use memcpy to copy
old data to new memory area, so it's OK for an array as it doesn't use
pointers while it's not OK for a rbtree as it uses pointers.

So krealloc() will mess up our rbtree and it ends up with crash.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/ulist.c |   13 ++++++++++++-
 1 files changed, 12 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/ulist.c b/fs/btrfs/ulist.c
index 7b417e2..69a9c32 100644
--- a/fs/btrfs/ulist.c
+++ b/fs/btrfs/ulist.c
@@ -73,7 +73,6 @@ void ulist_fini(struct ulist *ulist)
 	if (ulist->nodes_alloced > ULIST_SIZE)
 		kfree(ulist->nodes);
 	ulist->nodes_alloced = 0;	/* in case ulist_fini is called twice */
-	ulist->root = RB_ROOT;
 }
 EXPORT_SYMBOL(ulist_fini);
 
@@ -205,6 +204,7 @@ int ulist_add_merge(struct ulist *ulist, u64 val, u64 aux,
 		u64 new_alloced = ulist->nodes_alloced + 128;
 		struct ulist_node *new_nodes;
 		void *old = NULL;
+		int i;
 
 		/*
 		 * if nodes_alloced == ULIST_SIZE no memory has been allocated
@@ -222,6 +222,17 @@ int ulist_add_merge(struct ulist *ulist, u64 val, u64 aux,
 			memcpy(new_nodes, ulist->int_nodes,
 			       sizeof(ulist->int_nodes));
 
+		/*
+		 * krealloc actually uses memcpy, which does not copy rb_node
+		 * pointers, so we have to do it ourselves.  Otherwise we may
+		 * be bitten by crashes.
+		 */
+		for (i = 0; i < ulist->nnodes; i++) {
+			rb_erase(&ulist->nodes[i].rb_node, &ulist->root);
+			ret = ulist_rbtree_insert(ulist, &new_nodes[i]);
+			BUG_ON(ret);
+		}
+
 		ulist->nodes = new_nodes;
 		ulist->nodes_alloced = new_alloced;
 	}
-- 
1.7.7

