Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:35799 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753934AbbG1Hzh (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 28 Jul 2015 03:55:37 -0400
Received: from G08CNEXCHPEKD03.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t6S7riwM015895
	for <linux-btrfs@vger.kernel.org>; Tue, 28 Jul 2015 15:53:44 +0800
From: Zhaolei <zhaolei@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Zhao Lei <zhaolei@cn.fujitsu.com>
Subject: [PATCH] btrfs-progs: Increase running state's priority in stat output
Date: Tue, 28 Jul 2015 15:53:58 +0800
Message-ID: <7c723cfb3f6b2d792b832b96f2b6b0258a13044e.1438070027.git.zhaolei@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Zhao Lei <zhaolei@cn.fujitsu.com>

Anthony Plack <anthony@plack.net> reported a output bug in maillist:
  title: btrfs-progs SCRUB reporting aborted but still running - minor

btrfs scrub status report it was aborted but still runs to completion.
  # btrfs scrub status /mnt/data
  scrub status for f591ac13-1a69-476d-bd30-346f87a491da
	scrub started at Mon Apr 27 06:48:44 2015 and was aborted after 1089 seconds
	total bytes scrubbed: 1.02TiB with 0 errors
  #
  # btrfs scrub status /mnt/data
  scrub status for f591ac13-1a69-476d-bd30-346f87a491da
	scrub started at Mon Apr 27 06:48:44 2015 and was aborted after 1664 seconds
	total bytes scrubbed: 1.53TiB with 0 errors
  #
  ...

Reason:
  When scrub multi-device simultaneously, if some device canceled,
  and some device is still running, cancel state have higher priority to
  be outputed in global report.
  So we can see "scrub aborted" in status line, with running-time keeps
  increased.

Fix:
  We can increase running state's priority in output, if there is
  some device in scrub state, we output running state instead of
  cancelled state.

Reported-by: Anthony Plack <anthony@plack.net>
Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
---
 cmds-scrub.c | 18 ++++++++----------
 1 file changed, 8 insertions(+), 10 deletions(-)

diff --git a/cmds-scrub.c b/cmds-scrub.c
index b7aa809..7c9318e 100644
--- a/cmds-scrub.c
+++ b/cmds-scrub.c
@@ -252,17 +252,15 @@ static void _print_scrub_ss(struct scrub_stats *ss)
 	hours = ss->duration / (60 * 60);
 	gmtime_r(&seconds, &tm);
 	strftime(t, sizeof(t), "%M:%S", &tm);
-	if (ss->finished && !ss->canceled) {
-		printf(" and finished after %02u:%s\n", hours, t);
-	} else if (ss->canceled) {
+	if (ss->in_progress)
+		printf(", running for %02u:%s\n", hours, t);
+	else if (ss->canceled)
 		printf(" and was aborted after %02u:%s\n", hours, t);
-	} else {
-		if (ss->in_progress)
-			printf(", running for %02u:%s\n", hours, t);
-		else
-			printf(", interrupted after %02u:%s, not running\n",
-					hours, t);
-	}
+	else if (ss->finished)
+		printf(" and finished after %02u:%s\n", hours, t);
+	else
+		printf(", interrupted after %02u:%s, not running\n",
+		       hours, t);
 }
 
 static void print_scrub_dev(struct btrfs_ioctl_dev_info_args *di,
-- 
1.8.5.1

