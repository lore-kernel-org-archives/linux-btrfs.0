Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:48662 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729262AbeGRHWb (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 18 Jul 2018 03:22:31 -0400
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (unknown [10.167.33.83])
        by cn.fujitsu.com (Postfix) with ESMTP id 0B0BD48029E5
        for <linux-btrfs@vger.kernel.org>; Wed, 18 Jul 2018 14:46:05 +0800 (CST)
From: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 11/19] btrfs: qgroup: Drop fs_info parameter from btrfs_remove_qgroup
Date: Wed, 18 Jul 2018 14:45:34 +0800
Message-ID: <20180718064542.2730-12-lufq.fnst@cn.fujitsu.com>
In-Reply-To: <20180718064542.2730-1-lufq.fnst@cn.fujitsu.com>
References: <20180718064542.2730-1-lufq.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

It can be fetched from the transaction handle.

Signed-off-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
---
 fs/btrfs/ioctl.c  | 3 +--
 fs/btrfs/qgroup.c | 4 ++--
 fs/btrfs/qgroup.h | 3 +--
 3 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index ef0cdbdae98a..25bb192a3775 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -5193,7 +5193,6 @@ static long btrfs_ioctl_qgroup_assign(struct file *file, void __user *arg)
 static long btrfs_ioctl_qgroup_create(struct file *file, void __user *arg)
 {
 	struct inode *inode = file_inode(file);
-	struct btrfs_fs_info *fs_info = btrfs_sb(inode->i_sb);
 	struct btrfs_root *root = BTRFS_I(inode)->root;
 	struct btrfs_ioctl_qgroup_create_args *sa;
 	struct btrfs_trans_handle *trans;
@@ -5227,7 +5226,7 @@ static long btrfs_ioctl_qgroup_create(struct file *file, void __user *arg)
 	if (sa->create) {
 		ret = btrfs_create_qgroup(trans, sa->qgroupid);
 	} else {
-		ret = btrfs_remove_qgroup(trans, fs_info, sa->qgroupid);
+		ret = btrfs_remove_qgroup(trans, sa->qgroupid);
 	}
 
 	err = btrfs_end_transaction(trans);
diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index 5f6ea125f24d..09256114aaa6 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -1397,9 +1397,9 @@ int btrfs_create_qgroup(struct btrfs_trans_handle *trans, u64 qgroupid)
 	return ret;
 }
 
-int btrfs_remove_qgroup(struct btrfs_trans_handle *trans,
-			struct btrfs_fs_info *fs_info, u64 qgroupid)
+int btrfs_remove_qgroup(struct btrfs_trans_handle *trans, u64 qgroupid)
 {
+	struct btrfs_fs_info *fs_info = trans->fs_info;
 	struct btrfs_root *quota_root;
 	struct btrfs_qgroup *qgroup;
 	struct btrfs_qgroup_list *list;
diff --git a/fs/btrfs/qgroup.h b/fs/btrfs/qgroup.h
index 03adfedd9d01..41516dddf123 100644
--- a/fs/btrfs/qgroup.h
+++ b/fs/btrfs/qgroup.h
@@ -152,8 +152,7 @@ int btrfs_add_qgroup_relation(struct btrfs_trans_handle *trans, u64 src,
 int btrfs_del_qgroup_relation(struct btrfs_trans_handle *trans, u64 src,
 			      u64 dst);
 int btrfs_create_qgroup(struct btrfs_trans_handle *trans, u64 qgroupid);
-int btrfs_remove_qgroup(struct btrfs_trans_handle *trans,
-			      struct btrfs_fs_info *fs_info, u64 qgroupid);
+int btrfs_remove_qgroup(struct btrfs_trans_handle *trans, u64 qgroupid);
 int btrfs_limit_qgroup(struct btrfs_trans_handle *trans,
 		       struct btrfs_fs_info *fs_info, u64 qgroupid,
 		       struct btrfs_qgroup_limit *limit);
-- 
2.18.0



