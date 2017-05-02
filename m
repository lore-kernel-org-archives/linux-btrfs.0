Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:48187 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750927AbdECAuL (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 2 May 2017 20:50:11 -0400
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v430o9hZ010234
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Wed, 3 May 2017 00:50:10 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id v430o9WN007365
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Wed, 3 May 2017 00:50:09 GMT
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id v430o9bg028369
        for <linux-btrfs@vger.kernel.org>; Wed, 3 May 2017 00:50:09 GMT
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: fix the mount failure due to missing devices
Date: Tue,  2 May 2017 17:48:40 -0600
Message-Id: <1493768920-29678-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Say there is a raid1 btrfs which consists of two disks, after one disk
becomes unavailable, we can still mount it in degraded mode once, for
the second mount it would refuse to mount it with an error

"BTRFS warning (device sdf): missing devices (1) exceeds the limit (0), writeable mount is not allowed"

The reason is that during the first mount (with the default mount
option), it creates a chunk of single profile so that another mount
will report the limit to tolerate missing or faulty devices as 0.

But we're mounting the filesystem from the device where the single
profile chunk lives, we can safely allow it to be mounted in the
degraded mode.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/disk-io.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index eb1ee7b..b65a265 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -3686,8 +3686,15 @@ int btrfs_calc_num_tolerated_disk_barrier_failures(
 						   &space);
 			if (space.total_bytes == 0 || space.used_bytes == 0)
 				continue;
-			flags = space.flags;
 
+			/*
+			 * skip single profile as we have opened this
+			 * device for single profile
+			 */
+			if ((space.flags & BTRFS_BLOCK_GROUP_PROFILE_MASK) == 0)
+				continue;
+
+			flags = space.flags;
 			num_tolerated_disk_barrier_failures = min(
 				num_tolerated_disk_barrier_failures,
 				btrfs_get_num_tolerated_disk_barrier_failures(
-- 
1.8.3.1

