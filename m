Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:55688 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752970AbdLDEyi (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sun, 3 Dec 2017 23:54:38 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.21/8.16.0.21) with SMTP id vB44qHl5163754
        for <linux-btrfs@vger.kernel.org>; Mon, 4 Dec 2017 04:54:37 GMT
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by userp2120.oracle.com with ESMTP id 2ekpeu9yyj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-btrfs@vger.kernel.org>; Mon, 04 Dec 2017 04:54:37 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id vB44saQk013077
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Mon, 4 Dec 2017 04:54:36 GMT
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id vB44saSv022126
        for <linux-btrfs@vger.kernel.org>; Mon, 4 Dec 2017 04:54:36 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2 5/5] btrfs: cleanup device states define BTRFS_DEV_STATE_FLUSH_SENT
Date: Mon,  4 Dec 2017 12:54:56 +0800
Message-Id: <20171204045456.8602-6-anand.jain@oracle.com>
In-Reply-To: <20171204045456.8602-1-anand.jain@oracle.com>
References: <20171204045456.8602-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Currently device state is being managed by each individual int
variable such as struct btrfs_device::is_tgtdev_for_dev_replace.
Instead of that declare btrfs_device::dev_state
BTRFS_DEV_STATE_FLUSH_SENT and use the bit operations.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/disk-io.c | 6 +++---
 fs/btrfs/volumes.h | 1 +
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 890e3a6a2f3e..9b20c1f3563b 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -3359,7 +3359,7 @@ static void write_dev_flush(struct btrfs_device *device)
 	bio->bi_private = &device->flush_wait;
 
 	btrfsic_submit_bio(bio);
-	device->flush_bio_sent = 1;
+	set_bit(BTRFS_DEV_STATE_FLUSH_SENT, &device->dev_state);
 }
 
 /*
@@ -3369,10 +3369,10 @@ static blk_status_t wait_dev_flush(struct btrfs_device *device)
 {
 	struct bio *bio = device->flush_bio;
 
-	if (!device->flush_bio_sent)
+	if (!test_bit(BTRFS_DEV_STATE_FLUSH_SENT, &device->dev_state))
 		return BLK_STS_OK;
 
-	device->flush_bio_sent = 0;
+	clear_bit(BTRFS_DEV_STATE_FLUSH_SENT, &device->dev_state);
 	wait_for_completion_io(&device->flush_wait);
 
 	return bio->bi_status;
diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index 4096350c2cea..7acfd61611aa 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -51,6 +51,7 @@ struct btrfs_pending_bios {
 #define BTRFS_DEV_STATE_IN_FS_METADATA	(1UL << 1)
 #define BTRFS_DEV_STATE_MISSING		(1UL << 2)
 #define BTRFS_DEV_STATE_REPLACE_TGT	(1UL << 3)
+#define BTRFS_DEV_STATE_FLUSH_SENT	(1UL << 4)
 
 struct btrfs_device {
 	struct list_head dev_list;
-- 
2.15.0

