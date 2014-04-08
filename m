Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:17365 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750789AbaDHJPA (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 8 Apr 2014 05:15:00 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Anand Jain <anand.jain@oracle.com>
Subject: [PATCH] btrfs-progs: Fix the return value of btrfs_scan_kernel()
Date: Tue, 8 Apr 2014 17:16:02 +0800
Message-ID: <1396948562-16653-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

btrfs_scan_kernel() is only used in 'btrfs fi show' but returns wrong
return value.
When search parameter is passed, it will never return 0 even the search
can be matched.

This patch will change the whatever strange logic to a more easy to
understand one using 'found' var.

Reported-by: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: Anand Jain <anand.jain@oracle.com>
---
 cmds-filesystem.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/cmds-filesystem.c b/cmds-filesystem.c
index b81768b..49d3aa7 100644
--- a/cmds-filesystem.c
+++ b/cmds-filesystem.c
@@ -430,6 +430,7 @@ static int btrfs_scan_kernel_v2(void *search)
 static int btrfs_scan_kernel(void *search)
 {
 	int ret = 0, fd;
+	int found = 0;
 	FILE *f;
 	struct mntent *mnt;
 	struct btrfs_ioctl_fs_info_args fs_info_arg;
@@ -452,7 +453,6 @@ static int btrfs_scan_kernel(void *search)
 
 		if (get_label_mounted(mnt->mnt_dir, label)) {
 			kfree(dev_info_arg);
-			ret = 1;
 			goto out;
 		}
 		if (search && !match_search_item_kernel(fs_info_arg.fsid,
@@ -467,19 +467,16 @@ static int btrfs_scan_kernel(void *search)
 					space_info_arg, label, mnt->mnt_dir);
 			kfree(space_info_arg);
 			memset(label, 0, sizeof(label));
+			found = 1;
 		}
 		if (fd != -1)
 			close(fd);
 		kfree(dev_info_arg);
-		if (search)
-			ret = 0;
 	}
-	if (search)
-		ret = 1;
 
 out:
 	endmntent(f);
-	return ret;
+	return !found;
 }
 
 static int dev_to_fsid(char *dev, __u8 *fsid)
-- 
1.9.1

