Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:46294 "EHLO
	mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751451AbcE0HBj (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 27 May 2016 03:01:39 -0400
Received: from pps.filterd (m0048827.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.16.0.11/8.16.0.11) with SMTP id u4R6xYex031495
	for <linux-btrfs@vger.kernel.org>; Fri, 27 May 2016 03:01:39 -0400
Message-Id: <201605270701.u4R6xYex031495@mx0a-001b2d01.pphosted.com>
Received: from e28smtp01.in.ibm.com (e28smtp01.in.ibm.com [125.16.236.1])
	by mx0a-001b2d01.pphosted.com with ESMTP id 236bdbgbpr-1
	(version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
	for <linux-btrfs@vger.kernel.org>; Fri, 27 May 2016 03:01:37 -0400
Received: from localhost
	by e28smtp01.in.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <xufeifei@linux.vnet.ibm.com>;
	Fri, 27 May 2016 12:31:32 +0530
Received: from d28relay10.in.ibm.com (d28relay10.in.ibm.com [9.184.220.161])
	by d28dlp03.in.ibm.com (Postfix) with ESMTP id C6456125806F
	for <linux-btrfs@vger.kernel.org>; Fri, 27 May 2016 12:33:45 +0530 (IST)
Received: from d28av03.in.ibm.com (d28av03.in.ibm.com [9.184.220.65])
	by d28relay10.in.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id u4R71Q7029229154
	for <linux-btrfs@vger.kernel.org>; Fri, 27 May 2016 12:31:26 +0530
Received: from d28av03.in.ibm.com (localhost [127.0.0.1])
	by d28av03.in.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id u4R71OP4021802
	for <linux-btrfs@vger.kernel.org>; Fri, 27 May 2016 12:31:25 +0530
From: Feifei Xu <xufeifei@linux.vnet.ibm.com>
To: linux-btrfs@vger.kernel.org
Cc: steve.capper@linaro.org, chandan@mykolab.com, jbacik@fb.com,
        dsterba@suse.com, feifeixu.sh@gmail.com,
        Feifei Xu <xufeifei@linux.vnet.ibm.com>
Subject: [PATCH 2/5] Btrfs: Fix integer overflow when calculating bytes_per_bitmap
Date: Fri, 27 May 2016 15:00:35 +0800
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
In-Reply-To: <201605270701.u4R6xXUw031405@mx0a-001b2d01.pphosted.com>

On ppc64, bytes_per_bitmap will be (65536*8*65536). Hence append UL to
fix integer overflow.

Reviewed-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
Signed-off-by: Feifei Xu <xufeifei@linux.vnet.ibm.com>
---
 fs/btrfs/free-space-cache.c       | 13 +++++++------
 fs/btrfs/tests/free-space-tests.c |  2 +-
 2 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index 05c9ef8..95ee9e8 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -29,7 +29,8 @@
 #include "inode-map.h"
 #include "volumes.h"
 
-#define BITS_PER_BITMAP		(PAGE_SIZE * 8)
+#define BITS_PER_BITMAP		(PAGE_SIZE * 8UL)
+
 #define MAX_CACHE_BYTES_PER_GIG	SZ_32K
 
 struct btrfs_trim_range {
@@ -1415,11 +1416,11 @@ static inline u64 offset_to_bitmap(struct btrfs_free_space_ctl *ctl,
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
 
@@ -1638,10 +1639,10 @@ static void recalculate_thresholds(struct btrfs_free_space_ctl *ctl)
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
index 5142475..f568630 100644
--- a/fs/btrfs/tests/free-space-tests.c
+++ b/fs/btrfs/tests/free-space-tests.c
@@ -22,7 +22,7 @@
 #include "../disk-io.h"
 #include "../free-space-cache.h"
 
-#define BITS_PER_BITMAP		(PAGE_SIZE * 8)
+#define BITS_PER_BITMAP		(PAGE_SIZE * 8UL)
 
 /*
  * This test just does basic sanity checking, making sure we can add an exten
-- 
2.7.4

