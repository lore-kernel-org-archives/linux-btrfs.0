Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:58644 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753130AbbBYSZI (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 25 Feb 2015 13:25:08 -0500
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id D005EAAC8
	for <linux-btrfs@vger.kernel.org>; Wed, 25 Feb 2015 18:25:07 +0000 (UTC)
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>
Subject: [PATCH 11/11] btrfs: use explicit initializer for seq_elem
Date: Wed, 25 Feb 2015 19:25:07 +0100
Message-Id: <740f7e13af29eab07ba4cf1439dc3dfd79748cb5.1424880058.git.dsterba@suse.cz>
In-Reply-To: <cover.1424880058.git.dsterba@suse.cz>
References: <cover.1424880058.git.dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Using {} as initializer for struct seq_elem does not properly initialize
the list_head member, but it currently works because it gets set through
btrfs_get_tree_mod_seq if 'seq' is 0.

Signed-off-by: David Sterba <dsterba@suse.cz>
---
 fs/btrfs/backref.c | 4 ++--
 fs/btrfs/ctree.h   | 2 ++
 fs/btrfs/ioctl.c   | 2 +-
 fs/btrfs/qgroup.c  | 6 +++---
 4 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/backref.c b/fs/btrfs/backref.c
index f55721ff9385..9de772ee0031 100644
--- a/fs/btrfs/backref.c
+++ b/fs/btrfs/backref.c
@@ -1206,7 +1206,7 @@ int btrfs_check_shared(struct btrfs_trans_handle *trans,
 	struct ulist *roots = NULL;
 	struct ulist_iterator uiter;
 	struct ulist_node *node;
-	struct seq_list elem = {};
+	struct seq_list elem = SEQ_LIST_INIT(elem);
 	int ret = 0;
 
 	tmp = ulist_alloc(GFP_NOFS);
@@ -1610,7 +1610,7 @@ int iterate_extent_inodes(struct btrfs_fs_info *fs_info,
 	struct ulist *roots = NULL;
 	struct ulist_node *ref_node = NULL;
 	struct ulist_node *root_node = NULL;
-	struct seq_list tree_mod_seq_elem = {};
+	struct seq_list tree_mod_seq_elem = SEQ_LIST_INIT(tree_mod_seq_elem);
 	struct ulist_iterator ref_uiter;
 	struct ulist_iterator root_uiter;
 
diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index b3dd55f52f71..36e009ebab47 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -1328,6 +1328,8 @@ struct seq_list {
 	u64 seq;
 };
 
+#define SEQ_LIST_INIT(name)	{ .list = LIST_HEAD_INIT((name).list), .seq = 0 }
+
 enum btrfs_orphan_cleanup_state {
 	ORPHAN_CLEANUP_STARTED	= 1,
 	ORPHAN_CLEANUP_DONE	= 2,
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 5544a79dc2ba..4a5524c2713a 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -3039,7 +3039,7 @@ out:
 static int check_ref(struct btrfs_trans_handle *trans, struct btrfs_root *root,
 		     u64 disko)
 {
-	struct seq_list tree_mod_seq_elem = {};
+	struct seq_list tree_mod_seq_elem = SEQ_LIST_INIT(tree_mod_seq_elem);
 	struct ulist *roots;
 	struct ulist_iterator uiter;
 	struct ulist_node *root_node = NULL;
diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index 97159a8e91d4..7f7eb399a347 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -1845,7 +1845,7 @@ static int qgroup_shared_accounting(struct btrfs_trans_handle *trans,
 	struct ulist *roots = NULL;
 	struct ulist *qgroups, *tmp;
 	struct btrfs_qgroup *qgroup;
-	struct seq_list elem = {};
+	struct seq_list elem = SEQ_LIST_INIT(elem);
 	u64 seq;
 	int old_roots = 0;
 	int new_roots = 0;
@@ -1967,7 +1967,7 @@ static int qgroup_subtree_accounting(struct btrfs_trans_handle *trans,
 	int err;
 	struct btrfs_qgroup *qg;
 	u64 root_obj = 0;
-	struct seq_list elem = {};
+	struct seq_list elem = SEQ_LIST_INIT(elem);
 
 	parents = ulist_alloc(GFP_NOFS);
 	if (!parents)
@@ -2522,7 +2522,7 @@ qgroup_rescan_leaf(struct btrfs_fs_info *fs_info, struct btrfs_path *path,
 {
 	struct btrfs_key found;
 	struct ulist *roots = NULL;
-	struct seq_list tree_mod_seq_elem = {};
+	struct seq_list tree_mod_seq_elem = SEQ_LIST_INIT(tree_mod_seq_elem);
 	u64 num_bytes;
 	u64 seq;
 	int new_roots;
-- 
2.1.3

