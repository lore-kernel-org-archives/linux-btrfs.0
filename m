Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-we0-f172.google.com ([74.125.82.172]:51269 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754833Ab3KLNmR (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 12 Nov 2013 08:42:17 -0500
Received: by mail-we0-f172.google.com with SMTP id q58so6006827wes.31
        for <linux-btrfs@vger.kernel.org>; Tue, 12 Nov 2013 05:42:16 -0800 (PST)
From: Filipe David Borba Manana <fdmanana@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Filipe David Borba Manana <fdmanana@gmail.com>
Subject: [PATCH 5/5] Btrfs-progs: add support for the compression property
Date: Tue, 12 Nov 2013 13:41:46 +0000
Message-Id: <1384263706-25549-6-git-send-email-fdmanana@gmail.com>
In-Reply-To: <1384263706-25549-1-git-send-email-fdmanana@gmail.com>
References: <1384263706-25549-1-git-send-email-fdmanana@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

With this property, one can enable compression for individual files
without the need to mount the filesystem with the compress or
compress-force options, and specify the compression algorithm.

When applied against a directory, files created under that directory
will inherit the compression property.

This requires the corresponding kernel patch, which adds the
support for the property get and set ioctls and implementation
of the compression property.

Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
---
 ioctl.h |   12 +++++++++++
 props.c |   73 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 85 insertions(+)

diff --git a/ioctl.h b/ioctl.h
index d21413f..b1f7928 100644
--- a/ioctl.h
+++ b/ioctl.h
@@ -465,6 +465,14 @@ struct btrfs_ioctl_qgroup_create_args {
 	__u64 qgroupid;
 };
 
+struct btrfs_ioctl_getset_prop_args {
+	__u16 name_len;   /* in     */
+	__u16 value_len;  /* in/out */
+	__u8  unused[4];
+	__u64 name_ptr;   /* in     */
+	__u64 value_ptr;  /* in/out */
+};
+
 /* Error codes as returned by the kernel */
 enum btrfs_err_code {
 	notused,
@@ -551,6 +559,10 @@ struct btrfs_ioctl_clone_range_args {
 #define BTRFS_IOC_DEFAULT_SUBVOL _IOW(BTRFS_IOCTL_MAGIC, 19, u64)
 #define BTRFS_IOC_SPACE_INFO _IOWR(BTRFS_IOCTL_MAGIC, 20, \
 				    struct btrfs_ioctl_space_args)
+#define BTRFS_IOC_GET_PROP _IOR(BTRFS_IOCTL_MAGIC, 21, \
+				struct btrfs_ioctl_getset_prop_args)
+#define BTRFS_IOC_SET_PROP _IOW(BTRFS_IOCTL_MAGIC, 21, \
+				struct btrfs_ioctl_getset_prop_args)
 #define BTRFS_IOC_SNAP_CREATE_V2 _IOW(BTRFS_IOCTL_MAGIC, 23, \
 				   struct btrfs_ioctl_vol_args_v2)
 #define BTRFS_IOC_SUBVOL_CREATE_V2 _IOW(BTRFS_IOCTL_MAGIC, 24, \
diff --git a/props.c b/props.c
index 12fdc52..4a7d7ef 100644
--- a/props.c
+++ b/props.c
@@ -17,6 +17,7 @@
 #include <sys/stat.h>
 #include <sys/ioctl.h>
 #include <fcntl.h>
+#include <stdint.h>
 #include <unistd.h>
 
 #include "ctree.h"
@@ -102,10 +103,82 @@ static int prop_label(enum prop_object_type type,
 	return ret;
 }
 
+static int prop_compression(enum prop_object_type type,
+			    const char *object,
+			    const char *name,
+			    const char *value)
+{
+	int ret;
+	DIR *dirstream = NULL;
+	int fd = -1;
+	struct btrfs_ioctl_getset_prop_args args;
+	char *buf = NULL;
+
+	args.name_len = strlen(name);
+	args.name_ptr = (uintptr_t) name;
+
+	if (value) {
+		args.value_len = strlen(value);
+		args.value_ptr = (uintptr_t) value;
+	} else {
+		args.value_len = 0;
+		args.value_ptr = (uintptr_t) NULL;
+	}
+
+	fd = open_file_or_dir(object, &dirstream);
+	if (fd == -1) {
+		ret = -errno;
+		fprintf(stderr, "ERROR: open %s failed. %s\n",
+			object, strerror(-ret));
+		goto out;
+	}
+
+	if (value)
+		ret = ioctl(fd, BTRFS_IOC_SET_PROP, &args);
+	else
+		ret = ioctl(fd, BTRFS_IOC_GET_PROP, &args);
+	if (ret < 0) {
+		ret = -errno;
+		if (ret != -ENODATA)
+			fprintf(stderr,
+				"ERROR: failed to %s compression for %s. %s\n",
+				value ? "set" : "get", object, strerror(-ret));
+		goto out;
+	}
+	if (!value) {
+		buf = malloc(args.value_len);
+		if (!buf) {
+			ret = -ENOMEM;
+			goto out;
+		}
+		args.value_ptr = (uintptr_t) buf;
+		ret = ioctl(fd, BTRFS_IOC_GET_PROP, &args);
+		if (ret < 0) {
+			ret = -errno;
+			fprintf(stderr,
+				"ERROR: failed to get compression for %s. %s\n",
+				object, strerror(-ret));
+			goto out;
+		}
+		fprintf(stdout, "compression=%.*s\n", args.value_len, buf);
+	}
+
+	ret = 0;
+out:
+	free(buf);
+	if (fd >= 0)
+		close_file_or_dir(fd, dirstream);
+
+	return ret;
+}
+
+
 const struct prop_handler prop_handlers[] = {
 	{"ro", "Set/get read-only flag of subvolume.", 0, prop_object_subvol,
 	 prop_read_only},
 	{"label", "Set/get label of device.", 0,
 	 prop_object_dev | prop_object_root, prop_label},
+	{"compression", "Set/get compression for a file or directory", 0,
+	 prop_object_inode, prop_compression},
 	{0, 0, 0, 0, 0}
 };
-- 
1.7.9.5

