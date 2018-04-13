Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qk0-f195.google.com ([209.85.220.195]:45153 "EHLO
        mail-qk0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751553AbeDMU26 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 13 Apr 2018 16:28:58 -0400
Received: by mail-qk0-f195.google.com with SMTP id f9so2517071qkm.12
        for <linux-btrfs@vger.kernel.org>; Fri, 13 Apr 2018 13:28:58 -0700 (PDT)
From: Josef Bacik <josef@toxicpanda.com>
To: linux-btrfs@vger.kernel.org, kernel-team@fb.com
Cc: Josef Bacik <jbacik@fb.com>
Subject: [PATCH] btrfs: don't bug_on with enomem in __clear_state_bit
Date: Fri, 13 Apr 2018 16:28:55 -0400
Message-Id: <20180413202855.10453-1-josef@toxicpanda.com>
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
 fs/btrfs/extent_io.c | 28 ++++++++++++++++++++++++----
 1 file changed, 24 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index fb32394fd830..1054dc0158b5 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -593,8 +593,9 @@ int __clear_extent_bit(struct extent_io_tree *tree, u64 start, u64 end,
 	struct extent_state *prealloc = NULL;
 	struct rb_node *node;
 	u64 last_end;
-	int err;
+	int err = 0;
 	int clear = 0;
+	bool need_prealloc = false;
 
 	btrfs_debug_check_extent_io_range(tree, start, end);
 
@@ -617,6 +618,9 @@ int __clear_extent_bit(struct extent_io_tree *tree, u64 start, u64 end,
 		 * If we end up needing a new extent state we allocate it later.
 		 */
 		prealloc = alloc_extent_state(mask);
+		if (!prealloc && need_prealloc)
+			return -ENOMEM;
+		need_prealloc = false;
 	}
 
 	spin_lock(&tree->lock);
@@ -676,7 +680,15 @@ int __clear_extent_bit(struct extent_io_tree *tree, u64 start, u64 end,
 
 	if (state->start < start) {
 		prealloc = alloc_extent_state_atomic(prealloc);
-		BUG_ON(!prealloc);
+		if (!prealloc) {
+			if (gfpflags_allow_blocking(mask)) {
+				need_prealloc = true;
+				spin_unlock(&tree->lock);
+				goto again;
+			}
+			err = -ENOMEM;
+			goto out;
+		}
 		err = split_state(tree, state, prealloc, start);
 		if (err)
 			extent_io_tree_panic(tree, err);
@@ -699,7 +711,15 @@ int __clear_extent_bit(struct extent_io_tree *tree, u64 start, u64 end,
 	 */
 	if (state->start <= end && state->end > end) {
 		prealloc = alloc_extent_state_atomic(prealloc);
-		BUG_ON(!prealloc);
+		if (!prealloc) {
+			if (gfpflags_allow_blocking(mask)) {
+				need_prealloc = true;
+				spin_unlock(&tree->lock);
+				goto again;
+			}
+			err = -ENOMEM;
+			goto out;
+		}
 		err = split_state(tree, state, prealloc, end + 1);
 		if (err)
 			extent_io_tree_panic(tree, err);
@@ -734,7 +754,7 @@ int __clear_extent_bit(struct extent_io_tree *tree, u64 start, u64 end,
 	if (prealloc)
 		free_extent_state(prealloc);
 
-	return 0;
+	return err;
 
 }
 
-- 
2.14.3

