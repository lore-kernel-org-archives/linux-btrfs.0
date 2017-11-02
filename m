Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:20531 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S934040AbdKBDT6 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 1 Nov 2017 23:19:58 -0400
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (unknown [10.167.33.83])
        by cn.fujitsu.com (Postfix) with ESMTP id 569A2482CFF0
        for <linux-btrfs@vger.kernel.org>; Thu,  2 Nov 2017 11:19:57 +0800 (CST)
From: Su Yue <suy.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <suy.fnst@cn.fujitsu.com>
Subject: [PATCH 3/5] btrfs-progs: property: set/get/print label property
Date: Thu, 2 Nov 2017 11:23:18 +0800
Message-ID: <20171102032320.12537-4-suy.fnst@cn.fujitsu.com>
In-Reply-To: <20171102032320.12537-1-suy.fnst@cn.fujitsu.com>
References: <20171102032320.12537-1-suy.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Introduce set_prop_label(), get_prop_label(), print_prop_label()
to set/get/print label.

Signed-off-by: Su Yue <suy.fnst@cn.fujitsu.com>
---
 props.c | 64 +++++++++++++++++++++++++++++++++++++++++++++++++++++++---------
 1 file changed, 55 insertions(+), 9 deletions(-)

diff --git a/props.c b/props.c
index da69f6e9314c..28a81b6bdc81 100644
--- a/props.c
+++ b/props.c
@@ -145,23 +145,68 @@ out:
 	return ret;
 }
 
-static int prop_label(enum prop_object_type type,
-		      const char *object,
-		      const char *name,
-		      const char *value)
+static ssize_t prop_label(enum prop_object_type type, const char *object,
+		  const char *name, char *value, enum prop_operation operation)
 {
-	int ret;
+	ssize_t ret;
 
-	if (value) {
+	if (operation == set_prop) {
 		ret = set_label((char *) object, (char *) value);
 	} else {
 		char label[BTRFS_LABEL_SIZE];
 
 		ret = get_label((char *) object, label);
-		if (!ret)
-			fprintf(stdout, "label=%s\n", label);
+		if (ret)
+			goto out;
+
+		if (!value)
+			ret = strlen(label);
+		else
+			memcpy(value, label, strlen(label));
+	}
+out:
+	return ret;
+}
+
+static int set_prop_label(enum prop_object_type type, const char *object,
+			  const char *name, const char *value)
+{
+	return prop_label(type, object, name, (char *)value, set_prop);
+}
+
+static ssize_t get_prop_label(enum prop_object_type type, const char *object,
+			      const char *name, char *value)
+{
+	return prop_label(type, object, name, value, get_prop);
+}
+
+static int print_prop_label(enum prop_object_type type, const char *object,
+			    const char *name)
+{
+	int ret;
+	ssize_t len;
+	char *value = NULL;
+
+	len = get_prop_label(type, object, name, NULL);
+	if (len < 0) {
+		ret = len;
+		goto out;
 	}
 
+	value = malloc(len + 1);
+	if (!value) {
+		ret = -ENOMEM;
+		goto out;
+	}
+	ret = get_prop_label(type, object, name, value);
+	if (ret)
+		goto out;
+
+	value[len] = '\0';
+	printf("label=%s\n", value);
+out:
+	if (value)
+		free(value);
 	return ret;
 }
 
@@ -243,7 +288,8 @@ const struct prop_handler prop_handlers[] = {
 	 set_prop_read_only, get_prop_read_only, print_prop_read_only},
 
 	{"label", "Set/get label of device.", 0,
-	 prop_object_dev | prop_object_root, NULL, NULL, NULL},
+	 prop_object_dev | prop_object_root,
+	 set_prop_label, get_prop_label, print_prop_label},
 
 	{"compression", "Set/get compression for a file or directory", 0,
 	 prop_object_inode, NULL, NULL, NULL},
-- 
2.15.0



