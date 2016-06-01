Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from e18.ny.us.ibm.com ([129.33.205.208]:60937 "EHLO
	e18.ny.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754638AbcFAPxG (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 1 Jun 2016 11:53:06 -0400
Received: from localhost
	by e18.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <xufeifei@linux.vnet.ibm.com>;
	Wed, 1 Jun 2016 11:53:05 -0400
From: Feifei Xu <xufeifei@linux.vnet.ibm.com>
To: linux-btrfs@vger.kernel.org
Cc: steve.capper@linaro.org, chandan@mykolab.com, jbacik@fb.com,
        dsterba@suse.com, chandan@linux.vnet.ibm.com, feifeixu.sh@gmail.com,
        Feifei Xu <xufeifei@linux.vnet.ibm.com>
Subject: [PATCH V2 6/8] Btrfs: self-tests: Use macros instead of constants and add missing newline
Date: Wed,  1 Jun 2016 15:51:45 +0000
Message-Id: <1464796307-67173-7-git-send-email-xufeifei@linux.vnet.ibm.com>
In-Reply-To: <1464796307-67173-1-git-send-email-xufeifei@linux.vnet.ibm.com>
References: <1464796307-67173-1-git-send-email-xufeifei@linux.vnet.ibm.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

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

