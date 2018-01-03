Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:58736 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751336AbeACIGo (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 3 Jan 2018 03:06:44 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.21/8.16.0.21) with SMTP id w0386etC041310
        for <linux-btrfs@vger.kernel.org>; Wed, 3 Jan 2018 08:06:43 GMT
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by aserp2120.oracle.com with ESMTP id 2f8u6w01n7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Wed, 03 Jan 2018 08:06:43 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w0386gui023590
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-btrfs@vger.kernel.org>; Wed, 3 Jan 2018 08:06:42 GMT
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w0386fhK015995
        for <linux-btrfs@vger.kernel.org>; Wed, 3 Jan 2018 08:06:41 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs: not a disk error if the bio_add_page fails
Date: Wed,  3 Jan 2018 16:07:29 +0800
Message-Id: <20180103080729.20804-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

bio_add_page() can fail for logical reasons as from the bio_add_page()
comments:- 'This will only fail if either
bio->bi_vcnt == bio->bi_max_vecs or it's a cloned bio.' Don't inc the
write error statistics for this. And set -EINVAL instead of -EIO.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/scrub.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index d766c73eb29a..8c1508a41f90 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -4618,15 +4618,15 @@ static int write_page_nocow(struct scrub_ctx *sctx,
 	bio->bi_opf = REQ_OP_WRITE | REQ_SYNC;
 	ret = bio_add_page(bio, page, PAGE_SIZE, 0);
 	if (ret != PAGE_SIZE) {
-leave_with_eio:
 		bio_put(bio);
+		return -EINVAL;
+	}
+
+	if (btrfsic_submit_bio_wait(bio)) {
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

