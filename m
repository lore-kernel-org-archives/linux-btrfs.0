Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:50521 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752314Ab3DOGhl (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 15 Apr 2013 02:37:41 -0400
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: [PATCH 10/11, RESEND] btrfs-progs: avoid ioctl for multipath-dev with its non-multipath path
Date: Mon, 15 Apr 2013 14:38:16 +0800
Message-Id: <1366007897-26567-11-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1366007897-26567-1-git-send-email-anand.jain@oracle.com>
References: <1365141303-10571-1-git-send-email-anand.jain@oracle.com>
 <1366007897-26567-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We should avoid using non multi-path (mp) path for mp disks
As of now there is no good way (like api) to check that.
A workaround way is to check if the O_EXCL open is unsuccessful.
This is safe since otherwise the BTRFS_IOC_SCAN_DEV ioctl would
fail if the disk-path can not be opened with the flag O_EXCL set.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 utils.c | 30 +++++++++++++++++++++++++++++-
 1 file changed, 29 insertions(+), 1 deletion(-)

diff --git a/utils.c b/utils.c
index 926421c..158912c 100644
--- a/utils.c
+++ b/utils.c
@@ -1105,6 +1105,13 @@ again:
 		if (!S_ISBLK(st.st_mode)) {
 			continue;
 		}
+
+		/* Do not test for O_EXCL here since btrfs when
+		* mounted will open with O_EXCL, and if we don't
+		* allow btrfs_scan_one_device pass thru
+		* btrfs fi show will not show the btrfs fs which
+		* are mounted
+		*/
 		fd = open(fullpath, O_RDONLY);
 		if (fd < 0) {
 			/* ignore the following errors:
@@ -1122,10 +1129,18 @@ again:
 					    &num_devices,
 					    BTRFS_SUPER_INFO_OFFSET,
 					    0ull);
+		close(fd);
+
 		if (ret == 0 && flags & BTRFS_SCAN_REGISTER) {
+			/* Test if the dev is already opened with O_EXCL flag
+			*  if yes then no need to call ioctl since the
+			*  ioctl will anyway fail.
+			*/
+			fd = open(fullpath, O_RDONLY|O_EXCL);
+			if (fd < 0) continue;
+			close(fd);
 			btrfs_register_one_device(fullpath);
 		}
-		close(fd);
 	}
 	if (!list_empty(&pending_list)) {
 		free(pending);
@@ -1444,6 +1459,12 @@ scan_again:
 			continue;
 		}
 
+		/* Do not test for O_EXCL here since btrfs when
+		* mounted will open with O_EXCL, and if we don't
+		* allow btrfs_scan_one_device pass thru
+		* btrfs fi show will not show the btrfs fs which
+		* are mounted
+		*/
 		fd = open(fullpath, O_RDONLY);
 		if (fd < 0) {
 			fprintf(stderr, "failed to open %s: %s\n",
@@ -1455,6 +1476,13 @@ scan_again:
 					    BTRFS_SUPER_INFO_OFFSET,
 					    0ull);
 		if (ret == 0 && flags & BTRFS_SCAN_REGISTER) {
+			/* Test if the dev is already opened with O_EXCL flag
+			*  if yes then no need to call ioctl since the
+			*  ioctl will anyway fail.
+			*/
+			fd = open(fullpath, O_RDONLY|O_EXCL);
+			if (fd < 0) continue;
+			close(fd);
 			btrfs_register_one_device(fullpath);
 		}
 		close(fd);
-- 
1.8.1.227.g44fe835

