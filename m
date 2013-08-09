Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:31980 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S932676Ab3HIF1K (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 9 Aug 2013 01:27:10 -0400
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id r795R6Rd008848
	for <linux-btrfs@vger.kernel.org>; Fri, 9 Aug 2013 13:27:06 +0800
From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [patch v2 1/2] Btrfs: fix possible memory leak in find_parent_nodes()
Date: Fri, 9 Aug 2013 13:25:35 +0800
Message-Id: <1376025936-21652-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The origin code dealt with 'ref' as following steps:
	|->list_del(&ref-list)
		|->some operations
	|->kfree(ref)

If operations failed, it would goto label 'out' without freeing this 'ref'.
and then memory leak would happen.Just move list_del() after kfree()
will fix the problem.

Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
Reviewed-by: Miao Xie <miaox@cn.fujitsu.com>
---
V1->V2: add explanations to changelog
---
 fs/btrfs/backref.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/backref.c b/fs/btrfs/backref.c
index 68048d6..7b55c95 100644
--- a/fs/btrfs/backref.c
+++ b/fs/btrfs/backref.c
@@ -911,7 +911,6 @@ again:
 
 	while (!list_empty(&prefs)) {
 		ref = list_first_entry(&prefs, struct __prelim_ref, list);
-		list_del(&ref->list);
 		WARN_ON(ref->count < 0);
 		if (ref->count && ref->root_id && ref->parent == 0) {
 			/* no parent == root of tree */
@@ -956,6 +955,7 @@ again:
 				eie->next = ref->inode_list;
 			}
 		}
+		list_del(&ref->list);
 		kfree(ref);
 	}
 
-- 
1.8.0.1

