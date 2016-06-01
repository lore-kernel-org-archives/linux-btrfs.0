Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:54832 "EHLO
	mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750697AbcFAMam (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 1 Jun 2016 08:30:42 -0400
Received: from pps.filterd (m0048827.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.16.0.11/8.16.0.11) with SMTP id u51CTE9K012739
	for <linux-btrfs@vger.kernel.org>; Wed, 1 Jun 2016 08:30:41 -0400
Message-Id: <201606011230.u51CTE9K012739@mx0a-001b2d01.pphosted.com>
Received: from e23smtp01.au.ibm.com (e23smtp01.au.ibm.com [202.81.31.143])
	by mx0a-001b2d01.pphosted.com with ESMTP id 239t3saqk5-1
	(version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
	for <linux-btrfs@vger.kernel.org>; Wed, 01 Jun 2016 08:30:41 -0400
Received: from localhost
	by e23smtp01.au.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <xufeifei@linux.vnet.ibm.com>;
	Wed, 1 Jun 2016 21:20:13 +1000
Received: from d23relay06.au.ibm.com (d23relay06.au.ibm.com [9.185.63.219])
	by d23dlp02.au.ibm.com (Postfix) with ESMTP id 310CB2BB005A
	for <linux-btrfs@vger.kernel.org>; Wed,  1 Jun 2016 21:20:09 +1000 (EST)
Received: from d23av06.au.ibm.com (d23av06.au.ibm.com [9.190.235.151])
	by d23relay06.au.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id u51BK0eu10682748
	for <linux-btrfs@vger.kernel.org>; Wed, 1 Jun 2016 21:20:08 +1000
Received: from d23av06.au.ibm.com (localhost [127.0.0.1])
	by d23av06.au.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id u51BJZeq018042
	for <linux-btrfs@vger.kernel.org>; Wed, 1 Jun 2016 21:19:35 +1000
From: Feifei Xu <xufeifei@linux.vnet.ibm.com>
To: linux-btrfs@vger.kernel.org
Cc: steve.capper@linaro.org, chandan@mykolab.com, jbacik@fb.com,
        dsterba@suse.com, chandan@linux.vnet.ibm.com, feifeixu.sh@gmail.com,
        Feifei Xu <xufeifei@linux.vnet.ibm.com>
Subject: [PATCH V2 4/8] Btrfs: self-tests: Execute page straddling test only when nodesize < PAGE_SIZE
Date: Wed,  1 Jun 2016 19:18:26 +0800
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
In-Reply-To: <201606011120.u51BJXQB005621@mx0a-001b2d01.pphosted.com>

On ppc64, PAGE_SIZE is 64k which is same as BTRFS_MAX_METADATA_BLOCKSIZE.
In such a scenario, we will never be able to have an extent buffer
containing more than one page. Hence in such cases this commit does not
execute the page straddling tests.

Signed-off-by: Feifei Xu <xufeifei@linux.vnet.ibm.com>
Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
---
 fs/btrfs/tests/extent-io-tests.c | 49 ++++++++++++++++++++++++----------------
 1 file changed, 30 insertions(+), 19 deletions(-)

diff --git a/fs/btrfs/tests/extent-io-tests.c b/fs/btrfs/tests/extent-io-tests.c
index 755fceb..d7f5bbb 100644
--- a/fs/btrfs/tests/extent-io-tests.c
+++ b/fs/btrfs/tests/extent-io-tests.c
@@ -21,6 +21,7 @@
 #include <linux/slab.h>
 #include <linux/sizes.h>
 #include "btrfs-tests.h"
+#include "../ctree.h"
 #include "../extent_io.h"
 
 #define PROCESS_UNLOCK		(1 << 0)
@@ -298,25 +299,29 @@ static int __test_eb_bitmaps(unsigned long *bitmap, struct extent_buffer *eb,
 		return -EINVAL;
 	}
 
-	bitmap_set(bitmap, (PAGE_SIZE - sizeof(long) / 2) * BITS_PER_BYTE,
-		   sizeof(long) * BITS_PER_BYTE);
-	extent_buffer_bitmap_set(eb, PAGE_SIZE - sizeof(long) / 2, 0,
-				 sizeof(long) * BITS_PER_BYTE);
-	if (memcmp_extent_buffer(eb, bitmap, 0, len) != 0) {
-		test_msg("Setting straddling pages failed\n");
-		return -EINVAL;
-	}
+	/* Straddling pages test */
+	if (len > PAGE_SIZE) {
+		bitmap_set(bitmap,
+			(PAGE_SIZE - sizeof(long) / 2) * BITS_PER_BYTE,
+			sizeof(long) * BITS_PER_BYTE);
+		extent_buffer_bitmap_set(eb, PAGE_SIZE - sizeof(long) / 2, 0,
+					sizeof(long) * BITS_PER_BYTE);
+		if (memcmp_extent_buffer(eb, bitmap, 0, len) != 0) {
+			test_msg("Setting straddling pages failed\n");
+			return -EINVAL;
+		}
 
-	bitmap_set(bitmap, 0, len * BITS_PER_BYTE);
-	bitmap_clear(bitmap,
-		     (PAGE_SIZE - sizeof(long) / 2) * BITS_PER_BYTE,
-		     sizeof(long) * BITS_PER_BYTE);
-	extent_buffer_bitmap_set(eb, 0, 0, len * BITS_PER_BYTE);
-	extent_buffer_bitmap_clear(eb, PAGE_SIZE - sizeof(long) / 2, 0,
-				   sizeof(long) * BITS_PER_BYTE);
-	if (memcmp_extent_buffer(eb, bitmap, 0, len) != 0) {
-		test_msg("Clearing straddling pages failed\n");
-		return -EINVAL;
+		bitmap_set(bitmap, 0, len * BITS_PER_BYTE);
+		bitmap_clear(bitmap,
+			(PAGE_SIZE - sizeof(long) / 2) * BITS_PER_BYTE,
+			sizeof(long) * BITS_PER_BYTE);
+		extent_buffer_bitmap_set(eb, 0, 0, len * BITS_PER_BYTE);
+		extent_buffer_bitmap_clear(eb, PAGE_SIZE - sizeof(long) / 2, 0,
+					sizeof(long) * BITS_PER_BYTE);
+		if (memcmp_extent_buffer(eb, bitmap, 0, len) != 0) {
+			test_msg("Clearing straddling pages failed\n");
+			return -EINVAL;
+		}
 	}
 
 	/*
@@ -359,7 +364,13 @@ static int test_eb_bitmaps(u32 sectorsize, u32 nodesize)
 	int ret;
 
 	test_msg("Running extent buffer bitmap tests\n");
-	len = sectorsize * 4;
+
+	/*
+	* In ppc64, sectorsize can be 64K, thus 4 * 64K will be
+	* larger than BTRFS_MAX_METADATA_BLOCKSIZE.
+	*/
+	len = (sectorsize < BTRFS_MAX_METADATA_BLOCKSIZE)
+		? sectorsize * 4 : sectorsize;
 
 	bitmap = kmalloc(len, GFP_KERNEL);
 	if (!bitmap) {
-- 
2.7.4

