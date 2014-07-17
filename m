Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:34743 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754507AbaGQJHc (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 17 Jul 2014 05:07:32 -0400
Received: from acsinet22.oracle.com (acsinet22.oracle.com [141.146.126.238])
	by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id s6H97UZ2025203
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Thu, 17 Jul 2014 09:07:31 GMT
Received: from userz7021.oracle.com (userz7021.oracle.com [156.151.31.85])
	by acsinet22.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id s6H97Tl8003166
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <linux-btrfs@vger.kernel.org>; Thu, 17 Jul 2014 09:07:30 GMT
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
	by userz7021.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id s6H97TwN009758
	for <linux-btrfs@vger.kernel.org>; Thu, 17 Jul 2014 09:07:29 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs-porgs: fix xfstest btrfs/023 random failure
Date: Thu, 17 Jul 2014 17:28:24 +0800
Message-Id: <1405589304-7174-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

xfstest btrfs/023 which does the following tests

create_group_profile "raid0"
check_group_profile "RAID0"

create_group_profile "raid1"
check_group_profile "RAID1"

create_group_profile "raid10"
check_group_profile "RAID10"

create_group_profile "raid5"
check_group_profile "RAID5"

create_group_profile "raid6"
check_group_profile "RAID6"

fails randomly with the error as below

 ERROR: device scan failed '/dev/sde' - Invalid argument

since failure is at random group profile it indicates to me that
btrfs kernel did not see the newly created btrfs on the device

To note: I have the following patch on the kernel which
is not yet integrated, but its not related to this bug.

btrfs: RFC: code optimize use btrfs_get_bdev_and_sb() at btrfs_scan_one_device
btrfs: looping 'mkfs.btrfs -f <dev>' may fail with EBUSY
btrfs: check generation as replace duplicates devid+uuid

This patch calls fsync() at btrfs_prepare_device().

With this btrfs/023 has NOT failed consistently for several long
iterations.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 utils.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/utils.c b/utils.c
index fbc5bde..e144dfd 100644
--- a/utils.c
+++ b/utils.c
@@ -741,6 +741,8 @@ int btrfs_prepare_device(int fd, char *file, int zero_end, u64 *block_count_ret,
 	}
 	*block_count_ret = block_count;
 
+	fsync(fd);
+
 zero_dev_error:
 	if (ret < 0) {
 		fprintf(stderr, "ERROR: failed to zero device '%s' - %s\n",
-- 
2.0.0.153.g79dcccc

