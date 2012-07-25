Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:1352 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751974Ab2GYF7m (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 25 Jul 2012 01:59:42 -0400
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id q6P5xWH0005253
	for <linux-btrfs@vger.kernel.org>; Wed, 25 Jul 2012 13:59:40 +0800
From: Liu Bo <liubo2009@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 3/6 v3][RFC] Btrfs: break clear_state_bit into two parts
Date: Wed, 25 Jul 2012 13:58:39 +0800
Message-Id: <1343195922-31405-4-git-send-email-liubo2009@cn.fujitsu.com>
In-Reply-To: <1343195922-31405-1-git-send-email-liubo2009@cn.fujitsu.com>
References: <1343195922-31405-1-git-send-email-liubo2009@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

clear_state_bit() can be broken into two parts:
1) a part for clearing bits,
2) a part for freeing the state or merging it with adjacent ones.

And the first one does not need to touch the tree, so holding read locks
is enough, and this gives us the oppotunity to rework tree's lock with
rwlock.

Signed-off-by: Liu Bo <liubo2009@cn.fujitsu.com>
---
 fs/btrfs/extent_io.c |   22 ++++++++++++++++++----
 1 files changed, 18 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 4c6dd85..a84d904 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -425,11 +425,10 @@ static struct extent_state *next_state(struct extent_state *state)
  * If no bits are set on the state struct after clearing things, the
  * struct is freed and removed from the tree
  */
-static struct extent_state *clear_state_bit(struct extent_io_tree *tree,
-					    struct extent_state *state,
-					    int *bits, int wake)
+static int __clear_state_bit(struct extent_io_tree *tree,
+			     struct extent_state *state,
+			     int *bits, int wake)
 {
-	struct extent_state *next;
 	int bits_to_clear = *bits & ~EXTENT_CTLBITS;
 
 	if ((bits_to_clear & EXTENT_DIRTY) && (state->state & EXTENT_DIRTY)) {
@@ -441,6 +440,14 @@ static struct extent_state *clear_state_bit(struct extent_io_tree *tree,
 	state->state &= ~bits_to_clear;
 	if (wake)
 		wake_up(&state->wq);
+	return 0;
+}
+
+static struct extent_state *
+try_free_or_merge_state(struct extent_io_tree *tree, struct extent_state *state)
+{
+	struct extent_state *next = NULL;
+
 	if (state->state == 0) {
 		next = next_state(state);
 		if (state->tree) {
@@ -457,6 +464,13 @@ static struct extent_state *clear_state_bit(struct extent_io_tree *tree,
 	return next;
 }
 
+static struct extent_state *clear_state_bit(struct extent_io_tree *tree,
+			   struct extent_state *state, int *bits, int wake)
+{
+	__clear_state_bit(tree, state, bits, wake);
+	return try_free_or_merge_state(tree, state);
+}
+
 static struct extent_state *
 alloc_extent_state_atomic(struct extent_state *prealloc)
 {
-- 
1.6.5.2

