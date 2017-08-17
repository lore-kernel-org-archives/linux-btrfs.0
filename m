Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:43185 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750857AbdHQOZN (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 17 Aug 2017 10:25:13 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 5571EAC78
        for <linux-btrfs@vger.kernel.org>; Thu, 17 Aug 2017 14:25:12 +0000 (UTC)
Subject: [PATCH v2] btrfs: pass fs_info to btrfs_del_root instead of tree_root
To: linux-btrfs@vger.kernel.org
References: <20170802195453.32471-1-jeffm@suse.com>
From: Jeff Mahoney <jeffm@suse.com>
Message-ID: <d03588ec-2449-41ab-fd1a-8fefc5b879fa@suse.com>
Date: Thu, 17 Aug 2017 10:25:11 -0400
MIME-Version: 1.0
In-Reply-To: <20170802195453.32471-1-jeffm@suse.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

btrfs_del_roots always uses the tree_root.  Let's pass fs_info instead.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 fs/btrfs/ctree.h           | 4 ++--
 fs/btrfs/extent-tree.c     | 2 +-
 fs/btrfs/free-space-tree.c | 2 +-
 fs/btrfs/qgroup.c          | 3 +--
 fs/btrfs/root-tree.c       | 7 ++++---
 5 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 2ec2b24c0fec..044ca9b65a7b 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -2979,8 +2979,8 @@ int btrfs_del_root_ref(struct btrfs_trans_handle *trans,
 		       struct btrfs_fs_info *fs_info,
 		       u64 root_id, u64 ref_id, u64 dirid, u64 *sequence,
 		       const char *name, int name_len);
-int btrfs_del_root(struct btrfs_trans_handle *trans, struct btrfs_root *root,
-		   const struct btrfs_key *key);
+int btrfs_del_root(struct btrfs_trans_handle *trans,
+		   struct btrfs_fs_info *fs_info, const struct btrfs_key *key);
 int btrfs_insert_root(struct btrfs_trans_handle *trans, struct btrfs_root *root,
 		      const struct btrfs_key *key,
 		      struct btrfs_root_item *item);
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 116c5615d6c2..69eee2667720 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -9184,7 +9184,7 @@ int btrfs_drop_snapshot(struct btrfs_root *root,
 	if (err)
 		goto out_end_trans;
 
-	ret = btrfs_del_root(trans, tree_root, &root->root_key);
+	ret = btrfs_del_root(trans, fs_info, &root->root_key);
 	if (ret) {
 		btrfs_abort_transaction(trans, ret);
 		goto out_end_trans;
diff --git a/fs/btrfs/free-space-tree.c b/fs/btrfs/free-space-tree.c
index a5e34de06c2f..684f12247db7 100644
--- a/fs/btrfs/free-space-tree.c
+++ b/fs/btrfs/free-space-tree.c
@@ -1257,7 +1257,7 @@ int btrfs_clear_free_space_tree(struct btrfs_fs_info *fs_info)
 	if (ret)
 		goto abort;
 
-	ret = btrfs_del_root(trans, tree_root, &free_space_root->root_key);
+	ret = btrfs_del_root(trans, fs_info, &free_space_root->root_key);
 	if (ret)
 		goto abort;
 
diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index ddc37c537058..5c8b61c86e61 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -946,7 +946,6 @@ int btrfs_quota_enable(struct btrfs_trans_handle *trans,
 int btrfs_quota_disable(struct btrfs_trans_handle *trans,
 			struct btrfs_fs_info *fs_info)
 {
-	struct btrfs_root *tree_root = fs_info->tree_root;
 	struct btrfs_root *quota_root;
 	int ret = 0;
 
@@ -968,7 +967,7 @@ int btrfs_quota_disable(struct btrfs_trans_handle *trans,
 	if (ret)
 		goto out;
 
-	ret = btrfs_del_root(trans, tree_root, &quota_root->root_key);
+	ret = btrfs_del_root(trans, fs_info, &quota_root->root_key);
 	if (ret)
 		goto out;
 
diff --git a/fs/btrfs/root-tree.c b/fs/btrfs/root-tree.c
index 5b488af6f25e..9fb9896610e0 100644
--- a/fs/btrfs/root-tree.c
+++ b/fs/btrfs/root-tree.c
@@ -335,10 +335,11 @@ int btrfs_find_orphan_roots(struct btrfs_fs_info *fs_info)
 	return err;
 }
 
-/* drop the root item for 'key' from 'root' */
-int btrfs_del_root(struct btrfs_trans_handle *trans, struct btrfs_root *root,
-		   const struct btrfs_key *key)
+/* drop the root item for 'key' from the tree root */
+int btrfs_del_root(struct btrfs_trans_handle *trans,
+		   struct btrfs_fs_info *fs_info, const struct btrfs_key *key)
 {
+	struct btrfs_root *root = fs_info->tree_root;
 	struct btrfs_path *path;
 	int ret;
 

