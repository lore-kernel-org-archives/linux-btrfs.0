Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from victor.provo.novell.com ([137.65.250.26]:37912 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753393AbaJMLDb (ORCPT
	<rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
	Mon, 13 Oct 2014 07:03:31 -0400
From: Filipe Manana <fdmanana@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Filipe Manana <fdmanana@suse.com>
Subject: [PATCH 3/3] Btrfs: avoid returning -ENOMEM in convert_extent_bit() too early
Date: Mon, 13 Oct 2014 12:28:39 +0100
Message-Id: <1413199719-25742-3-git-send-email-fdmanana@suse.com>
In-Reply-To: <1413199719-25742-1-git-send-email-fdmanana@suse.com>
References: <1413199719-25742-1-git-send-email-fdmanana@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We try to allocate an extent state before acquiring the tree's spinlock
just in case we end up needing to split an existing extent state into two.
If that allocation failed, we would return -ENOMEM.
However, our only single caller (transaction/log commit code), passes in
an extent state that was cached from a call to find_first_extent_bit() and
that has a very high chance to match exactly the input range (always true
for a transaction commit and very often, but not always, true for a log
commit) - in this case we end up not needing at all that initial extent
state used for an eventual split. Therefore just don't return -ENOMEM if
we can't allocate the temporary extent state, since we might not need it
at all, and if we end up needing one, we'll do it later anyway.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/extent_io.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 0d931b1..654ed3d 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -1066,13 +1066,21 @@ int convert_extent_bit(struct extent_io_tree *tree, u64 start, u64 end,
 	int err = 0;
 	u64 last_start;
 	u64 last_end;
+	bool first_iteration = true;
 
 	btrfs_debug_check_extent_io_range(tree, start, end);
 
 again:
 	if (!prealloc && (mask & __GFP_WAIT)) {
+		/*
+		 * Best effort, don't worry if extent state allocation fails
+		 * here for the first iteration. We might have a cached state
+		 * that matches exactly the target range, in which case no
+		 * extent state allocations are needed. We'll only know this
+		 * after locking the tree.
+		 */
 		prealloc = alloc_extent_state(mask);
-		if (!prealloc)
+		if (!prealloc && !first_iteration)
 			return -ENOMEM;
 	}
 
@@ -1242,6 +1250,7 @@ search_again:
 	spin_unlock(&tree->lock);
 	if (mask & __GFP_WAIT)
 		cond_resched();
+	first_iteration = false;
 	goto again;
 }
 
-- 
1.9.1

