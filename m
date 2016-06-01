Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:6580 "EHLO
	mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752809AbcFALUf (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 1 Jun 2016 07:20:35 -0400
Received: from pps.filterd (m0049461.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.16.0.11/8.16.0.11) with SMTP id u51BJYYs030369
	for <linux-btrfs@vger.kernel.org>; Wed, 1 Jun 2016 07:20:34 -0400
Message-Id: <201606011120.u51BJYYs030369@mx0a-001b2d01.pphosted.com>
Received: from e23smtp07.au.ibm.com (e23smtp07.au.ibm.com [202.81.31.140])
	by mx0a-001b2d01.pphosted.com with ESMTP id 239u0g6t4k-1
	(version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
	for <linux-btrfs@vger.kernel.org>; Wed, 01 Jun 2016 07:20:33 -0400
Received: from localhost
	by e23smtp07.au.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <xufeifei@linux.vnet.ibm.com>;
	Wed, 1 Jun 2016 21:20:29 +1000
Received: from d23relay09.au.ibm.com (d23relay09.au.ibm.com [9.185.63.181])
	by d23dlp01.au.ibm.com (Postfix) with ESMTP id F132B2CE8046
	for <linux-btrfs@vger.kernel.org>; Wed,  1 Jun 2016 21:20:23 +1000 (EST)
Received: from d23av06.au.ibm.com (d23av06.au.ibm.com [9.190.235.151])
	by d23relay09.au.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id u51BKEWs4915556
	for <linux-btrfs@vger.kernel.org>; Wed, 1 Jun 2016 21:20:21 +1000
Received: from d23av06.au.ibm.com (localhost [127.0.0.1])
	by d23av06.au.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id u51BJl5B018393
	for <linux-btrfs@vger.kernel.org>; Wed, 1 Jun 2016 21:19:48 +1000
From: Feifei Xu <xufeifei@linux.vnet.ibm.com>
To: linux-btrfs@vger.kernel.org
Cc: steve.capper@linaro.org, chandan@mykolab.com, jbacik@fb.com,
        dsterba@suse.com, chandan@linux.vnet.ibm.com, feifeixu.sh@gmail.com,
        Feifei Xu <xufeifei@linux.vnet.ibm.com>
Subject: [PATCH V2 8/8] Btrfs: self-tests: Fix extent buffer bitmap test fail on BE system
Date: Wed,  1 Jun 2016 19:18:30 +0800
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
In-Reply-To: <201606011120.u51BJXQB005621@mx0a-001b2d01.pphosted.com>

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

