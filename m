From: Liu Bo <liubo2009@cn.fujitsu.com>
Subject: [PATCH 2/2] Btrfs: use fastpath in extent state ops as much as possible
Date: Thu, 10 May 2012 18:10:39 +0800
Message-ID: <1336644639-21595-2-git-send-email-liubo2009@cn.fujitsu.com>
References: <1336644639-21595-1-git-send-email-liubo2009@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1336644639-21595-1-git-send-email-liubo2009@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

Fully utilize our extent state's new helper functions to use
fastpath as much as possible.

Signed-off-by: Liu Bo <liubo2009@cn.fujitsu.com>
---
 fs/btrfs/extent_io.c |   44 ++++++++++++++++++--------------------------
 1 files changed, 18 insertions(+), 26 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 198c2ba..f6e9191 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -570,10 +570,8 @@ hit_next:
 		if (err)
 			goto out;
 		if (state->end <= end) {
-			clear_state_bit(tree, state, &bits, wake);
-			if (last_end == (u64)-1)
-				goto out;
-			start = last_end + 1;
+			state = clear_state_bit(tree, state, &bits, wake);
+			goto next;
 		}
 		goto search_again;
 	}
@@ -781,7 +779,6 @@ hit_next:
 	 * Just lock what we found and keep going
 	 */
 	if (state->start == start && state->end <= end) {
-		struct rb_node *next_node;
 		if (state->state & exclusive_bits) {
 			*failed_start = state->start;
 			err = -EEXIST;
@@ -789,20 +786,15 @@ hit_next:
 		}
 
 		set_state_bits(tree, state, &bits);
-
 		cache_state(state, cached_state);
 		merge_state(tree, state);
 		if (last_end == (u64)-1)
 			goto out;
-
 		start = last_end + 1;
-		next_node = rb_next(&state->rb_node);
-		if (next_node && start < end && prealloc && !need_resched()) {
-			state = rb_entry(next_node, struct extent_state,
-					 rb_node);
-			if (state->start == start)
-				goto hit_next;
-		}
+		state = next_state(state);
+		if (start < end && state && state->start == start &&
+		    !need_resched())
+			goto hit_next;
 		goto search_again;
 	}
 
@@ -845,6 +837,10 @@ hit_next:
 			if (last_end == (u64)-1)
 				goto out;
 			start = last_end + 1;
+			state = next_state(state);
+			if (start < end && state && state->start == start &&
+			    !need_resched())
+				goto hit_next;
 		}
 		goto search_again;
 	}
@@ -994,21 +990,14 @@ hit_next:
 	 * Just lock what we found and keep going
 	 */
 	if (state->start == start && state->end <= end) {
-		struct rb_node *next_node;
-
 		set_state_bits(tree, state, &bits);
-		clear_state_bit(tree, state, &clear_bits, 0);
+		state = clear_state_bit(tree, state, &clear_bits, 0);
 		if (last_end == (u64)-1)
 			goto out;
-
 		start = last_end + 1;
-		next_node = rb_next(&state->rb_node);
-		if (next_node && start < end && prealloc && !need_resched()) {
-			state = rb_entry(next_node, struct extent_state,
-					 rb_node);
-			if (state->start == start)
-				goto hit_next;
-		}
+		if (start < end && state && state->start == start &&
+		    !need_resched())
+			goto hit_next;
 		goto search_again;
 	}
 
@@ -1042,10 +1031,13 @@ hit_next:
 			goto out;
 		if (state->end <= end) {
 			set_state_bits(tree, state, &bits);
-			clear_state_bit(tree, state, &clear_bits, 0);
+			state = clear_state_bit(tree, state, &clear_bits, 0);
 			if (last_end == (u64)-1)
 				goto out;
 			start = last_end + 1;
+			if (start < end && state && state->start == start &&
+			    !need_resched())
+				goto hit_next;
 		}
 		goto search_again;
 	}
-- 
1.6.5.2

