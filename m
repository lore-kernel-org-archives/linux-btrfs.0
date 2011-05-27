From: Josef Bacik <josef@redhat.com>
Subject: [PATCH] Btrfs: fix the allocator loop logic
Date: Fri, 27 May 2011 16:15:15 -0400
Message-ID: <1306527315-3927-1-git-send-email-josef@redhat.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

I was testing with empty_cluster = 0 to try and reproduce a problem and kept
hitting early enospc panics.  This was because our loop logic was a little
confused.  So this is what I did

1) Make the loop variable the ultimate decider on wether we should loop again
isntead of checking to see if we had an uncached bg, empty size or empty
cluster.

2) Increment loop before checking to see what we are on to make the loop
definitions make more sense.

3) If we are on the chunk alloc loop don't set empty_size/empty_cluster to 0
unless we didn't actually allocate a chunk.  If we did allocate a chunk we
should be able to easily setup a new cluster so clearing
empty_size/empty_cluster makes us less efficient.

This kept me from hitting panics while trying to reproduce the other problem.
Thanks,

Signed-off-by: Josef Bacik <josef@redhat.com>
---
 fs/btrfs/extent-tree.c |   48 +++++++++++++++++++++++++-----------------------
 1 files changed, 25 insertions(+), 23 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index b4f67e8..cb4bbc9 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -5360,9 +5360,7 @@ loop:
 	 * LOOP_NO_EMPTY_SIZE, set empty_size and empty_cluster to 0 and try
 	 *			again
 	 */
-	if (!ins->objectid && loop < LOOP_NO_EMPTY_SIZE &&
-	    (found_uncached_bg || empty_size || empty_cluster ||
-	     allowed_chunk_alloc)) {
+	if (!ins->objectid && loop < LOOP_NO_EMPTY_SIZE) {
 		index = 0;
 		if (loop == LOOP_FIND_IDEAL && found_uncached_bg) {
 			found_uncached_bg = false;
@@ -5402,32 +5400,36 @@ loop:
 			goto search;
 		}
 
-		if (loop < LOOP_CACHING_WAIT) {
-			loop++;
-			goto search;
-		}
+		loop++;
 
 		if (loop == LOOP_ALLOC_CHUNK) {
-			empty_size = 0;
-			empty_cluster = 0;
-		}
+		       if (allowed_chunk_alloc) {
+				ret = do_chunk_alloc(trans, root, num_bytes +
+						     2 * 1024 * 1024, data,
+						     CHUNK_ALLOC_LIMITED);
+				allowed_chunk_alloc = 0;
+				if (ret == 1)
+					done_chunk_alloc = 1;
+			} else if (!done_chunk_alloc &&
+				   space_info->force_alloc ==
+				   CHUNK_ALLOC_NO_FORCE) {
+				space_info->force_alloc = CHUNK_ALLOC_LIMITED;
+			}
 
-		if (allowed_chunk_alloc) {
-			ret = do_chunk_alloc(trans, root, num_bytes +
-					     2 * 1024 * 1024, data,
-					     CHUNK_ALLOC_LIMITED);
-			allowed_chunk_alloc = 0;
-			done_chunk_alloc = 1;
-		} else if (!done_chunk_alloc &&
-			   space_info->force_alloc == CHUNK_ALLOC_NO_FORCE) {
-			space_info->force_alloc = CHUNK_ALLOC_LIMITED;
+		       /*
+			* We didn't allocate a chunk, go ahead and drop the
+			* empty size and loop again.
+			*/
+		       if (!done_chunk_alloc)
+			       loop = LOOP_NO_EMPTY_SIZE;
 		}
 
-		if (loop < LOOP_NO_EMPTY_SIZE) {
-			loop++;
-			goto search;
+		if (loop == LOOP_NO_EMPTY_SIZE) {
+			empty_size = 0;
+			empty_cluster = 0;
 		}
-		ret = -ENOSPC;
+
+		goto search;
 	} else if (!ins->objectid) {
 		ret = -ENOSPC;
 	} else if (ins->objectid) {
-- 
1.7.2.3

