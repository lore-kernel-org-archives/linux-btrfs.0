From: Jeff Mahoney <jeffm@suse.com>
Subject: [patch 98/99] btrfs: btrfs_destroy_pending_snapshots should return void
Date: Wed, 23 Nov 2011 19:37:11 -0500
Message-ID: <20111124004231.160415892@suse.com>
References: <20111124003533.395674389@suse.com>
To: Btrfs List <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

 btrfs_destroy_pending_snapshots has no error conditions and should
 return void.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 fs/btrfs/disk-io.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -53,7 +53,7 @@ static void btrfs_destroy_ordered_operat
 static void btrfs_destroy_ordered_extents(struct btrfs_root *root);
 static int btrfs_destroy_delayed_refs(struct btrfs_transaction *trans,
 				      struct btrfs_root *root);
-static int btrfs_destroy_pending_snapshots(struct btrfs_transaction *t);
+static void btrfs_destroy_pending_snapshots(struct btrfs_transaction *t);
 static void btrfs_destroy_delalloc_inodes(struct btrfs_root *root);
 static int btrfs_destroy_marked_extents(struct btrfs_root *root,
 					struct extent_io_tree *dirty_pages,
@@ -3239,7 +3239,7 @@ static int btrfs_destroy_delayed_refs(st
 	return ret;
 }
 
-static int btrfs_destroy_pending_snapshots(struct btrfs_transaction *t)
+static void btrfs_destroy_pending_snapshots(struct btrfs_transaction *t)
 {
 	struct btrfs_pending_snapshot *snapshot;
 	struct list_head splice;
@@ -3257,8 +3257,6 @@ static int btrfs_destroy_pending_snapsho
 
 		kfree(snapshot);
 	}
-
-	return 0;
 }
 
 static void btrfs_destroy_delalloc_inodes(struct btrfs_root *root)


