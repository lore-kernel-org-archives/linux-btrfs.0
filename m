Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:27825 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752036AbbHaLF0 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 31 Aug 2015 07:05:26 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t7VB5DbB009049
	for <linux-btrfs@vger.kernel.org>; Mon, 31 Aug 2015 19:05:13 +0800
From: Zhao Lei <zhaolei@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Zhao Lei <zhaolei@cn.fujitsu.com>
Subject: [PATCH v2 1/4] btrfs-progs: Introduce get_unit_mode_from_arg for common use
Date: Mon, 31 Aug 2015 19:03:41 +0800
Message-ID: <7d141667eedc90882d1660af3fee2491367e151c.1441018814.git.zhaolei@cn.fujitsu.com>
In-Reply-To: <cover.1441018814.git.zhaolei@cn.fujitsu.com>
References: <cover.1441018814.git.zhaolei@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We are using separate code for parse unit mode in current code,
better to use common function.

This patch introduce common function for to arguments for setting
unit, and a common help message, to make every tool in btrfs having
same unit argument.

The merit are:
1: Unify current each tool's arguments for unit
2: Make tools in future easy to implement such argument
3: Changes(enhancement) in common function have effect on all
   relative tools

Changelog v1->v2:
 Keep short options for 'fi df' command, to keeps option compatibility
 with the standalone 'df' commmand, suggested-by:
 David Sterba <dsterba@suse.cz>

Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
---
 utils.c | 102 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 utils.h |  24 +++++++++++++++
 2 files changed, 126 insertions(+)

diff --git a/utils.c b/utils.c
index 791d10f..220c7d8 100644
--- a/utils.c
+++ b/utils.c
@@ -2950,3 +2950,105 @@ int arg_copy_path(char *dest, const char *src, int destlen)
 
 	return 0;
 }
+
+unsigned int get_unit_mode_from_arg(int *argc, char *argv[], int df_mode)
+{
+	unsigned int unit_mode = UNITS_DEFAULT;
+	int arg_i;
+	int arg_end;
+
+	for (arg_i = 0; arg_i < *argc; arg_i++) {
+		if (!strcmp(argv[arg_i], "--raw")) {
+			unit_mode = UNITS_RAW;
+			argv[arg_i] = NULL;
+			continue;
+		}
+		if (!strcmp(argv[arg_i], "--human-readable")) {
+			unit_mode = UNITS_HUMAN_BINARY;
+			argv[arg_i] = NULL;
+			continue;
+		}
+
+		if (!strcmp(argv[arg_i], "--iec")) {
+			units_set_mode(&unit_mode, UNITS_BINARY);
+			argv[arg_i] = NULL;
+			continue;
+		}
+		if (!strcmp(argv[arg_i], "--si")) {
+			units_set_mode(&unit_mode, UNITS_DECIMAL);
+			argv[arg_i] = NULL;
+			continue;
+		}
+
+		if (!strcmp(argv[arg_i], "--kbytes")) {
+			units_set_base(&unit_mode, UNITS_KBYTES);
+			argv[arg_i] = NULL;
+			continue;
+		}
+		if (!strcmp(argv[arg_i], "--mbytes")) {
+			units_set_base(&unit_mode, UNITS_MBYTES);
+			argv[arg_i] = NULL;
+			continue;
+		}
+		if (!strcmp(argv[arg_i], "--gbytes")) {
+			units_set_base(&unit_mode, UNITS_GBYTES);
+			argv[arg_i] = NULL;
+			continue;
+		}
+		if (!strcmp(argv[arg_i], "--tbytes")) {
+			units_set_base(&unit_mode, UNITS_TBYTES);
+			argv[arg_i] = NULL;
+			continue;
+		}
+
+		if (!df_mode)
+			continue;
+
+		if (!strcmp(argv[arg_i], "-b")) {
+			unit_mode = UNITS_RAW;
+			argv[arg_i] = NULL;
+			continue;
+		}
+		if (!strcmp(argv[arg_i], "-h")) {
+			unit_mode = UNITS_HUMAN_BINARY;
+			argv[arg_i] = NULL;
+			continue;
+		}
+		if (!strcmp(argv[arg_i], "-H")) {
+			unit_mode = UNITS_HUMAN_DECIMAL;
+			argv[arg_i] = NULL;
+			continue;
+		}
+		if (!strcmp(argv[arg_i], "-k")) {
+			units_set_base(&unit_mode, UNITS_KBYTES);
+			argv[arg_i] = NULL;
+			continue;
+		}
+		if (!strcmp(argv[arg_i], "-m")) {
+			units_set_base(&unit_mode, UNITS_MBYTES);
+			argv[arg_i] = NULL;
+			continue;
+		}
+		if (!strcmp(argv[arg_i], "-g")) {
+			units_set_base(&unit_mode, UNITS_GBYTES);
+			argv[arg_i] = NULL;
+			continue;
+		}
+		if (!strcmp(argv[arg_i], "-t")) {
+			units_set_base(&unit_mode, UNITS_TBYTES);
+			argv[arg_i] = NULL;
+			continue;
+		}
+	}
+
+	for (arg_i = 0, arg_end = 0; arg_i < *argc; arg_i++) {
+		if (!argv[arg_i])
+			continue;
+		argv[arg_end] = argv[arg_i];
+		arg_end++;
+	}
+
+	*argc = arg_end;
+
+	return unit_mode;
+}
diff --git a/utils.h b/utils.h
index 10d68e9..44b3662 100644
--- a/utils.h
+++ b/utils.h
@@ -245,4 +245,28 @@ int btrfs_check_nodesize(u32 nodesize, u32 sectorsize);
 
 const char *get_argv0_buf(void);
 
+#define HELPINFO_OUTPUT_UNIT \
+	"--raw              raw numbers in bytes", \
+	"--human-readable   human friendly numbers, base 1024 (default)", \
+	"--iec              use 1024 as a base (KiB, MiB, GiB, TiB)", \
+	"--si               use 1000 as a base (kB, MB, GB, TB)", \
+	"--kbytes           show sizes in KiB, or kB with --si", \
+	"--mbytes           show sizes in MiB, or MB with --si", \
+	"--gbytes           show sizes in GiB, or GB with --si", \
+	"--tbytes           show sizes in TiB, or TB with --si"
+
+#define HELPINFO_OUTPUT_UNIT_DF \
+	"-b|--raw           raw numbers in bytes", \
+	"-h|--human-readable", \
+	"                   human friendly numbers, base 1024 (default)", \
+	"-H                 human friendly numbers, base 1000", \
+	"--iec              use 1024 as a base (KiB, MiB, GiB, TiB)", \
+	"--si               use 1000 as a base (kB, MB, GB, TB)", \
+	"-k|--kbytes        show sizes in KiB, or kB with --si", \
+	"-m|--mbytes        show sizes in MiB, or MB with --si", \
+	"-g|--gbytes        show sizes in GiB, or GB with --si", \
+	"-t|--tbytes        show sizes in TiB, or TB with --si"
+
+unsigned int get_unit_mode_from_arg(int *argc, char *argv[], int df_mode);
+
 #endif
-- 
1.8.5.1

