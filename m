From: Jeff Mahoney <jeffm@suse.com>
Subject: [patch 35/99] btrfs: btrfs_update_root error push-up
Date: Wed, 23 Nov 2011 19:36:08 -0500
Message-ID: <20111124004223.870830150@suse.com>
References: <20111124003533.395674389@suse.com>
To: Btrfs List <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

 btrfs_update_root BUG's when it can't alloc a path, yet it can recover
 from a search error. This patch returns -ENOMEM instead.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 fs/btrfs/ctree.h     |    7 ++++---
 fs/btrfs/root-tree.c |    4 +++-
 2 files changed, 7 insertions(+), 4 deletions(-)

--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -2400,9 +2400,10 @@ int btrfs_del_root(struct btrfs_trans_ha
 int btrfs_insert_root(struct btrfs_trans_handle *trans, struct btrfs_root
 		      *root, struct btrfs_key *key, struct btrfs_root_item
 		      *item);
-int btrfs_update_root(struct btrfs_trans_handle *trans, struct btrfs_root
-		      *root, struct btrfs_key *key, struct btrfs_root_item
-		      *item);
+int __must_check btrfs_update_root(struct btrfs_trans_handle *trans,
+				   struct btrfs_root *root,
+				   struct btrfs_key *key,
+				   struct btrfs_root_item *item);
 int btrfs_find_last_root(struct btrfs_root *root, u64 objectid, struct
 			 btrfs_root_item *item, struct btrfs_key *key);
 int btrfs_find_dead_roots(struct btrfs_root *root, u64 objectid);
--- a/fs/btrfs/root-tree.c
+++ b/fs/btrfs/root-tree.c
@@ -93,7 +93,9 @@ int btrfs_update_root(struct btrfs_trans
 	unsigned long ptr;
 
 	path = btrfs_alloc_path();
-	BUG_ON(!path);
+	if (!path)
+		return -ENOMEM;
+
 	ret = btrfs_search_slot(trans, root, key, path, 0, 1);
 	if (ret < 0)
 		goto out;



