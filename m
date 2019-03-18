Return-Path: <SRS0=8Q4i=RV=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A870C43381
	for <linux-btrfs@archiver.kernel.org>; Mon, 18 Mar 2019 16:49:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 76A6A204EC
	for <linux-btrfs@archiver.kernel.org>; Mon, 18 Mar 2019 16:49:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727704AbfCRQtQ (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 18 Mar 2019 12:49:16 -0400
Received: from mx2.suse.de ([195.135.220.15]:55940 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727130AbfCRQtP (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 18 Mar 2019 12:49:15 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id C4BFDAD3A
        for <linux-btrfs@vger.kernel.org>; Mon, 18 Mar 2019 16:49:14 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 04B5ADA8A7; Mon, 18 Mar 2019 17:50:30 +0100 (CET)
From:   David Sterba <dsterba@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     David Sterba <dsterba@suse.com>
Subject: [PATCH 11/22] btrfs: tests: properly initialize fs_info of extent buffer
Date:   Mon, 18 Mar 2019 17:50:30 +0100
Message-Id: <7c7776e8d4efec3fe1986251a74b6faa99d12097.1552927639.git.dsterba@suse.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <cover.1552927639.git.dsterba@suse.com>
References: <cover.1552927639.git.dsterba@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

The fs_info is supposed to be valid, even though it's not used right
now and the test does not crash.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/tests/extent-io-tests.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/tests/extent-io-tests.c b/fs/btrfs/tests/extent-io-tests.c
index 8ded2d9b1ac0..1d223086094a 100644
--- a/fs/btrfs/tests/extent-io-tests.c
+++ b/fs/btrfs/tests/extent-io-tests.c
@@ -413,7 +413,7 @@ static int test_eb_bitmaps(u32 sectorsize, u32 nodesize)
 
 	/* Do it over again with an extent buffer which isn't page-aligned. */
 	free_extent_buffer(eb);
-	eb = __alloc_dummy_extent_buffer(NULL, nodesize / 2, len);
+	eb = __alloc_dummy_extent_buffer(fs_info, nodesize / 2, len);
 	if (!eb) {
 		test_std_err(TEST_ALLOC_ROOT);
 		ret = -ENOMEM;
-- 
2.21.0

