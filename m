Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:39270 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751862AbcJBNZk (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 2 Oct 2016 09:25:40 -0400
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.17/8.16.0.17) with SMTP id u92DNBwW053050
        for <linux-btrfs@vger.kernel.org>; Sun, 2 Oct 2016 09:25:40 -0400
Received: from e36.co.us.ibm.com (e36.co.us.ibm.com [32.97.110.154])
        by mx0a-001b2d01.pphosted.com with ESMTP id 25txvnxdub-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-btrfs@vger.kernel.org>; Sun, 02 Oct 2016 09:25:39 -0400
Received: from localhost
        by e36.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-btrfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
        Sun, 2 Oct 2016 07:25:39 -0600
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
To: clm@fb.com, jbacik@fb.com, dsterba@suse.com
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>, linux-btrfs@vger.kernel.org
Subject: [PATCH V21 08/19] Btrfs: subpage-blocksize: Execute sanity tests on all possible block sizes
Date: Sun,  2 Oct 2016 18:54:17 +0530
In-Reply-To: <1475414668-25954-1-git-send-email-chandan@linux.vnet.ibm.com>
References: <1475414668-25954-1-git-send-email-chandan@linux.vnet.ibm.com>
Message-Id: <1475414668-25954-9-git-send-email-chandan@linux.vnet.ibm.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This commit executes sanity tests for all valid sectorsize/nodesize
combinations.

Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
---
 fs/btrfs/tests/btrfs-tests.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/tests/btrfs-tests.c b/fs/btrfs/tests/btrfs-tests.c
index dca90d6..0f2afb6 100644
--- a/fs/btrfs/tests/btrfs-tests.c
+++ b/fs/btrfs/tests/btrfs-tests.c
@@ -261,13 +261,19 @@ int btrfs_run_sanity_tests(void)
 	int ret, i;
 	u32 sectorsize, nodesize;
 	u32 test_sectorsize[] = {
-		PAGE_SIZE,
+		4096,
+		8192,
+		16384,
+		32768,
+		65536,
 	};
 	ret = btrfs_init_test_fs();
 	if (ret)
 		return ret;
 	for (i = 0; i < ARRAY_SIZE(test_sectorsize); i++) {
 		sectorsize = test_sectorsize[i];
+		if (sectorsize > PAGE_SIZE)
+			break;
 		for (nodesize = sectorsize;
 		     nodesize <= BTRFS_MAX_METADATA_BLOCKSIZE;
 		     nodesize <<= 1) {
-- 
2.5.5

