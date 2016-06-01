Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:24526 "EHLO
	mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752483AbcFALUt (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 1 Jun 2016 07:20:49 -0400
Received: from pps.filterd (m0048817.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.16.0.11/8.16.0.11) with SMTP id u51BJVGc003246
	for <linux-btrfs@vger.kernel.org>; Wed, 1 Jun 2016 07:20:48 -0400
Message-Id: <201606011120.u51BJVGc003246@mx0a-001b2d01.pphosted.com>
Received: from e23smtp04.au.ibm.com (e23smtp04.au.ibm.com [202.81.31.146])
	by mx0a-001b2d01.pphosted.com with ESMTP id 239r98bf61-1
	(version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
	for <linux-btrfs@vger.kernel.org>; Wed, 01 Jun 2016 07:20:48 -0400
Received: from localhost
	by e23smtp04.au.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <xufeifei@linux.vnet.ibm.com>;
	Wed, 1 Jun 2016 21:20:45 +1000
Received: from d23relay10.au.ibm.com (d23relay10.au.ibm.com [9.190.26.77])
	by d23dlp03.au.ibm.com (Postfix) with ESMTP id 4C8903578052
	for <linux-btrfs@vger.kernel.org>; Wed,  1 Jun 2016 21:20:26 +1000 (EST)
Received: from d23av06.au.ibm.com (d23av06.au.ibm.com [9.190.235.151])
	by d23relay10.au.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id u51BKB8h4653476
	for <linux-btrfs@vger.kernel.org>; Wed, 1 Jun 2016 21:20:20 +1000
Received: from d23av06.au.ibm.com (localhost [127.0.0.1])
	by d23av06.au.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id u51BJcjO018122
	for <linux-btrfs@vger.kernel.org>; Wed, 1 Jun 2016 21:19:39 +1000
From: Feifei Xu <xufeifei@linux.vnet.ibm.com>
To: linux-btrfs@vger.kernel.org
Cc: steve.capper@linaro.org, chandan@mykolab.com, jbacik@fb.com,
        dsterba@suse.com, chandan@linux.vnet.ibm.com, feifeixu.sh@gmail.com,
        Feifei Xu <xufeifei@linux.vnet.ibm.com>
Subject: [PATCH V2 5/8] Btrfs: self-tests: Support testing all possible sectorsizes and nodesizes
Date: Wed,  1 Jun 2016 19:18:27 +0800
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
In-Reply-To: <201606011120.u51BJXQB005621@mx0a-001b2d01.pphosted.com>

To test all possible sectorsizes, this commit adds a sectorsize
array. This commit executes the tests for all possible sectorsizes and
nodesizes.

Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
Signed-off-by: Feifei Xu <xufeifei@linux.vnet.ibm.com>
---
 fs/btrfs/super.c | 54 ++++++++++++++++++++++++++++++++----------------------
 1 file changed, 32 insertions(+), 22 deletions(-)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 5b0b354..c49d7ae 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -2318,32 +2318,42 @@ static void btrfs_print_mod_info(void)
 
 static int btrfs_run_sanity_tests(void)
 {
-	int ret;
+	int ret, i;
 	u32 sectorsize, nodesize;
-
-	sectorsize = PAGE_SIZE;
-	nodesize = PAGE_SIZE;
+	u32 test_sectorsize[] = {
+		PAGE_SIZE,
+	};
 	ret = btrfs_init_test_fs();
 	if (ret)
 		return ret;
-
-	ret = btrfs_test_free_space_cache(sectorsize, nodesize);
-	if (ret)
-		goto out;
-	ret = btrfs_test_extent_buffer_operations(sectorsize,
-		nodesize);
-	if (ret)
-		goto out;
-	ret = btrfs_test_extent_io(sectorsize, nodesize);
-	if (ret)
-		goto out;
-	ret = btrfs_test_inodes(sectorsize, nodesize);
-	if (ret)
-		goto out;
-	ret = btrfs_test_qgroups(sectorsize, nodesize);
-	if (ret)
-		goto out;
-	ret = btrfs_test_free_space_tree(sectorsize, nodesize);
+	for (i = 0; i < ARRAY_SIZE(test_sectorsize); i++) {
+		sectorsize = test_sectorsize[i];
+		for (nodesize = sectorsize;
+		     nodesize <= BTRFS_MAX_METADATA_BLOCKSIZE;
+		     nodesize <<= 1) {
+			pr_info("BTRFS: selftest: sectorsize: %u  nodesize: %u\n",
+				sectorsize, nodesize);
+			ret = btrfs_test_free_space_cache(sectorsize, nodesize);
+			if (ret)
+				goto out;
+			ret = btrfs_test_extent_buffer_operations(sectorsize,
+				nodesize);
+			if (ret)
+				goto out;
+			ret = btrfs_test_extent_io(sectorsize, nodesize);
+			if (ret)
+				goto out;
+			ret = btrfs_test_inodes(sectorsize, nodesize);
+			if (ret)
+				goto out;
+			ret = btrfs_test_qgroups(sectorsize, nodesize);
+			if (ret)
+				goto out;
+			ret = btrfs_test_free_space_tree(sectorsize, nodesize);
+			if (ret)
+				goto out;
+		}
+	}
 out:
 	btrfs_destroy_test_fs();
 	return ret;
-- 
2.7.4

