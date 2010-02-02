From: Josef Bacik <josef@redhat.com>
Subject: [PATCH] Btrfs: cache extent state in find_delalloc_range
Date: Tue, 2 Feb 2010 16:19:11 -0500
Message-ID: <20100202211911.GE15957@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

This patch makes us cache the extent state we find in find_delalloc_range since
we'll have to lock the extent later on in the function.  This will keep us from
re-searching for the rang when we try to lock the extent.

Signed-off-by: Josef Bacik <josef@redhat.com>
---
 fs/btrfs/extent_io.c |   11 ++++++++---
 1 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 42b4cde..1376611 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -1171,7 +1171,8 @@ out:
  * 1 is returned if we find something, 0 if nothing was in the tree
  */
 static noinline u64 find_delalloc_range(struct extent_io_tree *tree,
-					u64 *start, u64 *end, u64 max_bytes)
+					u64 *start, u64 *end, u64 max_bytes,
+					struct extent_state **cached_state)
 {
 	struct rb_node *node;
 	struct extent_state *state;
@@ -1203,8 +1204,11 @@ static noinline u64 find_delalloc_range(struct extent_io_tree *tree,
 				*end = state->end;
 			goto out;
 		}
-		if (!found)
+		if (!found) {
 			*start = state->start;
+			*cached_state = state;
+			atomic_inc(&state->refs);
+		}
 		found++;
 		*end = state->end;
 		cur_start = state->end + 1;
@@ -1336,10 +1340,11 @@ again:
 	delalloc_start = *start;
 	delalloc_end = 0;
 	found = find_delalloc_range(tree, &delalloc_start, &delalloc_end,
-				    max_bytes);
+				    max_bytes, &cached_state);
 	if (!found || delalloc_end <= *start) {
 		*start = delalloc_start;
 		*end = delalloc_end;
+		free_extent_state(cached_state);
 		return found;
 	}
 
-- 
1.6.6

