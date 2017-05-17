Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:25321 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751360AbdEQWmq (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 17 May 2017 18:42:46 -0400
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>
Subject: [PATCH v2] Btrfs: tolerate errors if we have retried successfully
Date: Wed, 17 May 2017 15:42:00 -0600
Message-Id: <20170517214200.9006-1-bo.li.liu@oracle.com>
In-Reply-To: <1492132316-3076-1-git-send-email-bo.li.liu@oracle.com>
References: <1492132316-3076-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

With raid1 profile, dio read isn't tolerating IO errors if read length is
less than the stripe length (64K).

Our bio didn't get split in btrfs_submit_direct_hook() if (dip->flags &
BTRFS_DIO_ORIG_BIO_SUBMITTED) is true and that happens when the read
length is less than 64k.  In this case, if the underlying device returns
error somehow, bio->bi_error has recorded that error.

If we could recover the correct data from another copy in profile raid1/10/5/6,
with btrfs_subio_endio_read() returning 0, bio would have the correct data in
its vector, but bio->bi_error is not updated accordingly so that the following
dio_end_io(dio_bio, bio->bi_error) makes directIO think this read has failed.

This fixes the problem by setting bio's error to 0 if a good copy has been
found.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---

v2: Add more details to changelog.

 fs/btrfs/inode.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 632b616..4e1398e 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -8113,8 +8113,11 @@ static void btrfs_endio_direct_read(struct bio *bio)
 	struct btrfs_io_bio *io_bio = btrfs_io_bio(bio);
 	int err = bio->bi_error;
 
-	if (dip->flags & BTRFS_DIO_ORIG_BIO_SUBMITTED)
+	if (dip->flags & BTRFS_DIO_ORIG_BIO_SUBMITTED) {
 		err = btrfs_subio_endio_read(inode, io_bio, err);
+		if (!err)
+			bio->bi_error = 0;
+	}
 
 	unlock_extent(&BTRFS_I(inode)->io_tree, dip->logical_offset,
 		      dip->logical_offset + dip->bytes - 1);
-- 
2.5.5

