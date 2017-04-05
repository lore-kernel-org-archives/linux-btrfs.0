Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:40194 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753145AbdDEDqF (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 4 Apr 2017 23:46:05 -0400
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH v2] btrfs: delete unused member nobarriers
Date: Wed,  5 Apr 2017 11:51:12 +0800
Message-Id: <20170405035112.20816-1-anand.jain@oracle.com>
In-Reply-To: <20170331112608.32478-1-anand.jain@oracle.com>
References: <20170331112608.32478-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The last consumer of nobarriers is removed by the commit [1] and sync
won't fail with EOPNOTSUPP anymore. Thus, now even when write cache is
write through it just return success without actually transpiring such
a request to the block device/lun.

[1]
commit b25de9d6da49b1a8760a89672283128aa8c78345
block: remove BIO_EOPNOTSUPP

And, as the device/lun write cache state may change dynamically saving
such as state won't help either. So deleting the member nobarriers.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 v2: We need this patch. Update the commit log.

 fs/btrfs/disk-io.c | 3 ---
 fs/btrfs/volumes.h | 1 -
 2 files changed, 4 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 3c476b118440..b6d047250ce2 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -3517,9 +3517,6 @@ static void btrfs_dev_issue_flush(struct work_struct *work)
  */
 static int write_dev_flush(struct btrfs_device *device, int wait)
 {
-	if (device->nobarriers)
-		return 0;
-
 	if (wait) {
 		int ret;
 
diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index 0df50bc65578..1168b78c5f1d 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -123,7 +123,6 @@ struct btrfs_device {
 	struct list_head resized_list;
 
 	/* for sending down flush barriers */
-	int nobarriers;
 	struct completion flush_wait;
 	struct work_struct flush_work;
 	int last_flush_error;
-- 
2.10.0

