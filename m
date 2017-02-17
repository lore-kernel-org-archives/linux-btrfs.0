Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wr0-f195.google.com ([209.85.128.195]:34743 "EHLO
        mail-wr0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934247AbdBQOoB (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 17 Feb 2017 09:44:01 -0500
Received: by mail-wr0-f195.google.com with SMTP id c4so5516195wrd.1
        for <linux-btrfs@vger.kernel.org>; Fri, 17 Feb 2017 06:44:00 -0800 (PST)
From: Nikolay Borisov <n.borisov.lkml@gmail.com>
To: dsterba@suse.com
Cc: linux-btrfs@vger.kernel.org, Nikolay Borisov <n.borisov.lkml@gmail.com>,
        Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 12/38] btrfs: Make btrfs_delalloc_reserve_metadata take btrfs_inode
Date: Fri, 17 Feb 2017 16:43:03 +0200
Message-Id: <1487342609-20652-13-git-send-email-nborisov@suse.com>
In-Reply-To: <1487342609-20652-1-git-send-email-nborisov@suse.com>
References: <1487342609-20652-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Nikolay Borisov <n.borisov.lkml@gmail.com>

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/ctree.h       |  2 +-
 fs/btrfs/extent-tree.c | 69 +++++++++++++++++++++++++-------------------------
 fs/btrfs/file.c        |  2 +-
 fs/btrfs/relocation.c  |  2 +-
 4 files changed, 37 insertions(+), 38 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 8eb07a9dfa6a..23dcc42f479b 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -2703,7 +2703,7 @@ int btrfs_subvolume_reserve_metadata(struct btrfs_root *root,
 				     u64 *qgroup_reserved, bool use_global_rsv);
 void btrfs_subvolume_release_metadata(struct btrfs_fs_info *fs_info,
 				      struct btrfs_block_rsv *rsv);
-int btrfs_delalloc_reserve_metadata(struct inode *inode, u64 num_bytes);
+int btrfs_delalloc_reserve_metadata(struct btrfs_inode *inode, u64 num_bytes);
 void btrfs_delalloc_release_metadata(struct inode *inode, u64 num_bytes);
 int btrfs_delalloc_reserve_space(struct inode *inode, u64 start, u64 len);
 void btrfs_delalloc_release_space(struct inode *inode, u64 start, u64 len);
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index f3ee86e178bb..746c7700317e 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -5920,10 +5920,10 @@ static u64 calc_csum_metadata_size(struct btrfs_inode *inode, u64 num_bytes,
 	return btrfs_calc_trans_metadata_size(fs_info, old_csums - num_csums);
 }
 
-int btrfs_delalloc_reserve_metadata(struct inode *inode, u64 num_bytes)
+int btrfs_delalloc_reserve_metadata(struct btrfs_inode *inode, u64 num_bytes)
 {
-	struct btrfs_fs_info *fs_info = btrfs_sb(inode->i_sb);
-	struct btrfs_root *root = BTRFS_I(inode)->root;
+	struct btrfs_fs_info *fs_info = btrfs_sb(inode->vfs_inode.i_sb);
+	struct btrfs_root *root = inode->root;
 	struct btrfs_block_rsv *block_rsv = &fs_info->delalloc_block_rsv;
 	u64 to_reserve = 0;
 	u64 csum_bytes;
@@ -5943,7 +5943,7 @@ int btrfs_delalloc_reserve_metadata(struct inode *inode, u64 num_bytes)
 	 * If we have a transaction open (can happen if we call truncate_block
 	 * from truncate), then we need FLUSH_LIMIT so we don't deadlock.
 	 */
-	if (btrfs_is_free_space_inode(BTRFS_I(inode))) {
+	if (btrfs_is_free_space_inode(inode)) {
 		flush = BTRFS_RESERVE_NO_FLUSH;
 		delalloc_lock = false;
 	} else if (current->journal_info) {
@@ -5955,25 +5955,24 @@ int btrfs_delalloc_reserve_metadata(struct inode *inode, u64 num_bytes)
 		schedule_timeout(1);
 
 	if (delalloc_lock)
-		mutex_lock(&BTRFS_I(inode)->delalloc_mutex);
+		mutex_lock(&inode->delalloc_mutex);
 
 	num_bytes = ALIGN(num_bytes, fs_info->sectorsize);
 
-	spin_lock(&BTRFS_I(inode)->lock);
+	spin_lock(&inode->lock);
 	nr_extents = count_max_extents(num_bytes);
-	BTRFS_I(inode)->outstanding_extents += nr_extents;
+	inode->outstanding_extents += nr_extents;
 
 	nr_extents = 0;
-	if (BTRFS_I(inode)->outstanding_extents >
-	    BTRFS_I(inode)->reserved_extents)
-		nr_extents += BTRFS_I(inode)->outstanding_extents -
-			BTRFS_I(inode)->reserved_extents;
+	if (inode->outstanding_extents > inode->reserved_extents)
+		nr_extents += inode->outstanding_extents -
+			inode->reserved_extents;
 
 	/* We always want to reserve a slot for updating the inode. */
 	to_reserve = btrfs_calc_trans_metadata_size(fs_info, nr_extents + 1);
-	to_reserve += calc_csum_metadata_size(BTRFS_I(inode), num_bytes, 1);
-	csum_bytes = BTRFS_I(inode)->csum_bytes;
-	spin_unlock(&BTRFS_I(inode)->lock);
+	to_reserve += calc_csum_metadata_size(inode, num_bytes, 1);
+	csum_bytes = inode->csum_bytes;
+	spin_unlock(&inode->lock);
 
 	if (test_bit(BTRFS_FS_QUOTA_ENABLED, &fs_info->flags)) {
 		ret = btrfs_qgroup_reserve_meta(root,
@@ -5989,38 +5988,38 @@ int btrfs_delalloc_reserve_metadata(struct inode *inode, u64 num_bytes)
 		goto out_fail;
 	}
 
-	spin_lock(&BTRFS_I(inode)->lock);
+	spin_lock(&inode->lock);
 	if (test_and_set_bit(BTRFS_INODE_DELALLOC_META_RESERVED,
-			     &BTRFS_I(inode)->runtime_flags)) {
+			     &inode->runtime_flags)) {
 		to_reserve -= btrfs_calc_trans_metadata_size(fs_info, 1);
 		release_extra = true;
 	}
-	BTRFS_I(inode)->reserved_extents += nr_extents;
-	spin_unlock(&BTRFS_I(inode)->lock);
+	inode->reserved_extents += nr_extents;
+	spin_unlock(&inode->lock);
 
 	if (delalloc_lock)
-		mutex_unlock(&BTRFS_I(inode)->delalloc_mutex);
+		mutex_unlock(&inode->delalloc_mutex);
 
 	if (to_reserve)
 		trace_btrfs_space_reservation(fs_info, "delalloc",
-				      btrfs_ino(BTRFS_I(inode)), to_reserve, 1);
+					      btrfs_ino(inode), to_reserve, 1);
 	if (release_extra)
 		btrfs_block_rsv_release(fs_info, block_rsv,
 				btrfs_calc_trans_metadata_size(fs_info, 1));
 	return 0;
 
 out_fail:
-	spin_lock(&BTRFS_I(inode)->lock);
-	dropped = drop_outstanding_extent(BTRFS_I(inode), num_bytes);
+	spin_lock(&inode->lock);
+	dropped = drop_outstanding_extent(inode, num_bytes);
 	/*
 	 * If the inodes csum_bytes is the same as the original
 	 * csum_bytes then we know we haven't raced with any free()ers
 	 * so we can just reduce our inodes csum bytes and carry on.
 	 */
-	if (BTRFS_I(inode)->csum_bytes == csum_bytes) {
-		calc_csum_metadata_size(BTRFS_I(inode), num_bytes, 0);
+	if (inode->csum_bytes == csum_bytes) {
+		calc_csum_metadata_size(inode, num_bytes, 0);
 	} else {
-		u64 orig_csum_bytes = BTRFS_I(inode)->csum_bytes;
+		u64 orig_csum_bytes = inode->csum_bytes;
 		u64 bytes;
 
 		/*
@@ -6031,9 +6030,9 @@ int btrfs_delalloc_reserve_metadata(struct inode *inode, u64 num_bytes)
 		 * number of bytes that were freed while we were trying our
 		 * reservation.
 		 */
-		bytes = csum_bytes - BTRFS_I(inode)->csum_bytes;
-		BTRFS_I(inode)->csum_bytes = csum_bytes;
-		to_free = calc_csum_metadata_size(BTRFS_I(inode), bytes, 0);
+		bytes = csum_bytes - inode->csum_bytes;
+		inode->csum_bytes = csum_bytes;
+		to_free = calc_csum_metadata_size(inode, bytes, 0);
 
 
 		/*
@@ -6041,9 +6040,9 @@ int btrfs_delalloc_reserve_metadata(struct inode *inode, u64 num_bytes)
 		 * been making this reservation and our ->csum_bytes were not
 		 * artificially inflated.
 		 */
-		BTRFS_I(inode)->csum_bytes = csum_bytes - num_bytes;
+		inode->csum_bytes = csum_bytes - num_bytes;
 		bytes = csum_bytes - orig_csum_bytes;
-		bytes = calc_csum_metadata_size(BTRFS_I(inode), bytes, 0);
+		bytes = calc_csum_metadata_size(inode, bytes, 0);
 
 		/*
 		 * Now reset ->csum_bytes to what it should be.  If bytes is
@@ -6053,23 +6052,23 @@ int btrfs_delalloc_reserve_metadata(struct inode *inode, u64 num_bytes)
 		 * need to do anything, the other free-ers did the correct
 		 * thing.
 		 */
-		BTRFS_I(inode)->csum_bytes = orig_csum_bytes - num_bytes;
+		inode->csum_bytes = orig_csum_bytes - num_bytes;
 		if (bytes > to_free)
 			to_free = bytes - to_free;
 		else
 			to_free = 0;
 	}
-	spin_unlock(&BTRFS_I(inode)->lock);
+	spin_unlock(&inode->lock);
 	if (dropped)
 		to_free += btrfs_calc_trans_metadata_size(fs_info, dropped);
 
 	if (to_free) {
 		btrfs_block_rsv_release(fs_info, block_rsv, to_free);
 		trace_btrfs_space_reservation(fs_info, "delalloc",
-				      btrfs_ino(BTRFS_I(inode)), to_free, 0);
+					      btrfs_ino(inode), to_free, 0);
 	}
 	if (delalloc_lock)
-		mutex_unlock(&BTRFS_I(inode)->delalloc_mutex);
+		mutex_unlock(&inode->delalloc_mutex);
 	return ret;
 }
 
@@ -6137,7 +6136,7 @@ int btrfs_delalloc_reserve_space(struct inode *inode, u64 start, u64 len)
 	ret = btrfs_check_data_free_space(inode, start, len);
 	if (ret < 0)
 		return ret;
-	ret = btrfs_delalloc_reserve_metadata(inode, len);
+	ret = btrfs_delalloc_reserve_metadata(BTRFS_I(inode), len);
 	if (ret < 0)
 		btrfs_free_reserved_data_space(inode, start, len);
 	return ret;
diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 7cdaafff4764..0e4ac5969f6e 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -1599,7 +1599,7 @@ static noinline ssize_t __btrfs_buffered_write(struct file *file,
 			}
 		}
 
-		ret = btrfs_delalloc_reserve_metadata(inode, reserve_bytes);
+		ret = btrfs_delalloc_reserve_metadata(BTRFS_I(inode), reserve_bytes);
 		if (ret) {
 			if (!only_release_metadata)
 				btrfs_free_reserved_data_space(inode, pos,
diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index ddbde0f08365..33cd6f873834 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -3203,7 +3203,7 @@ static int relocate_file_extent_cluster(struct inode *inode,
 	index = (cluster->start - offset) >> PAGE_SHIFT;
 	last_index = (cluster->end - offset) >> PAGE_SHIFT;
 	while (index <= last_index) {
-		ret = btrfs_delalloc_reserve_metadata(inode, PAGE_SIZE);
+		ret = btrfs_delalloc_reserve_metadata(BTRFS_I(inode), PAGE_SIZE);
 		if (ret)
 			goto out;
 
-- 
2.7.4

