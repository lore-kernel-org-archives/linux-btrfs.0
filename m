Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f194.google.com ([209.85.223.194]:34140 "EHLO
        mail-io0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751187AbcLBNa2 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 2 Dec 2016 08:30:28 -0500
Received: by mail-io0-f194.google.com with SMTP id r94so7738600ioe.1
        for <linux-btrfs@vger.kernel.org>; Fri, 02 Dec 2016 05:30:28 -0800 (PST)
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Cc: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Subject: [PATCH v2] btrfs-progs: add dev stats returncode option
Date: Fri,  2 Dec 2016 08:30:08 -0500
Message-Id: <20161202133008.72232-1-ahferroin7@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Currently, `btrfs device stats` returns non-zero only when there was an
error getting the counter values.  This is fine for when it gets run by a
user directly, but is a serious pain when trying to use it in a script or
for monitoring since you need to parse the (not at all machine friendly)
output to check the counter values.

This patch adds an option ('-s') which causes `btrfs device stats`
to set bit 6 in the return code if any of the counters are non-zero.
This greatly simplifies checking from a script or monitoring software if
any errors have been recorded.  In the event that this switch is passed
and an error occurs reading the stats, the return code will have bit
0 set (so if there are errors reading counters, and the counters which
were read were non-zero, the return value will be 65).

Signed-off-by: Austin S. Hemmelgarn <ahferroin7@gmail.com>
---
Changes since v1:
 * Switched to using bit 6 instead of bit 7 so we don't stomp on Bash's
   manipulation of return codes.  Thanks to Mike Fleetwood for reminding
   me about this.

 Documentation/btrfs-device.asciidoc |  8 +++++++-
 cmds-device.c                       | 39 ++++++++++++++++++++++++++++++-------
 2 files changed, 39 insertions(+), 8 deletions(-)

diff --git a/Documentation/btrfs-device.asciidoc b/Documentation/btrfs-device.asciidoc
index 239c99b..d398b6d 100644
--- a/Documentation/btrfs-device.asciidoc
+++ b/Documentation/btrfs-device.asciidoc
@@ -98,7 +98,7 @@ remain as such. Reloading the kernel module will drop this information. There's
 an alternative way of mounting multiple-device filesystem without the need for
 prior scanning. See the mount option 'device'.
 
-*stats* [-z] <path>|<device>::
+*stats* [-zs] <path>|<device>::
 Read and print the device IO error statistics for all devices of the given
 filesystem identified by <path> or for a single <device>. See section *DEVICE
 STATS* for more information.
@@ -108,6 +108,9 @@ STATS* for more information.
 -z::::
 Print the stats and reset the values to zero afterwards.
 
+-s::::
+Set bit 6 of the return-code if any error statistics are non-zero.
+
 *usage* [options] <path> [<path>...]::
 Show detailed information about internal allocations in devices.
 +
@@ -231,6 +234,9 @@ EXIT STATUS
 *btrfs device* returns a zero exit status if it succeeds. Non zero is
 returned in case of failure.
 
+If the '-s' option is used, *btrfs device stats* will add 64 to the
+exit status if any of the error counters is non-zero.
+
 AVAILABILITY
 ------------
 *btrfs* is part of btrfs-progs.
diff --git a/cmds-device.c b/cmds-device.c
index fa0830f..392e37c 100644
--- a/cmds-device.c
+++ b/cmds-device.c
@@ -376,6 +376,7 @@ static const char * const cmd_device_stats_usage[] = {
 	"Show current device IO stats.",
 	"",
 	"-z                     show current stats and reset values to zero",
+	"-s                     return non-zero if any stat counter is not zero",
 	NULL
 };
 
@@ -389,14 +390,18 @@ static int cmd_device_stats(int argc, char **argv)
 	int i;
 	int c;
 	int err = 0;
+	int status = 0;
 	__u64 flags = 0;
 	DIR *dirstream = NULL;
 
-	while ((c = getopt(argc, argv, "z")) != -1) {
+	while ((c = getopt(argc, argv, "zs")) != -1) {
 		switch (c) {
 		case 'z':
 			flags = BTRFS_DEV_STATS_RESET;
 			break;
+		case 's':
+			status = 1;
+			break;
 		case '?':
 		default:
 			usage(cmd_device_stats_usage);
@@ -440,7 +445,7 @@ static int cmd_device_stats(int argc, char **argv)
 		if (ioctl(fdmnt, BTRFS_IOC_GET_DEV_STATS, &args) < 0) {
 			error("DEV_STATS ioctl failed on %s: %s",
 			      path, strerror(errno));
-			err = 1;
+			err |= 1;
 		} else {
 			char *canonical_path;
 
@@ -457,31 +462,51 @@ static int cmd_device_stats(int argc, char **argv)
 					 "devid:%llu", args.devid);
 			}
 
-			if (args.nr_items >= BTRFS_DEV_STAT_WRITE_ERRS + 1)
+			if (args.nr_items >= BTRFS_DEV_STAT_WRITE_ERRS + 1) {
 				printf("[%s].write_io_errs   %llu\n",
 				       canonical_path,
 				       (unsigned long long) args.values[
 					BTRFS_DEV_STAT_WRITE_ERRS]);
-			if (args.nr_items >= BTRFS_DEV_STAT_READ_ERRS + 1)
+				if ((status == 1) && (args.values[BTRFS_DEV_STAT_WRITE_ERRS] > 0)) {
+					err |= 64;
+				}
+			}
+			if (args.nr_items >= BTRFS_DEV_STAT_READ_ERRS + 1) {
 				printf("[%s].read_io_errs    %llu\n",
 				       canonical_path,
 				       (unsigned long long) args.values[
 					BTRFS_DEV_STAT_READ_ERRS]);
-			if (args.nr_items >= BTRFS_DEV_STAT_FLUSH_ERRS + 1)
+				if ((status == 1) && (args.values[BTRFS_DEV_STAT_READ_ERRS] > 0)) {
+					err |= 64;
+				}
+			}
+			if (args.nr_items >= BTRFS_DEV_STAT_FLUSH_ERRS + 1) {
 				printf("[%s].flush_io_errs   %llu\n",
 				       canonical_path,
 				       (unsigned long long) args.values[
 					BTRFS_DEV_STAT_FLUSH_ERRS]);
-			if (args.nr_items >= BTRFS_DEV_STAT_CORRUPTION_ERRS + 1)
+				if ((status == 1) && (args.values[BTRFS_DEV_STAT_FLUSH_ERRS] > 0)) {
+					err |= 64;
+				}
+			}
+			if (args.nr_items >= BTRFS_DEV_STAT_CORRUPTION_ERRS + 1) {
 				printf("[%s].corruption_errs %llu\n",
 				       canonical_path,
 				       (unsigned long long) args.values[
 					BTRFS_DEV_STAT_CORRUPTION_ERRS]);
-			if (args.nr_items >= BTRFS_DEV_STAT_GENERATION_ERRS + 1)
+				if ((status == 1) && (args.values[BTRFS_DEV_STAT_CORRUPTION_ERRS] > 0)) {
+					err |= 64;
+				}
+			}
+			if (args.nr_items >= BTRFS_DEV_STAT_GENERATION_ERRS + 1) {
 				printf("[%s].generation_errs %llu\n",
 				       canonical_path,
 				       (unsigned long long) args.values[
 					BTRFS_DEV_STAT_GENERATION_ERRS]);
+				if ((status == 1) && (args.values[BTRFS_DEV_STAT_GENERATION_ERRS] > 0)) {
+					err |= 64;
+				}
+			}
 
 			free(canonical_path);
 		}
-- 
2.11.0

