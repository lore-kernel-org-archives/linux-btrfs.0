From: Jeff Mahoney <jeffm@suse.com>
Subject: [patch 04/99] btrfs: Simplify btrfs_insert_root
Date: Wed, 23 Nov 2011 19:35:37 -0500
Message-ID: <20111124004220.280660938@suse.com>
References: <20111124003533.395674389@suse.com>
To: Btrfs List <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

 btrfs_insert_root is just a wrapper for btrfs_insert_item. Just return
 the error directly.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 fs/btrfs/root-tree.c |    9 +++------
 1 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/root-tree.c b/fs/btrfs/root-tree.c
index f409990..1fd93d6 100644
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



