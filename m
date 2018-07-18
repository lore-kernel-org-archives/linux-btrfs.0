Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:47865 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729832AbeGRHWe (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 18 Jul 2018 03:22:34 -0400
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (unknown [10.167.33.83])
        by cn.fujitsu.com (Postfix) with ESMTP id 4426248029E5
        for <linux-btrfs@vger.kernel.org>; Wed, 18 Jul 2018 14:46:10 +0800 (CST)
From: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 16/19] btrfs: qgroup: Drop fs_info parameter from btrfs_qgroup_account_extent
Date: Wed, 18 Jul 2018 14:45:39 +0800
Message-ID: <20180718064542.2730-17-lufq.fnst@cn.fujitsu.com>
In-Reply-To: <20180718064542.2730-1-lufq.fnst@cn.fujitsu.com>
References: <20180718064542.2730-1-lufq.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

It can be fetched from the transaction handle.

Signed-off-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
---
 fs/btrfs/qgroup.c             | 20 ++++++++++----------
 fs/btrfs/qgroup.h             |  8 +++-----
 fs/btrfs/tests/qgroup-tests.c | 20 ++++++++++----------
 3 files changed, 23 insertions(+), 25 deletions(-)

diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index 92d757e3a2f5..c0b684f279cf 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -2039,12 +2039,11 @@ static int maybe_fs_roots(struct ulist *roots)
 	return is_fstree(unode->val);
 }
 
-int
-btrfs_qgroup_account_extent(struct btrfs_trans_handle *trans,
-			    struct btrfs_fs_info *fs_info,
-			    u64 bytenr, u64 num_bytes,
-			    struct ulist *old_roots, struct ulist *new_roots)
+int btrfs_qgroup_account_extent(struct btrfs_trans_handle *trans, u64 bytenr,
+				u64 num_bytes, struct ulist *old_roots,
+				struct ulist *new_roots)
 {
+	struct btrfs_fs_info *fs_info = trans->fs_info;
 	struct ulist *qgroups = NULL;
 	struct ulist *tmp = NULL;
 	u64 seq;
@@ -2174,9 +2173,10 @@ int btrfs_qgroup_account_extents(struct btrfs_trans_handle *trans)
 				ulist_del(record->old_roots, qgroup_to_skip,
 					  0);
 			}
-			ret = btrfs_qgroup_account_extent(trans, fs_info,
-					record->bytenr, record->num_bytes,
-					record->old_roots, new_roots);
+			ret = btrfs_qgroup_account_extent(trans, record->bytenr,
+							  record->num_bytes,
+							  record->old_roots,
+							  new_roots);
 			record->old_roots = NULL;
 			new_roots = NULL;
 		}
@@ -2712,8 +2712,8 @@ qgroup_rescan_leaf(struct btrfs_fs_info *fs_info, struct btrfs_path *path,
 		if (ret < 0)
 			goto out;
 		/* For rescan, just pass old_roots as NULL */
-		ret = btrfs_qgroup_account_extent(trans, fs_info,
-				found.objectid, num_bytes, NULL, roots);
+		ret = btrfs_qgroup_account_extent(trans, found.objectid,
+						  num_bytes, NULL, roots);
 		if (ret < 0)
 			goto out;
 	}
diff --git a/fs/btrfs/qgroup.h b/fs/btrfs/qgroup.h
index b8f15ce6c83d..61b723b1e4d8 100644
--- a/fs/btrfs/qgroup.h
+++ b/fs/btrfs/qgroup.h
@@ -236,11 +236,9 @@ int btrfs_qgroup_trace_leaf_items(struct btrfs_trans_handle *trans,
 int btrfs_qgroup_trace_subtree(struct btrfs_trans_handle *trans,
 			       struct extent_buffer *root_eb,
 			       u64 root_gen, int root_level);
-int
-btrfs_qgroup_account_extent(struct btrfs_trans_handle *trans,
-			    struct btrfs_fs_info *fs_info,
-			    u64 bytenr, u64 num_bytes,
-			    struct ulist *old_roots, struct ulist *new_roots);
+int btrfs_qgroup_account_extent(struct btrfs_trans_handle *trans, u64 bytenr,
+				u64 num_bytes, struct ulist *old_roots,
+				struct ulist *new_roots);
 int btrfs_qgroup_account_extents(struct btrfs_trans_handle *trans);
 int btrfs_run_qgroups(struct btrfs_trans_handle *trans,
 		      struct btrfs_fs_info *fs_info);
diff --git a/fs/btrfs/tests/qgroup-tests.c b/fs/btrfs/tests/qgroup-tests.c
index b5e332d45d37..412b910b04cc 100644
--- a/fs/btrfs/tests/qgroup-tests.c
+++ b/fs/btrfs/tests/qgroup-tests.c
@@ -249,8 +249,8 @@ static int test_no_shared_qgroup(struct btrfs_root *root,
 		return ret;
 	}
 
-	ret = btrfs_qgroup_account_extent(&trans, fs_info, nodesize,
-					  nodesize, old_roots, new_roots);
+	ret = btrfs_qgroup_account_extent(&trans, nodesize, nodesize, old_roots,
+					  new_roots);
 	if (ret) {
 		test_err("couldn't account space for a qgroup %d", ret);
 		return ret;
@@ -285,8 +285,8 @@ static int test_no_shared_qgroup(struct btrfs_root *root,
 		return ret;
 	}
 
-	ret = btrfs_qgroup_account_extent(&trans, fs_info, nodesize,
-					  nodesize, old_roots, new_roots);
+	ret = btrfs_qgroup_account_extent(&trans, nodesize, nodesize, old_roots,
+					  new_roots);
 	if (ret) {
 		test_err("couldn't account space for a qgroup %d", ret);
 		return -EINVAL;
@@ -350,8 +350,8 @@ static int test_multiple_refs(struct btrfs_root *root,
 		return ret;
 	}
 
-	ret = btrfs_qgroup_account_extent(&trans, fs_info, nodesize,
-					  nodesize, old_roots, new_roots);
+	ret = btrfs_qgroup_account_extent(&trans, nodesize, nodesize, old_roots,
+					  new_roots);
 	if (ret) {
 		test_err("couldn't account space for a qgroup %d", ret);
 		return ret;
@@ -385,8 +385,8 @@ static int test_multiple_refs(struct btrfs_root *root,
 		return ret;
 	}
 
-	ret = btrfs_qgroup_account_extent(&trans, fs_info, nodesize,
-					  nodesize, old_roots, new_roots);
+	ret = btrfs_qgroup_account_extent(&trans, nodesize, nodesize, old_roots,
+					  new_roots);
 	if (ret) {
 		test_err("couldn't account space for a qgroup %d", ret);
 		return ret;
@@ -426,8 +426,8 @@ static int test_multiple_refs(struct btrfs_root *root,
 		return ret;
 	}
 
-	ret = btrfs_qgroup_account_extent(&trans, fs_info, nodesize,
-					  nodesize, old_roots, new_roots);
+	ret = btrfs_qgroup_account_extent(&trans, nodesize, nodesize, old_roots,
+					  new_roots);
 	if (ret) {
 		test_err("couldn't account space for a qgroup %d", ret);
 		return ret;
-- 
2.18.0



