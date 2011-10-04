From: Jeff Mahoney <jeffm@suse.com>
Subject: [patch 04/65] btrfs: Simplify btrfs_insert_root
Date: Mon, 03 Oct 2011 23:22:34 -0400
Message-ID: <20111004032300.377559873@suse.com>
References: <20111004032230.458853274@suse.com>
Cc: Chris Mason <chris.mason@oracle.com>
To: BtrFS List <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

 btrfs_insert_root is just a wrapper for btrfs_insert_item. Just return
 the error directly.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 fs/btrfs/root-tree.c |    9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

--- a/fs/btrfs/root-tree.c
+++ b/fs/btrfs/root-tree.c
@@ -116,13 +116,10 @@ out:
 	return ret;
 }
 
-int btrfs_insert_root(struct btrfs_trans_handle *trans, struct btrfs_root
-		      *root, struct btrfs_key *key, struct btrfs_root_item
-		      *item)
+int btrfs_insert_root(struct btrfs_trans_handle *trans, struct btrfs_root *root,
+		      struct btrfs_key *key, struct btrfs_root_item *item)
 {
-	int ret;
-	ret = btrfs_insert_item(trans, root, key, item, sizeof(*item));
-	return ret;
+	return btrfs_insert_item(trans, root, key, item, sizeof(*item));
 }
 
 /*



