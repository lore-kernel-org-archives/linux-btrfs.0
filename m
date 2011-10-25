From: Jeff Mahoney <jeffm@suse.com>
Subject: [patch 38/66] btrfs: btrfs_destroy_delalloc_inodes should return void
Date: Mon, 24 Oct 2011 21:03:14 -0400
Message-ID: <20111025010854.927494999@suse.com>
References: <20111025010236.322699279@suse.com>
Cc: Linux Btrfs <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>,
	David Sterba <dsterba@suse.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

 btrfs_destroy_delalloc_inodes has no error conditions and should return
 void. Its callers already ignore the error codes anyway.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 fs/btrfs/disk-io.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -54,7 +54,7 @@ static int btrfs_destroy_ordered_extents
 static int btrfs_destroy_delayed_refs(struct btrfs_transaction *trans,
 				      struct btrfs_root *root);
 static int btrfs_destroy_pending_snapshots(struct btrfs_transaction *t);
-static int btrfs_destroy_delalloc_inodes(struct btrfs_root *root);
+static void btrfs_destroy_delalloc_inodes(struct btrfs_root *root);
 static int btrfs_destroy_marked_extents(struct btrfs_root *root,
 					struct extent_io_tree *dirty_pages,
 					int mark);
@@ -2939,7 +2939,7 @@ static int btrfs_destroy_pending_snapsho
 	return 0;
 }
 
-static int btrfs_destroy_delalloc_inodes(struct btrfs_root *root)
+static void btrfs_destroy_delalloc_inodes(struct btrfs_root *root)
 {
 	struct btrfs_inode *btrfs_inode;
 	struct list_head splice;
@@ -2959,8 +2959,6 @@ static int btrfs_destroy_delalloc_inodes
 	}
 
 	spin_unlock(&root->fs_info->delalloc_lock);
-
-	return 0;
 }
 
 static int btrfs_destroy_marked_extents(struct btrfs_root *root,


