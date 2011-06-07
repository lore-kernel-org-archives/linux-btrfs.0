From: Josef Bacik <josef@redhat.com>
Subject: [PATCH 2/2] Btrfs: serialize flushers in reserve_metadata_bytes
Date: Tue,  7 Jun 2011 16:44:09 -0400
Message-ID: <1307479449-14765-3-git-send-email-josef@redhat.com>
References: <1307479449-14765-1-git-send-email-josef@redhat.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1307479449-14765-1-git-send-email-josef@redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

We keep having problems with early enospc, and that's because our method of
making space is inherently racy.  The problem is we can have one guy trying to
make space for himself, and in the meantime people come in and steal his
reservation.  In order to stop this we make a waitqueue and put anybody who
comes into reserve_metadata_bytes on that waitqueue if somebody is trying to
make more space.  Thanks,

Signed-off-by: Josef Bacik <josef@redhat.com>
---
 fs/btrfs/ctree.h       |    3 ++
 fs/btrfs/extent-tree.c |   69 ++++++++++++++++++++++++++++++++----------------
 2 files changed, 49 insertions(+), 23 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 6034a23..8857d82 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -756,6 +756,8 @@ struct btrfs_space_info {
 				   chunks for this space */
 	unsigned int chunk_alloc:1;	/* set if we are allocating a chunk */
 
+	unsigned int flush:1;		/* set if we are trying to make space */
+
 	unsigned int force_alloc;	/* set if we need to force a chunk
 					   alloc for this space */
 
@@ -766,6 +768,7 @@ struct btrfs_space_info {
 	spinlock_t lock;
 	struct rw_semaphore groups_sem;
 	atomic_t caching_threads;
+	wait_queue_head_t wait;
 };
 
 struct btrfs_block_rsv {
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index b1c3ff7..d86f7c5 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -2932,6 +2932,8 @@ static int update_space_info(struct btrfs_fs_info *info, u64 flags,
 	found->full = 0;
 	found->force_alloc = CHUNK_ALLOC_NO_FORCE;
 	found->chunk_alloc = 0;
+	found->flush = 0;
+	init_waitqueue_head(&found->wait);
 	*space_info = found;
 	list_add_rcu(&found->list, &info->space_info);
 	atomic_set(&found->caching_threads, 0);
@@ -3314,9 +3316,13 @@ static int shrink_delalloc(struct btrfs_trans_handle *trans,
 	if (reserved == 0)
 		return 0;
 
-	/* nothing to shrink - nothing to reclaim */
-	if (root->fs_info->delalloc_bytes == 0)
+	smp_mb();
+	if (root->fs_info->delalloc_bytes == 0) {
+		if (trans)
+			return 0;
+		btrfs_wait_ordered_extents(root, 0, 0);
 		return 0;
+	}
 
 	max_reclaim = min(reserved, to_reclaim);
 
@@ -3360,6 +3366,8 @@ static int shrink_delalloc(struct btrfs_trans_handle *trans,
 		}
 
 	}
+	if (reclaimed >= to_reclaim && !trans)
+		btrfs_wait_ordered_extents(root, 0, 0);
 	return reclaimed >= to_reclaim;
 }
 
@@ -3384,15 +3392,36 @@ static int reserve_metadata_bytes(struct btrfs_trans_handle *trans,
 	u64 num_bytes = orig_bytes;
 	int retries = 0;
 	int ret = 0;
-	bool reserved = false;
 	bool committed = false;
+	bool flushing = false;
 
 again:
-	ret = -ENOSPC;
-	if (reserved)
-		num_bytes = 0;
-
+	ret = 0;
 	spin_lock(&space_info->lock);
+	/*
+	 * We only want to wait if somebody other than us is flushing and we are
+	 * actually alloed to flush.
+	 */
+	while (flush && !flushing && space_info->flush) {
+		spin_unlock(&space_info->lock);
+		/*
+		 * If we have a trans handle we can't wait because the flusher
+		 * may have to commit the transaction, which would mean we would
+		 * deadlock since we are waiting for the flusher to finish, but
+		 * hold the current transaction open.
+		 */
+		if (trans)
+			return -EAGAIN;
+		ret = wait_event_interruptible(space_info->wait,
+					       !space_info->flush);
+		/* Must have been interrupted, return */
+		if (ret)
+			return -EINTR;
+
+		spin_lock(&space_info->lock);
+	}
+
+	ret = -ENOSPC;
 	unused = space_info->bytes_used + space_info->bytes_reserved +
 		 space_info->bytes_pinned + space_info->bytes_readonly +
 		 space_info->bytes_may_use;
@@ -3407,8 +3436,7 @@ again:
 	if (unused <= space_info->total_bytes) {
 		unused = space_info->total_bytes - unused;
 		if (unused >= num_bytes) {
-			if (!reserved)
-				space_info->bytes_may_use += orig_bytes;
+			space_info->bytes_may_use += orig_bytes;
 			ret = 0;
 		} else {
 			/*
@@ -3433,17 +3461,14 @@ again:
 	 * to reclaim space we can actually use it instead of somebody else
 	 * stealing it from us.
 	 */
-	if (ret && !reserved) {
-		space_info->bytes_may_use += orig_bytes;
-		reserved = true;
+	if (ret && flush) {
+		flushing = true;
+		space_info->flush = 1;
 	}
 
 	spin_unlock(&space_info->lock);
 
-	if (!ret)
-		return 0;
-
-	if (!flush)
+	if (!ret || !flush)
 		goto out;
 
 	/*
@@ -3451,9 +3476,7 @@ again:
 	 * metadata until after the IO is completed.
 	 */
 	ret = shrink_delalloc(trans, root, num_bytes, 1);
-	if (ret > 0)
-		return 0;
-	else if (ret < 0)
+	if (ret < 0)
 		goto out;
 
 	/*
@@ -3466,11 +3489,11 @@ again:
 		goto again;
 	}
 
-	spin_lock(&space_info->lock);
 	/*
 	 * Not enough space to be reclaimed, don't bother committing the
 	 * transaction.
 	 */
+	spin_lock(&space_info->lock);
 	if (space_info->bytes_pinned < orig_bytes)
 		ret = -ENOSPC;
 	spin_unlock(&space_info->lock);
@@ -3493,12 +3516,12 @@ again:
 	}
 
 out:
-	if (reserved) {
+	if (flushing) {
 		spin_lock(&space_info->lock);
-		space_info->bytes_may_use -= orig_bytes;
+		space_info->flush = 0;
+		wake_up_all(&space_info->wait);
 		spin_unlock(&space_info->lock);
 	}
-
 	return ret;
 }
 
-- 
1.7.2.3

