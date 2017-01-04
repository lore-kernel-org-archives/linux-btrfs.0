Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:57268 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751007AbdADKbC (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 4 Jan 2017 05:31:02 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id E7F3AAAB7
        for <linux-btrfs@vger.kernel.org>; Wed,  4 Jan 2017 10:30:22 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH] btrfs: add wrapper for counting BTRFS_MAX_EXTENT_SIZE
Date: Wed,  4 Jan 2017 11:30:06 +0100
Message-Id: <20170104103006.23994-1-dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The expression is open-coded in several places, this asks for a wrapper.
As we know the MAX_EXTENT fits to u32, we can use the appropirate
division helper. This cascades to the result type updates.

Compiler is clever enough to use shift instead of integer division, so
there's no change in the generated assembly.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/ctree.h       |  8 ++++++++
 fs/btrfs/extent-tree.c | 12 ++++--------
 fs/btrfs/inode.c       | 34 +++++++++++-----------------------
 3 files changed, 23 insertions(+), 31 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 50bcfb80d33a..5da1ccc1c478 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -97,6 +97,14 @@ static const int btrfs_csum_sizes[] = { 4 };
 
 #define BTRFS_MAX_EXTENT_SIZE SZ_128M
 
+/*
+ * Count how many BTRFS_MAX_EXTENT_SIZE cover the @size
+ */
+static inline u32 count_max_extents(u64 size)
+{
+	return div_u64(size + BTRFS_MAX_EXTENT_SIZE - 1, BTRFS_MAX_EXTENT_SIZE);
+}
+
 struct btrfs_mapping_tree {
 	struct extent_map_tree map_tree;
 };
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index e97302f437a1..9d1b22e4e691 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -5841,11 +5841,9 @@ static unsigned drop_outstanding_extent(struct inode *inode, u64 num_bytes)
 {
 	unsigned drop_inode_space = 0;
 	unsigned dropped_extents = 0;
-	unsigned num_extents = 0;
+	unsigned num_extents;
 
-	num_extents = (unsigned)div64_u64(num_bytes +
-					  BTRFS_MAX_EXTENT_SIZE - 1,
-					  BTRFS_MAX_EXTENT_SIZE);
+	num_extents = count_max_extents(num_bytes);
 	ASSERT(num_extents);
 	ASSERT(BTRFS_I(inode)->outstanding_extents >= num_extents);
 	BTRFS_I(inode)->outstanding_extents -= num_extents;
@@ -5924,7 +5922,7 @@ int btrfs_delalloc_reserve_metadata(struct inode *inode, u64 num_bytes)
 	struct btrfs_block_rsv *block_rsv = &fs_info->delalloc_block_rsv;
 	u64 to_reserve = 0;
 	u64 csum_bytes;
-	unsigned nr_extents = 0;
+	unsigned nr_extents;
 	enum btrfs_reserve_flush_enum flush = BTRFS_RESERVE_FLUSH_ALL;
 	int ret = 0;
 	bool delalloc_lock = true;
@@ -5957,9 +5955,7 @@ int btrfs_delalloc_reserve_metadata(struct inode *inode, u64 num_bytes)
 	num_bytes = ALIGN(num_bytes, fs_info->sectorsize);
 
 	spin_lock(&BTRFS_I(inode)->lock);
-	nr_extents = (unsigned)div64_u64(num_bytes +
-					 BTRFS_MAX_EXTENT_SIZE - 1,
-					 BTRFS_MAX_EXTENT_SIZE);
+	nr_extents = count_max_extents(num_bytes);
 	BTRFS_I(inode)->outstanding_extents += nr_extents;
 
 	nr_extents = 0;
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index a713d9d324b0..7d1695e75659 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -1609,7 +1609,7 @@ static void btrfs_split_extent_hook(struct inode *inode,
 
 	size = orig->end - orig->start + 1;
 	if (size > BTRFS_MAX_EXTENT_SIZE) {
-		u64 num_extents;
+		u32 num_extents;
 		u64 new_size;
 
 		/*
@@ -1617,13 +1617,10 @@ static void btrfs_split_extent_hook(struct inode *inode,
 		 * applies here, just in reverse.
 		 */
 		new_size = orig->end - split + 1;
-		num_extents = div64_u64(new_size + BTRFS_MAX_EXTENT_SIZE - 1,
-					BTRFS_MAX_EXTENT_SIZE);
+		num_extents = count_max_extents(new_size);
 		new_size = split - orig->start;
-		num_extents += div64_u64(new_size + BTRFS_MAX_EXTENT_SIZE - 1,
-					BTRFS_MAX_EXTENT_SIZE);
-		if (div64_u64(size + BTRFS_MAX_EXTENT_SIZE - 1,
-			      BTRFS_MAX_EXTENT_SIZE) >= num_extents)
+		num_extents += count_max_extents(new_size);
+		if (count_max_extents(size) >= num_extents)
 			return;
 	}
 
@@ -1643,7 +1640,7 @@ static void btrfs_merge_extent_hook(struct inode *inode,
 				    struct extent_state *other)
 {
 	u64 new_size, old_size;
-	u64 num_extents;
+	u32 num_extents;
 
 	/* not delalloc, ignore it */
 	if (!(other->state & EXTENT_DELALLOC))
@@ -1681,14 +1678,10 @@ static void btrfs_merge_extent_hook(struct inode *inode,
 	 * this case.
 	 */
 	old_size = other->end - other->start + 1;
-	num_extents = div64_u64(old_size + BTRFS_MAX_EXTENT_SIZE - 1,
-				BTRFS_MAX_EXTENT_SIZE);
+	num_extents = count_max_extents(old_size);
 	old_size = new->end - new->start + 1;
-	num_extents += div64_u64(old_size + BTRFS_MAX_EXTENT_SIZE - 1,
-				 BTRFS_MAX_EXTENT_SIZE);
-
-	if (div64_u64(new_size + BTRFS_MAX_EXTENT_SIZE - 1,
-		      BTRFS_MAX_EXTENT_SIZE) >= num_extents)
+	num_extents += count_max_extents(old_size);
+	if (count_max_extents(new_size) >= num_extents)
 		return;
 
 	spin_lock(&BTRFS_I(inode)->lock);
@@ -1797,8 +1790,7 @@ static void btrfs_clear_bit_hook(struct inode *inode,
 {
 	struct btrfs_fs_info *fs_info = btrfs_sb(inode->i_sb);
 	u64 len = state->end + 1 - state->start;
-	u64 num_extents = div64_u64(len + BTRFS_MAX_EXTENT_SIZE -1,
-				    BTRFS_MAX_EXTENT_SIZE);
+	u32 num_extents = count_max_extents(len);
 
 	spin_lock(&BTRFS_I(inode)->lock);
 	if ((state->state & EXTENT_DEFRAG) && (*bits & EXTENT_DEFRAG))
@@ -7614,10 +7606,8 @@ static void adjust_dio_outstanding_extents(struct inode *inode,
 					   struct btrfs_dio_data *dio_data,
 					   const u64 len)
 {
-	unsigned num_extents;
+	unsigned num_extents = count_max_extents(len);
 
-	num_extents = (unsigned) div64_u64(len + BTRFS_MAX_EXTENT_SIZE - 1,
-					   BTRFS_MAX_EXTENT_SIZE);
 	/*
 	 * If we have an outstanding_extents count still set then we're
 	 * within our reservation, otherwise we need to adjust our inode
@@ -8674,9 +8664,7 @@ static ssize_t btrfs_direct_IO(struct kiocb *iocb, struct iov_iter *iter)
 		ret = btrfs_delalloc_reserve_space(inode, offset, count);
 		if (ret)
 			goto out;
-		dio_data.outstanding_extents = div64_u64(count +
-						BTRFS_MAX_EXTENT_SIZE - 1,
-						BTRFS_MAX_EXTENT_SIZE);
+		dio_data.outstanding_extents = count_max_extents(count);
 
 		/*
 		 * We need to know how many extents we reserved so that we can
-- 
2.10.1

