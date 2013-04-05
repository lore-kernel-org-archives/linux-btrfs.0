Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from xp-ob.rzone.de ([81.169.146.141]:22186 "EHLO xp-ob.rzone.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751669Ab3DELoL (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 5 Apr 2013 07:44:11 -0400
From: Jan Schmidt <list.btrfs@jan-o-sch.net>
To: chris.mason@fusionio.com, linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs-progs: quota rescan
Date: Fri,  5 Apr 2013 13:44:06 +0200
Message-Id: <1365162246-21830-1-git-send-email-list.btrfs@jan-o-sch.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This adds the quota rescan command to be used if qgroup tracking should get
out of sync. Can also be used to query the status of a running rescan
operation.

Signed-off-by: Jan Schmidt <list.btrfs@jan-o-sch.net>
---
 cmds-quota.c |   63 +++++++++++++++++++++++++++++++++++++++++++++++++++++----
 ioctl.h      |   46 ++++++++++++++++++++++++-----------------
 2 files changed, 85 insertions(+), 24 deletions(-)

diff --git a/cmds-quota.c b/cmds-quota.c
index 8481514..1169772 100644
--- a/cmds-quota.c
+++ b/cmds-quota.c
@@ -90,17 +90,70 @@ static int cmd_quota_disable(int argc, char **argv)
 }
 
 static const char * const cmd_quota_rescan_usage[] = {
-	"btrfs quota rescan <path>",
-	"Rescan the subvolume for a changed quota setting.",
+	"btrfs quota rescan [-s] <path>",
+	"Trash all qgroup numbers and scan the metadata again with the current config.",
+	"",
+	"-s   show status of a running rescan operation",
 	NULL
 };
 
 static int cmd_quota_rescan(int argc, char **argv)
 {
-	int ret = quota_ctl(BTRFS_QUOTA_CTL_RESCAN, argc, argv);
-	if (ret < 0)
+	int ret = 0;
+	int fd;
+	int e;
+	char *path = NULL;
+	struct btrfs_ioctl_quota_rescan_args args;
+	int ioctlnum = BTRFS_IOC_QUOTA_RESCAN;
+
+	optind = 1;
+	while (1) {
+		int c = getopt(argc, argv, "s");
+		if (c < 0)
+			break;
+		switch (c) {
+		case 's':
+			ioctlnum = BTRFS_IOC_QUOTA_RESCAN_STATUS;
+			break;
+		default:
+			usage(cmd_quota_rescan_usage);
+		}
+	}
+
+	if (check_argc_exact(argc - optind, 1))
 		usage(cmd_quota_rescan_usage);
-	return ret;
+
+	memset(&args, 0, sizeof(args));
+
+	path = argv[optind];
+	fd = open_file_or_dir(path);
+	if (fd < 0) {
+		fprintf(stderr, "ERROR: can't access '%s'\n", path);
+		return 12;
+	}
+
+	ret = ioctl(fd, ioctlnum, &args);
+	e = errno;
+	close(fd);
+
+	if (ioctlnum == BTRFS_IOC_QUOTA_RESCAN) {
+		if (ret < 0) {
+			fprintf(stderr, "ERROR: quota rescan failed: "
+				"%s\n", strerror(e));
+			return 30;
+		}  else {
+			printf("quota rescan started\n");
+		}
+	} else {
+		if (!args.flags) {
+			printf("no rescan operation in progress\n");
+		} else {
+			printf("rescan operation running (current key %lld)\n",
+				args.progress);
+		}
+	}
+
+	return 0;
 }
 
 const struct cmd_group quota_cmd_group = {
diff --git a/ioctl.h b/ioctl.h
index e841913..1ee631a 100644
--- a/ioctl.h
+++ b/ioctl.h
@@ -384,25 +384,6 @@ struct btrfs_ioctl_send_args {
 	__u64 reserved[4];		/* in */
 };
 
-#define BTRFS_QUOTA_CTL_ENABLE	1
-#define BTRFS_QUOTA_CTL_DISABLE	2
-#define BTRFS_QUOTA_CTL_RESCAN	3
-struct btrfs_ioctl_quota_ctl_args {
-	__u64 cmd;
-	__u64 status;
-};
-
-struct btrfs_ioctl_qgroup_assign_args {
-	__u64 assign;
-	__u64 src;
-	__u64 dst;
-};
-
-struct btrfs_ioctl_qgroup_create_args {
-	__u64 create;
-	__u64 qgroupid;
-};
-
 enum btrfs_dev_stat_values {
 	/* disk I/O failure stats */
 	BTRFS_DEV_STAT_WRITE_ERRS, /* EIO or EREMOTEIO from lower layers */
@@ -437,6 +418,29 @@ struct btrfs_ioctl_get_dev_stats {
 };
 
 /* BTRFS_IOC_SNAP_CREATE is no longer used by the btrfs command */
+#define BTRFS_QUOTA_CTL_ENABLE	1
+#define BTRFS_QUOTA_CTL_DISABLE	2
+/* 3 has formerly been reserved for BTRFS_QUOTA_CTL_RESCAN */
+struct btrfs_ioctl_quota_ctl_args {
+	__u64 cmd;
+	__u64 status;
+};
+
+struct btrfs_ioctl_quota_rescan_args {
+	__u64	flags;
+	__u64   progress;
+};
+
+struct btrfs_ioctl_qgroup_assign_args {
+	__u64 assign;
+	__u64 src;
+	__u64 dst;
+};
+
+struct btrfs_ioctl_qgroup_create_args {
+	__u64 create;
+	__u64 qgroupid;
+};
 #define BTRFS_IOC_SNAP_CREATE _IOW(BTRFS_IOCTL_MAGIC, 1, \
 				   struct btrfs_ioctl_vol_args)
 #define BTRFS_IOC_DEFRAG _IOW(BTRFS_IOCTL_MAGIC, 2, \
@@ -520,6 +524,10 @@ struct btrfs_ioctl_clone_range_args {
 					struct btrfs_ioctl_qgroup_create_args)
 #define BTRFS_IOC_QGROUP_LIMIT _IOR(BTRFS_IOCTL_MAGIC, 43, \
 					struct btrfs_ioctl_qgroup_limit_args)
+#define BTRFS_IOC_QUOTA_RESCAN _IOW(BTRFS_IOCTL_MAGIC, 44, \
+			       struct btrfs_ioctl_quota_rescan_args)
+#define BTRFS_IOC_QUOTA_RESCAN_STATUS _IOR(BTRFS_IOCTL_MAGIC, 45, \
+			       struct btrfs_ioctl_quota_rescan_args)
 #define BTRFS_IOC_GET_FSLABEL _IOR(BTRFS_IOCTL_MAGIC, 49, \
 				   char[BTRFS_LABEL_SIZE])
 #define BTRFS_IOC_SET_FSLABEL _IOW(BTRFS_IOCTL_MAGIC, 50, \
-- 
1.7.1

