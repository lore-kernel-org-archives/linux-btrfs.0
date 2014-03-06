Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:33940 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752525AbaCFDkw (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 5 Mar 2014 22:40:52 -0500
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s263emOG002080
	for <linux-btrfs@vger.kernel.org>; Thu, 6 Mar 2014 11:40:49 +0800
From: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Cc: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
Subject: [PATCH 2/3] btrfs-progs: cleanup device stat usage prompt
Date: Thu, 6 Mar 2014 11:36:47 +0800
Message-Id: <1394077008-3568-2-git-send-email-guihc.fnst@cn.fujitsu.com>
In-Reply-To: <1394077008-3568-1-git-send-email-guihc.fnst@cn.fujitsu.com>
References: <1394077008-3568-1-git-send-email-guihc.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

1. use usage() to replace the fprintf()
2. use check_argc_exact() to replace "argc != ..."

Signed-off-by: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
---
 cmds-device.c | 13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

diff --git a/cmds-device.c b/cmds-device.c
index ad59600..5009d9a 100644
--- a/cmds-device.c
+++ b/cmds-device.c
@@ -324,18 +324,13 @@ static int cmd_dev_stats(int argc, char **argv)
 			break;
 		case '?':
 		default:
-			fprintf(stderr, "ERROR: device stat args invalid.\n"
-					" device stat [-z] <path>|<device>\n"
-					" -z  to reset stats after reading.\n");
-			return 1;
+			usage(cmd_dev_stats_usage);
 		}
 	}
 
-	if (optind + 1 != argc) {
-		fprintf(stderr, "ERROR: device stat needs path|device as single"
-			" argument\n");
-		return 1;
-	}
+	argc = argc - optind;
+	if (check_argc_exact(argc, 1))
+		usage(cmd_dev_stats_usage);
 
 	dev_path = argv[optind];
 
-- 
1.8.1.4

