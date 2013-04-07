Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f47.google.com ([209.85.220.47]:36912 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933164Ab3DGK6o (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 7 Apr 2013 06:58:44 -0400
Received: by mail-pa0-f47.google.com with SMTP id bj3so2766835pad.34
        for <linux-btrfs@vger.kernel.org>; Sun, 07 Apr 2013 03:58:43 -0700 (PDT)
From: Wang Shilong <wangshilong1991@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: sensille@gmx.net, wangsl-fnst@cn.fujitsu.com
Subject: [PATCH] Btrfs: fix missing check about ulist_add() in qgroup.c
Date: Sun,  7 Apr 2013 18:58:14 +0800
Message-Id: <1365332294-1230-1-git-send-email-wangshilong1991@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Wang Shilong <wangsl-fnst@cn.fujitsu.com>

ulist_add() may return -ENOMEM, fix missing check about
return value.

Signed-off-by: Wang Shilong <wangsl-fnst@cn.fujitsu.com>
---
 fs/btrfs/qgroup.c | 60 +++++++++++++++++++++++++++++++++++++++----------------
 1 file changed, 43 insertions(+), 17 deletions(-)

diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index deaa2e8..f585b8a 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -1263,7 +1263,10 @@ int btrfs_qgroup_account_ref(struct btrfs_trans_handle *trans,
 
 		ulist_reinit(tmp);
 						/* XXX id not needed */
-		ulist_add(tmp, qg->qgroupid, (u64)(uintptr_t)qg, GFP_ATOMIC);
+		ret = ulist_add(tmp, qg->qgroupid,
+				(u64)(uintptr_t)qg, GFP_ATOMIC);
+		if (ret < 0)
+			goto unlock;
 		ULIST_ITER_INIT(&tmp_uiter);
 		while ((tmp_unode = ulist_next(tmp, &tmp_uiter))) {
 			struct btrfs_qgroup_list *glist;
@@ -1275,9 +1278,11 @@ int btrfs_qgroup_account_ref(struct btrfs_trans_handle *trans,
 				++qg->refcnt;
 
 			list_for_each_entry(glist, &qg->groups, next_group) {
-				ulist_add(tmp, glist->group->qgroupid,
-					  (u64)(uintptr_t)glist->group,
-					  GFP_ATOMIC);
+				ret = ulist_add(tmp, glist->group->qgroupid,
+						(u64)(uintptr_t)glist->group,
+						GFP_ATOMIC);
+				if (ret < 0)
+					goto unlock;
 			}
 		}
 	}
@@ -1286,7 +1291,10 @@ int btrfs_qgroup_account_ref(struct btrfs_trans_handle *trans,
 	 * step 2: walk from the new root
 	 */
 	ulist_reinit(tmp);
-	ulist_add(tmp, qgroup->qgroupid, (uintptr_t)qgroup, GFP_ATOMIC);
+	ret = ulist_add(tmp, qgroup->qgroupid,
+			(uintptr_t)qgroup, GFP_ATOMIC);
+	if (ret < 0)
+		goto unlock;
 	ULIST_ITER_INIT(&uiter);
 	while ((unode = ulist_next(tmp, &uiter))) {
 		struct btrfs_qgroup *qg;
@@ -1307,8 +1315,10 @@ int btrfs_qgroup_account_ref(struct btrfs_trans_handle *trans,
 		qg->tag = seq;
 
 		list_for_each_entry(glist, &qg->groups, next_group) {
-			ulist_add(tmp, glist->group->qgroupid,
-				  (uintptr_t)glist->group, GFP_ATOMIC);
+			ret = ulist_add(tmp, glist->group->qgroupid,
+					(uintptr_t)glist->group, GFP_ATOMIC);
+			if (ret < 0)
+				goto unlock;
 		}
 	}
 
@@ -1326,7 +1336,10 @@ int btrfs_qgroup_account_ref(struct btrfs_trans_handle *trans,
 			continue;
 
 		ulist_reinit(tmp);
-		ulist_add(tmp, qg->qgroupid, (uintptr_t)qg, GFP_ATOMIC);
+		ret = ulist_add(tmp, qg->qgroupid,
+				(uintptr_t)qg, GFP_ATOMIC);
+		if (ret < 0)
+			goto unlock;
 		ULIST_ITER_INIT(&tmp_uiter);
 		while ((tmp_unode = ulist_next(tmp, &tmp_uiter))) {
 			struct btrfs_qgroup_list *glist;
@@ -1342,9 +1355,11 @@ int btrfs_qgroup_account_ref(struct btrfs_trans_handle *trans,
 			}
 
 			list_for_each_entry(glist, &qg->groups, next_group) {
-				ulist_add(tmp, glist->group->qgroupid,
-					  (uintptr_t)glist->group,
-					  GFP_ATOMIC);
+				ret = ulist_add(tmp, glist->group->qgroupid,
+						(uintptr_t)glist->group,
+						GFP_ATOMIC);
+				if (ret < 0)
+					goto unlock;
 			}
 		}
 	}
@@ -1609,7 +1624,10 @@ int btrfs_qgroup_reserve(struct btrfs_root *root, u64 num_bytes)
 		ret = -ENOMEM;
 		goto out;
 	}
-	ulist_add(ulist, qgroup->qgroupid, (uintptr_t)qgroup, GFP_ATOMIC);
+	ret = ulist_add(ulist, qgroup->qgroupid,
+			(uintptr_t)qgroup, GFP_ATOMIC);
+	if (ret < 0)
+		goto out;
 	ULIST_ITER_INIT(&uiter);
 	while ((unode = ulist_next(ulist, &uiter))) {
 		struct btrfs_qgroup *qg;
@@ -1632,8 +1650,10 @@ int btrfs_qgroup_reserve(struct btrfs_root *root, u64 num_bytes)
 		}
 
 		list_for_each_entry(glist, &qg->groups, next_group) {
-			ulist_add(ulist, glist->group->qgroupid,
-				  (uintptr_t)glist->group, GFP_ATOMIC);
+			ret = ulist_add(ulist, glist->group->qgroupid,
+					(uintptr_t)glist->group, GFP_ATOMIC);
+			if (ret < 0)
+				goto out;
 		}
 	}
 
@@ -1665,6 +1685,7 @@ void btrfs_qgroup_free(struct btrfs_root *root, u64 num_bytes)
 	struct ulist_node *unode;
 	struct ulist_iterator uiter;
 	u64 ref_root = root->root_key.objectid;
+	int ret = 0;
 
 	if (!is_fstree(ref_root))
 		return;
@@ -1687,7 +1708,10 @@ void btrfs_qgroup_free(struct btrfs_root *root, u64 num_bytes)
 		btrfs_std_error(fs_info, -ENOMEM);
 		goto out;
 	}
-	ulist_add(ulist, qgroup->qgroupid, (uintptr_t)qgroup, GFP_ATOMIC);
+	ret = ulist_add(ulist, qgroup->qgroupid,
+			(uintptr_t)qgroup, GFP_ATOMIC);
+	if (ret < 0)
+		goto out;
 	ULIST_ITER_INIT(&uiter);
 	while ((unode = ulist_next(ulist, &uiter))) {
 		struct btrfs_qgroup *qg;
@@ -1698,8 +1722,10 @@ void btrfs_qgroup_free(struct btrfs_root *root, u64 num_bytes)
 		qg->reserved -= num_bytes;
 
 		list_for_each_entry(glist, &qg->groups, next_group) {
-			ulist_add(ulist, glist->group->qgroupid,
-				  (uintptr_t)glist->group, GFP_ATOMIC);
+			ret = ulist_add(ulist, glist->group->qgroupid,
+					(uintptr_t)glist->group, GFP_ATOMIC);
+			if (ret < 0)
+				goto out;
 		}
 	}
 
-- 
1.7.11.7

