From: liubo <liubo2009@cn.fujitsu.com>
Subject: [RFC PATCH] Btrfs: do not flush csum items of unchanged file data
 during treelog
Date: Thu, 21 Apr 2011 15:58:21 +0800
Message-ID: <4DAFE39D.4040309@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Chris Mason <chris.mason@oracle.com>,
	Josef Bacik <josef@redhat.com>
To: Linux Btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>


The current code relogs the entire inode every time during fsync log,
and it is much better suited to small files rather than large ones.

During my performance test, the fsync performace of large files sucks,
and we can ascribe this to the tremendous amount of csum infos of the
large ones, cause we have to flush all of these csum infos into log trees
even when there are only _one_ change in the whole file data.  Apparently,
to optimize fsync, we need to create a filter to skip the unnecessary csum
ones, that is, the corresponding file data remains unchanged before this fsync.

Here I have some test results to show, I use sysbench to do "random write + fsync".

Sysbench args:
  - Number of threads: 1
  - Extra file open flags: 0
  - 2 files, 4Gb each
  - Block size 4Kb
  - Number of random requests for random IO: 10000
  - Read/Write ratio for combined random IO test: 1.50
  - Periodic FSYNC enabled, calling fsync() each 100 requests.
  - Calling fsync() at the end of test, Enabled.
  - Using synchronous I/O mode
  - Doing random write test

Sysbench results:
===
   Operations performed:  0 Read, 10000 Write, 200 Other = 10200 Total
   Read 0b  Written 39.062Mb  Total transferred 39.062Mb
===
a) without patch:  (*SPEED* : 451.01Kb/sec)
   112.75 Requests/sec executed

b) with patch:     (*SPEED* : 5.1537Mb/sec)
   1319.34 Requests/sec executed

