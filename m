Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pb0-f52.google.com ([209.85.160.52]:51824 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757462Ab3CFLvw (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 6 Mar 2013 06:51:52 -0500
Received: by mail-pb0-f52.google.com with SMTP id ma3so5921176pbc.39
        for <linux-btrfs@vger.kernel.org>; Wed, 06 Mar 2013 03:51:52 -0800 (PST)
From: Wang Shilong <wangshilong1991@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: sensille@gmx.net, wangshilong1991@gmail.com
Subject: [PATCH] Btrfs: return as soon as possible when edquot happens
Date: Wed,  6 Mar 2013 19:51:47 +0800
Message-Id: <1362570707-1995-1-git-send-email-wangshilong1991@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Wang Shilong <wangsl-fnst@cn.fujitsu.com>

If one of qgroup fails to reserve firstly, we should return immediately,
it is unnecessary to continue check.

Signed-off-by: Wang Shilong <wangsl-fnst@cn.fujitsu.com>
---
 fs/btrfs/qgroup.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index aee4b1c..5471e47 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -1525,21 +1525,23 @@ int btrfs_qgroup_reserve(struct btrfs_root *root, u64 num_bytes)
 
 		if ((qg->lim_flags & BTRFS_QGROUP_LIMIT_MAX_RFER) &&
 		    qg->reserved + qg->rfer + num_bytes >
-		    qg->max_rfer)
+		    qg->max_rfer) {
 			ret = -EDQUOT;
+			goto out;
+		}
 
 		if ((qg->lim_flags & BTRFS_QGROUP_LIMIT_MAX_EXCL) &&
 		    qg->reserved + qg->excl + num_bytes >
-		    qg->max_excl)
+		    qg->max_excl) {
 			ret = -EDQUOT;
+			goto out;
+		}
 
 		list_for_each_entry(glist, &qg->groups, next_group) {
 			ulist_add(ulist, glist->group->qgroupid,
 				  (uintptr_t)glist->group, GFP_ATOMIC);
 		}
 	}
-	if (ret)
-		goto out;
 
 	/*
 	 * no limits exceeded, now record the reservation into all qgroups
-- 
1.7.11.7

