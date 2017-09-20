Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:34028 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751652AbdIUAwL (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 20 Sep 2017 20:52:11 -0400
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v8L0q9Rk029297
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Thu, 21 Sep 2017 00:52:10 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id v8L0q9bB027699
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Thu, 21 Sep 2017 00:52:09 GMT
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id v8L0q9T3015975
        for <linux-btrfs@vger.kernel.org>; Thu, 21 Sep 2017 00:52:09 GMT
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 2/2] Btrfs: skip checksum when reading compressed data if some IO have failed
Date: Wed, 20 Sep 2017 17:50:19 -0600
Message-Id: <20170920235019.10508-2-bo.li.liu@oracle.com>
In-Reply-To: <20170920235019.10508-1-bo.li.liu@oracle.com>
References: <20170920235019.10508-1-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Currently even if the underlying disk reports failure on IO,
compressed read endio still gets to verify checksum and reports it as
a checksum error.

In fact, if some IO have failed during reading a compressed data
extent , there's no way the checksum could match, therefore, we can
skip that in order to return error quickly to the upper layer.

Please note that we need to do this after recording the failed mirror
index so that read-repair in the upper layer's endio can work
properly.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/compression.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
index 9a4ccdf..d8d4678 100644
--- a/fs/btrfs/compression.c
+++ b/fs/btrfs/compression.c
@@ -108,7 +108,7 @@ static void end_compressed_bio_read(struct bio *bio)
 	struct page *page;
 	unsigned long index;
 	unsigned int mirror = btrfs_io_bio(bio)->mirror_num;
-	int ret;
+	int ret = 0;
 
 	if (bio->bi_status)
 		cb->errors = 1;
@@ -127,6 +127,13 @@ static void end_compressed_bio_read(struct bio *bio)
 	btrfs_io_bio(cb->orig_bio)->mirror_num = mirror;
 	cb->mirror_num = mirror;
 
+	/*
+	 * Some IO in this cb have failed, just skip checksum as there
+	 * is no way it could be correct.
+	 */
+	if (cb->errors == 1)
+		goto csum_failed;
+
 	inode = cb->inode;
 	ret = check_compressed_csum(BTRFS_I(inode), cb,
 				    (u64)bio->bi_iter.bi_sector << 9);
-- 
2.9.4

