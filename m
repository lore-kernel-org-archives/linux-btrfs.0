From: Jeff Mahoney <jeffm@suse.com>
Subject: [patch 35/65] btrfs: btrfs_invalidate_inodes should return void
Date: Mon, 03 Oct 2011 23:23:05 -0400
Message-ID: <20111004032303.933738679@suse.com>
References: <20111004032230.458853274@suse.com>
Cc: Chris Mason <chris.mason@oracle.com>
To: BtrFS List <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

 btrfs_invalidate_inodes has no error conditions and should return void.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 fs/btrfs/ctree.h |    2 +-
 fs/btrfs/inode.c |    3 +--
 2 files changed, 2 insertions(+), 3 deletions(-)

--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -2590,7 +2590,7 @@ void btrfs_orphan_post_snapshot(struct b
 void btrfs_orphan_commit_root(struct btrfs_trans_handle *trans,
 			      struct btrfs_root *root);
 int btrfs_cont_expand(struct inode *inode, loff_t oldsize, loff_t size);
-int btrfs_invalidate_inodes(struct btrfs_root *root);
+void btrfs_invalidate_inodes(struct btrfs_root *root);
 void btrfs_add_delayed_iput(struct inode *inode);
 void btrfs_run_delayed_iputs(struct btrfs_root *root);
 int btrfs_prealloc_file_range(struct inode *inode, int mode,
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -3886,7 +3886,7 @@ static void inode_tree_del(struct inode
 	}
 }
 
-int btrfs_invalidate_inodes(struct btrfs_root *root)
+void btrfs_invalidate_inodes(struct btrfs_root *root)
 {
 	struct rb_node *node;
 	struct rb_node *prev;
@@ -3946,7 +3946,6 @@ again:
 		node = rb_next(node);
 	}
 	spin_unlock(&root->inode_lock);
-	return 0;
 }
 
 static int btrfs_init_locked_inode(struct inode *inode, void *p)



