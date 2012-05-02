From: Josef Bacik <josef@redhat.com>
Subject: [PATCH] Btrfs: do not check delalloc when updating disk_i_size V2
Date: Wed,  2 May 2012 13:53:36 -0400
Message-ID: <1335981216-14509-1-git-send-email-josef@redhat.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

We are checking delalloc to see if it is ok to update the i_size.  There are
2 cases it stops us from updating

1) If there is delalloc between our current disk_i_size and this ordered
extent

2) If there is delalloc between our current ordered extent and the next
ordered extent

These tests are racy however since we can set delalloc for these ranges at
any time.  Also for the first case if we notice there is delalloc between
disk_i_size and our ordered extent we will not update disk_i_size and assume
that when that delalloc bit gets written out it will update everything
properly.  However if we crash before that we will have file extents outside
of our i_size, which is not good, so this test is dangerous as well as racy.
Thanks,

Signed-off-by: Josef Bacik <josef@redhat.com>
---
V1->V2: Sorry forgot to remove an unused variable.

 fs/btrfs/ordered-data.c |   19 +++----------------
 1 files changed, 3 insertions(+), 16 deletions(-)

diff --git a/fs/btrfs/ordered-data.c b/fs/btrfs/ordered-data.c
index 9807750..9565c02 100644
--- a/fs/btrfs/ordered-data.c
+++ b/fs/btrfs/ordered-data.c
@@ -751,7 +751,6 @@ int btrfs_ordered_update_i_size(struct inode *inode, u64 offset,
 				struct btrfs_ordered_extent *ordered)
 {
 	struct btrfs_ordered_inode_tree *tree = &BTRFS_I(inode)->ordered_tree;
-	struct extent_io_tree *io_tree = &BTRFS_I(inode)->io_tree;
 	u64 disk_i_size;
 	u64 new_i_size;
 	u64 i_size_test;
@@ -785,14 +784,6 @@ int btrfs_ordered_update_i_size(struct inode *inode, u64 offset,
 	}
 
 	/*
-	 * we can't update the disk_isize if there are delalloc bytes
-	 * between disk_i_size and  this ordered extent
-	 */
-	if (test_range_bit(io_tree, disk_i_size, offset - 1,
-			   EXTENT_DELALLOC, 0, NULL)) {
-		goto out;
-	}
-	/*
 	 * walk backward from this ordered extent to disk_i_size.
 	 * if we find an ordered extent then we can't update disk i_size
 	 * yet
@@ -853,15 +844,11 @@ int btrfs_ordered_update_i_size(struct inode *inode, u64 offset,
 
 	/*
 	 * i_size_test is the end of a region after this ordered
-	 * extent where there are no ordered extents.  As long as there
-	 * are no delalloc bytes in this area, it is safe to update
-	 * disk_i_size to the end of the region.
+	 * extent where there are no ordered extents, we can safely set
+	 * disk_i_size to this.
 	 */
-	if (i_size_test > offset &&
-	    !test_range_bit(io_tree, offset, i_size_test - 1,
-			    EXTENT_DELALLOC, 0, NULL)) {
+	if (i_size_test > offset)
 		new_i_size = min_t(u64, i_size_test, i_size);
-	}
 	BTRFS_I(inode)->disk_i_size = new_i_size;
 	ret = 0;
 out:
-- 
1.7.7.6

