Return-Path: <SRS0=8Q4i=RV=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CDA42C43381
	for <linux-btrfs@archiver.kernel.org>; Mon, 18 Mar 2019 16:49:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A3A6E20854
	for <linux-btrfs@archiver.kernel.org>; Mon, 18 Mar 2019 16:49:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727630AbfCRQtF (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 18 Mar 2019 12:49:05 -0400
Received: from mx2.suse.de ([195.135.220.15]:55890 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727130AbfCRQtF (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 18 Mar 2019 12:49:05 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 4090DACFA
        for <linux-btrfs@vger.kernel.org>; Mon, 18 Mar 2019 16:49:03 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 71EC0DA8A7; Mon, 18 Mar 2019 17:50:19 +0100 (CET)
From:   David Sterba <dsterba@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     David Sterba <dsterba@suse.com>
Subject: [PATCH 06/22] btrfs: tests: use standard error message after root allocation failure
Date:   Mon, 18 Mar 2019 17:50:19 +0100
Message-Id: <ac5d0955a11628c73f87e7bd49c383b6444b1609.1552927639.git.dsterba@suse.com>
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
 fs/btrfs/tests/free-space-tests.c      | 1 +
 fs/btrfs/tests/free-space-tree-tests.c | 2 +-
 fs/btrfs/tests/inode-tests.c           | 6 +++---
 fs/btrfs/tests/qgroup-tests.c          | 6 +++---
 5 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/fs/btrfs/tests/extent-buffer-tests.c b/fs/btrfs/tests/extent-buffer-tests.c
index 74c7975882d1..83814b769bde 100644
--- a/fs/btrfs/tests/extent-buffer-tests.c
+++ b/fs/btrfs/tests/extent-buffer-tests.c
@@ -36,7 +36,7 @@ static int test_btrfs_split_item(u32 sectorsize, u32 nodesize)
 
 	root = btrfs_alloc_dummy_root(fs_info);
 	if (IS_ERR(root)) {
-		test_err("could not allocate root");
+		test_std_err(TEST_ALLOC_ROOT);
 		ret = PTR_ERR(root);
 		goto out;
 	}
diff --git a/fs/btrfs/tests/free-space-tests.c b/fs/btrfs/tests/free-space-tests.c
index 2051e1a19104..8dcdefab1280 100644
--- a/fs/btrfs/tests/free-space-tests.c
+++ b/fs/btrfs/tests/free-space-tests.c
@@ -854,6 +854,7 @@ int btrfs_test_free_space_cache(u32 sectorsize, u32 nodesize)
 
 	root = btrfs_alloc_dummy_root(fs_info);
 	if (IS_ERR(root)) {
+		test_std_err(TEST_ALLOC_ROOT);
 		ret = PTR_ERR(root);
 		goto out;
 	}
diff --git a/fs/btrfs/tests/free-space-tree-tests.c b/fs/btrfs/tests/free-space-tree-tests.c
index 49fbf73c7f2b..79b5d0c97b7b 100644
--- a/fs/btrfs/tests/free-space-tree-tests.c
+++ b/fs/btrfs/tests/free-space-tree-tests.c
@@ -451,7 +451,7 @@ static int run_test(test_func_t test_func, int bitmaps, u32 sectorsize,
 
 	root = btrfs_alloc_dummy_root(fs_info);
 	if (IS_ERR(root)) {
-		test_err("couldn't allocate dummy root");
+		test_std_err(TEST_ALLOC_ROOT);
 		ret = PTR_ERR(root);
 		goto out;
 	}
diff --git a/fs/btrfs/tests/inode-tests.c b/fs/btrfs/tests/inode-tests.c
index 510365370d81..5803f342c47b 100644
--- a/fs/btrfs/tests/inode-tests.c
+++ b/fs/btrfs/tests/inode-tests.c
@@ -244,7 +244,7 @@ static noinline int test_btrfs_get_extent(u32 sectorsize, u32 nodesize)
 
 	root = btrfs_alloc_dummy_root(fs_info);
 	if (IS_ERR(root)) {
-		test_err("couldn't allocate root");
+		test_std_err(TEST_ALLOC_ROOT);
 		goto out;
 	}
 
@@ -845,7 +845,7 @@ static int test_hole_first(u32 sectorsize, u32 nodesize)
 
 	root = btrfs_alloc_dummy_root(fs_info);
 	if (IS_ERR(root)) {
-		test_err("couldn't allocate root");
+		test_std_err(TEST_ALLOC_ROOT);
 		goto out;
 	}
 
@@ -941,7 +941,7 @@ static int test_extent_accounting(u32 sectorsize, u32 nodesize)
 
 	root = btrfs_alloc_dummy_root(fs_info);
 	if (IS_ERR(root)) {
-		test_err("couldn't allocate root");
+		test_std_err(TEST_ALLOC_ROOT);
 		goto out;
 	}
 
diff --git a/fs/btrfs/tests/qgroup-tests.c b/fs/btrfs/tests/qgroup-tests.c
index c620f68462be..7e25a3a9f979 100644
--- a/fs/btrfs/tests/qgroup-tests.c
+++ b/fs/btrfs/tests/qgroup-tests.c
@@ -463,7 +463,7 @@ int btrfs_test_qgroups(u32 sectorsize, u32 nodesize)
 
 	root = btrfs_alloc_dummy_root(fs_info);
 	if (IS_ERR(root)) {
-		test_err("couldn't allocate root");
+		test_std_err(TEST_ALLOC_ROOT);
 		ret = PTR_ERR(root);
 		goto out;
 	}
@@ -495,7 +495,7 @@ int btrfs_test_qgroups(u32 sectorsize, u32 nodesize)
 
 	tmp_root = btrfs_alloc_dummy_root(fs_info);
 	if (IS_ERR(tmp_root)) {
-		test_err("couldn't allocate a fs root");
+		test_std_err(TEST_ALLOC_ROOT);
 		ret = PTR_ERR(tmp_root);
 		goto out;
 	}
@@ -510,7 +510,7 @@ int btrfs_test_qgroups(u32 sectorsize, u32 nodesize)
 
 	tmp_root = btrfs_alloc_dummy_root(fs_info);
 	if (IS_ERR(tmp_root)) {
-		test_err("couldn't allocate a fs root");
+		test_std_err(TEST_ALLOC_ROOT);
 		ret = PTR_ERR(tmp_root);
 		goto out;
 	}
-- 
2.21.0

