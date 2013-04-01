Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:29881 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750880Ab3DAFJU (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 1 Apr 2013 01:09:20 -0400
Received: from acsinet21.oracle.com (acsinet21.oracle.com [141.146.126.237])
	by userp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with ESMTP id r3159IKT015117
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Mon, 1 Apr 2013 05:09:19 GMT
Received: from acsmt356.oracle.com (acsmt356.oracle.com [141.146.40.156])
	by acsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r3159I9O024021
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Mon, 1 Apr 2013 05:09:18 GMT
Received: from abhmt111.oracle.com (abhmt111.oracle.com [141.146.116.63])
	by acsmt356.oracle.com (8.12.11.20060308/8.12.11) with ESMTP id r3159H67027571
	for <linux-btrfs@vger.kernel.org>; Mon, 1 Apr 2013 00:09:17 -0500
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs-progs: delete unused function get_mountpt
Date: Mon,  1 Apr 2013 13:10:27 +0800
Message-Id: <1364793027-9665-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

and get_btrfs_mount has replaced it

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 utils.c | 35 -----------------------------------
 1 file changed, 35 deletions(-)

diff --git a/utils.c b/utils.c
index b9b675d..0a4a971 100644
--- a/utils.c
+++ b/utils.c
@@ -976,41 +976,6 @@ out_mntloop_err:
 	return ret;
 }
 
-/* Gets the mount point of btrfs filesystem that is using the specified device.
- * Returns 0 is everything is good, <0 if we have an error.
- * TODO: Fix this fucntion and check_mounted to work with multiple drive BTRFS
- * setups.
- */
-int get_mountpt(char *dev, char *mntpt, size_t size)
-{
-       struct mntent *mnt;
-       FILE *f;
-       int ret = 0;
-
-       f = setmntent("/proc/mounts", "r");
-       if (f == NULL)
-               return -errno;
-
-       while ((mnt = getmntent(f)) != NULL )
-       {
-               if (strcmp(dev, mnt->mnt_fsname) == 0)
-               {
-                       strncpy(mntpt, mnt->mnt_dir, size);
-                       if (size)
-                                mntpt[size-1] = 0;
-                       break;
-               }
-       }
-
-       if (mnt == NULL)
-       {
-               /* We didn't find an entry so lets report an error */
-               ret = -1;
-       }
-
-       return ret;
-}
-
 struct pending_dir {
 	struct list_head list;
 	char name[PATH_MAX];
-- 
1.8.1.227.g44fe835

