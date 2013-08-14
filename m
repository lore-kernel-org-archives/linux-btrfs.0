Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp.gentoo.org ([140.211.166.183]:53598 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758543Ab3HNUbG (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 14 Aug 2013 16:31:06 -0400
From: Sergei Trofimovich <slyfox@gentoo.org>
To: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Sergei Trofimovich <slyfox@gentoo.org>, Josef Bacik <jbacik@fusionio.com>,
        Chris Mason <chris.mason@fusionio.com>
Subject: [PATCH] btrfs: mark some local function as 'static'
Date: Wed, 14 Aug 2013 23:27:46 +0300
Message-Id: <1376512066-7284-1-git-send-email-slyfox@gentoo.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Cc: Josef Bacik <jbacik@fusionio.com>
Cc: Chris Mason <chris.mason@fusionio.com>
Signed-off-by: Sergei Trofimovich <slyfox@gentoo.org>
---
 fs/btrfs/ctree.h       | 2 --
 fs/btrfs/disk-io.c     | 8 ++++----
 fs/btrfs/extent_io.c   | 2 +-
 fs/btrfs/extent_io.h   | 1 -
 fs/btrfs/root-tree.c   | 4 ++--
 fs/btrfs/transaction.c | 2 +-
 fs/btrfs/transaction.h | 2 --
 7 files changed, 8 insertions(+), 13 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index e795bf1..e91ab9e 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -3414,8 +3414,6 @@ int __must_check btrfs_update_root(struct btrfs_trans_handle *trans,
 				   struct btrfs_root *root,
 				   struct btrfs_key *key,
 				   struct btrfs_root_item *item);
-void btrfs_read_root_item(struct extent_buffer *eb, int slot,
-			  struct btrfs_root_item *item);
 int btrfs_find_root(struct btrfs_root *root, struct btrfs_key *search_key,
 		    struct btrfs_path *path, struct btrfs_root_item *root_item,
 		    struct btrfs_key *root_key);
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 6b092a1..227339d 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1428,8 +1428,8 @@ int btrfs_add_log_tree(struct btrfs_trans_handle *trans,
 	return 0;
 }
 
-struct btrfs_root *btrfs_read_tree_root(struct btrfs_root *tree_root,
-					struct btrfs_key *key)
+static struct btrfs_root *btrfs_read_tree_root(struct btrfs_root *tree_root,
+					       struct btrfs_key *key)
 {
 	struct btrfs_root *root;
 	struct btrfs_fs_info *fs_info = tree_root->fs_info;
@@ -1529,8 +1529,8 @@ fail:
 	return ret;
 }
 
-struct btrfs_root *btrfs_lookup_fs_root(struct btrfs_fs_info *fs_info,
-					u64 root_id)
+static struct btrfs_root *btrfs_lookup_fs_root(struct btrfs_fs_info *fs_info,
+					       u64 root_id)
 {
 	struct btrfs_root *root;
 
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index fe443fe..045263a 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -1810,7 +1810,7 @@ out:
  * set the private field for a given byte offset in the tree.  If there isn't
  * an extent_state there already, this does nothing.
  */
-int set_state_private(struct extent_io_tree *tree, u64 start, u64 private)
+static int set_state_private(struct extent_io_tree *tree, u64 start, u64 private)
 {
 	struct rb_node *node;
 	struct extent_state *state;
diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
index 3b8c4e2..bb1f75d 100644
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -261,7 +261,6 @@ int extent_readpages(struct extent_io_tree *tree,
 		     get_extent_t get_extent);
 int extent_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
 		__u64 start, __u64 len, get_extent_t *get_extent);
-int set_state_private(struct extent_io_tree *tree, u64 start, u64 private);
 void extent_cache_csums_dio(struct extent_io_tree *tree, u64 start, u32 csums[],
 			    int count);
 void extent_cache_csums(struct extent_io_tree *tree, struct bio *bio,
diff --git a/fs/btrfs/root-tree.c b/fs/btrfs/root-tree.c
index ffb1036..92453f0 100644
--- a/fs/btrfs/root-tree.c
+++ b/fs/btrfs/root-tree.c
@@ -29,8 +29,8 @@
  * generation numbers as then we know the root was once mounted with an older
  * kernel that was not aware of the root item structure change.
  */
-void btrfs_read_root_item(struct extent_buffer *eb, int slot,
-			  struct btrfs_root_item *item)
+static void btrfs_read_root_item(struct extent_buffer *eb, int slot,
+				struct btrfs_root_item *item)
 {
 	uuid_le uuid;
 	int len;
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index af1931a..a689247 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -837,7 +837,7 @@ int btrfs_wait_marked_extents(struct btrfs_root *root,
  * them in one of two extent_io trees.  This is used to make sure all of
  * those extents are on disk for transaction or log commit
  */
-int btrfs_write_and_wait_marked_extents(struct btrfs_root *root,
+static int btrfs_write_and_wait_marked_extents(struct btrfs_root *root,
 				struct extent_io_tree *dirty_pages, int mark)
 {
 	int ret;
diff --git a/fs/btrfs/transaction.h b/fs/btrfs/transaction.h
index defbc42..5c2af84 100644
--- a/fs/btrfs/transaction.h
+++ b/fs/btrfs/transaction.h
@@ -160,8 +160,6 @@ int btrfs_should_end_transaction(struct btrfs_trans_handle *trans,
 void btrfs_throttle(struct btrfs_root *root);
 int btrfs_record_root_in_trans(struct btrfs_trans_handle *trans,
 				struct btrfs_root *root);
-int btrfs_write_and_wait_marked_extents(struct btrfs_root *root,
-				struct extent_io_tree *dirty_pages, int mark);
 int btrfs_write_marked_extents(struct btrfs_root *root,
 				struct extent_io_tree *dirty_pages, int mark);
 int btrfs_wait_marked_extents(struct btrfs_root *root,
-- 
1.8.3.2

