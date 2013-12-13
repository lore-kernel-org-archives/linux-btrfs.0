Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:60617 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752434Ab3LMKIf (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 13 Dec 2013 05:08:35 -0500
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id rBDA8Sk8008939
	for <linux-btrfs@vger.kernel.org>; Fri, 13 Dec 2013 18:08:29 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 6/6] Btrfs: introduce the delayed inode ref deletion for the single link inode
Date: Fri, 13 Dec 2013 18:09:41 +0800
Message-Id: <1386929381-3483-6-git-send-email-miaox@cn.fujitsu.com>
In-Reply-To: <1386929381-3483-1-git-send-email-miaox@cn.fujitsu.com>
References: <1386929381-3483-1-git-send-email-miaox@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The inode reference item is close to inode item, so we insert it simultaneously
with the inode item insertion when we create a file/directory.. In fact, we also
can handle the inode reference deletion by the same way. So we made this patch to
introduce the delayed inode reference deletion for the single link inode(At most
case, the file doesn't has hard link, so we don't take the hard link into account).

This function is based on the delayed inode mechanism. After applying this patch,
we can reduce the time of the file/directory deletion by ~10%.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/btrfs_inode.h   |   3 ++
 fs/btrfs/delayed-inode.c | 103 +++++++++++++++++++++++++++++++++++++++++++++--
 fs/btrfs/delayed-inode.h |   2 +
 fs/btrfs/inode.c         |  55 ++++++++++++++++++++++++-
 4 files changed, 157 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/btrfs_inode.h b/fs/btrfs/btrfs_inode.h
