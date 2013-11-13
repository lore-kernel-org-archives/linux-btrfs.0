Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-we0-f169.google.com ([74.125.82.169]:43136 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754057Ab3KMBWR (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 12 Nov 2013 20:22:17 -0500
Received: by mail-we0-f169.google.com with SMTP id q58so6948051wes.0
        for <linux-btrfs@vger.kernel.org>; Tue, 12 Nov 2013 17:22:16 -0800 (PST)
From: Filipe David Borba Manana <fdmanana@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Filipe David Borba Manana <fdmanana@gmail.com>
Subject: [PATCH 5/5 V2] Btrfs-progs: add support for the compression property
Date: Wed, 13 Nov 2013 01:22:09 +0000
Message-Id: <1384305729-22656-1-git-send-email-fdmanana@gmail.com>
In-Reply-To: <1384263706-25549-1-git-send-email-fdmanana@gmail.com>
References: <1384263706-25549-1-git-send-email-fdmanana@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

With this property, one can enable compression for individual files
without the need to mount the filesystem with the compress or
compress-force options, and specify the compression algorithm.

When applied against a directory, files created under that directory
will inherit the compression property.

This requires the corresponding kernel patch, which adds the support
for setting and getting properties and implements the compression
property.

Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
---

V2: Update to match latest kernel change - use regular set/get xattr
    path to set/get compression property.

 props.c |   78 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 78 insertions(+)

diff --git a/props.c b/props.c
index 12fdc52..4d0aeea 100644
--- a/props.c
+++ b/props.c
@@ -16,6 +16,8 @@
 
 #include <sys/stat.h>
 #include <sys/ioctl.h>
+#include <sys/types.h>
+#include <attr/xattr.h>
 #include <fcntl.h>
 #include <unistd.h>
 
@@ -24,6 +26,10 @@
 #include "utils.h"
 #include "props.h"
 
+#define XATTR_BTRFS_PREFIX     "btrfs."
+#define XATTR_BTRFS_PREFIX_LEN (sizeof(XATTR_BTRFS_PREFIX) - 1)
+
+
 static int prop_read_only(enum prop_object_type type,
 			  const char *object,
 			  const char *name,
@@ -102,10 +108,82 @@ static int prop_label(enum prop_object_type type,
 	return ret;
 }
 
+static int prop_compression(enum prop_object_type type,
+			    const char *object,
+			    const char *name,
+			    const char *value)
+{
+	int ret;
+	ssize_t sret;
+	int fd = -1;
+	DIR *dirstream = NULL;
+	char *buf = NULL;
+	char *xattr_name = NULL;
+
+	fd = open_file_or_dir(object, &dirstream);
+	if (fd == -1) {
+		ret = -errno;
+		fprintf(stderr, "ERROR: open %s failed. %s\n",
+			object, strerror(-ret));
+		goto out;
+	}
+
+	xattr_name = malloc(XATTR_BTRFS_PREFIX_LEN + strlen(name));
+	if (!xattr_name) {
+		ret = -ENOMEM;
+		goto out;
+	}
+	memcpy(xattr_name, XATTR_BTRFS_PREFIX, XATTR_BTRFS_PREFIX_LEN);
+	memcpy(xattr_name + XATTR_BTRFS_PREFIX_LEN, name, strlen(name));
+
+	if (value)
+		sret = fsetxattr(fd, xattr_name, value, strlen(value), 0);
+	else
+		sret = fgetxattr(fd, xattr_name, NULL, 0);
+	if (sret < 0) {
+		ret = -errno;
+		if (ret != -ENODATA)
+			fprintf(stderr,
+				"ERROR: failed to %s compression for %s. %s\n",
+				value ? "set" : "get", object, strerror(-ret));
+		goto out;
+	}
+	if (!value) {
+		size_t len = sret;
+
+		buf = malloc(len);
+		if (!buf) {
+			ret = -ENOMEM;
+			goto out;
+		}
+		sret = fgetxattr(fd, xattr_name, buf, len);
+		if (sret < 0) {
+			ret = -errno;
+			fprintf(stderr,
+				"ERROR: failed to get compression for %s. %s\n",
+				object, strerror(-ret));
+			goto out;
+		}
+		fprintf(stdout, "compression=%.*s\n", (int)len, buf);
+	}
+
+	ret = 0;
+out:
+	free(xattr_name);
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

