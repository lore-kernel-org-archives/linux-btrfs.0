Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:48662 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728311AbeGRHWY (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 18 Jul 2018 03:22:24 -0400
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (unknown [10.167.33.83])
        by cn.fujitsu.com (Postfix) with ESMTP id 444744B5CF62
        for <linux-btrfs@vger.kernel.org>; Wed, 18 Jul 2018 14:46:03 +0800 (CST)
From: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 08/19] btrfs: qgroup: Drop fs_info parameter from __del_qgroup_relation
Date: Wed, 18 Jul 2018 14:45:31 +0800
Message-ID: <20180718064542.2730-9-lufq.fnst@cn.fujitsu.com>
In-Reply-To: <20180718064542.2730-1-lufq.fnst@cn.fujitsu.com>
References: <20180718064542.2730-1-lufq.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

It can be fetched from the transaction handle.

Signed-off-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
---
 fs/btrfs/qgroup.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index 9e709a01bfaa..51e43dbedbbc 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -1299,9 +1299,10 @@ int btrfs_add_qgroup_relation(struct btrfs_trans_handle *trans, u64 src,
 	return ret;
 }
 
-static int __del_qgroup_relation(struct btrfs_trans_handle *trans,
-			      struct btrfs_fs_info *fs_info, u64 src, u64 dst)
+static int __del_qgroup_relation(struct btrfs_trans_handle *trans, u64 src,
+				 u64 dst)
 {
+	struct btrfs_fs_info *fs_info = trans->fs_info;
 	struct btrfs_root *quota_root;
 	struct btrfs_qgroup *parent;
 	struct btrfs_qgroup *member;
@@ -1355,7 +1356,7 @@ int btrfs_del_qgroup_relation(struct btrfs_trans_handle *trans,
 	int ret = 0;
 
 	mutex_lock(&fs_info->qgroup_ioctl_lock);
-	ret = __del_qgroup_relation(trans, fs_info, src, dst);
+	ret = __del_qgroup_relation(trans, src, dst);
 	mutex_unlock(&fs_info->qgroup_ioctl_lock);
 
 	return ret;
@@ -1428,9 +1429,8 @@ int btrfs_remove_qgroup(struct btrfs_trans_handle *trans,
 	while (!list_empty(&qgroup->groups)) {
 		list = list_first_entry(&qgroup->groups,
 					struct btrfs_qgroup_list, next_group);
-		ret = __del_qgroup_relation(trans, fs_info,
-					   qgroupid,
-					   list->group->qgroupid);
+		ret = __del_qgroup_relation(trans, qgroupid,
+					    list->group->qgroupid);
 		if (ret)
 			goto out;
 	}
-- 
2.18.0



