Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:31998 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753531AbbH0NkG (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 27 Aug 2015 09:40:06 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t7RDdrqb017137
	for <linux-btrfs@vger.kernel.org>; Thu, 27 Aug 2015 21:39:53 +0800
From: Zhao Lei <zhaolei@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Zhao Lei <zhaolei@cn.fujitsu.com>
Subject: [PATCH 2/4] btrfs-progs: Use common unit parser for btrfs filesystem command
Date: Thu, 27 Aug 2015 21:38:21 +0800
Message-ID: <7270e42cc39f625842bf34e1dc9196ca0557373b.1440682373.git.zhaolei@cn.fujitsu.com>
In-Reply-To: <cover.1440682373.git.zhaolei@cn.fujitsu.com>
References: <cover.1440682373.git.zhaolei@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Move to use get_unit_mode_from_arg() for cmds-filesystem.c,
to make "btrfs filesystem df/show/usage"'s unit argument same.

Also have cleanup effect: 18 insertions(+), 178 deletions(-)

Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
---
 cmds-fi-usage.c   |  79 ++++-------------------------------
 cmds-filesystem.c | 121 ++++++------------------------------------------------
 2 files changed, 19 insertions(+), 181 deletions(-)

diff --git a/cmds-fi-usage.c b/cmds-fi-usage.c
index adf1c27..40e0f31 100644
--- a/cmds-fi-usage.c
+++ b/cmds-fi-usage.c
@@ -859,88 +859,23 @@ out:
 const char * const cmd_filesystem_usage_usage[] = {
 	"btrfs filesystem usage [options] <path> [<path>..]",
 	"Show detailed information about internal filesystem usage .",
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
-	"-T                 show data in tabular format",
+	HELPINFO_OUTPUT_UNIT,
 	NULL
 };
 
 int cmd_filesystem_usage(int argc, char **argv)
 {
-	unsigned unit_mode = UNITS_DEFAULT;
+	unsigned unit_mode;
 	int ret = 0;
-	int	i, more_than_one = 0;
-	int	tabular = 0;
+	int i, more_than_one = 0;
+	int tabular = 0;
 
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
-		c = getopt_long(argc, argv, "bhHkmgtT", long_options, NULL);
-
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
-		case 'T':
-			tabular = 1;
-			break;
-		default:
-			usage(cmd_filesystem_usage_usage);
-		}
-	}
+	unit_mode = get_unit_mode_from_arg(&argc, argv);
 
-	if (check_argc_min(argc - optind, 1))
+	if (check_argc_min(argc, 2) || argv[1][0] == '-')
 		usage(cmd_filesystem_usage_usage);
 
-	for (i = optind; i < argc; i++) {
+	for (i = 1; i < argc; i++) {
 		int fd;
 		DIR *dirstream = NULL;
 		struct chunk_info *chunkinfo = NULL;
diff --git a/cmds-filesystem.c b/cmds-filesystem.c
index fa555b0..6a4dc8f 100644
--- a/cmds-filesystem.c
+++ b/cmds-filesystem.c
@@ -121,19 +121,10 @@ static const char * const filesystem_cmd_group_usage[] = {
 };
 
 static const char * const cmd_filesystem_df_usage[] = {
-       "btrfs filesystem df [options] <path>",
-       "Show space usage information for a mount point",
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
-       NULL
+	"btrfs filesystem df [options] <path>",
+	"Show space usage information for a mount point",
+	HELPINFO_OUTPUT_UNIT,
+	NULL
 };
 
 static int get_df(int fd, struct btrfs_ioctl_space_args **sargs_ret)
@@ -205,64 +196,14 @@ static int cmd_filesystem_df(int argc, char **argv)
 	int fd;
 	char *path;
 	DIR *dirstream = NULL;
-	unsigned unit_mode = UNITS_DEFAULT;
+	unsigned unit_mode;
 
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
-			usage(cmd_filesystem_df_usage);
-		}
-	}
+	unit_mode = get_unit_mode_from_arg(&argc, argv);
 
-	if (check_argc_exact(argc, optind + 1))
+	if (argc != 2 || argv[1][0] == '-')
 		usage(cmd_filesystem_df_usage);
 
-	path = argv[optind];
+	path = argv[1];
 
 	fd = open_file_or_dir(path, &dirstream);
 	if (fd < 0) {
@@ -820,14 +761,7 @@ static const char * const cmd_filesystem_show_usage[] = {
 	"Show the structure of a filesystem",
 	"-d|--all-devices   show only disks under /dev containing btrfs filesystem",
 	"-m|--mounted       show only mounted btrfs",
-	"--raw              raw numbers in bytes",
-	"--human-readable   human friendly numbers, base 1024 (default)",
-	"--iec              use 1024 as a base (KiB, MiB, GiB, TiB)",
-	"--si               use 1000 as a base (kB, MB, GB, TB)",
-	"--kbytes           show sizes in KiB, or kB with --si",
-	"--mbytes           show sizes in MiB, or MB with --si",
-	"--gbytes           show sizes in GiB, or GB with --si",
-	"--tbytes           show sizes in TiB, or TB with --si",
+	HELPINFO_OUTPUT_UNIT,
 	"If no argument is given, structure of all present filesystems is shown.",
 	NULL
 };
@@ -845,23 +779,16 @@ static int cmd_filesystem_show(int argc, char **argv)
 	char path[PATH_MAX];
 	__u8 fsid[BTRFS_FSID_SIZE];
 	char uuid_buf[BTRFS_UUID_UNPARSED_SIZE];
-	unsigned unit_mode = UNITS_DEFAULT;
+	unsigned unit_mode;
 	int found = 0;
 
+	unit_mode = get_unit_mode_from_arg(&argc, argv);
+
 	while (1) {
 		int c;
 		static const struct option long_options[] = {
 			{ "all-devices", no_argument, NULL, 'd'},
 			{ "mounted", no_argument, NULL, 'm'},
-			{ "raw", no_argument, NULL, GETOPT_VAL_RAW},
-			{ "kbytes", no_argument, NULL, GETOPT_VAL_KBYTES},
-			{ "mbytes", no_argument, NULL, GETOPT_VAL_MBYTES},
-			{ "gbytes", no_argument, NULL, GETOPT_VAL_GBYTES},
-			{ "tbytes", no_argument, NULL, GETOPT_VAL_TBYTES},
-			{ "si", no_argument, NULL, GETOPT_VAL_SI},
-			{ "iec", no_argument, NULL, GETOPT_VAL_IEC},
-			{ "human-readable", no_argument, NULL,
-				GETOPT_VAL_HUMAN_READABLE},
 			{ NULL, 0, NULL, 0 }
 		};
 
@@ -875,30 +802,6 @@ static int cmd_filesystem_show(int argc, char **argv)
 		case 'm':
 			where = BTRFS_SCAN_MOUNTED;
 			break;
-		case GETOPT_VAL_RAW:
-			units_set_mode(&unit_mode, UNITS_RAW);
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
-			units_set_mode(&unit_mode, UNITS_HUMAN_BINARY);
-			break;
 		default:
 			usage(cmd_filesystem_show_usage);
 		}
-- 
1.8.5.1

