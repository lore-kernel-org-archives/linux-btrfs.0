Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:48826 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751208AbeAECqQ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 4 Jan 2018 21:46:16 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.21/8.16.0.21) with SMTP id w052hM8Y078169
        for <linux-btrfs@vger.kernel.org>; Fri, 5 Jan 2018 02:46:16 GMT
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by aserp2130.oracle.com with ESMTP id 2fa04er33f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Fri, 05 Jan 2018 02:46:15 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w052kEpA023278
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-btrfs@vger.kernel.org>; Fri, 5 Jan 2018 02:46:15 GMT
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w052kEes012706
        for <linux-btrfs@vger.kernel.org>; Fri, 5 Jan 2018 02:46:14 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v3] btrfs: not a disk error if the bio_add_page fails
Date: Fri,  5 Jan 2018 10:47:07 +0800
Message-Id: <20180105024707.26078-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

bio_add_page() can fail for logical reasons as from the bio_add_page()
comments:- 'This will only fail if either
bio->bi_vcnt == bio->bi_max_vecs or it's a cloned bio.'
Here as we have just allocated the bio, so both of those failures can't
occur. So drop the check for fail. Which would also drop write error
statistics.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
v2->v3: Drop check for bio_add_page return value. Thanks Liubo.
v1->v2: Add missing bio_put(). Thanks Filipe.

 fs/btrfs/scrub.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index ecfe3118d9dd..5030898247db 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -4600,7 +4600,6 @@ static int write_page_nocow(struct scrub_ctx *sctx,
 {
 	struct bio *bio;
 	struct btrfs_device *dev;
-	int ret;
 
 	dev = sctx->wr_tgtdev;
 	if (!dev)
@@ -4615,17 +4614,15 @@ static int write_page_nocow(struct scrub_ctx *sctx,
 	bio->bi_iter.bi_sector = physical_for_dev_replace >> 9;
 	bio_set_dev(bio, dev->bdev);
 	bio->bi_opf = REQ_OP_WRITE | REQ_SYNC;
-	ret = bio_add_page(bio, page, PAGE_SIZE, 0);
-	if (ret != PAGE_SIZE) {
-leave_with_eio:
+	/* bio_add_page won't fail here */
+	bio_add_page(bio, page, PAGE_SIZE, 0);
+
+	if (btrfsic_submit_bio_wait(bio)) {
 		bio_put(bio);
 		btrfs_dev_stat_inc_and_print(dev, BTRFS_DEV_STAT_WRITE_ERRS);
 		return -EIO;
 	}
 
-	if (btrfsic_submit_bio_wait(bio))
-		goto leave_with_eio;
-
 	bio_put(bio);
 	return 0;
 }
-- 
2.15.0

