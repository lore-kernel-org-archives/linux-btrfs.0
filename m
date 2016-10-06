Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:32528 "EHLO song.cn.fujitsu.com"
        rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S964983AbcJFIrd (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 6 Oct 2016 04:47:33 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH] btrfs-progs: Fix warning_trace compile error if backtrace is disabled
Date: Thu,  6 Oct 2016 16:47:19 +0800
Message-Id: <20161006084719.9540-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

If we disable backtrace, btrfs-progs can't be compiled since we don't
have warning_trace defined.

Fix by move it out of #ifndef BTRFS_DISABLE_BACKTRACE block.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 kerncompat.h | 38 ++++++++++++++++++++------------------
 1 file changed, 20 insertions(+), 18 deletions(-)

diff --git a/kerncompat.h b/kerncompat.h
index ea04ef3..fba0bc1 100644
--- a/kerncompat.h
+++ b/kerncompat.h
@@ -72,6 +72,26 @@
 #define ___token_glue(a,b,c)	a ## b ## c
 #define BUILD_ASSERT(x)		extern int __token_glue(compile_time_assert_,__LINE__,__COUNTER__)[1-2*!(x)] __attribute__((unused))
 
+static inline void warning_trace(const char *assertion, const char *filename,
+			      const char *func, unsigned line, int val,
+			      int trace)
+{
+	if (val)
+		return;
+	if (assertion)
+		fprintf(stderr,
+			"%s:%d: %s: Warning: assertion `%s` failed, value %d\n",
+			filename, line, func, assertion, val);
+	else
+		fprintf(stderr,
+			"%s:%d: %s: Warning: assertion failed, value %d.\n",
+			filename, line, func, val);
+#ifndef BTRFS_DISABLE_BACKTRACE
+	if (trace)
+		print_trace();
+#endif
+}
+
 #ifndef BTRFS_DISABLE_BACKTRACE
 #define MAX_BACKTRACE	16
 static inline void print_trace(void)
@@ -99,24 +119,6 @@ static inline void assert_trace(const char *assertion, const char *filename,
 	exit(1);
 }
 
-static inline void warning_trace(const char *assertion, const char *filename,
-			      const char *func, unsigned line, int val,
-			      int trace)
-{
-	if (val)
-		return;
-	if (assertion)
-		fprintf(stderr,
-			"%s:%d: %s: Warning: assertion `%s` failed, value %d\n",
-			filename, line, func, assertion, val);
-	else
-		fprintf(stderr,
-			"%s:%d: %s: Warning: assertion failed, value %d.\n",
-			filename, line, func, val);
-	if (trace)
-		print_trace();
-}
-
 #define BUG() assert_trace(NULL, __FILE__, __func__, __LINE__, 0)
 #else
 #define BUG() assert(0)
-- 
2.10.0



