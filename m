From: Miao Xie <miaox@cn.fujitsu.com>
Subject: [PATCH 3/4] btrfs: cleanup the unnecessary code in __tree_search()
 in ordered-data.c
Date: Tue, 15 Dec 2009 14:54:15 +0800
Message-ID: <4B273297.6040809@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Linux Btrfs <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

It is unnecessary to get the prev node by getting the next node first, because
we can get the prev node directly by rb_prev(). And it is also unnecessary to use
while loop to get the prev node.

This patch cleanups those unnecessary code in __tree_search() in ordered-data.c

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/ordered-data.c |   24 ++----------------------
 1 files changed, 2 insertions(+), 22 deletions(-)

diff --git a/fs/btrfs/ordered-data.c b/fs/btrfs/ordered-data.c
index 5799bc4..74128f6 100644
--- a/fs/btrfs/ordered-data.c
+++ b/fs/btrfs/ordered-data.c
@@ -69,7 +69,6 @@ static struct rb_node *__tree_search(struct rb_root *root, u64 file_offset,
 {
 	struct rb_node *n = root->rb_node;
 	struct rb_node *prev = NULL;
-	struct rb_node *test;
 	struct btrfs_ordered_extent *entry;
 	struct btrfs_ordered_extent *prev_entry = NULL;
 
@@ -88,28 +87,9 @@ static struct rb_node *__tree_search(struct rb_root *root, u64 file_offset,
 	if (!prev_ret)
 		return NULL;
 
-	while (prev && file_offset >= entry_end(prev_entry)) {
-		test = rb_next(prev);
-		if (!test)
-			break;
-		prev_entry = rb_entry(test, struct btrfs_ordered_extent,
-				      rb_node);
-		if (file_offset < entry_end(prev_entry))
-			break;
+	if (prev && file_offset < prev_entry->file_offset)
+		prev = rb_prev(prev);
 
-		prev = test;
-	}
-	if (prev)
-		prev_entry = rb_entry(prev, struct btrfs_ordered_extent,
-				      rb_node);
-	while (prev && file_offset < entry_end(prev_entry)) {
-		test = rb_prev(prev);
-		if (!test)
-			break;
-		prev_entry = rb_entry(test, struct btrfs_ordered_extent,
-				      rb_node);
-		prev = test;
-	}
 	*prev_ret = prev;
 	return NULL;
 }
-- 
1.6.5.2


