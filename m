Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:47865 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728491AbeGRHW2 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 18 Jul 2018 03:22:28 -0400
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (unknown [10.167.33.83])
        by cn.fujitsu.com (Postfix) with ESMTP id 6BF424B5CD99
        for <linux-btrfs@vger.kernel.org>; Wed, 18 Jul 2018 14:46:01 +0800 (CST)
From: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 05/19] btrfs: qgroup: Drop root parameter from update_qgroup_info_item
Date: Wed, 18 Jul 2018 14:45:28 +0800
Message-ID: <20180718064542.2730-6-lufq.fnst@cn.fujitsu.com>
In-Reply-To: <20180718064542.2730-1-lufq.fnst@cn.fujitsu.com>
References: <20180718064542.2730-1-lufq.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

It can be fetched from the transaction handle.

Signed-off-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
---
 fs/btrfs/qgroup.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index 763bcb3f24da..d405b09ca6db 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -742,9 +742,10 @@ static int update_qgroup_limit_item(struct btrfs_trans_handle *trans,
 }
 
 static int update_qgroup_info_item(struct btrfs_trans_handle *trans,
-				   struct btrfs_root *root,
 				   struct btrfs_qgroup *qgroup)
 {
+	struct btrfs_fs_info *fs_info = trans->fs_info;
+	struct btrfs_root *quota_root = fs_info->quota_root;
 	struct btrfs_path *path;
 	struct btrfs_key key;
 	struct extent_buffer *l;
@@ -752,7 +753,7 @@ static int update_qgroup_info_item(struct btrfs_trans_handle *trans,
 	int ret;
 	int slot;
 
-	if (btrfs_is_testing(root->fs_info))
+	if (btrfs_is_testing(fs_info))
 		return 0;
 
 	key.objectid = 0;
@@ -763,7 +764,7 @@ static int update_qgroup_info_item(struct btrfs_trans_handle *trans,
 	if (!path)
 		return -ENOMEM;
 
-	ret = btrfs_search_slot(trans, root, &key, path, 0, 1);
+	ret = btrfs_search_slot(trans, quota_root, &key, path, 0, 1);
 	if (ret > 0)
 		ret = -ENOENT;
 
@@ -2209,7 +2210,7 @@ int btrfs_run_qgroups(struct btrfs_trans_handle *trans,
 					  struct btrfs_qgroup, dirty);
 		list_del_init(&qgroup->dirty);
 		spin_unlock(&fs_info->qgroup_lock);
-		ret = update_qgroup_info_item(trans, quota_root, qgroup);
+		ret = update_qgroup_info_item(trans, qgroup);
 		if (ret)
 			fs_info->qgroup_flags |=
 					BTRFS_QGROUP_STATUS_FLAG_INCONSISTENT;
-- 
2.18.0



