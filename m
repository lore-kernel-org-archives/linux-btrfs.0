Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:40372 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751737AbaLRO1z (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 18 Dec 2014 09:27:55 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id C3C75AD2F
	for <linux-btrfs@vger.kernel.org>; Thu, 18 Dec 2014 14:27:54 +0000 (UTC)
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>
Subject: [PATCH 4/6] btrfs-progs: dev usage, add switches to set output units
Date: Thu, 18 Dec 2014 15:27:54 +0100
Message-Id: <abef6fd343ddc7c93b7ac032885419e4ec594ed1.1418912740.git.dsterba@suse.cz>
In-Reply-To: <cover.1418912740.git.dsterba@suse.cz>
References: <cover.1418912740.git.dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Same set of options as 'fi df': binary and decimal bases, human readable
options etc.

Signed-off-by: David Sterba <dsterba@suse.cz>
---
 cmds-device.c | 60 +++++++++++++++++++++++++++++++++++++++++++++++++----------
 1 file changed, 50 insertions(+), 10 deletions(-)

diff --git a/cmds-device.c b/cmds-device.c
index 33f1311a546c..13458d850c26 100644
--- a/cmds-device.c
+++ b/cmds-device.c
@@ -451,10 +451,17 @@ out:
 }
 
 const char * const cmd_device_usage_usage[] = {
-	"btrfs device usage [-b] <path> [<path>..]",
-	"Show which chunks are in a device.",
-	"",
-	"-b\tSet byte as unit",
+	"btrfs device usage [options] <path> [<path>..]",
+	"Show detailed information about internal allocations in devices.",
+	"-b|--raw           raw numbers in bytes",
+	"-h                 human friendly numbers, base 1024 (default)",
+	"-H                 human friendly numbers, base 1000",
+	"--iec              use 1024 as a base (KiB, MiB, GiB, TiB)",
+	"--si               use 1000 as a base (kB, MB, GB, TB)",
+	"-k|--kbytes        show sizes in KiB, or kB with --si",
+	"-m|--mbytes        show sizes in MiB, or MB with --si",
+	"-g|--gbytes        show sizes in GiB, or GB with --si",
+	"-t|--tbytes        show sizes in TiB, or TB with --si",
 	NULL
 };
 
@@ -489,21 +496,54 @@ out:
 
 int cmd_device_usage(int argc, char **argv)
 {
-
-	int mode = UNITS_HUMAN;
+	unsigned unit_mode = UNITS_DEFAULT;
 	int ret = 0;
 	int	i, more_than_one = 0;
 
 	optind = 1;
 	while (1) {
-		int c = getopt(argc, argv, "b");
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
+		int c = getopt_long(argc, argv, "bhHkmgt", long_options,
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
 		default:
 			usage(cmd_device_usage_usage);
@@ -527,7 +567,7 @@ int cmd_device_usage(int argc, char **argv)
 			goto out;
 		}
 
-		ret = _cmd_device_usage(fd, argv[i], mode);
+		ret = _cmd_device_usage(fd, argv[i], unit_mode);
 		close_file_or_dir(fd, dirstream);
 
 		if (ret)
-- 
2.1.3

