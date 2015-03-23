Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:57975 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752151AbbCWIKr (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 23 Mar 2015 04:10:47 -0400
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t2N89hIL012364
	for <linux-btrfs@vger.kernel.org>; Mon, 23 Mar 2015 16:09:43 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [RFC PATCH 10/11] btrfs: qgroup-tests: Add old_roots ulist to allow qgroup test pass.
Date: Mon, 23 Mar 2015 16:08:36 +0800
Message-ID: <1427098117-25152-11-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1427098117-25152-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1427098117-25152-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Since new qgroup design need to get old_roots before calling
btrfs_qgroup_record_ref(), modify qgroup test to follow the new routine.

And of course, without this modification, it won't pass the qgroup
multi-ref test.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 fs/btrfs/backref.c            | 10 ++++++++++
 fs/btrfs/tests/qgroup-tests.c | 32 +++++++++++++++++++++++++++-----
 2 files changed, 37 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/backref.c b/fs/btrfs/backref.c
index e33a003..58d87ab 100644
--- a/fs/btrfs/backref.c
+++ b/fs/btrfs/backref.c
@@ -1017,7 +1017,17 @@ again:
 	if (ret)
 		goto out;
 
+	/*
+	 * For sanity tests, all parents are 0, causing different roots
+	 * referring to one extent merged into one root.
+	 * So skip such search in sanity tests
+	 */
+#ifdef CONFIG_BTRFS_FS_RUN_SANITY_TESTS
+	if (!trans || (trans && likely(trans->type != __TRANS_DUMMY)))
+		__merge_refs(&prefs, 2);
+#else
 	__merge_refs(&prefs, 2);
+#endif
 
 	while (!list_empty(&prefs)) {
 		ref = list_first_entry(&prefs, struct __prelim_ref, list);
diff --git a/fs/btrfs/tests/qgroup-tests.c b/fs/btrfs/tests/qgroup-tests.c
index c97c5f8..967a185 100644
--- a/fs/btrfs/tests/qgroup-tests.c
+++ b/fs/btrfs/tests/qgroup-tests.c
@@ -21,6 +21,7 @@
 #include "../transaction.h"
 #include "../disk-io.h"
 #include "../qgroup.h"
+#include "../backref.h"
 
 static void init_dummy_trans(struct btrfs_trans_handle *trans)
 {
@@ -294,6 +295,7 @@ static int test_multiple_refs(struct btrfs_root *root)
 {
 	struct btrfs_trans_handle trans;
 	struct btrfs_fs_info *fs_info = root->fs_info;
+	struct ulist *old_roots = NULL;
 	int ret;
 
 	init_dummy_trans(&trans);
@@ -329,16 +331,27 @@ static int test_multiple_refs(struct btrfs_root *root)
 		return -EINVAL;
 	}
 
+	/* Get correct old ref counts before writing tree backref */
+	ret = btrfs_find_all_roots(&trans, fs_info, NULL, 4096, 0, &old_roots, 1);
+	if (ret < 0) {
+		ulist_free(old_roots);
+		return ret;
+	}
+
 	ret = add_tree_ref(root, 4096, 4096, 0, 256);
-	if (ret)
+	if (ret) {
+		ulist_free(old_roots);
 		return ret;
+	}
 
-	ret = btrfs_qgroup_record_ref(&trans, fs_info, NULL, 256, 4096, 4096, 0,
-				      BTRFS_QGROUP_OPER_ADD_SHARED, 0);
+	ret = btrfs_qgroup_record_ref(&trans, fs_info, old_roots, 256, 4096,
+				      4096, 0, BTRFS_QGROUP_OPER_ADD_SHARED, 0);
 	if (ret) {
 		test_msg("Qgroup record ref failed %d\n", ret);
+		ulist_free(old_roots);
 		return ret;
 	}
+	old_roots = NULL;
 
 	ret = btrfs_delayed_qgroup_accounting(&trans, fs_info);
 	if (ret) {
@@ -356,16 +369,25 @@ static int test_multiple_refs(struct btrfs_root *root)
 		return -EINVAL;
 	}
 
+	/* Get correct old ref counts before writing tree backref */
+	ret = btrfs_find_all_roots(&trans, fs_info, NULL, 4096, 0, &old_roots, 1);
+	if (ret < 0) {
+		ulist_free(old_roots);
+		return ret;
+	}
+
 	ret = remove_extent_ref(root, 4096, 4096, 0, 256);
 	if (ret)
 		return ret;
 
-	ret = btrfs_qgroup_record_ref(&trans, fs_info, NULL, 256, 4096, 4096, 0,
-				      BTRFS_QGROUP_OPER_SUB_SHARED, 0);
+	ret = btrfs_qgroup_record_ref(&trans, fs_info, old_roots, 256, 4096,
+				      4096, 0, BTRFS_QGROUP_OPER_SUB_SHARED, 0);
 	if (ret) {
+		ulist_free(old_roots);
 		test_msg("Qgroup record ref failed %d\n", ret);
 		return ret;
 	}
+	old_roots = NULL;
 
 	ret = btrfs_delayed_qgroup_accounting(&trans, fs_info);
 	if (ret) {
-- 
2.3.3

