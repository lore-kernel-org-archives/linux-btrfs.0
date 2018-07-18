Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:6307 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726180AbeGRHW0 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 18 Jul 2018 03:22:26 -0400
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (unknown [10.167.33.83])
        by cn.fujitsu.com (Postfix) with ESMTP id 018B148029E5
        for <linux-btrfs@vger.kernel.org>; Wed, 18 Jul 2018 14:45:59 +0800 (CST)
From: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 01/19] btrfs: qgroup: Drop quota_root parameter from add_qgroup_relation_item
Date: Wed, 18 Jul 2018 14:45:24 +0800
Message-ID: <20180718064542.2730-2-lufq.fnst@cn.fujitsu.com>
In-Reply-To: <20180718064542.2730-1-lufq.fnst@cn.fujitsu.com>
References: <20180718064542.2730-1-lufq.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

It can be fetched from the transaction handle.

Signed-off-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
---
 fs/btrfs/qgroup.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index 06e0e9b39340..489f0ff8036e 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -530,11 +530,11 @@ void btrfs_free_qgroup_config(struct btrfs_fs_info *fs_info)
 	fs_info->qgroup_ulist = NULL;
 }
 
-static int add_qgroup_relation_item(struct btrfs_trans_handle *trans,
-				    struct btrfs_root *quota_root,
-				    u64 src, u64 dst)
+static int add_qgroup_relation_item(struct btrfs_trans_handle *trans, u64 src,
+				    u64 dst)
 {
 	int ret;
+	struct btrfs_root *quota_root = trans->fs_info->quota_root;
 	struct btrfs_path *path;
 	struct btrfs_key key;
 
@@ -1273,11 +1273,11 @@ int btrfs_add_qgroup_relation(struct btrfs_trans_handle *trans,
 		}
 	}
 
-	ret = add_qgroup_relation_item(trans, quota_root, src, dst);
+	ret = add_qgroup_relation_item(trans, src, dst);
 	if (ret)
 		goto out;
 
-	ret = add_qgroup_relation_item(trans, quota_root, dst, src);
+	ret = add_qgroup_relation_item(trans, dst, src);
 	if (ret) {
 		del_qgroup_relation_item(trans, quota_root, src, dst);
 		goto out;
@@ -2294,12 +2294,12 @@ int btrfs_qgroup_inherit(struct btrfs_trans_handle *trans,
 		for (i = 0; i < inherit->num_qgroups; ++i, ++i_qgroups) {
 			if (*i_qgroups == 0)
 				continue;
-			ret = add_qgroup_relation_item(trans, quota_root,
-						       objectid, *i_qgroups);
+			ret = add_qgroup_relation_item(trans, objectid,
+						       *i_qgroups);
 			if (ret && ret != -EEXIST)
 				goto out;
-			ret = add_qgroup_relation_item(trans, quota_root,
-						       *i_qgroups, objectid);
+			ret = add_qgroup_relation_item(trans, *i_qgroups,
+						       objectid);
 			if (ret && ret != -EEXIST)
 				goto out;
 		}
-- 
2.18.0



