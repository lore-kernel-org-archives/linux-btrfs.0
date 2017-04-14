Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:27591 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750764AbdDNBNM (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 13 Apr 2017 21:13:12 -0400
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v3E1DAtv019482
        (version=TLSv1 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Fri, 14 Apr 2017 01:13:11 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserv0021.oracle.com (8.13.8/8.14.4) with ESMTP id v3E1DA0h014889
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Fri, 14 Apr 2017 01:13:10 GMT
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id v3E1DAuQ008984
        for <linux-btrfs@vger.kernel.org>; Fri, 14 Apr 2017 01:13:10 GMT
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: tolerate errors if we have retried successfully
Date: Thu, 13 Apr 2017 18:11:56 -0700
Message-Id: <1492132316-3076-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

With raid1 profile, dio read isn't tolerating IO errors if read length is
less than the stripe length (64K).

This fixes the problem by setting bio's error to 0 if a good copy has been
found.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/inode.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 632b616..4e1398e 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -8113,8 +8113,11 @@ static void btrfs_endio_direct_read(struct bio *bio)
 	struct btrfs_io_bio *io_bio = btrfs_io_bio(bio);
 	int err = bio->bi_error;
 
-	if (dip->flags & BTRFS_DIO_ORIG_BIO_SUBMITTED)
+	if (dip->flags & BTRFS_DIO_ORIG_BIO_SUBMITTED) {
 		err = btrfs_subio_endio_read(inode, io_bio, err);
+		if (!err)
+			bio->bi_error = 0;
+	}
 
 	unlock_extent(&BTRFS_I(inode)->io_tree, dip->logical_offset,
 		      dip->logical_offset + dip->bytes - 1);
-- 
2.5.5

