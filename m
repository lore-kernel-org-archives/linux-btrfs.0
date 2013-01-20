Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from eastrmfepo202.cox.net ([68.230.241.217]:51606 "EHLO
	eastrmfepo202.cox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752488Ab3ATVEi (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 20 Jan 2013 16:04:38 -0500
Received: from eastrmimpo209 ([68.230.241.224]) by eastrmfepo202.cox.net
          (InterMail vM.8.01.04.00 201-2260-137-20101110) with ESMTP
          id <20130120210437.PZD6475.eastrmfepo202.cox.net@eastrmimpo209>
          for <linux-btrfs@vger.kernel.org>;
          Sun, 20 Jan 2013 16:04:37 -0500
From: Gene Czarcinski <gene@czarc.net>
To: linux-btrfs@vger.kernel.org
Cc: Nirbheek Chauhan <nirbheek.chauhan@collabora.co.uk>,
        Gene Czarcinski <gene@czarc.net>
Subject: [PATCH 02/13] Btrfs-progs: fix resolving of loop devices
Date: Sun, 20 Jan 2013 16:04:07 -0500
Message-Id: <1358715858-4469-3-git-send-email-gene@czarc.net>
In-Reply-To: <1358715858-4469-1-git-send-email-gene@czarc.net>
References: <1358715858-4469-1-git-send-email-gene@czarc.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Nirbheek Chauhan <nirbheek.chauhan@collabora.co.uk>

The LOOP_GET_STATUS ioctl truncates filenames to 64 characters. We should get
the backing file for a given loop device from /sys/. This is how losetup does it
as well.

Signed-off-by: Gene Czarcinski <gene@czarc.net>
---
 utils.c | 26 ++++++++++++++------------
 1 file changed, 14 insertions(+), 12 deletions(-)

diff --git a/utils.c b/utils.c
index 51b78d5..7953ef9 100644
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
@@ -653,21 +654,22 @@ int is_loop_device (const char* device) {
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
1.8.1

