Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:27258 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754917AbbBJK1n (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 10 Feb 2015 05:27:43 -0500
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t1AAQufF000948
	for <linux-btrfs@vger.kernel.org>; Tue, 10 Feb 2015 18:26:56 +0800
From: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
Subject: [PATCH 1/7] Btrfs: qgroup: Add type to btrfs_qgroup.
Date: Tue, 10 Feb 2015 18:24:13 +0800
Message-ID: <1423563862-9151-3-git-send-email-yangds.fnst@cn.fujitsu.com>
In-Reply-To: <1423563862-9151-1-git-send-email-yangds.fnst@cn.fujitsu.com>
References: <1423563862-9151-1-git-send-email-yangds.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This patch is introducing a *type* to btrfs_qgroup.

Type could be data, metadata or both. data means this
qgroup only care about the data size, metadata means
this qgroup only care about the metadata size and both
means this qgroup will care about data and metadata like
what it was doing before this patch.

This idea comes from some complain of user that
"Why I can not write one byte in the subvolume when
the qgroup does not reach the limit?". That is caused
by the qgroup was accounting the metadata also, but it
is not confusing to a user.

So this patch here allow user to only limit the data size
in a qgroup.

Signed-off-by: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
---
 fs/btrfs/ctree.h              | 10 ++++++++-
 fs/btrfs/ioctl.c              |  3 ++-
 fs/btrfs/qgroup.c             | 47 +++++++++++++++++++++++++++++++------------
 fs/btrfs/qgroup.h             | 12 ++++++++++-
 fs/btrfs/tests/qgroup-tests.c |  4 ++--
 5 files changed, 58 insertions(+), 18 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 1d17e7a..24b0d42 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -521,6 +521,11 @@ struct btrfs_super_block {
 #define BTRFS_FEATURE_INCOMPAT_SKINNY_METADATA	(1ULL << 8)
 #define BTRFS_FEATURE_INCOMPAT_NO_HOLES		(1ULL << 9)
 
+/*
+ * Add a type in btrfs_qgroup_info_item;
+ */
+#define BTRFS_FEATURE_INCOMPAT_QGROUP_TYPE	(1ULL << 10)
+
 #define BTRFS_FEATURE_COMPAT_SUPP		0ULL
 #define BTRFS_FEATURE_COMPAT_SAFE_SET		0ULL
 #define BTRFS_FEATURE_COMPAT_SAFE_CLEAR		0ULL
@@ -537,7 +542,8 @@ struct btrfs_super_block {
 	 BTRFS_FEATURE_INCOMPAT_RAID56 |		\
 	 BTRFS_FEATURE_INCOMPAT_EXTENDED_IREF |		\
 	 BTRFS_FEATURE_INCOMPAT_SKINNY_METADATA |	\
-	 BTRFS_FEATURE_INCOMPAT_NO_HOLES)
+	 BTRFS_FEATURE_INCOMPAT_NO_HOLES |		\
+	 BTRFS_FEATURE_INCOMPAT_QGROUP_TYPE)
 
 #define BTRFS_FEATURE_INCOMPAT_SAFE_SET			\
 	(BTRFS_FEATURE_INCOMPAT_EXTENDED_IREF)
@@ -1101,6 +1107,7 @@ struct btrfs_qgroup_info_item {
 	__le64 rfer_cmpr;
 	__le64 excl;
 	__le64 excl_cmpr;
+	__u8 type;
 } __attribute__ ((__packed__));
 
 /* flags definition for qgroup limits */
@@ -3214,6 +3221,7 @@ BTRFS_SETGET_FUNCS(qgroup_status_rescan, struct btrfs_qgroup_status_item,
 /* btrfs_qgroup_info_item */
 BTRFS_SETGET_FUNCS(qgroup_info_generation, struct btrfs_qgroup_info_item,
 		   generation, 64);
+BTRFS_SETGET_FUNCS(qgroup_info_type, struct btrfs_qgroup_info_item, type, 8);
 BTRFS_SETGET_FUNCS(qgroup_info_rfer, struct btrfs_qgroup_info_item, rfer, 64);
 BTRFS_SETGET_FUNCS(qgroup_info_rfer_cmpr, struct btrfs_qgroup_info_item,
 		   rfer_cmpr, 64);
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index f6e730b..a50f295 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -4675,7 +4675,8 @@ static long btrfs_ioctl_qgroup_create(struct file *file, void __user *arg)
 
 	/* FIXME: check if the IDs really exist */
 	if (sa->create) {
-		ret = btrfs_create_qgroup(trans, root->fs_info, sa->qgroupid);
+		ret = btrfs_create_qgroup(trans, root->fs_info, sa->qgroupid,
+					  BTRFS_QGROUP_TYPE_DEFAULT);
 	} else {
 		ret = btrfs_remove_qgroup(trans, root->fs_info, sa->qgroupid);
 	}
diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index 28b0aa5..8ac785a 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -51,6 +51,7 @@
  */
 struct btrfs_qgroup {
 	u64 qgroupid;
+	u8 type;
 
 	/*
 	 * state
@@ -128,7 +129,7 @@ static struct btrfs_qgroup *find_qgroup_rb(struct btrfs_fs_info *fs_info,
 
 /* must be called with qgroup_lock held */
 static struct btrfs_qgroup *add_qgroup_rb(struct btrfs_fs_info *fs_info,
-					  u64 qgroupid)
+					  u64 qgroupid, u8 type)
 {
 	struct rb_node **p = &fs_info->qgroup_tree.rb_node;
 	struct rb_node *parent = NULL;
@@ -151,6 +152,7 @@ static struct btrfs_qgroup *add_qgroup_rb(struct btrfs_fs_info *fs_info,
 		return ERR_PTR(-ENOMEM);
 
 	qgroup->qgroupid = qgroupid;
+	qgroup->type = type;
 	INIT_LIST_HEAD(&qgroup->groups);
 	INIT_LIST_HEAD(&qgroup->members);
 	INIT_LIST_HEAD(&qgroup->dirty);
@@ -348,7 +350,8 @@ int btrfs_read_qgroup_config(struct btrfs_fs_info *fs_info)
 			flags |= BTRFS_QGROUP_STATUS_FLAG_INCONSISTENT;
 		}
 		if (!qgroup) {
-			qgroup = add_qgroup_rb(fs_info, found_key.offset);
+			qgroup = add_qgroup_rb(fs_info, found_key.offset,
+					       BTRFS_QGROUP_TYPE_DEFAULT);
 			if (IS_ERR(qgroup)) {
 				ret = PTR_ERR(qgroup);
 				goto out;
@@ -360,6 +363,8 @@ int btrfs_read_qgroup_config(struct btrfs_fs_info *fs_info)
 
 			ptr = btrfs_item_ptr(l, slot,
 					     struct btrfs_qgroup_info_item);
+			if (btrfs_fs_incompat(fs_info, QGROUP_TYPE))
+				qgroup->type = btrfs_qgroup_info_type(l, ptr);
 			qgroup->rfer = btrfs_qgroup_info_rfer(l, ptr);
 			qgroup->rfer_cmpr = btrfs_qgroup_info_rfer_cmpr(l, ptr);
 			qgroup->excl = btrfs_qgroup_info_excl(l, ptr);
@@ -530,7 +535,8 @@ out:
 }
 
 static int add_qgroup_item(struct btrfs_trans_handle *trans,
-			   struct btrfs_root *quota_root, u64 qgroupid)
+			   struct btrfs_root *quota_root, u64 qgroupid,
+			   u8 type)
 {
 	int ret;
 	struct btrfs_path *path;
@@ -538,6 +544,7 @@ static int add_qgroup_item(struct btrfs_trans_handle *trans,
 	struct btrfs_qgroup_limit_item *qgroup_limit;
 	struct extent_buffer *leaf;
 	struct btrfs_key key;
+	unsigned long size_of_info = 0;
 
 	if (btrfs_test_is_dummy_root(quota_root))
 		return 0;
@@ -556,8 +563,12 @@ static int add_qgroup_item(struct btrfs_trans_handle *trans,
 	 * on disk.
 	 */
 
+	size_of_info = sizeof(*qgroup_info);
+	if (!btrfs_fs_incompat(quota_root->fs_info, QGROUP_TYPE))
+		size_of_info = size_of_info - sizeof(u8);
+
 	ret = btrfs_insert_empty_item(trans, quota_root, path, &key,
-				      sizeof(*qgroup_info));
+				      size_of_info);
 	if (ret && ret != -EEXIST)
 		goto out;
 
@@ -565,6 +576,8 @@ static int add_qgroup_item(struct btrfs_trans_handle *trans,
 	qgroup_info = btrfs_item_ptr(leaf, path->slots[0],
 				 struct btrfs_qgroup_info_item);
 	btrfs_set_qgroup_info_generation(leaf, qgroup_info, trans->transid);
+	if (btrfs_fs_incompat(quota_root->fs_info, QGROUP_TYPE))
+		btrfs_set_qgroup_info_type(leaf, qgroup_info, type);
 	btrfs_set_qgroup_info_rfer(leaf, qgroup_info, 0);
 	btrfs_set_qgroup_info_rfer_cmpr(leaf, qgroup_info, 0);
 	btrfs_set_qgroup_info_excl(leaf, qgroup_info, 0);
@@ -722,6 +735,8 @@ static int update_qgroup_info_item(struct btrfs_trans_handle *trans,
 	btrfs_set_qgroup_info_rfer_cmpr(l, qgroup_info, qgroup->rfer_cmpr);
 	btrfs_set_qgroup_info_excl(l, qgroup_info, qgroup->excl);
 	btrfs_set_qgroup_info_excl_cmpr(l, qgroup_info, qgroup->excl_cmpr);
+	if (btrfs_fs_incompat(root->fs_info, QGROUP_TYPE))
+		btrfs_set_qgroup_info_type(l, qgroup_info, qgroup->type);
 
 	btrfs_mark_buffer_dirty(l);
 
@@ -902,11 +917,13 @@ int btrfs_quota_enable(struct btrfs_trans_handle *trans,
 
 		if (found_key.type == BTRFS_ROOT_REF_KEY) {
 			ret = add_qgroup_item(trans, quota_root,
-					      found_key.offset);
+					      found_key.offset,
+					      BTRFS_QGROUP_TYPE_DEFAULT);
 			if (ret)
 				goto out_free_path;
 
-			qgroup = add_qgroup_rb(fs_info, found_key.offset);
+			qgroup = add_qgroup_rb(fs_info, found_key.offset,
+					       BTRFS_QGROUP_TYPE_DEFAULT);
 			if (IS_ERR(qgroup)) {
 				ret = PTR_ERR(qgroup);
 				goto out_free_path;
@@ -921,11 +938,13 @@ int btrfs_quota_enable(struct btrfs_trans_handle *trans,
 
 out_add_root:
 	btrfs_release_path(path);
-	ret = add_qgroup_item(trans, quota_root, BTRFS_FS_TREE_OBJECTID);
+	ret = add_qgroup_item(trans, quota_root, BTRFS_FS_TREE_OBJECTID,
+			      BTRFS_QGROUP_TYPE_DEFAULT);
 	if (ret)
 		goto out_free_path;
 
-	qgroup = add_qgroup_rb(fs_info, BTRFS_FS_TREE_OBJECTID);
+	qgroup = add_qgroup_rb(fs_info, BTRFS_FS_TREE_OBJECTID,
+			       BTRFS_QGROUP_TYPE_DEFAULT);
 	if (IS_ERR(qgroup)) {
 		ret = PTR_ERR(qgroup);
 		goto out_free_path;
@@ -1118,7 +1137,8 @@ int btrfs_del_qgroup_relation(struct btrfs_trans_handle *trans,
 }
 
 int btrfs_create_qgroup(struct btrfs_trans_handle *trans,
-			struct btrfs_fs_info *fs_info, u64 qgroupid)
+			struct btrfs_fs_info *fs_info, u64 qgroupid,
+			u8 type)
 {
 	struct btrfs_root *quota_root;
 	struct btrfs_qgroup *qgroup;
@@ -1136,12 +1156,12 @@ int btrfs_create_qgroup(struct btrfs_trans_handle *trans,
 		goto out;
 	}
 
-	ret = add_qgroup_item(trans, quota_root, qgroupid);
+	ret = add_qgroup_item(trans, quota_root, qgroupid, type);
 	if (ret)
 		goto out;
 
 	spin_lock(&fs_info->qgroup_lock);
-	qgroup = add_qgroup_rb(fs_info, qgroupid);
+	qgroup = add_qgroup_rb(fs_info, qgroupid, type);
 	spin_unlock(&fs_info->qgroup_lock);
 
 	if (IS_ERR(qgroup))
@@ -2276,7 +2296,7 @@ int btrfs_qgroup_inherit(struct btrfs_trans_handle *trans,
 	/*
 	 * create a tracking group for the subvol itself
 	 */
-	ret = add_qgroup_item(trans, quota_root, objectid);
+	ret = add_qgroup_item(trans, quota_root, objectid, BTRFS_QGROUP_TYPE_DEFAULT);
 	if (ret)
 		goto out;
 
@@ -2319,7 +2339,7 @@ int btrfs_qgroup_inherit(struct btrfs_trans_handle *trans,
 
 	spin_lock(&fs_info->qgroup_lock);
 
-	dstgroup = add_qgroup_rb(fs_info, objectid);
+	dstgroup = add_qgroup_rb(fs_info, objectid, BTRFS_QGROUP_TYPE_DEFAULT);
 	if (IS_ERR(dstgroup)) {
 		ret = PTR_ERR(dstgroup);
 		goto unlock;
@@ -2351,6 +2371,7 @@ int btrfs_qgroup_inherit(struct btrfs_trans_handle *trans,
 		 * our counts don't go crazy, so at this point the only
 		 * difference between the two roots should be the root node.
 		 */
+		dstgroup->type = srcgroup->type;
 		dstgroup->rfer = srcgroup->rfer;
 		dstgroup->rfer_cmpr = srcgroup->rfer_cmpr;
 		dstgroup->excl = level_size;
diff --git a/fs/btrfs/qgroup.h b/fs/btrfs/qgroup.h
index 52d8b19..7bd3a90 100644
--- a/fs/btrfs/qgroup.h
+++ b/fs/btrfs/qgroup.h
@@ -20,6 +20,16 @@
 #define __BTRFS_QGROUP__
 
 /*
+ * Type for qgroup.
+ */
+#define BTRFS_QGROUP_TYPE_DATA		(1 << 0)
+#define BTRFS_QGROUP_TYPE_METADATA	(1 << 1)
+#define BTRFS_QGROUP_TYPE_MIXED		(BTRFS_QGROUP_TYPE_DATA | \
+					 BTRFS_QGROUP_TYPE_METADATA)
+
+#define BTRFS_QGROUP_TYPE_DEFAULT	BTRFS_QGROUP_TYPE_MIXED
+
+/*
  * A description of the operations, all of these operations only happen when we
  * are adding the 1st reference for that subvolume in the case of adding space
  * or on the last reference delete in the case of subtraction.  The only
@@ -73,7 +83,7 @@ int btrfs_add_qgroup_relation(struct btrfs_trans_handle *trans,
 int btrfs_del_qgroup_relation(struct btrfs_trans_handle *trans,
 			      struct btrfs_fs_info *fs_info, u64 src, u64 dst);
 int btrfs_create_qgroup(struct btrfs_trans_handle *trans,
-			struct btrfs_fs_info *fs_info, u64 qgroupid);
+			struct btrfs_fs_info *fs_info, u64 qgroupid, u8 type);
 int btrfs_remove_qgroup(struct btrfs_trans_handle *trans,
 			      struct btrfs_fs_info *fs_info, u64 qgroupid);
 int btrfs_limit_qgroup(struct btrfs_trans_handle *trans,
diff --git a/fs/btrfs/tests/qgroup-tests.c b/fs/btrfs/tests/qgroup-tests.c
index bcc1c7a..4ae3b5d 100644
--- a/fs/btrfs/tests/qgroup-tests.c
+++ b/fs/btrfs/tests/qgroup-tests.c
@@ -232,7 +232,7 @@ static int test_no_shared_qgroup(struct btrfs_root *root)
 	init_dummy_trans(&trans);
 
 	test_msg("Qgroup basic add\n");
-	ret = btrfs_create_qgroup(NULL, fs_info, 5);
+	ret = btrfs_create_qgroup(NULL, fs_info, 5, BTRFS_QGROUP_TYPE_DEFAULT);
 	if (ret) {
 		test_msg("Couldn't create a qgroup %d\n", ret);
 		return ret;
@@ -301,7 +301,7 @@ static int test_multiple_refs(struct btrfs_root *root)
 	test_msg("Qgroup multiple refs test\n");
 
 	/* We have 5 created already from the previous test */
-	ret = btrfs_create_qgroup(NULL, fs_info, 256);
+	ret = btrfs_create_qgroup(NULL, fs_info, 256, BTRFS_QGROUP_TYPE_DEFAULT);
 	if (ret) {
 		test_msg("Couldn't create a qgroup %d\n", ret);
 		return ret;
-- 
1.8.4.2

