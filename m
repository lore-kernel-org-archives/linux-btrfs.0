Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:4403 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751384AbdCCJHf (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 3 Mar 2017 04:07:35 -0500
From: Elena Reshetova <elena.reshetova@intel.com>
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org,
        peterz@infradead.org, gregkh@linuxfoundation.org, jbacik@fb.com,
        clm@fb.com, dsterba@suse.com,
        Elena Reshetova <elena.reshetova@intel.com>,
        Hans Liljestrand <ishkamiel@gmail.com>,
        Kees Cook <keescook@chromium.org>, David Windsor <dwindsor@gmail.com>
Subject: [PATCH 10/17] fs, btrfs: convert extent_state.refs from atomic_t to refcount_t
Date: Fri,  3 Mar 2017 10:55:19 +0200
Message-Id: <1488531326-21271-11-git-send-email-elena.reshetova@intel.com>
In-Reply-To: <1488531326-21271-1-git-send-email-elena.reshetova@intel.com>
References: <1488531326-21271-1-git-send-email-elena.reshetova@intel.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

refcount_t type and corresponding API should be
used instead of atomic_t when the variable is used as
a reference counter. This allows to avoid accidental
refcounter overflows that might lead to use-after-free
situations.

Signed-off-by: Elena Reshetova <elena.reshetova@intel.com>
Signed-off-by: Hans Liljestrand <ishkamiel@gmail.com>
Signed-off-by: Kees Cook <keescook@chromium.org>
Signed-off-by: David Windsor <dwindsor@gmail.com>
---
 fs/btrfs/extent_io.c | 14 +++++++-------
 fs/btrfs/extent_io.h |  3 ++-
 2 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 3cf0b02..0702be6 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -68,7 +68,7 @@ void btrfs_leak_debug_check(void)
 		pr_err("BTRFS: state leak: start %llu end %llu state %u in tree %d refs %d\n",
 		       state->start, state->end, state->state,
 		       extent_state_in_tree(state),
-		       atomic_read(&state->refs));
+		       refcount_read(&state->refs));
 		list_del(&state->leak_list);
 		kmem_cache_free(extent_state_cache, state);
 	}
@@ -238,7 +238,7 @@ static struct extent_state *alloc_extent_state(gfp_t mask)
 	state->failrec = NULL;
 	RB_CLEAR_NODE(&state->rb_node);
 	btrfs_leak_debug_add(&state->leak_list, &states);
-	atomic_set(&state->refs, 1);
+	refcount_set(&state->refs, 1);
 	init_waitqueue_head(&state->wq);
 	trace_alloc_extent_state(state, mask, _RET_IP_);
 	return state;
@@ -248,7 +248,7 @@ void free_extent_state(struct extent_state *state)
 {
 	if (!state)
 		return;
-	if (atomic_dec_and_test(&state->refs)) {
+	if (refcount_dec_and_test(&state->refs)) {
 		WARN_ON(extent_state_in_tree(state));
 		btrfs_leak_debug_del(&state->leak_list);
 		trace_free_extent_state(state, _RET_IP_);
@@ -641,7 +641,7 @@ static int __clear_extent_bit(struct extent_io_tree *tree, u64 start, u64 end,
 		if (cached && extent_state_in_tree(cached) &&
 		    cached->start <= start && cached->end > start) {
 			if (clear)
-				atomic_dec(&cached->refs);
+				refcount_dec(&cached->refs);
 			state = cached;
 			goto hit_next;
 		}
@@ -793,7 +793,7 @@ static void wait_extent_bit(struct extent_io_tree *tree, u64 start, u64 end,
 
 		if (state->state & bits) {
 			start = state->start;
-			atomic_inc(&state->refs);
+			refcount_inc(&state->refs);
 			wait_on_state(tree, state);
 			free_extent_state(state);
 			goto again;
@@ -834,7 +834,7 @@ static void cache_state_if_flags(struct extent_state *state,
 	if (cached_ptr && !(*cached_ptr)) {
 		if (!flags || (state->state & flags)) {
 			*cached_ptr = state;
-			atomic_inc(&state->refs);
+			refcount_inc(&state->refs);
 		}
 	}
 }
@@ -1538,7 +1538,7 @@ static noinline u64 find_delalloc_range(struct extent_io_tree *tree,
 		if (!found) {
 			*start = state->start;
 			*cached_state = state;
-			atomic_inc(&state->refs);
+			refcount_inc(&state->refs);
 		}
 		found++;
 		*end = state->end;
diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
index c16260c..9ea9338 100644
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -2,6 +2,7 @@
 #define __EXTENTIO__
 
 #include <linux/rbtree.h>
+#include <linux/refcount.h>
 #include "ulist.h"
 
 /* bits for the extent state */
@@ -134,7 +135,7 @@ struct extent_state {
 
 	/* ADD NEW ELEMENTS AFTER THIS */
 	wait_queue_head_t wq;
-	atomic_t refs;
+	refcount_t refs;
 	unsigned state;
 
 	struct io_failure_record *failrec;
-- 
2.7.4

