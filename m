Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:10477 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752140AbaD1Iga (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 28 Apr 2014 04:36:30 -0400
Received: from G08CNEXCHPEKD03.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s3S8aRIT001436
	for <linux-btrfs@vger.kernel.org>; Mon, 28 Apr 2014 16:36:27 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 1/2] btrfs-progs: Improve the errno string about open_path_or_dev_mnt()
Date: Mon, 28 Apr 2014 16:37:29 +0800
Message-ID: <1398674250-9656-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

open_path_or_dev_mnt() is used to on *mounted* btrfs device or mount
point, when a unmounted btrfs device is passed, errno is set to EINVAL to
info the caller.
If ignore the errno and just print "ERROR: can't access '%s'", end users
will get confused.

This patch will add check for open_path_or_dev_mnt() caller and print
more meaningful error message when a unmounted btrfs device path is
given.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 cmds-device.c  |  8 +++++++-
 cmds-replace.c |  9 +++++++--
 cmds-scrub.c   | 25 +++++++++++++++++++++----
 3 files changed, 35 insertions(+), 7 deletions(-)

diff --git a/cmds-device.c b/cmds-device.c
index a9b4a38..f2e08ba 100644
--- a/cmds-device.c
+++ b/cmds-device.c
@@ -353,7 +353,13 @@ static int cmd_dev_stats(int argc, char **argv)
 	fdmnt = open_path_or_dev_mnt(dev_path, &dirstream);
 
 	if (fdmnt < 0) {
-		fprintf(stderr, "ERROR: can't access '%s'\n", dev_path);
+		if (errno == EINVAL)
+			fprintf(stderr,
+				"ERROR: '%s' is not a mounted btrfs device\n",
+				dev_path);
+		else
+			fprintf(stderr, "ERROR: can't access '%s': %s\n",
+				dev_path, strerror(errno));
 		return 1;
 	}
 
diff --git a/cmds-replace.c b/cmds-replace.c
index 01ab77c..645dc98 100644
--- a/cmds-replace.c
+++ b/cmds-replace.c
@@ -172,8 +172,13 @@ static int cmd_start_replace(int argc, char **argv)
 	fdmnt = open_path_or_dev_mnt(path, &dirstream);
 
 	if (fdmnt < 0) {
-		fprintf(stderr, "ERROR: can't access \"%s\": %s\n",
-			path, strerror(errno));
+		if (errno == EINVAL)
+			fprintf(stderr,
+				"ERROR: '%s' is not a mounted btrfs device\n",
+				path);
+		else
+			fprintf(stderr, "ERROR: can't access '%s': %s\n",
+				path, strerror(errno));
 		goto leave_with_error;
 	}
 
diff --git a/cmds-scrub.c b/cmds-scrub.c
index 4338a0b..616d797 100644
--- a/cmds-scrub.c
+++ b/cmds-scrub.c
@@ -1172,7 +1172,13 @@ static int scrub_start(int argc, char **argv, int resume)
 	fdmnt = open_path_or_dev_mnt(path, &dirstream);
 
 	if (fdmnt < 0) {
-		ERR(!do_quiet, "ERROR: can't access '%s'\n", path);
+		if (errno == EINVAL)
+			ERR(!do_quiet,
+			    "ERROR: '%s' is not a mounted btrfs device\n",
+			    path);
+		else
+			ERR(!do_quiet, "ERROR: can't access '%s': %s\n",
+			    path, strerror(errno));
 		return 1;
 	}
 
@@ -1560,8 +1566,13 @@ static int cmd_scrub_cancel(int argc, char **argv)
 
 	fdmnt = open_path_or_dev_mnt(path, &dirstream);
 	if (fdmnt < 0) {
-		fprintf(stderr, "ERROR: could not open %s: %s\n",
-			path, strerror(errno));
+		if (errno == EINVAL)
+			fprintf(stderr,
+				"ERROR: '%s' is not a mounted btrfs device\n",
+				path);
+		else
+			fprintf(stderr, "ERROR: can't access '%s': %s\n",
+				path, strerror(errno));
 		ret = 1;
 		goto out;
 	}
@@ -1658,7 +1669,13 @@ static int cmd_scrub_status(int argc, char **argv)
 	fdmnt = open_path_or_dev_mnt(path, &dirstream);
 
 	if (fdmnt < 0) {
-		fprintf(stderr, "ERROR: can't access '%s'\n", path);
+		if (errno == EINVAL)
+			fprintf(stderr,
+				"ERROR: '%s' is not a mounted btrfs device\n",
+				path);
+		else
+			fprintf(stderr, "ERROR: can't access '%s': %s\n",
+				path, strerror(errno));
 		return 1;
 	}
 
-- 
1.9.2

