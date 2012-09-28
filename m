Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:40512 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1756054Ab2I1BtF (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 27 Sep 2012 21:49:05 -0400
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id q8S1n3HS007911
	for <linux-btrfs@vger.kernel.org>; Fri, 28 Sep 2012 09:49:03 +0800
Message-ID: <50650219.7080306@cn.fujitsu.com>
Date: Fri, 28 Sep 2012 09:49:13 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
MIME-Version: 1.0
To: Linux Btrfs <linux-btrfs@vger.kernel.org>
Subject: [PATCH V5 1/2] Btrfs: cleanup duplicated division functions
References: <5051BAB8.7080200@cn.fujitsu.com> <505A8632.10101@cn.fujitsu.com> <505C2E62.2000400@cn.fujitsu.com> <5064284E.9020504@cn.fujitsu.com>
In-Reply-To: <5064284E.9020504@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

div_factor{_fine} has been implemented for two times, and these two functions
are very similar, so cleanup the reduplicate implement and drop the original
div_factor(), and then rename div_factor_fine() to div_factor(). So the factor
of the new div_factor() is 100, not 10.

And I move div_factor into a independent file named math.h because it is a
common math function, may be used by every composition of btrfs.

Because these functions are mostly used on the hot path, and we are sure
the parameters are right in the most cases, we don't add complex checks
for the parameters. But in the other place, we must check and make sure
the parameters are right. So besides the code cleanup, this patch also
add a check for the usage of the space balance, it is the only place that
we need add check to make sure the parameters of div_factor are right till now.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
Changelog v4 -> v5:
- drop the check in the space balance, and make the churn to a minimum

Changelog v3 -> v4:
- deal with the wrong usage that was input on the old kernel

Changelog v2 -> v3:
- drop the original div_factor and rename div_factor_fine to div_factor
- drop the check of the factor

Changelog v1 -> v2:
- add missing check
---
 fs/btrfs/extent-tree.c |   29 ++++++-----------------------
 fs/btrfs/math.h        |   35 +++++++++++++++++++++++++++++++++++
 fs/btrfs/relocation.c  |    2 +-
 fs/btrfs/transaction.c |    2 +-
 fs/btrfs/volumes.c     |   35 ++++++++++-------------------------
 5 files changed, 53 insertions(+), 50 deletions(-)
 create mode 100644 fs/btrfs/math.h

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index a010234..bcb9ced 100644
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
@@ -674,7 +657,7 @@ u64 btrfs_find_block_group(struct btrfs_root *root,
 	u64 last = max(search_hint, search_start);
 	u64 group_start = 0;
 	int full_search = 0;
-	int factor = 9;
+	int factor = 90;
 	int wrapped = 0;
 again:
 	while (1) {
@@ -708,7 +691,7 @@ again:
 	if (!full_search && factor < 10) {
 		last = search_start;
 		full_search = 1;
-		factor = 10;
+		factor = 100;
 		goto again;
 	}
 found:
@@ -3513,7 +3496,7 @@ static int should_alloc_chunk(struct btrfs_root *root,
 	if (force == CHUNK_ALLOC_LIMITED) {
 		thresh = btrfs_super_total_bytes(root->fs_info->super_copy);
 		thresh = max_t(u64, 64 * 1024 * 1024,
-			       div_factor_fine(thresh, 1));
+			       div_factor(thresh, 1));
 
 		if (num_bytes - num_allocated < thresh)
 			return 1;
@@ -3521,12 +3504,12 @@ static int should_alloc_chunk(struct btrfs_root *root,
 	thresh = btrfs_super_total_bytes(root->fs_info->super_copy);
 
 	/* 256MB or 2% of the FS */
-	thresh = max_t(u64, 256 * 1024 * 1024, div_factor_fine(thresh, 2));
+	thresh = max_t(u64, 256 * 1024 * 1024, div_factor(thresh, 2));
 	/* system chunks need a much small threshold */
 	if (sinfo->flags & BTRFS_BLOCK_GROUP_SYSTEM)
 		thresh = 32 * 1024 * 1024;
 
-	if (num_bytes > thresh && sinfo->bytes_used < div_factor(num_bytes, 8))
+	if (num_bytes > thresh && sinfo->bytes_used < div_factor(num_bytes, 80))
 		return 0;
 	return 1;
 }
diff --git a/fs/btrfs/math.h b/fs/btrfs/math.h
new file mode 100644
index 0000000..4fef49f
--- /dev/null
+++ b/fs/btrfs/math.h
@@ -0,0 +1,35 @@
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
+	WARN_ON(factor > 100 || factor < 0);
+
+	num *= factor;
+	do_div(num, 100);
+	return num;
+}
+
+#endif
diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index f193096..2254478 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -3813,7 +3813,7 @@ restart:
 			}
 		}
 
-		ret = btrfs_block_rsv_check(rc->extent_root, rc->block_rsv, 5);
+		ret = btrfs_block_rsv_check(rc->extent_root, rc->block_rsv, 50);
 		if (ret < 0) {
 			if (ret != -ENOSPC) {
 				err = ret;
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index cf98dbc..115f054 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -489,7 +489,7 @@ static int should_end_transaction(struct btrfs_trans_handle *trans,
 {
 	int ret;
 
-	ret = btrfs_block_rsv_check(root, &root->fs_info->global_block_rsv, 5);
+	ret = btrfs_block_rsv_check(root, &root->fs_info->global_block_rsv, 50);
 	return ret ? 1 : 0;
 }
 
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 3f4e70e..763edc4 100644
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
@@ -2347,7 +2335,13 @@ static int chunk_usage_filter(struct btrfs_fs_info *fs_info, u64 chunk_offset,
 	cache = btrfs_lookup_block_group(fs_info, chunk_offset);
 	chunk_used = btrfs_block_group_used(&cache->item);
 
-	user_thresh = div_factor_fine(cache->key.offset, bargs->usage);
+	if (bargs->usage <= 0)
+		user_thresh = 0;
+	else if (bargs->usage >= 100)
+		user_thresh = cache->key.offset;
+	else
+		user_thresh = div_factor(cache->key.offset, bargs->usage);
+
 	if (chunk_used < user_thresh)
 		ret = 0;
 
@@ -2501,15 +2495,6 @@ static int should_balance_chunk(struct btrfs_root *root,
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
@@ -2534,7 +2519,7 @@ static int __btrfs_balance(struct btrfs_fs_info *fs_info)
 	devices = &fs_info->fs_devices->devices;
 	list_for_each_entry(device, devices, dev_list) {
 		old_size = device->total_bytes;
-		size_to_free = div_factor(old_size, 1);
+		size_to_free = div_factor(old_size, 10);
 		size_to_free = min(size_to_free, (u64)1 * 1024 * 1024);
 		if (!device->writeable ||
 		    device->total_bytes - device->bytes_used > size_to_free)
@@ -3284,7 +3269,7 @@ static int __btrfs_alloc_chunk(struct btrfs_trans_handle *trans,
 	}
 
 	/* we don't want a chunk larger than 10% of writeable space */
-	max_chunk_size = min(div_factor(fs_devices->total_rw_bytes, 1),
+	max_chunk_size = min(div_factor(fs_devices->total_rw_bytes, 10),
 			     max_chunk_size);
 
 	devices_info = kzalloc(sizeof(*devices_info) * fs_devices->rw_devices,
-- 
1.7.6.5

