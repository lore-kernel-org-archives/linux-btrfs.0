Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:34675 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751165AbdK2HKy (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 29 Nov 2017 02:10:54 -0500
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id vAT7ArA2018572
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Wed, 29 Nov 2017 07:10:53 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id vAT7ArC1021970
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Wed, 29 Nov 2017 07:10:53 GMT
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id vAT7Aq7a018884
        for <linux-btrfs@vger.kernel.org>; Wed, 29 Nov 2017 07:10:53 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 1/2] btrfs: submit a normal bio for the mirror read
Date: Wed, 29 Nov 2017 15:11:14 +0800
Message-Id: <20171129071115.7399-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When the fist mirror failed to read we submit bio again to read from the
2nd mirror, however during this, we also set the flag REQ_FAILFAST_DEV
which indicates to the underlying block device driver not to perform the
default IO retry (sd, 5 counts), and thus command will be failed and
returned at the first failed attempt.

On the contrary, in fact, it should have been other way around that is,
as 2nd mirror being the last copy of the data, it should rather try
equally hard to make this read cmd successful and at the same time with
or without REQ_FAILFAST_DEV there is no performance benefits if the
command is successful in the first attempt itself.

The only benefit which would be achieved with REQ_FAILFAST_DEV is that
when both the copies encounter failed read, then for the applications,
the EIO will be reported roughly 40% faster (since it saves 4 retries).
But when first mirror has failed whats more important will be to make
a successful read from the 2nd mirror.

And for the DUP case where both the copies are on the same disk, this
makes to retry 5 times on 2 different LBA/sector but on the same disk,
which probably is not a good idea if your test case involves pulling
out the disk. But as of now we don't have a way to tell the block layer
how critical a read is, so that block layer can accommodate the retry
dynamically.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/extent_io.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index d8eb457f2a70..29c03fb4d5af 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -2388,9 +2388,6 @@ static int bio_readpage_error(struct bio *failed_bio, u64 phy_offset,
 		return -EIO;
 	}
 
-	if (failed_bio->bi_vcnt > 1)
-		read_mode |= REQ_FAILFAST_DEV;
-
 	phy_offset >>= inode->i_sb->s_blocksize_bits;
 	bio = btrfs_create_repair_bio(inode, failed_bio, failrec, page,
 				      start - page_offset(page),
-- 
2.15.0

