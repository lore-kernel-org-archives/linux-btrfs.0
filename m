Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:6307 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726180AbeGRHW2 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 18 Jul 2018 03:22:28 -0400
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (unknown [10.167.33.83])
        by cn.fujitsu.com (Postfix) with ESMTP id D64F94B625EB
        for <linux-btrfs@vger.kernel.org>; Wed, 18 Jul 2018 14:46:03 +0800 (CST)
From: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 09/19] btrfs: qgroup: Drop fs_info parameter from btrfs_del_qgroup_relation
Date: Wed, 18 Jul 2018 14:45:32 +0800
Message-ID: <20180718064542.2730-10-lufq.fnst@cn.fujitsu.com>
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
 fs/btrfs/qgroup.c | 5 +++--
 fs/btrfs/qgroup.h | 4 ++--
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index b8e3c1c3519e..15a9f9b9d8bc 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -5171,8 +5171,7 @@ static long btrfs_ioctl_qgroup_assign(struct file *file, void __user *arg)
 	if (sa->assign) {
 		ret = btrfs_add_qgroup_relation(trans, sa->src, sa->dst);
 	} else {
-		ret = btrfs_del_qgroup_relation(trans, fs_info,
-						sa->src, sa->dst);
+		ret = btrfs_del_qgroup_relation(trans, sa->src, sa->dst);
 	}
 
 	/* update qgroup status and info */
diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index 51e43dbedbbc..6acb4658e844 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -1350,9 +1350,10 @@ static int __del_qgroup_relation(struct btrfs_trans_handle *trans, u64 src,
 	return ret;
 }
 
-int btrfs_del_qgroup_relation(struct btrfs_trans_handle *trans,
-			      struct btrfs_fs_info *fs_info, u64 src, u64 dst)
+int btrfs_del_qgroup_relation(struct btrfs_trans_handle *trans, u64 src,
+			      u64 dst)
 {
+	struct btrfs_fs_info *fs_info = trans->fs_info;
 	int ret = 0;
 
 	mutex_lock(&fs_info->qgroup_ioctl_lock);
diff --git a/fs/btrfs/qgroup.h b/fs/btrfs/qgroup.h
index cb4d0e58f486..539d4c449f26 100644
--- a/fs/btrfs/qgroup.h
+++ b/fs/btrfs/qgroup.h
@@ -149,8 +149,8 @@ int btrfs_qgroup_wait_for_completion(struct btrfs_fs_info *fs_info,
 				     bool interruptible);
 int btrfs_add_qgroup_relation(struct btrfs_trans_handle *trans, u64 src,
 			      u64 dst);
-int btrfs_del_qgroup_relation(struct btrfs_trans_handle *trans,
-			      struct btrfs_fs_info *fs_info, u64 src, u64 dst);
+int btrfs_del_qgroup_relation(struct btrfs_trans_handle *trans, u64 src,
+			      u64 dst);
 int btrfs_create_qgroup(struct btrfs_trans_handle *trans,
 			struct btrfs_fs_info *fs_info, u64 qgroupid);
 int btrfs_remove_qgroup(struct btrfs_trans_handle *trans,
-- 
2.18.0



