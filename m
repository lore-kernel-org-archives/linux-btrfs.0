Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from e17.ny.us.ibm.com ([129.33.205.207]:57017 "EHLO
	e17.ny.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932108AbcFAPxL (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 1 Jun 2016 11:53:11 -0400
Received: from localhost
	by e17.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <xufeifei@linux.vnet.ibm.com>;
	Wed, 1 Jun 2016 11:53:10 -0400
From: Feifei Xu <xufeifei@linux.vnet.ibm.com>
To: linux-btrfs@vger.kernel.org
Cc: steve.capper@linaro.org, chandan@mykolab.com, jbacik@fb.com,
        dsterba@suse.com, chandan@linux.vnet.ibm.com, feifeixu.sh@gmail.com,
        Feifei Xu <xufeifei@linux.vnet.ibm.com>
Subject: [PATCH V2 8/8] Btrfs: self-tests: Fix extent buffer bitmap test fail on BE system
Date: Wed,  1 Jun 2016 15:51:47 +0000
Message-Id: <1464796307-67173-9-git-send-email-xufeifei@linux.vnet.ibm.com>
In-Reply-To: <1464796307-67173-1-git-send-email-xufeifei@linux.vnet.ibm.com>
References: <1464796307-67173-1-git-send-email-xufeifei@linux.vnet.ibm.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

In __test_eb_bitmaps(), we write random data to a bitmap. Then copy
the bitmap to another bitmap that resides inside an extent buffer.
Later we verify the values of corresponding bits in the bitmap and the
bitmap inside the extent buffer. However, extent_buffer_test_bit()
reads in byte granularity while test_bit() reads in unsigned long
granularity. Hence we end up comparing wrong bits on big-endian
systems such as ppc64. This commit fixes the issue by reading the
bitmap in byte granularity.

Reviewed-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
Signed-off-by: Feifei Xu <xufeifei@linux.vnet.ibm.com>
---
 fs/btrfs/tests/extent-io-tests.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/tests/extent-io-tests.c b/fs/btrfs/tests/extent-io-tests.c
index d7f5bbb..0f7cfab 100644
--- a/fs/btrfs/tests/extent-io-tests.c
+++ b/fs/btrfs/tests/extent-io-tests.c
@@ -273,6 +273,16 @@ out:
 	return ret;
 }
 
+/**
+ * test_bit_in_byte - Determine whether a bit is set in a byte
+ * @nr: bit number to test
+ * @addr: Address to start counting from
+ */
+static inline int test_bit_in_byte(int nr, const u8 *addr)
+{
+	return 1UL & (addr[nr / BITS_PER_BYTE] >> (nr & (BITS_PER_BYTE - 1)));
+}
+
 static int __test_eb_bitmaps(unsigned long *bitmap, struct extent_buffer *eb,
 			     unsigned long len)
 {
@@ -338,7 +348,7 @@ static int __test_eb_bitmaps(unsigned long *bitmap, struct extent_buffer *eb,
 	for (i = 0; i < len * BITS_PER_BYTE; i++) {
 		int bit, bit1;
 
-		bit = !!test_bit(i, bitmap);
+		bit = !!test_bit_in_byte(i, (u8 *)bitmap);
 		bit1 = !!extent_buffer_test_bit(eb, 0, i);
 		if (bit1 != bit) {
 			test_msg("Testing bit pattern failed\n");
-- 
2.7.4

