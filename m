From: Jeff Mahoney <jeffm@suse.com>
Subject: [patch 96/99] btrfs: btrfs_destroy_ordered_operations should return void
Date: Wed, 23 Nov 2011 19:37:09 -0500
Message-ID: <20111124004230.928973500@suse.com>
References: <20111124003533.395674389@suse.com>
To: Btrfs List <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

 btrfs_destroy_ordered_operations has no error conditions and should
 return void.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 fs/btrfs/disk-io.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -49,7 +49,7 @@ static void end_workqueue_fn(struct btrf
 static void free_fs_root(struct btrfs_root *root);
 static void btrfs_check_super_valid(struct btrfs_fs_info *fs_info,
 				    int read_only);
-static int btrfs_destroy_ordered_operations(struct btrfs_root *root);
+static void btrfs_destroy_ordered_operations(struct btrfs_root *root);
 static int btrfs_destroy_ordered_extents(struct btrfs_root *root);
 static int btrfs_destroy_delayed_refs(struct btrfs_transaction *trans,
 				      struct btrfs_root *root);
@@ -3129,7 +3129,7 @@ int btrfs_error_commit_super(struct btrf
 	return ret;
 }
 
-static int btrfs_destroy_ordered_operations(struct btrfs_root *root)
+static void btrfs_destroy_ordered_operations(struct btrfs_root *root)
 {
 	struct btrfs_inode *btrfs_inode;
 	struct list_head splice;
@@ -3151,8 +3151,6 @@ static int btrfs_destroy_ordered_operati
 
 	spin_unlock(&root->fs_info->ordered_extent_lock);
 	mutex_unlock(&root->fs_info->ordered_operations_mutex);
-
-	return 0;
 }
 
 static int btrfs_destroy_ordered_extents(struct btrfs_root *root)


