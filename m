Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f48.google.com ([209.85.220.48]:33428 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756602Ab3CYLJM (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 25 Mar 2013 07:09:12 -0400
Received: by mail-pa0-f48.google.com with SMTP id hz10so971841pad.21
        for <linux-btrfs@vger.kernel.org>; Mon, 25 Mar 2013 04:09:12 -0700 (PDT)
From: Wang Shilong <wangshilong1991@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: wangshilong1991@gmail.com, sensille@gmx.net
Subject: [PATCH 2/2] Btrfs: kill some BUG_ONs() in the find_parent_nodes()
Date: Mon, 25 Mar 2013 19:09:07 +0800
Message-Id: <1364209747-1623-1-git-send-email-wangshilong1991@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Wang Shilong <wangsl-fnst@cn.fujitsu.com>

The reason that BUG_ON() happens in these places is just
because of ENOMEM. 

We try ro return ENOMEM rather than trigger BUG_ON(), the
caller will abort the transaction thus avoiding the kernel panic.

Signed-off-by: Wang Shilong <wangsl-fnst@cn.fujitsu.com>
Reviewed-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/backref.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/backref.c b/fs/btrfs/backref.c
index bd605c8..a5e2beb 100644
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
@@ -920,6 +921,8 @@ again:
 			ret = ulist_add_merge(refs, ref->parent,
 					      (uintptr_t)ref->inode_list,
 					      (u64 *)&eie, GFP_NOFS);
+			if (ret)
+				goto out;
 			if (!ret && extent_item_pos) {
 				/*
 				 * we've recorded that parent, so we must extend
@@ -930,7 +933,6 @@ again:
 					eie = eie->next;
 				eie->next = ref->inode_list;
 			}
-			BUG_ON(ret < 0);
 		}
 		kfree(ref);
 	}
-- 
1.7.7.6

