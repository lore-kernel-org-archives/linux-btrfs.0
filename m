Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:49679 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752565AbbHaLF1 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 31 Aug 2015 07:05:27 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t7VB5EHh009057
	for <linux-btrfs@vger.kernel.org>; Mon, 31 Aug 2015 19:05:14 +0800
From: Zhao Lei <zhaolei@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Zhao Lei <zhaolei@cn.fujitsu.com>
Subject: [PATCH v2 3/4] btrfs-progs: Use common unit parser for btrfs device command
Date: Mon, 31 Aug 2015 19:03:43 +0800
Message-ID: <cfffaef2ae967fab94afcc918729fae8a550f702.1441018814.git.zhaolei@cn.fujitsu.com>
In-Reply-To: <cover.1441018814.git.zhaolei@cn.fujitsu.com>
References: <cover.1441018814.git.zhaolei@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Move to use get_unit_mode_from_arg() for cmds-device.c,
to make "btrfs device usage"'s unit argument same with other
tools.

Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
---
 cmds-device.c | 74 ++++++-----------------------------------------------------
 1 file changed, 7 insertions(+), 67 deletions(-)

diff --git a/cmds-device.c b/cmds-device.c
index 844289a..e0f390b 100644
--- a/cmds-device.c
+++ b/cmds-device.c
@@ -474,16 +474,7 @@ out:
 const char * const cmd_device_usage_usage[] = {
 	"btrfs device usage [options] <path> [<path>..]",
 	"Show detailed information about internal allocations in devices.",
-	"-b|--raw           raw numbers in bytes",
-	"-h|--human-readable",
-	"                   human friendly numbers, base 1024 (default)",
-	"-H                 human friendly numbers, base 1000",
-	"--iec              use 1024 as a base (KiB, MiB, GiB, TiB)",
-	"--si               use 1000 as a base (kB, MB, GB, TB)",
-	"-k|--kbytes        show sizes in KiB, or kB with --si",
-	"-m|--mbytes        show sizes in MiB, or MB with --si",
-	"-g|--gbytes        show sizes in GiB, or GB with --si",
-	"-t|--tbytes        show sizes in TiB, or TB with --si",
+	HELPINFO_OUTPUT_UNIT,
 	NULL
 };
 
@@ -518,69 +509,18 @@ out:
 
 int cmd_device_usage(int argc, char **argv)
 {
-	unsigned unit_mode = UNITS_DEFAULT;
+	unsigned unit_mode;
 	int ret = 0;
-	int	i, more_than_one = 0;
+	int i, more_than_one = 0;
 
-	optind = 1;
-	while (1) {
-		int c;
-		static const struct option long_options[] = {
-			{ "raw", no_argument, NULL, 'b'},
-			{ "kbytes", no_argument, NULL, 'k'},
-			{ "mbytes", no_argument, NULL, 'm'},
-			{ "gbytes", no_argument, NULL, 'g'},
-			{ "tbytes", no_argument, NULL, 't'},
-			{ "si", no_argument, NULL, GETOPT_VAL_SI},
-			{ "iec", no_argument, NULL, GETOPT_VAL_IEC},
-			{ "human-readable", no_argument, NULL,
-				GETOPT_VAL_HUMAN_READABLE},
-			{ NULL, 0, NULL, 0 }
-		};
-
-		c = getopt_long(argc, argv, "bhHkmgt", long_options, NULL);
-		if (c < 0)
-			break;
-		switch (c) {
-		case 'b':
-			unit_mode = UNITS_RAW;
-			break;
-		case 'k':
-			units_set_base(&unit_mode, UNITS_KBYTES);
-			break;
-		case 'm':
-			units_set_base(&unit_mode, UNITS_MBYTES);
-			break;
-		case 'g':
-			units_set_base(&unit_mode, UNITS_GBYTES);
-			break;
-		case 't':
-			units_set_base(&unit_mode, UNITS_TBYTES);
-			break;
-		case GETOPT_VAL_HUMAN_READABLE:
-		case 'h':
-			unit_mode = UNITS_HUMAN_BINARY;
-			break;
-		case 'H':
-			unit_mode = UNITS_HUMAN_DECIMAL;
-			break;
-		case GETOPT_VAL_SI:
-			units_set_mode(&unit_mode, UNITS_DECIMAL);
-			break;
-		case GETOPT_VAL_IEC:
-			units_set_mode(&unit_mode, UNITS_BINARY);
-			break;
-		default:
-			usage(cmd_device_usage_usage);
-		}
-	}
+	unit_mode = get_unit_mode_from_arg(&argc, argv, 0);
 
-	if (check_argc_min(argc - optind, 1))
+	if (check_argc_min(argc, 2) || argv[1][0] == '-')
 		usage(cmd_device_usage_usage);
 
-	for (i = optind; i < argc ; i++) {
+	for (i = 1; i < argc; i++) {
 		int fd;
-		DIR	*dirstream = NULL;
+		DIR *dirstream = NULL;
 		if (more_than_one)
 			printf("\n");
 
-- 
1.8.5.1

