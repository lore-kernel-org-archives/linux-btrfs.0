From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
Subject: [Patch] bit-radix.c: fix declarations
Date: Mon, 19 Jan 2009 22:19:21 +0800
Message-ID: <20090119141921.GA8507@hack.private>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>


bit-radix.c should #include "bit-radix.h", and add a missing declaration
for find_next_bit().

Signed-off-by: WANG Cong <wangcong@zeuux.org>

---
diff --git a/bit-radix.c b/bit-radix.c
index 57f6f3c..01bf4af 100644
--- a/bit-radix.c
+++ b/bit-radix.c
@@ -17,7 +17,7 @@
  */
 
 #include "kerncompat.h"
-#include "radix-tree.h"
+#include "bit-radix.h"
 
 #define BIT_ARRAY_BYTES 256
 #define BIT_RADIX_BITS_PER_ARRAY ((BIT_ARRAY_BYTES - sizeof(unsigned long)) * 8)
diff --git a/bit-radix.h b/bit-radix.h
index af14e80..ff82c9c 100644
--- a/bit-radix.h
+++ b/bit-radix.h
@@ -23,6 +23,8 @@
 int set_radix_bit(struct radix_tree_root *radix, unsigned long bit);
 int test_radix_bit(struct radix_tree_root *radix, unsigned long bit);
 int clear_radix_bit(struct radix_tree_root *radix, unsigned long bit);
+unsigned long find_next_bit(const unsigned long *addr, unsigned long size,
+                unsigned long offset);
 int find_first_radix_bit(struct radix_tree_root *radix, unsigned long *retbits,
 			 unsigned long start, int nr);
 

