Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:45851 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753447AbbBLEc6 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 11 Feb 2015 23:32:58 -0500
Received: from acsinet22.oracle.com (acsinet22.oracle.com [141.146.126.238])
	by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id t1C4Wv21031912
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Thu, 12 Feb 2015 04:32:58 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
	by acsinet22.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id t1C4WuLg010642
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Thu, 12 Feb 2015 04:32:57 GMT
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
	by aserv0122.oracle.com (8.13.8/8.13.8) with ESMTP id t1C4WuvK005770
	for <linux-btrfs@vger.kernel.org>; Thu, 12 Feb 2015 04:32:56 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 3/3] Btsfs: procfs-devlist: update the sysfs contents
Date: Thu, 12 Feb 2015 04:32:31 +0800
Message-Id: <1423686751-5053-4-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1423686751-5053-1-git-send-email-anand.jain@oracle.com>
References: <1423686751-5053-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/procfs.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/fs/btrfs/procfs.c b/fs/btrfs/procfs.c
index 4aec759..0211aec 100644
--- a/fs/btrfs/procfs.c
+++ b/fs/btrfs/procfs.c
@@ -62,6 +62,17 @@ again_fs_devs:
 		BTRFS_SEQ_PRINT("\tseeding:\t\t%d\n", fs_devices->seeding);
 		BTRFS_SEQ_PRINT("\trotating:\t\t%d\n", fs_devices->rotating);
 
+		BTRFS_SEQ_PRINT("\tsuper_kobj_state:\t%d\n", fs_devices->super_kobj.state_initialized);
+		BTRFS_SEQ_PRINT("\tsuper_kobj_insysfs:\t%d\n", fs_devices->super_kobj.state_in_sysfs);
+
+		if (fs_devices->device_dir_kobj) {
+		BTRFS_SEQ_PRINT("\tdevice_kobj_state:\t%d\n", fs_devices->device_dir_kobj->state_initialized);
+		BTRFS_SEQ_PRINT("\tdevice_kobj_insysfs:\t%d\n", fs_devices->device_dir_kobj->state_in_sysfs);
+		} else {
+		BTRFS_SEQ_PRINT("\tdevice_kobj_state:\t%s\n", "null");
+		BTRFS_SEQ_PRINT("\tdevice_kobj_insysfs:\t%s\n", "null");
+		}
+
 		list_for_each_entry(device, &fs_devices->devices, dev_list) {
 			BTRFS_SEQ_PRINT("\t[[uuid: %pU]]\n", device->uuid);
 			BTRFS_SEQ_PRINT("\t\tdev_addr:\t%p\n", device);
-- 
2.0.0.153.g79dcccc

