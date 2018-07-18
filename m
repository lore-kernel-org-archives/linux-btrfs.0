Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:47865 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1730096AbeGRHWh (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 18 Jul 2018 03:22:37 -0400
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (unknown [10.167.33.83])
        by cn.fujitsu.com (Postfix) with ESMTP id D4FD64B5CD78
        for <linux-btrfs@vger.kernel.org>; Wed, 18 Jul 2018 14:46:10 +0800 (CST)
From: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 17/19] btrfs: qgroup: Drop fs_info parameter from btrfs_run_qgroups
Date: Wed, 18 Jul 2018 14:45:40 +0800
Message-ID: <20180718064542.2730-18-lufq.fnst@cn.fujitsu.com>
In-Reply-To: <20180718064542.2730-1-lufq.fnst@cn.fujitsu.com>
References: <20180718064542.2730-1-lufq.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

It can be fetched from the transaction handle.

Signed-off-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
---
 fs/btrfs/ioctl.c       | 2 +-
 fs/btrfs/qgroup.c      | 4 ++--
 fs/btrfs/qgroup.h      | 3 +--
 fs/btrfs/transaction.c | 2 +-
 4 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index a92f07831627..e78836df93ff 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -5175,7 +5175,7 @@ static long btrfs_ioctl_qgroup_assign(struct file *file, void __user *arg)
 	}
 
 	/* update qgroup status and info */
-	err = btrfs_run_qgroups(trans, fs_info);
+	err = btrfs_run_qgroups(trans);
 	if (err < 0)
 		btrfs_handle_fs_error(fs_info, err,
 				      "failed to update qgroup status and info");
diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index c0b684f279cf..b96f344cfb7e 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -2194,9 +2194,9 @@ int btrfs_qgroup_account_extents(struct btrfs_trans_handle *trans)
 /*
  * called from commit_transaction. Writes all changed qgroups to disk.
  */
-int btrfs_run_qgroups(struct btrfs_trans_handle *trans,
-		      struct btrfs_fs_info *fs_info)
+int btrfs_run_qgroups(struct btrfs_trans_handle *trans)
 {
+	struct btrfs_fs_info *fs_info = trans->fs_info;
 	struct btrfs_root *quota_root = fs_info->quota_root;
 	int ret = 0;
 
diff --git a/fs/btrfs/qgroup.h b/fs/btrfs/qgroup.h
index 61b723b1e4d8..2c8960f9028c 100644
--- a/fs/btrfs/qgroup.h
+++ b/fs/btrfs/qgroup.h
@@ -240,8 +240,7 @@ int btrfs_qgroup_account_extent(struct btrfs_trans_handle *trans, u64 bytenr,
 				u64 num_bytes, struct ulist *old_roots,
 				struct ulist *new_roots);
 int btrfs_qgroup_account_extents(struct btrfs_trans_handle *trans);
-int btrfs_run_qgroups(struct btrfs_trans_handle *trans,
-		      struct btrfs_fs_info *fs_info);
+int btrfs_run_qgroups(struct btrfs_trans_handle *trans);
 int btrfs_qgroup_inherit(struct btrfs_trans_handle *trans,
 			 struct btrfs_fs_info *fs_info, u64 srcid, u64 objectid,
 			 struct btrfs_qgroup_inherit *inherit);
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index ebe50dfb8947..0cbd55c498a1 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -1152,7 +1152,7 @@ static noinline int commit_cowonly_roots(struct btrfs_trans_handle *trans)
 	ret = btrfs_run_dev_replace(trans, fs_info);
 	if (ret)
 		return ret;
-	ret = btrfs_run_qgroups(trans, fs_info);
+	ret = btrfs_run_qgroups(trans);
 	if (ret)
 		return ret;
 
-- 
2.18.0



