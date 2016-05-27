Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:55269 "EHLO
	mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755089AbcE0HBz (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 27 May 2016 03:01:55 -0400
Received: from pps.filterd (m0075420.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.16.0.11/8.16.0.11) with SMTP id u4R6xUai016007
	for <linux-btrfs@vger.kernel.org>; Fri, 27 May 2016 03:01:54 -0400
Message-Id: <201605270701.u4R6xUai016007@mx0a-001b2d01.pphosted.com>
Received: from e28smtp03.in.ibm.com (e28smtp03.in.ibm.com [125.16.236.3])
	by mx0a-001b2d01.pphosted.com with ESMTP id 236baagfae-1
	(version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
	for <linux-btrfs@vger.kernel.org>; Fri, 27 May 2016 03:01:53 -0400
Received: from localhost
	by e28smtp03.in.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <xufeifei@linux.vnet.ibm.com>;
	Fri, 27 May 2016 12:31:50 +0530
Received: from d28relay10.in.ibm.com (d28relay10.in.ibm.com [9.184.220.161])
	by d28dlp01.in.ibm.com (Postfix) with ESMTP id 250C9E0060
	for <linux-btrfs@vger.kernel.org>; Fri, 27 May 2016 12:34:57 +0530 (IST)
Received: from d28av03.in.ibm.com (d28av03.in.ibm.com [9.184.220.65])
	by d28relay10.in.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id u4R71ah439845956
	for <linux-btrfs@vger.kernel.org>; Fri, 27 May 2016 12:31:36 +0530
Received: from d28av03.in.ibm.com (localhost [127.0.0.1])
	by d28av03.in.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id u4R71ZbH021867
	for <linux-btrfs@vger.kernel.org>; Fri, 27 May 2016 12:31:36 +0530
From: Feifei Xu <xufeifei@linux.vnet.ibm.com>
To: linux-btrfs@vger.kernel.org
Cc: steve.capper@linaro.org, chandan@mykolab.com, jbacik@fb.com,
        dsterba@suse.com, feifeixu.sh@gmail.com,
        Feifei Xu <xufeifei@linux.vnet.ibm.com>
Subject: [PATCH 5/5] Btrfs: self-test: fix extent buffer bitmap test fail on BE system
Date: Fri, 27 May 2016 15:00:38 +0800
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
In-Reply-To: <201605270701.u4R6xXUw031405@mx0a-001b2d01.pphosted.com>

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
index b06b13a..d33f28f 100644
--- a/fs/btrfs/tests/extent-io-tests.c
+++ b/fs/btrfs/tests/extent-io-tests.c
@@ -275,6 +275,16 @@ out:
 	return ret;
 }
 
+/**
+ * test_bit_in_byte - Determine whether a bit is set in a byte
+ * @nr: bit number to test
+ * @addr: Address to start counting from
+ */
+static inline int test_bit_in_byte(int nr, const u8 *addr)
+{
+	return 1UL & (addr[nr/BITS_PER_BYTE] >> (nr & (BITS_PER_BYTE-1)));
+}
+
 static int __test_eb_bitmaps(unsigned long *bitmap, struct extent_buffer *eb,
 			     unsigned long len)
 {
@@ -339,7 +349,7 @@ static int __test_eb_bitmaps(unsigned long *bitmap, struct extent_buffer *eb,
 	for (i = 0; i < len * BITS_PER_BYTE; i++) {
 		int bit, bit1;
 
-		bit = !!test_bit(i, bitmap);
+		bit = !!test_bit_in_byte(i, (u8 *)bitmap);
 		bit1 = !!extent_buffer_test_bit(eb, 0, i);
 		if (bit1 != bit) {
 			test_msg("Testing bit pattern failed\n");
-- 
2.7.4

