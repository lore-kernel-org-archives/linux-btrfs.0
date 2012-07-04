Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-gg0-f174.google.com ([209.85.161.174]:62942 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752642Ab2GDHaA (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 4 Jul 2012 03:30:00 -0400
Received: by gglu4 with SMTP id u4so6151932ggl.19
        for <linux-btrfs@vger.kernel.org>; Wed, 04 Jul 2012 00:30:00 -0700 (PDT)
From: chandan r <chandanrmail@gmail.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: Add code to support file creation time.
Date: Wed, 04 Jul 2012 12:48:07 +0530
Message-ID: <87ipe43sgg.fsf@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This patch adds a new member to the 'struct btrfs_inode' structure to hold
the file creation time.

Signed-off-by: chandan <chandanrmail@gmail.com>
---
 fs/btrfs/btrfs_inode.h   |  3 +++
 fs/btrfs/ctree.h         |  8 ++++++++
 fs/btrfs/delayed-inode.c | 10 +++++++++-
 fs/btrfs/inode.c         | 25 ++++++++++++++++++++++---
 4 files changed, 42 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/btrfs_inode.h b/fs/btrfs/btrfs_inode.h
index 12394a9..b761456 100644
--- a/fs/btrfs/btrfs_inode.h
+++ b/fs/btrfs/btrfs_inode.h
@@ -162,6 +162,9 @@ struct btrfs_inode {
 
 	struct btrfs_delayed_node *delayed_node;
 
+	/* File creation time. */
+	struct timespec i_otime;
+
 	struct inode vfs_inode;
 };
 
diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index fa5c45b..4ce172f 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -1816,6 +1816,14 @@ btrfs_inode_ctime(struct btrfs_inode_item *inode_item)
 	return (struct btrfs_timespec *)ptr;
 }
 
+static inline struct btrfs_timespec *
+btrfs_inode_otime(struct btrfs_inode_item *inode_item)
+{
+	unsigned long ptr = (unsigned long)inode_item;
+	ptr += offsetof(struct btrfs_inode_item, otime);
+	return (struct btrfs_timespec *)ptr;
+}
+
 BTRFS_SETGET_FUNCS(timespec_sec, struct btrfs_timespec, sec, 64);
 BTRFS_SETGET_FUNCS(timespec_nsec, struct btrfs_timespec, nsec, 32);
 
diff --git a/fs/btrfs/delayed-inode.c b/fs/btrfs/delayed-inode.c
index 21d91a8..63726967 100644
--- a/fs/btrfs/delayed-inode.c
+++ b/fs/btrfs/delayed-inode.c
@@ -1742,6 +1742,11 @@ static void fill_stack_inode_item(struct btrfs_trans_handle *trans,
 				     inode->i_ctime.tv_sec);
 	btrfs_set_stack_timespec_nsec(btrfs_inode_ctime(inode_item),
 				      inode->i_ctime.tv_nsec);
+
+	btrfs_set_stack_timespec_sec(btrfs_inode_otime(inode_item),
+				BTRFS_I(inode)->i_otime.tv_sec);
+	btrfs_set_stack_timespec_nsec(btrfs_inode_otime(inode_item),
+				BTRFS_I(inode)->i_otime.tv_nsec);
 }
 
 int btrfs_fill_inode(struct inode *inode, u32 *rdev)
@@ -1787,6 +1792,10 @@ int btrfs_fill_inode(struct inode *inode, u32 *rdev)
 	inode->i_ctime.tv_sec = btrfs_stack_timespec_sec(tspec);
 	inode->i_ctime.tv_nsec = btrfs_stack_timespec_nsec(tspec);
 
+	tspec = btrfs_inode_otime(inode_item);
+	BTRFS_I(inode)->i_otime.tv_sec = btrfs_stack_timespec_sec(tspec);
+	BTRFS_I(inode)->i_otime.tv_nsec = btrfs_stack_timespec_nsec(tspec);
+
 	inode->i_generation = BTRFS_I(inode)->generation;
 	BTRFS_I(inode)->index_cnt = (u64)-1;
 
