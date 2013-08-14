Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:14612 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1758038Ab3HNBPX (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 13 Aug 2013 21:15:23 -0400
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id r7E1FJS8025721
	for <linux-btrfs@vger.kernel.org>; Wed, 14 Aug 2013 09:15:19 +0800
From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2 1/3] Btrfs: fix oops when writing dirty qgroups to disk
Date: Wed, 14 Aug 2013 09:13:36 +0800
Message-Id: <1376442818-7587-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When disabling quota, we should clear out list 'dirty_qgroups',otherwise,
we will get oops if enabling quota again. Fix this by abstracting similar
code from del_qgroup_rb().

Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
Reviewed-by: Miao Xie <miaox@cn.fujitsu.com>
Reviewed-by: Arne Jansen <sensille@gmx.net>
---
v1->v2: remove unnecessary initialization(thanks to Arne)
---
 fs/btrfs/qgroup.c | 41 +++++++++++++----------------------------
 1 file changed, 13 insertions(+), 28 deletions(-)

diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index 64a9e3c..57b9805 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -157,18 +157,11 @@ static struct btrfs_qgroup *add_qgroup_rb(struct btrfs_fs_info *fs_info,
 	return qgroup;
 }
 
-/* must be called with qgroup_lock held */
-static int del_qgroup_rb(struct btrfs_fs_info *fs_info, u64 qgroupid)
+static void __del_qgroup_rb(struct btrfs_qgroup *qgroup)
 {
-	struct btrfs_qgroup *qgroup = find_qgroup_rb(fs_info, qgroupid);
 	struct btrfs_qgroup_list *list;
 
-	if (!qgroup)
-		return -ENOENT;
-
-	rb_erase(&qgroup->node, &fs_info->qgroup_tree);
 	list_del(&qgroup->dirty);
-
 	while (!list_empty(&qgroup->groups)) {
 		list = list_first_entry(&qgroup->groups,
 					struct btrfs_qgroup_list, next_group);
@@ -185,7 +178,18 @@ static int del_qgroup_rb(struct btrfs_fs_info *fs_info, u64 qgroupid)
 		kfree(list);
 	}
 	kfree(qgroup);
+}
 
+/* must be called with qgroup_lock held */
+static int del_qgroup_rb(struct btrfs_fs_info *fs_info, u64 qgroupid)
+{
+	struct btrfs_qgroup *qgroup = find_qgroup_rb(fs_info, qgroupid);
+
+	if (!qgroup)
+		return -ENOENT;
+
+	rb_erase(&qgroup->node, &fs_info->qgroup_tree);
+	__del_qgroup_rb(qgroup);
 	return 0;
 }
 
@@ -435,30 +439,11 @@ void btrfs_free_qgroup_config(struct btrfs_fs_info *fs_info)
 {
 	struct rb_node *n;
 	struct btrfs_qgroup *qgroup;
-	struct btrfs_qgroup_list *list;
 
 	while ((n = rb_first(&fs_info->qgroup_tree))) {
 		qgroup = rb_entry(n, struct btrfs_qgroup, node);
 		rb_erase(n, &fs_info->qgroup_tree);
-
-		while (!list_empty(&qgroup->groups)) {
-			list = list_first_entry(&qgroup->groups,
-						struct btrfs_qgroup_list,
-						next_group);
-			list_del(&list->next_group);
-			list_del(&list->next_member);
-			kfree(list);
-		}
-
-		while (!list_empty(&qgroup->members)) {
-			list = list_first_entry(&qgroup->members,
-						struct btrfs_qgroup_list,
-						next_member);
-			list_del(&list->next_group);
-			list_del(&list->next_member);
-			kfree(list);
-		}
-		kfree(qgroup);
+		__del_qgroup_rb(qgroup);
 	}
 	/*
 	 * we call btrfs_free_qgroup_config() when umounting
-- 
1.8.0.1

