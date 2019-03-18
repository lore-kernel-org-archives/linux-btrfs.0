Return-Path: <SRS0=8Q4i=RV=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E0B8C10F00
	for <linux-btrfs@archiver.kernel.org>; Mon, 18 Mar 2019 16:49:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2F8CD20854
	for <linux-btrfs@archiver.kernel.org>; Mon, 18 Mar 2019 16:49:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727647AbfCRQtJ (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 18 Mar 2019 12:49:09 -0400
Received: from mx2.suse.de ([195.135.220.15]:55896 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726846AbfCRQtI (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 18 Mar 2019 12:49:08 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id DBEF3ACFA
        for <linux-btrfs@vger.kernel.org>; Mon, 18 Mar 2019 16:49:07 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 15CDEDAC1C; Mon, 18 Mar 2019 17:50:24 +0100 (CET)
From:   David Sterba <dsterba@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     David Sterba <dsterba@suse.com>
Subject: [PATCH 08/22] btrfs: tests: use standard error message after path allocation failure
Date:   Mon, 18 Mar 2019 17:50:24 +0100
Message-Id: <3c1276338f4be38d6974ffc2b966c11710176c65.1552927639.git.dsterba@suse.com>
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
 fs/btrfs/tests/free-space-tree-tests.c | 2 +-
 fs/btrfs/tests/qgroup-tests.c          | 8 ++++----
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/tests/extent-buffer-tests.c b/fs/btrfs/tests/extent-buffer-tests.c
index dc2582554cf0..a1b9f9b5978e 100644
--- a/fs/btrfs/tests/extent-buffer-tests.c
+++ b/fs/btrfs/tests/extent-buffer-tests.c
@@ -43,7 +43,7 @@ static int test_btrfs_split_item(u32 sectorsize, u32 nodesize)
 
 	path = btrfs_alloc_path();
 	if (!path) {
-		test_err("could not allocate path");
+		test_std_err(TEST_ALLOC_PATH);
 		ret = -ENOMEM;
 		goto out;
 	}
diff --git a/fs/btrfs/tests/free-space-tree-tests.c b/fs/btrfs/tests/free-space-tree-tests.c
index 58fbca92dd0d..22282c16c022 100644
--- a/fs/btrfs/tests/free-space-tree-tests.c
+++ b/fs/btrfs/tests/free-space-tree-tests.c
@@ -486,7 +486,7 @@ static int run_test(test_func_t test_func, int bitmaps, u32 sectorsize,
 
 	path = btrfs_alloc_path();
 	if (!path) {
-		test_err("couldn't allocate path");
+		test_std_err(TEST_ALLOC_ROOT);
 		ret = -ENOMEM;
 		goto out;
 	}
diff --git a/fs/btrfs/tests/qgroup-tests.c b/fs/btrfs/tests/qgroup-tests.c
index 7e25a3a9f979..c85e4b955939 100644
--- a/fs/btrfs/tests/qgroup-tests.c
+++ b/fs/btrfs/tests/qgroup-tests.c
@@ -32,7 +32,7 @@ static int insert_normal_tree_ref(struct btrfs_root *root, u64 bytenr,
 
 	path = btrfs_alloc_path();
 	if (!path) {
-		test_err("couldn't allocate path");
+		test_std_err(TEST_ALLOC_ROOT);
 		return -ENOMEM;
 	}
 
@@ -82,7 +82,7 @@ static int add_tree_ref(struct btrfs_root *root, u64 bytenr, u64 num_bytes,
 
 	path = btrfs_alloc_path();
 	if (!path) {
-		test_err("couldn't allocate path");
+		test_std_err(TEST_ALLOC_ROOT);
 		return -ENOMEM;
 	}
 
@@ -132,7 +132,7 @@ static int remove_extent_item(struct btrfs_root *root, u64 bytenr,
 
 	path = btrfs_alloc_path();
 	if (!path) {
-		test_err("couldn't allocate path");
+		test_std_err(TEST_ALLOC_ROOT);
 		return -ENOMEM;
 	}
 	path->leave_spinning = 1;
@@ -166,7 +166,7 @@ static int remove_extent_ref(struct btrfs_root *root, u64 bytenr,
 
 	path = btrfs_alloc_path();
 	if (!path) {
-		test_err("couldn't allocate path");
+		test_std_err(TEST_ALLOC_ROOT);
 		return -ENOMEM;
 	}
 
-- 
2.21.0

