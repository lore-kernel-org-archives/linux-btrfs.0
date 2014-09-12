Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:43031 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751217AbaILBQ1 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 11 Sep 2014 21:16:27 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s8C1GYcD010489
	for <linux-btrfs@vger.kernel.org>; Fri, 12 Sep 2014 09:16:34 +0800
From: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
Subject: [PATCH v2] btrfs-progs: deal with conflict options for btrfs fi show
Date: Fri, 12 Sep 2014 09:15:41 +0800
Message-ID: <1410484541-16422-1-git-send-email-guihc.fnst@cn.fujitsu.com>
In-Reply-To: <1410412751-9277-1-git-send-email-guihc.fnst@cn.fujitsu.com>
References: <1410412751-9277-1-git-send-email-guihc.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

For btrfs fi show, -d|--all-devices & -m|--mounted will
overwrite each other, so if specified both, let the user
know that he should not use them at the same time.

Signed-off-by: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
---
changelog:
	v1->v2: add option conflict descriptions to manpage and usage.
---
 Documentation/btrfs-filesystem.txt |  9 ++++++---
 cmds-filesystem.c                  | 12 ++++++++++--
 2 files changed, 16 insertions(+), 5 deletions(-)

diff --git a/Documentation/btrfs-filesystem.txt b/Documentation/btrfs-filesystem.txt
index c9c0b00..d3d2dcc 100644
--- a/Documentation/btrfs-filesystem.txt
+++ b/Documentation/btrfs-filesystem.txt
@@ -20,15 +20,18 @@ SUBCOMMAND
 *df* <path> [<path>...]::
 Show space usage information for a mount point.
 
-*show* [--mounted|--all-devices|<path>|<uuid>|<device>|<label>]::
+*show* [-m|--mounted|-d|--all-devices|<path>|<uuid>|<device>|<label>]::
 Show the btrfs filesystem with some additional info.
 +
 If no option nor <path>|<uuid>|<device>|<label> is passed, btrfs shows
 information of all the btrfs filesystem both mounted and unmounted.
-If '--mounted' is passed, it would probe btrfs kernel to list mounted btrfs
+If '-m|--mounted' is passed, it would probe btrfs kernel to list mounted btrfs
 filesystem(s);
-If '--all-devices' is passed, all the devices under /dev are scanned;
+If '-d|--all-devices' is passed, all the devices under /dev are scanned;
 otherwise the devices list is extracted from the /proc/partitions file.
+Don't combine -m|--mounted and -d|--all-devices, because these two options
+will overwrite each other, and only one scan way will be adopted,
+probe the kernel to scan or scan devices under /dev.
 
 *sync* <path>::
 Force a sync for the filesystem identified by <path>.
diff --git a/cmds-filesystem.c b/cmds-filesystem.c
index 69c1ca5..51c4c55 100644
--- a/cmds-filesystem.c
+++ b/cmds-filesystem.c
@@ -495,6 +495,7 @@ static const char * const cmd_show_usage[] = {
 	"-d|--all-devices   show only disks under /dev containing btrfs filesystem",
 	"-m|--mounted       show only mounted btrfs",
 	"If no argument is given, structure of all present filesystems is shown.",
+	"Don't combine -d|--all-devices and -m|--mounted, refer to manpage for details.",
 	NULL
 };
 
@@ -526,16 +527,23 @@ static int cmd_show(int argc, char **argv)
 			break;
 		switch (c) {
 		case 'd':
-			where = BTRFS_SCAN_PROC;
+			where &= ~BTRFS_SCAN_LBLKID;
+			where |= BTRFS_SCAN_PROC;
 			break;
 		case 'm':
-			where = BTRFS_SCAN_MOUNTED;
+			where &= ~BTRFS_SCAN_LBLKID;
+			where |= BTRFS_SCAN_MOUNTED;
 			break;
 		default:
 			usage(cmd_show_usage);
 		}
 	}
 
+	if ((where & BTRFS_SCAN_PROC) && (where & BTRFS_SCAN_MOUNTED)) {
+		fprintf(stderr, "Don't use -d|--all-devices and -m|--mounted options at the same time.\n");
+		usage(cmd_show_usage);
+	}
+
 	if (check_argc_max(argc, optind + 1))
 		usage(cmd_show_usage);
 
-- 
1.8.1.4

