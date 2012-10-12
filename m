Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([93.93.135.160]:37206 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932996Ab2JLN4c (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 12 Oct 2012 09:56:32 -0400
From: nirbheek.chauhan@collabora.co.uk
To: linux-btrfs@vger.kernel.org
Cc: Nirbheek Chauhan <nirbheek.chauhan@collabora.co.uk>
Subject: [PATCH] Btrfs-progs: fix resolving of loop devices
Date: Fri, 12 Oct 2012 19:25:34 +0530
Message-Id: <1350050134-12151-2-git-send-email-nirbheek.chauhan@collabora.co.uk>
In-Reply-To: <1350050134-12151-1-git-send-email-nirbheek.chauhan@collabora.co.uk>
References: <1350050134-12151-1-git-send-email-nirbheek.chauhan@collabora.co.uk>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Nirbheek Chauhan <nirbheek.chauhan@collabora.co.uk>

The LOOP_GET_STATUS ioctl truncates filenames to 64 characters. We should get
the backing file for a given loop device from /sys/. This is how losetup does it
as well.
---
 utils.c |   26 ++++++++++++++------------
 1 files changed, 14 insertions(+), 12 deletions(-)

diff --git a/utils.c b/utils.c
index 205e667..cdd6f7d 100644
--- a/utils.c
+++ b/utils.c
@@ -20,6 +20,7 @@
 #define __USE_XOPEN2K
 #include <stdio.h>
 #include <stdlib.h>
+#include <string.h>
 #ifndef __CHECKER__
 #include <sys/ioctl.h>
 #include <sys/mount.h>
@@ -651,21 +652,22 @@ int is_loop_device (const char* device) {
  * the associated file (e.g. /images/my_btrfs.img) */
 int resolve_loop_device(const char* loop_dev, char* loop_file, int max_len)
 {
-	int loop_fd;
-	int ret_ioctl;
-	struct loop_info loopinfo;
+	int ret;
+	FILE *f;
+	char fmt[20];
+	char p[PATH_MAX];
+	char real_loop_dev[PATH_MAX];
 
-	if ((loop_fd = open(loop_dev, O_RDONLY)) < 0)
+	if (!realpath(loop_dev, real_loop_dev))
+		return -errno;
+	snprintf(p, PATH_MAX, "/sys/block/%s/loop/backing_file", strrchr(real_loop_dev, '/'));
+	if (!(f = fopen(p, "r")))
 		return -errno;
 
-	ret_ioctl = ioctl(loop_fd, LOOP_GET_STATUS, &loopinfo);
-	close(loop_fd);
-
-	if (ret_ioctl == 0) {
-		strncpy(loop_file, loopinfo.lo_name, max_len);
-		if (max_len > 0)
-			loop_file[max_len-1] = 0;
-	} else
+	snprintf(fmt, 20, "%%%i[^\n]", max_len-1);
+	ret = fscanf(f, fmt, loop_file);
+	fclose(f);
+	if (ret == EOF)
 		return -errno;
 
 	return 0;
-- 
1.7.8.6

