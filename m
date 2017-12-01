Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:36573 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751007AbdLAB3A (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 30 Nov 2017 20:29:00 -0500
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id vB11SxaS022833
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Fri, 1 Dec 2017 01:28:59 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id vB11SwQF026438
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Fri, 1 Dec 2017 01:28:59 GMT
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id vB11Sw7a006684
        for <linux-btrfs@vger.kernel.org>; Fri, 1 Dec 2017 01:28:58 GMT
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: use struct completion in scrub_submit_raid56_bio_wait
Date: Thu, 30 Nov 2017 17:26:39 -0700
Message-Id: <20171201002639.32257-1-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This changes to use struct completion directly and removes 'struct
scrub_bio_ret' along with the code using it.

This struct is used to get the return value from bio, but the caller
can access bio to get the return value directly and is holding a
reference on bio so that it won't go away underneath us.  So it can be
removed safely.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/scrub.c | 21 ++++-----------------
 1 file changed, 4 insertions(+), 17 deletions(-)

diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index e3f6c49..0cdf359 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -1666,17 +1666,9 @@ static int scrub_setup_recheck_block(struct scrub_block *original_sblock,
 	return 0;
 }
 
-struct scrub_bio_ret {
-	struct completion event;
-	blk_status_t status;
-};
-
 static void scrub_bio_wait_endio(struct bio *bio)
 {
-	struct scrub_bio_ret *ret = bio->bi_private;
-
-	ret->status = bio->bi_status;
-	complete(&ret->event);
+	complete(bio->bi_private);
 }
 
 static inline int scrub_is_page_on_raid56(struct scrub_page *page)
@@ -1689,11 +1681,9 @@ static int scrub_submit_raid56_bio_wait(struct btrfs_fs_info *fs_info,
 					struct bio *bio,
 					struct scrub_page *page)
 {
-	struct scrub_bio_ret done;
+	DECLARE_COMPLETION_ONSTACK(done);
 	int ret;
 
-	init_completion(&done.event);
-	done.status = 0;
 	bio->bi_iter.bi_sector = page->logical >> 9;
 	bio->bi_private = &done;
 	bio->bi_end_io = scrub_bio_wait_endio;
@@ -1704,11 +1694,8 @@ static int scrub_submit_raid56_bio_wait(struct btrfs_fs_info *fs_info,
 	if (ret)
 		return ret;
 
-	wait_for_completion_io(&done.event);
-	if (done.status)
-		return -EIO;
-
-	return 0;
+	wait_for_completion_io(&done);
+	return blk_status_to_errno(bio->bi_status);
 }
 
 /*
-- 
2.9.4

