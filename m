Return-Path: <SRS0=8Q4i=RV=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9912C43381
	for <linux-btrfs@archiver.kernel.org>; Mon, 18 Mar 2019 16:49:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9388720854
	for <linux-btrfs@archiver.kernel.org>; Mon, 18 Mar 2019 16:49:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727442AbfCRQto (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 18 Mar 2019 12:49:44 -0400
Received: from mx2.suse.de ([195.135.220.15]:56100 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726910AbfCRQto (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 18 Mar 2019 12:49:44 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 28A85ADD4
        for <linux-btrfs@vger.kernel.org>; Mon, 18 Mar 2019 16:49:42 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 6E6BEDA8A7; Mon, 18 Mar 2019 17:50:56 +0100 (CET)
From:   David Sterba <dsterba@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     David Sterba <dsterba@suse.com>
Subject: [PATCH 22/22] btrfs: tests: unify messages when tests start
Date:   Mon, 18 Mar 2019 17:50:56 +0100
Message-Id: <4034c272b16cd94aad148bf7b96c7ed699e6b9a2.1552927639.git.dsterba@suse.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <cover.1552927639.git.dsterba@suse.com>
References: <cover.1552927639.git.dsterba@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

- make the messages more visually consistent and use same format
  "running ... test", any error or other warning can be easily spotted

- move some message to the test entry function

- add message to the inode tests

Example output:

[    8.187391] Btrfs loaded, crc32c=crc32c-generic, assert=on, integrity-checker=on, ref-verify=on
[    8.189476] BTRFS: selftest: sectorsize: 4096  nodesize: 4096
[    8.190761] BTRFS: selftest: running btrfs free space cache tests
[    8.192245] BTRFS: selftest: running extent only tests
[    8.193573] BTRFS: selftest: running bitmap only tests
[    8.194876] BTRFS: selftest: running bitmap and extent tests
[    8.196166] BTRFS: selftest: running space stealing from bitmap to extent tests
[    8.198026] BTRFS: selftest: running extent buffer operation tests
[    8.199328] BTRFS: selftest: running btrfs_split_item tests
[    8.200653] BTRFS: selftest: running extent I/O tests
[    8.201808] BTRFS: selftest: running find delalloc tests
[    8.320733] BTRFS: selftest: running extent buffer bitmap tests
[    8.340795] BTRFS: selftest: running inode tests
[    8.341766] BTRFS: selftest: running btrfs_get_extent tests
[    8.342981] BTRFS: selftest: running hole first btrfs_get_extent test
[    8.344342] BTRFS: selftest: running outstanding_extents tests
[    8.345575] BTRFS: selftest: running qgroup tests
[    8.346537] BTRFS: selftest: running qgroup add/remove tests
[    8.347725] BTRFS: selftest: running qgroup multiple refs test
[    8.354982] BTRFS: selftest: running free space tree tests
[    8.372175] BTRFS: selftest: sectorsize: 4096  nodesize: 8192
[    8.373539] BTRFS: selftest: running btrfs free space cache tests
[    8.374989] BTRFS: selftest: running extent only tests
[    8.376236] BTRFS: selftest: running bitmap only tests
[    8.377483] BTRFS: selftest: running bitmap and extent tests
[    8.378854] BTRFS: selftest: running space stealing from bitmap to extent tests
...

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/tests/free-space-tests.c |  2 +-
 fs/btrfs/tests/inode-tests.c      | 11 ++++++++---
 fs/btrfs/tests/qgroup-tests.c     |  4 ++--
 3 files changed, 11 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/tests/free-space-tests.c b/fs/btrfs/tests/free-space-tests.c
index d0fdc94a5d61..af89f66f9e63 100644
--- a/fs/btrfs/tests/free-space-tests.c
+++ b/fs/btrfs/tests/free-space-tests.c
@@ -404,7 +404,7 @@ test_steal_space_from_bitmap_to_extent(struct btrfs_block_group_cache *cache,
 	};
 	const struct btrfs_free_space_op *orig_free_space_ops;
 
-	test_msg("running space stealing from bitmap to extent");
+	test_msg("running space stealing from bitmap to extent tests");
 
 	/*
 	 * For this test, we want to ensure we end up with an extent entry
diff --git a/fs/btrfs/tests/inode-tests.c b/fs/btrfs/tests/inode-tests.c
index 46571cd27513..3d2c7abda5de 100644
--- a/fs/btrfs/tests/inode-tests.c
+++ b/fs/btrfs/tests/inode-tests.c
@@ -226,6 +226,8 @@ static noinline int test_btrfs_get_extent(u32 sectorsize, u32 nodesize)
 	u64 offset;
 	int ret = -ENOMEM;
 
+	test_msg("running btrfs_get_extent tests");
+
 	inode = btrfs_new_test_inode();
 	if (!inode) {
 		test_std_err(TEST_ALLOC_INODE);
@@ -827,6 +829,8 @@ static int test_hole_first(u32 sectorsize, u32 nodesize)
 	struct extent_map *em = NULL;
 	int ret = -ENOMEM;
 
+	test_msg("running hole first btrfs_get_extent test");
+
 	inode = btrfs_new_test_inode();
 	if (!inode) {
 		test_std_err(TEST_ALLOC_INODE);
@@ -927,6 +931,8 @@ static int test_extent_accounting(u32 sectorsize, u32 nodesize)
 	struct btrfs_root *root = NULL;
 	int ret = -ENOMEM;
 
+	test_msg("running outstanding_extents tests");
+
 	inode = btrfs_new_test_inode();
 	if (!inode) {
 		test_std_err(TEST_ALLOC_INODE);
@@ -1110,17 +1116,16 @@ int btrfs_test_inodes(u32 sectorsize, u32 nodesize)
 {
 	int ret;
 
+	test_msg("running inode tests");
+
 	set_bit(EXTENT_FLAG_COMPRESSED, &compressed_only);
 	set_bit(EXTENT_FLAG_PREALLOC, &prealloc_only);
 
-	test_msg("running btrfs_get_extent tests");
 	ret = test_btrfs_get_extent(sectorsize, nodesize);
 	if (ret)
 		return ret;
-	test_msg("running hole first btrfs_get_extent test");
 	ret = test_hole_first(sectorsize, nodesize);
 	if (ret)
 		return ret;
-	test_msg("running outstanding_extents tests");
 	return test_extent_accounting(sectorsize, nodesize);
 }
diff --git a/fs/btrfs/tests/qgroup-tests.c b/fs/btrfs/tests/qgroup-tests.c
index c85e4b955939..09aaca1efd62 100644
--- a/fs/btrfs/tests/qgroup-tests.c
+++ b/fs/btrfs/tests/qgroup-tests.c
@@ -215,7 +215,7 @@ static int test_no_shared_qgroup(struct btrfs_root *root,
 
 	btrfs_init_dummy_trans(&trans, fs_info);
 
-	test_msg("qgroup basic add");
+	test_msg("running qgroup add/remove tests");
 	ret = btrfs_create_qgroup(&trans, BTRFS_FS_TREE_OBJECTID);
 	if (ret) {
 		test_err("couldn't create a qgroup %d", ret);
@@ -316,7 +316,7 @@ static int test_multiple_refs(struct btrfs_root *root,
 
 	btrfs_init_dummy_trans(&trans, fs_info);
 
-	test_msg("qgroup multiple refs test");
+	test_msg("running qgroup multiple refs test");
 
 	/*
 	 * We have BTRFS_FS_TREE_OBJECTID created already from the
-- 
2.21.0

