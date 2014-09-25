Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:50238 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750933AbaIYUHO (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 25 Sep 2014 16:07:14 -0400
Received: from pps.filterd (m0004060 [127.0.0.1])
	by mx0b-00082601.pphosted.com (8.14.5/8.14.5) with SMTP id s8PK5bs0024645
	for <linux-btrfs@vger.kernel.org>; Thu, 25 Sep 2014 13:07:13 -0700
Received: from mail.thefacebook.com (mailwest.thefacebook.com [173.252.71.148])
	by mx0b-00082601.pphosted.com with ESMTP id 1pmgfrhr43-1
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Thu, 25 Sep 2014 13:07:13 -0700
From: Josef Bacik <jbacik@fb.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs-progs: make BUG*() be more verbose
Date: Thu, 25 Sep 2014 16:07:10 -0400
Message-ID: <1411675630-4109-1-git-send-email-jbacik@fb.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Currently these macros just tie to assert(), which gives us line number and such
but no backtrace so no actual context.  This patch adds support for spitting out
a backtrace so we can see how we got to the given assert.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fb.com>
---
 Makefile     |  2 +-
 kerncompat.h | 40 ++++++++++++++++++++++++++++++++++++----
 2 files changed, 37 insertions(+), 5 deletions(-)

diff --git a/Makefile b/Makefile
index 18eb944..7cc7783 100644
--- a/Makefile
+++ b/Makefile
@@ -5,7 +5,7 @@ CC = gcc
 LN = ln
 AR = ar
 AM_CFLAGS = -Wall -D_FILE_OFFSET_BITS=64 -DBTRFS_FLAT_INCLUDES -fno-strict-aliasing -fPIC
-CFLAGS = -g -O1 -fno-strict-aliasing
+CFLAGS = -g -O1 -fno-strict-aliasing -rdynamic
 objects = ctree.o disk-io.o radix-tree.o extent-tree.o print-tree.o \
 	  root-tree.o dir-item.o file-item.o inode-item.o inode-map.o \
 	  extent-cache.o extent_io.o volumes.o utils.o repair.o \
diff --git a/kerncompat.h b/kerncompat.h
index bb03194..669dd8d 100644
--- a/kerncompat.h
+++ b/kerncompat.h
@@ -29,6 +29,7 @@
 #include <stddef.h>
 #include <linux/types.h>
 #include <stdint.h>
+#include <execinfo.h>
 
 #define ptr_to_u64(x)	((u64)(uintptr_t)x)
 #define u64_to_ptr(x)	((void *)(uintptr_t)x)
@@ -54,7 +55,37 @@
 #define ULONG_MAX       (~0UL)
 #endif
 
-#define BUG() assert(0)
+static inline void print_trace(void)
+{
+	void *array[10];
+	size_t size;
+	char **strings;
+	size_t i;
+
+	size = backtrace(array, 10);
+	strings = backtrace_symbols(array, size);
+	for (i = 0; i < size; i++)
+		fprintf(stderr, "\t%s\n", strings[i]);
+	free(strings);
+}
+
+static inline void btr_assert(const char *assertion, const char *filename,
+			      const char *func, unsigned line, int val)
+{
+	if (val)
+		return;
+	if (assertion)
+		fprintf(stderr, "%s:%d: %s: Assertion `%s` failed.\n",
+			filename, line, func, assertion);
+	else
+		fprintf(stderr, "%s:%d: %s: Assertion failed.\n", filename,
+			line, func);
+	print_trace();
+	exit(1);
+}
+
+#define BUG() btr_assert(NULL, __FILE__, __func__, __LINE__, 0)
+
 #ifdef __CHECKER__
 #define __force    __attribute__((force))
 #define __bitwise__ __attribute__((bitwise))
@@ -237,9 +268,10 @@ static inline long IS_ERR(const void *ptr)
 #define kstrdup(x, y) strdup(x)
 #define kfree(x) free(x)
 
-#define BUG_ON(c) assert(!(c))
-#define WARN_ON(c) assert(!(c))
-#define	ASSERT(c) assert(c)
+#define BUG_ON(c) btr_assert(#c, __FILE__, __func__, __LINE__, !(c))
+
+#define WARN_ON(c) BUG_ON(c)
+#define	ASSERT(c) btr_assert(#c, __FILE__, __func__, __LINE__, (c))
 
 #define container_of(ptr, type, member) ({                      \
         const typeof( ((type *)0)->member ) *__mptr = (ptr);    \
-- 
1.9.3

