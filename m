Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:56111 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753787Ab3EFK6Y (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 6 May 2013 06:58:24 -0400
Message-ID: <51878DFF.5070008@cn.fujitsu.com>
Date: Mon, 06 May 2013 19:03:27 +0800
From: Wang Shilong <wangsl-fnst@cn.fujitsu.com>
MIME-Version: 1.0
To: Linux Btrfs <linux-btrfs@vger.kernel.org>
CC: Jan Schmidt <list.btrfs@jan-o-sch.net>, Arne Jansen <sensille@gmx.net>
Subject: [PATCH] Btrfs: introduce qgroup_ulist to avoid frequently allocating/freeing
 ulist
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When doing qgroup accounting, we call ulist_alloc()/ulist_free() every time
when we want to walk qgroup tree.

By introducing 'qgroup_ulist', we only need to call ulist_alloc()/ulist_free()
once. This reduce some sys time to allocate memory, see the measurements below

fsstress -p 4 -n 10000 -d $dir

With this patch:

real    0m50.153s
user    0m0.081s
sys     0m6.294s

real    0m51.113s
user    0m0.092s
sys     0m6.220s

real    0m52.610s
user    0m0.096s
sys     0m6.125s	avg 6.213
-----------------------------------------------------
Without the patch:

real    0m54.825s
user    0m0.061s
sys     0m10.665s

real    1m6.401s
user    0m0.089s
sys     0m11.218s

real    1m13.768s
user    0m0.087s
sys     0m10.665s       avg 10.849

we can see the sys time reduce ~43%.

Signed-off-by: Wang Shilong <wangsl-fnst@cn.fujitsu.com>
---
 fs/btrfs/ctree.h   |    6 ++++
 fs/btrfs/disk-io.c |    1 +
 fs/btrfs/qgroup.c  |   70 ++++++++++++++++++++++++++-------------------------
 3 files changed, 43 insertions(+), 34 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 63c328a..3ccb829 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -1594,6 +1594,12 @@ struct btrfs_fs_info {
 	struct rb_root qgroup_tree;
 	spinlock_t qgroup_lock;
 
+	/*
+	 * used to avoid frequently calling ulist_alloc()/ulist_free()
+	 * when doing qgroup accounting, it must be protected by qgroup_lock.
+	 */
+	struct ulist *qgroup_ulist;
+
 	/* protect user change for quota operations */
 	struct mutex qgroup_ioctl_lock;
 
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 2223494..ee8ce33 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -2267,6 +2267,7 @@ int open_ctree(struct super_block *sb,
 	fs_info->qgroup_seq = 1;
 	fs_info->quota_enabled = 0;
 	fs_info->pending_quota_state = 0;
+	fs_info->qgroup_ulist = NULL;
 	mutex_init(&fs_info->qgroup_rescan_lock);
 
 	btrfs_init_free_cluster(&fs_info->meta_alloc_cluster);
diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index 9d49c58..7f38cce 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -259,6 +259,12 @@ int btrfs_read_qgroup_config(struct btrfs_fs_info *fs_info)
 	if (!fs_info->quota_enabled)
 		return 0;
 
+	fs_info->qgroup_ulist = ulist_alloc(GFP_NOFS);
+	if (!fs_info->qgroup_ulist) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
 	path = btrfs_alloc_path();
 	if (!path) {
 		ret = -ENOMEM;
@@ -424,6 +430,9 @@ out:
 	}
 	btrfs_free_path(path);
 
+	if (ret)
+		ulist_free(fs_info->qgroup_ulist);
+
 	return ret < 0 ? ret : 0;
 }
 
@@ -460,6 +469,7 @@ void btrfs_free_qgroup_config(struct btrfs_fs_info *fs_info)
 		}
 		kfree(qgroup);
 	}
