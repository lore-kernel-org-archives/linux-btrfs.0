Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from victor.provo.novell.com ([137.65.250.26]:36905 "EHLO
        prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933369AbdKHAyy (ORCPT
        <rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
        Tue, 7 Nov 2017 19:54:54 -0500
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz, Filipe Manana <fdmanana@gmail.com>
Subject: [PATCH v2 1/3] btrfs: tree-checker: Fix false panic for sanity test
Date: Wed,  8 Nov 2017 08:54:24 +0800
Message-Id: <20171108005426.17903-2-wqu@suse.com>
In-Reply-To: <20171108005426.17903-1-wqu@suse.com>
References: <20171108005426.17903-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

[BUG]
If we run btrfs with CONFIG_BTRFS_FS_RUN_SANITY_TESTS=y, it will
instantly cause kernel panic like:

------
...
assertion failed: 0, file: fs/btrfs/disk-io.c, line: 3853
...
Call Trace:
 btrfs_mark_buffer_dirty+0x187/0x1f0 [btrfs]
 setup_items_for_insert+0x385/0x650 [btrfs]
 __btrfs_drop_extents+0x129a/0x1870 [btrfs]
...
-----

[Cause]
Btrfs will call btrfs_check_leaf() in btrfs_mark_buffer_dirty() to check
if the leaf is valid with CONFIG_BTRFS_FS_RUN_SANITY_TESTS=y.

However quite some btrfs_mark_buffer_dirty() callers(*) don't really
initialize its item data but only initialize its item pointers, leaving
item data uninitialized.

This makes tree-checker catch uninitialized data as error, causing
such panic.

*: These callers include but not limited to
setup_items_for_insert()
btrfs_split_item()
btrfs_expand_item()

[Fix]
Add a new parameter @check_item_data to btrfs_check_leaf().
With @check_item_data set to false, item data check will be skipped and
fallback to old btrfs_check_leaf() behavior.

So we can still get early warning if we screw up item pointers, and
avoid false panic.

Cc: Filipe Manana <fdmanana@gmail.com>
Reported-by: Lakshmipathi.G <lakshmipathi.g@gmail.com>
Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/disk-io.c      | 10 ++++++++--
 fs/btrfs/tree-checker.c | 27 ++++++++++++++++++++++-----
 fs/btrfs/tree-checker.h | 14 +++++++++++++-
 3 files changed, 43 insertions(+), 8 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index efce9a2fa9be..10a2a579cc7f 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -610,7 +610,7 @@ static int btree_readpage_end_io_hook(struct btrfs_io_bio *io_bio,
 	 * that we don't try and read the other copies of this block, just
 	 * return -EIO.
 	 */
-	if (found_level == 0 && btrfs_check_leaf(root, eb)) {
+	if (found_level == 0 && btrfs_check_leaf_full(root, eb)) {
 		set_bit(EXTENT_BUFFER_CORRUPT, &eb->bflags);
 		ret = -EIO;
 	}
@@ -3848,7 +3848,13 @@ void btrfs_mark_buffer_dirty(struct extent_buffer *buf)
 					 buf->len,
 					 fs_info->dirty_metadata_batch);
 #ifdef CONFIG_BTRFS_FS_CHECK_INTEGRITY
-	if (btrfs_header_level(buf) == 0 && btrfs_check_leaf(root, buf)) {
+	/*
+	 * Since btrfs_mark_buffer_dirty() can be called with item pointer set
+	 * but item data not updated.
+	 * So here we should only check item pointers, not item data.
+	 */
+	if (btrfs_header_level(buf) == 0 &&
+	    btrfs_check_leaf_relaxed(root, buf)) {
 		btrfs_print_leaf(buf);
 		ASSERT(0);
 	}
diff --git a/fs/btrfs/tree-checker.c b/fs/btrfs/tree-checker.c
index 114fc5f0ecc5..ce4ed6ec8f39 100644
--- a/fs/btrfs/tree-checker.c
+++ b/fs/btrfs/tree-checker.c
@@ -242,7 +242,8 @@ static int check_leaf_item(struct btrfs_root *root,
 	return ret;
 }
 
-int btrfs_check_leaf(struct btrfs_root *root, struct extent_buffer *leaf)
+static int check_leaf(struct btrfs_root *root, struct extent_buffer *leaf,
+		      bool check_item_data)
 {
 	struct btrfs_fs_info *fs_info = root->fs_info;
 	/* No valid key type is 0, so all key should be larger than this key */
@@ -361,10 +362,15 @@ int btrfs_check_leaf(struct btrfs_root *root, struct extent_buffer *leaf)
 			return -EUCLEAN;
 		}
 
-		/* Check if the item size and content meet other criteria */
-		ret = check_leaf_item(root, leaf, &key, slot);
-		if (ret < 0)
-			return ret;
+		if (check_item_data) {
+			/*
+			 * Check if the item size and content meet other
+			 * criteria
+			 */
+			ret = check_leaf_item(root, leaf, &key, slot);
+			if (ret < 0)
+				return ret;
+		}
 
 		prev_key.objectid = key.objectid;
 		prev_key.type = key.type;
@@ -374,6 +380,17 @@ int btrfs_check_leaf(struct btrfs_root *root, struct extent_buffer *leaf)
 	return 0;
 }
 
+int btrfs_check_leaf_full(struct btrfs_root *root, struct extent_buffer *leaf)
+{
+	return check_leaf(root, leaf, true);
+}
+
+int btrfs_check_leaf_relaxed(struct btrfs_root *root,
+			     struct extent_buffer *leaf)
+{
+	return check_leaf(root, leaf, false);
+}
+
 int btrfs_check_node(struct btrfs_root *root, struct extent_buffer *node)
 {
 	unsigned long nr = btrfs_header_nritems(node);
diff --git a/fs/btrfs/tree-checker.h b/fs/btrfs/tree-checker.h
index 96c486e95d70..3d53e8d6fda0 100644
--- a/fs/btrfs/tree-checker.h
+++ b/fs/btrfs/tree-checker.h
@@ -20,7 +20,19 @@
 #include "ctree.h"
 #include "extent_io.h"
 
-int btrfs_check_leaf(struct btrfs_root *root, struct extent_buffer *leaf);
+/*
+ * Comprehensive leaf checker.
+ * Will check not only the item pointers, but also every possible member
+ * in item data.
+ */
+int btrfs_check_leaf_full(struct btrfs_root *root, struct extent_buffer *leaf);
+
+/*
+ * Less strict leaf checker.
+ * Will only check item pointers, not reading item data.
+ */
+int btrfs_check_leaf_relaxed(struct btrfs_root *root,
+			     struct extent_buffer *leaf);
 int btrfs_check_node(struct btrfs_root *root, struct extent_buffer *node);
 
 #endif
-- 
2.15.0

