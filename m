From: Josef Bacik <josef@redhat.com>
Subject: [PATCH] Btrfs: fix some ENOSPC problems
Date: Wed,  6 Oct 2010 15:56:12 -0400
Message-ID: <1286394972-26428-1-git-send-email-josef@redhat.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Running some multi-threaded writer tests with mixed block groups I was noticing
that I hit ENOSPC really quickly.  There were a few problems

1) If we tried to use some space and couldn't, we'd try and reclaim.  The
problem is we aren't holding onto our reservation, so it just means that other
threads will come in and use the space we are freeing up, so we could run out of
space that we'd freed up before we got to use it.  Fix this by taking our
reservation and then trying to free up space.

2) The priority calculation doesn't make sense, the calc_global_metadata_size
stuff pre-reserves enough slack space so we don't get ourselves into deep of a
ENOSPC hole.  This part is important, since without it things still don't work
right.

3) With mixed block_groups we use bytes_may_use for tracking data space used, so
use it in determining how much space we have used.

4) With mixed block_groups data and metadata used will be the same, so fix
calc_global_metadata_size to only use meta_used and set data_used = 0.

Without these changes I run out of space around 50mb into a 1 gig partition,
with these changes I can fill the entire thing up.

Signed-off-by: Josef Bacik <josef@redhat.com>
---
 fs/btrfs/extent-tree.c |   59 ++++++++++++++++++++++++++++++++---------------
 1 files changed, 40 insertions(+), 19 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 5343e56..439e290 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -3433,35 +3433,46 @@ static int should_retry_reserve(struct btrfs_trans_handle *trans,
 	return 1;
 }
 
+/*
+ * Retries tells us how many times we've called reserve_metadata_bytes.  The
+ * idea is if this is the first call (retries == 0) then we will add to our
+ * reserved count if we can't make the allocation in order to hold our place
+ * while we go and try and free up space.  That way for retries > 1 we don't try
+ * and add space, we just check to see if the amount of unused space is >= the
+ * total space, meaning that our reservation is valid.
+ *
+ * However if we don't intend to retry this reservation, pass -1 as retries so
+ * that it short circuits this logic.
+ */
 static int reserve_metadata_bytes(struct btrfs_block_rsv *block_rsv,
-				  u64 num_bytes)
+				  u64 num_bytes, int retries)
 {
 	struct btrfs_space_info *space_info = block_rsv->space_info;
 	u64 unused;
 	int ret = -ENOSPC;
 
+	if (retries > 0)
+		num_bytes = 0;
+
 	spin_lock(&space_info->lock);
 	unused = space_info->bytes_used + space_info->bytes_reserved +
-		 space_info->bytes_pinned + space_info->bytes_readonly;
+		 space_info->bytes_pinned + space_info->bytes_readonly +
+		 space_info->bytes_may_use;
 
-	if (unused < space_info->total_bytes)
+	if (unused <= space_info->total_bytes)
 		unused = space_info->total_bytes - unused;
 	else
-		unused = 0;
+		unused = -1;
 
 	if (unused >= num_bytes) {
-		if (block_rsv->priority >= 10) {
+		if (retries <= 0)
 			space_info->bytes_reserved += num_bytes;
-			ret = 0;
-		} else {
-			if ((unused + block_rsv->reserved) *
-			    block_rsv->priority >=
-			    (num_bytes + block_rsv->reserved) * 10) {
-				space_info->bytes_reserved += num_bytes;
-				ret = 0;
-			}
-		}
+		ret = 0;
+	} else if (retries == 0) {
+		space_info->bytes_reserved += num_bytes;
+		ret = -EAGAIN;
 	}
+
 	spin_unlock(&space_info->lock);
 
 	return ret;
@@ -3613,7 +3624,7 @@ int btrfs_block_rsv_add(struct btrfs_trans_handle *trans,
 	if (num_bytes == 0)
 		return 0;
 again:
-	ret = reserve_metadata_bytes(block_rsv, num_bytes);
+	ret = reserve_metadata_bytes(block_rsv, num_bytes, *retries);
 	if (!ret) {
 		block_rsv_add_bytes(block_rsv, num_bytes, 1);
 		return 0;
@@ -3623,6 +3634,10 @@ again:
 	if (ret > 0)
 		goto again;
 
+	spin_lock(&block_rsv->space_info->lock);
+	block_rsv->space_info->bytes_reserved -= num_bytes;
+	spin_unlock(&block_rsv->space_info->lock);
+
 	return ret;
 }
 
@@ -3657,7 +3672,7 @@ int btrfs_block_rsv_check(struct btrfs_trans_handle *trans,
 		return 0;
 
 	if (block_rsv->refill_used) {
-		ret = reserve_metadata_bytes(block_rsv, num_bytes);
+		ret = reserve_metadata_bytes(block_rsv, num_bytes, -1);
 		if (!ret) {
 			block_rsv_add_bytes(block_rsv, num_bytes, 0);
 			return 0;
@@ -3736,6 +3751,8 @@ static u64 calc_global_metadata_size(struct btrfs_fs_info *fs_info)
 
 	sinfo = __find_space_info(fs_info, BTRFS_BLOCK_GROUP_METADATA);
 	spin_lock(&sinfo->lock);
+	if (sinfo->flags & BTRFS_BLOCK_GROUP_DATA)
+		data_used = 0;
 	meta_used = sinfo->bytes_used;
 	spin_unlock(&sinfo->lock);
 
@@ -3763,7 +3780,8 @@ static void update_global_block_rsv(struct btrfs_fs_info *fs_info)
 	block_rsv->size = num_bytes;
 
 	num_bytes = sinfo->bytes_used + sinfo->bytes_pinned +
-		    sinfo->bytes_reserved + sinfo->bytes_readonly;
+		    sinfo->bytes_reserved + sinfo->bytes_readonly +
+		    sinfo->bytes_may_use;
 
 	if (sinfo->total_bytes > num_bytes) {
 		num_bytes = sinfo->total_bytes - num_bytes;
@@ -3937,13 +3955,16 @@ again:
 	}
 
 	to_reserve += calc_csum_metadata_size(inode, num_bytes);
-	ret = reserve_metadata_bytes(block_rsv, to_reserve);
+	ret = reserve_metadata_bytes(block_rsv, to_reserve, retries);
 	if (ret) {
 		spin_unlock(&BTRFS_I(inode)->accounting_lock);
 		ret = should_retry_reserve(NULL, root, block_rsv, to_reserve,
 					   &retries);
 		if (ret > 0)
 			goto again;
+		spin_lock(&block_rsv->space_info->lock);
+		block_rsv->space_info->bytes_reserved -= to_reserve;
+		spin_unlock(&block_rsv->space_info->lock);
 		return ret;
 	}
 
@@ -5575,7 +5596,7 @@ use_block_rsv(struct btrfs_trans_handle *trans,
 	block_rsv = get_block_rsv(trans, root);
 
 	if (block_rsv->size == 0) {
-		ret = reserve_metadata_bytes(block_rsv, blocksize);
+		ret = reserve_metadata_bytes(block_rsv, blocksize, -1);
 		if (ret)
 			return ERR_PTR(ret);
 		return block_rsv;
-- 
1.6.6.1

