Return-Path: <SRS0=8Q4i=RV=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02C88C43381
	for <linux-btrfs@archiver.kernel.org>; Mon, 18 Mar 2019 16:49:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D092B20854
	for <linux-btrfs@archiver.kernel.org>; Mon, 18 Mar 2019 16:49:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727774AbfCRQtj (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 18 Mar 2019 12:49:39 -0400
Received: from mx2.suse.de ([195.135.220.15]:56094 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727442AbfCRQti (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 18 Mar 2019 12:49:38 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id D5C47ADD4
        for <linux-btrfs@vger.kernel.org>; Mon, 18 Mar 2019 16:49:37 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 1E906DA8A7; Mon, 18 Mar 2019 17:50:54 +0100 (CET)
From:   David Sterba <dsterba@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     David Sterba <dsterba@suse.com>
Subject: [PATCH 21/22] btrfs: tests: drop messages when some tests finish
Date:   Mon, 18 Mar 2019 17:50:54 +0100
Message-Id: <1fc33831cd1dcda4ae28c8a51f3a9380e77c2a0e.1552927639.git.dsterba@suse.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <cover.1552927639.git.dsterba@suse.com>
References: <cover.1552927639.git.dsterba@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

The messages like 'extent I/O tests finished' are redundant, if the test
fails it's quite obvious in the log and hang is also noticeable. No
other then extent_io and free space tree tests print that so make it
consistent.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/tests/extent-io-tests.c  | 1 -
 fs/btrfs/tests/free-space-tests.c | 1 -
 2 files changed, 2 deletions(-)

diff --git a/fs/btrfs/tests/extent-io-tests.c b/fs/btrfs/tests/extent-io-tests.c
index 1d223086094a..843b53e64528 100644
--- a/fs/btrfs/tests/extent-io-tests.c
+++ b/fs/btrfs/tests/extent-io-tests.c
@@ -440,6 +440,5 @@ int btrfs_test_extent_io(u32 sectorsize, u32 nodesize)
 
 	ret = test_eb_bitmaps(sectorsize, nodesize);
 out:
-	test_msg("extent I/O tests finished");
 	return ret;
 }
diff --git a/fs/btrfs/tests/free-space-tests.c b/fs/btrfs/tests/free-space-tests.c
index dcbe526e5698..d0fdc94a5d61 100644
--- a/fs/btrfs/tests/free-space-tests.c
+++ b/fs/btrfs/tests/free-space-tests.c
@@ -876,6 +876,5 @@ int btrfs_test_free_space_cache(u32 sectorsize, u32 nodesize)
 	btrfs_free_dummy_block_group(cache);
 	btrfs_free_dummy_root(root);
 	btrfs_free_dummy_fs_info(fs_info);
-	test_msg("free space cache tests finished");
 	return ret;
 }
-- 
2.21.0

