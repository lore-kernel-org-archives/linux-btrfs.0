Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:58706 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751000Ab2H2EM6 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 29 Aug 2012 00:12:58 -0400
Message-ID: <503D96B2.2070402@cn.fujitsu.com>
Date: Wed, 29 Aug 2012 12:12:34 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
MIME-Version: 1.0
To: Linux Btrfs <linux-btrfs@vger.kernel.org>
CC: David Sterba <dave@jikos.cz>
Subject: [PATCH 3/7] Btrfs: fix file extent discount problem in the snapshot
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

If a snapshot is created while we are writing some data into the file,
the i_size of the corresponding file in the snapshot will be wrong, it will
be beyond the end of the last file extent. And btrfsck will report:
  root 256 inode 257 errors 100

Steps to reproduce:
 # mkfs.btrfs <partition>
 # mount <partition> <mnt>
 # cd <mnt>
 # dd if=/dev/zero of=tmpfile bs=4M count=1024 &
 # for ((i=0; i<4; i++))
 > do
 > btrfs sub snap . $i
 > done

This because the algorithm of disk_i_size update is wrong. Though there are
some ordered extents behind the current one which we use to update disk_i_size,
it doesn't mean those extents will be dealt with in the same transaction. So
We shouldn't use the offset of those extents to update disk_i_size. Or we will
get the wrong i_size in the snapshot.

We fix this problem by recording the max real i_size. If we find there is a
ordered extent which is in front of the current one and doesn't complete, we
will record the end of the current one into that ordered extent. Surely, if
the current extent holds the end of other extent(it must be greater than
the current one because it is behind the current one), we will record the
number that the current extent holds. In this way, we can exclude the ordered
extents that may not be dealth with in the same transaction, and be easy to
know the real disk_i_size.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/ordered-data.c |   62 +++++++++++++---------------------------------
 fs/btrfs/ordered-data.h |    7 +++++
 2 files changed, 25 insertions(+), 44 deletions(-)

diff --git a/fs/btrfs/ordered-data.c b/fs/btrfs/ordered-data.c
index 643335a..2eb79cc 100644
--- a/fs/btrfs/ordered-data.c
+++ b/fs/btrfs/ordered-data.c
@@ -775,7 +775,6 @@ int btrfs_ordered_update_i_size(struct inode *inode, u64 offset,
 	struct btrfs_ordered_inode_tree *tree = &BTRFS_I(inode)->ordered_tree;
 	u64 disk_i_size;
 	u64 new_i_size;
-	u64 i_size_test;
 	u64 i_size = i_size_read(inode);
 	struct rb_node *node;
 	struct rb_node *prev = NULL;
@@ -835,55 +834,30 @@ int btrfs_ordered_update_i_size(struct inode *inode, u64 offset,
 			break;
 		if (test->file_offset >= i_size)
 			break;
-		if (test->file_offset >= disk_i_size)
+		if (test->file_offset >= disk_i_size) {
+			/*
+			 * we don't update disk_i_size now, so record this
+			 * undealt i_size. Or we will not know the real
+			 * i_size.
+			 */
+			if (test->outstanding_isize < offset)
+				test->outstanding_isize = offset;
+			if (ordered &&
+			    ordered->outstanding_isize >
+			    test->outstanding_isize)
+				test->outstanding_isize =
+						ordered->outstanding_isize;
 			goto out;
-	}
-	new_i_size = min_t(u64, offset, i_size);
-
-	/*
-	 * at this point, we know we can safely update i_size to at least
-	 * the offset from this ordered extent.  But, we need to
-	 * walk forward and see if ios from higher up in the file have
-	 * finished.
-	 */
-	if (ordered) {
-		node = rb_next(&ordered->rb_node);
-	} else {
-		if (prev)
-			node = rb_next(prev);
-		else
-			node = rb_first(&tree->tree);
-	}
-
-	/*
-	 * We are looking for an area between our current extent and the next
-	 * ordered extent to update the i_size to.  There are 3 cases here
-	 *
-	 * 1) We don't actually have anything and we can update to i_size.
-	 * 2) We have stuff but they already did their i_size update so again we
-	 * can just update to i_size.
-	 * 3) We have an outstanding ordered extent so the most we can update
-	 * our disk_i_size to is the start of the next offset.
-	 */
-	i_size_test = i_size;
-	for (; node; node = rb_next(node)) {
-		test = rb_entry(node, struct btrfs_ordered_extent, rb_node);
-
-		if (test_bit(BTRFS_ORDERED_UPDATED_ISIZE, &test->flags))
-			continue;
-		if (test->file_offset > offset) {
-			i_size_test = test->file_offset;
-			break;
 		}
 	}
+	new_i_size = min_t(u64, offset, i_size);
 
 	/*
-	 * i_size_test is the end of a region after this ordered
-	 * extent where there are no ordered extents, we can safely set
-	 * disk_i_size to this.
+	 * Some ordered extents may completed before the current one, and
+	 * we hold the real i_size in ->outstanding_isize.
 	 */
-	if (i_size_test > offset)
-		new_i_size = min_t(u64, i_size_test, i_size);
+	if (ordered && ordered->outstanding_isize > new_i_size)
+		new_i_size = min_t(u64, ordered->outstanding_isize, i_size);
 	BTRFS_I(inode)->disk_i_size = new_i_size;
 	ret = 0;
 out:
diff --git a/fs/btrfs/ordered-data.h b/fs/btrfs/ordered-data.h
index e03c560..c2443a4 100644
--- a/fs/btrfs/ordered-data.h
+++ b/fs/btrfs/ordered-data.h
@@ -96,6 +96,13 @@ struct btrfs_ordered_extent {
 	/* number of bytes that still need writing */
 	u64 bytes_left;
 
+	/*
+	 * the end of the ordered extent which is behind it but
+	 * didn't update disk_i_size. Please see the comment of
+	 * btrfs_ordered_update_i_size();
+	 */
+	u64 outstanding_isize;
+
 	/* flags (described above) */
 	unsigned long flags;
 
-- 
1.7.6.5
