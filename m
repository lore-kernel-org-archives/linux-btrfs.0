Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from e37.co.us.ibm.com ([32.97.110.158]:35924 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751648AbcFAPw7 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 1 Jun 2016 11:52:59 -0400
Received: from localhost
	by e37.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <xufeifei@linux.vnet.ibm.com>;
	Wed, 1 Jun 2016 09:52:57 -0600
From: Feifei Xu <xufeifei@linux.vnet.ibm.com>
To: linux-btrfs@vger.kernel.org
Cc: steve.capper@linaro.org, chandan@mykolab.com, jbacik@fb.com,
        dsterba@suse.com, chandan@linux.vnet.ibm.com, feifeixu.sh@gmail.com,
        Feifei Xu <xufeifei@linux.vnet.ibm.com>
Subject: [PATCH V2 7/8] Btrfs: self-tests: Fix test_bitmaps fail on 64k sectorsize
Date: Wed,  1 Jun 2016 15:51:46 +0000
Message-Id: <1464796307-67173-8-git-send-email-xufeifei@linux.vnet.ibm.com>
In-Reply-To: <1464796307-67173-1-git-send-email-xufeifei@linux.vnet.ibm.com>
References: <1464796307-67173-1-git-send-email-xufeifei@linux.vnet.ibm.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

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

