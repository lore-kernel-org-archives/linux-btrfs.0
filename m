Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:6307 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726180AbeGRHWW (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 18 Jul 2018 03:22:22 -0400
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (unknown [10.167.33.83])
        by cn.fujitsu.com (Postfix) with ESMTP id 1DAAA4B5CF56
        for <linux-btrfs@vger.kernel.org>; Wed, 18 Jul 2018 14:46:02 +0800 (CST)
From: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 06/19] btrfs: qgroup: Drop quota_root and fs_info parameters from update_qgroup_status_item
Date: Wed, 18 Jul 2018 14:45:29 +0800
Message-ID: <20180718064542.2730-7-lufq.fnst@cn.fujitsu.com>
In-Reply-To: <20180718064542.2730-1-lufq.fnst@cn.fujitsu.com>
References: <20180718064542.2730-1-lufq.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

They can be fetched from the transaction handle.

Signed-off-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
---
 fs/btrfs/qgroup.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index d405b09ca6db..73608075db4e 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -787,10 +787,10 @@ static int update_qgroup_info_item(struct btrfs_trans_handle *trans,
 	return ret;
 }
 
-static int update_qgroup_status_item(struct btrfs_trans_handle *trans,
-				     struct btrfs_fs_info *fs_info,
-				    struct btrfs_root *root)
+static int update_qgroup_status_item(struct btrfs_trans_handle *trans)
 {
+	struct btrfs_fs_info *fs_info = trans->fs_info;
+	struct btrfs_root *quota_root = fs_info->quota_root;
 	struct btrfs_path *path;
 	struct btrfs_key key;
 	struct extent_buffer *l;
@@ -806,7 +806,7 @@ static int update_qgroup_status_item(struct btrfs_trans_handle *trans,
 	if (!path)
 		return -ENOMEM;
 
-	ret = btrfs_search_slot(trans, root, &key, path, 0, 1);
+	ret = btrfs_search_slot(trans, quota_root, &key, path, 0, 1);
 	if (ret > 0)
 		ret = -ENOENT;
 
@@ -2226,7 +2226,7 @@ int btrfs_run_qgroups(struct btrfs_trans_handle *trans,
 		fs_info->qgroup_flags &= ~BTRFS_QGROUP_STATUS_FLAG_ON;
 	spin_unlock(&fs_info->qgroup_lock);
 
-	ret = update_qgroup_status_item(trans, fs_info, quota_root);
+	ret = update_qgroup_status_item(trans);
 	if (ret)
 		fs_info->qgroup_flags |= BTRFS_QGROUP_STATUS_FLAG_INCONSISTENT;
 
@@ -2794,7 +2794,7 @@ static void btrfs_qgroup_rescan_worker(struct btrfs_work *work)
 			  err);
 		goto done;
 	}
-	ret = update_qgroup_status_item(trans, fs_info, fs_info->quota_root);
+	ret = update_qgroup_status_item(trans);
 	if (ret < 0) {
 		err = ret;
 		btrfs_err(fs_info, "fail to update qgroup status: %d", err);
-- 
2.18.0



