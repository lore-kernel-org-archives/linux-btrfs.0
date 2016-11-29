Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:51872 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750922AbcK2QZH (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 29 Nov 2016 11:25:07 -0500
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id CBD5DABE7
        for <linux-btrfs@vger.kernel.org>; Tue, 29 Nov 2016 16:25:05 +0000 (UTC)
From: Goldwyn Rodrigues <rgoldwyn@suse.de>
To: linux-btrfs@vger.kernel.org
Cc: Goldwyn Rodrigues <rgoldwyn@suse.com>
Subject: [PATCH 1/2] btrfs-progs: Correct value printed by assertions/BUG_ON/WARN_ON
Date: Tue, 29 Nov 2016 10:24:52 -0600
Message-Id: <20161129162452.28402-1-rgoldwyn@suse.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Goldwyn Rodrigues <rgoldwyn@suse.com>

The values passed to BUG_ON/WARN_ON are negated(!) and printed, which
results in printing the value zero for each bug/warning. For example:
volumes.c:988: btrfs_alloc_chunk: Assertion `ret` failed, value 0

This is not useful. Instead changed to print the value of the parameter
passed to BUG_ON()/WARN_ON(). The value needed to be changed to long
to accomodate pointers being passed.

Also, consolidated assert() and BUG() into ifndef.

Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
---
 kerncompat.h | 35 +++++++++++++++--------------------
 1 file changed, 15 insertions(+), 20 deletions(-)

diff --git a/kerncompat.h b/kerncompat.h
index ed9a042..9bd25bd 100644
--- a/kerncompat.h
+++ b/kerncompat.h
@@ -88,39 +88,36 @@ static inline void print_trace(void)
 }
 
 static inline void assert_trace(const char *assertion, const char *filename,
-			      const char *func, unsigned line, int val)
+			      const char *func, unsigned line, long val)
 {
-	if (val)
+	if (!val)
 		return;
 	if (assertion)
-		fprintf(stderr, "%s:%d: %s: Assertion `%s` failed, value %d\n",
+		fprintf(stderr, "%s:%d: %s: Assertion `%s` failed, value %ld\n",
 			filename, line, func, assertion, val);
 	else
-		fprintf(stderr, "%s:%d: %s: Assertion failed, value %d.\n",
+		fprintf(stderr, "%s:%d: %s: Assertion failed, value %ld.\n",
 			filename, line, func, val);
 	print_trace();
 	abort();
 	exit(1);
 }
 
-#define BUG() assert_trace(NULL, __FILE__, __func__, __LINE__, 0)
-#else
-#define BUG() assert(0)
 #endif
 
 static inline void warning_trace(const char *assertion, const char *filename,
-			      const char *func, unsigned line, int val,
+			      const char *func, unsigned line, long val,
 			      int trace)
 {
-	if (val)
+	if (!val)
 		return;
 	if (assertion)
 		fprintf(stderr,
-			"%s:%d: %s: Warning: assertion `%s` failed, value %d\n",
+			"%s:%d: %s: Warning: assertion `%s` failed, value %ld\n",
 			filename, line, func, assertion, val);
 	else
 		fprintf(stderr,
-			"%s:%d: %s: Warning: assertion failed, value %d.\n",
+			"%s:%d: %s: Warning: assertion failed, value %ld.\n",
 			filename, line, func, val);
 #ifndef BTRFS_DISABLE_BACKTRACE
 	if (trace)
@@ -299,17 +296,15 @@ static inline long IS_ERR(const void *ptr)
 #define vfree(x) free(x)
 
 #ifndef BTRFS_DISABLE_BACKTRACE
-#define BUG_ON(c) assert_trace(#c, __FILE__, __func__, __LINE__, !(c))
-#define WARN_ON(c) warning_trace(#c, __FILE__, __func__, __LINE__, !(c), 1)
+#define BUG_ON(c) assert_trace(#c, __FILE__, __func__, __LINE__, (long)(c))
+#define WARN_ON(c) warning_trace(#c, __FILE__, __func__, __LINE__, (long)(c), 1)
+#define	ASSERT(c) assert_trace(#c, __FILE__, __func__, __LINE__, (long)!(c))
+#define BUG() assert_trace(NULL, __FILE__, __func__, __LINE__, 1)
 #else
 #define BUG_ON(c) assert(!(c))
-#define WARN_ON(c) warning_trace(#c, __FILE__, __func__, __LINE__, !(c), 0)
-#endif
-
-#ifndef BTRFS_DISABLE_BACKTRACE
-#define	ASSERT(c) assert_trace(#c, __FILE__, __func__, __LINE__, (c))
-#else
-#define ASSERT(c) assert(c)
+#define WARN_ON(c) warning_trace(#c, __FILE__, __func__, __LINE__, (long)(c), 0)
+#define ASSERT(c) assert(!(c))
+#define BUG() assert(0)
 #endif
 
 #define container_of(ptr, type, member) ({                      \
-- 
2.10.0

