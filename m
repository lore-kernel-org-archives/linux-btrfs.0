Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:47328 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753978Ab3F1CZs (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 27 Jun 2013 22:25:48 -0400
Received: from acsinet22.oracle.com (acsinet22.oracle.com [141.146.126.238])
	by userp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with ESMTP id r5S2JRt8012376
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Fri, 28 Jun 2013 02:19:28 GMT
Received: from aserz7021.oracle.com (aserz7021.oracle.com [141.146.126.230])
	by acsinet22.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r5S2Pk3W018478
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Fri, 28 Jun 2013 02:25:46 GMT
Received: from abhmt116.oracle.com (abhmt116.oracle.com [141.146.116.68])
	by aserz7021.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r5S2PjcD023528
	for <linux-btrfs@vger.kernel.org>; Fri, 28 Jun 2013 02:25:45 GMT
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2] Btrfs: fix crash regarding to ulist_add_merge
Date: Fri, 28 Jun 2013 10:25:39 +0800
Message-Id: <1372386339-32599-1-git-send-email-bo.li.liu@oracle.com>
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
v2: fix an use-after-free bug and a finger error(Thanks Zach and Josef).

 fs/btrfs/ulist.c |   17 +++++++++++++++++
 1 files changed, 17 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/ulist.c b/fs/btrfs/ulist.c
index 7b417e2..adc9aac 100644
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
@@ -224,6 +228,19 @@ int ulist_add_merge(struct ulist *ulist, u64 val, u64 aux,
 
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
+			if (ret) {
+				kfree(new_nodes);
+				return -ENOMEM;
+			}
+		}
 	}
 	ulist->nodes[ulist->nnodes].val = val;
 	ulist->nodes[ulist->nnodes].aux = aux;
-- 
1.7.7

