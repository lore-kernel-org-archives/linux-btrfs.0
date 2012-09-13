Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:63237 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1757528Ab2IMLAm (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 13 Sep 2012 07:00:42 -0400
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id q8DApgUO030992
	for <linux-btrfs@vger.kernel.org>; Thu, 13 Sep 2012 18:51:43 +0800
Message-ID: <5051BAB8.7080200@cn.fujitsu.com>
Date: Thu, 13 Sep 2012 18:51:36 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
MIME-Version: 1.0
To: Linux Btrfs <linux-btrfs@vger.kernel.org>
Subject: [PATCH 1/2] Btrfs: cleanup duplicated division functions
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

div_factor{_fine} has been implemented for two times, cleanup it.
And I move them into a independent file named math.h because they are
common math functions.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/extent-tree.c |   19 +------------------
 fs/btrfs/math.h        |   44 ++++++++++++++++++++++++++++++++++++++++++++
 fs/btrfs/volumes.c     |   23 +----------------------
 3 files changed, 46 insertions(+), 40 deletions(-)
 create mode 100644 fs/btrfs/math.h

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index a010234..5f6bae1 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -33,6 +33,7 @@
 #include "volumes.h"
 #include "locking.h"
 #include "free-space-cache.h"
+#include "math.h"
 
 #undef SCRAMBLE_DELAYED_REFS
 
@@ -648,24 +649,6 @@ void btrfs_clear_space_info_full(struct btrfs_fs_info *info)
 	rcu_read_unlock();
 }
 
-static u64 div_factor(u64 num, int factor)
-{
-	if (factor == 10)
-		return num;
-	num *= factor;
-	do_div(num, 10);
-	return num;
-}
-
-static u64 div_factor_fine(u64 num, int factor)
-{
-	if (factor == 100)
-		return num;
-	num *= factor;
-	do_div(num, 100);
-	return num;
-}
-
 u64 btrfs_find_block_group(struct btrfs_root *root,
 			   u64 search_start, u64 search_hint, int owner)
 {
diff --git a/fs/btrfs/math.h b/fs/btrfs/math.h
new file mode 100644
index 0000000..b7816ce
--- /dev/null
+++ b/fs/btrfs/math.h
@@ -0,0 +1,44 @@
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
+#include <asm/div64.h>
+
+static inline u64 div_factor(u64 num, int factor)
+{
+	if (factor == 10)
+		return num;
+	num *= factor;
+	do_div(num, 10);
+	return num;
+}
+
+static inline u64 div_factor_fine(u64 num, int factor)
+{
+	if (factor == 100)
+		return num;
+	num *= factor;
+	do_div(num, 100);
+	return num;
+}
+
+#endif
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 3f4e70e..2558fc0 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -25,7 +25,6 @@
 #include <linux/capability.h>
 #include <linux/ratelimit.h>
 #include <linux/kthread.h>
-#include <asm/div64.h>
 #include "compat.h"
 #include "ctree.h"
 #include "extent_map.h"
@@ -36,6 +35,7 @@
 #include "async-thread.h"
 #include "check-integrity.h"
 #include "rcu-string.h"
+#include "math.h"
 
 static int init_first_rw_device(struct btrfs_trans_handle *trans,
 				struct btrfs_root *root,
@@ -2325,18 +2325,6 @@ static int chunk_profiles_filter(u64 chunk_type,
 	return 1;
 }
 
-static u64 div_factor_fine(u64 num, int factor)
-{
-	if (factor <= 0)
-		return 0;
-	if (factor >= 100)
-		return num;
-
-	num *= factor;
-	do_div(num, 100);
-	return num;
-}
-
 static int chunk_usage_filter(struct btrfs_fs_info *fs_info, u64 chunk_offset,
 			      struct btrfs_balance_args *bargs)
 {
@@ -2501,15 +2489,6 @@ static int should_balance_chunk(struct btrfs_root *root,
 	return 1;
 }
 
-static u64 div_factor(u64 num, int factor)
-{
-	if (factor == 10)
-		return num;
-	num *= factor;
-	do_div(num, 10);
-	return num;
-}
-
 static int __btrfs_balance(struct btrfs_fs_info *fs_info)
 {
 	struct btrfs_balance_control *bctl = fs_info->balance_ctl;
-- 
1.7.6.5
