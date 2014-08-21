Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f52.google.com ([209.85.220.52]:62636 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754019AbaHUMEM (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 21 Aug 2014 08:04:12 -0400
Received: by mail-pa0-f52.google.com with SMTP id bj1so14133053pad.39
        for <linux-btrfs@vger.kernel.org>; Thu, 21 Aug 2014 05:04:11 -0700 (PDT)
Received: from ako (pl398.nas931.p-kanagawa.nttpc.ne.jp. [219.102.77.142])
        by mx.google.com with ESMTPSA id ey10sm38501939pdb.50.2014.08.21.05.04.09
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1.2 cipher=RC4-SHA bits=128/128);
        Thu, 21 Aug 2014 05:04:10 -0700 (PDT)
From: Naohiro Aota <naota@elisp.net>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH RFC] btrfs-progs: Show backtrace on BUGs
Date: Thu, 21 Aug 2014 21:04:07 +0900
Message-ID: <87zjey82x4.fsf@elisp.net>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

"btrfs check" is still under heavy development and so there are some
BUGs beging hit. "btrfs check" can be run on limited environment which
lacks gdb to debug the abort in detail. If we could see backtrace, it
will be easier to find a root cause of the BUG.

Following is my "btrfs check" output with and without the patch.

without patch:

ref mismatch on [1437411180544 16384] extent item 3, found 2
btrfs: extent_io.c:612: free_extent_buffer: Assertion `!(eb->flags & 1)' failed.
enabling repair mode
Checking filesystem on /dev/sdb2
UUID: a53121ee-679f-4241-bb44-ceb5a1a7beb7

with patch:

ref mismatch on [1437411180544 16384] extent item 3, found 2
btrfs check(free_extent_buffer+0xa3)[0x808ff89]
btrfs check[0x8090222]
btrfs check(alloc_extent_buffer+0xa7)[0x80903d0]
btrfs check(btrfs_find_create_tree_block+0x2e)[0x807edef]
btrfs check(btrfs_alloc_free_block+0x299)[0x808a3c4]
btrfs check(__btrfs_cow_block+0x1d4)[0x8078896]
btrfs check(btrfs_cow_block+0x150)[0x807934d]
btrfs check(btrfs_search_slot+0x136)[0x807c041]
btrfs check[0x8065a6b]
btrfs check[0x806bc0f]
btrfs check(cmd_check+0xc8f)[0x806d03a]
btrfs check(main+0x167)[0x804f5ec]
/lib/libc.so.6(__libc_start_main+0xe6)[0xf754c4f6]
btrfs check[0x804f061]
btrfsck: extent_io.c:612: free_extent_buffer: Assertion `!(eb->flags & 1)' failed.
enabling repair mode
Checking filesystem on /dev/sdb2
UUID: a53121ee-679f-4241-bb44-ceb5a1a7beb7

Now it's much clear that there's something wrong around
alloc_extent_buffer.

Signed-off-by: Naohiro Aota <naota@elisp.net>
---
 Makefile     |  2 +-
 kerncompat.h | 29 ++++++++++++++++++++++++++---
 2 files changed, 27 insertions(+), 4 deletions(-)

diff --git a/Makefile b/Makefile
index 76565e8..9db5441 100644
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
index f370cd8..94fadc8 100644
--- a/kerncompat.h
+++ b/kerncompat.h
@@ -27,6 +27,7 @@
 #include <byteswap.h>
 #include <assert.h>
 #include <stddef.h>
+#include <execinfo.h>
 #include <linux/types.h>
 
 #ifndef READ
@@ -50,7 +51,18 @@
 #define ULONG_MAX       (~0UL)
 #endif
 
-#define BUG() assert(0)
+#define MAX_BACKTRACE 128
+#define show_trace()						\
+	do {							\
+		void *trace[MAX_BACKTRACE];			\
+		int n = backtrace(trace, MAX_BACKTRACE);	\
+		backtrace_symbols_fd(trace, n, 2);		\
+	} while(0)
+#define BUG()					\
+	do {					\
+		show_trace();			\
+		assert(0);			\
+	} while(0)
 #ifdef __CHECKER__
 #define __force    __attribute__((force))
 #define __bitwise__ __attribute__((bitwise))
@@ -233,8 +245,19 @@ static inline long IS_ERR(const void *ptr)
 #define kstrdup(x, y) strdup(x)
 #define kfree(x) free(x)
 
-#define BUG_ON(c) assert(!(c))
-#define WARN_ON(c) assert(!(c))
+#define BUG_ON(c)				\
+	do {					\
+		if((c)) {			\
+			show_trace();		\
+			assert(!(c));		\
+		}				\
+	} while(0)
+#define WARN_ON(c) do {				\
+		if((c)) {			\
+			show_trace();		\
+			assert(!(c));		\
+		}				\
+	} while(0)
 
 
 #define container_of(ptr, type, member) ({                      \
-- 
2.0.4
