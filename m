Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:47865 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728491AbeGRHWb (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 18 Jul 2018 03:22:31 -0400
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (unknown [10.167.33.83])
        by cn.fujitsu.com (Postfix) with ESMTP id 6B9C54B5CD78
        for <linux-btrfs@vger.kernel.org>; Wed, 18 Jul 2018 14:46:04 +0800 (CST)
From: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 10/19] btrfs: qgroup: Drop fs_info parameter from btrfs_create_qgroup
Date: Wed, 18 Jul 2018 14:45:33 +0800
Message-ID: <20180718064542.2730-11-lufq.fnst@cn.fujitsu.com>
In-Reply-To: <20180718064542.2730-1-lufq.fnst@cn.fujitsu.com>
References: <20180718064542.2730-1-lufq.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

It can be fetched from the transaction handle.

Signed-off-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
---
 fs/btrfs/ioctl.c              | 2 +-
 fs/btrfs/qgroup.c             | 4 ++--
 fs/btrfs/qgroup.h             | 3 +--
 fs/btrfs/tests/qgroup-tests.c | 4 ++--
 4 files changed, 6 insertions(+), 7 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 15a9f9b9d8bc..ef0cdbdae98a 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -5225,7 +5225,7 @@ static long btrfs_ioctl_qgroup_create(struct file *file, void __user *arg)
 	}
 
 	if (sa->create) {
-		ret = btrfs_create_qgroup(trans, fs_info, sa->qgroupid);
+		ret = btrfs_create_qgroup(trans, sa->qgroupid);
 	} else {
 		ret = btrfs_remove_qgroup(trans, fs_info, sa->qgroupid);
 	}
diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index 6acb4658e844..5f6ea125f24d 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -1363,9 +1363,9 @@ int btrfs_del_qgroup_relation(struct btrfs_trans_handle *trans, u64 src,
 	return ret;
 }
 
-int btrfs_create_qgroup(struct btrfs_trans_handle *trans,
-			struct btrfs_fs_info *fs_info, u64 qgroupid)
+int btrfs_create_qgroup(struct btrfs_trans_handle *trans, u64 qgroupid)
 {
+	struct btrfs_fs_info *fs_info = trans->fs_info;
 	struct btrfs_root *quota_root;
 	struct btrfs_qgroup *qgroup;
 	int ret = 0;
diff --git a/fs/btrfs/qgroup.h b/fs/btrfs/qgroup.h
index 539d4c449f26..03adfedd9d01 100644
--- a/fs/btrfs/qgroup.h
+++ b/fs/btrfs/qgroup.h
@@ -151,8 +151,7 @@ int btrfs_add_qgroup_relation(struct btrfs_trans_handle *trans, u64 src,
 			      u64 dst);
 int btrfs_del_qgroup_relation(struct btrfs_trans_handle *trans, u64 src,
 			      u64 dst);
-int btrfs_create_qgroup(struct btrfs_trans_handle *trans,
-			struct btrfs_fs_info *fs_info, u64 qgroupid);
+int btrfs_create_qgroup(struct btrfs_trans_handle *trans, u64 qgroupid);
 int btrfs_remove_qgroup(struct btrfs_trans_handle *trans,
 			      struct btrfs_fs_info *fs_info, u64 qgroupid);
 int btrfs_limit_qgroup(struct btrfs_trans_handle *trans,
diff --git a/fs/btrfs/tests/qgroup-tests.c b/fs/btrfs/tests/qgroup-tests.c
index ace94db09d29..b5e332d45d37 100644
--- a/fs/btrfs/tests/qgroup-tests.c
+++ b/fs/btrfs/tests/qgroup-tests.c
@@ -216,7 +216,7 @@ static int test_no_shared_qgroup(struct btrfs_root *root,
 	btrfs_init_dummy_trans(&trans, fs_info);
 
 	test_msg("qgroup basic add");
-	ret = btrfs_create_qgroup(NULL, fs_info, BTRFS_FS_TREE_OBJECTID);
+	ret = btrfs_create_qgroup(&trans, BTRFS_FS_TREE_OBJECTID);
 	if (ret) {
 		test_err("couldn't create a qgroup %d", ret);
 		return ret;
@@ -322,7 +322,7 @@ static int test_multiple_refs(struct btrfs_root *root,
 	 * We have BTRFS_FS_TREE_OBJECTID created already from the
 	 * previous test.
 	 */
-	ret = btrfs_create_qgroup(NULL, fs_info, BTRFS_FIRST_FREE_OBJECTID);
+	ret = btrfs_create_qgroup(&trans, BTRFS_FIRST_FREE_OBJECTID);
 	if (ret) {
 		test_err("couldn't create a qgroup %d", ret);
 		return ret;
-- 
2.18.0



