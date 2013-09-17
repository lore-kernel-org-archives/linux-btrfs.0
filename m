Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:59033 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752868Ab3IQOyP (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 17 Sep 2013 10:54:15 -0400
Received: from relay1.suse.de (unknown [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 35D36A5387
	for <linux-btrfs@vger.kernel.org>; Tue, 17 Sep 2013 16:54:14 +0200 (CEST)
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>
Subject: [PATCH 2/2] btrfs-progs: add nodiscard option to device add
Date: Tue, 17 Sep 2013 16:54:01 +0200
Message-Id: <2082ba8f6190a06da6832c93c0f96f4b1f1efd0b.1379429393.git.dsterba@suse.cz>
In-Reply-To: <cover.1379429392.git.dsterba@suse.cz>
References: <cover.1379429392.git.dsterba@suse.cz>
In-Reply-To: <cover.1379429392.git.dsterba@suse.cz>
References: <cover.1379429392.git.dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Same as for mkfs.

Signed-off-by: David Sterba <dsterba@suse.cz>
---
 cmds-device.c  | 34 +++++++++++++++++++++++++++++-----
 man/btrfs.8.in | 11 +++++++++--
 utils.c        |  2 ++
 3 files changed, 40 insertions(+), 7 deletions(-)

diff --git a/cmds-device.c b/cmds-device.c
index 800a050..12c802e 100644
--- a/cmds-device.c
+++ b/cmds-device.c
@@ -22,6 +22,7 @@
 #include <sys/ioctl.h>
 #include <errno.h>
 #include <sys/stat.h>
+#include <getopt.h>
 
 #include "kerncompat.h"
 #include "ctree.h"
@@ -36,8 +37,9 @@ static const char * const device_cmd_group_usage[] = {
 };
 
 static const char * const cmd_add_dev_usage[] = {
-	"btrfs device add <device> [<device>...] <path>",
+	"btrfs device add [options] <device> [<device>...] <path>",
 	"Add a device to a filesystem",
+	"-K|--nodiscard    do not perform whole device TRIM",
 	NULL
 };
 
@@ -46,11 +48,33 @@ static int cmd_add_dev(int argc, char **argv)
 	char	*mntpnt;
 	int	i, fdmnt, ret=0, e;
 	DIR	*dirstream = NULL;
+	int discard = 1;
+
+	while (1) {
+		int long_index;
+		static struct option long_options[] = {
+			{ "nodiscard", optional_argument, NULL, 'K'},
+			{ 0, 0, 0, 0 }
+		};
+		int c = getopt_long(argc, argv, "K", long_options,
+					&long_index);
+		if (c < 0)
+			break;
+		switch (c) {
+		case 'K':
+			discard = 0;
+			break;
+		default:
+			usage(cmd_add_dev_usage);
+		}
+	}
 
-	if (check_argc_min(argc, 3))
+	argc = argc - optind;
+
+	if (check_argc_min(argc, 2))
 		usage(cmd_add_dev_usage);
 
-	mntpnt = argv[argc - 1];
+	mntpnt = argv[optind + argc - 1];
 
 	fdmnt = open_file_or_dir(mntpnt, &dirstream);
 	if (fdmnt < 0) {
@@ -58,7 +82,7 @@ static int cmd_add_dev(int argc, char **argv)
 		return 1;
 	}
 
-	for (i = 1; i < argc - 1; i++ ){
+	for (i = optind; i < optind + argc - 1; i++){
 		struct btrfs_ioctl_vol_args ioctl_args;
 		int	devfd, res;
 		u64 dev_block_count = 0;
@@ -99,7 +123,7 @@ static int cmd_add_dev(int argc, char **argv)
 		}
 
 		res = btrfs_prepare_device(devfd, argv[i], 1, &dev_block_count,
-					   0, &mixed, 0);
+					   0, &mixed, discard);
 		if (res) {
 			fprintf(stderr, "ERROR: Unable to init '%s'\n", argv[i]);
 			close(devfd);
diff --git a/man/btrfs.8.in b/man/btrfs.8.in
index 61ffe8d..03126b4 100644
--- a/man/btrfs.8.in
+++ b/man/btrfs.8.in
@@ -47,7 +47,7 @@ btrfs \- control a btrfs filesystem
 \fBbtrfs\fP \fB[filesystem] balance status\fP [-v] \fI<path>\fP
 .PP
 .PP
-\fBbtrfs\fP \fBdevice add\fP \fI<device>\fP [\fI<device>...\fP] \fI<path>\fP
+\fBbtrfs\fP \fBdevice add\fP [-K] \fI<device>\fP [\fI<device>...\fP] \fI<path>\fP
 .PP
 \fBbtrfs\fP \fBdevice delete\fP \fI<device>\fP [\fI<device>...\fP] \fI<path>\fP
 .PP
@@ -386,8 +386,15 @@ be verbose
 .RE
 .TP
 
-\fBdevice add\fR\fI <dev> \fP[\fI<dev>...\fP] \fI<path>\fR
+\fBdevice add\fR\fI [-K] <dev> \fP[\fI<dev>...\fP] \fI<path>\fR
 Add device(s) to the filesystem identified by \fI<path>\fR.
+If applicable, a whole device discard (TRIM) operation is performed.
+.RS
+
+\fIOptions\fR
+.IP "\fB-K|--nodiscard\fP" 5
+do not perform discard by default
+.RE
 .TP
 
 \fBdevice delete\fR\fI <dev> \fP[\fI<dev>...\fP] \fI<path>\fR
diff --git a/utils.c b/utils.c
index bb1bcdb..68aa534 100644
--- a/utils.c
+++ b/utils.c
@@ -597,6 +597,8 @@ int btrfs_prepare_device(int fd, char *file, int zero_end, u64 *block_count_ret,
 	}
 
 	if (discard) {
+		fprintf(stderr, "Performing full device TRIM (%s) ...\n",
+				pretty_size(block_count));
 		/*
 		 * We intentionally ignore errors from the discard ioctl.  It is
 		 * not necessary for the mkfs functionality but just an optimization.
-- 
1.8.3.1

