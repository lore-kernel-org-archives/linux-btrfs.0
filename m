Return-Path: <SRS0=8Q4i=RV=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 443D0C43381
	for <linux-btrfs@archiver.kernel.org>; Mon, 18 Mar 2019 16:49:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1EBC520854
	for <linux-btrfs@archiver.kernel.org>; Mon, 18 Mar 2019 16:49:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727658AbfCRQtJ (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 18 Mar 2019 12:49:09 -0400
Received: from mx2.suse.de ([195.135.220.15]:55902 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727130AbfCRQtJ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 18 Mar 2019 12:49:09 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 121A8AD3A
        for <linux-btrfs@vger.kernel.org>; Mon, 18 Mar 2019 16:49:08 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id C349CDA8A7; Mon, 18 Mar 2019 17:50:21 +0100 (CET)
From:   David Sterba <dsterba@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     David Sterba <dsterba@suse.com>
Subject: [PATCH 07/22] btrfs: tests: use standard error message after extent buffer allocation failure
Date:   Mon, 18 Mar 2019 17:50:21 +0100
Message-Id: <8b5fc82286b81442cebfa18afa0bfb85fe7de44d.1552927639.git.dsterba@suse.com>
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
 fs/btrfs/tests/extent-io-tests.c       | 4 ++--
 fs/btrfs/tests/free-space-tree-tests.c | 2 +-
 fs/btrfs/tests/inode-tests.c           | 4 ++--
 4 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/tests/extent-buffer-tests.c b/fs/btrfs/tests/extent-buffer-tests.c
index 83814b769bde..dc2582554cf0 100644
--- a/fs/btrfs/tests/extent-buffer-tests.c
+++ b/fs/btrfs/tests/extent-buffer-tests.c
@@ -50,7 +50,7 @@ static int test_btrfs_split_item(u32 sectorsize, u32 nodesize)
 
 	path->nodes[0] = eb = alloc_dummy_extent_buffer(fs_info, nodesize);
 	if (!eb) {
-		test_err("could not allocate dummy buffer");
+		test_std_err(TEST_ALLOC_EXTENT_BUFFER);
 		ret = -ENOMEM;
 		goto out;
 	}
diff --git a/fs/btrfs/tests/extent-io-tests.c b/fs/btrfs/tests/extent-io-tests.c
index 52f30c8738e5..cc9e6c88bcc1 100644
--- a/fs/btrfs/tests/extent-io-tests.c
+++ b/fs/btrfs/tests/extent-io-tests.c
@@ -402,7 +402,7 @@ static int test_eb_bitmaps(u32 sectorsize, u32 nodesize)
 
 	eb = __alloc_dummy_extent_buffer(fs_info, 0, len);
 	if (!eb) {
-		test_err("couldn't allocate test extent buffer");
+		test_std_err(TEST_ALLOC_ROOT);
 		ret = -ENOMEM;
 		goto out;
 	}
@@ -415,7 +415,7 @@ static int test_eb_bitmaps(u32 sectorsize, u32 nodesize)
 	free_extent_buffer(eb);
 	eb = __alloc_dummy_extent_buffer(NULL, nodesize / 2, len);
 	if (!eb) {
-		test_err("couldn't allocate test extent buffer");
+		test_std_err(TEST_ALLOC_ROOT);
 		ret = -ENOMEM;
 		goto out;
 	}
diff --git a/fs/btrfs/tests/free-space-tree-tests.c b/fs/btrfs/tests/free-space-tree-tests.c
index 79b5d0c97b7b..58fbca92dd0d 100644
--- a/fs/btrfs/tests/free-space-tree-tests.c
+++ b/fs/btrfs/tests/free-space-tree-tests.c
@@ -463,7 +463,7 @@ static int run_test(test_func_t test_func, int bitmaps, u32 sectorsize,
 
 	root->node = alloc_test_extent_buffer(root->fs_info, nodesize);
 	if (!root->node) {
-		test_err("couldn't allocate dummy buffer");
+		test_std_err(TEST_ALLOC_EXTENT_BUFFER);
 		ret = -ENOMEM;
 		goto out;
 	}
diff --git a/fs/btrfs/tests/inode-tests.c b/fs/btrfs/tests/inode-tests.c
index 5803f342c47b..e63c128c741c 100644
--- a/fs/btrfs/tests/inode-tests.c
+++ b/fs/btrfs/tests/inode-tests.c
@@ -250,7 +250,7 @@ static noinline int test_btrfs_get_extent(u32 sectorsize, u32 nodesize)
 
 	root->node = alloc_dummy_extent_buffer(fs_info, nodesize);
 	if (!root->node) {
-		test_err("couldn't allocate dummy buffer");
+		test_std_err(TEST_ALLOC_ROOT);
 		goto out;
 	}
 
@@ -851,7 +851,7 @@ static int test_hole_first(u32 sectorsize, u32 nodesize)
 
 	root->node = alloc_dummy_extent_buffer(fs_info, nodesize);
 	if (!root->node) {
-		test_err("couldn't allocate dummy buffer");
+		test_std_err(TEST_ALLOC_ROOT);
 		goto out;
 	}
 
-- 
2.21.0

