Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:48662 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729306AbeGRHWh (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 18 Jul 2018 03:22:37 -0400
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (unknown [10.167.33.83])
        by cn.fujitsu.com (Postfix) with ESMTP id BE2934B5CD80
        for <linux-btrfs@vger.kernel.org>; Wed, 18 Jul 2018 14:46:11 +0800 (CST)
From: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 18/19] btrfs: qgroup: Drop fs_info parameter from btrfs_qgroup_inherit
Date: Wed, 18 Jul 2018 14:45:41 +0800
Message-ID: <20180718064542.2730-19-lufq.fnst@cn.fujitsu.com>
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
 fs/btrfs/qgroup.c      | 6 +++---
 fs/btrfs/qgroup.h      | 5 ++---
 fs/btrfs/transaction.c | 3 +--
 4 files changed, 7 insertions(+), 9 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index e78836df93ff..1f8f8a34aaec 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -601,7 +601,7 @@ static noinline int create_subvol(struct inode *dir,
 	trans->block_rsv = &block_rsv;
 	trans->bytes_reserved = block_rsv.size;
 
-	ret = btrfs_qgroup_inherit(trans, fs_info, 0, objectid, inherit);
+	ret = btrfs_qgroup_inherit(trans, 0, objectid, inherit);
 	if (ret)
 		goto fail;
 
diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index b96f344cfb7e..98eb2e314030 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -2239,13 +2239,13 @@ int btrfs_run_qgroups(struct btrfs_trans_handle *trans)
  * cause a transaction abort so we take extra care here to only error
  * when a readonly fs is a reasonable outcome.
  */
-int btrfs_qgroup_inherit(struct btrfs_trans_handle *trans,
-			 struct btrfs_fs_info *fs_info, u64 srcid, u64 objectid,
-			 struct btrfs_qgroup_inherit *inherit)
+int btrfs_qgroup_inherit(struct btrfs_trans_handle *trans, u64 srcid,
+			 u64 objectid, struct btrfs_qgroup_inherit *inherit)
 {
 	int ret = 0;
 	int i;
 	u64 *i_qgroups;
+	struct btrfs_fs_info *fs_info = trans->fs_info;
 	struct btrfs_root *quota_root = fs_info->quota_root;
 	struct btrfs_qgroup *srcgroup;
 	struct btrfs_qgroup *dstgroup;
diff --git a/fs/btrfs/qgroup.h b/fs/btrfs/qgroup.h
index 2c8960f9028c..54b8bb282c0e 100644
--- a/fs/btrfs/qgroup.h
+++ b/fs/btrfs/qgroup.h
@@ -241,9 +241,8 @@ int btrfs_qgroup_account_extent(struct btrfs_trans_handle *trans, u64 bytenr,
 				struct ulist *new_roots);
 int btrfs_qgroup_account_extents(struct btrfs_trans_handle *trans);
 int btrfs_run_qgroups(struct btrfs_trans_handle *trans);
-int btrfs_qgroup_inherit(struct btrfs_trans_handle *trans,
-			 struct btrfs_fs_info *fs_info, u64 srcid, u64 objectid,
-			 struct btrfs_qgroup_inherit *inherit);
+int btrfs_qgroup_inherit(struct btrfs_trans_handle *trans, u64 srcid,
+			 u64 objectid, struct btrfs_qgroup_inherit *inherit);
 void btrfs_qgroup_free_refroot(struct btrfs_fs_info *fs_info,
 			       u64 ref_root, u64 num_bytes,
 			       enum btrfs_qgroup_rsv_type type);
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 0cbd55c498a1..aec208cbff00 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -1355,8 +1355,7 @@ static int qgroup_account_snapshot(struct btrfs_trans_handle *trans,
 		goto out;
 
 	/* Now qgroup are all updated, we can inherit it to new qgroups */
-	ret = btrfs_qgroup_inherit(trans, fs_info,
-				   src->root_key.objectid, dst_objectid,
+	ret = btrfs_qgroup_inherit(trans, src->root_key.objectid, dst_objectid,
 				   inherit);
 	if (ret < 0)
 		goto out;
-- 
2.18.0



