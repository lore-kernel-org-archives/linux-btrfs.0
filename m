Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:43999 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755999Ab3HHFFt (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 8 Aug 2013 01:05:49 -0400
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id r7855lij008783
	for <linux-btrfs@vger.kernel.org>; Thu, 8 Aug 2013 13:05:47 +0800
From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 1/3] Btrfs: fix possible memory leak in find_parent_nodes()
Date: Thu, 8 Aug 2013 13:04:17 +0800
Message-Id: <1375938259-5015-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
Reviewed-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/backref.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/backref.c b/fs/btrfs/backref.c
index cb73a12..54e7610 100644
--- a/fs/btrfs/backref.c
+++ b/fs/btrfs/backref.c
@@ -911,7 +911,6 @@ again:
 
 	while (!list_empty(&prefs)) {
 		ref = list_first_entry(&prefs, struct __prelim_ref, list);
-		list_del(&ref->list);
 		WARN_ON(ref->count < 0);
 		if (ref->count && ref->root_id && ref->parent == 0) {
 			/* no parent == root of tree */
@@ -954,6 +953,7 @@ again:
 				eie->next = ref->inode_list;
 			}
 		}
+		list_del(&ref->list);
 		kfree(ref);
 	}
 
-- 
1.8.0.1

