Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qk0-f196.google.com ([209.85.220.196]:45347 "EHLO
        mail-qk0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751065AbdKIRxQ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 9 Nov 2017 12:53:16 -0500
Received: by mail-qk0-f196.google.com with SMTP id p19so3576541qke.2
        for <linux-btrfs@vger.kernel.org>; Thu, 09 Nov 2017 09:53:16 -0800 (PST)
From: Josef Bacik <josef@toxicpanda.com>
To: linux-btrfs@vger.kernel.org, kernel-team@fb.com
Cc: Josef Bacik <jbacik@fb.com>
Subject: [PATCH] btrfs: don't bug_on with enomem in __clear_state_bit
Date: Thu,  9 Nov 2017 12:53:14 -0500
Message-Id: <1510249994-6023-1-git-send-email-josef@toxicpanda.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Josef Bacik <jbacik@fb.com>

Since we're allocating under atomic we could every easily enomem, so if
that's the case and we can block then loop around and try to allocate
the prealloc not under a lock.

We also saw this happen during try_to_release_page in production, in
which case it's completely valid to return ENOMEM so we can tell
try_to_release_page that we can't release this page.

Signed-off-by: Josef Bacik <jbacik@fb.com>
---
 fs/btrfs/extent_io.c | 26 ++++++++++++++++++++++----
 1 file changed, 22 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index dd941885b9c3..6d1de1a81dc8 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -590,8 +590,9 @@ static int __clear_extent_bit(struct extent_io_tree *tree, u64 start, u64 end,
 	struct extent_state *prealloc = NULL;
 	struct rb_node *node;
 	u64 last_end;
-	int err;
+	int err = 0;
 	int clear = 0;
+	bool need_prealloc = false;
 
 	btrfs_debug_check_extent_io_range(tree, start, end);
 
@@ -614,6 +615,9 @@ static int __clear_extent_bit(struct extent_io_tree *tree, u64 start, u64 end,
 		 * If we end up needing a new extent state we allocate it later.
 		 */
 		prealloc = alloc_extent_state(mask);
+		if (!prealloc && need_prealloc)
+			return -ENOMEM;
+		need_prealloc = false;
 	}
 
 	spin_lock(&tree->lock);
@@ -673,7 +677,14 @@ static int __clear_extent_bit(struct extent_io_tree *tree, u64 start, u64 end,
 
 	if (state->start < start) {
 		prealloc = alloc_extent_state_atomic(prealloc);
-		BUG_ON(!prealloc);
+		if (!prealloc) {
+			if (gfpflags_allow_blocking(mask)) {
+				need_prealloc = true;
+				goto again;
+			}
+			err = -ENOMEM;
+			goto out;
+		}
 		err = split_state(tree, state, prealloc, start);
 		if (err)
 			extent_io_tree_panic(tree, err);
@@ -696,7 +707,14 @@ static int __clear_extent_bit(struct extent_io_tree *tree, u64 start, u64 end,
 	 */
 	if (state->start <= end && state->end > end) {
 		prealloc = alloc_extent_state_atomic(prealloc);
-		BUG_ON(!prealloc);
+		if (!prealloc) {
+			if (gfpflags_allow_blocking(mask)) {
+				need_prealloc = true;
+				goto again;
+			}
+			err = -ENOMEM;
+			goto out;
+		}
 		err = split_state(tree, state, prealloc, end + 1);
 		if (err)
 			extent_io_tree_panic(tree, err);
@@ -731,7 +749,7 @@ static int __clear_extent_bit(struct extent_io_tree *tree, u64 start, u64 end,
 	if (prealloc)
 		free_extent_state(prealloc);
 
-	return 0;
+	return err;
 
 }
 
-- 
2.7.5

