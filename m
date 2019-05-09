Return-Path: <SRS0=cuF+=TJ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85400C04AB1
	for <linux-btrfs@archiver.kernel.org>; Thu,  9 May 2019 07:31:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 603AE216C4
	for <linux-btrfs@archiver.kernel.org>; Thu,  9 May 2019 07:31:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726701AbfEIHb4 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 9 May 2019 03:31:56 -0400
Received: from mx2.suse.de ([195.135.220.15]:37122 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726099AbfEIHb4 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 9 May 2019 03:31:56 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 7E781AE24
        for <linux-btrfs@vger.kernel.org>; Thu,  9 May 2019 07:31:54 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs: extent-io: Remove the incorrect comment on RO fs when btrfs_run_delalloc_range() fails
Date:   Thu,  9 May 2019 15:31:50 +0800
Message-Id: <20190509073150.13027-1-wqu@suse.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

At the context of btrfs_run_delalloc_range(), we haven't started/joined
a transaction, thus even something went wrong, we can't and won't abort
transaction, thus no way to make the fs RO.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/extent_io.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 13fca7bfc1f2..85023bb322f0 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -3312,7 +3312,6 @@ static noinline_for_stack int writepage_delalloc(struct inode *inode,
 		}
 		ret = btrfs_run_delalloc_range(inode, page, delalloc_start,
 				delalloc_end, &page_started, nr_written, wbc);
-		/* File system has been set read-only */
 		if (ret) {
 			SetPageError(page);
 			/*
-- 
2.21.0

