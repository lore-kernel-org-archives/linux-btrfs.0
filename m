Return-Path: <SRS0=6ez2=NZ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04891C07E85
	for <linux-btrfs@archiver.kernel.org>; Wed, 14 Nov 2018 13:35:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CA71622419
	for <linux-btrfs@archiver.kernel.org>; Wed, 14 Nov 2018 13:35:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CA71622419
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.de
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732929AbeKNXiv (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 14 Nov 2018 18:38:51 -0500
Received: from mx2.suse.de ([195.135.220.15]:52908 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731585AbeKNXiq (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 14 Nov 2018 18:38:46 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 66BAEB0CE
        for <linux-btrfs@vger.kernel.org>; Wed, 14 Nov 2018 13:35:28 +0000 (UTC)
From:   Johannes Thumshirn <jthumshirn@suse.de>
To:     David Sterba <dsterba@suse.com>
Cc:     Linux BTRFS Mailinglist <linux-btrfs@vger.kernel.org>,
        Johannes Thumshirn <jthumshirn@suse.de>
Subject: [PATCH 4/6] btrfs: remove unused variable tree in bio_readpage_error()
Date:   Wed, 14 Nov 2018 14:35:18 +0100
Message-Id: <20181114133520.16069-5-jthumshirn@suse.de>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20181114133520.16069-1-jthumshirn@suse.de>
References: <20181114133520.16069-1-jthumshirn@suse.de>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Commit 2922040236f9 (btrfs: Remove extent_io_ops::writepage_end_io_hook)
removed the indirection to extent_io_ops::writepage_end_io_hook but didn't
remove the tree variable which then became unused.

Remove 'tree' as well to silence the warning when -Wunused-but-set-variable is
used to compile btrfs.

Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
---
 fs/btrfs/extent_io.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 0f8f9c035812..17a15cc6b542 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -2403,11 +2403,8 @@ static int bio_readpage_error(struct bio *failed_bio, u64 phy_offset,
 void end_extent_writepage(struct page *page, int err, u64 start, u64 end)
 {
 	int uptodate = (err == 0);
-	struct extent_io_tree *tree;
 	int ret = 0;
 
-	tree = &BTRFS_I(page->mapping->host)->io_tree;
-
 	btrfs_writepage_endio_finish_ordered(page, start, end, NULL, uptodate);
 
 	if (!uptodate) {
-- 
2.16.4

