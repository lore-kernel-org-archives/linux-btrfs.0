Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:41823 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751333AbeACNwE (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 3 Jan 2018 08:52:04 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.21/8.16.0.21) with SMTP id w03DpYvT025222
        for <linux-btrfs@vger.kernel.org>; Wed, 3 Jan 2018 13:52:04 GMT
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by userp2130.oracle.com with ESMTP id 2f906br2fh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Wed, 03 Jan 2018 13:52:03 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w03Dq3Xj014297
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-btrfs@vger.kernel.org>; Wed, 3 Jan 2018 13:52:03 GMT
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w03Dq3ZB015802
        for <linux-btrfs@vger.kernel.org>; Wed, 3 Jan 2018 13:52:03 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2] btrfs: not a disk error if the bio_add_page fails
Date: Wed,  3 Jan 2018 21:52:43 +0800
Message-Id: <20180103135243.21169-1-anand.jain@oracle.com>
In-Reply-To: <20180103080729.20804-1-anand.jain@oracle.com>
References: <20180103080729.20804-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

bio_add_page() can fail for logical reasons as from the bio_add_page()
comments:- 'This will only fail if either
bio->bi_vcnt == bio->bi_max_vecs or it's a cloned bio.' Don't inc the
write error statistics for this. And set -EINVAL instead of -EIO.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
v1->v2: Add missing bio_put(). Thanks Filipe.

 fs/btrfs/scrub.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index ecfe3118d9dd..57ac39a3f046 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -4617,15 +4617,16 @@ static int write_page_nocow(struct scrub_ctx *sctx,
 	bio->bi_opf = REQ_OP_WRITE | REQ_SYNC;
 	ret = bio_add_page(bio, page, PAGE_SIZE, 0);
 	if (ret != PAGE_SIZE) {
-leave_with_eio:
+		bio_put(bio);
+		return -EINVAL;
+	}
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

