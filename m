Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26180C388F9
	for <linux-btrfs@archiver.kernel.org>; Wed, 11 Nov 2020 07:02:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ACE80206C0
	for <linux-btrfs@archiver.kernel.org>; Wed, 11 Nov 2020 07:02:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="RTD5ttrH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726107AbgKKHCy (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 11 Nov 2020 02:02:54 -0500
Received: from mx2.suse.de ([195.135.220.15]:58260 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726070AbgKKHCv (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 11 Nov 2020 02:02:51 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1605078170;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=TNAMG3sXYzA4Nn3etX6HvUtH97HGY3NLIJmL+POH9pI=;
        b=RTD5ttrHJ/twjJ4UvM20WpDGwu8lpz74rxlW14gj7x8aWStNrk1A/oJhqF9YKawesgHHDa
        v6vXRTef5qFg41SGeQsJ0vlg969a5JCH8rl1X5WeFVggp81s+GSQCAGiFSH6XV/yj61sCE
        lOcCh0f1e8ASRRUOC49vtizFK/ylqK0=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 4228AABD1
        for <linux-btrfs@vger.kernel.org>; Wed, 11 Nov 2020 07:02:50 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs: tests: fix free space tree test failure on 64K page system
Date:   Wed, 11 Nov 2020 15:02:45 +0800
Message-Id: <20201111070245.92797-1-wqu@suse.com>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

When trying to load btrfs with selftest compiled in, on 64K page system
the test will always fail:

  BTRFS: selftest: running free space tree tests
  BTRFS: selftest: fs/btrfs/tests/free-space-tree-tests.c:101 free space tree is invalid
  BTRFS: selftest: fs/btrfs/tests/free-space-tree-tests.c:529 test_empty_block_group [btrfs] failed with extents, sectorsize=65536, nodesize=65536, alignment=134217728

The cause is that, after commit 801dc0c9ff1f ("btrfs: replace div_u64 by
shift in free_space_bitmap_size"), we use fs_info->sectorsize_bits for
free space cache.

But in comit fc59cfa7d2ab ("btrfs: use precalculated sectorsize_bits
from fs_info"), we only initialized the fs_info for non-testing
environment, leaving the default bits to be ilog2(4K), screwing up the
selftest on 64K page system.

Fix it by also honor sectorsize_bits in selftest.

David, please fold this fix into the offending commit.

Fixes: fc59cfa7d2ab ("btrfs: use precalculated sectorsize_bits from fs_info")
Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/tests/btrfs-tests.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/btrfs/tests/btrfs-tests.c b/fs/btrfs/tests/btrfs-tests.c
index 8519f7746b2e..8ca334d554af 100644
--- a/fs/btrfs/tests/btrfs-tests.c
+++ b/fs/btrfs/tests/btrfs-tests.c
@@ -134,6 +134,7 @@ struct btrfs_fs_info *btrfs_alloc_dummy_fs_info(u32 nodesize, u32 sectorsize)
 
 	fs_info->nodesize = nodesize;
 	fs_info->sectorsize = sectorsize;
+	fs_info->sectorsize_bits = ilog2(sectorsize);
 	set_bit(BTRFS_FS_STATE_DUMMY_FS_INFO, &fs_info->fs_state);
 
 	test_mnt->mnt_sb->s_fs_info = fs_info;
-- 
2.29.2

