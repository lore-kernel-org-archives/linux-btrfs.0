Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wg0-f42.google.com ([74.125.82.42]:38665 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751333AbaD0Sl6 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 27 Apr 2014 14:41:58 -0400
Received: by mail-wg0-f42.google.com with SMTP id k14so2815458wgh.1
        for <linux-btrfs@vger.kernel.org>; Sun, 27 Apr 2014 11:41:56 -0700 (PDT)
From: Filipe David Borba Manana <fdmanana@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Filipe David Borba Manana <fdmanana@gmail.com>
Subject: [PATCH v2] Btrfs: implement inode_operations callback tmpfile
Date: Sun, 27 Apr 2014 20:40:45 +0100
Message-Id: <1398627645-9622-1-git-send-email-fdmanana@gmail.com>
In-Reply-To: <1396392799-9858-1-git-send-email-fdmanana@gmail.com>
References: <1396392799-9858-1-git-send-email-fdmanana@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This implements the tmpfile callback of struct inode_operations, introduced
in the linux kernel 3.11, and implemented already by some filesystems. This
callback is invoked by the VFS when the flag O_TMPFILE is passed to the open
system call.

Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
---

V2: Updated change log and comment about how many metadata units are needed
    for the transaction.
    Left the ACL inheritance in the callback (like ext4 does) since the thread
    in linux-fsdevel seems to have ended with the conclusion that this is the
    right behaviour (as Andreas Gruenbacher says).

 fs/btrfs/inode.c | 118 +++++++++++++++++++++++++++++++++++++++++++++----------
 1 file changed, 98 insertions(+), 20 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 0c0bb45..b5397db 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -5549,6 +5549,7 @@ static struct inode *btrfs_new_inode(struct btrfs_trans_handle *trans,
 	struct btrfs_inode_ref *ref;
 	struct btrfs_key key[2];
 	u32 sizes[2];
+	int nitems = name ? 2 : 1;
 	unsigned long ptr;
 	int ret;
 
@@ -5568,7 +5569,7 @@ static struct inode *btrfs_new_inode(struct btrfs_trans_handle *trans,
 	 */
 	inode->i_ino = objectid;
 
-	if (dir) {
+	if (dir && name) {
 		trace_btrfs_inode_request(dir);
 
 		ret = btrfs_set_inode_index(dir, index);
@@ -5577,6 +5578,8 @@ static struct inode *btrfs_new_inode(struct btrfs_trans_handle *trans,
 			iput(inode);
 			return ERR_PTR(ret);
 		}
+	} else if (dir) {
+		*index = 0;
 	}
 	/*
 	 * index_cnt is ignored for everything but a dir,
@@ -5601,21 +5604,24 @@ static struct inode *btrfs_new_inode(struct btrfs_trans_handle *trans,
 	btrfs_set_key_type(&key[0], BTRFS_INODE_ITEM_KEY);
 	key[0].offset = 0;
 
-	/*
-	 * Start new inodes with an inode_ref. This is slightly more
-	 * efficient for small numbers of hard links since they will
-	 * be packed into one item. Extended refs will kick in if we
-	 * add more hard links than can fit in the ref item.
-	 */
-	key[1].objectid = objectid;
-	btrfs_set_key_type(&key[1], BTRFS_INODE_REF_KEY);
-	key[1].offset = ref_objectid;
-
 	sizes[0] = sizeof(struct btrfs_inode_item);
-	sizes[1] = name_len + sizeof(*ref);
+
+	if (name) {
+		/*
+		 * Start new inodes with an inode_ref. This is slightly more
+		 * efficient for small numbers of hard links since they will
+		 * be packed into one item. Extended refs will kick in if we
+		 * add more hard links than can fit in the ref item.
+		 */
+		key[1].objectid = objectid;
+		btrfs_set_key_type(&key[1], BTRFS_INODE_REF_KEY);
+		key[1].offset = ref_objectid;
+
+		sizes[1] = name_len + sizeof(*ref);
+	}
 
 	path->leave_spinning = 1;
-	ret = btrfs_insert_empty_items(trans, root, path, key, sizes, 2);
+	ret = btrfs_insert_empty_items(trans, root, path, key, sizes, nitems);
 	if (ret != 0)
 		goto fail;
 
@@ -5628,12 +5634,14 @@ static struct inode *btrfs_new_inode(struct btrfs_trans_handle *trans,
 			     sizeof(*inode_item));
 	fill_inode_item(trans, path->nodes[0], inode_item, inode);
 
-	ref = btrfs_item_ptr(path->nodes[0], path->slots[0] + 1,
-			     struct btrfs_inode_ref);
-	btrfs_set_inode_ref_name_len(path->nodes[0], ref, name_len);
-	btrfs_set_inode_ref_index(path->nodes[0], ref, *index);
-	ptr = (unsigned long)(ref + 1);
-	write_extent_buffer(path->nodes[0], name, ptr, name_len);
+	if (name) {
+		ref = btrfs_item_ptr(path->nodes[0], path->slots[0] + 1,
+				     struct btrfs_inode_ref);
+		btrfs_set_inode_ref_name_len(path->nodes[0], ref, name_len);
+		btrfs_set_inode_ref_index(path->nodes[0], ref, *index);
+		ptr = (unsigned long)(ref + 1);
+		write_extent_buffer(path->nodes[0], name, ptr, name_len);
+	}
 
 	btrfs_mark_buffer_dirty(path->nodes[0]);
 	btrfs_free_path(path);
@@ -5669,7 +5677,7 @@ static struct inode *btrfs_new_inode(struct btrfs_trans_handle *trans,
 
 	return inode;
 fail:
-	if (dir)
+	if (dir && name)
 		BTRFS_I(dir)->index_cnt--;
 	btrfs_free_path(path);
 	iput(inode);
@@ -5954,6 +5962,15 @@ static int btrfs_link(struct dentry *old_dentry, struct inode *dir,
 		err = btrfs_update_inode(trans, root, inode);
 		if (err)
 			goto fail;
+		if (inode->i_nlink == 1) {
+			/*
+			 * If new hard link count is 1, it's a file created
+			 * with open(2) O_TMPFILE flag.
+			 */
+			err = btrfs_orphan_del(trans, inode);
+			if (err)
+				goto fail;
+		}
 		d_instantiate(dentry, inode);
 		btrfs_log_new_name(trans, inode, NULL, parent);
 	}
@@ -8886,6 +8903,66 @@ static int btrfs_permission(struct inode *inode, int mask)
 	return generic_permission(inode, mask);
 }
 
+static int btrfs_tmpfile(struct inode *dir, struct dentry *dentry, umode_t mode)
+{
+	struct btrfs_trans_handle *trans;
+	struct btrfs_root *root = BTRFS_I(dir)->root;
+	struct inode *inode = NULL;
+	u64 objectid;
+	u64 index;
+	int ret = 0;
+
+	/*
+	 * 5 units required for adding orphan entry
+	 */
+	trans = btrfs_start_transaction(root, 5);
+	if (IS_ERR(trans))
+		return PTR_ERR(trans);
+
+	ret = btrfs_find_free_ino(root, &objectid);
+	if (ret)
+		goto out;
+
+	inode = btrfs_new_inode(trans, root, dir, NULL, 0,
+				btrfs_ino(dir), objectid, mode, &index);
+	if (IS_ERR(inode)) {
+		ret = PTR_ERR(inode);
+		inode = NULL;
+		goto out;
+	}
+
+	ret = btrfs_init_inode_security(trans, inode, dir, NULL);
+	if (ret)
+		goto out;
+
+	ret = btrfs_update_inode(trans, root, inode);
+	if (ret)
+		goto out;
+
+	inode->i_fop = &btrfs_file_operations;
+	inode->i_op = &btrfs_file_inode_operations;
+
+	inode->i_mapping->a_ops = &btrfs_aops;
+	inode->i_mapping->backing_dev_info = &root->fs_info->bdi;
+	BTRFS_I(inode)->io_tree.ops = &btrfs_extent_io_ops;
+
+	ret = btrfs_orphan_add(trans, inode);
+	if (ret)
+		goto out;
+
+	d_tmpfile(dentry, inode);
+	mark_inode_dirty(inode);
+
+out:
+	btrfs_end_transaction(trans, root);
+	if (ret)
+		iput(inode);
+	btrfs_balance_delayed_items(root);
+	btrfs_btree_balance_dirty(root);
+
+	return ret;
+}
+
 static const struct inode_operations btrfs_dir_inode_operations = {
 	.getattr	= btrfs_getattr,
 	.lookup		= btrfs_lookup,
@@ -8905,6 +8982,7 @@ static const struct inode_operations btrfs_dir_inode_operations = {
 	.permission	= btrfs_permission,
 	.get_acl	= btrfs_get_acl,
 	.update_time	= btrfs_update_time,
+	.tmpfile        = btrfs_tmpfile,
 };
 static const struct inode_operations btrfs_dir_ro_inode_operations = {
 	.lookup		= btrfs_lookup,
-- 
1.9.1

