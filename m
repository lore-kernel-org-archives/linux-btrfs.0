From: Jeff Mahoney <jeffm@suse.com>
Subject: [patch 97/99] btrfs: btrfs_destroy_ordered_extents should return void
Date: Wed, 23 Nov 2011 19:37:10 -0500
Message-ID: <20111124004231.044693962@suse.com>
References: <20111124003533.395674389@suse.com>
To: Btrfs List <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

 btrfs_destroy_ordered_extents has no error conditions and should return
 void.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 fs/btrfs/disk-io.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -50,7 +50,7 @@ static void free_fs_root(struct btrfs_ro
 static void btrfs_check_super_valid(struct btrfs_fs_info *fs_info,
 				    int read_only);
 static void btrfs_destroy_ordered_operations(struct btrfs_root *root);
-static int btrfs_destroy_ordered_extents(struct btrfs_root *root);
+static void btrfs_destroy_ordered_extents(struct btrfs_root *root);
 static int btrfs_destroy_delayed_refs(struct btrfs_transaction *trans,
 				      struct btrfs_root *root);
 static int btrfs_destroy_pending_snapshots(struct btrfs_transaction *t);
@@ -3153,7 +3153,7 @@ static void btrfs_destroy_ordered_operat
 	mutex_unlock(&root->fs_info->ordered_operations_mutex);
 }
 
-static int btrfs_destroy_ordered_extents(struct btrfs_root *root)
+static void btrfs_destroy_ordered_extents(struct btrfs_root *root)
 {
 	struct list_head splice;
 	struct btrfs_ordered_extent *ordered;
@@ -3185,8 +3185,6 @@ static int btrfs_destroy_ordered_extents
 	}
 
 	spin_unlock(&root->fs_info->ordered_extent_lock);
-
-	return 0;
 }
 
 static int btrfs_destroy_delayed_refs(struct btrfs_transaction *trans,


