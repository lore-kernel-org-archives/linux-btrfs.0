Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:24795 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755292Ab3AFDxr (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 5 Jan 2013 22:53:47 -0500
Received: from acsinet22.oracle.com (acsinet22.oracle.com [141.146.126.238])
	by userp1040.oracle.com (Sentrion-MTA-4.2.2/Sentrion-MTA-4.2.2) with ESMTP id r063rkqb005803
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Sun, 6 Jan 2013 03:53:47 GMT
Received: from acsmt357.oracle.com (acsmt357.oracle.com [141.146.40.157])
	by acsinet22.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r063rjgI025456
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Sun, 6 Jan 2013 03:53:46 GMT
Received: from abhmt107.oracle.com (abhmt107.oracle.com [141.146.116.59])
	by acsmt357.oracle.com (8.12.11.20060308/8.12.11) with ESMTP id r063rjIJ032239
	for <linux-btrfs@vger.kernel.org>; Sat, 5 Jan 2013 21:53:45 -0600
Message-ID: <50E8F545.5030706@oracle.com>
Date: Sun, 06 Jan 2013 11:53:41 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: replace simple_strtoull() with kstrtoull() in btrfs_ioctl_resize()
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

simple_strtoull() is obsolete, use kstrtoull() instead.

Signed-off-by: Jie Liu <jeff.liu@oracle.com>
---
 fs/btrfs/ioctl.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 8fcf9a5..b147424 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -1331,11 +1331,16 @@ static noinline int btrfs_ioctl_resize(struct btrfs_root *root,
 	sizestr = vol_args->name;
 	devstr = strchr(sizestr, ':');
 	if (devstr) {
-		char *end;
 		sizestr = devstr + 1;
 		*devstr = '\0';
 		devstr = vol_args->name;
-		devid = simple_strtoull(devstr, &end, 10);
+		ret = kstrtoull(devstr, 10, &devid);
+		if (ret) {
+			pr_err("btrfs: resizer unable to parse device %s\n",
+				devstr);
+			ret = -EINVAL;
+			goto out_free;
+		}
 		printk(KERN_INFO "btrfs: resizing devid %llu\n",
 		       (unsigned long long)devid);
 	}
-- 
1.7.9.5
