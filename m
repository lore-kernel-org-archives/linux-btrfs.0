From: Liu Bo <liubo2009@cn.fujitsu.com>
Subject: [PATCH] Btrfs: drop spin lock when memory alloc fails
Date: Wed, 23 Nov 2011 15:21:49 +0800
Message-ID: <1322032909-28758-1-git-send-email-liubo2009@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Drop spin lock in convert_extent_bit() when memory alloc fails,
otherwise, it will be a deadlock.

Signed-off-by: Liu Bo <liubo2009@cn.fujitsu.com>
---
 fs/btrfs/extent_io.c |   24 ++++++++++++++++--------
 1 files changed, 16 insertions(+), 8 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 9472d3d..445db2e 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -935,8 +935,10 @@ again:
 	node = tree_search(tree, start);
 	if (!node) {
 		prealloc = alloc_extent_state_atomic(prealloc);
-		if (!prealloc)
-			return -ENOMEM;
+		if (!prealloc) {
+			err = -ENOMEM;
+			goto out;
+		}
 		err = insert_state(tree, prealloc, start, end, &bits);
 		prealloc = NULL;
 		BUG_ON(err == -EEXIST);
@@ -992,8 +994,10 @@ hit_next:
 	 */
 	if (state->start < start) {
 		prealloc = alloc_extent_state_atomic(prealloc);
-		if (!prealloc)
-			return -ENOMEM;
+		if (!prealloc) {
+			err = -ENOMEM;
+			goto out;
+		}
 		err = split_state(tree, state, prealloc, start);
 		BUG_ON(err == -EEXIST);
 		prealloc = NULL;
@@ -1024,8 +1028,10 @@ hit_next:
 			this_end = last_start - 1;
 
 		prealloc = alloc_extent_state_atomic(prealloc);
-		if (!prealloc)
-			return -ENOMEM;
+		if (!prealloc) {
+			err = -ENOMEM;
+			goto out;
+		}
 
 		/*
 		 * Avoid to free 'prealloc' if it can be merged with
@@ -1051,8 +1057,10 @@ hit_next:
 	 */
 	if (state->start <= end && state->end > end) {
 		prealloc = alloc_extent_state_atomic(prealloc);
-		if (!prealloc)
-			return -ENOMEM;
+		if (!prealloc) {
+			err = -ENOMEM;
+			goto out;
+		}
 
 		err = split_state(tree, state, prealloc, end + 1);
 		BUG_ON(err == -EEXIST);
-- 
1.6.5.2

