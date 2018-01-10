Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:33234 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753451AbeAJCjC (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 9 Jan 2018 21:39:02 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w0A2bYwo121897
        for <linux-btrfs@vger.kernel.org>; Wed, 10 Jan 2018 02:39:01 GMT
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by userp2130.oracle.com with ESMTP id 2fd8su85mw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Wed, 10 Jan 2018 02:39:01 +0000
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w0A2d166020016
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-btrfs@vger.kernel.org>; Wed, 10 Jan 2018 02:39:01 GMT
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w0A2d02Z025367
        for <linux-btrfs@vger.kernel.org>; Wed, 10 Jan 2018 02:39:00 GMT
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2] Btrfs: raid56: fix race between merge_bio and rbio_orig_end_io
Date: Tue,  9 Jan 2018 18:36:25 -0700
Message-Id: <20180110013625.14297-1-bo.li.liu@oracle.com>
In-Reply-To: <20171208230235.30636-1-bo.li.liu@oracle.com>
References: <20171208230235.30636-1-bo.li.liu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Before rbio_orig_end_io() goes to free rbio, rbio may get merged with
more bios from other rbios and rbio->bio_list becomes non-empty,
in that case, these newly merged bios don't end properly.

Once unlock_stripe() is done, rbio->bio_list will not be updated any
more and we can call bio_endio() on all queued bios.

It should only happen in error-out cases, the normal path of recover
and full stripe write have already set RBIO_RMW_LOCKED_BIT to disable
merge before doing IO, so rbio_orig_end_io() called by them doesn't
have the above issue.

Reported-by: Jérôme Carretero <cJ-ko@zougloub.eu>
Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
v2: - Remove the usage spin_lock as there is a chance of deadlock in
      interrupt context, it's reported by lockdep, although it'd never
      happen because we've taken care of it by saving irq flags at all
      places.
    - Update commit log and comments of code to explain the new idea.
    - This has been tested against btrfs/011 for 50 times.

 fs/btrfs/raid56.c | 37 +++++++++++++++++++++++++------------
 1 file changed, 25 insertions(+), 12 deletions(-)

diff --git a/fs/btrfs/raid56.c b/fs/btrfs/raid56.c
index 7747323..b2b426d 100644
--- a/fs/btrfs/raid56.c
+++ b/fs/btrfs/raid56.c
@@ -864,10 +864,17 @@ static void __free_raid_bio(struct btrfs_raid_bio *rbio)
 	kfree(rbio);
 }
 
-static void free_raid_bio(struct btrfs_raid_bio *rbio)
+static void rbio_endio_bio_list(struct bio *cur, blk_status_t err)
 {
-	unlock_stripe(rbio);
-	__free_raid_bio(rbio);
+	struct bio *next;
+
+	while (cur) {
+		next = cur->bi_next;
+		cur->bi_next = NULL;
+		cur->bi_status = err;
+		bio_endio(cur);
+		cur = next;
+	}
 }
 
 /*
@@ -877,20 +884,26 @@ static void free_raid_bio(struct btrfs_raid_bio *rbio)
 static void rbio_orig_end_io(struct btrfs_raid_bio *rbio, blk_status_t err)
 {
 	struct bio *cur = bio_list_get(&rbio->bio_list);
-	struct bio *next;
+	struct bio *extra;
 
 	if (rbio->generic_bio_cnt)
 		btrfs_bio_counter_sub(rbio->fs_info, rbio->generic_bio_cnt);
 
-	free_raid_bio(rbio);
+	/*
+	 * At this moment, rbio->bio_list is empty, however since rbio does not
+	 * always have RBIO_RMW_LOCKED_BIT set and rbio is still linked on the
+	 * hash list, rbio may be merged with others so that rbio->bio_list
+	 * becomes non-empty.
+	 * Once unlock_stripe() is done, rbio->bio_list will not be updated any
+	 * more and we can call bio_endio() on all queued bios.
+	 */
+	unlock_stripe(rbio);
+	extra = bio_list_get(&rbio->bio_list);
+	__free_raid_bio(rbio);
 
-	while (cur) {
-		next = cur->bi_next;
-		cur->bi_next = NULL;
-		cur->bi_status = err;
-		bio_endio(cur);
-		cur = next;
-	}
+	rbio_endio_bio_list(cur, err);
+	if (extra)
+		rbio_endio_bio_list(extra, err);
 }
 
 /*
-- 
2.9.4

