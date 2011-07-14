From: Li Zefan <lizf@cn.fujitsu.com>
Subject: [PATCH 14/16] Btrfs: clean up for insert_state()
Date: Thu, 14 Jul 2011 11:19:08 +0800
Message-ID: <4E1E602C.3060101@cn.fujitsu.com>
References: <4E1E5F59.5030208@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4E1E5F59.5030208@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>

Don't duplicate set_state_bits().

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 fs/btrfs/extent_io.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index b181a94..6c7394f 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -308,6 +308,9 @@ static void clear_state_cb(struct extent_io_tree *tree,
 		tree->ops->clear_bit_hook(tree->mapping->host, state, bits);
 }
 
+static int set_state_bits(struct extent_io_tree *tree,
+			  struct extent_state *state, int *bits);
+
 /*
  * insert an extent_state struct into the tree.  'bits' are set on the
  * struct before it is inserted.
@@ -323,7 +326,6 @@ static int insert_state(struct extent_io_tree *tree,
 			int *bits)
 {
 	struct rb_node *node;
-	int bits_to_set = *bits & ~EXTENT_CTLBITS;
 	int ret;
 
 	if (end < start) {
@@ -334,13 +336,11 @@ static int insert_state(struct extent_io_tree *tree,
 	}
 	state->start = start;
 	state->end = end;
-	ret = set_state_cb(tree, state, bits);
+
+	ret = set_state_bits(tree, state, bits);
 	if (ret)
 		return ret;
 
-	if (bits_to_set & EXTENT_DIRTY)
-		tree->dirty_bytes += end - start + 1;
-	state->state |= bits_to_set;
 	node = tree_insert(&tree->state, end, &state->rb_node);
 	if (node) {
 		struct extent_state *found;
-- 
1.7.3.1
