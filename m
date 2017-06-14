Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:51275 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751707AbdFNJ4a (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 14 Jun 2017 05:56:30 -0400
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH] btrfs: test for device flush-able should be after wait code
Date: Wed, 14 Jun 2017 18:02:38 +0800
Message-Id: <1497434558-715-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

write_dev_flush() checks if the device is flush capable, however as
the device mode can change any time, this check should be after the
wait part of the code.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
 Fixes: c2a9c7ab475b btrfs: check if the device is flush capable
---
 fs/btrfs/disk-io.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 9f2ffe2c6afb..603a7e32e708 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -3496,13 +3496,10 @@ static void btrfs_end_empty_barrier(struct bio *bio)
  */
 static int write_dev_flush(struct btrfs_device *device, int wait)
 {
-	struct request_queue *q = bdev_get_queue(device->bdev);
+	struct request_queue *devq;
 	struct bio *bio;
 	int ret = 0;
 
-	if (!test_bit(QUEUE_FLAG_WC, &q->queue_flags))
-		return 0;
-
 	if (wait) {
 		bio = device->flush_bio;
 		if (!bio)
@@ -3527,6 +3524,10 @@ static int write_dev_flush(struct btrfs_device *device, int wait)
 		return ret;
 	}
 
+	devq = bdev_get_queue(device->bdev);
+	if (!test_bit(QUEUE_FLAG_WC, &devq->queue_flags))
+		return 0;
+
 	/*
 	 * one reference for us, and we leave it for the
 	 * caller
-- 
2.7.0

