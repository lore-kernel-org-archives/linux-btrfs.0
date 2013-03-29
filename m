Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pd0-f176.google.com ([209.85.192.176]:61516 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750980Ab3CaKEf (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 31 Mar 2013 06:04:35 -0400
Received: by mail-pd0-f176.google.com with SMTP id r11so803801pdi.7
        for <linux-btrfs@vger.kernel.org>; Sun, 31 Mar 2013 03:04:34 -0700 (PDT)
From: Wang Shilong <wangshilong1991@gmail.com>
To: wangshilong1991@gmail.com, linux-btrfs@vger.kernel.org
Cc: sensille@gmx.net, list.btrfs@jan-o-sch.net, wangsl-fnst@cn.fujitsu.com
Subject: [PATCH V3] Btrfs: kill some BUG_ONs() in the find_parent_nodes()
Date: Sat, 30 Mar 2013 07:03:21 +0800
Message-Id: <1364598201-28723-1-git-send-email-wangshilong1991@gmail.com>
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
Changelog:
	V2->V3: correct wrong check about ulist_add()
	and revert the check about ret=0
---
 fs/btrfs/backref.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/backref.c b/fs/btrfs/backref.c
index bd605c8..3dd0693 100644
--- a/fs/btrfs/backref.c
+++ b/fs/btrfs/backref.c
@@ -900,7 +900,8 @@ again:
 		if (ref->count && ref->root_id && ref->parent == 0) {
 			/* no parent == root of tree */
 			ret = ulist_add(roots, ref->root_id, 0, GFP_NOFS);
-			BUG_ON(ret < 0);
+			if (ret < 0)
+				goto out;
 		}
 		if (ref->count && ref->parent) {
 			struct extent_inode_elem *eie = NULL;
@@ -920,6 +921,8 @@ again:
 			ret = ulist_add_merge(refs, ref->parent,
 					      (uintptr_t)ref->inode_list,
 					      (u64 *)&eie, GFP_NOFS);
+			if (ret < 0)
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
1.7.11.7

