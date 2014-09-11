Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:32684 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752042AbaIKFW5 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 11 Sep 2014 01:22:57 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s8B5N3mI015964
	for <linux-btrfs@vger.kernel.org>; Thu, 11 Sep 2014 13:23:03 +0800
From: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
Subject: [PATCH] btrfs-progs: deal with conflict options for btrfs fi show
Date: Thu, 11 Sep 2014 13:19:11 +0800
Message-ID: <1410412751-9277-1-git-send-email-guihc.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

For btrfs fi show, -d|--all-devices & -m|--mounted will
overwrite each other, so if specified both, let the user
know that he should not use them at the same time.

Signed-off-by: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
---
 cmds-filesystem.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/cmds-filesystem.c b/cmds-filesystem.c
index 69c1ca5..78aeacc 100644
--- a/cmds-filesystem.c
+++ b/cmds-filesystem.c
@@ -526,16 +526,23 @@ static int cmd_show(int argc, char **argv)
 			break;
 		switch (c) {
 		case 'd':
-			where = BTRFS_SCAN_PROC;
+			where &= ~BTRFS_SCAN_LBLKID;
+			where |= BTRFS_SCAN_PROC;
 			break;
 		case 'm':
-			where = BTRFS_SCAN_MOUNTED;
+			where &= ~BTRFS_SCAN_LBLKID;
+			where |= BTRFS_SCAN_MOUNTED;
 			break;
 		default:
 			usage(cmd_show_usage);
 		}
 	}
 
+	if ((where & BTRFS_SCAN_PROC) && (where & BTRFS_SCAN_MOUNTED)) {
+		fprintf(stderr, "don't use -d|--all-devices and -m|--mounted options at the same time\n");
+		usage(cmd_show_usage);
+	}
+
 	if (check_argc_max(argc, optind + 1))
 		usage(cmd_show_usage);
 
-- 
1.8.1.4

