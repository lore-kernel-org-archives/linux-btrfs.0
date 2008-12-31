From: Shen Feng <shen@cn.fujitsu.com>
Subject: [PATCH] Btrfs-progs: update BUG_ON and WARN_ON
Date: Wed, 31 Dec 2008 14:54:15 +0800
Message-ID: <495B1717.7020404@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>


Define BUG_ON and WARN_ON as assert for esay debug.

Signed-off-by: Shen Feng <shen@cn.fujitsu.com>
---
 kerncompat.h |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/kerncompat.h b/kerncompat.h
index e6e9987..aed4b55 100644
--- a/kerncompat.h
+++ b/kerncompat.h
@@ -24,6 +24,7 @@
 #include <string.h>
 #include <endian.h>
 #include <byteswap.h>
+#include <assert.h>
 
 #ifndef READ
 #define READ 0
@@ -199,8 +200,8 @@ static inline long IS_ERR(const void *ptr)
 #define kstrdup(x, y) strdup(x)
 #define kfree(x) free(x)
 
-#define BUG_ON(c) do { if (c) abort(); } while (0)
-#define WARN_ON(c) do { if (c) abort(); } while (0)
+#define BUG_ON(c) assert(!(c))
+#define WARN_ON(c) assert(!(c))
 
 #undef offsetof
 #ifdef __compiler_offsetof
-- 
1.6.0.6

