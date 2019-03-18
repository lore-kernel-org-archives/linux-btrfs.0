Return-Path: <SRS0=8Q4i=RV=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 826C1C43381
	for <linux-btrfs@archiver.kernel.org>; Mon, 18 Mar 2019 16:49:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4F70020854
	for <linux-btrfs@archiver.kernel.org>; Mon, 18 Mar 2019 16:49:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727600AbfCRQtA (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 18 Mar 2019 12:49:00 -0400
Received: from mx2.suse.de ([195.135.220.15]:55868 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727130AbfCRQs7 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 18 Mar 2019 12:48:59 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id DA072ACFA
        for <linux-btrfs@vger.kernel.org>; Mon, 18 Mar 2019 16:48:58 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id D829FDA8A7; Mon, 18 Mar 2019 17:50:14 +0100 (CET)
From:   David Sterba <dsterba@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     David Sterba <dsterba@suse.com>
Subject: [PATCH 04/22] btrfs: tests: add table of most common errors
Date:   Mon, 18 Mar 2019 17:50:14 +0100
Message-Id: <4610baeba875e4b77dcd6227f4aa4930cc294444.1552927639.git.dsterba@suse.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <cover.1552927639.git.dsterba@suse.com>
References: <cover.1552927639.git.dsterba@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Allocation of main objects like fs_info or extent buffers is in each
test so let's simplify and unify the error messages to a table and add a
convenience helper.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/tests/btrfs-tests.c | 10 ++++++++++
 fs/btrfs/tests/btrfs-tests.h | 14 ++++++++++++++
 2 files changed, 24 insertions(+)

diff --git a/fs/btrfs/tests/btrfs-tests.c b/fs/btrfs/tests/btrfs-tests.c
index 8a59597f1883..7c667aa5425f 100644
--- a/fs/btrfs/tests/btrfs-tests.c
+++ b/fs/btrfs/tests/btrfs-tests.c
@@ -17,6 +17,16 @@
 
 static struct vfsmount *test_mnt = NULL;
 
+const char *test_error[] = {
+	[TEST_ALLOC_FS_INFO]	     = "cannot allocate fs_info",
+	[TEST_ALLOC_ROOT]	     = "cannot allocate root",
+	[TEST_ALLOC_EXTENT_BUFFER]   = "cannot extent buffer",
+	[TEST_ALLOC_PATH]	     = "cannot allocate path",
+	[TEST_ALLOC_INODE]	     = "cannot allocate inode",
+	[TEST_ALLOC_BLOCK_GROUP]     = "cannot allocate block group",
+	[TEST_ALLOC_EXTENT_MAP]      = "cannot allocate extent map",
+};
+
 static const struct super_operations btrfs_test_super_ops = {
 	.alloc_inode	= btrfs_alloc_inode,
 	.destroy_inode	= btrfs_test_destroy_inode,
diff --git a/fs/btrfs/tests/btrfs-tests.h b/fs/btrfs/tests/btrfs-tests.h
index bb9e9c234535..ee277bbd939b 100644
--- a/fs/btrfs/tests/btrfs-tests.h
+++ b/fs/btrfs/tests/btrfs-tests.h
@@ -13,6 +13,20 @@ int btrfs_run_sanity_tests(void);
 #define test_err(fmt, ...) pr_err("BTRFS: selftest: %s:%d " fmt "\n",	\
 		__FILE__, __LINE__, ##__VA_ARGS__)
 
+#define test_std_err(index)	test_err("%s", test_error[index])
+
+enum {
+	TEST_ALLOC_FS_INFO,
+	TEST_ALLOC_ROOT,
+	TEST_ALLOC_EXTENT_BUFFER,
+	TEST_ALLOC_PATH,
+	TEST_ALLOC_INODE,
+	TEST_ALLOC_BLOCK_GROUP,
+	TEST_ALLOC_EXTENT_MAP,
+};
+
+extern const char *test_error[];
+
 struct btrfs_root;
 struct btrfs_trans_handle;
 
-- 
2.21.0

