Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from victor.provo.novell.com ([137.65.250.26]:36579 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753367AbaJMLDQ (ORCPT
	<rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
	Mon, 13 Oct 2014 07:03:16 -0400
From: Filipe Manana <fdmanana@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Filipe Manana <fdmanana@suse.com>
Subject: [PATCH 2/3] Btrfs: make find_first_extent_bit be able to cache any state
Date: Mon, 13 Oct 2014 12:28:38 +0100
Message-Id: <1413199719-25742-2-git-send-email-fdmanana@suse.com>
In-Reply-To: <1413199719-25742-1-git-send-email-fdmanana@suse.com>
References: <1413199719-25742-1-git-send-email-fdmanana@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Right now the only caller of find_first_extent_bit() that is interested
in caching extent states (transaction or log commit), never gets an extent
state cached. This is because find_first_extent_bit() only caches states
that have at least one of the flags EXTENT_IOBITS or EXTENT_BOUNDARY, and
the transaction/log commit caller always passes a tree that doesn't have
ever extent states with any of those flags (they can only have one of the
following flags: EXTENT_DIRTY, EXTENT_NEW or EXTENT_NEED_WAIT).

This change together with the following one in the patch series (titled
"Btrfs: avoid returning -ENOMEM in convert_extent_bit() too early") will
help reduce significantly the chances of calls to convert_extent_bit()
fail with -ENOMEM when called from the transaction/log commit code.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/extent_io.c   | 16 ++++++++++++----
 fs/btrfs/transaction.c |  3 +++
 2 files changed, 15 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 420fe26..0d931b1 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -796,17 +796,25 @@ static void set_state_bits(struct extent_io_tree *tree,
 	state->state |= bits_to_set;
 }
 
-static void cache_state(struct extent_state *state,
-			struct extent_state **cached_ptr)
+static void cache_state_if_flags(struct extent_state *state,
+				 struct extent_state **cached_ptr,
+				 const u64 flags)
 {
 	if (cached_ptr && !(*cached_ptr)) {
-		if (state->state & (EXTENT_IOBITS | EXTENT_BOUNDARY)) {
+		if (!flags || (state->state & flags)) {
 			*cached_ptr = state;
 			atomic_inc(&state->refs);
 		}
 	}
 }
 
+static void cache_state(struct extent_state *state,
+			struct extent_state **cached_ptr)
+{
+	return cache_state_if_flags(state, cached_ptr,
+				    EXTENT_IOBITS | EXTENT_BOUNDARY);
+}
+
 /*
  * set some bits on a range in the tree.  This may require allocations or
  * sleeping, so the gfp mask is used to indicate what is allowed.
@@ -1482,7 +1490,7 @@ int find_first_extent_bit(struct extent_io_tree *tree, u64 start,
 	state = find_first_extent_bit_state(tree, start, bits);
 got_it:
 	if (state) {
-		cache_state(state, cached_state);
+		cache_state_if_flags(state, cached_state, 0);
 		*start_ret = state->start;
 		*end_ret = state->end;
 		ret = 0;
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index cb673d4..396ae8b 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -882,6 +882,7 @@ int btrfs_write_marked_extents(struct btrfs_root *root,
 			werr = err;
 		else if (wait_writeback)
 			werr = filemap_fdatawait_range(mapping, start, end);
+		free_extent_state(cached_state);
 		cached_state = NULL;
 		cond_resched();
 		start = end + 1;
@@ -926,6 +927,8 @@ int btrfs_wait_marked_extents(struct btrfs_root *root,
 			err = filemap_fdatawait_range(mapping, start, end);
 		if (err)
 			werr = err;
+		free_extent_state(cached_state);
+		cached_state = NULL;
 		cond_resched();
 		start = end + 1;
 	}
-- 
1.9.1

