From: Josef Bacik <josef@redhat.com>
Subject: [PATCH] Btrfs: mark the bio with an error if we have a failure in dio
Date: Tue, 22 Mar 2011 11:48:31 -0400
Message-ID: <1300808911-3071-1-git-send-email-josef@redhat.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

I noticed that dio_end_io calls the appropriate endio function with an error,
but the endio functions don't actually do anything with that error, they assume
that if there was an error then the bio will not be uptodate.  So if we had
checksum failures we would never pass back EIO.  So if there is an error in our
endio functions make sure to clear the uptodate flag on the bio.  Thanks,

Signed-off-by: Josef Bacik <josef@redhat.com>
---
 fs/btrfs/inode.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 570cd44..e9813bd 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -5744,6 +5744,10 @@ static void btrfs_endio_direct_read(struct bio *bio, int err)
 
 	kfree(dip->csums);
 	kfree(dip);
+
+	/* If we had a csum failure make sure to clear the uptodate flag */
+	if (err)
+		clear_bit(BIO_UPTODATE, &bio->bi_flags);
 	dio_end_io(bio, err);
 }
 
@@ -5845,6 +5849,10 @@ out_done:
 
 	kfree(dip->csums);
 	kfree(dip);
+
+	/* If we had an error make sure to clear the uptodate flag */
+	if (err)
+		clear_bit(BIO_UPTODATE, &bio->bi_flags);
 	dio_end_io(bio, err);
 }
 
-- 
1.7.2.3

