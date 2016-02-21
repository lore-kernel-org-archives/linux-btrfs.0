Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from 17.mo4.mail-out.ovh.net ([46.105.41.16]:41631 "EHLO
	17.mo4.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752358AbcBUXDG (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 21 Feb 2016 18:03:06 -0500
Received: from mail178.ha.ovh.net (b9.ovh.net [213.186.33.59])
	by mo4.mail-out.ovh.net (Postfix) with SMTP id 9A14A10F40ED
	for <linux-btrfs@vger.kernel.org>; Mon, 22 Feb 2016 00:03:00 +0100 (CET)
From: Philippe Loctaux <phil@philippeloctaux.com>
To: clm@fb.com
Cc: jbacik@fb.com, dsterba@suse.com, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Philippe Loctaux <phil@philippeloctaux.com>
Subject: [PATCH] Btrfs: check-integrity: fixed comment blocks coding style issues
Date: Mon, 22 Feb 2016 00:02:47 +0100
Message-Id: <1456095767-1561-1-git-send-email-phil@philippeloctaux.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Makes the comment blocks start with /* on separate lines, and end
with */ on separate lines as well.

Signed-off-by: Philippe Loctaux <phil@philippeloctaux.com>
---
 fs/btrfs/check-integrity.c | 30 ++++++++++++++++++++++--------
 1 file changed, 22 insertions(+), 8 deletions(-)

diff --git a/fs/btrfs/check-integrity.c b/fs/btrfs/check-integrity.c
index 861d472..cb5dc04 100644
--- a/fs/btrfs/check-integrity.c
+++ b/fs/btrfs/check-integrity.c
@@ -2070,8 +2070,11 @@ again:
 				goto continue_loop;
 			}
 
-			/* this is getting ugly for the
-			 * include_extent_data case... */
+			/*
+			 * this is getting ugly for the
+			 * include_extent_data case...
+			 */
+
 			bytenr = 0;	/* unknown */
 		} else {
 			processed_len = state->metablock_size;
@@ -2180,8 +2183,11 @@ static void btrfsic_bio_end_io(struct bio *bp)
 	struct btrfsic_block *block = (struct btrfsic_block *)bp->bi_private;
 	int iodone_w_error;
 
-	/* mutex is not held! This is not save if IO is not yet completed
-	 * on umount */
+	/*
+	 * mutex is not held! This is not save if IO is not yet completed
+	 * on umount
+	 */
+
 	iodone_w_error = 0;
 	if (bp->bi_error)
 		iodone_w_error = 1;
@@ -2861,8 +2867,12 @@ int btrfsic_submit_bh(int rw, struct buffer_head *bh)
 		return submit_bh(rw, bh);
 
 	mutex_lock(&btrfsic_mutex);
-	/* since btrfsic_submit_bh() might also be called before
-	 * btrfsic_mount(), this might return NULL */
+
+	/*
+	 * since btrfsic_submit_bh() might also be called before
+	 * btrfsic_mount(), this might return NULL
+	 */
+
 	dev_state = btrfsic_dev_state_lookup(bh->b_bdev);
 
 	/* Only called to write the superblock (incl. FLUSH/FUA) */
@@ -2924,8 +2934,12 @@ static void __btrfsic_submit_bio(int rw, struct bio *bio)
 		return;
 
 	mutex_lock(&btrfsic_mutex);
-	/* since btrfsic_submit_bio() is also called before
-	 * btrfsic_mount(), this might return NULL */
+
+	/*
+	 * since btrfsic_submit_bio() is also called before
+	 * btrfsic_mount(), this might return NULL
+	 */
+
 	dev_state = btrfsic_dev_state_lookup(bio->bi_bdev);
 	if (NULL != dev_state &&
 	    (rw & WRITE) && NULL != bio->bi_io_vec) {
-- 
2.7.1

