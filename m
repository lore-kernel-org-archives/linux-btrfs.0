Return-Path: <SRS0=DuSC=DH=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06B4CC47420
	for <linux-btrfs@archiver.kernel.org>; Wed, 30 Sep 2020 01:56:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B2A5821531
	for <linux-btrfs@archiver.kernel.org>; Wed, 30 Sep 2020 01:56:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="kVuybwbs"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729905AbgI3B4o (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 29 Sep 2020 21:56:44 -0400
Received: from mx2.suse.de ([195.135.220.15]:50550 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729898AbgI3B4n (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 29 Sep 2020 21:56:43 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1601431002;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TI5TPLiEU5zKd52eOxhVCHK7Ya0tQFmlIXIWvc5peHo=;
        b=kVuybwbsV35OrGULLtXKpTbed1MOvfZ6W5Mg1j+k+FKMNKWiII+0ULkxLhZxHkHMNgUhEB
        NIU3WvPlgei/en72xKP6oCKRa0K26PrIazwOFP6/XOlwJ3e6kMCXPQz4e5JEKCnEYFa7SM
        UTWLmPNvNkLE8YNGrqCYu8qx6WoTUK8=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id CA7DDAF99
        for <linux-btrfs@vger.kernel.org>; Wed, 30 Sep 2020 01:56:42 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH v3 27/49] btrfs: extent_io: don't allow tree block to cross page boundary for subpage support
Date:   Wed, 30 Sep 2020 09:55:17 +0800
Message-Id: <20200930015539.48867-28-wqu@suse.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200930015539.48867-1-wqu@suse.com>
References: <20200930015539.48867-1-wqu@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

As a preparation for subpage sector size support (allowing filesystem
with sector size smaller than page size to be mounted) if the sector
size is smaller than page size, we don't allow tree block to be read if
it crosses 64K(*) boundary.

The 64K is selected because:
- We are only going to support 64K page size for subpage for now
- 64K is also the max node size btrfs supports

This ensures that, tree blocks are always contained in one page for a
system with 64K page size, which can greatly simplify the handling.

Or we need to do complex multi-page handling for tree blocks.

Currently the only way to create such tree blocks crossing 64K boundary
is by btrfs-convert, which will get fixed soon and doesn't get
wide-spread usage.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/extent_io.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 50cd5efc79ab..28188509a206 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -5268,6 +5268,13 @@ struct extent_buffer *alloc_extent_buffer(struct btrfs_fs_info *fs_info,
 		btrfs_err(fs_info, "bad tree block start %llu", start);
 		return ERR_PTR(-EINVAL);
 	}
+	if (btrfs_is_subpage(fs_info) && round_down(start, PAGE_SIZE) !=
+	    round_down(start + len - 1, PAGE_SIZE)) {
+		btrfs_err(fs_info,
+		"tree block crosses page boundary, start %llu nodesize %lu",
+			  start, len);
+		return ERR_PTR(-EINVAL);
+	}
 
 	eb = find_extent_buffer(fs_info, start);
 	if (eb)
-- 
2.28.0

