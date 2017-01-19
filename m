Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:6982 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751656AbdASEBH (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 18 Jan 2017 23:01:07 -0500
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <dsterba@suse.cz>, Goldwyn Rodrigues <rgoldwyn@suse.de>
Subject: [PATCH v4] btrfs-progs: Fix disable backtrace assert error
Date: Thu, 19 Jan 2017 12:00:03 +0800
Message-ID: <20170119040003.22773-1-quwenruo@cn.fujitsu.com>
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
manually, this patch will use ASSERT() to implement the resting
ASSERT/WARN_ON/BUG() for disable backtrace case, and use assert_trace()
to implement ASSERT() and BUG_ON(), to allow them to print correct
value.

Also, move WARN_ON() out of the ifdef branch, as it's completely the
same for both branches.

Cc: Goldwyn Rodrigues <rgoldwyn@suse.de>
Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
v2:
  Keep ASSERT() outputing meaningful error string, use ASSERT() to
  implement BUG_ON() so only the abused BUG_ON() output is affected.
  Suggested by David.
v3:
  Update commit message, since we use ASSERT() instead of BUG_ON() as
  main assert function now.

v4:
  Make BUG_ON() to print correct condition.
---
 kerncompat.h | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/kerncompat.h b/kerncompat.h
index 19ed3fc0..b4070dac 100644
--- a/kerncompat.h
+++ b/kerncompat.h
@@ -291,18 +291,16 @@ static inline void assert_trace(const char *assertion, const char *filename,
 	abort();
 	exit(1);
 }
-
-#define BUG_ON(c) assert_trace(#c, __FILE__, __func__, __LINE__, (long)(c))
-#define WARN_ON(c) warning_trace(#c, __FILE__, __func__, __LINE__, (long)(c))
 #define	ASSERT(c) assert_trace(#c, __FILE__, __func__, __LINE__, (long)!(c))
-#define BUG() assert_trace(NULL, __FILE__, __func__, __LINE__, 1)
+#define BUG_ON(c) assert_trace(#c, __FILE__, __func__, __LINE__, (long)(c))
 #else
-#define BUG_ON(c) assert(!(c))
-#define WARN_ON(c) warning_trace(#c, __FILE__, __func__, __LINE__, (long)(c))
-#define ASSERT(c) assert(!(c))
-#define BUG() assert(0)
+#define ASSERT(c) assert(c)
+#define BUG_ON(c) ASSERT(!(c))
 #endif
 
+#define BUG() BUG_ON(1)
+#define WARN_ON(c) warning_trace(#c, __FILE__, __func__, __LINE__, (long)(c))
+
 #define container_of(ptr, type, member) ({                      \
         const typeof( ((type *)0)->member ) *__mptr = (ptr);    \
 	        (type *)( (char *)__mptr - offsetof(type,member) );})
-- 
2.11.0



