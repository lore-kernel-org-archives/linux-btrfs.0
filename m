Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:38614 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750788AbdLIAE7 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 8 Dec 2017 19:04:59 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.21/8.16.0.21) with SMTP id vB902EIi060759
        for <linux-btrfs@vger.kernel.org>; Sat, 9 Dec 2017 00:04:58 GMT
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by userp2120.oracle.com with ESMTP id 2er4pag20d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-btrfs@vger.kernel.org>; Sat, 09 Dec 2017 00:04:58 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id vB904vBO003146
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Sat, 9 Dec 2017 00:04:57 GMT
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id vB904vvB030390
        for <linux-btrfs@vger.kernel.org>; Sat, 9 Dec 2017 00:04:57 GMT
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: raid56: fix race between merge_bio and rbio_orig_end_io
Date: Fri,  8 Dec 2017 16:02:35 -0700
Message-Id: <20171208230235.30636-1-bo.li.liu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We're not allowed to take any new bios to rbio->bio_list in
rbio_orig_end_io(), otherwise we may get merged with more bios and
rbio->bio_list is not empty.

This should only happens in error-out cases, the normal path of
recover and full stripe write have already set RBIO_RMW_LOCKED_BIT to
disable merge before doing IO.

Reported-by: Jérôme Carretero <cJ-ko@zougloub.eu>
Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/raid56.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/raid56.c b/fs/btrfs/raid56.c
index 5aa9d22..127c782 100644
--- a/fs/btrfs/raid56.c
+++ b/fs/btrfs/raid56.c
@@ -859,12 +859,23 @@ static void free_raid_bio(struct btrfs_raid_bio *rbio)
  */
 static void rbio_orig_end_io(struct btrfs_raid_bio *rbio, blk_status_t err)
 {
-	struct bio *cur = bio_list_get(&rbio->bio_list);
+	struct bio *cur;
 	struct bio *next;
 
+	/*
+	 * We're not allowed to take any new bios to rbio->bio_list
+	 * from now on, otherwise we may get merged with more bios and
+	 * rbio->bio_list is not empty.
+	 */
+	spin_lock(&rbio->bio_list_lock);
+	set_bit(RBIO_RMW_LOCKED_BIT, &rbio->flags);
+	spin_unlock(&rbio->bio_list_lock);
+
 	if (rbio->generic_bio_cnt)
 		btrfs_bio_counter_sub(rbio->fs_info, rbio->generic_bio_cnt);
 
+	cur = bio_list_get(&rbio->bio_list);
+
 	free_raid_bio(rbio);
 
 	while (cur) {
-- 
2.9.4