index ac0b39d..661b0ac 100644
--- a/fs/btrfs/btrfs_inode.h
+++ b/fs/btrfs/btrfs_inode.h
@@ -135,6 +135,9 @@ struct btrfs_inode {
 	 */
 	u64 index_cnt;
 
+	/* Cache the directory index number to speed the dir/file remove */
+	u64 dir_index;
+
 	/* the fsync log has some corner cases that mean we have to check
 	 * directories to see if any unlinks have been done before
 	 * the directory was logged.  See tree-log.c for all the
diff --git a/fs/btrfs/delayed-inode.c b/fs/btrfs/delayed-inode.c
index 979db56..8671d980 100644
--- a/fs/btrfs/delayed-inode.c
+++ b/fs/btrfs/delayed-inode.c
@@ -1015,6 +1015,18 @@ static void btrfs_release_delayed_inode(struct btrfs_delayed_node *delayed_node)
 	}
 }
 
+static void btrfs_release_delayed_iref(struct btrfs_delayed_node *delayed_node)
+{
+	struct btrfs_delayed_root *delayed_root;
+
+	BUG_ON(!delayed_node->root);
+	clear_bit(BTRFS_DELAYED_NODE_DEL_IREF, &delayed_node->flags);
+	delayed_node->count--;
+
+	delayed_root = delayed_node->root->fs_info->delayed_root;
+	finish_one_item(delayed_root);
+}
+
 static int __btrfs_update_delayed_inode(struct btrfs_trans_handle *trans,
 					struct btrfs_root *root,
 					struct btrfs_path *path,
@@ -1023,13 +1035,19 @@ static int __btrfs_update_delayed_inode(struct btrfs_trans_handle *trans,
 	struct btrfs_key key;
 	struct btrfs_inode_item *inode_item;
 	struct extent_buffer *leaf;
+	int mod;
 	int ret;
 
 	key.objectid = node->inode_id;
 	btrfs_set_key_type(&key, BTRFS_INODE_ITEM_KEY);
 	key.offset = 0;
 
-	ret = btrfs_lookup_inode(trans, root, path, &key, 1);
+	if (test_bit(BTRFS_DELAYED_NODE_DEL_IREF, &node->flags))
+		mod = -1;
+	else
+		mod = 1;
+
+	ret = btrfs_lookup_inode(trans, root, path, &key, mod);
 	if (ret > 0) {
 		btrfs_release_path(path);
 		return -ENOENT;
@@ -1037,19 +1055,58 @@ static int __btrfs_update_delayed_inode(struct btrfs_trans_handle *trans,
 		return ret;
 	}
 
-	btrfs_unlock_up_safe(path, 1);
 	leaf = path->nodes[0];
 	inode_item = btrfs_item_ptr(leaf, path->slots[0],
 				    struct btrfs_inode_item);
 	write_extent_buffer(leaf, &node->inode_item, (unsigned long)inode_item,
 			    sizeof(struct btrfs_inode_item));
 	btrfs_mark_buffer_dirty(leaf);
-	btrfs_release_path(path);
 
+	if (!test_bit(BTRFS_DELAYED_NODE_DEL_IREF, &node->flags))
+		goto no_iref;
+
+	path->slots[0]++;
+	if (path->slots[0] >= btrfs_header_nritems(leaf))
+		goto search;
+again:
+	btrfs_item_key_to_cpu(leaf, &key, path->slots[0]);
+	if (key.objectid != node->inode_id)
+		goto out;
+
+	if (key.type != BTRFS_INODE_REF_KEY &&
+	    key.type != BTRFS_INODE_EXTREF_KEY)
+		goto out;
+
+	/*
+	 * Delayed iref deletion is for the inode who has only one link,
+	 * so there is only one iref. The case that several irefs are
+	 * in the same item doesn't exist.
+	 */
+	btrfs_del_item(trans, root, path);
+out:
+	btrfs_release_delayed_iref(node);
+no_iref:
+	btrfs_release_path(path);
+err_out:
 	btrfs_delayed_inode_release_metadata(root, node);
 	btrfs_release_delayed_inode(node);
 
-	return 0;
+	return ret;
+
+search:
+	btrfs_release_path(path);
+
+	btrfs_set_key_type(&key, BTRFS_INODE_EXTREF_KEY);
+	key.offset = -1;
+	ret = btrfs_search_slot(trans, root, &key, path, -1, 1);
+	if (ret < 0)
+		goto err_out;
+	BUG_ON(!ret);
+
+	ret = 0;
+	leaf = path->nodes[0];
+	path->slots[0]--;
+	goto again;
 }
 
 static inline int btrfs_update_delayed_inode(struct btrfs_trans_handle *trans,
@@ -1793,6 +1850,41 @@ release_node:
 	return ret;
 }
 
+int btrfs_delayed_delete_inode_ref(struct inode *inode)
+{
+	struct btrfs_delayed_node *delayed_node;
+
+	delayed_node = btrfs_get_or_create_delayed_node(inode);
+	if (IS_ERR(delayed_node))
+		return PTR_ERR(delayed_node);
+
+	/*
+	 * We don't reserve space for inode ref deletion is because:
+	 * - We ONLY do async inode ref deletion for the inode who has only
+	 *   one link(i_nlink == 1), it means there is only one inode ref.
+	 *   And in most case, the inode ref and the inode item are in the
+	 *   same leaf, and we will deal with them at the same time.
+	 *   Since we are sure we will reserve the space for the inode item,
+	 *   it is unnecessary to reserve space for inode ref deletion.
+	 * - If the inode ref and the inode item are not in the same leaf,
+	 *   We also needn't worry about enospc problem, because we reserve
+	 *   much more space for the inode update than it needs.
+	 * - At the worst, we can steal some space from the global reservation.
+	 *   It is very rare.
+	 */
+	mutex_lock(&delayed_node->mutex);
+	if (test_bit(BTRFS_DELAYED_NODE_DEL_IREF, &delayed_node->flags))
+		goto release_node;
+
+	set_bit(BTRFS_DELAYED_NODE_DEL_IREF, &delayed_node->flags);
+	delayed_node->count++;
+	atomic_inc(&BTRFS_I(inode)->root->fs_info->delayed_root->items);
+release_node:
+	mutex_unlock(&delayed_node->mutex);
+	btrfs_release_delayed_node(delayed_node);
+	return 0;
+}
+
 static void __btrfs_kill_delayed_node(struct btrfs_delayed_node *delayed_node)
 {
 	struct btrfs_root *root = delayed_node->root;
@@ -1815,6 +1907,9 @@ static void __btrfs_kill_delayed_node(struct btrfs_delayed_node *delayed_node)
 		btrfs_release_delayed_item(prev_item);
 	}
 
