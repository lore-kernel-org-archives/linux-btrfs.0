From: Jeff Mahoney <jeffm@suse.com>
Subject: [patch 36/66] btrfs: btrfs_invalidate_inodes should return void
Date: Mon, 24 Oct 2011 21:03:12 -0400
Message-ID: <20111025010854.699505611@suse.com>
References: <20111025010236.322699279@suse.com>
Cc: Linux Btrfs <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>,
	David Sterba <dsterba@suse.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

 btrfs_invalidate_inodes has no error conditions and should return void.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 fs/btrfs/ctree.h |    2 +-
 fs/btrfs/inode.c |    3 +--
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 7d90a9c..e8f0689 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -2584,7 +2584,7 @@ int btrfs_orphan_cleanup(struct btrfs_root *root);
 void btrfs_orphan_commit_root(struct btrfs_trans_handle *trans,
 			      struct btrfs_root *root);
 int btrfs_cont_expand(struct inode *inode, loff_t oldsize, loff_t size);
-int btrfs_invalidate_inodes(struct btrfs_root *root);
+void btrfs_invalidate_inodes(struct btrfs_root *root);
 void btrfs_add_delayed_iput(struct inode *inode);
 void btrfs_run_delayed_iputs(struct btrfs_root *root);
 int btrfs_prealloc_file_range(struct inode *inode, int mode,
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 321c9cf..59c681b 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -3861,7 +3861,7 @@ static void inode_tree_del(struct inode *inode)
 	}
 }
 
-int btrfs_invalidate_inodes(struct btrfs_root *root)
+void btrfs_invalidate_inodes(struct btrfs_root *root)
 {
 	struct rb_node *node;
 	struct rb_node *prev;
@@ -3921,7 +3921,6 @@ again:
 		node = rb_next(node);
 	}
 	spin_unlock(&root->inode_lock);
-	return 0;
 }
 
 static int btrfs_init_locked_inode(struct inode *inode, void *p)



