Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:33156 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S933100AbbIDN0B (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 4 Sep 2015 09:26:01 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t84DPmSc030032
	for <linux-btrfs@vger.kernel.org>; Fri, 4 Sep 2015 21:25:48 +0800
From: Zhao Lei <zhaolei@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Zhao Lei <zhaolei@cn.fujitsu.com>
Subject: [PATCH 4/5] btrfs-progs: add help command to btrfs rescue zero-log
Date: Fri, 4 Sep 2015 21:24:18 +0800
Message-ID: <7902fde708c717f3cc963240a9b02f0f6aa6d542.1441357933.git.zhaolei@cn.fujitsu.com>
In-Reply-To: <cover.1441357933.git.zhaolei@cn.fujitsu.com>
References: <cover.1441357933.git.zhaolei@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

To make it unified with other two rescue command, which support
--help option.

Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
---
 cmds-rescue.c | 17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

diff --git a/cmds-rescue.c b/cmds-rescue.c
index a709e1b..3ed63f6 100644
--- a/cmds-rescue.c
+++ b/cmds-rescue.c
@@ -165,6 +165,7 @@ const char * const cmd_rescue_zero_log_usage[] = {
 	"Clear the tree log. Usable if it's corrupted and prevents mount.",
 	"",
 	HELPINFO_EXTRA_DEV,
+	"-h                 Help",
 	NULL
 };
 
@@ -179,10 +180,22 @@ int cmd_rescue_zero_log(int argc, char **argv)
 	if (set_extra_dev_from_arg(&argc, argv))
 		usage(cmd_rescue_zero_log_usage);
 
-	if (check_argc_exact(argc, 2))
+	while (1) {
+		int c = getopt(argc, argv, "h");
+
+		if (c < 0)
+			break;
+		switch (c) {
+		case 'h':
+		default:
+			usage(cmd_rescue_zero_log_usage);
+		}
+	}
+
+	if (check_argc_exact(argc - optind, 1))
 		usage(cmd_rescue_zero_log_usage);
 
-	devname = argv[1];
+	devname = argv[optind];
 	ret = check_mounted(devname);
 	if (ret < 0) {
 		fprintf(stderr, "Could not check mount status: %s\n", strerror(-ret));
-- 
1.8.5.1

