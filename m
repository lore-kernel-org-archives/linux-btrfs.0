From: Josef Bacik <jbacik@redhat.com>
Subject: [PATCH] fix seekiness due to finding the wrong block group
Date: Tue, 30 Sep 2008 14:04:44 -0400
Message-ID: <20080930180443.GA12752@unused.rdu.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

This patch fixes a problem where we end up seeking too much when *last_ptr is
valid.  This happens because btrfs_lookup_first_block_group only returns a block
group that starts on or after the given search start, so if the search_start is
in the middle of a block group it will return the block group after the given
search_start, which is suboptimal.  This patch fixes that by doing a
btrfs_lookup_block_group, which will return the block group that contains the
given search start.  If we fail to find a block group, we fall back on
btrfs_lookup_first_block_group so we can find the next block group, not sure if
this is absolutely needed, but better safe than sorry.  Also if we can't find
the block group that we need, or it happens to not be of the right type, we need
to add empty_cluster since *last_ptr could point to a mismatched block group,
which means we need to start over with empty_cluster added to total needed.
Thank you,

Signed-off-by: Josef Bacik <jbacik@redhat.com>


Index: root/btrfs-unstable/fs/btrfs/extent-tree.c
===================================================================
--- root.orig/btrfs-unstable/fs/btrfs/extent-tree.c
+++ root/btrfs-unstable/fs/btrfs/extent-tree.c
@@ -2238,7 +2238,10 @@ static int noinline find_free_extent(str
 	total_needed += empty_size;
 
 new_group:
-	block_group = btrfs_lookup_first_block_group(info, search_start);
+	block_group = btrfs_lookup_block_group(info, search_start);
+	if (!block_group)
+		block_group = btrfs_lookup_first_block_group(info,
+							     search_start);
 
 	/*
 	 * Ok this looks a little tricky, buts its really simple.  First if we
@@ -2255,8 +2258,10 @@ new_group:
 	if (!block_group || (!block_group_bits(block_group, data) &&
 			     last_ptr && *last_ptr)) {
 		if (search_start != orig_search_start) {
-			if (last_ptr && *last_ptr)
+			if (last_ptr && *last_ptr) {
+				total_needed += empty_cluster;
 				*last_ptr = 0;
+			}
 			search_start = orig_search_start;
 			goto new_group;
 		} else if (!chunk_alloc_done && allowed_chunk_alloc) {
