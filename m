Return-Path: <SRS0=8Q4i=RV=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EDB8CC43381
	for <linux-btrfs@archiver.kernel.org>; Mon, 18 Mar 2019 16:49:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BEA2420854
	for <linux-btrfs@archiver.kernel.org>; Mon, 18 Mar 2019 16:49:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727685AbfCRQtL (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 18 Mar 2019 12:49:11 -0400
Received: from mx2.suse.de ([195.135.220.15]:55908 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727130AbfCRQtL (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 18 Mar 2019 12:49:11 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 2B95CACFA
        for <linux-btrfs@vger.kernel.org>; Mon, 18 Mar 2019 16:49:10 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 5CC03DA8A7; Mon, 18 Mar 2019 17:50:26 +0100 (CET)
From:   David Sterba <dsterba@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     David Sterba <dsterba@suse.com>
Subject: [PATCH 09/22] btrfs: tests: use standard error message after inode allocation failure
Date:   Mon, 18 Mar 2019 17:50:26 +0100
Message-Id: <e94afa8ab76491d231afb9559d3e93acb74abb81.1552927639.git.dsterba@suse.com>
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
 fs/btrfs/tests/extent-io-tests.c | 2 +-
 fs/btrfs/tests/inode-tests.c     | 6 +++---
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/tests/extent-io-tests.c b/fs/btrfs/tests/extent-io-tests.c
index cc9e6c88bcc1..8ded2d9b1ac0 100644
--- a/fs/btrfs/tests/extent-io-tests.c
+++ b/fs/btrfs/tests/extent-io-tests.c
@@ -73,7 +73,7 @@ static int test_find_delalloc(u32 sectorsize)
 
 	inode = btrfs_new_test_inode();
 	if (!inode) {
-		test_err("failed to allocate test inode");
+		test_std_err(TEST_ALLOC_INODE);
 		return -ENOMEM;
 	}
 
diff --git a/fs/btrfs/tests/inode-tests.c b/fs/btrfs/tests/inode-tests.c
index e63c128c741c..46571cd27513 100644
--- a/fs/btrfs/tests/inode-tests.c
+++ b/fs/btrfs/tests/inode-tests.c
@@ -228,7 +228,7 @@ static noinline int test_btrfs_get_extent(u32 sectorsize, u32 nodesize)
 
 	inode = btrfs_new_test_inode();
 	if (!inode) {
-		test_err("couldn't allocate inode");
+		test_std_err(TEST_ALLOC_INODE);
 		return ret;
 	}
 
@@ -829,7 +829,7 @@ static int test_hole_first(u32 sectorsize, u32 nodesize)
 
 	inode = btrfs_new_test_inode();
 	if (!inode) {
-		test_err("couldn't allocate inode");
+		test_std_err(TEST_ALLOC_INODE);
 		return ret;
 	}
 
@@ -929,7 +929,7 @@ static int test_extent_accounting(u32 sectorsize, u32 nodesize)
 
 	inode = btrfs_new_test_inode();
 	if (!inode) {
-		test_err("couldn't allocate inode");
+		test_std_err(TEST_ALLOC_INODE);
 		return ret;
 	}
 
-- 
2.21.0

