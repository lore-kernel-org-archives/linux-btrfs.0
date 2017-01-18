Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:49162 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751517AbdARCON (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 17 Jan 2017 21:14:13 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id C6955AC0D
        for <linux-btrfs@vger.kernel.org>; Wed, 18 Jan 2017 01:56:48 +0000 (UTC)
From: jeffm@suse.com
To: linux-btrfs@vger.kernel.org
Cc: Jeff Mahoney <jeffm@suse.com>
Subject: [PATCH 2/2] btrfs-progs: quota: Add -W option to rescan to wait without starting rescan
Date: Tue, 17 Jan 2017 20:56:40 -0500
Message-Id: <1484704600-16079-2-git-send-email-jeffm@suse.com>
In-Reply-To: <1484704600-16079-1-git-send-email-jeffm@suse.com>
References: <1484704600-16079-1-git-send-email-jeffm@suse.com>
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
index 33c3bfd..7b29a97 100644
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
index f9b422d..a6df839 100644
--- a/cmds-quota.c
+++ b/cmds-quota.c
@@ -121,14 +121,20 @@ static int cmd_quota_rescan(int argc, char **argv)
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
@@ -136,8 +142,9 @@ static int cmd_quota_rescan(int argc, char **argv)
 		}
 	}
 
-	if (ioctlnum != BTRFS_IOC_QUOTA_RESCAN && wait_for_completion) {
-		error("switch -w cannot be used with -s");
+	if (ioctlnum == BTRFS_IOC_QUOTA_RESCAN_STATUS && wait_for_completion) {
+		error("switch -%c cannot be used with -s",
+		      ioctlnum ? 'w' : 'W');
 		return 1;
 	}
 
@@ -151,8 +158,10 @@ static int cmd_quota_rescan(int argc, char **argv)
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
@@ -169,7 +178,7 @@ static int cmd_quota_rescan(int argc, char **argv)
 		return 0;
 	}
 
-	if (ret == 0) {
+	if (ioctlnum == BTRFS_IOC_QUOTA_RESCAN && ret == 0) {
 		printf("quota rescan started\n");
 		fflush(stdout);
 	} else if (ret < 0 && (!wait_for_completion || e != EINPROGRESS)) {
-- 
2.7.1

