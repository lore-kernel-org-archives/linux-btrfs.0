Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:3722 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754861AbbBJK0u (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 10 Feb 2015 05:26:50 -0500
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t1AAQ4GG000876
	for <linux-btrfs@vger.kernel.org>; Tue, 10 Feb 2015 18:26:04 +0800
From: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
Subject: [PATCH 8/9] Btrfs: qgroup: cleanup, remove an unsued parameter in btrfs_create_qgroup().
Date: Tue, 10 Feb 2015 18:23:22 +0800
Message-ID: <1423563803-8996-11-git-send-email-yangds.fnst@cn.fujitsu.com>
In-Reply-To: <1423563803-8996-1-git-send-email-yangds.fnst@cn.fujitsu.com>
References: <1423563803-8996-1-git-send-email-yangds.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
---
 fs/btrfs/ioctl.c              | 3 +--
 fs/btrfs/qgroup.c             | 2 +-
 fs/btrfs/qgroup.h             | 3 +--
 fs/btrfs/tests/qgroup-tests.c | 4 ++--
 4 files changed, 5 insertions(+), 7 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index d49fe8a..658d83d 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -4669,8 +4669,7 @@ static long btrfs_ioctl_qgroup_create(struct file *file, void __user *arg)
 
 	/* FIXME: check if the IDs really exist */
 	if (sa->create) {
-		ret = btrfs_create_qgroup(trans, root->fs_info, sa->qgroupid,
-					  NULL);
+		ret = btrfs_create_qgroup(trans, root->fs_info, sa->qgroupid);
 	} else {
 		ret = btrfs_remove_qgroup(trans, root->fs_info, sa->qgroupid);
 	}
diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index d3c261b..24c5bb1 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -1094,7 +1094,7 @@ out:
 }
 
 int btrfs_create_qgroup(struct btrfs_trans_handle *trans,
-			struct btrfs_fs_info *fs_info, u64 qgroupid, char *name)
+			struct btrfs_fs_info *fs_info, u64 qgroupid)
 {
 	struct btrfs_root *quota_root;
 	struct btrfs_qgroup *qgroup;
diff --git a/fs/btrfs/qgroup.h b/fs/btrfs/qgroup.h
index 18cc68c..c5242aa 100644
--- a/fs/btrfs/qgroup.h
+++ b/fs/btrfs/qgroup.h
@@ -70,8 +70,7 @@ int btrfs_add_qgroup_relation(struct btrfs_trans_handle *trans,
 int btrfs_del_qgroup_relation(struct btrfs_trans_handle *trans,
 			      struct btrfs_fs_info *fs_info, u64 src, u64 dst);
 int btrfs_create_qgroup(struct btrfs_trans_handle *trans,
-			struct btrfs_fs_info *fs_info, u64 qgroupid,
-			char *name);
+			struct btrfs_fs_info *fs_info, u64 qgroupid);
 int btrfs_remove_qgroup(struct btrfs_trans_handle *trans,
 			      struct btrfs_fs_info *fs_info, u64 qgroupid);
 int btrfs_limit_qgroup(struct btrfs_trans_handle *trans,
diff --git a/fs/btrfs/tests/qgroup-tests.c b/fs/btrfs/tests/qgroup-tests.c
index ec3dcb2..bcc1c7a 100644
--- a/fs/btrfs/tests/qgroup-tests.c
+++ b/fs/btrfs/tests/qgroup-tests.c
@@ -232,7 +232,7 @@ static int test_no_shared_qgroup(struct btrfs_root *root)
 	init_dummy_trans(&trans);
 
 	test_msg("Qgroup basic add\n");
-	ret = btrfs_create_qgroup(NULL, fs_info, 5, NULL);
+	ret = btrfs_create_qgroup(NULL, fs_info, 5);
 	if (ret) {
 		test_msg("Couldn't create a qgroup %d\n", ret);
 		return ret;
@@ -301,7 +301,7 @@ static int test_multiple_refs(struct btrfs_root *root)
 	test_msg("Qgroup multiple refs test\n");
 
 	/* We have 5 created already from the previous test */
-	ret = btrfs_create_qgroup(NULL, fs_info, 256, NULL);
+	ret = btrfs_create_qgroup(NULL, fs_info, 256);
 	if (ret) {
 		test_msg("Couldn't create a qgroup %d\n", ret);
 		return ret;
-- 
1.8.4.2

