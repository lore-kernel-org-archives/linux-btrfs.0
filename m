Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:61748 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751428AbdKBDUA (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 1 Nov 2017 23:20:00 -0400
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (unknown [10.167.33.83])
        by cn.fujitsu.com (Postfix) with ESMTP id 30DA94818485
        for <linux-btrfs@vger.kernel.org>; Thu,  2 Nov 2017 11:19:55 +0800 (CST)
From: Su Yue <suy.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <suy.fnst@cn.fujitsu.com>
Subject: [PATCH 1/5] btrfs-progs: property: divide prop_handler_t into setter,getter,printer
Date: Thu, 2 Nov 2017 11:23:16 +0800
Message-ID: <20171102032320.12537-2-suy.fnst@cn.fujitsu.com>
In-Reply-To: <20171102032320.12537-1-suy.fnst@cn.fujitsu.com>
References: <20171102032320.12537-1-suy.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Previously, function prototype prop_handler_t() in props.h is
just for setting and getting @value. However, it prints @value
directly instead of returns the value. It was difficult to get
@value by @name.

For code-reuse, here divide prop_handler_t into three handlers:
1) prop_setter_t: set @value as origin.
2) prop_getter_t:
	if arg @value is NULL, return the length of result for
		caller to allocate.
	else copy result to memory space which arg @value points to.

3) prop_printer_t: just call correspond prop_getter_t and
prints result.

Notice:
Since C language has no feature like tpyeinfo in others.
After return of prop_getter_t(), the arg @value will point
to array of characters without null-terminated.

Signed-off-by: Su Yue <suy.fnst@cn.fujitsu.com>
---
 cmds-property.c |  7 +++++--
 props.c         | 11 +++++++----
 props.h         | 19 +++++++++++++++----
 3 files changed, 27 insertions(+), 10 deletions(-)

diff --git a/cmds-property.c b/cmds-property.c
index 03bafa054701..6795d1795027 100644
--- a/cmds-property.c
+++ b/cmds-property.c
@@ -180,7 +180,7 @@ static int dump_prop(const struct prop_handler *prop,
 
 	if ((types & type) && (prop->types & type)) {
 		if (!name_and_help)
-			ret = prop->handler(type, object, prop->name, NULL);
+			ret = prop->printer(type, object, prop->name);
 		else
 			printf("%-20s%s\n", prop->name, prop->desc);
 	}
@@ -244,7 +244,10 @@ static int setget_prop(int types, const char *object,
 		goto out;
 	}
 
-	ret = prop->handler(types, object, name, value);
+	if (value)
+		ret = prop->setter(types, object, name, value);
+	else
+		ret = prop->printer(types, object, name);
 
 	if (ret < 0)
 		ret = 50;
diff --git a/props.c b/props.c
index cddbd9272fe4..d6249f53887d 100644
--- a/props.c
+++ b/props.c
@@ -188,10 +188,13 @@ out:
 
 const struct prop_handler prop_handlers[] = {
 	{"ro", "Set/get read-only flag of subvolume.", 0, prop_object_subvol,
-	 prop_read_only},
+	 NULL, NULL, NULL},
+
 	{"label", "Set/get label of device.", 0,
-	 prop_object_dev | prop_object_root, prop_label},
+	 prop_object_dev | prop_object_root, NULL, NULL, NULL},
+
 	{"compression", "Set/get compression for a file or directory", 0,
-	 prop_object_inode, prop_compression},
-	{NULL, NULL, 0, 0, NULL}
+	 prop_object_inode, NULL, NULL, NULL},
+
+	{NULL, NULL, 0, 0, NULL, NULL, NULL}
 };
diff --git a/props.h b/props.h
index a43cb2537f37..fd5796bff09d 100644
--- a/props.h
+++ b/props.h
@@ -17,6 +17,8 @@
 #ifndef __BTRFS_PROPS_H__
 #define __BTRFS_PROPS_H__
 
+#include <unistd.h>
+
 enum prop_object_type {
 	prop_object_dev		= (1 << 0),
 	prop_object_root	= (1 << 1),
@@ -25,17 +27,26 @@ enum prop_object_type {
 	__prop_object_max,
 };
 
-typedef int (*prop_handler_t)(enum prop_object_type type,
+typedef int (*prop_setter_t)(enum prop_object_type type,
+			     const char *object,
+			     const char *name,
+			     const char *value);
+typedef ssize_t (*prop_getter_t)(enum prop_object_type type,
+				 const char *object,
+				 const char *name,
+				 char *value);
+typedef int (*prop_printer_t)(enum prop_object_type type,
 			      const char *object,
-			      const char *name,
-			      const char *value);
+			      const char *name);
 
 struct prop_handler {
 	const char *name;
 	const char *desc;
 	int read_only;
 	int types;
-	prop_handler_t handler;
+	prop_setter_t setter;
+	prop_getter_t getter;
+	prop_printer_t printer;
 };
 
 extern const struct prop_handler prop_handlers[];
-- 
2.15.0



