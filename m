Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:38685 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753072AbbHFDHf (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 5 Aug 2015 23:07:35 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t7635cxx021080
	for <linux-btrfs@vger.kernel.org>; Thu, 6 Aug 2015 11:05:38 +0800
From: Zhao Lei <zhaolei@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Zhao Lei <zhaolei@cn.fujitsu.com>
Subject: [PATCH v2 1/2] btrfs-progs: use switch instead of a series of ifs for output errormsg
Date: Thu, 6 Aug 2015 11:05:54 +0800
Message-ID: <4779cd8de60a58c7e3d9ea2cf62595bd075638c2.1438830282.git.zhaolei@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

switch statement is more suitable for outputing currsponding message
for errno.

Suggested-by: David Sterba <dsterba@suse.com>
Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
---
 cmds-scrub.c | 33 ++++++++++++++++++---------------
 1 file changed, 18 insertions(+), 15 deletions(-)

diff --git a/cmds-scrub.c b/cmds-scrub.c
index 7c9318e..a40eecf 100644
--- a/cmds-scrub.c
+++ b/cmds-scrub.c
@@ -1457,21 +1457,24 @@ static int scrub_start(int argc, char **argv, int resume)
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
+					fprintf(stderr, "ERROR: scrubbing %s failed for device id %lld (%s)\n",
+						path, devid,
+						strerror(sp[i].ioctl_errno));
+				++err;
+				continue;
+			}
 		}
 		if (sp[i].scrub_args.progress.uncorrectable_errors > 0)
 			e_uncorrectable++;
-- 
1.8.5.1

