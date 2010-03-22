From: jim owens <owens6336@gmail.com>
Subject: [PATCH] Btrfs: change direct I/O read to not use i_mutex.
Date: Sun, 21 Mar 2010 22:32:39 -0400
Message-ID: <4BA6D6C7.3030708@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>


This depends on the change to ordered data search.

Signed-off-by: jim owens <owens6336@gmail.com>
---
 fs/btrfs/dio.c |  150 +++++++++++++++++++++++++++++++++++++++-----------------
 1 files changed, 104 insertions(+), 46 deletions(-)

diff --git a/fs/btrfs/dio.c b/fs/btrfs/dio.c
index b6934be..c930ff5 100644
--- a/fs/btrfs/dio.c
+++ b/fs/btrfs/dio.c
@@ -435,14 +435,81 @@ static void btrfs_dio_write(struct btrfs_diocb *diocb)
 {
 }
 
+/* verify that we have locked everything we need to do the read and
+ * have pushed the ordered data into the btree so the extent is valid
+ */
+static void btrfs_dio_safe_to_read(struct btrfs_diocb *diocb,
+				struct extent_map *em, u64 *lockend,
+				u64 *data_len, int *safe_to_read)
+{
+	struct extent_io_tree *io_tree = &BTRFS_I(diocb->inode)->io_tree;
+	struct btrfs_ordered_extent *ordered;
+	u64 stop;
+
+	/* must ensure the whole compressed extent is valid on each loop
+	 * as we don't know the final extent size until we look it up
+	 */
+	if (test_bit(EXTENT_FLAG_COMPRESSED, &em->flags) &&
+	    (diocb->lockstart > em->start || *lockend <= em->start + em->len)) {
+		unlock_extent(io_tree, diocb->lockstart, *lockend, GFP_NOFS);
+		diocb->lockstart = em->start;
+		*lockend = min(*lockend, em->start + em->len - 1);
+		*safe_to_read = 0;
+		return;
+	}
+
+	/* one test on first loop covers all extents if no concurrent writes */
+	if (*safe_to_read)
+		return;
+
+	ordered = btrfs_lookup_first_ordered_extent(diocb->inode,
+			diocb->lockstart, *lockend + 1 - diocb->lockstart);
+	if (!ordered) {
+		*safe_to_read = 1;
+		return;
+	}
+
+	/* we checked everything to lockend which might cover multiple extents
+	 * in the hope that we could do the whole read with one locking. that
+	 * won't happen now, but we can read the first extent (or part of it
+	 * for uncompressed data) if what we need is before this ordered data.
+	 * we must have the whole extent valid to read any compressed data,
+	 * while we can read a single block of valid uncompressed data.
+	 */
+	if (test_bit(EXTENT_FLAG_COMPRESSED, &em->flags))
+		stop = em->start + em->len;
+	else
+		stop = diocb->lockstart +
+				BTRFS_I(diocb->inode)->root->sectorsize;
+
+	if (ordered->file_offset < stop) {
+		unlock_extent(io_tree, diocb->lockstart, *lockend, GFP_NOFS);
+		btrfs_start_ordered_extent(diocb->inode, ordered, 1);
+		btrfs_put_ordered_extent(ordered);
+		*safe_to_read = 0;
+		return;
+	}
+
+	/* do the part of the data that is valid to read now with the
+	 * remainder unlocked so that ordered data can flush in parallel
+	 */
+	unlock_extent(io_tree, ordered->file_offset, *lockend, GFP_NOFS);
+	*lockend = ordered->file_offset - 1;
+	*data_len = ordered->file_offset - diocb->start;
+	btrfs_put_ordered_extent(ordered);
+
+	*safe_to_read = 1;
+	return;
+}
+
 static void btrfs_dio_read(struct btrfs_diocb *diocb)
 {
 	struct extent_io_tree *io_tree = &BTRFS_I(diocb->inode)->io_tree;
 	u64 end = diocb->terminate; /* copy because reaper changes it */
 	u64 lockend;
 	u64 data_len;
+	int safe_to_read;
 	int err = 0;
-	int loop = 0;
 	u32 blocksize = BTRFS_I(diocb->inode)->root->sectorsize;
 
 	/* expand lock region to include what we read to validate checksum */
@@ -450,42 +517,25 @@ static void btrfs_dio_read(struct btrfs_diocb *diocb)
 	lockend = ALIGN(end, blocksize) - 1;
 
 getlock:
-	mutex_lock(&diocb->inode->i_mutex);
+	/* writeout everything we read for checksum or compressed extents */
+	filemap_write_and_wait_range(diocb->inode->i_mapping,
+				diocb->lockstart, lockend);
+	lock_extent(io_tree, diocb->lockstart, lockend, GFP_NOFS);
 
-	/* ensure writeout and btree update on everything
-	 * we might read for checksum or compressed extents
-	 */
-	data_len = lockend + 1 - diocb->lockstart;
-	err = btrfs_wait_ordered_range(diocb->inode,
-					diocb->lockstart, data_len);
-	if (err) {
-		diocb->error = err;
-		mutex_unlock(&diocb->inode->i_mutex);
-		return;
-	}
-	data_len = i_size_read(diocb->inode);
-	if (data_len < end)
-		end = data_len;
-	if (end <= diocb->start) {
-		mutex_unlock(&diocb->inode->i_mutex);
-		return; /* 0 is returned past EOF */
-	}
-	if (!loop) {
-		loop++;
-		diocb->terminate = end;
-		lockend = ALIGN(end, blocksize) - 1;
+	data_len = min_t(u64, end, i_size_read(diocb->inode));
+	if (data_len <= diocb->start) {
+		/* whatever we finished (or 0) is returned past EOF */
+		goto fail;
 	}
+	data_len -= diocb->start;
 
-	lock_extent(io_tree, diocb->lockstart, lockend, GFP_NOFS);
-	mutex_unlock(&diocb->inode->i_mutex);
-
-	data_len = end - diocb->start;
+	safe_to_read = 0;
 	while (data_len && !diocb->error) { /* error in reaper stops submit */
 		struct extent_map *em;
-		u64 len = data_len;
+		u64 len;
 
 		em = btrfs_get_extent(diocb->inode, NULL, 0,
-					diocb->start, len, 0);
+					diocb->start, data_len, 0);
 		if (IS_ERR(em)) {
 			err = PTR_ERR(em);
 			printk(KERN_ERR
@@ -496,6 +546,18 @@ getlock:
 			goto fail;
 		}
 
+		/* verify extent was locked and ordered data was flushed,
+		 * may change data_len and lockend whether true or false.
+		 */
+		btrfs_dio_safe_to_read(diocb, em, &lockend, &data_len,
+					&safe_to_read);
+		if (!safe_to_read) {
+			free_extent_map(em);
+			goto getlock;
+		}
+
+		len = data_len;
+
 		/* problem flushing ordered data with btree not updated */
 		if (test_bit(EXTENT_FLAG_VACANCY, &em->flags)) {
 			printk(KERN_ERR
@@ -520,25 +582,12 @@ getlock:
 		} else {
 			len = min(len, em->len - (diocb->start - em->start));
 			if (test_bit(EXTENT_FLAG_PREALLOC, &em->flags) ||
-			    em->block_start == EXTENT_MAP_HOLE) {
+			    em->block_start == EXTENT_MAP_HOLE)
 				err = btrfs_dio_hole_read(diocb, len);
-			} else if (test_bit(EXTENT_FLAG_COMPRESSED,
-								&em->flags)) {
-				if (diocb->lockstart > em->start ||
-				    lockend < em->start + em->len - 1) {
-					/* lock everything we read to inflate */
-					unlock_extent(io_tree, diocb->lockstart,
-						lockend, GFP_NOFS);
-					diocb->lockstart = em->start;
-					lockend = max(lockend,
-						em->start + em->len - 1);
-					free_extent_map(em);
-					goto getlock;
-				}
+			else if (test_bit(EXTENT_FLAG_COMPRESSED, &em->flags))
 				err = btrfs_dio_compressed_read(diocb, em, len);
-			} else {
+			else
 				err = btrfs_dio_extent_read(diocb, em, len);
-			}
 		}
 
 		free_extent_map(em);
@@ -547,6 +596,15 @@ getlock:
 			goto fail;
 		cond_resched();
 	}
+
+	/* we might have shortened data_len because of uncommitted
+	 * ordered data, we want to try again to read the remainder
+	 */
+	if (diocb->start < end && !err && !diocb->error) {
+		lockend = ALIGN(end, blocksize) - 1;
+		goto getlock;
+	}
+
 fail:
 	if (err)
 		diocb->error = err;
-- 
1.6.3.3
