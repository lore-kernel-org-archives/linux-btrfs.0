Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from e31.co.us.ibm.com ([32.97.110.149]:50119 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753087Ab2GEH0v (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 5 Jul 2012 03:26:51 -0400
Received: from /spool/local
	by e31.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <zwu.kernel@gmail.com>;
	Thu, 5 Jul 2012 01:26:51 -0600
From: zwu.kernel@gmail.com
To: linux-btrfs@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
Subject: [PATCH] btrfs-progs: rework the code logic
Date: Thu,  5 Jul 2012 15:26:38 +0800
Message-Id: <1341473198-3883-1-git-send-email-zwu.kernel@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>

Signed-off-by: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
---
 extent-cache.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/extent-cache.c b/extent-cache.c
index 3dd6434..a5084ee 100644
--- a/extent-cache.c
+++ b/extent-cache.c
@@ -136,10 +136,10 @@ struct cache_extent *find_first_cache_extent(struct cache_tree *tree,
 	struct cache_extent *entry;
 
 	ret = __tree_search(&tree->root, start, 1, &prev);
-	if (!ret)
+	if (!ret) {
 		ret = prev;
-	if (!ret)
 		return NULL;
+        }
 	entry = rb_entry(ret, struct cache_extent, rb_node);
 	return entry;
 }
-- 
1.7.6

