From: jim owens <owens6336@gmail.com>
Subject: [PATCH dio.c V2 5/6] Btrfs: remove lockend from diocb.
Date: Wed, 03 Mar 2010 13:55:20 -0500
Message-ID: <4B8EB098.4050205@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>


Signed-off-by: jim owens <jim6336@gmail.com>
---
 fs/btrfs/dio.c |   21 ++++++++++-----------
 1 files changed, 10 insertions(+), 11 deletions(-)

diff --git a/fs/btrfs/dio.c b/fs/btrfs/dio.c
index ad9b58f..05a7445 100644
--- a/fs/btrfs/dio.c
+++ b/fs/btrfs/dio.c
@@ -127,7 +127,6 @@ struct btrfs_diocb {
 	u64 start;			/* current submit file position */
 	u64 end;
 	u64 lockstart;
-	u64 lockend;
 	u64 begin;			/* original beginning file position */
 	u64 terminate;			/* fpos after submit/completion */
 
@@ -431,6 +430,7 @@ static void btrfs_dio_read(struct btrfs_diocb *diocb)
 {
 	struct extent_io_tree *io_tree = &BTRFS_I(diocb->inode)->io_tree;
 	u64 end = diocb->terminate; /* copy because reaper changes it */
+	u64 lockend;
 	u64 data_len;
 	int err = 0;
 	int loop = 0;
@@ -438,7 +438,7 @@ static void btrfs_dio_read(struct btrfs_diocb *diocb)
 
 	/* expand lock region to include what we read to validate checksum */
 	diocb->lockstart = diocb->start & ~(blocksize - 1);
-	diocb->lockend = ALIGN(diocb->terminate, blocksize) - 1;
+	lockend = ALIGN(end, blocksize) - 1;
 
 getlock:
 	mutex_lock(&diocb->inode->i_mutex);
@@ -446,7 +446,7 @@ getlock:
 	/* ensure writeout and btree update on everything
 	 * we might read for checksum or compressed extents
 	 */
-	data_len = diocb->lockend + 1 - diocb->lockstart;
+	data_len = lockend + 1 - diocb->lockstart;
 	err = btrfs_wait_ordered_range(diocb->inode,
 					diocb->lockstart, data_len);
 	if (err) {
@@ -464,10 +464,10 @@ getlock:
 	if (!loop) {
 		loop++;
 		diocb->terminate = end;
-		diocb->lockend = ALIGN(diocb->terminate, blocksize) - 1;
+		lockend = ALIGN(end, blocksize) - 1;
 	}
 
-	lock_extent(io_tree, diocb->lockstart, diocb->lockend, GFP_NOFS);
+	lock_extent(io_tree, diocb->lockstart, lockend, GFP_NOFS);
 	mutex_unlock(&diocb->inode->i_mutex);
 
 	data_len = end - diocb->start;
@@ -514,12 +514,12 @@ getlock:
 			} else if (test_bit(EXTENT_FLAG_COMPRESSED,
 								&em->flags)) {
 				if (diocb->lockstart > em->start ||
-				    diocb->lockend < em->start + em->len - 1) {
+				    lockend < em->start + em->len - 1) {
 					/* lock everything we read to inflate */
 					unlock_extent(io_tree, diocb->lockstart,
-						diocb->lockend, GFP_NOFS);
+						lockend, GFP_NOFS);
 					diocb->lockstart = em->start;
-					diocb->lockend = max(diocb->lockend,
+					lockend = max(lockend,
 						em->start + em->len - 1);
 					free_extent_map(em);
 					goto getlock;
@@ -545,9 +545,8 @@ fail:
 	 * range as appropriate for submitted bios, so we only
 	 * need to unlock the unprocessed remainder
 	 */
-	if (diocb->lockstart <= diocb->lockend)
-		unlock_extent(io_tree, diocb->lockstart,
-					diocb->lockend, GFP_NOFS);
+	if (diocb->lockstart <= lockend)
+		unlock_extent(io_tree, diocb->lockstart, lockend, GFP_NOFS);
 }
 
 static int btrfs_dio_new_extcb(struct btrfs_dio_extcb **alloc_extcb,
-- 
1.6.3.3
