Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:60706 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751183AbdARC6n (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 17 Jan 2017 21:58:43 -0500
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <dsterba@suse.cz>, Goldwyn Rodrigues <rgoldwyn@suse.de>
Subject: [PATCH v2] btrfs-progs: Fix disable backtrace assert error
Date: Wed, 18 Jan 2017 10:57:04 +0800
Message-ID: <20170118025704.27592-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Due to commit 00e769d04c2c83029d6c71(btrfs-progs: Correct value printed
by assertions/BUG_ON/WARN_ON), which changed the assert_trace()
parameter, the condition passed to assert/WARN_ON/BUG_ON are logical
notted for backtrace enabled and disabled case.

Such behavior makes us easier to pass value wrong, and in fact it did
cause us to pass wrong condition for ASSERT().

Instead of passing different conditions for ASSERT/WARN_ON/BUG_ON()
manually, this patch will use BUG_ON() to implement the resting
ASSERT/WARN_ON/BUG(), so we don't need to pass 3 different conditions
but only one.

And to further info the review for the fact that the condition should be
different, rename "assert_trace" to "bugon_trace", as unlike assert, we
will only trigger the bug when condition is true.

Also, move WARN_ON() out of the ifdef branch, as it's completely the
same for both branches.

Cc: Goldwyn Rodrigues <rgoldwyn@suse.de>
Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
Sorry for late update, being digging the dev-replace/scrub bug

v2:
  Keep ASSERT() outputing meaningful error string, use ASSERT() to
  implement BUG_ON() so only the abused BUG_ON() output is affected.
  Suggested by David.
---
 kerncompat.h | 13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

diff --git a/kerncompat.h b/kerncompat.h
index 19ed3fc0..fe23774e 100644
--- a/kerncompat.h
+++ b/kerncompat.h
@@ -291,18 +291,15 @@ static inline void assert_trace(const char *assertion, const char *filename,
 	abort();
 	exit(1);
 }
-
-#define BUG_ON(c) assert_trace(#c, __FILE__, __func__, __LINE__, (long)(c))
-#define WARN_ON(c) warning_trace(#c, __FILE__, __func__, __LINE__, (long)(c))
 #define	ASSERT(c) assert_trace(#c, __FILE__, __func__, __LINE__, (long)!(c))
-#define BUG() assert_trace(NULL, __FILE__, __func__, __LINE__, 1)
 #else
-#define BUG_ON(c) assert(!(c))
-#define WARN_ON(c) warning_trace(#c, __FILE__, __func__, __LINE__, (long)(c))
-#define ASSERT(c) assert(!(c))
-#define BUG() assert(0)
+#define ASSERT(c) assert(c)
 #endif
 
+#define BUG_ON(c) ASSERT(!(c))
+#define BUG() BUG_ON(1)
+#define WARN_ON(c) warning_trace(#c, __FILE__, __func__, __LINE__, (long)(c))
+
 #define container_of(ptr, type, member) ({                      \
         const typeof( ((type *)0)->member ) *__mptr = (ptr);    \
 	        (type *)( (char *)__mptr - offsetof(type,member) );})
-- 
2.11.0