+	if (test_bit(BTRFS_DELAYED_NODE_DEL_IREF, &delayed_node->flags))
+		btrfs_release_delayed_iref(delayed_node);
+
 	if (test_bit(BTRFS_DELAYED_NODE_INODE_DIRTY, &delayed_node->flags)) {
 		btrfs_delayed_inode_release_metadata(root, delayed_node);
 		btrfs_release_delayed_inode(delayed_node);
diff --git a/fs/btrfs/delayed-inode.h b/fs/btrfs/delayed-inode.h
index a6a13f7..f70119f 100644
--- a/fs/btrfs/delayed-inode.h
+++ b/fs/btrfs/delayed-inode.h
@@ -50,6 +50,7 @@ struct btrfs_delayed_root {
 
 #define BTRFS_DELAYED_NODE_IN_LIST	0
 #define BTRFS_DELAYED_NODE_INODE_DIRTY	1
+#define BTRFS_DELAYED_NODE_DEL_IREF	2
 
 struct btrfs_delayed_node {
 	u64 inode_id;
@@ -127,6 +128,7 @@ int btrfs_commit_inode_delayed_inode(struct inode *inode);
 int btrfs_delayed_update_inode(struct btrfs_trans_handle *trans,
 			       struct btrfs_root *root, struct inode *inode);
 int btrfs_fill_inode(struct inode *inode, u32 *rdev);
+int btrfs_delayed_delete_inode_ref(struct inode *inode);
 
 /* Used for drop dead root */
 void btrfs_kill_all_delayed_nodes(struct btrfs_root *root);
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index f1a7744..daa1490 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -3315,6 +3315,7 @@ static void btrfs_read_locked_inode(struct inode *inode)
 	struct btrfs_timespec *tspec;
 	struct btrfs_root *root = BTRFS_I(inode)->root;
 	struct btrfs_key location;
+	unsigned long ptr;
 	int maybe_acls;
 	u32 rdev;
 	int ret;
@@ -3338,7 +3339,7 @@ static void btrfs_read_locked_inode(struct inode *inode)
 	leaf = path->nodes[0];
 
 	if (filled)
-		goto cache_acl;
+		goto cache_index;
 
 	inode_item = btrfs_item_ptr(leaf, path->slots[0],
 				    struct btrfs_inode_item);
@@ -3381,6 +3382,30 @@ static void btrfs_read_locked_inode(struct inode *inode)
 
 	BTRFS_I(inode)->index_cnt = (u64)-1;
 	BTRFS_I(inode)->flags = btrfs_inode_flags(leaf, inode_item);
+
+cache_index:
+	path->slots[0]++;
+	if (inode->i_nlink != 1 ||
+	    path->slots[0] >= btrfs_header_nritems(leaf))
+		goto cache_acl;
+
+	btrfs_item_key_to_cpu(leaf, &location, path->slots[0]);
+	if (location.objectid != btrfs_ino(inode))
+		goto cache_acl;
+
+	ptr = btrfs_item_ptr_offset(leaf, path->slots[0]);
+	if (location.type == BTRFS_INODE_REF_KEY) {
+		struct btrfs_inode_ref *ref;
+
+		ref = (struct btrfs_inode_ref *)ptr;
+		BTRFS_I(inode)->dir_index = btrfs_inode_ref_index(leaf, ref);
+	} else if (location.type == BTRFS_INODE_EXTREF_KEY) {
+		struct btrfs_inode_extref *extref;
+
+		extref = (struct btrfs_inode_extref *)ptr;
+		BTRFS_I(inode)->dir_index = btrfs_inode_extref_index(leaf,
+								     extref);
+	}
 cache_acl:
 	/*
 	 * try to precache a NULL acl entry for files that don't have
@@ -3593,6 +3618,24 @@ static int __btrfs_unlink_inode(struct btrfs_trans_handle *trans,
 		goto err;
 	btrfs_release_path(path);
 
+	/*
+	 * If we don't have dir index, we have to get it by looking up
+	 * the inode ref, since we get the inode ref, remove it directly,
+	 * it is unnecessary to do delayed deletion.
+	 *
+	 * But if we have dir index, needn't search inode ref to get it.
+	 * Since the inode ref is close to the inode item, it is better
+	 * that we delay to delete it, and just do this deletion when
+	 * we update the inode item.
+	 */
+	if (BTRFS_I(inode)->dir_index) {
+		ret = btrfs_delayed_delete_inode_ref(inode);
+		if (!ret) {
+			index = BTRFS_I(inode)->dir_index;
+			goto skip_backref;
+		}
+	}
+
 	ret = btrfs_del_inode_ref(trans, root, name, name_len, ino,
 				  dir_ino, &index);
 	if (ret) {
@@ -3602,7 +3645,7 @@ static int __btrfs_unlink_inode(struct btrfs_trans_handle *trans,
 		btrfs_abort_transaction(trans, root, ret);
 		goto err;
 	}
-
+skip_backref:
 	ret = btrfs_delete_delayed_dir_index(trans, root, dir, index);
 	if (ret) {
 		btrfs_abort_transaction(trans, root, ret);
@@ -5388,6 +5431,7 @@ static struct inode *btrfs_new_inode(struct btrfs_trans_handle *trans,
 	 * number
 	 */
 	BTRFS_I(inode)->index_cnt = 2;
+	BTRFS_I(inode)->dir_index = *index;
 	BTRFS_I(inode)->root = root;
 	BTRFS_I(inode)->generation = trans->transid;
 	inode->i_generation = BTRFS_I(inode)->generation;
@@ -5737,6 +5781,8 @@ static int btrfs_link(struct dentry *old_dentry, struct inode *dir,
 		goto fail;
 	}
 
+	/* There are several dir indexes for this inode, clear the cache. */
+	BTRFS_I(inode)->dir_index = 0ULL;
 	inc_nlink(inode);
 	inode_inc_iversion(inode);
 	inode->i_ctime = CURRENT_TIME;
@@ -7776,6 +7822,7 @@ struct inode *btrfs_alloc_inode(struct super_block *sb)
 	ei->flags = 0;
 	ei->csum_bytes = 0;
 	ei->index_cnt = (u64)-1;
+	ei->dir_index = 0;
 	ei->last_unlink_trans = 0;
 	ei->last_log_commit = 0;
 
@@ -8063,6 +8110,7 @@ static int btrfs_rename(struct inode *old_dir, struct dentry *old_dentry,
 	if (ret)
 		goto out_fail;
 
+	BTRFS_I(old_inode)->dir_index = 0ULL;
 	if (unlikely(old_ino == BTRFS_FIRST_FREE_OBJECTID)) {
 		/* force full log commit if subvolume involved. */
 		root->fs_info->last_trans_log_full_commit = trans->transid;
@@ -8151,6 +8199,9 @@ static int btrfs_rename(struct inode *old_dir, struct dentry *old_dentry,
 		goto out_fail;
 	}
 
+	if (old_inode->i_nlink == 1)
+		BTRFS_I(old_inode)->dir_index = index;
+
 	if (old_ino != BTRFS_FIRST_FREE_OBJECTID) {
 		struct dentry *parent = new_dentry->d_parent;
 		btrfs_log_new_name(trans, old_inode, old_dir, parent);
-- 
1.8.3.1

