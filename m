Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:48662 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728311AbeGRHWa (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 18 Jul 2018 03:22:30 -0400
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (unknown [10.167.33.83])
        by cn.fujitsu.com (Postfix) with ESMTP id CBE554B5CD87
        for <linux-btrfs@vger.kernel.org>; Wed, 18 Jul 2018 14:46:00 +0800 (CST)
From: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 04/19] btrfs: qgroup: Drop root parameter from update_qgroup_limit_item
Date: Wed, 18 Jul 2018 14:45:27 +0800
Message-ID: <20180718064542.2730-5-lufq.fnst@cn.fujitsu.com>
In-Reply-To: <20180718064542.2730-1-lufq.fnst@cn.fujitsu.com>
References: <20180718064542.2730-1-lufq.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

It can be fetched from the transaction handle.

Signed-off-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
---
 fs/btrfs/qgroup.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index 6eb65a0e912e..763bcb3f24da 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -700,9 +700,9 @@ static int del_qgroup_item(struct btrfs_trans_handle *trans, u64 qgroupid)
 }
 
 static int update_qgroup_limit_item(struct btrfs_trans_handle *trans,
-				    struct btrfs_root *root,
 				    struct btrfs_qgroup *qgroup)
 {
+	struct btrfs_root *quota_root = trans->fs_info->quota_root;
 	struct btrfs_path *path;
 	struct btrfs_key key;
 	struct extent_buffer *l;
@@ -718,7 +718,7 @@ static int update_qgroup_limit_item(struct btrfs_trans_handle *trans,
 	if (!path)
 		return -ENOMEM;
 
-	ret = btrfs_search_slot(trans, root, &key, path, 0, 1);
+	ret = btrfs_search_slot(trans, quota_root, &key, path, 0, 1);
 	if (ret > 0)
 		ret = -ENOENT;
 
@@ -1508,7 +1508,7 @@ int btrfs_limit_qgroup(struct btrfs_trans_handle *trans,
 
 	spin_unlock(&fs_info->qgroup_lock);
 
-	ret = update_qgroup_limit_item(trans, quota_root, qgroup);
+	ret = update_qgroup_limit_item(trans, qgroup);
 	if (ret) {
 		fs_info->qgroup_flags |= BTRFS_QGROUP_STATUS_FLAG_INCONSISTENT;
 		btrfs_info(fs_info, "unable to update quota limit for %llu",
@@ -2213,7 +2213,7 @@ int btrfs_run_qgroups(struct btrfs_trans_handle *trans,
 		if (ret)
 			fs_info->qgroup_flags |=
 					BTRFS_QGROUP_STATUS_FLAG_INCONSISTENT;
-		ret = update_qgroup_limit_item(trans, quota_root, qgroup);
+		ret = update_qgroup_limit_item(trans, qgroup);
 		if (ret)
 			fs_info->qgroup_flags |=
 					BTRFS_QGROUP_STATUS_FLAG_INCONSISTENT;
@@ -2322,7 +2322,7 @@ int btrfs_qgroup_inherit(struct btrfs_trans_handle *trans,
 		dstgroup->rsv_rfer = inherit->lim.rsv_rfer;
 		dstgroup->rsv_excl = inherit->lim.rsv_excl;
 
-		ret = update_qgroup_limit_item(trans, quota_root, dstgroup);
+		ret = update_qgroup_limit_item(trans, dstgroup);
 		if (ret) {
 			fs_info->qgroup_flags |= BTRFS_QGROUP_STATUS_FLAG_INCONSISTENT;
 			btrfs_info(fs_info,
-- 
2.18.0



