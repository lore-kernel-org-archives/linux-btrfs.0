Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:2998 "EHLO
	mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751727AbcFALUx (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 1 Jun 2016 07:20:53 -0400
Received: from pps.filterd (m0048817.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.16.0.11/8.16.0.11) with SMTP id u51BJXUj003293
	for <linux-btrfs@vger.kernel.org>; Wed, 1 Jun 2016 07:20:52 -0400
Message-Id: <201606011120.u51BJXUj003293@mx0a-001b2d01.pphosted.com>
Received: from e23smtp02.au.ibm.com (e23smtp02.au.ibm.com [202.81.31.144])
	by mx0a-001b2d01.pphosted.com with ESMTP id 239r98bf81-1
	(version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
	for <linux-btrfs@vger.kernel.org>; Wed, 01 Jun 2016 07:20:52 -0400
Received: from localhost
	by e23smtp02.au.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <xufeifei@linux.vnet.ibm.com>;
	Wed, 1 Jun 2016 21:20:48 +1000
Received: from d23relay09.au.ibm.com (d23relay09.au.ibm.com [9.185.63.181])
	by d23dlp01.au.ibm.com (Postfix) with ESMTP id 274EB2CE805A
	for <linux-btrfs@vger.kernel.org>; Wed,  1 Jun 2016 21:20:41 +1000 (EST)
Received: from d23av06.au.ibm.com (d23av06.au.ibm.com [9.190.235.151])
	by d23relay09.au.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id u51BKJKl59244640
	for <linux-btrfs@vger.kernel.org>; Wed, 1 Jun 2016 21:20:30 +1000
Received: from d23av06.au.ibm.com (localhost [127.0.0.1])
	by d23av06.au.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id u51BJifh018311
	for <linux-btrfs@vger.kernel.org>; Wed, 1 Jun 2016 21:19:45 +1000
From: Feifei Xu <xufeifei@linux.vnet.ibm.com>
To: linux-btrfs@vger.kernel.org
Cc: steve.capper@linaro.org, chandan@mykolab.com, jbacik@fb.com,
        dsterba@suse.com, chandan@linux.vnet.ibm.com, feifeixu.sh@gmail.com,
        Feifei Xu <xufeifei@linux.vnet.ibm.com>
Subject: [PATCH V2 7/8] Btrfs: self-tests: Fix test_bitmaps fail on 64k sectorsize
Date: Wed,  1 Jun 2016 19:18:29 +0800
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
In-Reply-To: <201606011120.u51BJXQB005621@mx0a-001b2d01.pphosted.com>

With 64K sectorsize, 1G sized block group cannot span across bitmaps.
To execute test_bitmaps() function, this commit allocates
"BITS_PER_BITMAP * sectorsize + PAGE_SIZE" sized block group.

Reviewed-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
Signed-off-by: Feifei Xu <xufeifei@linux.vnet.ibm.com>
---
 fs/btrfs/tests/free-space-tests.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/tests/free-space-tests.c b/fs/btrfs/tests/free-space-tests.c
index 029343b..3956bb2 100644
--- a/fs/btrfs/tests/free-space-tests.c
+++ b/fs/btrfs/tests/free-space-tests.c
@@ -843,7 +843,13 @@ int btrfs_test_free_space_cache(u32 sectorsize, u32 nodesize)
 
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

