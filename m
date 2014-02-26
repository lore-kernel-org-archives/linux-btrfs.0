Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:48913 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750858AbaBZHW6 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 26 Feb 2014 02:22:58 -0500
Received: from acsinet21.oracle.com (acsinet21.oracle.com [141.146.126.237])
	by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id s1Q7Muv6007806
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Wed, 26 Feb 2014 07:22:57 GMT
Received: from aserz7022.oracle.com (aserz7022.oracle.com [141.146.126.231])
	by acsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id s1Q7MsuS002093
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Wed, 26 Feb 2014 07:22:56 GMT
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
	by aserz7022.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id s1Q7MsY1018227
	for <linux-btrfs@vger.kernel.org>; Wed, 26 Feb 2014 07:22:54 GMT
From: Anand Jain <Anand.Jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH RFC] btrfs: total_devices vs num_devices
Date: Wed, 26 Feb 2014 15:22:45 +0800
Message-Id: <1393399365-8393-1-git-send-email-Anand.Jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The intended usage of total_devices and num_devices
should be recorded in the comments so that these
two counters can be used correctly to match the
original intentions.

And there appears to be bugs due to missing clarity,
the bugs are mainly in the fact that in the current
code the num_devices does not count seed devices where
as total_devices does, next, total_devices does not count
the replacing devices where as num_devices does.

In this situation the ioctl(BTRFS_IOC_DEVICES_READY)
will fails when there is seed FS.
The applications using ioctl(BTRFS_IOC_FS_INFO) and
ioctl(BTRFS_IOC_DEV_INFO) in conjuction to allocate
the slots will also be confused as farmer depend on
the num_devices where as later would match total_devices
(except when replace is running).

This patch will help have the clarity on usage
of these two counter so that bugs related to this can
be fixed.

Signed-off-by: Anand Jain <Anand.Jain@oracle.com>
---
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

