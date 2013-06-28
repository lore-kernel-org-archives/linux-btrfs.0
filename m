Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:44706 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750882Ab3F1Eh7 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 28 Jun 2013 00:37:59 -0400
Received: from acsinet21.oracle.com (acsinet21.oracle.com [141.146.126.237])
	by userp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with ESMTP id r5S4VdBH010302
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Fri, 28 Jun 2013 04:31:40 GMT
Received: from userz7022.oracle.com (userz7022.oracle.com [156.151.31.86])
	by acsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r5S4bvj2014478
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Fri, 28 Jun 2013 04:37:58 GMT
Received: from abhmt112.oracle.com (abhmt112.oracle.com [141.146.116.64])
	by userz7022.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r5S4bv9k015692
	for <linux-btrfs@vger.kernel.org>; Fri, 28 Jun 2013 04:37:57 GMT
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v3] Btrfs: fix crash regarding to ulist_add_merge
Date: Fri, 28 Jun 2013 12:37:45 +0800
Message-Id: <1372394265-1959-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Several users reported this crash of NULL pointer or general protection,
the story is that we add a rbtree for speedup ulist iteration, and we
use krealloc() to address ulist growth, and krealloc() use memcpy to copy
old data to new memory area, so it's OK for an array as it doesn't use
pointers while it's not OK for a rbtree as it uses pointers.

So krealloc() will mess up our rbtree and it ends up with crash.

Reviewed-by: Wang Shilong <wangsl-fnst@cn.fujitsu.com>
Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
v3: fix a return value problem(Thanks Wang Shilong).
v2: fix an use-after-free bug and a finger error(Thanks Zach and Josef).

 fs/btrfs/ulist.c |   15 +++++++++++++++
 1 files changed, 15 insertions(+), 0 deletions(-)

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
1.7.7

