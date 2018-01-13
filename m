Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:45414 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965376AbeAMCJq (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 12 Jan 2018 21:09:46 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w0D27PrH060051
        for <linux-btrfs@vger.kernel.org>; Sat, 13 Jan 2018 02:09:45 GMT
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by userp2120.oracle.com with ESMTP id 2ff8qcr15q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Sat, 13 Jan 2018 02:09:45 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w0D29ixd025918
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-btrfs@vger.kernel.org>; Sat, 13 Jan 2018 02:09:44 GMT
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w0D29ifp031823
        for <linux-btrfs@vger.kernel.org>; Sat, 13 Jan 2018 02:09:44 GMT
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: do not cache rbio pages if using raid6 recover
Date: Fri, 12 Jan 2018 18:07:02 -0700
Message-Id: <20180113010702.25612-2-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Since raid6 recover tries all possible combinations of failed stripes,

- when raid6 rebuild algorithm is used, i.e. raid6_datap_recov() and
  raid6_2data_recov(), it may change the in-memory content of failed
  stripes, if such a raid bio is cached, a later raid write rmw or recover
  can steal @stripe_pages from it instead of reading from disks, such that
  it carries the wrong content to do write rmw or recovery and ends up
  with corruption or recovery failures.

- when raid5 rebuild algorithm is used, i.e. xor, raid bio can be cached
  because the only failed stripe which contains @rbio->bio_pages gets
  modified, others remain the same so that their in-memory content is
  consistent with their on-disk content.

This adds a check to skip caching rbio if using raid6 recover.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/raid56.c | 17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/raid56.c b/fs/btrfs/raid56.c
index 56ae5bd..4d56f24 100644
--- a/fs/btrfs/raid56.c
+++ b/fs/btrfs/raid56.c
@@ -1975,7 +1975,22 @@ static void __raid_recover_end_io(struct btrfs_raid_bio *rbio)
 
 cleanup_io:
 	if (rbio->operation == BTRFS_RBIO_READ_REBUILD) {
-		if (err == BLK_STS_OK)
+		/*
+		 * - In case of two failures, where rbio->failb != -1:
+		 *
+		 *   Do not cache this rbio since the above read reconstruction
+		 *   (raid6_datap_recov() or raid6_2data_recov()) may have
+		 *   changed some content of stripes which are not identical to
+		 *   on-disk content any more, otherwise, a later write/recover
+		 *   may steal stripe_pages from this rbio and end up with
+		 *   corruptions or rebuild failures.
+		 *
+		 * - In case of single failure, where rbio->failb == -1:
+		 *
+		 *   Cache this rbio iff the above read reconstruction is
+		 *   excuted without problems.
+		 */
+		if (err == BLK_STS_OK && rbio->failb < 0)
 			cache_rbio_pages(rbio);
 		else
 			clear_bit(RBIO_CACHE_READY_BIT, &rbio->flags);
-- 
2.9.4

