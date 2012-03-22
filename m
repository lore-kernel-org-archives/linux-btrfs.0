From: Jeff Mahoney <jeffm@suse.com>
Subject: [patch 10/35] btrfs: btrfs_update_root error push-up
Date: Wed, 21 Mar 2012 21:11:14 -0400
Message-ID: <20120322011134.369657433@suse.com>
References: <20120322011104.212214639@suse.com>
Cc: David Sterba <dsterba@suse.com>
To: Linux Btrfs List <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

btrfs_update_root BUG's when it can't alloc a path, yet it can recover
from a search error. This patch returns -ENOMEM instead.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 fs/btrfs/ctree.h     |    7 ++++---
 fs/btrfs/root-tree.c |    4 +++-
 2 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index a97a670..339e637 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -2724,9 +2724,10 @@ int btrfs_del_root(struct btrfs_trans_handle *trans, struct btrfs_root *root,
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
diff --git a/fs/btrfs/root-tree.c b/fs/btrfs/root-tree.c
index 1fd93d6..1486cf9 100644
--- a/fs/btrfs/root-tree.c
+++ b/fs/btrfs/root-tree.c
@@ -93,7 +93,9 @@ int btrfs_update_root(struct btrfs_trans_handle *trans, struct btrfs_root
 	unsigned long ptr;
 
 	path = btrfs_alloc_path();
-	BUG_ON(!path);
+	if (!path)
+		return -ENOMEM;
+
 	ret = btrfs_search_slot(trans, root, key, path, 0, 1);
 	if (ret < 0)
 		goto out;
-- 
1.7.9



