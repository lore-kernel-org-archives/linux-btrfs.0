Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([93.93.135.160]:58282 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753027Ab2JWJyH (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 23 Oct 2012 05:54:07 -0400
From: Hector Oron <hector.oron@collabora.co.uk>
To: linux-btrfs@vger.kernel.org
Cc: nirbheek.chauhan@collabora.co.uk
Subject: [PATCH] Btrfs-progs: fix resolving of loop devices
Date: Tue, 23 Oct 2012 11:53:43 +0200
Message-Id: <1350986023-8758-1-git-send-email-hector.oron@collabora.co.uk>
In-Reply-To: <1350050134-12151-2-git-send-email-nirbheek.chauhan@collabora.co.uk>
References: <1350050134-12151-2-git-send-email-nirbheek.chauhan@collabora.co.uk>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Nirbheek Chauhan <nirbheek.chauhan <at> collabora.co.uk>

If the path to a given loopback file is longer than 64 characters, none of the
Btrfs-progs tools can use it. This is because the size of loopinfo.lo_name
returned by the LOOP_GET_STATUS ioctl is 64.

The attached patch fixes this by fetching the backing file for a loopback device
from /sys/block; which is how `losetup` from util-linux does it as well.

Nirbheek Chauhan (1):
  Btrfs-progs: fix resolving of loop devices

 utils.c |   26 ++++++++++++++------------
 1 files changed, 14 insertions(+), 12 deletions(-)

Tested-By: Hector Oron <hector.oron@collabora.co.uk>

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
