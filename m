Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:39541 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752791AbdDEDn2 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 4 Apr 2017 23:43:28 -0400
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH v2] btrfs: check if the device is flush capable
Date: Wed,  5 Apr 2017 11:48:34 +0800
Message-Id: <20170405034834.20503-1-anand.jain@oracle.com>
In-Reply-To: <20170404104144.9414-1-anand.jain@oracle.com>
References: <20170404104144.9414-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The blkdev_issue_flush() will check if the write cache is enabled
before submitting the flush. This will add a code to fail fast if
its not.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
v1:
  This patch will replace
  [PATCH] btrfs: delete unused member nobarriers

v2:
  - This patch will now _not_ replace the below patch and this patch
  should be applied on top of it.
    [PATCH] btrfs: delete unused member nobarriers
  That's because, Q wc flag is not static, so we can't save its
  state into nobarries.
  - commit log is updated.

 fs/btrfs/disk-io.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index b6d047250ce2..bb5816c7f5c4 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -3517,6 +3517,11 @@ static void btrfs_dev_issue_flush(struct work_struct *work)
  */
 static int write_dev_flush(struct btrfs_device *device, int wait)
 {
+	struct request_queue *q = bdev_get_queue(device->bdev);
+
+	if (!test_bit(QUEUE_FLAG_WC, &q->queue_flags))
+		return 0;
+
 	if (wait) {
 		int ret;
 
-- 
2.10.0

