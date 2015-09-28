Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:45722 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S933732AbbI1N77 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 28 Sep 2015 09:59:59 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t8SDxZKw005922
	for <linux-btrfs@vger.kernel.org>; Mon, 28 Sep 2015 21:59:35 +0800
From: Zhao Lei <zhaolei@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Zhao Lei <zhaolei@cn.fujitsu.com>, Qu Wenruo <quwenruo@cn.fujitsu.com>
Subject: [PATCH v3 1/2] btrfs-progs: Introduce warning and error for common use
Date: Mon, 28 Sep 2015 21:58:13 +0800
Message-ID: <58c06ee5bd98f3a92637eec20ecbc15f7abfa2ee.1443448527.git.zhaolei@cn.fujitsu.com>
In-Reply-To: <cover.1443448527.git.zhaolei@cn.fujitsu.com>
References: <cover.1443448527.git.zhaolei@cn.fujitsu.com>
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
 utils.h | 51 +++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 51 insertions(+)

diff --git a/utils.h b/utils.h
index 192f3d1..ba9ba10 100644
--- a/utils.h
+++ b/utils.h
@@ -22,6 +22,7 @@
 #include <sys/stat.h>
 #include "ctree.h"
 #include <dirent.h>
+#include <stdarg.h>
 
 #define BTRFS_MKFS_SYSTEM_GROUP_SIZE (4 * 1024 * 1024)
 #define BTRFS_MKFS_SMALL_VOLUME_SIZE (1024 * 1024 * 1024)
@@ -270,4 +271,54 @@ const char *get_argv0_buf(void);
 
 unsigned int get_unit_mode_from_arg(int *argc, char *argv[], int df_mode);
 
+static inline void warning(const char *fmt, ...)
+{
+	va_list args;
+
+	fputs("WARNING: ", stderr);
+	va_start(args, fmt);
+	vfprintf(stderr, fmt, args);
+	va_end(args);
+}
+
+static inline void error(const char *fmt, ...)
+{
+	va_list args;
+
+	fputs("ERROR: ", stderr);
+	va_start(args, fmt);
+	vfprintf(stderr, fmt, args);
+	va_end(args);
+}
+
+static inline int warning_on(int condition, const char *fmt, ...)
+{
+	va_list args;
+
+	if (!condition)
+		return 0;
+
+	fputs("WARNING: ", stderr);
+	va_start(args, fmt);
+	vfprintf(stderr, fmt, args);
+	va_end(args);
+
+	return 1;
+}
+
+static inline int error_on(int condition, const char *fmt, ...)
+{
+	va_list args;
+
+	if (!condition)
+		return 0;
+
+	fputs("ERROR: ", stderr);
+	va_start(args, fmt);
+	vfprintf(stderr, fmt, args);
+	va_end(args);
+
+	return 1;
+}
+
 #endif
-- 
1.8.5.1

