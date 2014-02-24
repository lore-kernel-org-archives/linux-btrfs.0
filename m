Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:18215 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752091AbaBXLo0 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 24 Feb 2014 06:44:26 -0500
Received: from acsinet22.oracle.com (acsinet22.oracle.com [141.146.126.238])
	by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id s1OBiOSJ027405
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Mon, 24 Feb 2014 11:44:25 GMT
Received: from userz7022.oracle.com (userz7022.oracle.com [156.151.31.86])
	by acsinet22.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id s1OBiOhM014813
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Mon, 24 Feb 2014 11:44:24 GMT
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
	by userz7022.oracle.com (8.14.5+Sun/8.14.4) with ESMTP id s1OBiNxL029204
	for <linux-btrfs@vger.kernel.org>; Mon, 24 Feb 2014 11:44:23 GMT
From: Anand Jain <Anand.Jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 3/3] btrfs-progs: Fix bug when scanned for devid which was missing and deleted
Date: Mon, 24 Feb 2014 19:43:39 +0800
Message-Id: <1393242219-18525-3-git-send-email-Anand.Jain@oracle.com>
In-Reply-To: <1393242219-18525-1-git-send-email-Anand.Jain@oracle.com>
References: <1393242219-18525-1-git-send-email-Anand.Jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

get_fs_info() provides the info of the specific
device/devid, however when we delete the missing disk
the super-block on the disk isn't cleared, and since
btrfs-progs makes its decision by reading the disk super
block, so it doesn't know about the kernel previous action,
And now when we tried to probe kernel for the devid it fails.

reproducer:

$ mkfs.btrfs -d raid1 -m raid1 /dev/sde /dev/sdf
$ modprobe -r btrfs && modprobe btrfs
$ mount -o degraded /dev/sde /btrfs
$ btrfs dev add /dev/sdd /btrfs
$ btrfs dev del missing /btrfs
$ btrfs scrub start -B /dev/sdf
btrfs: utils.c:1741: get_fs_info: Assertion `!(ndevs == 0)' failed.
Aborted (core dumped)

Signed-off-by: Anand Jain <Anand.Jain@oracle.com>
---
 utils.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/utils.c b/utils.c
index 231031e..bce92ab 100644
--- a/utils.c
+++ b/utils.c
@@ -1726,8 +1726,15 @@ int get_fs_info(char *path, struct btrfs_ioctl_fs_info_args *fi_args,
 		ndevs++;
 	}
 
-	BUG_ON(ndevs == 0);
-	ret = 0;
+	/*
+	* only when the only dev we wanted to find is not there then
+	* let any error be returned
+	*/
+	if (fi_args->num_devices != 1) {
+		BUG_ON(ndevs == 0);
+		ret = 0;
+	}
+
 out:
 	close_file_or_dir(fd, dirstream);
 	return ret;
-- 
1.8.4.2

