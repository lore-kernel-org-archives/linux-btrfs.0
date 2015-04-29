Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:36586 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1031519AbbD2Cbb (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 28 Apr 2015 22:31:31 -0400
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t3T2UEsL018350
	for <linux-btrfs@vger.kernel.org>; Wed, 29 Apr 2015 10:30:14 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH v2 14/18] btrfs: qgroup: Switch self test to extent-oriented qgroup mechanism.
Date: Wed, 29 Apr 2015 10:29:07 +0800
Message-ID: <1430274551-9277-15-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1430274551-9277-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1430274551-9277-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Since the self test transaction don't have delayed_ref_roots, so use
find_all_roots() and export btrfs_qgroup_account_extent() to simulate it

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
v2:
  None
---
 fs/btrfs/qgroup.c             |   2 +-
 fs/btrfs/qgroup.h             |   5 ++
 fs/btrfs/tests/qgroup-tests.c | 109 ++++++++++++++++++++++++++++++++----------
 3 files changed, 89 insertions(+), 27 deletions(-)

diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index c86e515..2e86bea 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -2346,7 +2346,7 @@ static int btrfs_qgroup_account(struct btrfs_trans_handle *trans,
 	return ret;
 }
 
-static int
+int
 btrfs_qgroup_account_extent(struct btrfs_trans_handle *trans,
 			    struct btrfs_fs_info *fs_info,
 			    u64 bytenr, u64 num_bytes,
diff --git a/fs/btrfs/qgroup.h b/fs/btrfs/qgroup.h
index c3b08d6..80d7df8 100644
--- a/fs/btrfs/qgroup.h
+++ b/fs/btrfs/qgroup.h
@@ -104,6 +104,11 @@ int btrfs_qgroup_prepare_account_extents(struct btrfs_trans_handle *trans,
 struct btrfs_qgroup_extent_record
 *btrfs_qgroup_insert_dirty_extent(struct btrfs_delayed_ref_root *delayed_refs,
 				  struct btrfs_qgroup_extent_record *record);
+int
+btrfs_qgroup_account_extent(struct btrfs_trans_handle *trans,
+			    struct btrfs_fs_info *fs_info,
+			    u64 bytenr, u64 num_bytes,
+			    struct ulist *old_roots, struct ulist *new_roots);
 int btrfs_qgroup_account_extents(struct btrfs_trans_handle *trans,
 				 struct btrfs_fs_info *fs_info);
 int btrfs_delayed_qgroup_accounting(struct btrfs_trans_handle *trans,
diff --git a/fs/btrfs/tests/qgroup-tests.c b/fs/btrfs/tests/qgroup-tests.c
index 73f299e..db61e3e 100644
--- a/fs/btrfs/tests/qgroup-tests.c
+++ b/fs/btrfs/tests/qgroup-tests.c
@@ -21,6 +21,7 @@
 #include "../transaction.h"
 #include "../disk-io.h"
 #include "../qgroup.h"
+#include "../backref.h"
 
 static void init_dummy_trans(struct btrfs_trans_handle *trans)
 {
@@ -227,6 +228,8 @@ static int test_no_shared_qgroup(struct btrfs_root *root)
 {
 	struct btrfs_trans_handle trans;
 	struct btrfs_fs_info *fs_info = root->fs_info;
+	struct ulist *old_roots = NULL;
+	struct ulist *new_roots = NULL;
 	int ret;
 
 	init_dummy_trans(&trans);
@@ -238,10 +241,15 @@ static int test_no_shared_qgroup(struct btrfs_root *root)
 		return ret;
 	}
 
-	ret = btrfs_qgroup_record_ref(&trans, fs_info, 5, 4096, 4096,
-				      BTRFS_QGROUP_OPER_ADD_EXCL, 0);
+	/*
+	 * Since the test trans doesn't havee the complicated delayed refs,
+	 * we can only call btrfs_qgroup_account_extent() directly to test
+	 * quota.
+	 */
+	ret = btrfs_find_all_roots(&trans, fs_info, 4096, 0, &old_roots);
 	if (ret) {
-		test_msg("Couldn't add space to a qgroup %d\n", ret);
+		ulist_free(old_roots);
+		test_msg("Couldn't find old roots: %d\n", ret);
 		return ret;
 	}
 
@@ -249,9 +257,18 @@ static int test_no_shared_qgroup(struct btrfs_root *root)
 	if (ret)
 		return ret;
 
-	ret = btrfs_delayed_qgroup_accounting(&trans, fs_info);
+	ret = btrfs_find_all_roots(&trans, fs_info, 4096, 0, &new_roots);
+	if (ret) {
+		ulist_free(old_roots);
+		ulist_free(new_roots);
+		test_msg("Couldn't find old roots: %d\n", ret);
+		return ret;
+	}
+
+	ret = btrfs_qgroup_account_extent(&trans, fs_info, 4096, 4096,
+					  old_roots, new_roots);
 	if (ret) {
-		test_msg("Delayed qgroup accounting failed %d\n", ret);
+		test_msg("Couldn't account space for a qgroup %d\n", ret);
 		return ret;
 	}
 
@@ -259,21 +276,32 @@ static int test_no_shared_qgroup(struct btrfs_root *root)
 		test_msg("Qgroup counts didn't match expected values\n");
 		return -EINVAL;
 	}
+	old_roots = NULL;
+	new_roots = NULL;
+
+	ret = btrfs_find_all_roots(&trans, fs_info, 4096, 0, &old_roots);
+	if (ret) {
+		ulist_free(old_roots);
+		test_msg("Couldn't find old roots: %d\n", ret);
+		return ret;
+	}
 
 	ret = remove_extent_item(root, 4096, 4096);
 	if (ret)
 		return -EINVAL;
 
-	ret = btrfs_qgroup_record_ref(&trans, fs_info, 5, 4096, 4096,
-				      BTRFS_QGROUP_OPER_SUB_EXCL, 0);
+	ret = btrfs_find_all_roots(&trans, fs_info, 4096, 0, &new_roots);
 	if (ret) {
-		test_msg("Couldn't remove space from the qgroup %d\n", ret);
-		return -EINVAL;
+		ulist_free(old_roots);
+		ulist_free(new_roots);
+		test_msg("Couldn't find old roots: %d\n", ret);
+		return ret;
 	}
 
-	ret = btrfs_delayed_qgroup_accounting(&trans, fs_info);
+	ret = btrfs_qgroup_account_extent(&trans, fs_info, 4096, 4096,
+					  old_roots, new_roots);
 	if (ret) {
-		test_msg("Qgroup accounting failed %d\n", ret);
+		test_msg("Couldn't account space for a qgroup %d\n", ret);
 		return -EINVAL;
 	}
 
@@ -294,6 +322,8 @@ static int test_multiple_refs(struct btrfs_root *root)
 {
 	struct btrfs_trans_handle trans;
 	struct btrfs_fs_info *fs_info = root->fs_info;
+	struct ulist *old_roots = NULL;
+	struct ulist *new_roots = NULL;
 	int ret;
 
 	init_dummy_trans(&trans);
@@ -307,20 +337,29 @@ static int test_multiple_refs(struct btrfs_root *root)
 		return ret;
 	}
 
+	ret = btrfs_find_all_roots(&trans, fs_info, 4096, 0, &old_roots);
+	if (ret) {
+		ulist_free(old_roots);
+		test_msg("Couldn't find old roots: %d\n", ret);
+		return ret;
+	}
+
 	ret = insert_normal_tree_ref(root, 4096, 4096, 0, 5);
 	if (ret)
 		return ret;
 
-	ret = btrfs_qgroup_record_ref(&trans, fs_info, 5, 4096, 4096,
-				      BTRFS_QGROUP_OPER_ADD_EXCL, 0);
+	ret = btrfs_find_all_roots(&trans, fs_info, 4096, 0, &new_roots);
 	if (ret) {
-		test_msg("Couldn't add space to a qgroup %d\n", ret);
+		ulist_free(old_roots);
+		ulist_free(new_roots);
+		test_msg("Couldn't find old roots: %d\n", ret);
 		return ret;
 	}
 
-	ret = btrfs_delayed_qgroup_accounting(&trans, fs_info);
+	ret = btrfs_qgroup_account_extent(&trans, fs_info, 4096, 4096,
+					  old_roots, new_roots);
 	if (ret) {
-		test_msg("Delayed qgroup accounting failed %d\n", ret);
+		test_msg("Couldn't account space for a qgroup %d\n", ret);
 		return ret;
 	}
 
@@ -329,20 +368,29 @@ static int test_multiple_refs(struct btrfs_root *root)
 		return -EINVAL;
 	}
 
+	ret = btrfs_find_all_roots(&trans, fs_info, 4096, 0, &old_roots);
+	if (ret) {
+		ulist_free(old_roots);
+		test_msg("Couldn't find old roots: %d\n", ret);
+		return ret;
+	}
+
 	ret = add_tree_ref(root, 4096, 4096, 0, 256);
 	if (ret)
 		return ret;
 
-	ret = btrfs_qgroup_record_ref(&trans, fs_info, 256, 4096, 4096,
-				      BTRFS_QGROUP_OPER_ADD_SHARED, 0);
+	ret = btrfs_find_all_roots(&trans, fs_info, 4096, 0, &new_roots);
 	if (ret) {
-		test_msg("Qgroup record ref failed %d\n", ret);
+		ulist_free(old_roots);
+		ulist_free(new_roots);
+		test_msg("Couldn't find old roots: %d\n", ret);
 		return ret;
 	}
 
-	ret = btrfs_delayed_qgroup_accounting(&trans, fs_info);
+	ret = btrfs_qgroup_account_extent(&trans, fs_info, 4096, 4096,
+					  old_roots, new_roots);
 	if (ret) {
-		test_msg("Qgroup accounting failed %d\n", ret);
+		test_msg("Couldn't account space for a qgroup %d\n", ret);
 		return ret;
 	}
 
@@ -356,20 +404,29 @@ static int test_multiple_refs(struct btrfs_root *root)
 		return -EINVAL;
 	}
 
+	ret = btrfs_find_all_roots(&trans, fs_info, 4096, 0, &old_roots);
+	if (ret) {
+		ulist_free(old_roots);
+		test_msg("Couldn't find old roots: %d\n", ret);
+		return ret;
+	}
+
 	ret = remove_extent_ref(root, 4096, 4096, 0, 256);
 	if (ret)
 		return ret;
 
-	ret = btrfs_qgroup_record_ref(&trans, fs_info, 256, 4096, 4096,
-				      BTRFS_QGROUP_OPER_SUB_SHARED, 0);
+	ret = btrfs_find_all_roots(&trans, fs_info, 4096, 0, &new_roots);
 	if (ret) {
-		test_msg("Qgroup record ref failed %d\n", ret);
+		ulist_free(old_roots);
+		ulist_free(new_roots);
+		test_msg("Couldn't find old roots: %d\n", ret);
 		return ret;
 	}
 
-	ret = btrfs_delayed_qgroup_accounting(&trans, fs_info);
+	ret = btrfs_qgroup_account_extent(&trans, fs_info, 4096, 4096,
+					  old_roots, new_roots);
 	if (ret) {
-		test_msg("Qgroup accounting failed %d\n", ret);
+		test_msg("Couldn't account space for a qgroup %d\n", ret);
 		return ret;
 	}
 
-- 
2.3.6

