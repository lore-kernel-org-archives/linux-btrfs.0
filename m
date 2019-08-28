Return-Path: <SRS0=UCOX=WY=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E23BC3A5A3
	for <linux-btrfs@archiver.kernel.org>; Wed, 28 Aug 2019 02:33:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6143E208CB
	for <linux-btrfs@archiver.kernel.org>; Wed, 28 Aug 2019 02:33:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726247AbfH1CdT (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 27 Aug 2019 22:33:19 -0400
Received: from mx2.suse.de ([195.135.220.15]:39860 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726232AbfH1CdT (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 27 Aug 2019 22:33:19 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id EB247AF80
        for <linux-btrfs@vger.kernel.org>; Wed, 28 Aug 2019 02:33:17 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH 1/2] btrfs: Consider system chunk array size for new SYSTEM chunks
Date:   Wed, 28 Aug 2019 10:33:12 +0800
Message-Id: <20190828023313.22417-1-wqu@suse.com>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

For SYSTEM chunks, despite the regular chunk item size limit, there is
another limit due to system chunk array size.

The extra limit is removed in a refactor, so just add it back.

Fixes: e3ecdb3fdecf ("btrfs: factor out devs_max setting in __btrfs_alloc_chunk")
Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/volumes.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index a447d3ec48d5..8b72d03738d9 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -4966,6 +4966,7 @@ static int __btrfs_alloc_chunk(struct btrfs_trans_handle *trans,
 	} else if (type & BTRFS_BLOCK_GROUP_SYSTEM) {
 		max_stripe_size = SZ_32M;
 		max_chunk_size = 2 * max_stripe_size;
+		devs_max = min_t(int, devs_max, BTRFS_MAX_DEVS_SYS_CHUNK);
 	} else {
 		btrfs_err(info, "invalid chunk type 0x%llx requested",
 		       type);
-- 
2.23.0

