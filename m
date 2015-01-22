Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:52725 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752625AbbAVRUo (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 22 Jan 2015 12:20:44 -0500
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: chandan r <chandanrmail@gmail.com>, David Sterba <dsterba@suse.cz>
Subject: [PATCH v2] Btrfs: Add code to support file creation time
Date: Thu, 22 Jan 2015 18:20:41 +0100
Message-Id: <1421947241-9323-1-git-send-email-dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: chandan r <chandanrmail@gmail.com>

This patch adds a new member to the 'struct btrfs_inode' structure to hold
the file creation time.

Signed-off-by: chandan <chandanrmail@gmail.com>
[refreshed, removed btrfs_inode_otime]
Signed-off-by: David Sterba <dsterba@suse.cz>
---

This is based on top of https://patchwork.kernel.org/patch/5484061/ that cleans
up [cma]time use, otime is treated the same way.

 fs/btrfs/btrfs_inode.h   |  3 +++
 fs/btrfs/delayed-inode.c | 10 ++++++++++
 fs/btrfs/inode.c         | 29 +++++++++++++++++++++++++++--
 3 files changed, 40 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/btrfs_inode.h b/fs/btrfs/btrfs_inode.h
index 4aadadcfab20..de5e4f2adfea 100644
--- a/fs/btrfs/btrfs_inode.h
+++ b/fs/btrfs/btrfs_inode.h
@@ -185,6 +185,9 @@ struct btrfs_inode {
 
 	struct btrfs_delayed_node *delayed_node;
 
+	/* File creation time. */
+	struct timespec i_otime;
+
 	struct inode vfs_inode;
 };
 
diff --git a/fs/btrfs/delayed-inode.c b/fs/btrfs/delayed-inode.c
index 116eb4bed8d3..82f0c7c95474 100644
--- a/fs/btrfs/delayed-inode.c
+++ b/fs/btrfs/delayed-inode.c
@@ -1769,6 +1769,11 @@ static void fill_stack_inode_item(struct btrfs_trans_handle *trans,
 				     inode->i_ctime.tv_sec);
 	btrfs_set_stack_timespec_nsec(&inode_item->ctime,
 				      inode->i_ctime.tv_nsec);
+
+	btrfs_set_stack_timespec_sec(&inode_item->otime,
+				     BTRFS_I(inode)->i_otime.tv_sec);
+	btrfs_set_stack_timespec_nsec(&inode_item->otime,
+				     BTRFS_I(inode)->i_otime.tv_nsec);
 }
 
 int btrfs_fill_inode(struct inode *inode, u32 *rdev)
@@ -1810,6 +1815,11 @@ int btrfs_fill_inode(struct inode *inode, u32 *rdev)
 	inode->i_ctime.tv_sec = btrfs_stack_timespec_sec(&inode_item->ctime);
 	inode->i_ctime.tv_nsec = btrfs_stack_timespec_nsec(&inode_item->ctime);
 
+	BTRFS_I(inode)->i_otime.tv_sec =
+		btrfs_stack_timespec_sec(&inode_item->otime);
+	BTRFS_I(inode)->i_otime.tv_nsec =
+		btrfs_stack_timespec_nsec(&inode_item->otime);
+
 	inode->i_generation = BTRFS_I(inode)->generation;
 	BTRFS_I(inode)->index_cnt = (u64)-1;
 
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 87f1d9b8727e..5db15b21280a 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -3535,6 +3535,11 @@ static void btrfs_read_locked_inode(struct inode *inode)
 	inode->i_ctime.tv_sec = btrfs_timespec_sec(leaf, &inode_item->ctime);
 	inode->i_ctime.tv_nsec = btrfs_timespec_nsec(leaf, &inode_item->ctime);
 
+	BTRFS_I(inode)->i_otime.tv_sec =
+		btrfs_timespec_sec(leaf, &inode_item->otime);
+	BTRFS_I(inode)->i_otime.tv_nsec =
+		btrfs_timespec_nsec(leaf, &inode_item->otime);
+
 	inode_set_bytes(inode, btrfs_inode_nbytes(leaf, inode_item));
 	BTRFS_I(inode)->generation = btrfs_inode_generation(leaf, inode_item);
 	BTRFS_I(inode)->last_trans = btrfs_inode_transid(leaf, inode_item);
@@ -3669,6 +3674,11 @@ static void fill_inode_item(struct btrfs_trans_handle *trans,
 	btrfs_set_token_timespec_nsec(leaf, &item->ctime,
 				      inode->i_ctime.tv_nsec, &token);
 
+	btrfs_set_token_timespec_sec(leaf, btrfs_inode_otime(item),
+				     BTRFS_I(inode)->i_otime.tv_sec, &token);
+	btrfs_set_token_timespec_nsec(leaf, btrfs_inode_otime(item),
+				      BTRFS_I(inode)->i_otime.tv_nsec, &token);
+
 	btrfs_set_token_inode_nbytes(leaf, item, inode_get_bytes(inode),
 				     &token);
 	btrfs_set_token_inode_generation(leaf, item, BTRFS_I(inode)->generation,
@@ -5244,6 +5254,7 @@ static struct inode *new_simple_dir(struct super_block *s,
 				    struct btrfs_root *root)
 {
 	struct inode *inode = new_inode(s);
+	struct timespec current_time;
 
 	if (!inode)
 		return ERR_PTR(-ENOMEM);
@@ -5256,7 +5267,11 @@ static struct inode *new_simple_dir(struct super_block *s,
 	inode->i_op = &btrfs_dir_ro_inode_operations;
 	inode->i_fop = &simple_dir_operations;
 	inode->i_mode = S_IFDIR | S_IRUGO | S_IWUSR | S_IXUGO;
-	inode->i_mtime = inode->i_atime = inode->i_ctime = CURRENT_TIME;
+	current_time = CURRENT_TIME;
+	inode->i_mtime = current_time;
+	inode->i_atime = current_time;
+	inode->i_ctime = current_time;
+	BTRFS_I(inode)->i_otime = current_time;
 
 	return inode;
 }
@@ -5729,6 +5744,7 @@ static struct inode *btrfs_new_inode(struct btrfs_trans_handle *trans,
 	struct btrfs_path *path;
 	struct btrfs_inode_ref *ref;
 	struct btrfs_key key[2];
+	struct timespec current_time;
 	u32 sizes[2];
 	int nitems = name ? 2 : 1;
 	unsigned long ptr;
@@ -5824,7 +5840,13 @@ static struct inode *btrfs_new_inode(struct btrfs_trans_handle *trans,
 
 	inode_init_owner(inode, dir, mode);
 	inode_set_bytes(inode, 0);
-	inode->i_mtime = inode->i_atime = inode->i_ctime = CURRENT_TIME;
+
+	current_time = CURRENT_TIME;
+	inode->i_mtime = current_time;
+	inode->i_atime = current_time;
+	inode->i_ctime = current_time;
+	BTRFS_I(inode)->i_otime = current_time;
+
 	inode_item = btrfs_item_ptr(path->nodes[0], path->slots[0],
 				  struct btrfs_inode_item);
 	memset_extent_buffer(path->nodes[0], 0, (unsigned long)inode_item,
@@ -8574,6 +8596,9 @@ struct inode *btrfs_alloc_inode(struct super_block *sb)
 
 	ei->delayed_node = NULL;
 
+	ei->i_otime.tv_sec = 0;
+	ei->i_otime.tv_nsec = 0;
+
 	inode = &ei->vfs_inode;
 	extent_map_tree_init(&ei->extent_tree);
 	extent_io_tree_init(&ei->io_tree, &inode->i_data);
-- 
1.8.4.5