@@ -1912,4 +1921,3 @@ void btrfs_destroy_delayed_inodes(struct btrfs_root *root)
 		btrfs_release_delayed_node(prev_node);
 	}
 }
-
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 0d507e6..145a2ed 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -2581,6 +2581,10 @@ static void btrfs_read_locked_inode(struct inode *inode)
 	inode->i_ctime.tv_sec = btrfs_timespec_sec(leaf, tspec);
 	inode->i_ctime.tv_nsec = btrfs_timespec_nsec(leaf, tspec);
 
+	tspec = btrfs_inode_otime(inode_item);
+	BTRFS_I(inode)->i_otime.tv_sec = btrfs_timespec_sec(leaf, tspec);
+	BTRFS_I(inode)->i_otime.tv_nsec = btrfs_timespec_nsec(leaf, tspec);
+
 	inode_set_bytes(inode, btrfs_inode_nbytes(leaf, inode_item));
 	BTRFS_I(inode)->generation = btrfs_inode_generation(leaf, inode_item);
 	inode->i_version = btrfs_inode_sequence(leaf, inode_item);
@@ -2665,6 +2669,11 @@ static void fill_inode_item(struct btrfs_trans_handle *trans,
 	btrfs_set_timespec_nsec(leaf, btrfs_inode_ctime(item),
 				inode->i_ctime.tv_nsec);
 
+	btrfs_set_timespec_sec(leaf, btrfs_inode_otime(item),
+			BTRFS_I(inode)->i_otime.tv_sec);
+	btrfs_set_timespec_nsec(leaf, btrfs_inode_otime(item),
+				BTRFS_I(inode)->i_otime.tv_nsec);
+
 	btrfs_set_inode_nbytes(leaf, item, inode_get_bytes(inode));
 	btrfs_set_inode_generation(leaf, item, BTRFS_I(inode)->generation);
 	btrfs_set_inode_sequence(leaf, item, inode->i_version);
@@ -2846,7 +2855,7 @@ int btrfs_unlink_inode(struct btrfs_trans_handle *trans,
 	}
 	return ret;
 }
-		
+
 
 /* helper to check if there is any shared block in the path */
 static int check_path_shared(struct btrfs_root *root,
@@ -4151,7 +4160,11 @@ static struct inode *new_simple_dir(struct super_block *s,
 	inode->i_op = &btrfs_dir_ro_inode_operations;
 	inode->i_fop = &simple_dir_operations;
 	inode->i_mode = S_IFDIR | S_IRUGO | S_IWUSR | S_IXUGO;
-	inode->i_mtime = inode->i_atime = inode->i_ctime = CURRENT_TIME;
+	BTRFS_I(inode)->i_otime
+		= inode->i_mtime
+		= inode->i_atime
+		= inode->i_ctime
+		= CURRENT_TIME;
 
 	return inode;
 }
@@ -4687,7 +4700,11 @@ static struct inode *btrfs_new_inode(struct btrfs_trans_handle *trans,
 
 	inode_init_owner(inode, dir, mode);
 	inode_set_bytes(inode, 0);
-	inode->i_mtime = inode->i_atime = inode->i_ctime = CURRENT_TIME;
+	BTRFS_I(inode)->i_otime
+		= inode->i_mtime
+		= inode->i_atime
+		= inode->i_ctime
+		= CURRENT_TIME;
 	inode_item = btrfs_item_ptr(path->nodes[0], path->slots[0],
 				  struct btrfs_inode_item);
 	fill_inode_item(trans, path->nodes[0], inode_item, inode);
@@ -6960,6 +6977,8 @@ struct inode *btrfs_alloc_inode(struct super_block *sb)
 
 	ei->delayed_node = NULL;
 
+	ei->i_otime.tv_sec = ei->i_otime.tv_nsec = 0;
+
 	inode = &ei->vfs_inode;
 	extent_map_tree_init(&ei->extent_tree);
 	extent_io_tree_init(&ei->io_tree, &inode->i_data);
-- 
1.7.11

