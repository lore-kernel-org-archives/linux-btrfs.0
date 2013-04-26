Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:37324 "EHLO sandeen.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753521Ab3DZVGO (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 26 Apr 2013 17:06:14 -0400
From: Eric Sandeen <sandeen@redhat.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 6/9] Btrfs-progs: cleanup duplicated division functions
Date: Fri, 26 Apr 2013 16:06:07 -0500
Message-Id: <1367010370-21571-7-git-send-email-sandeen@redhat.com>
In-Reply-To: <1367010370-21571-1-git-send-email-sandeen@redhat.com>
References: <1367010370-21571-1-git-send-email-sandeen@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

div_factor has been implemented for two times, cleanup it.
And I move them into a independent file named math.h because they are
common math functions.

[Eric Sandeen: port kernel commit 3fed40c to userspace]

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 extent-tree.c |   10 +---------
 math.h        |   33 +++++++++++++++++++++++++++++++++
 volumes.c     |    9 +--------
 3 files changed, 35 insertions(+), 17 deletions(-)
 create mode 100644 math.h

diff --git a/extent-tree.c b/extent-tree.c
index e8b6999..b8403d6 100644
--- a/extent-tree.c
+++ b/extent-tree.c
@@ -27,6 +27,7 @@
 #include "crc32c.h"
 #include "volumes.h"
 #include "free-space-cache.h"
+#include "math.h"
 
 #define BLOCK_GROUP_DATA     EXTENT_WRITEBACK
 #define BLOCK_GROUP_METADATA EXTENT_UPTODATE
@@ -313,15 +314,6 @@ no_cache:
 	goto again;
 }
 
-static u64 div_factor(u64 num, int factor)
-{
-	if (factor == 10)
-		return num;
-	num *= factor;
-	num /= 10;
-	return num;
-}
-
 static int block_group_state_bits(u64 flags)
 {
 	int bits = 0;
diff --git a/math.h b/math.h
new file mode 100644
index 0000000..482dba3
--- /dev/null
+++ b/math.h
@@ -0,0 +1,33 @@
+
+/*
+ * Copyright (C) 2012 Fujitsu.  All rights reserved.
+ * Written by Miao Xie <miaox@cn.fujitsu.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public
+ * License v2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public
+ * License along with this program; if not, write to the
+ * Free Software Foundation, Inc., 59 Temple Place - Suite 330,
+ * Boston, MA 021110-1307, USA.
+ */
+
+#ifndef __BTRFS_MATH_H
+#define __BTRFS_MATH_H
+
+static inline u64 div_factor(u64 num, int factor)
+{
+	if (factor == 10)
+		return num;
+	num *= factor;
+	num /= 10;
+	return num;
+}
+
+#endif
diff --git a/volumes.c b/volumes.c
index d6f81f8..aa1c3dd 100644
--- a/volumes.c
+++ b/volumes.c
@@ -29,6 +29,7 @@
 #include "transaction.h"
 #include "print-tree.h"
 #include "volumes.h"
+#include "math.h"
 
 struct stripe {
 	struct btrfs_device *dev;
@@ -623,14 +624,6 @@ int btrfs_add_system_chunk(struct btrfs_trans_handle *trans,
 	return 0;
 }
 
-static u64 div_factor(u64 num, int factor)
-{
-	if (factor == 10)
-		return num;
-	num *= factor;
-	return num / 10;
-}
-
 static u64 chunk_bytes_by_type(u64 type, u64 calc_size, int num_stripes,
 			       int sub_stripes)
 {
-- 
1.7.1

