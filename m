From: Itaru Kitayama <kitayama@cl.bb4u.ne.jp>
Subject: Re: [PATCH V3] btrfs: implement delayed inode items operation
Date: Wed, 16 Mar 2011 18:48:50 +0900
Message-ID: <20110316184850.f25551a6.kitayama@cl.bb4u.ne.jp>
References: <20110310000355.f225f0d0.kitayama@cl.bb4u.ne.jp>
	<4D786DF2.7000104@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Cc: linux-btrfs@vger.kernel.org
To: miaox@cn.fujitsu.com
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4D786DF2.7000104@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

Hi Miao,

The V4 still hangs. Does the new function, btrfs_update_inode_nodelayed() you introduced to the V4
need take care of a delayed node (commit delayed items of the inode and set the delayed note to NULL)?

Below is my experimental patch on top of V4 trying to avoid taking trans_mutex in btrfs_remove_delayed_node(), 
but still hangs. Could you take a look at it? Thanks.

Itaru

diff --git a/fs/btrfs/delayed-inode.c b/fs/btrfs/delayed-inode.c
index 495a6af..b6ea082 100644
--- a/fs/btrfs/delayed-inode.c
+++ b/fs/btrfs/delayed-inode.c
@@ -1006,9 +1006,9 @@ int btrfs_run_delayed_items(struct btrfs_trans_handle *trans,
 	return ret;
 }
 
-int btrfs_commit_inode_delayed_items(struct btrfs_trans_handle *trans,
-				     struct btrfs_root *root,
-				     struct inode *inode)
+int __btrfs_commit_inode_delayed_items(struct btrfs_trans_handle *trans,
+				       struct btrfs_root *root,
+				       struct inode *inode, int delayed_update)
 {
 	struct btrfs_delayed_node *delayed_node = btrfs_get_delayed_node(inode);
 	struct btrfs_path *path;
@@ -1036,7 +1036,7 @@ int btrfs_commit_inode_delayed_items(struct btrfs_trans_handle *trans,
 	if (!ret)
 		ret = btrfs_delete_delayed_items(trans, path, root,
 						 delayed_node);
-	if (!ret)
+	if (!ret && delayed_update)
 		ret = btrfs_update_delayed_inode(trans, root, path,
 						 delayed_node);
 	btrfs_free_path(path);
@@ -1044,13 +1044,27 @@ int btrfs_commit_inode_delayed_items(struct btrfs_trans_handle *trans,
 	return ret;
 }
 
+int btrfs_commit_inode_delayed_items(struct btrfs_trans_handle *trans,
+				     struct btrfs_root *root,
+				     struct inode *inode)
+{
+	return __btrfs_commit_inode_delayed_items(trans, root, inode, 1);
+}
+
+int btrfs_commit_inode_delayed_items_no_delayed_update(struct btrfs_trans_handle *trans,
+						       struct btrfs_root *root,
+						       struct inode *inode)
+{
+	return __btrfs_commit_inode_delayed_items(trans, root, inode, 0);
+}
+
 int btrfs_remove_delayed_node(struct inode *inode)
 {
 	struct btrfs_trans_handle *trans;
 	struct btrfs_root *root = BTRFS_I(inode)->root;
 	struct btrfs_delayed_node *delayed_node = BTRFS_I(inode)->delayed_node;
 	int ret;
-
+	
 	if (!delayed_node)
 		return 0;
 
diff --git a/fs/btrfs/delayed-inode.h b/fs/btrfs/delayed-inode.h
index d4134bc..b6986df 100644
--- a/fs/btrfs/delayed-inode.h
+++ b/fs/btrfs/delayed-inode.h
@@ -114,6 +114,11 @@ void btrfs_balance_delayed_items(struct btrfs_root *root);
 int btrfs_commit_inode_delayed_items(struct btrfs_trans_handle *trans,
 				     struct btrfs_root *root,
 				     struct inode *inode);
+int btrfs_commit_inode_delayed_items_no_delayed_update(
+				struct btrfs_trans_handle *trans,
+				struct btrfs_root *root,
+				struct inode *inode);
+
 /* Used for evicting the inode. */
 int btrfs_remove_delayed_node(struct inode *inode);
 int btrfs_kill_delayed_inode_items(struct btrfs_trans_handle *trans,
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 5299d9c..e198051 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -2611,8 +2611,12 @@ noinline int btrfs_update_inode_nodelayed(struct btrfs_trans_handle *trans,
 	struct btrfs_inode_item *inode_item;
 	struct btrfs_path *path;
 	struct extent_buffer *leaf;
+	struct btrfs_delayed_node *delayed_node;
 	int ret;
 
+	btrfs_commit_inode_delayed_items_no_delayed_update(trans, root, inode);
+	delayed_node = NULL;
+
 	path = btrfs_alloc_path();
 	if (!path)
 		return -ENOMEM;
