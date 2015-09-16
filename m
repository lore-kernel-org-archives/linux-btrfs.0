Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:58059 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752031AbbIPJma (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 16 Sep 2015 05:42:30 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t8G9gALr000364
	for <linux-btrfs@vger.kernel.org>; Wed, 16 Sep 2015 17:42:10 +0800
From: Zhao Lei <zhaolei@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Zhao Lei <zhaolei@cn.fujitsu.com>, Qu Wenruo <quwenruo@cn.fujitsu.com>
Subject: [PATCH v2 1/2] btrfs-progs: Introduce warning and error for common use
Date: Wed, 16 Sep 2015 17:40:46 +0800
Message-ID: <e4768fb11c5e7584b2211559c26d974517e70171.1442396165.git.zhaolei@cn.fujitsu.com>
In-Reply-To: <cover.1442396165.git.zhaolei@cn.fujitsu.com>
References: <cover.1442396165.git.zhaolei@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Current code use fprintf(stderr, "...") to output warnning and
error information.

The error message have different style, as:
 # grep fprintf *.c
 fprintf(stderr, "Open ctree failed\n");
 fprintf(stderr, "%s: open ctree failed\n", __func__);
 fprintf(stderr, "ERROR: cannot open ctree\n");
 ...

And sometimes, we forgot add tailed '\n', or use printf instead,
as in current code:
 printf("warning, device %llu is missing\n",

This patch introduce warning() and error() as common function,
to make:
1: Each warning and error information have same format
2: Easy to search/change all error message
3: Easy to modify function's internal for debug or other requirement,
   for example:
   print function/linenumber in error()
   dumpstack in error()
   add some trace for some style of message
   add support for -v, -vv, ...
   support for locales
   custom output functions
   support some special device/tty

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
---
 utils.h | 55 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 55 insertions(+)

diff --git a/utils.h b/utils.h
index dce0a47..c63e372 100644
--- a/utils.h
+++ b/utils.h
@@ -22,6 +22,7 @@
 #include <sys/stat.h>
 #include "ctree.h"
 #include <dirent.h>
+#include <stdarg.h>
 
 #define BTRFS_MKFS_SYSTEM_GROUP_SIZE (4 * 1024 * 1024)
 #define BTRFS_MKFS_SMALL_VOLUME_SIZE (1024 * 1024 * 1024)
@@ -269,4 +270,58 @@ const char *get_argv0_buf(void);
 
 unsigned int get_unit_mode_from_arg(int *argc, char *argv[], int df_mode);
 
+static inline void __veprintf(const char *prefix, const char *format,
+			      va_list ap)
+{
+	if (prefix)
+		fprintf(stderr, "%s", prefix);
+	vfprintf(stderr, format, ap);
+}
+
+static inline void warning(const char *fmt, ...)
+{
+	va_list args;
+
+	va_start(args, fmt);
+	__veprintf("WARNING: ", fmt, args);
+	va_end(args);
+}
+
+static inline void error(const char *fmt, ...)
+{
+	va_list args;
+
+	va_start(args, fmt);
+	__veprintf("ERROR: ", fmt, args);
+	va_end(args);
+}
+
+static inline int warning_on(int condition, const char *fmt, ...)
+{
+	if (!condition)
+		return 0;
+
+	va_list args;
+
+	va_start(args, fmt);
+	__veprintf("WARNING: ", fmt, args);
+	va_end(args);
+
+	return 1;
+}
+
+static inline int error_on(int condition, const char *fmt, ...)
+{
+	if (!condition)
+		return 0;
+
+	va_list args;
+
+	va_start(args, fmt);
+	__veprintf("ERROR: ", fmt, args);
+	va_end(args);
+
+	return 1;
+}
+
 #endif
-- 
1.8.5.1

