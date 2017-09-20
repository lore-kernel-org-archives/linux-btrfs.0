Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:34023 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751584AbdIUAwK (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 20 Sep 2017 20:52:10 -0400
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v8L0q9ah029293
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Thu, 21 Sep 2017 00:52:09 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id v8L0q9FZ028952
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Thu, 21 Sep 2017 00:52:09 GMT
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id v8L0q8RC022227
        for <linux-btrfs@vger.kernel.org>; Thu, 21 Sep 2017 00:52:09 GMT
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 1/2] Btrfs: fix kernel oops while reading compressed data
Date: Wed, 20 Sep 2017 17:50:18 -0600
Message-Id: <20170920235019.10508-1-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The kernel oops happens at

kernel BUG at fs/btrfs/extent_io.c:2104!
...
RIP: clean_io_failure+0x263/0x2a0 [btrfs]

It's showing that read-repair code is using an improper mirror index.
This is due to the fact that compression read's endio hasn't recorded
the failed mirror index in %cb->orig_bio.

With this, btrfs's read-repair can work properly on reading compressed
data.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
Reported-by: Paul Jones <paul@pauljones.id.au>
---
 fs/btrfs/compression.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
index d2ef9ac..9a4ccdf 100644
--- a/fs/btrfs/compression.c
+++ b/fs/btrfs/compression.c
@@ -107,6 +107,7 @@ static void end_compressed_bio_read(struct bio *bio)
 	struct inode *inode;
 	struct page *page;
 	unsigned long index;
+	unsigned int mirror = btrfs_io_bio(bio)->mirror_num;
 	int ret;
 
 	if (bio->bi_status)
@@ -118,6 +119,14 @@ static void end_compressed_bio_read(struct bio *bio)
 	if (!refcount_dec_and_test(&cb->pending_bios))
 		goto out;
 
+	/*
+	 * Record the correct mirror_num in cb->orig_bio so that
+	 * read-repair can work properly.
+	 */
+	ASSERT(btrfs_io_bio(cb->orig_bio));
+	btrfs_io_bio(cb->orig_bio)->mirror_num = mirror;
+	cb->mirror_num = mirror;
+
 	inode = cb->inode;
 	ret = check_compressed_csum(BTRFS_I(inode), cb,
 				    (u64)bio->bi_iter.bi_sector << 9);
-- 
2.9.4

