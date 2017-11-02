Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:20531 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S934169AbdKBDUA (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 1 Nov 2017 23:20:00 -0400
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (unknown [10.167.33.83])
        by cn.fujitsu.com (Postfix) with ESMTP id 0AB7A482D00D
        for <linux-btrfs@vger.kernel.org>; Thu,  2 Nov 2017 11:19:58 +0800 (CST)
From: Su Yue <suy.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <suy.fnst@cn.fujitsu.com>
Subject: [PATCH 4/5] btrfs-progs: property: set/get/print compression property
Date: Thu, 2 Nov 2017 11:23:19 +0800
Message-ID: <20171102032320.12537-5-suy.fnst@cn.fujitsu.com>
In-Reply-To: <20171102032320.12537-1-suy.fnst@cn.fujitsu.com>
References: <20171102032320.12537-1-suy.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Introduce set_prop_compression(), get_prop_compression()
and print_prop_compression() to set/get/print compression property.

Signed-off-by: Su Yue <suy.fnst@cn.fujitsu.com>
---
 props.c | 68 ++++++++++++++++++++++++++++++++++++++++++++++++++++-------------
 1 file changed, 55 insertions(+), 13 deletions(-)

diff --git a/props.c b/props.c
index 28a81b6bdc81..edddc4b99ebb 100644
--- a/props.c
+++ b/props.c
@@ -210,12 +210,10 @@ out:
 	return ret;
 }
 
-static int prop_compression(enum prop_object_type type,
-			    const char *object,
-			    const char *name,
-			    const char *value)
+static ssize_t prop_compression(enum prop_object_type type, const char *object,
+		const char *name, char *value, enum prop_operation operation)
 {
-	int ret;
+	ssize_t ret;
 	ssize_t sret;
 	int fd = -1;
 	DIR *dirstream = NULL;
@@ -239,7 +237,7 @@ static int prop_compression(enum prop_object_type type,
 	memcpy(xattr_name + XATTR_BTRFS_PREFIX_LEN, name, strlen(name));
 	xattr_name[XATTR_BTRFS_PREFIX_LEN + strlen(name)] = '\0';
 
-	if (value) {
+	if (operation == set_prop) {
 		if (strcmp(value, "no") == 0 || strcmp(value, "none") == 0)
 			value = "";
 		sret = fsetxattr(fd, xattr_name, value, strlen(value), 0);
@@ -255,14 +253,14 @@ static int prop_compression(enum prop_object_type type,
 			ret = 0;
 		goto out;
 	}
-	if (!value) {
+	if (operation == get_prop) {
 		size_t len = sret;
 
-		buf = malloc(len);
-		if (!buf) {
-			ret = -ENOMEM;
+		if (!value) {
+			ret = len;
 			goto out;
 		}
+		buf = value;
 		sret = fgetxattr(fd, xattr_name, buf, len);
 		if (sret < 0) {
 			ret = -errno;
@@ -270,19 +268,62 @@ static int prop_compression(enum prop_object_type type,
 			      object, strerror(-ret));
 			goto out;
 		}
-		fprintf(stdout, "compression=%.*s\n", (int)len, buf);
 	}
 
 	ret = 0;
 out:
 	free(xattr_name);
-	free(buf);
 	if (fd >= 0)
 		close_file_or_dir(fd, dirstream);
 
 	return ret;
 }
 
+static int set_prop_compression(enum prop_object_type type, const char *object,
+				const char *name, const char *value)
+{
+	return prop_compression(type, object, name, (char *)value, set_prop);
+}
+
+static ssize_t get_prop_compression(enum prop_object_type type,
+			    const char *object, const char *name, char *value)
+{
+	return prop_compression(type, object, name, value, get_prop);
+}
+
+static int print_prop_compression(enum prop_object_type type,
+				  const char *object, const char *name)
+{
+	int ret = 0;
+	ssize_t len;
+	char *value = NULL;
+
+	len = get_prop_compression(type, object, name, NULL);
+	if (len <= 0) {
+		if (len == -ENOATTR)
+			ret = 0;
+		else
+			ret = len;
+		goto out;
+	}
+	value = malloc(len + 1);
+	if (!value) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	ret = get_prop_compression(type, object, name, value);
+	if (ret)
+		goto out;
+
+	value[len] = '\0';
+	printf("compression=%s\n", value);
+out:
+	if (value)
+		free(value);
+	return ret;
+}
+
 const struct prop_handler prop_handlers[] = {
 	{"ro", "Set/get read-only flag of subvolume.", 0, prop_object_subvol,
 	 set_prop_read_only, get_prop_read_only, print_prop_read_only},
@@ -292,7 +333,8 @@ const struct prop_handler prop_handlers[] = {
 	 set_prop_label, get_prop_label, print_prop_label},
 
 	{"compression", "Set/get compression for a file or directory", 0,
-	 prop_object_inode, NULL, NULL, NULL},
+	 prop_object_inode,
+	 set_prop_compression, get_prop_compression, print_prop_compression},
 
 	{NULL, NULL, 0, 0, NULL, NULL, NULL}
 };
-- 
2.15.0



