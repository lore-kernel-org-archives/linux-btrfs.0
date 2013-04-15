Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:44396 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752213Ab3DOGhh (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 15 Apr 2013 02:37:37 -0400
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: [PATCH 07/11, RESEND] btrfs-progs: delete unused function get_mountpt
Date: Mon, 15 Apr 2013 14:38:13 +0800
Message-Id: <1366007897-26567-8-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1366007897-26567-1-git-send-email-anand.jain@oracle.com>
References: <1365141303-10571-1-git-send-email-anand.jain@oracle.com>
 <1366007897-26567-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

and get_btrfs_mount has replaced it

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 utils.c | 35 -----------------------------------
 1 file changed, 35 deletions(-)

diff --git a/utils.c b/utils.c
index 67419da..926421c 100644
--- a/utils.c
+++ b/utils.c
@@ -977,41 +977,6 @@ out_mntloop_err:
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

