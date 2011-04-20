From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Subject: [PATCH v2 2/2] Btrfs: fix unsafe usage of merge_state
Date: Wed, 20 Apr 2011 14:45:49 +0800
Message-ID: <4DAE811D.6080506@cn.fujitsu.com>
References: <4DAE80E9.2010102@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: LKML <linux-kernel@vger.kernel.org>,
	BTRFS <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4DAE80E9.2010102@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

merge_state can free the current state if it can be merged with the next node,
but in set_extent_bit(), after merge_state, we still use the current extent to
get the next node and cache it into cached_state

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 fs/btrfs/extent_io.c |   22 ++++++++++++++--------
 1 files changed, 14 insertions(+), 8 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index f36e284..129601e 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -780,20 +780,18 @@ hit_next:
 		if (err)
 			goto out;
 
+		next_node = rb_next(node);
 		cache_state(state, cached_state);
 		merge_state(tree, state);
 		if (last_end == (u64)-1)
 			goto out;
 
 		start = last_end + 1;
-		if (start < end && prealloc && !need_resched()) {
-			next_node = rb_next(node);
-			if (next_node) {
-				state = rb_entry(next_node, struct extent_state,
-						 rb_node);
-				if (state->start == start)
-					goto hit_next;
-			}
+		if (next_node && start < end && prealloc && !need_resched()) {
+			state = rb_entry(next_node, struct extent_state,
+					 rb_node);
+			if (state->start == start)
+				goto hit_next;
 		}
 		goto search_again;
 	}
@@ -856,14 +854,22 @@ hit_next:
 
 		prealloc = alloc_extent_state_atomic(prealloc);
 		BUG_ON(!prealloc);
+
+		/*
+		 * Avoid to free 'prealloc' if it can be merged with
+		 * the later extent.
+		 */
+		atomic_inc(&prealloc->refs);
 		err = insert_state(tree, prealloc, start, this_end,
 				   &bits);
 		BUG_ON(err == -EEXIST);
 		if (err) {
+			free_extent_state(prealloc);
 			prealloc = NULL;
 			goto out;
 		}
 		cache_state(prealloc, cached_state);
+		free_extent_state(prealloc);
 		prealloc = NULL;
 		start = this_end + 1;
 		goto search_again;
-- 
1.7.4.2
