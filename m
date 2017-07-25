Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:44799 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750839AbdGYUtS (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 25 Jul 2017 16:49:18 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 1FF72AEC0
        for <linux-btrfs@vger.kernel.org>; Tue, 25 Jul 2017 20:49:16 +0000 (UTC)
From: jeffm@suse.com
To: linux-btrfs@vger.kernel.org
Cc: Jeff Mahoney <jeffm@suse.com>
Subject: [PATCH] btrfs-progs: quota: Add -W option to rescan to wait without starting rescan
Date: Tue, 25 Jul 2017 16:49:51 -0400
Message-Id: <20170725204951.28014-1-jeffm@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Jeff Mahoney <jeffm@suse.com>

This patch adds a new -W option to wait for a rescan without starting a
new operation.  This is useful for things like xfstests where we want
do to do a "btrfs quota enable" and not continue until the subsequent
rescan has finished.

In addition to documenting the new option in the man page, I've cleaned
up the rescan entry to document the -w option a bit better.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 Documentation/btrfs-quota.asciidoc | 10 +++++++---
 cmds-quota.c                       | 21 +++++++++++++++------
 2 files changed, 22 insertions(+), 9 deletions(-)

diff --git a/Documentation/btrfs-quota.asciidoc b/Documentation/btrfs-quota.asciidoc
index ef2e5d3..16ba864 100644
--- a/Documentation/btrfs-quota.asciidoc
+++ b/Documentation/btrfs-quota.asciidoc
@@ -222,15 +222,19 @@ Disable subvolume quota support for a filesystem.
 *enable* <path>::
 Enable subvolume quota support for a filesystem.
 
-*rescan* [-s] <path>::
+*rescan* [-s|-w|-W] <path>::
 Trash all qgroup numbers and scan the metadata again with the current config.
 +
 `Options`
 +
 -s::::
-show status of a running rescan operation.
+Show status of a running rescan operation.
+
 -w::::
-wait for rescan operation to finish(can be already in progress).
+Start rescan operation and wait until it has finished before exiting.  If a rescan is already running, wait until it finishes and then exit without starting a new one.
+
+-W::::
+Wait for rescan operation to finish and then exit.  If a rescan is not already running, exit silently.
 
 EXIT STATUS
 -----------
diff --git a/cmds-quota.c b/cmds-quota.c
index 15bd4b9..43d184d 100644
--- a/cmds-quota.c
+++ b/cmds-quota.c
@@ -122,14 +122,20 @@ static int cmd_quota_rescan(int argc, char **argv)
 	int wait_for_completion = 0;
 
 	while (1) {
-		int c = getopt(argc, argv, "sw");
+		int c = getopt(argc, argv, "swW");
 		if (c < 0)
 			break;
 		switch (c) {
 		case 's':
 			ioctlnum = BTRFS_IOC_QUOTA_RESCAN_STATUS;
 			break;
+		case 'W':
+			ioctlnum = 0;
+			wait_for_completion = 1;
+			break;
 		case 'w':
+			/* Reset it in case the user did both -W and -w */
+			ioctlnum = BTRFS_IOC_QUOTA_RESCAN;
 			wait_for_completion = 1;
 			break;
 		default:
@@ -137,8 +143,9 @@ static int cmd_quota_rescan(int argc, char **argv)
 		}
 	}
 
-	if (ioctlnum != BTRFS_IOC_QUOTA_RESCAN && wait_for_completion) {
-		error("switch -w cannot be used with -s");
+	if (ioctlnum == BTRFS_IOC_QUOTA_RESCAN_STATUS && wait_for_completion) {
+		error("switch -%c cannot be used with -s",
+		      ioctlnum ? 'w' : 'W');
 		return 1;
 	}
 
@@ -152,8 +159,10 @@ static int cmd_quota_rescan(int argc, char **argv)
 	if (fd < 0)
 		return 1;
 
-	ret = ioctl(fd, ioctlnum, &args);
-	e = errno;
+	if (ioctlnum) {
+		ret = ioctl(fd, ioctlnum, &args);
+		e = errno;
+	}
 
 	if (ioctlnum == BTRFS_IOC_QUOTA_RESCAN_STATUS) {
 		close_file_or_dir(fd, dirstream);
@@ -170,7 +179,7 @@ static int cmd_quota_rescan(int argc, char **argv)
 		return 0;
 	}
 
-	if (ret == 0) {
+	if (ioctlnum == BTRFS_IOC_QUOTA_RESCAN && ret == 0) {
 		printf("quota rescan started\n");
 		fflush(stdout);
 	} else if (ret < 0 && (!wait_for_completion || e != EINPROGRESS)) {
-- 
2.11.0

