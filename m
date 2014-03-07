Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:34638 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751935AbaCGPs7 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 7 Mar 2014 10:48:59 -0500
Received: from acsinet22.oracle.com (acsinet22.oracle.com [141.146.126.238])
	by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id s27Fmvwk016020
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Fri, 7 Mar 2014 15:48:58 GMT
Received: from aserz7021.oracle.com (aserz7021.oracle.com [141.146.126.230])
	by acsinet22.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id s27FmvaI010338
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Fri, 7 Mar 2014 15:48:57 GMT
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
	by aserz7021.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id s27FmvXY005865
	for <linux-btrfs@vger.kernel.org>; Fri, 7 Mar 2014 15:48:57 GMT
From: Anand Jain <Anand.Jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 1/3 v2 RFC] btrfs: total_devices vs num_devices
Date: Fri,  7 Mar 2014 23:48:37 +0800
Message-Id: <1394207319-13252-1-git-send-email-Anand.Jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The intended usage of total_devices and num_devices
should be recorded in the comments so that these
two counters can be used correctly as originally
intended.

As of now there appears to be slight deviations/bugs
from the original intention, the bugs are apparent
that num_devices does not count seed devices where
as total_devices does, but total_devices does not
count the replacing devices where as num_devices does.

So in this situation the ioctl(BTRFS_IOC_DEVICES_READY)
will fails when there is seed FS. Next, applications
using ioctl(BTRFS_IOC_FS_INFO) and ioctl(BTRFS_IOC_DEV_INFO)
in conjunction to allocate the slots will also fail
as former depend on the num_devices where as latter
would match total_devices (except when replace is running).

This patch will help have the clarity on usage
of these two counter so that bugs related to this can
be fixed.

Signed-off-by: Anand Jain <Anand.Jain@oracle.com>
---
v2: edit commit

 fs/btrfs/volumes.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index 91b7596..99c71aa 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -121,12 +121,18 @@ struct btrfs_fs_devices {
 	/* the device with this id has the most recent copy of the super */
 	u64 latest_devid;
 	u64 latest_trans;
+	/* num_devices contains run time count of devices which are part
+	 * of this FSID. (the FS devices + replacing devices + ?
+	 */
 	u64 num_devices;
 	u64 open_devices;
 	u64 rw_devices;
 	u64 missing_devices;
 	u64 total_rw_bytes;
 	u64 num_can_discard;
+	/* total_devices contains static recorded count of device which
+	 * are part of this FSID. (the FS devices + seed devices + ?
+	 */
 	u64 total_devices;
 	struct block_device *latest_bdev;
 
-- 
1.8.5.3

