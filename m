Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:51905 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752427AbcK2QZT (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 29 Nov 2016 11:25:19 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 29061ABE7
        for <linux-btrfs@vger.kernel.org>; Tue, 29 Nov 2016 16:25:18 +0000 (UTC)
From: Goldwyn Rodrigues <rgoldwyn@suse.de>
To: linux-btrfs@vger.kernel.org
Cc: Goldwyn Rodrigues <rgoldwyn@suse.com>
Subject: [PATCH 2/2] btrfs-progs: Remove duplicate printfs in warning_trace()/assert_trace()
Date: Tue, 29 Nov 2016 10:25:14 -0600
Message-Id: <20161129162514.28453-1-rgoldwyn@suse.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Goldwyn Rodrigues <rgoldwyn@suse.com>

Code reduction. Call warning_trace from assert_trace in order to
reduce the printf's used. Also, trace variable in warning_trace()
is not required because it is already handled by BTRFS_DISABLE_BACKTRACE.

Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
---
 kerncompat.h | 37 ++++++++++++++-----------------------
 1 file changed, 14 insertions(+), 23 deletions(-)

diff --git a/kerncompat.h b/kerncompat.h
index 9bd25bd..e374614 100644
--- a/kerncompat.h
+++ b/kerncompat.h
@@ -86,28 +86,10 @@ static inline void print_trace(void)
 	size = backtrace(array, MAX_BACKTRACE);
 	backtrace_symbols_fd(array, size, 2);
 }
-
-static inline void assert_trace(const char *assertion, const char *filename,
-			      const char *func, unsigned line, long val)
-{
-	if (!val)
-		return;
-	if (assertion)
-		fprintf(stderr, "%s:%d: %s: Assertion `%s` failed, value %ld\n",
-			filename, line, func, assertion, val);
-	else
-		fprintf(stderr, "%s:%d: %s: Assertion failed, value %ld.\n",
-			filename, line, func, val);
-	print_trace();
-	abort();
-	exit(1);
-}
-
 #endif
 
 static inline void warning_trace(const char *assertion, const char *filename,
-			      const char *func, unsigned line, long val,
-			      int trace)
+			      const char *func, unsigned line, long val)
 {
 	if (!val)
 		return;
@@ -120,8 +102,7 @@ static inline void warning_trace(const char *assertion, const char *filename,
 			"%s:%d: %s: Warning: assertion failed, value %ld.\n",
 			filename, line, func, val);
 #ifndef BTRFS_DISABLE_BACKTRACE
-	if (trace)
-		print_trace();
+	print_trace();
 #endif
 }
 
@@ -296,13 +277,23 @@ static inline long IS_ERR(const void *ptr)
 #define vfree(x) free(x)
 
 #ifndef BTRFS_DISABLE_BACKTRACE
+static inline void assert_trace(const char *assertion, const char *filename,
+			      const char *func, unsigned line, long val)
+{
+	if (!val)
+		return;
+	warning_trace(assertion, filename, func, line, val);
+	abort();
+	exit(1);
+}
+
 #define BUG_ON(c) assert_trace(#c, __FILE__, __func__, __LINE__, (long)(c))
-#define WARN_ON(c) warning_trace(#c, __FILE__, __func__, __LINE__, (long)(c), 1)
+#define WARN_ON(c) warning_trace(#c, __FILE__, __func__, __LINE__, (long)(c))
 #define	ASSERT(c) assert_trace(#c, __FILE__, __func__, __LINE__, (long)!(c))
 #define BUG() assert_trace(NULL, __FILE__, __func__, __LINE__, 1)
 #else
 #define BUG_ON(c) assert(!(c))
-#define WARN_ON(c) warning_trace(#c, __FILE__, __func__, __LINE__, (long)(c), 0)
+#define WARN_ON(c) warning_trace(#c, __FILE__, __func__, __LINE__, (long)(c))
 #define ASSERT(c) assert(!(c))
 #define BUG() assert(0)
 #endif
-- 
2.10.0

