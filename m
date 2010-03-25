From: Miao Xie <miaox@cn.fujitsu.com>
Subject: [PATCH 06/18] Btrfs: Remove unnecessary variant in __tree_search
Date: Thu, 25 Mar 2010 20:30:51 +0800
Message-ID: <4BAB577B.3090902@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Linux Btrfs <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

From: Zhao Lei <zhaolei@cn.fujitsu.com>

"prev_entry"'s value is same as "entry" in reference.
We can use "entry" only in these function without readability impact.

Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/extent_map.c   |   14 ++++++--------
 fs/btrfs/ordered-data.c |   16 +++++++---------
 2 files changed, 13 insertions(+), 17 deletions(-)

diff --git a/fs/btrfs/extent_map.c b/fs/btrfs/extent_map.c
index 5a01f35..9f83eab 100644
--- a/fs/btrfs/extent_map.c
+++ b/fs/btrfs/extent_map.c
@@ -116,13 +116,11 @@ static struct rb_node *__tree_search(struct rb_root *root, u64 offset,
 	struct rb_node *n = root->rb_node;
 	struct rb_node *prev = NULL;
 	struct rb_node *orig_prev = NULL;
-	struct extent_map *entry;
-	struct extent_map *prev_entry = NULL;
+	struct extent_map *entry = NULL;
 
 	while (n) {
 		entry = rb_entry(n, struct extent_map, rb_node);
 		prev = n;
-		prev_entry = entry;
 
 		WARN_ON(!entry->in_tree);
 
@@ -136,19 +134,19 @@ static struct rb_node *__tree_search(struct rb_root *root, u64 offset,
 
 	if (prev_ret) {
 		orig_prev = prev;
-		while (prev && offset >= extent_map_end(prev_entry)) {
+		while (prev && offset >= extent_map_end(entry)) {
 			prev = rb_next(prev);
-			prev_entry = rb_entry(prev, struct extent_map, rb_node);
+			entry = rb_entry(prev, struct extent_map, rb_node);
 		}
 		*prev_ret = prev;
 		prev = orig_prev;
 	}
 
 	if (next_ret) {
-		prev_entry = rb_entry(prev, struct extent_map, rb_node);
-		while (prev && offset < prev_entry->start) {
+		entry = rb_entry(prev, struct extent_map, rb_node);
+		while (prev && offset < entry->start) {
 			prev = rb_prev(prev);
-			prev_entry = rb_entry(prev, struct extent_map, rb_node);
+			entry = rb_entry(prev, struct extent_map, rb_node);
 		}
 		*next_ret = prev;
 	}
diff --git a/fs/btrfs/ordered-data.c b/fs/btrfs/ordered-data.c
index a8ffecd..2d221a4 100644
--- a/fs/btrfs/ordered-data.c
+++ b/fs/btrfs/ordered-data.c
@@ -70,13 +70,11 @@ static struct rb_node *__tree_search(struct rb_root *root, u64 file_offset,
 	struct rb_node *n = root->rb_node;
 	struct rb_node *prev = NULL;
 	struct rb_node *test;
-	struct btrfs_ordered_extent *entry;
-	struct btrfs_ordered_extent *prev_entry = NULL;
+	struct btrfs_ordered_extent *entry = NULL;
 
 	while (n) {
 		entry = rb_entry(n, struct btrfs_ordered_extent, rb_node);
 		prev = n;
-		prev_entry = entry;
 
 		if (file_offset < entry->file_offset)
 			n = n->rb_left;
@@ -88,25 +86,25 @@ static struct rb_node *__tree_search(struct rb_root *root, u64 file_offset,
 	if (!prev_ret)
 		return NULL;
 
-	while (prev && file_offset >= entry_end(prev_entry)) {
+	while (prev && file_offset >= entry_end(entry)) {
 		test = rb_next(prev);
 		if (!test)
 			break;
-		prev_entry = rb_entry(test, struct btrfs_ordered_extent,
+		entry = rb_entry(test, struct btrfs_ordered_extent,
 				      rb_node);
-		if (file_offset < entry_end(prev_entry))
+		if (file_offset < entry_end(entry))
 			break;
 
 		prev = test;
 	}
 	if (prev)
-		prev_entry = rb_entry(prev, struct btrfs_ordered_extent,
+		entry = rb_entry(prev, struct btrfs_ordered_extent,
 				      rb_node);
-	while (prev && file_offset < entry_end(prev_entry)) {
+	while (prev && file_offset < entry_end(entry)) {
 		test = rb_prev(prev);
 		if (!test)
 			break;
-		prev_entry = rb_entry(test, struct btrfs_ordered_extent,
+		entry = rb_entry(test, struct btrfs_ordered_extent,
 				      rb_node);
 		prev = test;
 	}
-- 
1.6.5.2


