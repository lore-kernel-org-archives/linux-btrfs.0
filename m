Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from e19.ny.us.ibm.com ([129.33.205.209]:58146 "EHLO
	e19.ny.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932108AbcFAPxR (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 1 Jun 2016 11:53:17 -0400
Received: from localhost
	by e19.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <xufeifei@linux.vnet.ibm.com>;
	Wed, 1 Jun 2016 11:53:10 -0400
From: Feifei Xu <xufeifei@linux.vnet.ibm.com>
To: linux-btrfs@vger.kernel.org
Cc: steve.capper@linaro.org, chandan@mykolab.com, jbacik@fb.com,
        dsterba@suse.com, chandan@linux.vnet.ibm.com, feifeixu.sh@gmail.com,
        Feifei Xu <xufeifei@linux.vnet.ibm.com>
Subject: [PATCH V2 5/8] Btrfs: self-tests: Support testing all possible sectorsizes and nodesizes
Date: Wed,  1 Jun 2016 15:51:44 +0000
Message-Id: <1464796307-67173-6-git-send-email-xufeifei@linux.vnet.ibm.com>
In-Reply-To: <1464796307-67173-1-git-send-email-xufeifei@linux.vnet.ibm.com>
References: <1464796307-67173-1-git-send-email-xufeifei@linux.vnet.ibm.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

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

