Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:41809 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751862AbcKPMwu (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 16 Nov 2016 07:52:50 -0500
Received: from 80-109-146-114.cable.dynamic.surfer.at ([80.109.146.114] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.85_2 #1 (Red Hat Linux))
        id 1c6zhp-0005VJ-EI
        for linux-btrfs@vger.kernel.org; Wed, 16 Nov 2016 12:52:49 +0000
From: Christoph Hellwig <hch@lst.de>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 9/9] btrfs: only check bio size to see if a repair bio should have the failfast flag
Date: Wed, 16 Nov 2016 13:52:16 +0100
Message-Id: <1479300736-9724-10-git-send-email-hch@lst.de>
In-Reply-To: <1479300736-9724-1-git-send-email-hch@lst.de>
References: <1479300736-9724-1-git-send-email-hch@lst.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The number of pages in a bio is a bad indicatator for the number of
splits lower levels could do, and with the multipage bio_vec work even
that measure goes away and will become a number of segments of physically
contiguous areas instead.  Check the total bio size vs the sector size
instead, which gives us an indication without any false negatives,
although the false positive rate might increase a bit.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/btrfs/extent_io.c | 4 ++--
 fs/btrfs/inode.c     | 4 +---
 2 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index ea9ade7..a05fc41 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -2296,7 +2296,7 @@ int btrfs_check_repairable(struct inode *inode, struct bio *failed_bio,
 	 *	a) deliver good data to the caller
 	 *	b) correct the bad sectors on disk
 	 */
-	if (failed_bio->bi_vcnt > 1) {
+	if (failed_bio->bi_iter.bi_size > BTRFS_I(inode)->root->sectorsize) {
 		/*
 		 * to fulfill b), we need to know the exact failing sectors, as
 		 * we don't want to rewrite any more than the failed ones. thus,
@@ -2403,7 +2403,7 @@ static int bio_readpage_error(struct bio *failed_bio, u64 phy_offset,
 		return -EIO;
 	}
 
-	if (failed_bio->bi_vcnt > 1)
+	if (failed_bio->bi_iter.bi_size > BTRFS_I(inode)->root->sectorsize)
 		read_mode = READ_SYNC | REQ_FAILFAST_DEV;
 	else
 		read_mode = READ_SYNC;
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 3f09cb6..54afe41 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -7933,9 +7933,7 @@ static int dio_read_error(struct inode *inode, struct bio *failed_bio,
 		return -EIO;
 	}
 
-	if ((failed_bio->bi_vcnt > 1)
-		|| (failed_bio->bi_io_vec->bv_len
-			> BTRFS_I(inode)->root->sectorsize))
+	if (failed_bio->bi_iter.bi_size > BTRFS_I(inode)->root->sectorsize)
 		read_mode = READ_SYNC | REQ_FAILFAST_DEV;
 	else
 		read_mode = READ_SYNC;
-- 
2.1.4

