From: Li Zefan <lizf@cn.fujitsu.com>
Subject: [PATCH 16/16] Btrfs: clean up for find_first_extent_bit()
Date: Thu, 14 Jul 2011 11:19:45 +0800
Message-ID: <4E1E6051.4040505@cn.fujitsu.com>
References: <4E1E5F59.5030208@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
	Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4E1E5F59.5030208@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>

find_first_extent_bit() and find_first_extent_bit_state() share
most of the code, and we can just make the former call the latter.

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 fs/btrfs/extent_io.c |   64 ++++++++++++++++++-------------------------------
 1 files changed, 24 insertions(+), 40 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 1959a63..a31ffa5 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -1055,46 +1055,6 @@ static int set_range_writeback(struct extent_io_tree *tree, u64 start, u64 end)
 	return 0;
 }
 
-/*
- * find the first offset in the io tree with 'bits' set. zero is
- * returned if we find something, and *start_ret and *end_ret are
- * set to reflect the state struct that was found.
- *
- * If nothing was found, 1 is returned, < 0 on error
- */
-int find_first_extent_bit(struct extent_io_tree *tree, u64 start,
-			  u64 *start_ret, u64 *end_ret, int bits)
-{
-	struct rb_node *node;
-	struct extent_state *state;
-	int ret = 1;
-
-	spin_lock(&tree->lock);
-	/*
-	 * this search will find all the extents that end after
-	 * our range starts.
-	 */
-	node = tree_search(tree, start);
-	if (!node)
-		goto out;
-
-	while (1) {
-		state = rb_entry(node, struct extent_state, rb_node);
-		if (state->end >= start && (state->state & bits)) {
-			*start_ret = state->start;
-			*end_ret = state->end;
-			ret = 0;
-			break;
-		}
-		node = rb_next(node);
-		if (!node)
-			break;
-	}
-out:
-	spin_unlock(&tree->lock);
-	return ret;
-}
-
 /* find the first state struct with 'bits' set after 'start', and
  * return it.  tree->lock must be held.  NULL will returned if
  * nothing was found after 'start'
@@ -1127,6 +1087,30 @@ out:
 }
 
 /*
+ * find the first offset in the io tree with 'bits' set. zero is
+ * returned if we find something, and *start_ret and *end_ret are
+ * set to reflect the state struct that was found.
+ *
+ * If nothing was found, 1 is returned, < 0 on error
+ */
+int find_first_extent_bit(struct extent_io_tree *tree, u64 start,
+			  u64 *start_ret, u64 *end_ret, int bits)
+{
+	struct extent_state *state;
+	int ret = 1;
+
+	spin_lock(&tree->lock);
+	state = find_first_extent_bit_state(tree, start, bits);
+	if (state) {
+		*start_ret = state->start;
+		*end_ret = state->end;
+		ret = 0;
+	}
+	spin_unlock(&tree->lock);
+	return ret;
+}
+
+/*
  * find a contiguous range of bytes in the file marked as delalloc, not
  * more than 'max_bytes'.  start and end are used to return the range,
  *
-- 
1.7.3.1
