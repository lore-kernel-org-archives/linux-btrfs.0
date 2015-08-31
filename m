Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:27825 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752568AbbHaLF1 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 31 Aug 2015 07:05:27 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t7VB5FZM009061
	for <linux-btrfs@vger.kernel.org>; Mon, 31 Aug 2015 19:05:15 +0800
From: Zhao Lei <zhaolei@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Zhao Lei <zhaolei@cn.fujitsu.com>
Subject: [PATCH v2 4/4] btrfs-progs: Use common unit parser for btrfs qgroup command
Date: Mon, 31 Aug 2015 19:03:44 +0800
Message-ID: <a312768dbec07fcfca4ac280358770c4a3c9c5c2.1441018814.git.zhaolei@cn.fujitsu.com>
In-Reply-To: <cover.1441018814.git.zhaolei@cn.fujitsu.com>
References: <cover.1441018814.git.zhaolei@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Move to use get_unit_mode_from_arg() for btrfs qgroup command,
to make "btrfs qgroup show"'s unit argument same with other
tools.

Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
---
 cmds-qgroup.c | 47 ++++-------------------------------------------
 1 file changed, 4 insertions(+), 43 deletions(-)

diff --git a/cmds-qgroup.c b/cmds-qgroup.c
index d58df5e..48c1733 100644
--- a/cmds-qgroup.c
+++ b/cmds-qgroup.c
@@ -275,15 +275,7 @@ static const char * const cmd_qgroup_show_usage[] = {
 	"               (including ancestral qgroups)",
 	"-f             list all qgroups which impact the given path",
 	"               (excluding ancestral qgroups)",
-	"--raw          raw numbers in bytes",
-	"--human-readable",
-	"               human firendly numbers in given base, 1024 by default",
-	"--iec          use 1024 as a base (KiB, MiB, GiB, TiB)",
-	"--si           use 1000 as a base (kB, MB, GB, TB)",
-	"--kbytes       show sizes in KiB, or kB with --si",
-	"--mbytes       show sizes in MiB, or MB with --si",
-	"--gbytes       show sizes in GiB, or GB with --si",
-	"--tbytes       show sizes in TiB, or TB with --si",
+	HELPINFO_OUTPUT_UNIT,
 	"--sort=qgroupid,rfer,excl,max_rfer,max_excl",
 	"               list qgroups sorted by specified items",
 	"               you can use '+' or '-' in front of each item.",
@@ -300,27 +292,20 @@ static int cmd_qgroup_show(int argc, char **argv)
 	DIR *dirstream = NULL;
 	u64 qgroupid;
 	int filter_flag = 0;
-	unsigned unit_mode = UNITS_DEFAULT;
+	unsigned unit_mode;
 
 	struct btrfs_qgroup_comparer_set *comparer_set;
 	struct btrfs_qgroup_filter_set *filter_set;
 	filter_set = btrfs_qgroup_alloc_filter_set();
 	comparer_set = btrfs_qgroup_alloc_comparer_set();
 
+	unit_mode = get_unit_mode_from_arg(&argc, argv, 0);
+
 	optind = 1;
 	while (1) {
 		int c;
 		static const struct option long_options[] = {
 			{"sort", required_argument, NULL, 'S'},
-			{"raw", no_argument, NULL, GETOPT_VAL_RAW},
-			{"kbytes", no_argument, NULL, GETOPT_VAL_KBYTES},
-			{"mbytes", no_argument, NULL, GETOPT_VAL_MBYTES},
-			{"gbytes", no_argument, NULL, GETOPT_VAL_GBYTES},
-			{"tbytes", no_argument, NULL, GETOPT_VAL_TBYTES},
-			{"si", no_argument, NULL, GETOPT_VAL_SI},
-			{"iec", no_argument, NULL, GETOPT_VAL_IEC},
-			{ "human-readable", no_argument, NULL,
-				GETOPT_VAL_HUMAN_READABLE},
 			{ NULL, 0, NULL, 0 }
 		};
 
@@ -356,30 +341,6 @@ static int cmd_qgroup_show(int argc, char **argv)
 			if (ret)
 				usage(cmd_qgroup_show_usage);
 			break;
-		case GETOPT_VAL_RAW:
-			unit_mode = UNITS_RAW;
-			break;
-		case GETOPT_VAL_KBYTES:
-			units_set_base(&unit_mode, UNITS_KBYTES);
-			break;
-		case GETOPT_VAL_MBYTES:
-			units_set_base(&unit_mode, UNITS_MBYTES);
-			break;
-		case GETOPT_VAL_GBYTES:
-			units_set_base(&unit_mode, UNITS_GBYTES);
-			break;
-		case GETOPT_VAL_TBYTES:
-			units_set_base(&unit_mode, UNITS_TBYTES);
-			break;
-		case GETOPT_VAL_SI:
-			units_set_mode(&unit_mode, UNITS_DECIMAL);
-			break;
-		case GETOPT_VAL_IEC:
-			units_set_mode(&unit_mode, UNITS_BINARY);
-			break;
-		case GETOPT_VAL_HUMAN_READABLE:
-			unit_mode = UNITS_HUMAN_BINARY;
-			break;
 		default:
 			usage(cmd_qgroup_show_usage);
 		}
-- 
1.8.5.1

