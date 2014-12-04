Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f176.google.com ([209.85.212.176]:32871 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932455AbaLDSYp (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 4 Dec 2014 13:24:45 -0500
Received: by mail-wi0-f176.google.com with SMTP id ex7so35665456wid.3
        for <linux-btrfs@vger.kernel.org>; Thu, 04 Dec 2014 10:24:44 -0800 (PST)
From: Goffredo Baroncelli <kreijack@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Goffredo Baroncelli <kreijack@inwind.it>
Subject: [PATCH 2/5] 'btrfs device scan' skips lvm snapshots.
Date: Thu,  4 Dec 2014 19:24:27 +0100
Message-Id: <1417717470-6298-3-git-send-email-kreijack@inwind.it>
In-Reply-To: <1417717470-6298-1-git-send-email-kreijack@inwind.it>
References: <1417717470-6298-1-git-send-email-kreijack@inwind.it>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

LVM snapshots create a problem to the btrfs devices management.
BTRFS assumes that each device has an unique 'device UUID'.
A LVM snapshot breaks this assumption.

With this patch, 'btrfs device scan' skips LVM snapshot.
If you need to consider a LVM snapshot you have to pass the '-s' switch
ot set the environment variable BTRFS_SKIP_LVM_SNAPSHOT to "no".

Signed-off-by: Goffredo Baroncelli <kreijack@inwind.it>
---
 cmds-device.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/cmds-device.c b/cmds-device.c
index 6cd41e1..580879c 100644
--- a/cmds-device.c
+++ b/cmds-device.c
@@ -197,9 +197,10 @@ static int cmd_rm_dev(int argc, char **argv)
 }
 
 static const char * const cmd_scan_dev_usage[] = {
-	"btrfs device scan [(-d|--all-devices)|<device> [<device>...]]",
+	"btrfs device scan [-s][(-d|--all-devices)|<device> [<device>...]]",
 	"Scan devices for a btrfs filesystem",
 	" -d|--all-devices (deprecated)",
+	" -s                               don't skip lvm snapshot\n",
 	NULL
 };
 
@@ -209,6 +210,7 @@ static int cmd_scan_dev(int argc, char **argv)
 	int devstart = 1;
 	int all = 0;
 	int ret = 0;
+	int skip_snapshot = btrfs_scan_get_skip_lvm_snapshot();
 
 	optind = 1;
 	while (1) {
@@ -217,7 +219,7 @@ static int cmd_scan_dev(int argc, char **argv)
 			{ "all-devices", no_argument, NULL, 'd'},
 			{ 0, 0, 0, 0 },
 		};
-		int c = getopt_long(argc, argv, "d", long_options,
+		int c = getopt_long(argc, argv, "sd", long_options,
 				    &long_index);
 		if (c < 0)
 			break;
@@ -225,6 +227,9 @@ static int cmd_scan_dev(int argc, char **argv)
 		case 'd':
 			all = 1;
 			break;
+		case 's':
+			skip_snapshot = 0;
+			break;
 		default:
 			usage(cmd_scan_dev_usage);
 		}
@@ -261,6 +266,12 @@ static int cmd_scan_dev(int argc, char **argv)
 			ret = 1;
 			goto out;
 		}
+
+		if (skip_snapshot && is_low_priority_device(path)) {
+			fprintf(stderr, "WARNING: skip device '%s' because it is a snapshot\n",
+				argv[i]);
+			continue;
+		}
 		printf("Scanning for Btrfs filesystems in '%s'\n", path);
 		if (btrfs_register_one_device(path) != 0) {
 			ret = 1;
-- 
2.1.3

