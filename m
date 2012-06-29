Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:29759 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750891Ab2F2JvQ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 29 Jun 2012 05:51:16 -0400
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id q5T9pCUL012719
	for <linux-btrfs@vger.kernel.org>; Fri, 29 Jun 2012 17:51:13 +0800
From: Liu Bo <liubo2009@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 1/3] Btrfs-progs: add support to set subvolume/snapshot readonly
Date: Fri, 29 Jun 2012 18:00:36 +0800
Message-Id: <1340964038-32584-1-git-send-email-liubo2009@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Setting subvolume/snapshot readonly has been missing for a long time.

With this patch, we can set a subvolume/snapshot readonly via:

o    btrfs subvolume set-ro <path>

Signed-off-by: Liu Bo <liubo2009@cn.fujitsu.com>
---
 cmds-subvolume.c |   40 ++++++++++++++++++++++++++++++++++++++++
 ioctl.h          |    7 +++++++
 2 files changed, 47 insertions(+), 0 deletions(-)

diff --git a/cmds-subvolume.c b/cmds-subvolume.c
index 950fa8f..5ee31cb 100644
--- a/cmds-subvolume.c
+++ b/cmds-subvolume.c
@@ -512,6 +512,44 @@ static int cmd_find_new(int argc, char **argv)
 	return 0;
 }
 
+static const char * const cmd_subvol_set_ro_usage[] = {
+	"btrfs subvolume set-ro <path>",
+	"Set the subvolume ro",
+	NULL
+};
+
+static int cmd_subvol_set_ro(int argc, char **argv)
+{
+	int	ret=0, fd, e;
+	char	*path;
+	struct	btrfs_ioctl_get_set_flags_args args;
+
+	if (check_argc_exact(argc, 2))
+		usage(cmd_subvol_set_ro_usage);
+
+	path = argv[1];
+
+	memset(&args, 0, sizeof(args));
+
+	fd = open_file_or_dir(path);
+	if (fd < 0) {
+		fprintf(stderr, "ERROR: can't access to '%s'\n", path);
+		return 12;
+	}
+
+	args.flags |= BTRFS_SUBVOL_RDONLY;
+	args.objectid = 0;
+	ret = ioctl(fd, BTRFS_IOC_SUBVOL_SETFLAGS, &args);
+	e = errno;
+	close(fd);
+	if( ret < 0 ){
+		fprintf(stderr, "ERROR: unable to set a subvolume RO- %s\n",
+			strerror(e));
+		return 30;
+	}
+	return 0;
+}
+
 const struct cmd_group subvolume_cmd_group = {
 	subvolume_cmd_group_usage, NULL, {
 		{ "create", cmd_subvol_create, cmd_subvol_create_usage, NULL, 0 },
@@ -522,6 +560,8 @@ const struct cmd_group subvolume_cmd_group = {
 			cmd_subvol_get_default_usage, NULL, 0 },
 		{ "set-default", cmd_subvol_set_default,
 			cmd_subvol_set_default_usage, NULL, 0 },
+		{ "set-ro", cmd_subvol_set_ro,
+			cmd_subvol_set_ro_usage, NULL, 0 },
 		{ "find-new", cmd_find_new, cmd_find_new_usage, NULL, 0 },
 		{ 0, 0, 0, 0, 0 }
 	}
diff --git a/ioctl.h b/ioctl.h
index f2e5d8d..9c066eb 100644
--- a/ioctl.h
+++ b/ioctl.h
@@ -42,6 +42,11 @@ struct btrfs_ioctl_vol_args_v2 {
 	char name[BTRFS_SUBVOL_NAME_MAX + 1];
 };
 
+struct btrfs_ioctl_get_set_flags_args {
+	__u64 objectid;
+	__u64 flags;
+};
+
 #define BTRFS_FSID_SIZE 16
 #define BTRFS_UUID_SIZE 16
 
@@ -312,6 +317,8 @@ struct btrfs_ioctl_logical_ino_args {
 				    struct btrfs_ioctl_space_args)
 #define BTRFS_IOC_SNAP_CREATE_V2 _IOW(BTRFS_IOCTL_MAGIC, 23, \
 				   struct btrfs_ioctl_vol_args_v2)
+#define BTRFS_IOC_SUBVOL_GETFLAGS _IOW(BTRFS_IOCTL_MAGIC, 25, __u64)
+#define BTRFS_IOC_SUBVOL_SETFLAGS _IOW(BTRFS_IOCTL_MAGIC, 26, __u64)
 #define BTRFS_IOC_SCRUB _IOWR(BTRFS_IOCTL_MAGIC, 27, \
 				struct btrfs_ioctl_scrub_args)
 #define BTRFS_IOC_SCRUB_CANCEL _IO(BTRFS_IOCTL_MAGIC, 28)
-- 
1.6.5.2

