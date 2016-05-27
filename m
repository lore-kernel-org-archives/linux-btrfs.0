Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:16507 "EHLO
	mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754875AbcE0HBo (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 27 May 2016 03:01:44 -0400
Received: from pps.filterd (m0049461.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.16.0.11/8.16.0.11) with SMTP id u4R6xOIa036272
	for <linux-btrfs@vger.kernel.org>; Fri, 27 May 2016 03:01:43 -0400
Message-Id: <201605270701.u4R6xOIa036272@mx0a-001b2d01.pphosted.com>
Received: from e28smtp09.in.ibm.com (e28smtp09.in.ibm.com [125.16.236.9])
	by mx0a-001b2d01.pphosted.com with ESMTP id 236aym8vrg-1
	(version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
	for <linux-btrfs@vger.kernel.org>; Fri, 27 May 2016 03:01:43 -0400
Received: from localhost
	by e28smtp09.in.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <xufeifei@linux.vnet.ibm.com>;
	Fri, 27 May 2016 12:31:39 +0530
Received: from d28relay06.in.ibm.com (d28relay06.in.ibm.com [9.184.220.150])
	by d28dlp02.in.ibm.com (Postfix) with ESMTP id 1808C3940081
	for <linux-btrfs@vger.kernel.org>; Fri, 27 May 2016 12:31:34 +0530 (IST)
Received: from d28av03.in.ibm.com (d28av03.in.ibm.com [9.184.220.65])
	by d28relay06.in.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id u4R71XSR44957788
	for <linux-btrfs@vger.kernel.org>; Fri, 27 May 2016 12:31:33 +0530
Received: from d28av03.in.ibm.com (localhost [127.0.0.1])
	by d28av03.in.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id u4R71VDP021850
	for <linux-btrfs@vger.kernel.org>; Fri, 27 May 2016 12:31:32 +0530
From: Feifei Xu <xufeifei@linux.vnet.ibm.com>
To: linux-btrfs@vger.kernel.org
Cc: steve.capper@linaro.org, chandan@mykolab.com, jbacik@fb.com,
        dsterba@suse.com, feifeixu.sh@gmail.com,
        Feifei Xu <xufeifei@linux.vnet.ibm.com>
Subject: [PATCH 4/5] Btrfs: test_bitmaps: Fix failure on 64k sectorsize
Date: Fri, 27 May 2016 15:00:37 +0800
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
In-Reply-To: <201605270701.u4R6xXUw031405@mx0a-001b2d01.pphosted.com>

With 64K sectorsize, 1G sized block group cannot span across bitmaps.
To execute test_bitmaps() function, this commit allocates
"BITS_PER_BITMAP * sectorsize + PAGE_SIZE" sized block group.

Reviewed-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
Signed-off-by: Feifei Xu <xufeifei@linux.vnet.ibm.com>
---
 fs/btrfs/tests/free-space-tests.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/tests/free-space-tests.c b/fs/btrfs/tests/free-space-tests.c
index 6ec1bd0..aee340b 100644
--- a/fs/btrfs/tests/free-space-tests.c
+++ b/fs/btrfs/tests/free-space-tests.c
@@ -841,7 +841,13 @@ int btrfs_test_free_space_cache(u32 sectorsize, u32 nodesize)
 
 	test_msg("Running btrfs free space cache tests\n");
 
-	cache = btrfs_alloc_dummy_block_group(1024 * 1024 * 1024, sectorsize);
+	/*
+	 * For ppc64 (with 64k page size), bytes per bitmap might be
+	 * larger than 1G.  To make bitmap test available in ppc64,
+	 * alloc dummy block group whose size cross bitmaps.
+	 */
+	cache = btrfs_alloc_dummy_block_group(BITS_PER_BITMAP * sectorsize
+					+ PAGE_SIZE, sectorsize);
 	if (!cache) {
 		test_msg("Couldn't run the tests\n");
 		return 0;
-- 
2.7.4

