Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:45298 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753012Ab3I0RaY (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 27 Sep 2013 13:30:24 -0400
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH v2] btrfs-progs: device add should check existing FS before adding
Date: Sat, 28 Sep 2013 01:30:05 +0800
Message-Id: <1380303005-10164-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

as of now, when 'btrfs device add' adds a device it doesn't
check if the given device contains an existing FS. This
patch will change that to check the same. which when true
add will fail, and ask user to use -f option to overwrite.

further, since now we have test_dev_for_mkfs() function
to check if a disk can be used, so this patch will also
use this function to test the given device before adding.

v2: rebase on 20130920, update man page and review comments

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 cmds-device.c  | 36 +++++++++++-------------------------
 man/btrfs.8.in |  6 ++++--
 2 files changed, 15 insertions(+), 27 deletions(-)

diff --git a/cmds-device.c b/cmds-device.c
index 12c802e..7cfc347 100644
--- a/cmds-device.c
+++ b/cmds-device.c
@@ -40,6 +40,7 @@ static const char * const cmd_add_dev_usage[] = {
 	"btrfs device add [options] <device> [<device>...] <path>",
 	"Add a device to a filesystem",
 	"-K|--nodiscard    do not perform whole device TRIM",
+	"-f|--force        force overwrite existing filesystem on the disk",
 	NULL
 };
 
@@ -49,14 +50,17 @@ static int cmd_add_dev(int argc, char **argv)
 	int	i, fdmnt, ret=0, e;
 	DIR	*dirstream = NULL;
 	int discard = 1;
+	int force = 0;
+	char estr[100];
 
 	while (1) {
 		int long_index;
 		static struct option long_options[] = {
 			{ "nodiscard", optional_argument, NULL, 'K'},
+			{ "force", no_argument, NULL, 'f'},
 			{ 0, 0, 0, 0 }
 		};
-		int c = getopt_long(argc, argv, "K", long_options,
+		int c = getopt_long(argc, argv, "Kf", long_options,
 					&long_index);
 		if (c < 0)
 			break;
@@ -64,6 +68,9 @@ static int cmd_add_dev(int argc, char **argv)
 		case 'K':
 			discard = 0;
 			break;
+		case 'f':
+			force = 1;
+			break;
 		default:
 			usage(cmd_add_dev_usage);
 		}
@@ -86,19 +93,11 @@ static int cmd_add_dev(int argc, char **argv)
 		struct btrfs_ioctl_vol_args ioctl_args;
 		int	devfd, res;
 		u64 dev_block_count = 0;
-		struct stat st;
 		int mixed = 0;
 
-		res = check_mounted(argv[i]);
-		if (res < 0) {
-			fprintf(stderr, "error checking %s mount status\n",
-				argv[i]);
-			ret++;
-			continue;
-		}
-		if (res == 1) {
-			fprintf(stderr, "%s is mounted\n", argv[i]);
-			ret++;
+		res = test_dev_for_mkfs(argv[i], force, estr);
+		if (res) {
+			fprintf(stderr, "%s", estr);
 			continue;
 		}
 
@@ -108,19 +107,6 @@ static int cmd_add_dev(int argc, char **argv)
 			ret++;
 			continue;
 		}
-		res = fstat(devfd, &st);
-		if (res) {
-			fprintf(stderr, "ERROR: Unable to stat '%s'\n", argv[i]);
-			close(devfd);
-			ret++;
-			continue;
-		}
-		if (!S_ISBLK(st.st_mode)) {
-			fprintf(stderr, "ERROR: '%s' is not a block device\n", argv[i]);
-			close(devfd);
-			ret++;
-			continue;
-		}
 
 		res = btrfs_prepare_device(devfd, argv[i], 1, &dev_block_count,
 					   0, &mixed, discard);
diff --git a/man/btrfs.8.in b/man/btrfs.8.in
index 60e02bb..a65ed93 100644
--- a/man/btrfs.8.in
+++ b/man/btrfs.8.in
@@ -47,7 +47,7 @@ btrfs \- control a btrfs filesystem
 \fBbtrfs\fP \fB[filesystem] balance status\fP [-v] \fI<path>\fP
 .PP
 .PP
-\fBbtrfs\fP \fBdevice add\fP [-K] \fI<device>\fP [\fI<device>...\fP] \fI<path>\fP
+\fBbtrfs\fP \fBdevice add\fP [-Kf] \fI<device>\fP [\fI<device>...\fP] \fI<path>\fP
 .PP
 \fBbtrfs\fP \fBdevice delete\fP \fI<device>\fP [\fI<device>...\fP] \fI<path>\fP
 .PP
@@ -390,7 +390,7 @@ be verbose
 .RE
 .TP
 
-\fBdevice add\fR\fI [-K] <dev> \fP[\fI<dev>...\fP] \fI<path>\fR
+\fBdevice add\fR\fI [-Kf] <dev> \fP[\fI<dev>...\fP] \fI<path>\fR
 Add device(s) to the filesystem identified by \fI<path>\fR.
 If applicable, a whole device discard (TRIM) operation is performed.
 .RS
@@ -398,6 +398,8 @@ If applicable, a whole device discard (TRIM) operation is performed.
 \fIOptions\fR
 .IP "\fB-K|--nodiscard\fP" 5
 do not perform discard by default
+.IP "\fB-f|--force\fP" 5
+force overwrite of existing filesystem on the given disk(s)
 .RE
 .TP
 
-- 
1.8.4.rc4.1.g0d8beaa

