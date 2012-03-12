From: Li Zefan <lizf@cn.fujitsu.com>
Subject: [PATCH 2/2][RESEND] Btrfs: avoid possible use-after-free in clear_extent_bit()
Date: Mon, 12 Mar 2012 17:07:23 +0800
Message-ID: <4F5DBCCB.5080709@cn.fujitsu.com>
References: <4F5DB640.3010102@cn.fujitsu.com> <4F5DB654.6020807@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4F5DB654.6020807@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

clear_extent_bit()
{
    next_node = rb_next(&state->rb_node);
    ...
    clear_state_bit(state);  <-- this may free next_node
    if (next_node) {
        state = rb_entry(next_node);
        ...
    }
}

clear_state_bit() calls merge_state() which may free the next node
of the passing extent_state, so clear_extent_bit() may end up
referencing freed memory.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---

no more Chinese characters in this section. ;)

---
 fs/btrfs/extent_io.c |   36 +++++++++++++++++++++---------------
 1 files changed, 21 insertions(+), 15 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index c968c95..20f2f5a 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -392,6 +392,15 @@ static int split_state(struct extent_io_tree *tree, struct extent_state *orig,
 	return 0;
 }
 
+static struct extent_state *next_state(struct extent_state *state)
+{
+	struct rb_node *next = rb_next(&state->rb_node);
+	if (next)
+		return rb_entry(next, struct extent_state, rb_node);
+	else
+		return NULL;
+}
+
 /*
  * utility function to clear some bits in an extent state struct.
  * it will optionally wake up any one waiting on this state (wake == 1)
@@ -399,10 +408,11 @@ static int split_state(struct extent_io_tree *tree, struct extent_state *orig,
  * If no bits are set on the state struct after clearing things, the
  * struct is freed and removed from the tree
  */
-static void clear_state_bit(struct extent_io_tree *tree,
-			    struct extent_state *state,
-			    int *bits, int wake)
+static struct extent_state *clear_state_bit(struct extent_io_tree *tree,
+					    struct extent_state *state,
+					    int *bits, int wake)
 {
+	struct extent_state *next;
 	int bits_to_clear = *bits & ~EXTENT_CTLBITS;
 
 	if ((bits_to_clear & EXTENT_DIRTY) && (state->state & EXTENT_DIRTY)) {
@@ -415,6 +425,7 @@ static void clear_state_bit(struct extent_io_tree *tree,
 	if (wake)
 		wake_up(&state->wq);
 	if (state->state == 0) {
+		next = next_state(state);
 		if (state->tree) {
 			rb_erase(&state->rb_node, &tree->state);
 			state->tree = NULL;
@@ -424,7 +435,9 @@ static void clear_state_bit(struct extent_io_tree *tree,
 		}
 	} else {
 		merge_state(tree, state);
+		next = next_state(state);
 	}
+	return next;
 }
 
 static struct extent_state *
@@ -456,7 +469,6 @@ int clear_extent_bit(struct extent_io_tree *tree, u64 start, u64 end,
 	struct extent_state *state;
 	struct extent_state *cached;
 	struct extent_state *prealloc = NULL;
-	struct rb_node *next_node;
 	struct rb_node *node;
 	u64 last_end;
 	int err;
@@ -508,14 +520,11 @@ hit_next:
 	WARN_ON(state->end < start);
 	last_end = state->end;
 
-	if (state->end < end && !need_resched())
-		next_node = rb_next(&state->rb_node);
-	else
-		next_node = NULL;
-
 	/* the state doesn't have the wanted bits, go ahead */
-	if (!(state->state & bits))
+	if (!(state->state & bits)) {
+		state = next_state(state);
 		goto next;
+	}
 
 	/*
 	 *     | ---- desired range ---- |
@@ -569,16 +578,13 @@ hit_next:
 		goto out;
 	}
 
-	clear_state_bit(tree, state, &bits, wake);
+	state = clear_state_bit(tree, state, &bits, wake);
 next:
 	if (last_end == (u64)-1)
 		goto out;
 	start = last_end + 1;
-	if (start <= end && next_node) {
-		state = rb_entry(next_node, struct extent_state,
-				 rb_node);
+	if (start <= end && state && !need_resched())
 		goto hit_next;
-	}
 	goto search_again;
 
 out:
-- 1.7.3.1 

