Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:41807 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751213AbdIOWJC (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 15 Sep 2017 18:09:02 -0400
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: Goffredo Baroncelli <kreijack@inwind.it>
Subject: [PATCH] Btrfs: fix unexpected result when dio reading corrupted blocks
Date: Fri, 15 Sep 2017 15:06:51 -0600
Message-Id: <20170915210651.8385-1-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

commit 4246a0b63bd8 ("block: add a bi_error field to struct bio")
changed the logic of how dio read endio reports errors.

For single stripe dio read, %bio->bi_status reflects the error before
verifying checksum, and now we're updating it when data block matches
with its checksum, while in the mismatching case, %bio->bi_status is
not updated to relfect that.

When some blocks in a file have been corrupted on disk, reading such a
file ends up with

1) checksum errros are reported in kernel log
2) read(2) returns successfully with some content being 0x01.

In order to fix it, we need to report its checksum mismatch error to
the upper layer (dio layer in this case) as well.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
Reported-by: Goffredo Baroncelli <kreijack@inwind.it>
cc: Goffredo Baroncelli <kreijack@inwind.it>
---
 fs/btrfs/inode.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 24bcd5c..a46799e 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -8267,11 +8267,8 @@ static void btrfs_endio_direct_read(struct bio *bio)
 	struct btrfs_io_bio *io_bio = btrfs_io_bio(bio);
 	blk_status_t err = bio->bi_status;
 
-	if (dip->flags & BTRFS_DIO_ORIG_BIO_SUBMITTED) {
+	if (dip->flags & BTRFS_DIO_ORIG_BIO_SUBMITTED)
 		err = btrfs_subio_endio_read(inode, io_bio, err);
-		if (!err)
-			bio->bi_status = 0;
-	}
 
 	unlock_extent(&BTRFS_I(inode)->io_tree, dip->logical_offset,
 		      dip->logical_offset + dip->bytes - 1);
@@ -8279,7 +8276,7 @@ static void btrfs_endio_direct_read(struct bio *bio)
 
 	kfree(dip);
 
-	dio_bio->bi_status = bio->bi_status;
+	dio_bio->bi_status = err;
 	dio_end_io(dio_bio);
 
 	if (io_bio->end_io)
-- 
1.8.3.1

