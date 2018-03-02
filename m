Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:60083 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1947443AbeCBSrP (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 2 Mar 2018 13:47:15 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id A9279AE87
        for <linux-btrfs@vger.kernel.org>; Fri,  2 Mar 2018 18:47:13 +0000 (UTC)
From: jeffm@suse.com
To: linux-btrfs@vger.kernel.org
Cc: Jeff Mahoney <jeffm@suse.com>
Subject: [PATCH 1/8] btrfs-progs: quota: Add -W option to rescan to wait without starting rescan
Date: Fri,  2 Mar 2018 13:46:57 -0500
Message-Id: <20180302184704.22399-2-jeffm@suse.com>
In-Reply-To: <20180302184704.22399-1-jeffm@suse.com>
References: <20180302184704.22399-1-jeffm@suse.com>
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
index 85ebf729..0b64a69b 100644
--- a/Documentation/btrfs-quota.asciidoc
+++ b/Documentation/btrfs-quota.asciidoc
@@ -238,15 +238,19 @@ Disable subvolume quota support for a filesystem.
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
index 745889d1..fe6376ac 100644
--- a/cmds-quota.c
+++ b/cmds-quota.c
@@ -120,14 +120,20 @@ static int cmd_quota_rescan(int argc, char **argv)
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
@@ -135,8 +141,9 @@ static int cmd_quota_rescan(int argc, char **argv)
 		}
 	}
 
-	if (ioctlnum != BTRFS_IOC_QUOTA_RESCAN && wait_for_completion) {
-		error("switch -w cannot be used with -s");
+	if (ioctlnum == BTRFS_IOC_QUOTA_RESCAN_STATUS && wait_for_completion) {
+		error("switch -%c cannot be used with -s",
+		      ioctlnum ? 'w' : 'W');
 		return 1;
 	}
 
@@ -150,8 +157,10 @@ static int cmd_quota_rescan(int argc, char **argv)
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
@@ -167,7 +176,7 @@ static int cmd_quota_rescan(int argc, char **argv)
 		return 0;
 	}
 
-	if (ret == 0) {
+	if (ioctlnum == BTRFS_IOC_QUOTA_RESCAN && ret == 0) {
 		printf("quota rescan started\n");
 		fflush(stdout);
 	} else if (ret < 0 && (!wait_for_completion || e != EINPROGRESS)) {
-- 
2.15.1

