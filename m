Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:33228 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1425197AbcBRGUv (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 18 Feb 2016 01:20:51 -0500
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Cc: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
Subject: [PATCH 8/8] btrfs-progs: property: add a dedup property
Date: Thu, 18 Feb 2016 14:18:20 +0800
Message-Id: <1455776300-11234-8-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1455776300-11234-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1455776300-11234-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>

Normally if we enable online dedup for a fs, it's filesystem wide
de-duplication. With this property, we can explicitly disable data
de-duplication for specified files.

Signed-off-by: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
---
 Documentation/btrfs-property.asciidoc |  2 +
 props.c                               | 73 +++++++++++++++++++++++++++++++++++
 2 files changed, 75 insertions(+)

diff --git a/Documentation/btrfs-property.asciidoc b/Documentation/btrfs-property.asciidoc
index 8b9b7f0..2fbecf6 100644
--- a/Documentation/btrfs-property.asciidoc
+++ b/Documentation/btrfs-property.asciidoc
@@ -44,6 +44,8 @@ label::::
 label of device
 compression::::
 compression setting for an inode: lzo, zlib, or "" (empty string)
+dedup::::
+online dedup setting for an inode: disable or "" (empty string)
 
 *list* [-t <type>] <object>::
 Lists available properties with their descriptions for the given object.
diff --git a/props.c b/props.c
index 5b74932..f27eb8b 100644
--- a/props.c
+++ b/props.c
@@ -187,6 +187,77 @@ out:
 	return ret;
 }
 
+static int prop_dedup(enum prop_object_type type, const char *object,
+	const char *name, const char *value)
+{
+	int ret;
+	ssize_t sret;
+	int fd = -1;
+	DIR *dirstream = NULL;
+	char *buf = NULL;
+	char *xattr_name = NULL;
+	int open_flags = value ? O_RDWR : O_RDONLY;
+
+	fd = open_file_or_dir3(object, &dirstream, open_flags);
+	if (fd == -1) {
+		ret = -errno;
+		fprintf(stderr, "ERROR: open %s failed. %s\n",
+			object, strerror(-ret));
+		goto out;
+	}
+
+	xattr_name = malloc(XATTR_BTRFS_PREFIX_LEN + strlen(name) + 1);
+	if (!xattr_name) {
+		ret = -ENOMEM;
+		goto out;
+	}
+	memcpy(xattr_name, XATTR_BTRFS_PREFIX, XATTR_BTRFS_PREFIX_LEN);
+	memcpy(xattr_name + XATTR_BTRFS_PREFIX_LEN, name, strlen(name));
+	xattr_name[XATTR_BTRFS_PREFIX_LEN + strlen(name)] = '\0';
+
+	if (value)
+		sret = fsetxattr(fd, xattr_name, value, strlen(value), 0);
+	else
+		sret = fgetxattr(fd, xattr_name, NULL, 0);
+	if (sret < 0) {
+		ret = -errno;
+		if (ret != -ENOATTR)
+			fprintf(stderr,
+				"ERROR: failed to %s dedup for %s. %s\n",
+				value ? "set" : "get", object, strerror(-ret));
+		else
+			ret = 0;
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
+				"ERROR: failed to get dedup for %s. %s\n",
+				object, strerror(-ret));
+			goto out;
+		}
+		fprintf(stdout, "dedup=%.*s\n", (int)len, buf);
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
 const struct prop_handler prop_handlers[] = {
 	{"ro", "Set/get read-only flag of subvolume.", 0, prop_object_subvol,
 	 prop_read_only},
@@ -194,5 +265,7 @@ const struct prop_handler prop_handlers[] = {
 	 prop_object_dev | prop_object_root, prop_label},
 	{"compression", "Set/get compression for a file or directory", 0,
 	 prop_object_inode, prop_compression},
+	{"dedup", "Set/get dedup for a file or directory", 0,
+	 prop_object_inode, prop_dedup},
 	{NULL, NULL, 0, 0, NULL}
 };
-- 
2.7.1



