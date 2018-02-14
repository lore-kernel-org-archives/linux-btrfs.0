Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:51064 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754381AbeBNIxm (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 14 Feb 2018 03:53:42 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id E343AAC39
        for <linux-btrfs@vger.kernel.org>; Wed, 14 Feb 2018 08:53:40 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH] btrfs: Remove redundant memory barriers
Date: Wed, 14 Feb 2018 10:53:36 +0200
Message-Id: <1518598416-13069-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Using any kind of memory barriers around atomic operations which have
a return value is redundant, since those operations themselves are
fully ordered. atomic_t.txt states:

    - RMW operations that have a return value are fully ordered;

    Fully ordered primitives are ordered against everything prior and
    everything subsequent. Therefore a fully ordered primitive is like
    having an smp_mb() before and an smp_mb() after the primitive.

Given this let's replace the extra memory barriers with comments.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/inode.c | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 8997e39c8e37..b6e4288010fa 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -8321,13 +8321,13 @@ static void btrfs_end_dio_bio(struct bio *bio)
 		err = dip->subio_endio(dip->inode, btrfs_io_bio(bio), err);
 
 	if (err) {
-		dip->errors = 1;
-
 		/*
-		 * before atomic variable goto zero, we must make sure
-		 * dip->errors is perceived to be set.
+		 * We want to perceive the errors flag being set before
+		 * decrementing the reference count. We don't need a barrier
+		 * since atomic operations with a return value are fully
+		 * ordered as per atomic_t.txt
 		 */
-		smp_mb__before_atomic();
+		dip->errors = 1;
 	}
 
 	/* if there are more bios still pending for this dio, just exit */
@@ -8515,10 +8515,11 @@ static int btrfs_submit_direct_hook(struct btrfs_dio_private *dip)
 out_err:
 	dip->errors = 1;
 	/*
-	 * before atomic variable goto zero, we must
-	 * make sure dip->errors is perceived to be set.
+	 * Before atomic variable goto zero, we must  make sure dip->errors is
+	 * perceived to be set. This ordering is ensured by the fact that an
+	 * atomic operations with a return value are fully ordered as per
+	 * atomic_t.txt
 	 */
-	smp_mb__before_atomic();
 	if (atomic_dec_and_test(&dip->pending_bios))
 		bio_io_error(dip->orig_bio);
 
-- 
2.7.4

