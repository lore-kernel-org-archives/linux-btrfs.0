Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:20531 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752397AbdKBDT7 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 1 Nov 2017 23:19:59 -0400
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (unknown [10.167.33.83])
        by cn.fujitsu.com (Postfix) with ESMTP id D7FE8482CFEE
        for <linux-btrfs@vger.kernel.org>; Thu,  2 Nov 2017 11:19:55 +0800 (CST)
From: Su Yue <suy.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <suy.fnst@cn.fujitsu.com>
Subject: [PATCH 2/5] btrfs-progs: property: set/get/print ro property
Date: Thu, 2 Nov 2017 11:23:17 +0800
Message-ID: <20171102032320.12537-3-suy.fnst@cn.fujitsu.com>
In-Reply-To: <20171102032320.12537-1-suy.fnst@cn.fujitsu.com>
References: <20171102032320.12537-1-suy.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Introduce set_prop_read_only(), get_prop_read_only(),
print_prop_read_only() to set, get and print the subvolume
is read-only or not.

Signed-off-by: Su Yue <suy.fnst@cn.fujitsu.com>
---
 props.c | 72 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++---------
 1 file changed, 62 insertions(+), 10 deletions(-)

diff --git a/props.c b/props.c
index d6249f53887d..da69f6e9314c 100644
--- a/props.c
+++ b/props.c
@@ -36,12 +36,16 @@
 #define ENOATTR ENODATA
 #endif
 
-static int prop_read_only(enum prop_object_type type,
-			  const char *object,
-			  const char *name,
-			  const char *value)
+enum prop_operation {
+	set_prop,
+	get_prop,
+};
+
+static ssize_t prop_read_only(enum prop_object_type type, const char *object,
+			      const char *name, char *value,
+			      enum prop_operation operation)
 {
-	int ret = 0;
+	ssize_t ret = 0;
 	int fd = -1;
 	u64 flags = 0;
 
@@ -60,12 +64,19 @@ static int prop_read_only(enum prop_object_type type,
 		goto out;
 	}
 
-	if (!value) {
+	if (operation == get_prop) {
+		const char *is_ro;
 		if (flags & BTRFS_SUBVOL_RDONLY)
-			fprintf(stdout, "ro=true\n");
+			is_ro = "true";
 		else
-			fprintf(stdout, "ro=false\n");
-		ret = 0;
+			is_ro = "false";
+
+		if (value) {
+			memcpy(value, is_ro, strlen(is_ro));
+			ret = 0;
+		} else {
+			ret = strlen(is_ro);
+		}
 		goto out;
 	}
 
@@ -93,6 +104,47 @@ out:
 	return ret;
 }
 
+static int set_prop_read_only(enum prop_object_type type, const char *object,
+			      const char *name, const char *value)
+{
+	return prop_read_only(type, object, name, (char *)value, set_prop);
+}
+
+static ssize_t get_prop_read_only(enum prop_object_type type,
+			  const char *object, const char *name, char *value)
+{
+	return prop_read_only(type, object, name, value, get_prop);
+}
+
+static int print_prop_read_only(enum prop_object_type type, const char *object,
+				const char *name)
+{
+	ssize_t len;
+	char *value = NULL;
+	int ret;
+
+	len = get_prop_read_only(type, object, name, NULL);
+	if (len <= 0) {
+		ret = -1;
+		goto out;
+	}
+	value = malloc(len + 1);
+	if (!value) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	ret = get_prop_read_only(type, object, name, value);
+	if (ret)
+		goto out;
+	value[len] = '\0';
+	printf("ro=%s\n", value);
+out:
+	if (value)
+		free(value);
+	return ret;
+}
+
 static int prop_label(enum prop_object_type type,
 		      const char *object,
 		      const char *name,
@@ -188,7 +240,7 @@ out:
 
 const struct prop_handler prop_handlers[] = {
 	{"ro", "Set/get read-only flag of subvolume.", 0, prop_object_subvol,
-	 NULL, NULL, NULL},
+	 set_prop_read_only, get_prop_read_only, print_prop_read_only},
 
 	{"label", "Set/get label of device.", 0,
 	 prop_object_dev | prop_object_root, NULL, NULL, NULL},
-- 
2.15.0



