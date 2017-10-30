Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:51550 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932784AbdJ3SRG (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 30 Oct 2017 14:17:06 -0400
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v9UIH6af015000
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Mon, 30 Oct 2017 18:17:06 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id v9UIH5jL012890
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Mon, 30 Oct 2017 18:17:05 GMT
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id v9UIH5V1006151
        for <linux-btrfs@vger.kernel.org>; Mon, 30 Oct 2017 18:17:05 GMT
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: kill threshold for submit_workers
Date: Mon, 30 Oct 2017 11:14:39 -0600
Message-Id: <20171030171440.27044-2-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

"submit_workers" is a workqueue that serves to collect and dispatch IOs
on each device in btrfs, thus the work that is queued on it is
per-device, which means at most there're as many works as the number
of devices owned by a btrfs.

Now we've set threshhold (=64) for "submit_workers" and the
'max_active' work of this workqueue is set to 1 and will be updated
accrodingly.

However, as the threshold (64) is the highest one and the 'max_active'
gets updated only when there're more works than its threshold at the
same time, the end result is that it's almostly unlikely to update
'max_active' because you'll need >64 devices to have a chance to do
that.

Given the above fact, in most cases, works on each device which
process IOs is run in order by only one kthread of 'submit_workers'.

It's OK for DUP and raid0 since at the same time IOs are always
submitted to one device, while for raid1 and raid10, where our primary
bio only completes when all cloned bios submitted by each raid1/10's
device complete[1], it's suboptimal.

This changes the threshold to 1 so that __btrfs_alloc_workqueue() can
use NO_THRESHOLD for 'submit_workers' and the 'max_active' will be
min(num_devices, thread_pool_size).

[1]: raid1 example,
    primary bio
         /\
     bio1  bio2
      |     |
     dev1  dev2
      |     |
    endio1 endio2
         \/
	endio

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/disk-io.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index dfdab84..373d3f6f 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -2368,15 +2368,10 @@ static int btrfs_init_workqueues(struct btrfs_fs_info *fs_info,
 	fs_info->caching_workers =
 		btrfs_alloc_workqueue(fs_info, "cache", flags, max_active, 0);
 
-	/*
-	 * a higher idle thresh on the submit workers makes it much more
-	 * likely that bios will be send down in a sane order to the
-	 * devices
-	 */
 	fs_info->submit_workers =
 		btrfs_alloc_workqueue(fs_info, "submit", flags,
 				      min_t(u64, fs_devices->num_devices,
-					    max_active), 64);
+					    max_active), 1);
 
 	fs_info->fixup_workers =
 		btrfs_alloc_workqueue(fs_info, "fixup", flags, 1, 0);
-- 
2.9.4

