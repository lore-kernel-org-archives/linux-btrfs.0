From: Josef Bacik <josef@redhat.com>
Subject: [PATCH] Btrfs: account for space reservations properly V2
Date: Tue,  7 Jun 2011 13:37:45 -0400
Message-ID: <1307468265-22726-1-git-send-email-josef@redhat.com>
References: <1307394036-3727-1-git-send-email-josef@redhat.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1307394036-3727-1-git-send-email-josef@redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

We have been using space_info->bytes_reserved in the metadata case to cover our
reservations for ENOSPC.  The problem with this is thats horribly wrong.  We use
bytes_reserved to keep track of how many bytes the allocator has outstanding
that haven't actually been made into extents yet.  So what has been happening is
that we've been using bytes_reserved for our ENOSPC reservations and our
allocations.

Currently that isn't a big deal, everything is being accounted for
appropriately.  The only thing this affects is how we allocate chunks, so we've
grown all these horrible things to make sure we don't end up with a stupid
amount of metadata chunks.  The problem is we think that the entire space is
used up because we use bytes_used and bytes_reserved to get an idea of how much
is actually in use by real data, but thats not the case.

So switch over to using bytes_may_use, which the data space info stuff has
already been using for the same exact reason.  This will allow us to go back to
pre-emptively allocating chunks in the enospc code.  Thanks,

Signed-off-by: Josef Bacik <josef@redhat.com>
---
V1->V2:
-fixed updating bytes_reserved in free_tree_block
-update bytes_may_use in unpin_extent_range

 fs/btrfs/ctree.h       |    2 +-
 fs/btrfs/extent-tree.c |   22 +++++++++++-----------
 2 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 91806fe..93a409f 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -745,7 +745,7 @@ struct btrfs_space_info {
 
 	/*
 	 * we bump reservation progress every time we decrement
-	 * bytes_reserved.  This way people waiting for reservations
+	 * bytes_may_use.  This way people waiting for reservations
 	 * know something good has happened and they can check
 	 * for progress.  The number here isn't to be trusted, it
 	 * just shows reclaim activity
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index b42efc2..933d7dc 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -3308,7 +3308,7 @@ static int shrink_delalloc(struct btrfs_trans_handle *trans,
 	space_info = block_rsv->space_info;
 
 	smp_mb();
-	reserved = space_info->bytes_reserved;
+	reserved = space_info->bytes_may_use;
 	progress = space_info->reservation_progress;
 
 	if (reserved == 0)
@@ -3328,9 +3328,9 @@ static int shrink_delalloc(struct btrfs_trans_handle *trans,
 		writeback_inodes_sb_nr_if_idle(root->fs_info->sb, nr_pages);
 
 		spin_lock(&space_info->lock);
-		if (reserved > space_info->bytes_reserved)
-			reclaimed += reserved - space_info->bytes_reserved;
-		reserved = space_info->bytes_reserved;
+		if (reserved > space_info->bytes_may_use)
+			reclaimed += reserved - space_info->bytes_may_use;
+		reserved = space_info->bytes_may_use;
 		spin_unlock(&space_info->lock);
 
 		loops++;
@@ -3408,7 +3408,7 @@ again:
 		unused = space_info->total_bytes - unused;
 		if (unused >= num_bytes) {
 			if (!reserved)
-				space_info->bytes_reserved += orig_bytes;
+				space_info->bytes_may_use += orig_bytes;
 			ret = 0;
 		} else {
 			/*
@@ -3434,7 +3434,7 @@ again:
 	 * stealing it from us.
 	 */
 	if (ret && !reserved) {
-		space_info->bytes_reserved += orig_bytes;
+		space_info->bytes_may_use += orig_bytes;
 		reserved = true;
 	}
 
@@ -3495,7 +3495,7 @@ again:
 out:
 	if (reserved) {
 		spin_lock(&space_info->lock);
-		space_info->bytes_reserved -= orig_bytes;
+		space_info->bytes_may_use -= orig_bytes;
 		spin_unlock(&space_info->lock);
 	}
 
@@ -3579,7 +3579,7 @@ static void block_rsv_release_bytes(struct btrfs_block_rsv *block_rsv,
 		}
 		if (num_bytes) {
 			spin_lock(&space_info->lock);
-			space_info->bytes_reserved -= num_bytes;
+			space_info->bytes_may_use -= num_bytes;
 			space_info->reservation_progress++;
 			spin_unlock(&space_info->lock);
 		}
@@ -3791,12 +3791,12 @@ static void update_global_block_rsv(struct btrfs_fs_info *fs_info)
 	if (sinfo->total_bytes > num_bytes) {
 		num_bytes = sinfo->total_bytes - num_bytes;
 		block_rsv->reserved += num_bytes;
-		sinfo->bytes_reserved += num_bytes;
+		sinfo->bytes_may_use += num_bytes;
 	}
 
 	if (block_rsv->reserved >= block_rsv->size) {
 		num_bytes = block_rsv->reserved - block_rsv->size;
-		sinfo->bytes_reserved -= num_bytes;
+		sinfo->bytes_may_use -= num_bytes;
 		sinfo->reservation_progress++;
 		block_rsv->reserved = block_rsv->size;
 		block_rsv->full = 1;
@@ -4302,7 +4302,7 @@ static int unpin_extent_range(struct btrfs_root *root, u64 start, u64 end)
 		} else if (cache->reserved_pinned > 0) {
 			len = min(len, cache->reserved_pinned);
 			cache->reserved_pinned -= len;
-			cache->space_info->bytes_reserved += len;
+			cache->space_info->bytes_may_use += len;
 		}
 		spin_unlock(&cache->lock);
 		spin_unlock(&cache->space_info->lock);
-- 
1.7.2.3

