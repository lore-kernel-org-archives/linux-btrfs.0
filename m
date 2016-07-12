Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pf0-f169.google.com ([209.85.192.169]:36722 "EHLO
	mail-pf0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752166AbcGLXWX (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 12 Jul 2016 19:22:23 -0400
Received: by mail-pf0-f169.google.com with SMTP id t190so11631658pfb.3
        for <linux-btrfs@vger.kernel.org>; Tue, 12 Jul 2016 16:22:18 -0700 (PDT)
From: Omar Sandoval <osandov@osandov.com>
To: linux-btrfs@vger.kernel.org
Cc: Anatoly Pugachev <matorola@gmail.com>,
        Feifei Xu <xufeifei@linux.vnet.ibm.com>
Subject: [PATCH] Btrfs: fix extent buffer bitmap tests on big-endian systems
Date: Tue, 12 Jul 2016 16:21:48 -0700
Message-Id: <e6dc753c434a6570251d68d4233d05e6fa84ac67.1468365157.git.osandov@fb.com>
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
Signed-off-by: Omar Sandoval <osandov@fb.com>
---
This worked for me on a QEMU-emulated MIPS system. Anatoly, could you try this
out and let me know if this fixes your problem? Applies to v4.7-rc7.

 fs/btrfs/tests/extent-io-tests.c | 82 +++++++++++++++++++++++-----------------
 1 file changed, 48 insertions(+), 34 deletions(-)

diff --git a/fs/btrfs/tests/extent-io-tests.c b/fs/btrfs/tests/extent-io-tests.c
index d19ab0317283..0207279a9fa9 100644
--- a/fs/btrfs/tests/extent-io-tests.c
+++ b/fs/btrfs/tests/extent-io-tests.c
@@ -273,20 +273,36 @@ out:
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
+	unsigned long i, j, x;
+	int ret;
 
 	memset(bitmap, 0, len);
 	memset_extent_buffer(eb, 0, 0, len);
@@ -297,16 +313,18 @@ static int __test_eb_bitmaps(unsigned long *bitmap, struct extent_buffer *eb,
 
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
@@ -316,9 +334,10 @@ static int __test_eb_bitmaps(unsigned long *bitmap, struct extent_buffer *eb,
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
@@ -328,9 +347,10 @@ static int __test_eb_bitmaps(unsigned long *bitmap, struct extent_buffer *eb,
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
 
@@ -339,28 +359,22 @@ static int __test_eb_bitmaps(unsigned long *bitmap, struct extent_buffer *eb,
 	 * something repetitive that could miss some hypothetical off-by-n bug.
 	 */
 	x = 0;
+	bitmap_clear(bitmap, 0, len * BITS_PER_BYTE);
+	extent_buffer_bitmap_clear(eb, 0, 0, len * BITS_PER_BYTE);
 	for (i = 0; i < len / sizeof(long); i++) {
 		x = (0x19660dULL * (u64)x + 0x3c6ef35fULL) & 0xffffffffUL;
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
+		for (j = 0; j < BITS_PER_LONG; j++) {
+			if (x & (1 << j)) {
+				bitmap_set(bitmap, i * sizeof(long) + j, 1);
+				extent_buffer_bitmap_set(eb, 0, i * sizeof(long) + j, 1);
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

