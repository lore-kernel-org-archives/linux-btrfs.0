Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:11950 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751093AbbHEIeG (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 5 Aug 2015 04:34:06 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t758W8la016291
	for <linux-btrfs@vger.kernel.org>; Wed, 5 Aug 2015 16:32:08 +0800
From: Zhao Lei <zhaolei@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Zhao Lei <zhaolei@cn.fujitsu.com>
Subject: [PATCH] btrfs-progs: Modify confuse error message in scrub
Date: Wed, 5 Aug 2015 16:32:26 +0800
Message-ID: <a2853778dc15eec5eb3b09ddcc3b3e911254c19a.1438763531.git.zhaolei@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Scrub output following error message in my test:
  ERROR: scrubbing /var/ltf/tester/scratch_mnt failed for device id 5 (Success)

It is caused by a broken kernel and fs, but the we need to avoid
outputting both "error and success" in oneline message as above.

This patch modified above message to:
  ERROR: scrubbing /var/ltf/tester/scratch_mnt failed for device id 5, ret=1, errno=0(Success)

Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
---
 cmds-scrub.c | 34 +++++++++++++++++++---------------
 1 file changed, 19 insertions(+), 15 deletions(-)

diff --git a/cmds-scrub.c b/cmds-scrub.c
index 7c9318e..2529956 100644
--- a/cmds-scrub.c
+++ b/cmds-scrub.c
@@ -1457,21 +1457,25 @@ static int scrub_start(int argc, char **argv, int resume)
 			++err;
 			continue;
 		}
-		if (sp[i].ret && sp[i].ioctl_errno == ENODEV) {
-			if (do_print)
-				fprintf(stderr, "WARNING: device %lld not "
-					"present\n", devid);
-			continue;
-		}
-		if (sp[i].ret && sp[i].ioctl_errno == ECANCELED) {
-			++err;
-		} else if (sp[i].ret) {
-			if (do_print)
-				fprintf(stderr, "ERROR: scrubbing %s failed "
-					"for device id %lld (%s)\n", path,
-					devid, strerror(sp[i].ioctl_errno));
-			++err;
-			continue;
+		if (sp[i].ret) {
+			switch (sp[i].ioctl_errno) {
+			case ENODEV:
+				if (do_print)
+					fprintf(stderr, "WARNING: device %lld not present\n",
+						devid);
+				continue;
+			case ECANCELED:
+				++err;
+				break;
+			default:
+				if (do_print)
+					fprintf(stderr, "ERROR: scrubbing %s failed for device id %lld, ret=%d, errno=%d(%s)\n",
+						path, devid,
+						sp[i].ret, sp[i].ioctl_errno,
+						strerror(sp[i].ioctl_errno));
+				++err;
+				continue;
+			}
 		}
 		if (sp[i].scrub_args.progress.uncorrectable_errors > 0)
 			e_uncorrectable++;
-- 
1.8.5.1

