Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pb0-f45.google.com ([209.85.160.45]:55057 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757065Ab3CYMR1 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 25 Mar 2013 08:17:27 -0400
Received: by mail-pb0-f45.google.com with SMTP id ro8so4165751pbb.4
        for <linux-btrfs@vger.kernel.org>; Mon, 25 Mar 2013 05:17:26 -0700 (PDT)
From: Wang Shilong <wangshilong1991@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: wangshilong1991@gmail.com, sensille@gmx.net, list.btrfs@jan-o-sch.net
Subject: [PATCH V2 2/2] Btrfs: kill some BUG_ONs() in the find_parent_nodes()
Date: Mon, 25 Mar 2013 20:11:41 +0800
Message-Id: <1364213501-2422-1-git-send-email-wangshilong1991@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Wang Shilong <wangsl-fnst@cn.fujitsu.com>

The reason that BUG_ON() happens in these places is just
because of ENOMEM.

We try ro return ENOMEM rather than trigger BUG_ON(), the
caller will abort the transaction thus avoiding the kernel panic.

Signed-off-by: Wang Shilong <wangsl-fnst@cn.fujitsu.com>
Reviewed-by: Miao Xie <miaox@cn.fujitsu.com>
Reviewed-by: Jan Schmidt <list.btrfs@jan-o-sch.net>
---
 fs/btrfs/backref.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/backref.c b/fs/btrfs/backref.c
index bd605c8..5ff46ee 100644
--- a/fs/btrfs/backref.c
+++ b/fs/btrfs/backref.c
@@ -900,7 +900,8 @@ again:
 		if (ref->count && ref->root_id && ref->parent == 0) {
 			/* no parent == root of tree */
 			ret = ulist_add(roots, ref->root_id, 0, GFP_NOFS);
-			BUG_ON(ret < 0);
+			if (ret)
+				goto out;
 		}
 		if (ref->count && ref->parent) {
 			struct extent_inode_elem *eie = NULL;
@@ -920,7 +921,9 @@ again:
 			ret = ulist_add_merge(refs, ref->parent,
 					      (uintptr_t)ref->inode_list,
 					      (u64 *)&eie, GFP_NOFS);
-			if (!ret && extent_item_pos) {
+			if (ret)
+				goto out;
+			if (extent_item_pos) {
 				/*
 				 * we've recorded that parent, so we must extend
 				 * its inode list here
@@ -930,7 +933,6 @@ again:
 					eie = eie->next;
 				eie->next = ref->inode_list;
 			}
-			BUG_ON(ret < 0);
 		}
 		kfree(ref);
 	}
-- 
1.7.11.7

