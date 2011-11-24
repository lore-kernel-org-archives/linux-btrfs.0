From: Jeff Mahoney <jeffm@suse.com>
Subject: [patch 68/99] btrfs: setup_items_for_insert should return void
Date: Wed, 23 Nov 2011 19:36:41 -0500
Message-ID: <20111124004227.688829387@suse.com>
References: <20111124003533.395674389@suse.com>
To: Btrfs List <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

 setup_items_for_insert now has no error conditions and should return void.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 fs/btrfs/ctree.c         |   26 ++++++++++----------------
 fs/btrfs/ctree.h         |    8 ++++----
 fs/btrfs/delayed-inode.c |    6 ++----
 3 files changed, 16 insertions(+), 24 deletions(-)

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index dedd3a1..fdaddcc 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -2516,7 +2516,6 @@ static noinline int __push_leaf_left(struct btrfs_trans_handle *trans,
 	u32 old_left_nritems;
 	u32 nr;
 	int ret = 0;
-	int wret;
 	u32 this_item_size;
 	u32 old_left_item_size;
 
@@ -3212,11 +3211,9 @@ int btrfs_duplicate_item(struct btrfs_trans_handle *trans,
 		return ret;
 
 	path->slots[0]++;
-	ret = setup_items_for_insert(trans, root, path, new_key, &item_size,
-				     item_size, item_size +
-				     sizeof(struct btrfs_item), 1);
-	BUG_ON(ret);
-
+	setup_items_for_insert(trans, root, path, new_key, &item_size,
+			       item_size, item_size +
+			       sizeof(struct btrfs_item), 1);
 	leaf = path->nodes[0];
 	memcpy_extent_buffer(leaf,
 			     btrfs_item_ptr_offset(leaf, path->slots[0]),
@@ -3536,10 +3533,10 @@ out:
  * to save stack depth by doing the bulk of the work in a function
  * that doesn't call btrfs_search_slot
  */
-int setup_items_for_insert(struct btrfs_trans_handle *trans,
-			   struct btrfs_root *root, struct btrfs_path *path,
-			   struct btrfs_key *cpu_key, u32 *data_size,
-			   u32 total_data, u32 total_size, int nr)
+void setup_items_for_insert(struct btrfs_trans_handle *trans,
+			    struct btrfs_root *root, struct btrfs_path *path,
+			    struct btrfs_key *cpu_key, u32 *data_size,
+			    u32 total_data, u32 total_size, int nr)
 {
 	struct btrfs_item *item;
 	int i;
@@ -3617,7 +3614,6 @@ int setup_items_for_insert(struct btrfs_trans_handle *trans,
 		btrfs_print_leaf(root, leaf);
 		BUG();
 	}
-	return ret;
 }
 
 /*
@@ -3644,16 +3640,14 @@ int btrfs_insert_empty_items(struct btrfs_trans_handle *trans,
 	if (ret == 0)
 		return -EEXIST;
 	if (ret < 0)
-		goto out;
+		return ret;
 
 	slot = path->slots[0];
 	BUG_ON(slot < 0);
 
-	ret = setup_items_for_insert(trans, root, path, cpu_key, data_size,
+	setup_items_for_insert(trans, root, path, cpu_key, data_size,
 			       total_data, total_size, nr);
-
-out:
-	return ret;
+	return 0;
 }
 
 /*
diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index c866167..ea47c73 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -2344,10 +2344,10 @@ static inline int btrfs_del_item(struct btrfs_trans_handle *trans,
 	return btrfs_del_items(trans, root, path, path->slots[0], 1);
 }
 
-int setup_items_for_insert(struct btrfs_trans_handle *trans,
-			   struct btrfs_root *root, struct btrfs_path *path,
-			   struct btrfs_key *cpu_key, u32 *data_size,
-			   u32 total_data, u32 total_size, int nr);
+void setup_items_for_insert(struct btrfs_trans_handle *trans,
+			    struct btrfs_root *root, struct btrfs_path *path,
+			    struct btrfs_key *cpu_key, u32 *data_size,
+			    u32 total_data, u32 total_size, int nr);
 int btrfs_insert_item(struct btrfs_trans_handle *trans, struct btrfs_root
 		      *root, struct btrfs_key *key, void *data, u32 data_size);
 int btrfs_insert_empty_items(struct btrfs_trans_handle *trans,
diff --git a/fs/btrfs/delayed-inode.c b/fs/btrfs/delayed-inode.c
index b52c672..6211997 100644
--- a/fs/btrfs/delayed-inode.c
+++ b/fs/btrfs/delayed-inode.c
@@ -738,10 +738,8 @@ static int btrfs_batch_insert_items(struct btrfs_trans_handle *trans,
 	btrfs_clear_path_blocking(path, NULL, 0);
 
 	/* insert the keys of the items */
-	ret = setup_items_for_insert(trans, root, path, keys, data_size,
-				     total_data_size, total_size, nitems);
-	if (ret)
-		goto error;
+	setup_items_for_insert(trans, root, path, keys, data_size,
+			       total_data_size, total_size, nitems);
 
 	/* insert the dir index items */
 	slot = path->slots[0];



