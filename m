Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pf0-f176.google.com ([209.85.192.176]:33057 "EHLO
	mail-pf0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751133AbcGNXbU (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 14 Jul 2016 19:31:20 -0400
Received: by mail-pf0-f176.google.com with SMTP id y134so8599561pfg.0
        for <linux-btrfs@vger.kernel.org>; Thu, 14 Jul 2016 16:31:20 -0700 (PDT)
From: Omar Sandoval <osandov@osandov.com>
To: linux-btrfs@vger.kernel.org
Cc: kernel-team@fb.com
Subject: [PATCH 2/3] Btrfs: fix extent buffer bitmap tests on big-endian systems
Date: Thu, 14 Jul 2016 16:31:07 -0700
Message-Id: <fd59705a730c316b6cb7adf0762d3b1b1016c512.1468538030.git.osandov@fb.com>
In-Reply-To: <cover.1468538030.git.osandov@fb.com>
References: <cover.1468538030.git.osandov@fb.com>
In-Reply-To: <cover.1468538030.git.osandov@fb.com>
References: <cover.1468538030.git.osandov@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Omar Sandoval <osandov@fb.com>

The in-memory bitmap code manipulates words and is therefore sensitive
to endianness, while the extent buffer bitmap code addresses bytes and
is byte-order agnostic. Because the byte addressing of the extent buffer
bitmaps is equivalent to a little-endian in-memory bitmap, the extent
buffer bitmap tests fail on big-endian systems.

34b3e6c92af1 ("Btrfs: self-tests: Fix extent buffer bitmap test fail on
BE system") worked around another endianness bug in the tests but missed
this one because ed9e4afdb055 ("Btrfs: self-tests: Execute page
straddling test only when nodesize < PAGE_SIZE") disables this part of
the test on ppc64. That change lost the original meaning of the test,
however. We really want to test that an equivalent series of operations
using the in-memory bitmap API and the extent buffer bitmap API produces
equivalent results.

To fix this, don't use memcmp_extent_buffer() or write_extent_buffer();
do everything bit-by-bit.

Reported-by: Anatoly Pugachev <matorola@gmail.com>
Tested-by: Anatoly Pugachev <matorola@gmail.com>
Tested-by: Feifei Xu <xufeifei@linux.vnet.ibm.com>
Signed-off-by: Omar Sandoval <osandov@fb.com>
---
 fs/btrfs/tests/extent-io-tests.c | 87 +++++++++++++++++++++++-----------------
 1 file changed, 51 insertions(+), 36 deletions(-)

diff --git a/fs/btrfs/tests/extent-io-tests.c b/fs/btrfs/tests/extent-io-tests.c
index d19ab0317283..caad80bb9bd0 100644
--- a/fs/btrfs/tests/extent-io-tests.c
+++ b/fs/btrfs/tests/extent-io-tests.c
@@ -273,20 +273,37 @@ out:
 	return ret;
 }
 
-/**
- * test_bit_in_byte - Determine whether a bit is set in a byte
- * @nr: bit number to test
- * @addr: Address to start counting from
- */
-static inline int test_bit_in_byte(int nr, const u8 *addr)
+static int check_eb_bitmap(unsigned long *bitmap, struct extent_buffer *eb,
+			   unsigned long len)
 {
-	return 1UL & (addr[nr / BITS_PER_BYTE] >> (nr & (BITS_PER_BYTE - 1)));
+	unsigned long i;
+
+	for (i = 0; i < len * BITS_PER_BYTE; i++) {
+		int bit, bit1;
+
+		bit = !!test_bit(i, bitmap);
+		bit1 = !!extent_buffer_test_bit(eb, 0, i);
+		if (bit1 != bit) {
+			test_msg("Bits do not match\n");
+			return -EINVAL;
+		}
+
+		bit1 = !!extent_buffer_test_bit(eb, i / BITS_PER_BYTE,
+						i % BITS_PER_BYTE);
+		if (bit1 != bit) {
+			test_msg("Offset bits do not match\n");
+			return -EINVAL;
+		}
+	}
+	return 0;
 }
 
 static int __test_eb_bitmaps(unsigned long *bitmap, struct extent_buffer *eb,
 			     unsigned long len)
 {
-	unsigned long i, x;
+	unsigned long i, j;
+	u32 x;
+	int ret;
 
 	memset(bitmap, 0, len);
 	memset_extent_buffer(eb, 0, 0, len);
@@ -297,16 +314,18 @@ static int __test_eb_bitmaps(unsigned long *bitmap, struct extent_buffer *eb,
 
 	bitmap_set(bitmap, 0, len * BITS_PER_BYTE);
 	extent_buffer_bitmap_set(eb, 0, 0, len * BITS_PER_BYTE);
-	if (memcmp_extent_buffer(eb, bitmap, 0, len) != 0) {
+	ret = check_eb_bitmap(bitmap, eb, len);
+	if (ret) {
 		test_msg("Setting all bits failed\n");
-		return -EINVAL;
+		return ret;
 	}
 
 	bitmap_clear(bitmap, 0, len * BITS_PER_BYTE);
 	extent_buffer_bitmap_clear(eb, 0, 0, len * BITS_PER_BYTE);
-	if (memcmp_extent_buffer(eb, bitmap, 0, len) != 0) {
+	ret = check_eb_bitmap(bitmap, eb, len);
+	if (ret) {
 		test_msg("Clearing all bits failed\n");
-		return -EINVAL;
+		return ret;
 	}
 
 	/* Straddling pages test */
@@ -316,9 +335,10 @@ static int __test_eb_bitmaps(unsigned long *bitmap, struct extent_buffer *eb,
 			sizeof(long) * BITS_PER_BYTE);
 		extent_buffer_bitmap_set(eb, PAGE_SIZE - sizeof(long) / 2, 0,
 					sizeof(long) * BITS_PER_BYTE);
-		if (memcmp_extent_buffer(eb, bitmap, 0, len) != 0) {
+		ret = check_eb_bitmap(bitmap, eb, len);
+		if (ret) {
 			test_msg("Setting straddling pages failed\n");
-			return -EINVAL;
+			return ret;
 		}
 
 		bitmap_set(bitmap, 0, len * BITS_PER_BYTE);
@@ -328,9 +348,10 @@ static int __test_eb_bitmaps(unsigned long *bitmap, struct extent_buffer *eb,
 		extent_buffer_bitmap_set(eb, 0, 0, len * BITS_PER_BYTE);
 		extent_buffer_bitmap_clear(eb, PAGE_SIZE - sizeof(long) / 2, 0,
 					sizeof(long) * BITS_PER_BYTE);
-		if (memcmp_extent_buffer(eb, bitmap, 0, len) != 0) {
+		ret = check_eb_bitmap(bitmap, eb, len);
+		if (ret) {
 			test_msg("Clearing straddling pages failed\n");
-			return -EINVAL;
+			return ret;
 		}
 	}
 
@@ -339,28 +360,22 @@ static int __test_eb_bitmaps(unsigned long *bitmap, struct extent_buffer *eb,
 	 * something repetitive that could miss some hypothetical off-by-n bug.
 	 */
 	x = 0;
-	for (i = 0; i < len / sizeof(long); i++) {
-		x = (0x19660dULL * (u64)x + 0x3c6ef35fULL) & 0xffffffffUL;
-		bitmap[i] = x;
-	}
-	write_extent_buffer(eb, bitmap, 0, len);
-
-	for (i = 0; i < len * BITS_PER_BYTE; i++) {
-		int bit, bit1;
-
-		bit = !!test_bit_in_byte(i, (u8 *)bitmap);
-		bit1 = !!extent_buffer_test_bit(eb, 0, i);
-		if (bit1 != bit) {
-			test_msg("Testing bit pattern failed\n");
-			return -EINVAL;
+	bitmap_clear(bitmap, 0, len * BITS_PER_BYTE);
+	extent_buffer_bitmap_clear(eb, 0, 0, len * BITS_PER_BYTE);
+	for (i = 0; i < len * BITS_PER_BYTE / 32; i++) {
+		x = (0x19660dULL * (u64)x + 0x3c6ef35fULL) & 0xffffffffU;
+		for (j = 0; j < 32; j++) {
+			if (x & (1U << j)) {
+				bitmap_set(bitmap, i * 32 + j, 1);
+				extent_buffer_bitmap_set(eb, 0, i * 32 + j, 1);
+			}
 		}
+	}
 
-		bit1 = !!extent_buffer_test_bit(eb, i / BITS_PER_BYTE,
-						i % BITS_PER_BYTE);
-		if (bit1 != bit) {
-			test_msg("Testing bit pattern with offset failed\n");
-			return -EINVAL;
-		}
+	ret = check_eb_bitmap(bitmap, eb, len);
+	if (ret) {
+		test_msg("Random bit pattern failed\n");
+		return ret;
 	}
 
 	return 0;
-- 
2.9.0

