Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:40354 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751737AbaLRO1t (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 18 Dec 2014 09:27:49 -0500
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id D7E39AD2F
	for <linux-btrfs@vger.kernel.org>; Thu, 18 Dec 2014 14:27:47 +0000 (UTC)
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>
Subject: [PATCH 2/6] btrfs-progs: fi usage, add switches to set output units
Date: Thu, 18 Dec 2014 15:27:47 +0100
Message-Id: <14e5f687fbb00599cc6923dba71dd93bd5220c46.1418912740.git.dsterba@suse.cz>
In-Reply-To: <cover.1418912740.git.dsterba@suse.cz>
References: <cover.1418912740.git.dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Same set of options as 'fi df': binary and decimal bases, human readable
options etc.

Signed-off-by: David Sterba <dsterba@suse.cz>
---
 cmds-fi-disk_usage.c | 64 +++++++++++++++++++++++++++++++++++++++++++---------
 1 file changed, 53 insertions(+), 11 deletions(-)

diff --git a/cmds-fi-disk_usage.c b/cmds-fi-disk_usage.c
index 77ab8b4c1604..b3b70cc23fd1 100644
--- a/cmds-fi-disk_usage.c
+++ b/cmds-fi-disk_usage.c
@@ -21,6 +21,7 @@
 #include <sys/ioctl.h>
 #include <errno.h>
 #include <stdarg.h>
+#include <getopt.h>
 
 #include "utils.h"
 #include "kerncompat.h"
@@ -844,31 +845,72 @@ out:
 }
 
 const char * const cmd_filesystem_usage_usage[] = {
-	"btrfs filesystem usage [-b][-t] <path> [<path>..]",
-	"Show in which disk the chunks are allocated.",
-	"",
-	"-b\tSet byte as unit",
-	"-T\tShow data in tabular format",
+	"btrfs filesystem usage [options] <path> [<path>..]",
+	"Show detailed information about internal filesystem usage .",
+	"-b|--raw           raw numbers in bytes",
+	"-h                 human friendly numbers, base 1024 (default)",
+	"-H                 human friendly numbers, base 1000",
+	"--iec              use 1024 as a base (KiB, MiB, GiB, TiB)",
+	"--si               use 1000 as a base (kB, MB, GB, TB)",
+	"-k|--kbytes        show sizes in KiB, or kB with --si",
+	"-m|--mbytes        show sizes in MiB, or MB with --si",
+	"-g|--gbytes        show sizes in GiB, or GB with --si",
+	"-t|--tbytes        show sizes in TiB, or TB with --si",
+	"-T                 show data in tabular format",
 	NULL
 };
 
 int cmd_filesystem_usage(int argc, char **argv)
 {
-	int mode = UNITS_HUMAN;
+	unsigned unit_mode = UNITS_DEFAULT;
 	int ret = 0;
 	int	i, more_than_one = 0;
 	int	tabular = 0;
 
 	optind = 1;
 	while (1) {
-		int c = getopt(argc, argv, "bT");
+		int long_index;
+		static const struct option long_options[] = {
+			{ "raw", no_argument, NULL, 'b'},
+			{ "kbytes", no_argument, NULL, 'k'},
+			{ "mbytes", no_argument, NULL, 'm'},
+			{ "gbytes", no_argument, NULL, 'g'},
+			{ "tbytes", no_argument, NULL, 't'},
+			{ "si", no_argument, NULL, 256},
+			{ "iec", no_argument, NULL, 257},
+		};
+		int c = getopt_long(argc, argv, "bhHkmgtT", long_options,
+				&long_index);
 
 		if (c < 0)
 			break;
-
 		switch (c) {
 		case 'b':
-			mode = UNITS_RAW;
+			unit_mode = UNITS_RAW;
+			break;
+		case 'k':
+			units_set_base(&unit_mode, UNITS_KBYTES);
+			break;
+		case 'm':
+			units_set_base(&unit_mode, UNITS_MBYTES);
+			break;
+		case 'g':
+			units_set_base(&unit_mode, UNITS_GBYTES);
+			break;
+		case 't':
+			units_set_base(&unit_mode, UNITS_TBYTES);
+			break;
+		case 'h':
+			unit_mode = UNITS_HUMAN_BINARY;
+			break;
+		case 'H':
+			unit_mode = UNITS_HUMAN_DECIMAL;
+			break;
+		case 256:
+			units_set_mode(&unit_mode, UNITS_DECIMAL);
+			break;
+		case 257:
+			units_set_mode(&unit_mode, UNITS_BINARY);
 			break;
 		case 'T':
 			tabular = 1;
@@ -905,12 +947,12 @@ int cmd_filesystem_usage(int argc, char **argv)
 			goto cleanup;
 
 		ret = print_filesystem_usage_overall(fd, chunkinfo, chunkcount,
-				devinfo, devcount, argv[i], mode);
+				devinfo, devcount, argv[i], unit_mode);
 		if (ret)
 			goto cleanup;
 		printf("\n");
 		ret = print_filesystem_usage_by_chunk(fd, chunkinfo, chunkcount,
-				devinfo, devcount, argv[i], mode, tabular);
+				devinfo, devcount, argv[i], unit_mode, tabular);
 cleanup:
 		close_file_or_dir(fd, dirstream);
 		free(chunkinfo);
-- 
2.1.3

