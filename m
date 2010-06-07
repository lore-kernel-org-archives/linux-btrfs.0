From: Josef Bacik <josef@redhat.com>
Subject: [PATCH] Btrfs: read from backup copy if csum fails with DIO
Date: Mon,  7 Jun 2010 17:07:10 -0400
Message-ID: <1275944830-4698-1-git-send-email-josef@redhat.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Previously DIO would simply fail if the checksums didn't match when doing DIO
reads, but if we mirror data then we have another copy we can read from.  This
patch does this by cloning the bio and resubmitting it against the next mirror.
I tested this by short-circuiting things so the first mirror _always_ failed,
and then ran xfstests and fsx with dio enabled.  Both xfstests and fsx ran
without problems.  Thanks,

Signed-off-by: Josef Bacik <josef@redhat.com>
---
 fs/btrfs/inode.c |   42 +++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 41 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index d999c53..78c0547 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -5494,6 +5494,7 @@ struct btrfs_dio_private {
 	u64 bytes;
 	u32 *csums;
 	void *private;
+	int mirror;
 };
 
 static void btrfs_endio_direct_read(struct bio *bio, int err)
@@ -5503,8 +5504,11 @@ static void btrfs_endio_direct_read(struct bio *bio, int err)
 	struct btrfs_dio_private *dip = bio->bi_private;
 	struct inode *inode = dip->inode;
 	struct btrfs_root *root = BTRFS_I(inode)->root;
+	struct bio *new_bio;
 	u64 start;
 	u32 *private = dip->csums;
+	int num_copies;
+	int ret;
 
 	start = dip->logical_offset;
 	do {
@@ -5528,7 +5532,7 @@ static void btrfs_endio_direct_read(struct bio *bio, int err)
 				      " %llu csum %u private %u\n",
 				      inode->i_ino, (unsigned long long)start,
 				      csum, *private);
-				err = -EIO;
+				goto failed;
 			}
 		}
 
@@ -5537,6 +5541,7 @@ static void btrfs_endio_direct_read(struct bio *bio, int err)
 		bvec++;
 	} while (bvec <= bvec_end);
 
+out:
 	unlock_extent(&BTRFS_I(inode)->io_tree, dip->logical_offset,
 		      dip->logical_offset + dip->bytes - 1, GFP_NOFS);
 	bio->bi_private = dip->private;
@@ -5544,6 +5549,40 @@ static void btrfs_endio_direct_read(struct bio *bio, int err)
 	kfree(dip->csums);
 	kfree(dip);
 	dio_end_io(bio, err);
+	return;
+failed:
+	num_copies = btrfs_num_copies(&root->fs_info->mapping_tree,
+				      dip->logical_offset, dip->bytes);
+	dip->mirror++;
+	if (dip->mirror > num_copies) {
+		err = -EIO;
+		goto out;
+	}
+
+	new_bio = bio_clone(bio, GFP_NOFS);
+	if (!new_bio) {
+		err = -EIO;
+		goto out;
+	}
+
+	new_bio->bi_end_io = btrfs_endio_direct_read;
+	new_bio->bi_private = dip;
+	new_bio->bi_size = dip->bytes;
+	new_bio->bi_sector = dip->disk_bytenr >> 9;
+
+	ret = btrfs_bio_wq_end_io(root->fs_info, new_bio, 0);
+	if (ret) {
+		bio_put(new_bio);
+		err = -EIO;
+		goto out;
+	}
+
+	ret = btrfs_map_bio(root, READ, new_bio, dip->mirror, 1);
+	if (ret) {
+		bio_put(new_bio);
+		err = -EIO;
+		goto out;
+	}
 }
 
 static void btrfs_endio_direct_write(struct bio *bio, int err)
@@ -5674,6 +5713,7 @@ static void btrfs_submit_direct(int rw, struct bio *bio, struct inode *inode,
 	dip->private = bio->bi_private;
 	dip->inode = inode;
 	dip->logical_offset = file_offset;
+	dip->mirror = 0;
 
 	start = dip->logical_offset;
 	dip->bytes = 0;
-- 
1.6.6.1

