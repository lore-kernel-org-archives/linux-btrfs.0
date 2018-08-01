Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:65449 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726688AbeHAFQJ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 1 Aug 2018 01:16:09 -0400
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (unknown [10.167.33.83])
        by cn.fujitsu.com (Postfix) with ESMTP id 01CDC4B66B9F
        for <linux-btrfs@vger.kernel.org>; Wed,  1 Aug 2018 11:32:39 +0800 (CST)
From: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 2/7] btrfs: Remove fs_info from btrfs_delete_delayed_dir_index
Date: Wed, 1 Aug 2018 11:32:26 +0800
Message-ID: <20180801033231.23166-3-lufq.fnst@cn.fujitsu.com>
In-Reply-To: <20180801033231.23166-1-lufq.fnst@cn.fujitsu.com>
References: <20180801033231.23166-1-lufq.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

It can be referenced from the passed transaction handle.

Signed-off-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
---
 fs/btrfs/delayed-inode.c | 6 +++---
 fs/btrfs/delayed-inode.h | 1 -
 fs/btrfs/inode.c         | 4 ++--
 3 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/delayed-inode.c b/fs/btrfs/delayed-inode.c
index 5d103eda1874..f51b509f2d9b 100644
--- a/fs/btrfs/delayed-inode.c
+++ b/fs/btrfs/delayed-inode.c
@@ -1493,7 +1493,6 @@ static int btrfs_delete_delayed_insertion_item(struct btrfs_fs_info *fs_info,
 }
 
 int btrfs_delete_delayed_dir_index(struct btrfs_trans_handle *trans,
-				   struct btrfs_fs_info *fs_info,
 				   struct btrfs_inode *dir, u64 index)
 {
 	struct btrfs_delayed_node *node;
@@ -1509,7 +1508,8 @@ int btrfs_delete_delayed_dir_index(struct btrfs_trans_handle *trans,
 	item_key.type = BTRFS_DIR_INDEX_KEY;
 	item_key.offset = index;
 
-	ret = btrfs_delete_delayed_insertion_item(fs_info, node, &item_key);
+	ret = btrfs_delete_delayed_insertion_item(trans->fs_info, node,
+						  &item_key);
 	if (!ret)
 		goto end;
 
@@ -1531,7 +1531,7 @@ int btrfs_delete_delayed_dir_index(struct btrfs_trans_handle *trans,
 	mutex_lock(&node->mutex);
 	ret = __btrfs_add_delayed_deletion_item(node, item);
 	if (unlikely(ret)) {
-		btrfs_err(fs_info,
+		btrfs_err(trans->fs_info,
 			  "err add delayed dir index item(index: %llu) into the deletion tree of the delayed node(root id: %llu, inode id: %llu, errno: %d)",
 			  index, node->root->objectid, node->inode_id, ret);
 		BUG();
diff --git a/fs/btrfs/delayed-inode.h b/fs/btrfs/delayed-inode.h
index 44558ededcf5..33536cd681d4 100644
--- a/fs/btrfs/delayed-inode.h
+++ b/fs/btrfs/delayed-inode.h
@@ -92,7 +92,6 @@ int btrfs_insert_delayed_dir_index(struct btrfs_trans_handle *trans,
 				   u64 index);
 
 int btrfs_delete_delayed_dir_index(struct btrfs_trans_handle *trans,
-				   struct btrfs_fs_info *fs_info,
 				   struct btrfs_inode *dir, u64 index);
 
 int btrfs_inode_delayed_dir_index_count(struct btrfs_inode *inode);
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 472457795486..59b3ea32b6de 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -3978,7 +3978,7 @@ static int __btrfs_unlink_inode(struct btrfs_trans_handle *trans,
 		goto err;
 	}
 skip_backref:
-	ret = btrfs_delete_delayed_dir_index(trans, fs_info, dir, index);
+	ret = btrfs_delete_delayed_dir_index(trans, dir, index);
 	if (ret) {
 		btrfs_abort_transaction(trans, ret);
 		goto err;
@@ -4144,7 +4144,7 @@ static int btrfs_unlink_subvol(struct btrfs_trans_handle *trans,
 	}
 	btrfs_release_path(path);
 
-	ret = btrfs_delete_delayed_dir_index(trans, fs_info, BTRFS_I(dir), index);
+	ret = btrfs_delete_delayed_dir_index(trans, BTRFS_I(dir), index);
 	if (ret) {
 		btrfs_abort_transaction(trans, ret);
 		goto out;
-- 
2.18.0



