Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:40621 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753230AbdJNAeV (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 13 Oct 2017 20:34:21 -0400
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v9E0YK5i029885
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Sat, 14 Oct 2017 00:34:20 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id v9E0YJYk019188
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Sat, 14 Oct 2017 00:34:20 GMT
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id v9E0YJxt021927
        for <linux-btrfs@vger.kernel.org>; Sat, 14 Oct 2017 00:34:19 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2] btrfs: fix false EIO for missing device
Date: Sat, 14 Oct 2017 08:34:02 +0800
Message-Id: <20171014003402.7230-1-anand.jain@oracle.com>
In-Reply-To: <20171013134218.19048-1-anand.jain@oracle.com>
References: <20171013134218.19048-1-anand.jain@oracle.com>
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
Reviewed-by: Liu Bo <bo.li.liu@oracle.com>
---
v2: Use BLK_STS_OK instead of 0.

 fs/btrfs/volumes.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 41c02a3ffc78..15e017af756c 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -6131,7 +6131,10 @@ static void bbio_error(struct btrfs_bio *bbio, struct bio *bio, u64 logical)
 
 		btrfs_io_bio(bio)->mirror_num = bbio->mirror_num;
 		bio->bi_iter.bi_sector = logical >> 9;
-		bio->bi_status = BLK_STS_IOERR;
+		if (atomic_read(&bbio->error) > bbio->max_errors)
+			bio->bi_status = BLK_STS_IOERR;
+		else
+			bio->bi_status = BLK_STS_OK;
 		btrfs_end_bbio(bbio, bio);
 	}
 }
-- 
2.13.1

