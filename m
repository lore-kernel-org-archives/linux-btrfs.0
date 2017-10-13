Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:36512 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753394AbdJMNmq (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 13 Oct 2017 09:42:46 -0400
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v9DDgiZs016855
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Fri, 13 Oct 2017 13:42:45 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id v9DDgiTf014095
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Fri, 13 Oct 2017 13:42:44 GMT
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id v9DDgiJj032636
        for <linux-btrfs@vger.kernel.org>; Fri, 13 Oct 2017 13:42:44 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs: fix false EIO for missing device
Date: Fri, 13 Oct 2017 21:42:18 +0800
Message-Id: <20171013134218.19048-1-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When one of the device is missing, bbio_error() takes care
of setting the error status. And if its only IO that is
pending in that stripe, it fails to check the status of the
other IO at %bbio_error before setting the error %bi_status
for the %orig_bio. Fix this by checking if %bbio->error is
has crossed the %bbio->max_errors. Thxs.

Reproducer as below fdatasync error is seen intermittently.

 mount -o degraded /dev/sdc /btrfs
 dd status=none if=/dev/zero of=$(mktemp /btrfs/XXX) bs=4096 count=1 conv=fdatasync

 dd: fdatasync failed for ‘/btrfs/LSe’: Input/output error

 The reason for the intermittences of the problem is because..
 following condition has to be met, which depends on timely
 coordination.
 In btrfs_map_bio()
  . The RAID1 the missing device has to be at %dev_nr = 1
 In bbio_error()
  . Before bbio_error() is called the bio of the not-missing
    device at %dev_nr=0 must be completed so that the below
    condition is true
     if (atomic_dec_and_test(&bbio->stripes_pending)) {

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/volumes.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 9af633dcf015..efd502176915 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -6131,7 +6131,10 @@ static void bbio_error(struct btrfs_bio *bbio, struct bio *bio, u64 logical)
 
 		btrfs_io_bio(bio)->mirror_num = bbio->mirror_num;
 		bio->bi_iter.bi_sector = logical >> 9;
-		bio->bi_status = BLK_STS_IOERR;
+		if (atomic_read(&bbio->error) > bbio->max_errors)
+			bio->bi_status = BLK_STS_IOERR;
+		else
+			bio->bi_status = 0;
 		btrfs_end_bbio(bbio, bio);
 	}
 }
-- 
2.13.1

