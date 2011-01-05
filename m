From: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
Subject: [PATCH] btrfs: check NULL or not
Date: Wed, 05 Jan 2011 11:32:22 +0900
Message-ID: <201101050232.AA00003@T-ITOH1.jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: chris.mason@oracle.com
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Should check if functions returns NULL or not.

Signed-off-by: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
---
 fs/btrfs/ctree.c     |    6 ++++++
 fs/btrfs/disk-io.c   |    8 ++++++++
 fs/btrfs/extent_io.c |    2 ++
 3 files changed, 16 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index 9ac1715..f68c6ff 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -2514,6 +2514,9 @@ static int push_leaf_right(struct btrfs_trans_handle *trans, struct btrfs_root
 	btrfs_assert_tree_locked(path->nodes[1]);
 
 	right = read_node_slot(root, upper, slot + 1);
+	if (right == NULL)
+		return 1;
+
 	btrfs_tree_lock(right);
 	btrfs_set_lock_blocking(right);
 
@@ -2764,6 +2767,9 @@ static int push_leaf_left(struct btrfs_trans_handle *trans, struct btrfs_root
 	btrfs_assert_tree_locked(path->nodes[1]);
 
 	left = read_node_slot(root, path->nodes[1], slot - 1);
+	if (left == NULL)
+		return 1;
+
 	btrfs_tree_lock(left);
 	btrfs_set_lock_blocking(left);
 
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index a5d2249..5ede105 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -353,6 +353,10 @@ static int csum_dirty_buffer(struct btrfs_root *root, struct page *page)
 	WARN_ON(len == 0);
 
 	eb = alloc_extent_buffer(tree, start, len, page, GFP_NOFS);
+	if (eb == NULL) {
+		WARN_ON(1);
+		goto out;
+	}
 	ret = btree_read_extent_buffer_pages(root, eb, start + PAGE_CACHE_SIZE,
 					     btrfs_header_generation(eb));
 	BUG_ON(ret);
@@ -427,6 +431,10 @@ static int btree_readpage_end_io_hook(struct page *page, u64 start, u64 end,
 	WARN_ON(len == 0);
 
 	eb = alloc_extent_buffer(tree, start, len, page, GFP_NOFS);
+	if (eb == NULL) {
+		ret = -EIO;
+		goto out;
+	}
 
 	found_start = btrfs_header_bytenr(eb);
 	if (found_start != start) {
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 5e7a94d..d05c5d2 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -3072,6 +3072,8 @@ static struct extent_buffer *__alloc_extent_buffer(struct extent_io_tree *tree,
 #endif
 
 	eb = kmem_cache_zalloc(extent_buffer_cache, mask);
+	if (eb == NULL)
+		return NULL;
 	eb->start = start;
 	eb->len = len;
 	spin_lock_init(&eb->lock);


