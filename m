Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:39334 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726960AbeHAFQF (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 1 Aug 2018 01:16:05 -0400
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (unknown [10.167.33.83])
        by cn.fujitsu.com (Postfix) with ESMTP id 69B684B6ADE1
        for <linux-btrfs@vger.kernel.org>; Wed,  1 Aug 2018 11:32:38 +0800 (CST)
From: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 1/7] btrfs: Remove fs_info from btrfs_insert_delayed_dir_index
Date: Wed, 1 Aug 2018 11:32:25 +0800
Message-ID: <20180801033231.23166-2-lufq.fnst@cn.fujitsu.com>
In-Reply-To: <20180801033231.23166-1-lufq.fnst@cn.fujitsu.com>
References: <20180801033231.23166-1-lufq.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

It can be referenced from the passed transaction handle.

Signed-off-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
---
 fs/btrfs/delayed-inode.c | 4 +---
 fs/btrfs/delayed-inode.h | 1 -
 fs/btrfs/dir-item.c      | 4 ++--
 3 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/delayed-inode.c b/fs/btrfs/delayed-inode.c
index 596d2af0c8aa..5d103eda1874 100644
--- a/fs/btrfs/delayed-inode.c
+++ b/fs/btrfs/delayed-inode.c
@@ -1418,7 +1418,6 @@ void btrfs_balance_delayed_items(struct btrfs_fs_info *fs_info)
 
 /* Will return 0 or -ENOMEM */
 int btrfs_insert_delayed_dir_index(struct btrfs_trans_handle *trans,
-				   struct btrfs_fs_info *fs_info,
 				   const char *name, int name_len,
 				   struct btrfs_inode *dir,
 				   struct btrfs_disk_key *disk_key, u8 type,
@@ -1458,11 +1457,10 @@ int btrfs_insert_delayed_dir_index(struct btrfs_trans_handle *trans,
 	 */
 	BUG_ON(ret);
 
-
 	mutex_lock(&delayed_node->mutex);
 	ret = __btrfs_add_delayed_insertion_item(delayed_node, delayed_item);
 	if (unlikely(ret)) {
-		btrfs_err(fs_info,
+		btrfs_err(trans->fs_info,
 			  "err add delayed dir index item(name: %.*s) into the insertion tree of the delayed node(root id: %llu, inode id: %llu, errno: %d)",
 			  name_len, name, delayed_node->root->objectid,
 			  delayed_node->inode_id, ret);
diff --git a/fs/btrfs/delayed-inode.h b/fs/btrfs/delayed-inode.h
index ca7a97f3ab6b..44558ededcf5 100644
--- a/fs/btrfs/delayed-inode.h
+++ b/fs/btrfs/delayed-inode.h
@@ -86,7 +86,6 @@ static inline void btrfs_init_delayed_root(
 }
 
 int btrfs_insert_delayed_dir_index(struct btrfs_trans_handle *trans,
-				   struct btrfs_fs_info *fs_info,
 				   const char *name, int name_len,
 				   struct btrfs_inode *dir,
 				   struct btrfs_disk_key *disk_key, u8 type,
diff --git a/fs/btrfs/dir-item.c b/fs/btrfs/dir-item.c
index 39e9766d1cbd..a678b07fcf01 100644
--- a/fs/btrfs/dir-item.c
+++ b/fs/btrfs/dir-item.c
@@ -160,8 +160,8 @@ int btrfs_insert_dir_item(struct btrfs_trans_handle *trans, struct btrfs_root
 	}
 	btrfs_release_path(path);
 
-	ret2 = btrfs_insert_delayed_dir_index(trans, root->fs_info, name,
-			name_len, dir, &disk_key, type, index);
+	ret2 = btrfs_insert_delayed_dir_index(trans, name, name_len, dir,
+					      &disk_key, type, index);
 out_free:
 	btrfs_free_path(path);
 	if (ret)
-- 
2.18.0



