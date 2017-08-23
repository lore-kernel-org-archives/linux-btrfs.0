Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:40285 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932530AbdHWTRB (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 23 Aug 2017 15:17:01 -0400
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v7NJH0TN013352
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Wed, 23 Aug 2017 19:17:00 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id v7NJGx8P015084
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Wed, 23 Aug 2017 19:16:59 GMT
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id v7NJGxfT011617
        for <linux-btrfs@vger.kernel.org>; Wed, 23 Aug 2017 19:16:59 GMT
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: do not reset bio->bi_ops while writing bio
Date: Wed, 23 Aug 2017 12:15:09 -0600
Message-Id: <20170823181509.19816-1-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

flush_epd_write_bio() sets bio->bi_ops by itself to honor REQ_SYNC,
but it's not needed at all since bio->bi_ops has set up properly in
both __extent_writepage() and write_one_eb(), and in the case of
write_one_eb(), it also sets REQ_META, which we will lose in
flush_epd_write_bio().

This remove this unnecessary bio->bi_ops setting.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/extent_io.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index b61d68f..a454a10 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -4054,9 +4054,6 @@ static void flush_epd_write_bio(struct extent_page_data *epd)
 	if (epd->bio) {
 		int ret;
 
-		bio_set_op_attrs(epd->bio, REQ_OP_WRITE,
-				 epd->sync_io ? REQ_SYNC : 0);
-
 		ret = submit_one_bio(epd->bio, 0, 0);
 		BUG_ON(ret < 0); /* -ENOMEM */
 		epd->bio = NULL;
-- 
2.9.4

