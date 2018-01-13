Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:44076 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965201AbeAMCJq (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 12 Jan 2018 21:09:46 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w0D27TGU054711
        for <linux-btrfs@vger.kernel.org>; Sat, 13 Jan 2018 02:09:45 GMT
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by userp2130.oracle.com with ESMTP id 2ff8kgg1pd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Sat, 13 Jan 2018 02:09:45 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w0D29iLp016371
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-btrfs@vger.kernel.org>; Sat, 13 Jan 2018 02:09:44 GMT
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w0D29iut002942
        for <linux-btrfs@vger.kernel.org>; Sat, 13 Jan 2018 02:09:44 GMT
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: raid56: iterate raid56 internal bio with bio_for_each_segment_all
Date: Fri, 12 Jan 2018 18:07:01 -0700
Message-Id: <20180113010702.25612-1-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Bio iterated by set_bio_pages_uptodate() is raid56 internal one, so it
will never be a BIO_CLONED bio, and since this is called by end_io
functions, bio->bi_iter.bi_size is zero, we mustn't use
bio_for_each_segment() as that is a no-op if bi_size is zero.

Fixes: 6592e58c6b68e61f003a01ba29a3716e7e2e9484 ("Btrfs: fix write corruption due to bio cloning on raid5/6")
Cc: <stable@vger.kernel.org> # v4.12-rc6+
Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/raid56.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/raid56.c b/fs/btrfs/raid56.c
index 765af6a..56ae5bd 100644
--- a/fs/btrfs/raid56.c
+++ b/fs/btrfs/raid56.c
@@ -1442,14 +1442,13 @@ static int fail_bio_stripe(struct btrfs_raid_bio *rbio,
  */
 static void set_bio_pages_uptodate(struct bio *bio)
 {
-	struct bio_vec bvec;
-	struct bvec_iter iter;
+	struct bio_vec *bvec;
+	int i;
 
-	if (bio_flagged(bio, BIO_CLONED))
-		bio->bi_iter = btrfs_io_bio(bio)->iter;
+	ASSERT(!bio_flagged(bio, BIO_CLONED));
 
-	bio_for_each_segment(bvec, bio, iter)
-		SetPageUptodate(bvec.bv_page);
+	bio_for_each_segment_all(bvec, bio, i)
+		SetPageUptodate(bvec->bv_page);
 }
 
 /*
-- 
2.9.4

