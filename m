From: Liu Bo <liubo2009@cn.fujitsu.com>
Subject: [PATCH 2/5] Btrfs: merge adjacent states as much as possible
Date: Thu, 15 Mar 2012 17:12:14 +0800
Message-ID: <1331802737-29454-3-git-send-email-liubo2009@cn.fujitsu.com>
References: <1331802737-29454-1-git-send-email-liubo2009@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1331802737-29454-1-git-send-email-liubo2009@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

In order to reduce write locks, we do merge_state as much as much as possible.

Signed-off-by: Liu Bo <liubo2009@cn.fujitsu.com>
---
 fs/btrfs/extent_io.c |   47 +++++++++++++++++++++++++++--------------------
 1 files changed, 27 insertions(+), 20 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index e6433d4..7e76403 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -267,29 +267,36 @@ static void merge_state(struct extent_io_tree *tree,
 	if (state->state & (EXTENT_IOBITS | EXTENT_BOUNDARY))
 		return;
 
-	other_node = rb_prev(&state->rb_node);
-	if (other_node) {
+	while (1) {
+		other_node = rb_prev(&state->rb_node);
+		if (!other_node)
+			break;
 		other = rb_entry(other_node, struct extent_state, rb_node);
-		if (other->end == state->start - 1 &&
-		    other->state == state->state) {
-			merge_cb(tree, state, other);
-			state->start = other->start;
-			other->tree = NULL;
-			rb_erase(&other->rb_node, &tree->state);
-			free_extent_state(other);
-		}
+		if (other->end != state->start - 1 ||
+		    other->state != state->state)
+			break;
+
+		merge_cb(tree, state, other);
+		state->start = other->start;
+		other->tree = NULL;
+		rb_erase(&other->rb_node, &tree->state);
+		free_extent_state(other);
 	}
-	other_node = rb_next(&state->rb_node);
-	if (other_node) {
+
+	while (1) {
+		other_node = rb_next(&state->rb_node);
+		if (!other_node)
+			break;
 		other = rb_entry(other_node, struct extent_state, rb_node);
-		if (other->start == state->end + 1 &&
-		    other->state == state->state) {
-			merge_cb(tree, state, other);
-			state->end = other->end;
-			other->tree = NULL;
-			rb_erase(&other->rb_node, &tree->state);
-			free_extent_state(other);
-		}
+		if (other->start != state->end + 1 ||
+		    other->state != state->state)
+			break;
+
+		merge_cb(tree, state, other);
+		state->end = other->end;
+		other->tree = NULL;
+		rb_erase(&other->rb_node, &tree->state);
+		free_extent_state(other);
 	}
 }
 
-- 
1.6.5.2

