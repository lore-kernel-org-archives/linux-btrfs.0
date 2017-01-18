Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:49161 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751518AbdARCOM (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 17 Jan 2017 21:14:12 -0500
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id A71A7AB1D
        for <linux-btrfs@vger.kernel.org>; Wed, 18 Jan 2017 01:56:48 +0000 (UTC)
From: jeffm@suse.com
To: linux-btrfs@vger.kernel.org
Cc: Jeff Mahoney <jeffm@suse.com>
Subject: [PATCH 1/2] btrfs-progs: quota: fix printing during wait mode
Date: Tue, 17 Jan 2017 20:56:39 -0500
Message-Id: <1484704600-16079-1-git-send-email-jeffm@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Jeff Mahoney <jeffm@suse.com>

If we call "btrfs quota rescan -w", it will attempt to start the rescan
operation, wait for it, and then print the "quota rescan started" message.
The wait could last an arbitrary amount of time, so printing it after
the wait isn't very helpful.

This patch reworks how we print the rescan started message as well as the
printing of the messages, including adding an error message for status
query failures (which could be EPERM/EFAULT/ENOMEM, not just no rescan
in progress) and wait failures.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 cmds-quota.c | 40 +++++++++++++++++++++++++++-------------
 1 file changed, 27 insertions(+), 13 deletions(-)

diff --git a/cmds-quota.c b/cmds-quota.c
index 75c032b..f9b422d 100644
--- a/cmds-quota.c
+++ b/cmds-quota.c
@@ -154,28 +154,42 @@ static int cmd_quota_rescan(int argc, char **argv)
 	ret = ioctl(fd, ioctlnum, &args);
 	e = errno;
 
-	if (wait_for_completion && (ret == 0 || e == EINPROGRESS)) {
-		ret = ioctl(fd, BTRFS_IOC_QUOTA_RESCAN_WAIT, &args);
-		e = errno;
-	}
-	close_file_or_dir(fd, dirstream);
-
-	if (ioctlnum == BTRFS_IOC_QUOTA_RESCAN) {
+	if (ioctlnum == BTRFS_IOC_QUOTA_RESCAN_STATUS) {
+		close_file_or_dir(fd, dirstream);
 		if (ret < 0) {
-			error("quota rescan failed: %s", strerror(e));
+			error("could not obtain quota rescan status: %s",
+			      strerror(e));
 			return 1;
-		}  else {
-			printf("quota rescan started\n");
 		}
-	} else {
-		if (!args.flags) {
+		if (!args.flags)
 			printf("no rescan operation in progress\n");
-		} else {
+		else
 			printf("rescan operation running (current key %lld)\n",
 				args.progress);
+		return 0;
+	}
+
+	if (ret == 0) {
+		printf("quota rescan started\n");
+		fflush(stdout);
+	} else if (ret < 0 && (!wait_for_completion || e != EINPROGRESS)) {
+		error("quota rescan failed: %s", strerror(e));
+		close_file_or_dir(fd, dirstream);
+		return 1;
+	}
+
+	if (wait_for_completion) {
+		ret = ioctl(fd, BTRFS_IOC_QUOTA_RESCAN_WAIT, &args);
+		e = errno;
+		if (ret < 0) {
+			error("quota rescan wait failed: %s",
+			      strerror(e));
+			close_file_or_dir(fd, dirstream);
+			return 1;
 		}
 	}
 
+	close_file_or_dir(fd, dirstream);
 	return 0;
 }
 
-- 
2.7.1

