Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:39334 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726960AbeHAFQK (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 1 Aug 2018 01:16:10 -0400
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (unknown [10.167.33.83])
        by cn.fujitsu.com (Postfix) with ESMTP id D18794B41ED3
        for <linux-btrfs@vger.kernel.org>; Wed,  1 Aug 2018 11:32:39 +0800 (CST)
From: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 3/7] btrfs: Remove fs_info from btrfs_del_root
Date: Wed, 1 Aug 2018 11:32:27 +0800
Message-ID: <20180801033231.23166-4-lufq.fnst@cn.fujitsu.com>
In-Reply-To: <20180801033231.23166-1-lufq.fnst@cn.fujitsu.com>
References: <20180801033231.23166-1-lufq.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

It can be referenced from the passed transaction handle.

Signed-off-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
---
 fs/btrfs/ctree.h           | 2 +-
 fs/btrfs/extent-tree.c     | 2 +-
 fs/btrfs/free-space-tree.c | 2 +-
 fs/btrfs/qgroup.c          | 2 +-
 fs/btrfs/root-tree.c       | 4 ++--
 5 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 2e32584c635f..9ef47a171e2f 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -2993,7 +2993,7 @@ int btrfs_del_root_ref(struct btrfs_trans_handle *trans,
 		       u64 root_id, u64 ref_id, u64 dirid, u64 *sequence,
 		       const char *name, int name_len);
 int btrfs_del_root(struct btrfs_trans_handle *trans,
-		   struct btrfs_fs_info *fs_info, const struct btrfs_key *key);
+		   const struct btrfs_key *key);
 int btrfs_insert_root(struct btrfs_trans_handle *trans, struct btrfs_root *root,
 		      const struct btrfs_key *key,
 		      struct btrfs_root_item *item);
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index fcaf598f4222..042dd4186fb8 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -9028,7 +9028,7 @@ int btrfs_drop_snapshot(struct btrfs_root *root,
 	if (err)
 		goto out_end_trans;
 
-	ret = btrfs_del_root(trans, fs_info, &root->root_key);
+	ret = btrfs_del_root(trans, &root->root_key);
 	if (ret) {
 		btrfs_abort_transaction(trans, ret);
 		err = ret;
diff --git a/fs/btrfs/free-space-tree.c b/fs/btrfs/free-space-tree.c
index b5950aacd697..d6736595ec57 100644
--- a/fs/btrfs/free-space-tree.c
+++ b/fs/btrfs/free-space-tree.c
@@ -1236,7 +1236,7 @@ int btrfs_clear_free_space_tree(struct btrfs_fs_info *fs_info)
 	if (ret)
 		goto abort;
 
-	ret = btrfs_del_root(trans, fs_info, &free_space_root->root_key);
+	ret = btrfs_del_root(trans, &free_space_root->root_key);
 	if (ret)
 		goto abort;
 
diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index dd30c5921dcd..2ba29f0609d9 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -1087,7 +1087,7 @@ int btrfs_quota_disable(struct btrfs_fs_info *fs_info)
 		goto end_trans;
 	}
 
-	ret = btrfs_del_root(trans, fs_info, &quota_root->root_key);
+	ret = btrfs_del_root(trans, &quota_root->root_key);
 	if (ret) {
 		btrfs_abort_transaction(trans, ret);
 		goto end_trans;
diff --git a/fs/btrfs/root-tree.c b/fs/btrfs/root-tree.c
index c451285976ac..f7c14c454f91 100644
--- a/fs/btrfs/root-tree.c
+++ b/fs/btrfs/root-tree.c
@@ -320,9 +320,9 @@ int btrfs_find_orphan_roots(struct btrfs_fs_info *fs_info)
 
 /* drop the root item for 'key' from the tree root */
 int btrfs_del_root(struct btrfs_trans_handle *trans,
-		   struct btrfs_fs_info *fs_info, const struct btrfs_key *key)
+		   const struct btrfs_key *key)
 {
-	struct btrfs_root *root = fs_info->tree_root;
+	struct btrfs_root *root = trans->fs_info->tree_root;
 	struct btrfs_path *path;
 	int ret;
 
-- 
2.18.0



