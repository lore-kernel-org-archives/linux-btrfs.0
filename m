Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:55249 "EHLO
	mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757897AbcFALUQ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 1 Jun 2016 07:20:16 -0400
Received: from pps.filterd (m0075771.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.16.0.11/8.16.0.11) with SMTP id u51BJXbD004181
	for <linux-btrfs@vger.kernel.org>; Wed, 1 Jun 2016 07:20:15 -0400
Message-Id: <201606011120.u51BJXbD004181@mx0a-001b2d01.pphosted.com>
Received: from e23smtp06.au.ibm.com (e23smtp06.au.ibm.com [202.81.31.148])
	by mx0a-001b2d01.pphosted.com with ESMTP id 239svy932f-1
	(version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
	for <linux-btrfs@vger.kernel.org>; Wed, 01 Jun 2016 07:20:15 -0400
Received: from localhost
	by e23smtp06.au.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <xufeifei@linux.vnet.ibm.com>;
	Wed, 1 Jun 2016 21:20:11 +1000
Received: from d23relay09.au.ibm.com (d23relay09.au.ibm.com [9.185.63.181])
	by d23dlp01.au.ibm.com (Postfix) with ESMTP id C2E652CE8056
	for <linux-btrfs@vger.kernel.org>; Wed,  1 Jun 2016 21:20:08 +1000 (EST)
Received: from d23av06.au.ibm.com (d23av06.au.ibm.com [9.190.235.151])
	by d23relay09.au.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id u51BJxKT55246896
	for <linux-btrfs@vger.kernel.org>; Wed, 1 Jun 2016 21:20:07 +1000
Received: from d23av06.au.ibm.com (localhost [127.0.0.1])
	by d23av06.au.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id u51BJSgf017922
	for <linux-btrfs@vger.kernel.org>; Wed, 1 Jun 2016 21:19:29 +1000
From: Feifei Xu <xufeifei@linux.vnet.ibm.com>
To: linux-btrfs@vger.kernel.org
Cc: steve.capper@linaro.org, chandan@mykolab.com, jbacik@fb.com,
        dsterba@suse.com, chandan@linux.vnet.ibm.com, feifeixu.sh@gmail.com,
        Feifei Xu <xufeifei@linux.vnet.ibm.com>
Subject: [PATCH V2 2/8] Btrfs: Fix integer overflow when calculating bytes_per_bitmap
Date: Wed,  1 Jun 2016 19:18:24 +0800
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
In-Reply-To: <201606011120.u51BJXQB005621@mx0a-001b2d01.pphosted.com>

On ppc64, bytes_per_bitmap will be (65536*8*65536). Hence append UL to
fix integer overflow.

Reviewed-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
Signed-off-by: Feifei Xu <xufeifei@linux.vnet.ibm.com>
---
 fs/btrfs/free-space-cache.c       | 12 ++++++------
 fs/btrfs/tests/free-space-tests.c |  2 +-
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index fa62335..2813ef0 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -29,7 +29,7 @@
 #include "inode-map.h"
 #include "volumes.h"
 
-#define BITS_PER_BITMAP		(PAGE_SIZE * 8)
+#define BITS_PER_BITMAP		(PAGE_SIZE * 8UL)
 #define MAX_CACHE_BYTES_PER_GIG	SZ_32K
 
 struct btrfs_trim_range {
@@ -1415,11 +1415,11 @@ static inline u64 offset_to_bitmap(struct btrfs_free_space_ctl *ctl,
 				   u64 offset)
 {
 	u64 bitmap_start;
-	u32 bytes_per_bitmap;
+	u64 bytes_per_bitmap;
 
 	bytes_per_bitmap = BITS_PER_BITMAP * ctl->unit;
 	bitmap_start = offset - ctl->start;
-	bitmap_start = div_u64(bitmap_start, bytes_per_bitmap);
+	bitmap_start = div64_u64(bitmap_start, bytes_per_bitmap);
 	bitmap_start *= bytes_per_bitmap;
 	bitmap_start += ctl->start;
 
@@ -1638,10 +1638,10 @@ static void recalculate_thresholds(struct btrfs_free_space_ctl *ctl)
 	u64 bitmap_bytes;
 	u64 extent_bytes;
 	u64 size = block_group->key.offset;
-	u32 bytes_per_bg = BITS_PER_BITMAP * ctl->unit;
-	u32 max_bitmaps = div_u64(size + bytes_per_bg - 1, bytes_per_bg);
+	u64 bytes_per_bg = BITS_PER_BITMAP * ctl->unit;
+	u64 max_bitmaps = div64_u64(size + bytes_per_bg - 1, bytes_per_bg);
 
-	max_bitmaps = max_t(u32, max_bitmaps, 1);
+	max_bitmaps = max_t(u64, max_bitmaps, 1);
 
 	ASSERT(ctl->total_bitmaps <= max_bitmaps);
 
diff --git a/fs/btrfs/tests/free-space-tests.c b/fs/btrfs/tests/free-space-tests.c
index 0eeb8f3..f3756d6 100644
--- a/fs/btrfs/tests/free-space-tests.c
+++ b/fs/btrfs/tests/free-space-tests.c
@@ -22,7 +22,7 @@
 #include "../disk-io.h"
 #include "../free-space-cache.h"
 
-#define BITS_PER_BITMAP		(PAGE_SIZE * 8)
+#define BITS_PER_BITMAP		(PAGE_SIZE * 8UL)
 
 /*
  * This test just does basic sanity checking, making sure we can add an extent
-- 
2.7.4

