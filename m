Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17630C4708F
	for <linux-btrfs@archiver.kernel.org>; Mon, 31 May 2021 08:51:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ED4A060FEB
	for <linux-btrfs@archiver.kernel.org>; Mon, 31 May 2021 08:51:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230483AbhEaIxY (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 31 May 2021 04:53:24 -0400
Received: from mx2.suse.de ([195.135.220.15]:41066 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230514AbhEaIxS (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 31 May 2021 04:53:18 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1622451098; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fgWAUgevymMQjo0fJYC778dFvvYwPIBTjm3Jm8ozieE=;
        b=vNouQWtQDquzvuU7Vib65px+/0CaDHYeYtfU1PrFKIP5ut/QBKTKK+Tqp215dI91b9WirL
        8gkspddV2F52F2xMmKqcOiu70fl5NN7toOlB61pare+mHe7o6UvqHkHOIiZJ/ZhRMlfDBn
        k4++dUflj0W3o0unH8wnGHjjVJrNODo=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 2C0F3B2E9
        for <linux-btrfs@vger.kernel.org>; Mon, 31 May 2021 08:51:38 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH v4 15/30] btrfs: make btrfs_truncate_block() to be subpage compatible
Date:   Mon, 31 May 2021 16:50:51 +0800
Message-Id: <20210531085106.259490-16-wqu@suse.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531085106.259490-1-wqu@suse.com>
References: <20210531085106.259490-1-wqu@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

btrfs_truncate_block() itself is already mostly subpage compatible, the
only missing part is the page dirtying code.

Currently if we have a sector that needs to be truncated, we set the
sector aligned range delalloc, then set the full page dirty.

The problem is, current subpage code requires subpage dirty bit to be
set, or __extent_writepage_io() won't submit bio, thus leads to ordered
extent never to finish.

So this patch will make btrfs_truncate_block() to call
btrfs_page_set_dirty() helper to replace set_page_dirty() to fix the
problem.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/inode.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 7bf6ed4b4530..909aadc098ce 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -4946,7 +4946,8 @@ int btrfs_truncate_block(struct btrfs_inode *inode, loff_t from, loff_t len,
 		flush_dcache_page(page);
 	}
 	ClearPageChecked(page);
-	set_page_dirty(page);
+	btrfs_page_set_dirty(fs_info, page, block_start,
+			     block_end + 1 - block_start);
 	unlock_extent_cached(io_tree, block_start, block_end, &cached_state);
 
 	if (only_release_metadata)
-- 
2.31.1