+	ulist_free(fs_info->qgroup_ulist);
 }
 
 static int add_qgroup_relation_item(struct btrfs_trans_handle *trans,
@@ -819,6 +829,12 @@ int btrfs_quota_enable(struct btrfs_trans_handle *trans,
 		goto out;
 	}
 
+	fs_info->qgroup_ulist = ulist_alloc(GFP_NOFS);
+	if (!fs_info->qgroup_ulist) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
 	/*
 	 * initially create the quota tree
 	 */
@@ -916,6 +932,8 @@ out_free_root:
 		kfree(quota_root);
 	}
 out:
+	if (ret)
+		ulist_free(fs_info->qgroup_ulist);
 	mutex_unlock(&fs_info->qgroup_ioctl_lock);
 	return ret;
 }
@@ -1355,7 +1373,6 @@ int btrfs_qgroup_account_ref(struct btrfs_trans_handle *trans,
 	u64 ref_root;
 	struct btrfs_qgroup *qgroup;
 	struct ulist *roots = NULL;
-	struct ulist *tmp = NULL;
 	u64 seq;
 	int ret = 0;
 	int sgn;
@@ -1448,31 +1465,28 @@ int btrfs_qgroup_account_ref(struct btrfs_trans_handle *trans,
 	/*
 	 * step 1: for each old ref, visit all nodes once and inc refcnt
 	 */
-	tmp = ulist_alloc(GFP_ATOMIC);
-	if (!tmp) {
-		ret = -ENOMEM;
-		goto unlock;
-	}
+	ulist_reinit(fs_info->qgroup_ulist);
 	seq = fs_info->qgroup_seq;
 	fs_info->qgroup_seq += roots->nnodes + 1; /* max refcnt */
 
-	ret = qgroup_account_ref_step1(fs_info, roots, tmp, seq);
+	ret = qgroup_account_ref_step1(fs_info, roots, fs_info->qgroup_ulist,
+				       seq);
 	if (ret)
 		goto unlock;
 
 	/*
 	 * step 2: walk from the new root
 	 */
-	ret = qgroup_account_ref_step2(fs_info, roots, tmp, seq, sgn,
-				       node->num_bytes, qgroup);
+	ret = qgroup_account_ref_step2(fs_info, roots, fs_info->qgroup_ulist,
+				       seq, sgn, node->num_bytes, qgroup);
 	if (ret)
 		goto unlock;
 
 	/*
 	 * step 3: walk again from old refs
 	 */
-	ret = qgroup_account_ref_step3(fs_info, roots, tmp, seq, sgn,
-				       node->num_bytes);
+	ret = qgroup_account_ref_step3(fs_info, roots, fs_info->qgroup_ulist,
+				       seq, sgn, node->num_bytes);
 	if (ret)
 		goto unlock;
 
@@ -1480,7 +1494,6 @@ unlock:
 	spin_unlock(&fs_info->qgroup_lock);
 	mutex_unlock(&fs_info->qgroup_rescan_lock);
 	ulist_free(roots);
-	ulist_free(tmp);
 
 	return ret;
 }
@@ -1720,7 +1733,6 @@ int btrfs_qgroup_reserve(struct btrfs_root *root, u64 num_bytes)
 	struct btrfs_fs_info *fs_info = root->fs_info;
 	u64 ref_root = root->root_key.objectid;
 	int ret = 0;
-	struct ulist *ulist = NULL;
 	struct ulist_node *unode;
 	struct ulist_iterator uiter;
 
@@ -1743,17 +1755,13 @@ int btrfs_qgroup_reserve(struct btrfs_root *root, u64 num_bytes)
 	 * in a first step, we check all affected qgroups if any limits would
 	 * be exceeded
 	 */
-	ulist = ulist_alloc(GFP_ATOMIC);
-	if (!ulist) {
-		ret = -ENOMEM;
-		goto out;
-	}
-	ret = ulist_add(ulist, qgroup->qgroupid,
+	ulist_reinit(fs_info->qgroup_ulist);
+	ret = ulist_add(fs_info->qgroup_ulist, qgroup->qgroupid,
 			(uintptr_t)qgroup, GFP_ATOMIC);
 	if (ret < 0)
 		goto out;
 	ULIST_ITER_INIT(&uiter);
-	while ((unode = ulist_next(ulist, &uiter))) {
+	while ((unode = ulist_next(fs_info->qgroup_ulist, &uiter))) {
 		struct btrfs_qgroup *qg;
 		struct btrfs_qgroup_list *glist;
 
@@ -1774,7 +1782,8 @@ int btrfs_qgroup_reserve(struct btrfs_root *root, u64 num_bytes)
 		}
 
 		list_for_each_entry(glist, &qg->groups, next_group) {
-			ret = ulist_add(ulist, glist->group->qgroupid,
+			ret = ulist_add(fs_info->qgroup_ulist,
+					glist->group->qgroupid,
 					(uintptr_t)glist->group, GFP_ATOMIC);
 			if (ret < 0)
 				goto out;
@@ -1785,7 +1794,7 @@ int btrfs_qgroup_reserve(struct btrfs_root *root, u64 num_bytes)
 	 * no limits exceeded, now record the reservation into all qgroups
 	 */
 	ULIST_ITER_INIT(&uiter);
-	while ((unode = ulist_next(ulist, &uiter))) {
+	while ((unode = ulist_next(fs_info->qgroup_ulist, &uiter))) {
 		struct btrfs_qgroup *qg;
 
 		qg = (struct btrfs_qgroup *)(uintptr_t)unode->aux;
@@ -1795,8 +1804,6 @@ int btrfs_qgroup_reserve(struct btrfs_root *root, u64 num_bytes)
 
 out:
 	spin_unlock(&fs_info->qgroup_lock);
-	ulist_free(ulist);
-
 	return ret;
 }
 
@@ -1805,7 +1812,6 @@ void btrfs_qgroup_free(struct btrfs_root *root, u64 num_bytes)
 	struct btrfs_root *quota_root;
 	struct btrfs_qgroup *qgroup;
 	struct btrfs_fs_info *fs_info = root->fs_info;
-	struct ulist *ulist = NULL;
 	struct ulist_node *unode;
 	struct ulist_iterator uiter;
 	u64 ref_root = root->root_key.objectid;
@@ -1827,17 +1833,13 @@ void btrfs_qgroup_free(struct btrfs_root *root, u64 num_bytes)
 	if (!qgroup)
 		goto out;
 
-	ulist = ulist_alloc(GFP_ATOMIC);
-	if (!ulist) {
-		btrfs_std_error(fs_info, -ENOMEM);
-		goto out;
-	}
-	ret = ulist_add(ulist, qgroup->qgroupid,
+	ulist_reinit(fs_info->qgroup_ulist);
+	ret = ulist_add(fs_info->qgroup_ulist, qgroup->qgroupid,
 			(uintptr_t)qgroup, GFP_ATOMIC);
 	if (ret < 0)
 		goto out;
 	ULIST_ITER_INIT(&uiter);
-	while ((unode = ulist_next(ulist, &uiter))) {
+	while ((unode = ulist_next(fs_info->qgroup_ulist, &uiter))) {
 		struct btrfs_qgroup *qg;
 		struct btrfs_qgroup_list *glist;
 
@@ -1846,7 +1848,8 @@ void btrfs_qgroup_free(struct btrfs_root *root, u64 num_bytes)
 		qg->reserved -= num_bytes;
 
 		list_for_each_entry(glist, &qg->groups, next_group) {
-			ret = ulist_add(ulist, glist->group->qgroupid,
+			ret = ulist_add(fs_info->qgroup_ulist,
+					glist->group->qgroupid,
 					(uintptr_t)glist->group, GFP_ATOMIC);
 			if (ret < 0)
 				goto out;
@@ -1855,7 +1858,6 @@ void btrfs_qgroup_free(struct btrfs_root *root, u64 num_bytes)
 
 out:
 	spin_unlock(&fs_info->qgroup_lock);
-	ulist_free(ulist);
 }
 
 void assert_qgroups_uptodate(struct btrfs_trans_handle *trans)
-- 
1.7.7.6





