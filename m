From: Jeff Mahoney <jeffm@suse.com>
Subject: [patch 66/66] btrfs: update_inline_extent_backref should return void
Date: Mon, 24 Oct 2011 21:03:42 -0400
Message-ID: <20111025010858.133833006@suse.com>
References: <20111025010236.322699279@suse.com>
Cc: Linux Btrfs <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>,
	David Sterba <dsterba@suse.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

 Now that btrfs_truncate_item returns void, there are no more error
 conditions in update_inline_extent_backref and it should return void.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 fs/btrfs/extent-tree.c |   23 +++++++++++------------
 1 file changed, 11 insertions(+), 12 deletions(-)

--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -1649,12 +1649,12 @@ static int lookup_extent_backref(struct
  * helper to update/remove inline back ref
  */
 static noinline_for_stack
-int update_inline_extent_backref(struct btrfs_trans_handle *trans,
-				 struct btrfs_root *root,
-				 struct btrfs_path *path,
-				 struct btrfs_extent_inline_ref *iref,
-				 int refs_to_mod,
-				 struct btrfs_delayed_extent_op *extent_op)
+void update_inline_extent_backref(struct btrfs_trans_handle *trans,
+				  struct btrfs_root *root,
+				  struct btrfs_path *path,
+				  struct btrfs_extent_inline_ref *iref,
+				  int refs_to_mod,
+				  struct btrfs_delayed_extent_op *extent_op)
 {
 	struct extent_buffer *leaf;
 	struct btrfs_extent_item *ei;
@@ -1709,7 +1709,6 @@ int update_inline_extent_backref(struct
 		btrfs_truncate_item(trans, root, path, item_size, 1);
 	}
 	btrfs_mark_buffer_dirty(leaf);
-	return 0;
 }
 
 static noinline_for_stack
@@ -1729,8 +1728,8 @@ int insert_inline_extent_backref(struct
 					   root_objectid, owner, offset, 1);
 	if (ret == 0) {
 		BUG_ON(owner < BTRFS_FIRST_FREE_OBJECTID);
-		ret = update_inline_extent_backref(trans, root, path, iref,
-						   refs_to_add, extent_op);
+		update_inline_extent_backref(trans, root, path, iref,
+					     refs_to_add, extent_op);
 	} else if (ret == -ENOENT) {
 		setup_inline_extent_backref(trans, root, path, iref, parent,
 					    root_objectid, owner, offset,
@@ -1765,12 +1764,12 @@ static int remove_extent_backref(struct
 				 struct btrfs_extent_inline_ref *iref,
 				 int refs_to_drop, int is_data)
 {
-	int ret;
+	int ret = 0;
 
 	BUG_ON(!is_data && refs_to_drop != 1);
 	if (iref) {
-		ret = update_inline_extent_backref(trans, root, path, iref,
-						   -refs_to_drop, NULL);
+		update_inline_extent_backref(trans, root, path, iref,
+					     -refs_to_drop, NULL);
 	} else if (is_data) {
 		ret = remove_extent_data_ref(trans, root, path, refs_to_drop);
 	} else {


