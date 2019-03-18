Return-Path: <SRS0=8Q4i=RV=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27FB8C10F00
	for <linux-btrfs@archiver.kernel.org>; Mon, 18 Mar 2019 16:48:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0224620854
	for <linux-btrfs@archiver.kernel.org>; Mon, 18 Mar 2019 16:48:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727534AbfCRQsx (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 18 Mar 2019 12:48:53 -0400
Received: from mx2.suse.de ([195.135.220.15]:55850 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727130AbfCRQsx (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 18 Mar 2019 12:48:53 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id B411EAD57
        for <linux-btrfs@vger.kernel.org>; Mon, 18 Mar 2019 16:48:51 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id EF527DA8A7; Mon, 18 Mar 2019 17:50:07 +0100 (CET)
From:   David Sterba <dsterba@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     David Sterba <dsterba@suse.com>
Subject: [PATCH 01/22] btrfs: tests: handle fs_info allocation failure in extent_io tests
Date:   Mon, 18 Mar 2019 17:50:07 +0100
Message-Id: <e5c2d222e4d72e6435622752ef3c3335558ace82.1552927639.git.dsterba@suse.com>
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
 fs/btrfs/tests/extent-io-tests.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/btrfs/tests/extent-io-tests.c b/fs/btrfs/tests/extent-io-tests.c
index 3c46d7f23456..c444243f3fdd 100644
--- a/fs/btrfs/tests/extent-io-tests.c
+++ b/fs/btrfs/tests/extent-io-tests.c
@@ -388,6 +388,10 @@ static int test_eb_bitmaps(u32 sectorsize, u32 nodesize)
 		? sectorsize * 4 : sectorsize;
 
 	fs_info = btrfs_alloc_dummy_fs_info(len, len);
+	if (!fs_info) {
+		test_err("could not allocate fs_info");
+		return -ENOMEM;
+	}
 
 	bitmap = kmalloc(len, GFP_KERNEL);
 	if (!bitmap) {
-- 
2.21.0

