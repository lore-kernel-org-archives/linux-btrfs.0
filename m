Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:23607 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752524AbdFMI7b (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 13 Jun 2017 04:59:31 -0400
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH 2/3 v2] btrfs: remove redundant null bdev counting during flush submit
Date: Tue, 13 Jun 2017 17:05:40 +0800
Message-Id: <1497344741-1135-2-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1497344741-1135-1-git-send-email-anand.jain@oracle.com>
References: <1497344741-1135-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

There is no extra benefit to count null bdev during submit loop,
as these null devices will be anyway checked during command
completion device loop just after the submit loop, and as we are
holding the device_list_mutex, the device->bdev status won't
change in between.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
v2: . The tile of this patch is changed from 
      [PATCH 2/2] btrfs: flush error also accounts for its send error
      also added commit log.
    . The submit_flush_error is removed in patch 1/3 but it was here
      before.
    . Dropped the comments.

 fs/btrfs/disk-io.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 9fbcfa9ccab7..a9f1c48519dd 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -3565,7 +3565,6 @@ static int barrier_all_devices(struct btrfs_fs_info *info)
 {
 	struct list_head *head;
 	struct btrfs_device *dev;
-	int errors_send = 0;
 	int errors_wait = 0;
 	int ret;
 
@@ -3574,10 +3573,8 @@ static int barrier_all_devices(struct btrfs_fs_info *info)
 	list_for_each_entry_rcu(dev, head, dev_list) {
 		if (dev->missing)
 			continue;
-		if (!dev->bdev) {
-			errors_send++;
+		if (!dev->bdev)
 			continue;
-		}
 		if (!dev->in_fs_metadata || !dev->writeable)
 			continue;
 
@@ -3603,7 +3600,7 @@ static int barrier_all_devices(struct btrfs_fs_info *info)
 		}
 	}
 
-	if (errors_send || errors_wait) {
+	if (errors_wait) {
 		/*
 		 * At some point we need the status of all disks
 		 * to arrive at the volume status. So error checking
-- 
2.7.0

