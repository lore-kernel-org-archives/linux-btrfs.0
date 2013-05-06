Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from xp-ob.rzone.de ([81.169.146.139]:11336 "EHLO xp-ob.rzone.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755802Ab3EFTPV (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 6 May 2013 15:15:21 -0400
From: Jan Schmidt <list.btrfs@jan-o-sch.net>
To: chris.mason@fusionio.com, linux-btrfs@vger.kernel.org
Subject: [PATCH 2/2] Btrfs-progs: added "btrfs quota rescan" -w switch (wait)
Date: Mon,  6 May 2013 21:15:18 +0200
Message-Id: <1367867718-5201-1-git-send-email-list.btrfs@jan-o-sch.net>
In-Reply-To: <1367867657-4630-1-git-send-email-list.btrfs@jan-o-sch.net>
References: <1367867657-4630-1-git-send-email-list.btrfs@jan-o-sch.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

With -w one can wait for a rescan operation to finish. It can be used when
starting a rescan operation or later to wait for the currently running
rescan operation to finish. Waiting is interruptible.

Signed-off-by: Jan Schmidt <list.btrfs@jan-o-sch.net>
---
 cmds-quota.c |   19 +++++++++++++++++--
 ioctl.h      |    1 +
 2 files changed, 18 insertions(+), 2 deletions(-)

diff --git a/cmds-quota.c b/cmds-quota.c
index 1169772..6557e83 100644
--- a/cmds-quota.c
+++ b/cmds-quota.c
@@ -90,10 +90,11 @@ static int cmd_quota_disable(int argc, char **argv)
 }
 
 static const char * const cmd_quota_rescan_usage[] = {
-	"btrfs quota rescan [-s] <path>",
+	"btrfs quota rescan [-sw] <path>",
 	"Trash all qgroup numbers and scan the metadata again with the current config.",
 	"",
 	"-s   show status of a running rescan operation",
+	"-w   wait for rescan operation to finish (can be already in progress)",
 	NULL
 };
 
@@ -105,21 +106,30 @@ static int cmd_quota_rescan(int argc, char **argv)
 	char *path = NULL;
 	struct btrfs_ioctl_quota_rescan_args args;
 	int ioctlnum = BTRFS_IOC_QUOTA_RESCAN;
+	int wait_for_completion = 0;
 
 	optind = 1;
 	while (1) {
-		int c = getopt(argc, argv, "s");
+		int c = getopt(argc, argv, "sw");
 		if (c < 0)
 			break;
 		switch (c) {
 		case 's':
 			ioctlnum = BTRFS_IOC_QUOTA_RESCAN_STATUS;
 			break;
+		case 'w':
+			wait_for_completion = 1;
+			break;
 		default:
 			usage(cmd_quota_rescan_usage);
 		}
 	}
 
+	if (ioctlnum != BTRFS_IOC_QUOTA_RESCAN && wait_for_completion) {
+		fprintf(stderr, "ERROR: -w cannot be used with -s\n");
+		return 12;
+	}
+
 	if (check_argc_exact(argc - optind, 1))
 		usage(cmd_quota_rescan_usage);
 
@@ -134,6 +144,11 @@ static int cmd_quota_rescan(int argc, char **argv)
 
 	ret = ioctl(fd, ioctlnum, &args);
 	e = errno;
+
+	if (wait_for_completion && (ret == 0 || e == EINPROGRESS)) {
+		ret = ioctl(fd, BTRFS_IOC_QUOTA_RESCAN_WAIT, &args);
+		e = errno;
+	}
 	close(fd);
 
 	if (ioctlnum == BTRFS_IOC_QUOTA_RESCAN) {
diff --git a/ioctl.h b/ioctl.h
index abe6dd4..c260bbf 100644
--- a/ioctl.h
+++ b/ioctl.h
@@ -529,6 +529,7 @@ struct btrfs_ioctl_clone_range_args {
 			       struct btrfs_ioctl_quota_rescan_args)
 #define BTRFS_IOC_QUOTA_RESCAN_STATUS _IOR(BTRFS_IOCTL_MAGIC, 45, \
 			       struct btrfs_ioctl_quota_rescan_args)
+#define BTRFS_IOC_QUOTA_RESCAN_WAIT _IO(BTRFS_IOCTL_MAGIC, 46)
 #define BTRFS_IOC_GET_FSLABEL _IOR(BTRFS_IOCTL_MAGIC, 49, \
 				   char[BTRFS_LABEL_SIZE])
 #define BTRFS_IOC_SET_FSLABEL _IOW(BTRFS_IOCTL_MAGIC, 50, \
-- 
1.7.1

