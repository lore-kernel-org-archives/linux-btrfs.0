Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:9828 "EHLO
	mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757897AbcFALUW (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 1 Jun 2016 07:20:22 -0400
Received: from pps.filterd (m0075771.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.16.0.11/8.16.0.11) with SMTP id u51BJXqp004150
	for <linux-btrfs@vger.kernel.org>; Wed, 1 Jun 2016 07:20:22 -0400
Message-Id: <201606011120.u51BJXqp004150@mx0a-001b2d01.pphosted.com>
Received: from e23smtp07.au.ibm.com (e23smtp07.au.ibm.com [202.81.31.140])
	by mx0a-001b2d01.pphosted.com with ESMTP id 239svy936t-1
	(version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
	for <linux-btrfs@vger.kernel.org>; Wed, 01 Jun 2016 07:20:21 -0400
Received: from localhost
	by e23smtp07.au.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <xufeifei@linux.vnet.ibm.com>;
	Wed, 1 Jun 2016 21:20:19 +1000
Received: from d23relay07.au.ibm.com (d23relay07.au.ibm.com [9.190.26.37])
	by d23dlp02.au.ibm.com (Postfix) with ESMTP id C206C2BB0060
	for <linux-btrfs@vger.kernel.org>; Wed,  1 Jun 2016 21:20:16 +1000 (EST)
Received: from d23av06.au.ibm.com (d23av06.au.ibm.com [9.190.235.151])
	by d23relay07.au.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id u51BK6RH18677884
	for <linux-btrfs@vger.kernel.org>; Wed, 1 Jun 2016 21:20:16 +1000
Received: from d23av06.au.ibm.com (localhost [127.0.0.1])
	by d23av06.au.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id u51BJeeA018179
	for <linux-btrfs@vger.kernel.org>; Wed, 1 Jun 2016 21:19:41 +1000
From: Feifei Xu <xufeifei@linux.vnet.ibm.com>
To: linux-btrfs@vger.kernel.org
Cc: steve.capper@linaro.org, chandan@mykolab.com, jbacik@fb.com,
        dsterba@suse.com, chandan@linux.vnet.ibm.com, feifeixu.sh@gmail.com,
        Feifei Xu <xufeifei@linux.vnet.ibm.com>
Subject: [PATCH V2 6/8] Btrfs: self-tests: Use macros instead of constants and add missing newline
Date: Wed,  1 Jun 2016 19:18:28 +0800
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
In-Reply-To: <201606011120.u51BJXQB005621@mx0a-001b2d01.pphosted.com>

This commit replaces numerical constants with appropriate
preprocessor macros.

Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
Signed-off-by: Feifei Xu <xufeifei@linux.vnet.ibm.com>
---
 fs/btrfs/disk-io.c                   |  3 ++-
 fs/btrfs/tests/extent-buffer-tests.c |  2 +-
 fs/btrfs/tests/qgroup-tests.c        | 44 +++++++++++++++++++++++-------------
 3 files changed, 31 insertions(+), 18 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 06ef433..c3764dd 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1323,7 +1323,8 @@ struct btrfs_root *btrfs_alloc_dummy_root(u32 sectorsize, u32 nodesize)
 	if (!root)
 		return ERR_PTR(-ENOMEM);
 	/* We don't use the stripesize in selftest, set it as sectorsize */
-	__setup_root(nodesize, sectorsize, sectorsize, root, NULL, 1);
+	__setup_root(nodesize, sectorsize, sectorsize, root, NULL,
+			BTRFS_ROOT_TREE_OBJECTID);
 	set_bit(BTRFS_ROOT_DUMMY_ROOT, &root->state);
 	root->alloc_bytenr = 0;
 
diff --git a/fs/btrfs/tests/extent-buffer-tests.c b/fs/btrfs/tests/extent-buffer-tests.c
index 17b110f..4f8cbd1 100644
--- a/fs/btrfs/tests/extent-buffer-tests.c
+++ b/fs/btrfs/tests/extent-buffer-tests.c
@@ -225,6 +225,6 @@ out:
 
 int btrfs_test_extent_buffer_operations(u32 sectorsize, u32 nodesize)
 {
-	test_msg("Running extent buffer operation tests");
+	test_msg("Running extent buffer operation tests\n");
 	return test_btrfs_split_item(sectorsize, nodesize);
 }
diff --git a/fs/btrfs/tests/qgroup-tests.c b/fs/btrfs/tests/qgroup-tests.c
index 9c1d273..57a12c0 100644
--- a/fs/btrfs/tests/qgroup-tests.c
+++ b/fs/btrfs/tests/qgroup-tests.c
@@ -229,7 +229,7 @@ static int test_no_shared_qgroup(struct btrfs_root *root,
 	btrfs_init_dummy_trans(&trans);
 
 	test_msg("Qgroup basic add\n");
-	ret = btrfs_create_qgroup(NULL, fs_info, 5);
+	ret = btrfs_create_qgroup(NULL, fs_info, BTRFS_FS_TREE_OBJECTID);
 	if (ret) {
 		test_msg("Couldn't create a qgroup %d\n", ret);
 		return ret;
@@ -247,7 +247,8 @@ static int test_no_shared_qgroup(struct btrfs_root *root,
 		return ret;
 	}
 
-	ret = insert_normal_tree_ref(root, nodesize, nodesize, 0, 5);
+	ret = insert_normal_tree_ref(root, nodesize, nodesize, 0,
+				BTRFS_FS_TREE_OBJECTID);
 	if (ret)
 		return ret;
 
@@ -266,7 +267,8 @@ static int test_no_shared_qgroup(struct btrfs_root *root,
 		return ret;
 	}
 
-	if (btrfs_verify_qgroup_counts(fs_info, 5, nodesize, nodesize)) {
+	if (btrfs_verify_qgroup_counts(fs_info, BTRFS_FS_TREE_OBJECTID,
+				nodesize, nodesize)) {
 		test_msg("Qgroup counts didn't match expected values\n");
 		return -EINVAL;
 	}
@@ -299,7 +301,7 @@ static int test_no_shared_qgroup(struct btrfs_root *root,
 		return -EINVAL;
 	}
 
-	if (btrfs_verify_qgroup_counts(fs_info, 5, 0, 0)) {
+	if (btrfs_verify_qgroup_counts(fs_info, BTRFS_FS_TREE_OBJECTID, 0, 0)) {
 		test_msg("Qgroup counts didn't match expected values\n");
 		return -EINVAL;
 	}
@@ -325,8 +327,11 @@ static int test_multiple_refs(struct btrfs_root *root,
 
 	test_msg("Qgroup multiple refs test\n");
 
-	/* We have 5 created already from the previous test */
-	ret = btrfs_create_qgroup(NULL, fs_info, 256);
+	/*
+	 * We have BTRFS_FS_TREE_OBJECTID created already from the
+	 * previous test.
+	 */
+	ret = btrfs_create_qgroup(NULL, fs_info, BTRFS_FIRST_FREE_OBJECTID);
 	if (ret) {
 		test_msg("Couldn't create a qgroup %d\n", ret);
 		return ret;
@@ -339,7 +344,8 @@ static int test_multiple_refs(struct btrfs_root *root,
 		return ret;
 	}
 
-	ret = insert_normal_tree_ref(root, nodesize, nodesize, 0, 5);
+	ret = insert_normal_tree_ref(root, nodesize, nodesize, 0,
+				BTRFS_FS_TREE_OBJECTID);
 	if (ret)
 		return ret;
 
@@ -358,7 +364,7 @@ static int test_multiple_refs(struct btrfs_root *root,
 		return ret;
 	}
 
-	if (btrfs_verify_qgroup_counts(fs_info, 5,
+	if (btrfs_verify_qgroup_counts(fs_info, BTRFS_FS_TREE_OBJECTID,
 				       nodesize, nodesize)) {
 		test_msg("Qgroup counts didn't match expected values\n");
 		return -EINVAL;
@@ -371,7 +377,8 @@ static int test_multiple_refs(struct btrfs_root *root,
 		return ret;
 	}
 
-	ret = add_tree_ref(root, nodesize, nodesize, 0, 256);
+	ret = add_tree_ref(root, nodesize, nodesize, 0,
+			BTRFS_FIRST_FREE_OBJECTID);
 	if (ret)
 		return ret;
 
@@ -390,12 +397,14 @@ static int test_multiple_refs(struct btrfs_root *root,
 		return ret;
 	}
 
-	if (btrfs_verify_qgroup_counts(fs_info, 5, nodesize, 0)) {
+	if (btrfs_verify_qgroup_counts(fs_info, BTRFS_FS_TREE_OBJECTID,
+					nodesize, 0)) {
 		test_msg("Qgroup counts didn't match expected values\n");
 		return -EINVAL;
 	}
 
-	if (btrfs_verify_qgroup_counts(fs_info, 256, nodesize, 0)) {
+	if (btrfs_verify_qgroup_counts(fs_info, BTRFS_FIRST_FREE_OBJECTID,
+					nodesize, 0)) {
 		test_msg("Qgroup counts didn't match expected values\n");
 		return -EINVAL;
 	}
@@ -407,7 +416,8 @@ static int test_multiple_refs(struct btrfs_root *root,
 		return ret;
 	}
 
-	ret = remove_extent_ref(root, nodesize, nodesize, 0, 256);
+	ret = remove_extent_ref(root, nodesize, nodesize, 0,
+				BTRFS_FIRST_FREE_OBJECTID);
 	if (ret)
 		return ret;
 
@@ -426,12 +436,14 @@ static int test_multiple_refs(struct btrfs_root *root,
 		return ret;
 	}
 
-	if (btrfs_verify_qgroup_counts(fs_info, 256, 0, 0)) {
+	if (btrfs_verify_qgroup_counts(fs_info, BTRFS_FIRST_FREE_OBJECTID,
+					0, 0)) {
 		test_msg("Qgroup counts didn't match expected values\n");
 		return -EINVAL;
 	}
 
-	if (btrfs_verify_qgroup_counts(fs_info, 5, nodesize, nodesize)) {
+	if (btrfs_verify_qgroup_counts(fs_info, BTRFS_FS_TREE_OBJECTID,
+					nodesize, nodesize)) {
 		test_msg("Qgroup counts didn't match expected values\n");
 		return -EINVAL;
 	}
@@ -490,7 +502,7 @@ int btrfs_test_qgroups(u32 sectorsize, u32 nodesize)
 		goto out;
 	}
 
-	tmp_root->root_key.objectid = 5;
+	tmp_root->root_key.objectid = BTRFS_FS_TREE_OBJECTID;
 	root->fs_info->fs_root = tmp_root;
 	ret = btrfs_insert_fs_root(root->fs_info, tmp_root);
 	if (ret) {
@@ -505,7 +517,7 @@ int btrfs_test_qgroups(u32 sectorsize, u32 nodesize)
 		goto out;
 	}
 
-	tmp_root->root_key.objectid = 256;
+	tmp_root->root_key.objectid = BTRFS_FIRST_FREE_OBJECTID;
 	ret = btrfs_insert_fs_root(root->fs_info, tmp_root);
 	if (ret) {
 		test_msg("Couldn't insert fs root %d\n", ret);
-- 
2.7.4

