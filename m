Return-Path: <SRS0=8Q4i=RV=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4CEC3C43381
	for <linux-btrfs@archiver.kernel.org>; Mon, 18 Mar 2019 16:49:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 233B520989
	for <linux-btrfs@archiver.kernel.org>; Mon, 18 Mar 2019 16:49:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727614AbfCRQtD (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 18 Mar 2019 12:49:03 -0400
Received: from mx2.suse.de ([195.135.220.15]:55876 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727130AbfCRQtC (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 18 Mar 2019 12:49:02 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id EE405ACFA
        for <linux-btrfs@vger.kernel.org>; Mon, 18 Mar 2019 16:49:00 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 28EFADA8A7; Mon, 18 Mar 2019 17:50:17 +0100 (CET)
From:   David Sterba <dsterba@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     David Sterba <dsterba@suse.com>
Subject: [PATCH 05/22] btrfs: tests: use standard error message after fs_info allocation failure
Date:   Mon, 18 Mar 2019 17:50:17 +0100
Message-Id: <1ebd5529f755fde631f3b77a9eb39b3769f4c8ce.1552927639.git.dsterba@suse.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <cover.1552927639.git.dsterba@suse.com>
References: <cover.1552927639.git.dsterba@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/tests/extent-buffer-tests.c   | 2 +-
 fs/btrfs/tests/extent-io-tests.c       | 2 +-
 fs/btrfs/tests/extent-map-tests.c      | 2 +-
 fs/btrfs/tests/free-space-tests.c      | 5 +++--
 fs/btrfs/tests/free-space-tree-tests.c | 2 +-
 fs/btrfs/tests/inode-tests.c           | 6 +++---
 fs/btrfs/tests/qgroup-tests.c          | 2 +-
 7 files changed, 11 insertions(+), 10 deletions(-)

diff --git a/fs/btrfs/tests/extent-buffer-tests.c b/fs/btrfs/tests/extent-buffer-tests.c
index 7d72eab6d32c..74c7975882d1 100644
--- a/fs/btrfs/tests/extent-buffer-tests.c
+++ b/fs/btrfs/tests/extent-buffer-tests.c
@@ -30,7 +30,7 @@ static int test_btrfs_split_item(u32 sectorsize, u32 nodesize)
 
 	fs_info = btrfs_alloc_dummy_fs_info(nodesize, sectorsize);
 	if (!fs_info) {
-		test_err("could not allocate fs_info");
+		test_std_err(TEST_ALLOC_FS_INFO);
 		return -ENOMEM;
 	}
 
diff --git a/fs/btrfs/tests/extent-io-tests.c b/fs/btrfs/tests/extent-io-tests.c
index af3309e51876..52f30c8738e5 100644
--- a/fs/btrfs/tests/extent-io-tests.c
+++ b/fs/btrfs/tests/extent-io-tests.c
@@ -389,7 +389,7 @@ static int test_eb_bitmaps(u32 sectorsize, u32 nodesize)
 
 	fs_info = btrfs_alloc_dummy_fs_info(len, len);
 	if (!fs_info) {
-		test_err("could not allocate fs_info");
+		test_std_err(TEST_ALLOC_FS_INFO);
 		return -ENOMEM;
 	}
 
diff --git a/fs/btrfs/tests/extent-map-tests.c b/fs/btrfs/tests/extent-map-tests.c
index bf15d3a7f20e..662b718506b9 100644
--- a/fs/btrfs/tests/extent-map-tests.c
+++ b/fs/btrfs/tests/extent-map-tests.c
@@ -349,7 +349,7 @@ int btrfs_test_extent_map(void)
 	 */
 	fs_info = btrfs_alloc_dummy_fs_info(PAGE_SIZE, PAGE_SIZE);
 	if (!fs_info) {
-		test_msg("Couldn't allocate dummy fs info");
+		test_std_err(TEST_ALLOC_FS_INFO);
 		return -ENOMEM;
 	}
 
diff --git a/fs/btrfs/tests/free-space-tests.c b/fs/btrfs/tests/free-space-tests.c
index 5c2f77e9439b..2051e1a19104 100644
--- a/fs/btrfs/tests/free-space-tests.c
+++ b/fs/btrfs/tests/free-space-tests.c
@@ -834,9 +834,10 @@ int btrfs_test_free_space_cache(u32 sectorsize, u32 nodesize)
 
 	test_msg("running btrfs free space cache tests");
 	fs_info = btrfs_alloc_dummy_fs_info(nodesize, sectorsize);
-	if (!fs_info)
+	if (!fs_info) {
+		test_std_err(TEST_ALLOC_FS_INFO);
 		return -ENOMEM;
-
+	}
 
 	/*
 	 * For ppc64 (with 64k page size), bytes per bitmap might be
diff --git a/fs/btrfs/tests/free-space-tree-tests.c b/fs/btrfs/tests/free-space-tree-tests.c
index 89346da890cf..49fbf73c7f2b 100644
--- a/fs/btrfs/tests/free-space-tree-tests.c
+++ b/fs/btrfs/tests/free-space-tree-tests.c
@@ -444,7 +444,7 @@ static int run_test(test_func_t test_func, int bitmaps, u32 sectorsize,
 
 	fs_info = btrfs_alloc_dummy_fs_info(nodesize, sectorsize);
 	if (!fs_info) {
-		test_err("couldn't allocate dummy fs info");
+		test_std_err(TEST_ALLOC_FS_INFO);
 		ret = -ENOMEM;
 		goto out;
 	}
diff --git a/fs/btrfs/tests/inode-tests.c b/fs/btrfs/tests/inode-tests.c
index af0c8e30d9e2..510365370d81 100644
--- a/fs/btrfs/tests/inode-tests.c
+++ b/fs/btrfs/tests/inode-tests.c
@@ -238,7 +238,7 @@ static noinline int test_btrfs_get_extent(u32 sectorsize, u32 nodesize)
 
 	fs_info = btrfs_alloc_dummy_fs_info(nodesize, sectorsize);
 	if (!fs_info) {
-		test_err("couldn't allocate dummy fs info");
+		test_std_err(TEST_ALLOC_FS_INFO);
 		goto out;
 	}
 
@@ -839,7 +839,7 @@ static int test_hole_first(u32 sectorsize, u32 nodesize)
 
 	fs_info = btrfs_alloc_dummy_fs_info(nodesize, sectorsize);
 	if (!fs_info) {
-		test_err("couldn't allocate dummy fs info");
+		test_std_err(TEST_ALLOC_FS_INFO);
 		goto out;
 	}
 
@@ -935,7 +935,7 @@ static int test_extent_accounting(u32 sectorsize, u32 nodesize)
 
 	fs_info = btrfs_alloc_dummy_fs_info(nodesize, sectorsize);
 	if (!fs_info) {
-		test_err("couldn't allocate dummy fs info");
+		test_std_err(TEST_ALLOC_FS_INFO);
 		goto out;
 	}
 
diff --git a/fs/btrfs/tests/qgroup-tests.c b/fs/btrfs/tests/qgroup-tests.c
index 412b910b04cc..c620f68462be 100644
--- a/fs/btrfs/tests/qgroup-tests.c
+++ b/fs/btrfs/tests/qgroup-tests.c
@@ -457,7 +457,7 @@ int btrfs_test_qgroups(u32 sectorsize, u32 nodesize)
 
 	fs_info = btrfs_alloc_dummy_fs_info(nodesize, sectorsize);
 	if (!fs_info) {
-		test_err("couldn't allocate dummy fs info");
+		test_std_err(TEST_ALLOC_FS_INFO);
 		return -ENOMEM;
 	}
 
-- 
2.21.0

