Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:18193 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751472AbaBXLoW (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 24 Feb 2014 06:44:22 -0500
Received: from ucsinet22.oracle.com (ucsinet22.oracle.com [156.151.31.94])
	by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id s1OBiML4027363
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Mon, 24 Feb 2014 11:44:22 GMT
Received: from aserz7021.oracle.com (aserz7021.oracle.com [141.146.126.230])
	by ucsinet22.oracle.com (8.14.5+Sun/8.14.5) with ESMTP id s1OBiLaw029129
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Mon, 24 Feb 2014 11:44:21 GMT
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
	by aserz7021.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id s1OBiLHg026185
	for <linux-btrfs@vger.kernel.org>; Mon, 24 Feb 2014 11:44:21 GMT
From: Anand Jain <Anand.Jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 1/3 v3] btrfs-progs: there is devid 0 when replace is running
Date: Mon, 24 Feb 2014 19:43:37 +0800
Message-Id: <1393242219-18525-1-git-send-email-Anand.Jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Anand Jain <anand.jain@oracle.com>

as of now, when we replace a disk, it is added to the
dev list with devid 0. And we fail to obtain details
of devid 0 because we don't query devid 0 at all.

reproducer:

 btrfs rep start /dev/sdb /dev/sdf /btrfs
 btrfs fi show
 Label: none  uuid: f8fb9819-16c8-47b7-b62f-0ff90f8c56cd
        Total devices 3 FS bytes used 1.94GiB
        devid    1 size 1.10GiB used 1.10GiB path /dev/sdb
        devid    2 size 1.10GiB used 1.08GiB path /dev/sdc
        devid    0 size 0.00 used 0.00 path

  this patch will make it proper by querying devid 0.

 btrfs repl start /dev/sdb /dev/sdf /btrfs
 btrfs fi show /btrfs
 Label: none  uuid: f8fb9819-16c8-47b7-b62f-0ff90f8c56cd
        Total devices 3 FS bytes used 1.94GiB
        devid    0 size 1.10GiB used 1.10GiB path /dev/sdf
        devid    1 size 1.10GiB used 1.10GiB path /dev/sdb
        devid    2 size 1.10GiB used 1.08GiB path /dev/sdc

 Its fine to query devid 0 when there is no replace
 activity as well, because we just skip the error ENODEV

 btrfs fi show /btrfs
 Label: none  uuid: f8fb9819-16c8-47b7-b62f-0ff90f8c56cd
        Total devices 2 FS bytes used 1.94GiB
        devid    1 size 1.10GiB used 1.10GiB path /dev/sdf
        devid    2 size 1.10GiB used 1.08GiB path /dev/sdc

Signed-off-by: Anand Jain <Anand.Jain@oracle.com>
---
 v3: it needs to handle per devid probe
 v2: commit message fix

 utils.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/utils.c b/utils.c
index de513b6..e0c750d 100644
--- a/utils.c
+++ b/utils.c
@@ -1637,7 +1637,7 @@ int get_fs_info(char *path, struct btrfs_ioctl_fs_info_args *fi_args,
 	int fd = -1;
 	int ret = 0;
 	int ndevs = 0;
-	int i = 1;
+	int i = 0;
 	struct btrfs_fs_devices *fs_devices_mnt = NULL;
 	struct btrfs_ioctl_dev_info_args *di_args;
 	char mp[BTRFS_PATH_NAME_MAX + 1];
-- 
1.8.4.2

