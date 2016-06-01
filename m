Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from e38.co.us.ibm.com ([32.97.110.159]:47992 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751648AbcFAPwp (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 1 Jun 2016 11:52:45 -0400
Received: from localhost
	by e38.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <xufeifei@linux.vnet.ibm.com>;
	Wed, 1 Jun 2016 09:52:44 -0600
From: Feifei Xu <xufeifei@linux.vnet.ibm.com>
To: linux-btrfs@vger.kernel.org
Cc: steve.capper@linaro.org, chandan@mykolab.com, jbacik@fb.com,
        dsterba@suse.com, chandan@linux.vnet.ibm.com, feifeixu.sh@gmail.com,
        Feifei Xu <xufeifei@linux.vnet.ibm.com>
Subject: [PATCH V2 4/8] Btrfs: self-tests: Execute page straddling test only when nodesize < PAGE_SIZE
Date: Wed,  1 Jun 2016 15:51:43 +0000
Message-Id: <1464796307-67173-5-git-send-email-xufeifei@linux.vnet.ibm.com>
In-Reply-To: <1464796307-67173-1-git-send-email-xufeifei@linux.vnet.ibm.com>
References: <1464796307-67173-1-git-send-email-xufeifei@linux.vnet.ibm.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

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

