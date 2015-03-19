Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:38965 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751475AbbCSGE7 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 19 Mar 2015 02:04:59 -0400
From: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>, <dsterba@suse.cz>, <jbacik@fb.com>,
        <clm@fb.com>
CC: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
Subject: [PATCH 4/7] Btrfs: qgroup: update all infos and limits to disk.
Date: Thu, 19 Mar 2015 14:01:01 +0800
Message-ID: <1426744864-7031-9-git-send-email-yangds.fnst@cn.fujitsu.com>
In-Reply-To: <1426744864-7031-1-git-send-email-yangds.fnst@cn.fujitsu.com>
References: <1426744864-7031-1-git-send-email-yangds.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

There are not only one info for a qgroup, then we need
to store the all infos and limits to disk.

Signed-off-by: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
---
 fs/btrfs/qgroup.c | 52 ++++++++++++++++++++++++++++++++++++++++------------
 1 file changed, 40 insertions(+), 12 deletions(-)

diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index 9dd2627..5df8527 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -624,6 +624,8 @@ info_again:
 
 	if (btrfs_fs_incompat(quota_root->fs_info, QGROUP_TYPE))
 		key.objectid = BTRFS_QGROUP_DATA_LIMIT_OBJECTID;
+	else
+		key.objectid = 0;
 
 	key.type = BTRFS_QGROUP_LIMIT_KEY;
 
@@ -700,6 +702,8 @@ info_again:
 
 	if (btrfs_fs_incompat(quota_root->fs_info, QGROUP_TYPE))
 		key.objectid = BTRFS_QGROUP_DATA_LIMIT_OBJECTID;
+	else
+		key.objectid = 0;
 
 	key.type = BTRFS_QGROUP_LIMIT_KEY;
 
@@ -739,14 +743,21 @@ static int update_qgroup_limit_item(struct btrfs_trans_handle *trans,
 	int ret;
 	int slot;
 
-	key.objectid = 0;
+	if (!btrfs_fs_incompat(root->fs_info, QGROUP_TYPE)) {
+		key.objectid = 0;
+		limits = &qgroup->mixed_limits;
+	} else {
+		key.objectid = BTRFS_QGROUP_DATA_LIMIT_OBJECTID;
+		limits = &qgroup->data_limits;
+	}
+
 	key.type = BTRFS_QGROUP_LIMIT_KEY;
 	key.offset = qgroup->qgroupid;
 
 	path = btrfs_alloc_path();
 	if (!path)
 		return -ENOMEM;
-
+again:
 	ret = btrfs_search_slot(trans, root, &key, path, 0, 1);
 	if (ret > 0)
 		ret = -ENOENT;
@@ -754,8 +765,6 @@ static int update_qgroup_limit_item(struct btrfs_trans_handle *trans,
 	if (ret)
 		goto out;
 
-	limits = &qgroup->mixed_limits;
-
 	l = path->nodes[0];
 	slot = path->slots[0];
 	qgroup_limit = btrfs_item_ptr(l, slot, struct btrfs_qgroup_limit_item);
@@ -766,6 +775,14 @@ static int update_qgroup_limit_item(struct btrfs_trans_handle *trans,
 	btrfs_set_qgroup_limit_rsv_excl(l, qgroup_limit, limits->rsv_excl);
 
 	btrfs_mark_buffer_dirty(l);
+	btrfs_release_path(path);
+
+	if (btrfs_fs_incompat(root->fs_info, QGROUP_TYPE) &&
+	    key.objectid != BTRFS_QGROUP_MIXED_LIMIT_OBJECTID) {
+		key.objectid++;
+		limits++;
+		goto again;
+	}
 
 out:
 	btrfs_free_path(path);
@@ -780,14 +797,18 @@ static int update_qgroup_info_item(struct btrfs_trans_handle *trans,
 	struct btrfs_key key;
 	struct extent_buffer *l;
 	struct btrfs_qgroup_info_item *qgroup_info;
-	struct btrfs_qgroup_info *data_info;
+	struct btrfs_qgroup_info *info;
 	int ret;
 	int slot;
 
 	if (btrfs_test_is_dummy_root(root))
 		return 0;
 
-	key.objectid = 0;
+	if (!btrfs_fs_incompat(root->fs_info, QGROUP_TYPE))
+		key.objectid = 0;
+	else
+		key.objectid = BTRFS_QGROUP_DATA_INFO_OBJECTID;
+
 	key.type = BTRFS_QGROUP_INFO_KEY;
 	key.offset = qgroup->qgroupid;
 
@@ -795,6 +816,8 @@ static int update_qgroup_info_item(struct btrfs_trans_handle *trans,
 	if (!path)
 		return -ENOMEM;
 
+	info = &qgroup->data_info;
+again:
 	ret = btrfs_search_slot(trans, root, &key, path, 0, 1);
 	if (ret > 0)
 		ret = -ENOENT;
@@ -802,19 +825,24 @@ static int update_qgroup_info_item(struct btrfs_trans_handle *trans,
 	if (ret)
 		goto out;
 
-	data_info = &qgroup->data_info;
-
 	l = path->nodes[0];
 	slot = path->slots[0];
 	qgroup_info = btrfs_item_ptr(l, slot, struct btrfs_qgroup_info_item);
 	btrfs_set_qgroup_info_generation(l, qgroup_info, trans->transid);
-	btrfs_set_qgroup_info_rfer(l, qgroup_info, data_info->rfer);
-	btrfs_set_qgroup_info_rfer_cmpr(l, qgroup_info, data_info->rfer_cmpr);
-	btrfs_set_qgroup_info_excl(l, qgroup_info, data_info->excl);
-	btrfs_set_qgroup_info_excl_cmpr(l, qgroup_info, data_info->excl_cmpr);
+	btrfs_set_qgroup_info_rfer(l, qgroup_info, info->rfer);
+	btrfs_set_qgroup_info_rfer_cmpr(l, qgroup_info, info->rfer_cmpr);
+	btrfs_set_qgroup_info_excl(l, qgroup_info, info->excl);
+	btrfs_set_qgroup_info_excl_cmpr(l, qgroup_info, info->excl_cmpr);
 
 	btrfs_mark_buffer_dirty(l);
+	btrfs_release_path(path);
 
+	if (btrfs_fs_incompat(root->fs_info, QGROUP_TYPE) &&
+	    key.objectid != BTRFS_QGROUP_METADATA_INFO_OBJECTID) {
+		key.objectid++;
+		info++;
+		goto again;
+	}
 out:
 	btrfs_free_path(path);
 	return ret;
-- 
1.8.4.2

