Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from www.zacarias.com.ar ([62.210.192.172]:42427 "EHLO
	www.zacarias.com.ar" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752462AbaJGOSt (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 7 Oct 2014 10:18:49 -0400
From: Gustavo Zacarias <gustavo@zacarias.com.ar>
To: linux-btrfs@vger.kernel.org
Cc: Gustavo Zacarias <gustavo@zacarias.com.ar>
Subject: [PATCH] btrfs-progs: add option to disable backtrace usage
Date: Tue,  7 Oct 2014 11:09:04 -0300
Message-Id: <1412690944-5513-1-git-send-email-gustavo@zacarias.com.ar>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This commit adds the support for a make variable named
"DISABLE_BACKTRACE" which allows to disable the support for backtrace()
usage on ASSERT(), BUG() and BUG_ON() calls.
This is useful because some alternative C libraries like uClibc have
optional support for backtrace() which is rarely built when debugging
isn't taking place.

Signed-off-by: Gustavo Zacarias <gustavo@zacarias.com.ar>
---
 Makefile     |  4 ++++
 kerncompat.h | 15 +++++++++++++++
 2 files changed, 19 insertions(+)

diff --git a/Makefile b/Makefile
index 7cc7783..342545c 100644
--- a/Makefile
+++ b/Makefile
@@ -63,6 +63,10 @@ BUILDDIRS = $(patsubst %,build-%,$(SUBDIRS))
 INSTALLDIRS = $(patsubst %,install-%,$(SUBDIRS))
 CLEANDIRS = $(patsubst %,clean-%,$(SUBDIRS))
 
+ifeq ($(DISABLE_BACKTRACE),1)
+AM_CFLAGS += -DBTRFS_DISABLE_BACKTRACE
+endif
+
 ifneq ($(DISABLE_DOCUMENTATION),1)
 BUILDDIRS += build-Documentation
 INSTALLDIRS += install-Documentation
diff --git a/kerncompat.h b/kerncompat.h
index 19c7fa5..889d94c 100644
--- a/kerncompat.h
+++ b/kerncompat.h
@@ -29,7 +29,9 @@
 #include <stddef.h>
 #include <linux/types.h>
 #include <stdint.h>
+#ifndef BTRFS_DISABLE_BACKTRACE
 #include <execinfo.h>
+#endif
 
 #define ptr_to_u64(x)	((u64)(uintptr_t)x)
 #define u64_to_ptr(x)	((void *)(uintptr_t)x)
@@ -55,6 +57,7 @@
 #define ULONG_MAX       (~0UL)
 #endif
 
+#ifndef BTRFS_DISABLE_BACKTRACE
 #define MAX_BACKTRACE	16
 static inline void print_trace(void)
 {
@@ -81,6 +84,9 @@ static inline void assert_trace(const char *assertion, const char *filename,
 }
 
 #define BUG() assert_trace(NULL, __FILE__, __func__, __LINE__, 0)
+#else
+#define BUG() assert(0)
+#endif
 
 #ifdef __CHECKER__
 #define __force    __attribute__((force))
@@ -264,10 +270,19 @@ static inline long IS_ERR(const void *ptr)
 #define kstrdup(x, y) strdup(x)
 #define kfree(x) free(x)
 
+#ifndef BTRFS_DISABLE_BACKTRACE
 #define BUG_ON(c) assert_trace(#c, __FILE__, __func__, __LINE__, !(c))
+#else
+#define BUG_ON(c) assert(!(c))
+#endif
 
 #define WARN_ON(c) BUG_ON(c)
+
+#ifndef BTRFS_DISABLE_BACKTRACE
 #define	ASSERT(c) assert_trace(#c, __FILE__, __func__, __LINE__, (c))
+#else
+#define ASSERT(c) assert(c)
+#endif
 
 #define container_of(ptr, type, member) ({                      \
         const typeof( ((type *)0)->member ) *__mptr = (ptr);    \
-- 
2.0.4

