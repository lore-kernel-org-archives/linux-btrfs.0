Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:62294 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750951AbbCSGEy (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 19 Mar 2015 02:04:54 -0400
From: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>, <dsterba@suse.cz>, <jbacik@fb.com>,
        <clm@fb.com>
CC: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
Subject: [PATCH 2/7] Btrfs: qgroup: add incompatability feature for QGROUP_TYPE.
Date: Thu, 19 Mar 2015 14:00:57 +0800
Message-ID: <1426744864-7031-5-git-send-email-yangds.fnst@cn.fujitsu.com>
In-Reply-To: <1426744864-7031-1-git-send-email-yangds.fnst@cn.fujitsu.com>
References: <1426744864-7031-1-git-send-email-yangds.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

As we need to change the structure in disk for qgroup, we have
to introduce a incompatability feature for it.

------------------------------------              ------------------------------------------------
|0 |BTRFS_QGROUP_INFO_KEY |qgroupid| ------------>|TYPE_OBJECTID |BTRFS_QGROUP_INFO_KEY |qgroupid|
------------------------------------              ------------------------------------------------

similar for the limits.

Signed-off-by: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
---
 fs/btrfs/ctree.h  | 20 ++++++++++++++-
 fs/btrfs/qgroup.c | 77 +++++++++++++++++++++++++++++++++++++++++++++++++++----
 2 files changed, 91 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index f00eacd..d029119 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -150,6 +150,22 @@ struct btrfs_ordered_sum;
 #define BTRFS_DEV_REPLACE_DEVID 0ULL
 
 /*
+ * the items for qgroup info.
+ */
+#define BTRFS_QGROUP_DATA_INFO_OBJECTID 1ULL
+
+#define BTRFS_QGROUP_METADATA_INFO_OBJECTID 2ULL
+
+/*
+ * the items for qgroup limits.
+ */
+#define BTRFS_QGROUP_DATA_LIMIT_OBJECTID 1ULL
+
+#define BTRFS_QGROUP_METADATA_LIMIT_OBJECTID 2ULL
+
+#define BTRFS_QGROUP_MIXED_LIMIT_OBJECTID 3ULL
+
+/*
  * the max metadata block size.  This limit is somewhat artificial,
  * but the memmove costs go through the roof for larger blocks.
  */
@@ -522,6 +538,7 @@ struct btrfs_super_block {
 #define BTRFS_FEATURE_INCOMPAT_RAID56		(1ULL << 7)
 #define BTRFS_FEATURE_INCOMPAT_SKINNY_METADATA	(1ULL << 8)
 #define BTRFS_FEATURE_INCOMPAT_NO_HOLES		(1ULL << 9)
+#define BTRFS_FEATURE_INCOMPAT_QGROUP_TYPE	(1ULL << 10)
 
 #define BTRFS_FEATURE_COMPAT_SUPP		0ULL
 #define BTRFS_FEATURE_COMPAT_SAFE_SET		0ULL
@@ -539,7 +556,8 @@ struct btrfs_super_block {
 	 BTRFS_FEATURE_INCOMPAT_RAID56 |		\
 	 BTRFS_FEATURE_INCOMPAT_EXTENDED_IREF |		\
 	 BTRFS_FEATURE_INCOMPAT_SKINNY_METADATA |	\
-	 BTRFS_FEATURE_INCOMPAT_NO_HOLES)
+	 BTRFS_FEATURE_INCOMPAT_NO_HOLES |		\
+	 BTRFS_FEATURE_INCOMPAT_QGROUP_TYPE)
 
 #define BTRFS_FEATURE_INCOMPAT_SAFE_SET			\
 	(BTRFS_FEATURE_INCOMPAT_EXTENDED_IREF)
diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index dd99908..34eb4f5 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -372,7 +372,19 @@ int btrfs_read_qgroup_config(struct btrfs_fs_info *fs_info)
 			struct btrfs_qgroup_info_item *ptr;
 			struct btrfs_qgroup_info *info;
 
-			info = &qgroup->data_info;
+			/*
+			 * In newer qgroup, we store the quota data in
+			 * different info_items.
+			 */
+			if (!btrfs_fs_incompat(fs_info, QGROUP_TYPE)) {
+				info = &qgroup->data_info;
+			} else {
+				if (found_key.objectid == BTRFS_QGROUP_DATA_INFO_OBJECTID)
+					info = &qgroup->data_info;
+				else
+					info = &qgroup->metadata_info;
+			}
+
 			ptr = btrfs_item_ptr(l, slot,
 					     struct btrfs_qgroup_info_item);
 			info->rfer = btrfs_qgroup_info_rfer(l, ptr);
@@ -386,7 +398,17 @@ int btrfs_read_qgroup_config(struct btrfs_fs_info *fs_info)
 			struct btrfs_qgroup_limit_item *ptr;
 			struct btrfs_qgroup_limits *limits;
 
-			limits = &qgroup->mixed_limits;
+			if (!btrfs_fs_incompat(fs_info, QGROUP_TYPE)) {
+				limits = &qgroup->mixed_limits;
+			} else {
+				if (found_key.objectid == BTRFS_QGROUP_DATA_LIMIT_OBJECTID)
+					limits = &qgroup->data_limits;
+				else if (found_key.objectid == BTRFS_QGROUP_METADATA_LIMIT_OBJECTID)
+					limits = &qgroup->metadata_limits;
+				else
+					limits = &qgroup->mixed_limits;
+			}
+
 			ptr = btrfs_item_ptr(l, slot,
 					     struct btrfs_qgroup_limit_item);
 			limits->lim_flags = btrfs_qgroup_limit_flags(l, ptr);
@@ -563,7 +585,10 @@ static int add_qgroup_item(struct btrfs_trans_handle *trans,
 	if (!path)
 		return -ENOMEM;
 
-	key.objectid = 0;
+	if (!btrfs_fs_incompat(quota_root->fs_info, QGROUP_TYPE))
+		key.objectid = 0;
+	else
+		key.objectid = BTRFS_QGROUP_DATA_INFO_OBJECTID;
 	key.type = BTRFS_QGROUP_INFO_KEY;
 	key.offset = qgroupid;
 
@@ -573,6 +598,7 @@ static int add_qgroup_item(struct btrfs_trans_handle *trans,
 	 * on disk.
 	 */
 
+info_again:
 	ret = btrfs_insert_empty_item(trans, quota_root, path, &key,
 				      sizeof(*qgroup_info));
 	if (ret && ret != -EEXIST)
@@ -588,10 +614,20 @@ static int add_qgroup_item(struct btrfs_trans_handle *trans,
 	btrfs_set_qgroup_info_excl_cmpr(leaf, qgroup_info, 0);
 
 	btrfs_mark_buffer_dirty(leaf);
-
 	btrfs_release_path(path);
 
+	if (btrfs_fs_incompat(quota_root->fs_info, QGROUP_TYPE) &&
+	    key.objectid != BTRFS_QGROUP_METADATA_INFO_OBJECTID) {
+		key.objectid++;
+		goto info_again;
+	}
+
+	if (btrfs_fs_incompat(quota_root->fs_info, QGROUP_TYPE))
+		key.objectid = BTRFS_QGROUP_DATA_LIMIT_OBJECTID;
+
 	key.type = BTRFS_QGROUP_LIMIT_KEY;
+
+limits_again:
 	ret = btrfs_insert_empty_item(trans, quota_root, path, &key,
 				      sizeof(*qgroup_limit));
 	if (ret && ret != -EEXIST)
@@ -607,6 +643,13 @@ static int add_qgroup_item(struct btrfs_trans_handle *trans,
 	btrfs_set_qgroup_limit_rsv_excl(leaf, qgroup_limit, 0);
 
 	btrfs_mark_buffer_dirty(leaf);
+	btrfs_release_path(path);
+
+	if (btrfs_fs_incompat(quota_root->fs_info, QGROUP_TYPE) &&
+	    key.objectid != BTRFS_QGROUP_MIXED_LIMIT_OBJECTID) {
+		key.objectid++;
+		goto limits_again;
+	}
 
 	ret = 0;
 out:
@@ -625,9 +668,15 @@ static int del_qgroup_item(struct btrfs_trans_handle *trans,
 	if (!path)
 		return -ENOMEM;
 
-	key.objectid = 0;
+	if (!btrfs_fs_incompat(quota_root->fs_info, QGROUP_TYPE))
+		key.objectid = 0;
+	else
+		key.objectid = BTRFS_QGROUP_DATA_INFO_OBJECTID;
+
 	key.type = BTRFS_QGROUP_INFO_KEY;
 	key.offset = qgroupid;
+
+info_again:
 	ret = btrfs_search_slot(trans, quota_root, &key, path, -1, 1);
 	if (ret < 0)
 		goto out;
@@ -643,7 +692,18 @@ static int del_qgroup_item(struct btrfs_trans_handle *trans,
 
 	btrfs_release_path(path);
 
+	if (btrfs_fs_incompat(quota_root->fs_info, QGROUP_TYPE) &&
+	    key.objectid != BTRFS_QGROUP_METADATA_INFO_OBJECTID) {
+		key.objectid++;
+		goto info_again;
+	}
+
+	if (btrfs_fs_incompat(quota_root->fs_info, QGROUP_TYPE))
+		key.objectid = BTRFS_QGROUP_DATA_LIMIT_OBJECTID;
+
 	key.type = BTRFS_QGROUP_LIMIT_KEY;
+
+limits_again:
 	ret = btrfs_search_slot(trans, quota_root, &key, path, -1, 1);
 	if (ret < 0)
 		goto out;
@@ -654,6 +714,13 @@ static int del_qgroup_item(struct btrfs_trans_handle *trans,
 	}
 
 	ret = btrfs_del_item(trans, quota_root, path);
+	btrfs_release_path(path);
+
+	if (btrfs_fs_incompat(quota_root->fs_info, QGROUP_TYPE) &&
+	    key.objectid != BTRFS_QGROUP_MIXED_LIMIT_OBJECTID) {
+		key.objectid++;
+		goto limits_again;
+	}
 
 out:
 	btrfs_free_path(path);
-- 
1.8.4.2

