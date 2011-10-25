From: Jeff Mahoney <jeffm@suse.com>
Subject: [patch 15/66] btrfs: btrfs_update_root error push-up
Date: Mon, 24 Oct 2011 21:02:51 -0400
Message-ID: <20111025010852.290470912@suse.com>
References: <20111025010236.322699279@suse.com>
Cc: Linux Btrfs <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>,
	David Sterba <dsterba@suse.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

 btrfs_update_root BUG's when it can't alloc a path, yet it can recover
 from a search error. This patch returns -ENOMEM instead.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 fs/btrfs/ctree.h     |    6 +++---
 fs/btrfs/root-tree.c |    4 +++-
 2 files changed, 6 insertions(+), 4 deletions(-)

--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -2400,9 +2400,9 @@ int btrfs_del_root(struct btrfs_trans_ha
 int btrfs_insert_root(struct btrfs_trans_handle *trans, struct btrfs_root
 		      *root, struct btrfs_key *key, struct btrfs_root_item
 		      *item);
-int btrfs_update_root(struct btrfs_trans_handle *trans, struct btrfs_root
-		      *root, struct btrfs_key *key, struct btrfs_root_item
-		      *item);
+int btrfs_update_root(struct btrfs_trans_handle *trans,
+		      struct btrfs_root *root, struct btrfs_key *key,
+		      struct btrfs_root_item *item) __must_check;
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


