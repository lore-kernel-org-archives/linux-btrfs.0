Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from out30-133.freemail.mail.aliyun.com ([115.124.30.133]:39646 "EHLO
        out30-133.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727016AbeHVWlY (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 22 Aug 2018 18:41:24 -0400
From: Liu Bo <bo.liu@linux.alibaba.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: use next_state in find_first_extent_bit
Date: Thu, 23 Aug 2018 03:14:53 +0800
Message-Id: <1534965293-70614-1-git-send-email-bo.liu@linux.alibaba.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

As next_state() is already defined to get the next state, update us to use
the helper.

No functional changes.

Signed-off-by: Liu Bo <bo.liu@linux.alibaba.com>
---
 fs/btrfs/extent_io.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 628f1aef34b0..44397fa909c2 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -1424,20 +1424,15 @@ int find_first_extent_bit(struct extent_io_tree *tree, u64 start,
 			  struct extent_state **cached_state)
 {
 	struct extent_state *state;
-	struct rb_node *n;
 	int ret = 1;
 
 	spin_lock(&tree->lock);
 	if (cached_state && *cached_state) {
 		state = *cached_state;
 		if (state->end == start - 1 && extent_state_in_tree(state)) {
-			n = rb_next(&state->rb_node);
-			while (n) {
-				state = rb_entry(n, struct extent_state,
-						 rb_node);
+			while ((state = next_state(state)) != NULL) {
 				if (state->state & bits)
 					goto got_it;
-				n = rb_next(n);
 			}
 			free_extent_state(*cached_state);
 			*cached_state = NULL;
-- 
1.8.3.1
