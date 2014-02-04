Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:22662 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755067AbaBDENg (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 3 Feb 2014 23:13:36 -0500
Received: from acsinet21.oracle.com (acsinet21.oracle.com [141.146.126.237])
	by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id s144DZu6016734
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Tue, 4 Feb 2014 04:13:36 GMT
Received: from userz7021.oracle.com (userz7021.oracle.com [156.151.31.85])
	by acsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id s144DYrb013420
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <linux-btrfs@vger.kernel.org>; Tue, 4 Feb 2014 04:13:35 GMT
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
	by userz7021.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id s144DY1u014756
	for <linux-btrfs@vger.kernel.org>; Tue, 4 Feb 2014 04:13:34 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs-progs: there is devid 0 when replace is running
Date: Tue,  4 Feb 2014 12:23:30 +0800
Message-Id: <1391487810-21545-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

 as of now when the replace-er disk is add to dev list
 with its devid 0. We fail to obtain details of devid 0
 since we don't query devid 0 at all as below.

---
 btrfs rep start /dev/sdb /dev/sdf /btrfs

 btrfs fi show
 Label: none  uuid: f8fb9819-16c8-47b7-b62f-0ff90f8c56cd
        Total devices 3 FS bytes used 1.94GiB
        devid    1 size 1.10GiB used 1.10GiB path /dev/sdb
        devid    2 size 1.10GiB used 1.08GiB path /dev/sdc
        devid    0 size 0.00 used 0.00 path
---

  this patch will make it proper by querying dev id 0.
-----
btrfs repl start /dev/sdb /dev/sdf /btrfs
btrfs fi show /btrfs
Label: none  uuid: f8fb9819-16c8-47b7-b62f-0ff90f8c56cd
        Total devices 3 FS bytes used 1.94GiB
        devid    0 size 1.10GiB used 1.10GiB path /dev/sdf
        devid    1 size 1.10GiB used 1.10GiB path /dev/sdb
        devid    2 size 1.10GiB used 1.08GiB path /dev/sdc
-----

 Its fine to query dev id 0 when there is no replace
 activity well because we just skip the error ENODEV

----
btrfs fi show /btrfs
Label: none  uuid: f8fb9819-16c8-47b7-b62f-0ff90f8c56cd
        Total devices 2 FS bytes used 1.94GiB
        devid    1 size 1.10GiB used 1.10GiB path /dev/sdf
        devid    2 size 1.10GiB used 1.08GiB path /dev/sdc
----

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 utils.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/utils.c b/utils.c
index de513b6..a045ffd 100644
--- a/utils.c
+++ b/utils.c
@@ -1696,7 +1696,7 @@ int get_fs_info(char *path, struct btrfs_ioctl_fs_info_args *fi_args,
 		goto out;
 	}
 
-	for (; i <= fi_args->max_id; ++i) {
+	for (i = 0; i <= fi_args->max_id; ++i) {
 		BUG_ON(ndevs >= fi_args->num_devices);
 		ret = get_device_info(fd, i, &di_args[ndevs]);
 		if (ret == -ENODEV)
-- 
1.7.1