Signed-off-by: Liu Bo <liubo2009@cn.fujitsu.com>
---
 fs/btrfs/ctree.h    |   14 ++++++++++++--
 fs/btrfs/inode.c    |    1 +
 fs/btrfs/tree-log.c |   31 +++++++++++++++++++++++++------
 3 files changed, 38 insertions(+), 8 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 2e61fe1..300bea0 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -642,6 +642,12 @@ struct btrfs_root_ref {
 #define BTRFS_FILE_EXTENT_REG 1
 #define BTRFS_FILE_EXTENT_PREALLOC 2
 
+/*
+ * used to indicate that this file extent has just been changed and
+ * its csums need to be updated when fsync tries to log this inode.
+ */
+#define BTRFS_FILE_EXTENT_CSUM_UPTODATE	(1 << 0)
+
 struct btrfs_file_extent_item {
 	/*
 	 * transaction id that created this extent
@@ -665,7 +671,9 @@ struct btrfs_file_extent_item {
 	 */
 	u8 compression;
 	u8 encryption;
-	__le16 other_encoding; /* spare for later use */
+	u8 other_encoding; /* spare for later use */
+
+	u8 flag;
 
 	/* are we inline data or a real extent? */
 	u8 type;
@@ -2026,7 +2034,9 @@ BTRFS_SETGET_FUNCS(file_extent_compression, struct btrfs_file_extent_item,
 BTRFS_SETGET_FUNCS(file_extent_encryption, struct btrfs_file_extent_item,
 		   encryption, 8);
 BTRFS_SETGET_FUNCS(file_extent_other_encoding, struct btrfs_file_extent_item,
-		   other_encoding, 16);
+		   other_encoding, 8);
+BTRFS_SETGET_FUNCS(file_extent_flag, struct btrfs_file_extent_item,
+		   flag, 8);
 
 /* this returns the number of file bytes represented by the inline item.
  * If an item is compressed, this is the uncompressed size
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index a4157cf..ed4e318 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -1660,6 +1660,7 @@ static int insert_reserved_file_extent(struct btrfs_trans_handle *trans,
 	btrfs_set_file_extent_compression(leaf, fi, compression);
 	btrfs_set_file_extent_encryption(leaf, fi, encryption);
 	btrfs_set_file_extent_other_encoding(leaf, fi, other_encoding);
+	btrfs_set_file_extent_flag(leaf, fi, BTRFS_FILE_EXTENT_CSUM_UPTODATE);
 
 	btrfs_unlock_up_safe(path, 1);
 	btrfs_set_lock_blocking(leaf);
diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index c50271a..baa4a0a 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -2591,11 +2591,24 @@ static int drop_objectid_items(struct btrfs_trans_handle *trans,
 	return ret;
 }
 
+static inline int need_csum(struct extent_buffer *src,
+			    struct btrfs_file_extent_item *fi,
+			    u64 gen, int csum)
+{
+	if (csum &&
+	    (btrfs_file_extent_generation(src, fi) == gen) &&
+	    (btrfs_file_extent_flag(src, fi) & BTRFS_FILE_EXTENT_CSUM_UPTODATE))
+		return 1;
+
+	return 0;
+}
+
+
 static noinline int copy_items(struct btrfs_trans_handle *trans,
 			       struct btrfs_root *log,
 			       struct btrfs_path *dst_path,
 			       struct extent_buffer *src,
-			       int start_slot, int nr, int inode_only)
+			       int start_slot, int nr, int inode_only, int csum)
 {
 	unsigned long src_offset;
 	unsigned long dst_offset;
@@ -2653,6 +2666,7 @@ static noinline int copy_items(struct btrfs_trans_handle *trans,
 			btrfs_set_inode_generation(dst_path->nodes[0],
 						   inode_item, 0);
 		}
+
 		/* take a reference on file data extents so that truncates
 		 * or deletes of this inode don't have to relog the inode
 		 * again
@@ -2663,8 +2677,9 @@ static noinline int copy_items(struct btrfs_trans_handle *trans,
 						struct btrfs_file_extent_item);
 
 			found_type = btrfs_file_extent_type(src, extent);
-			if (found_type == BTRFS_FILE_EXTENT_REG ||
-			    found_type == BTRFS_FILE_EXTENT_PREALLOC) {
+			if ((found_type == BTRFS_FILE_EXTENT_REG ||
+			     found_type == BTRFS_FILE_EXTENT_PREALLOC) &&
+			    need_csum(src, extent, trans->transid, csum)) {
 				u64 ds, dl, cs, cl;
 				ds = btrfs_file_extent_disk_bytenr(src,
 								extent);
@@ -2688,6 +2703,9 @@ static noinline int copy_items(struct btrfs_trans_handle *trans,
 						ds + cs, ds + cs + cl - 1,
 						&ordered_sums);
 				BUG_ON(ret);
+
+				btrfs_set_file_extent_flag(src, extent, 0);
+				btrfs_mark_buffer_dirty(src);
 			}
 		}
 	}
@@ -2742,6 +2760,7 @@ static int btrfs_log_inode(struct btrfs_trans_handle *trans,
 	int nritems;
 	int ins_start_slot = 0;
 	int ins_nr;
+	int csum = (BTRFS_I(inode)->flags & BTRFS_INODE_NODATASUM) ? 0 : 1;
 
 	log = root->log_root;
 
@@ -2816,7 +2835,7 @@ again:
 		}
 
 		ret = copy_items(trans, log, dst_path, src, ins_start_slot,
-				 ins_nr, inode_only);
+				 ins_nr, inode_only, csum);
 		if (ret) {
 			err = ret;
 			goto out_unlock;
@@ -2835,7 +2854,7 @@ next_slot:
 		if (ins_nr) {
 			ret = copy_items(trans, log, dst_path, src,
 					 ins_start_slot,
-					 ins_nr, inode_only);
+					 ins_nr, inode_only, csum);
 			if (ret) {
 				err = ret;
 				goto out_unlock;
@@ -2856,7 +2875,7 @@ next_slot:
 	if (ins_nr) {
 		ret = copy_items(trans, log, dst_path, src,
 				 ins_start_slot,
-				 ins_nr, inode_only);
+				 ins_nr, inode_only, csum);
 		if (ret) {
 			err = ret;
 			goto out_unlock;
-- 
1.6.5.2
