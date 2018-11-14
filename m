Return-Path: <SRS0=6ez2=NZ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE751C18DF5
	for <linux-btrfs@archiver.kernel.org>; Wed, 14 Nov 2018 13:35:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 92896208E7
	for <linux-btrfs@archiver.kernel.org>; Wed, 14 Nov 2018 13:35:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 92896208E7
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.de
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732927AbeKNXis (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 14 Nov 2018 18:38:48 -0500
Received: from mx2.suse.de ([195.135.220.15]:52916 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1732671AbeKNXis (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 14 Nov 2018 18:38:48 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 73916B0D9
        for <linux-btrfs@vger.kernel.org>; Wed, 14 Nov 2018 13:35:28 +0000 (UTC)
From:   Johannes Thumshirn <jthumshirn@suse.de>
To:     David Sterba <dsterba@suse.com>
Cc:     Linux BTRFS Mailinglist <linux-btrfs@vger.kernel.org>,
        Johannes Thumshirn <jthumshirn@suse.de>
Subject: [PATCH 5/6] btrfs: remove unused variable tree in end_compressed_bio_write()
Date:   Wed, 14 Nov 2018 14:35:19 +0100
Message-Id: <20181114133520.16069-6-jthumshirn@suse.de>
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

Remove 'tree' as well to silence the warning when -Wunused-but-set-variable
is used to compile btrfs.

Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
---
 fs/btrfs/compression.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
index bde8d0487bbb..088570c5dfb8 100644
--- a/fs/btrfs/compression.c
+++ b/fs/btrfs/compression.c
@@ -229,7 +229,6 @@ static noinline void end_compressed_writeback(struct inode *inode,
  */
 static void end_compressed_bio_write(struct bio *bio)
 {
-	struct extent_io_tree *tree;
 	struct compressed_bio *cb = bio->bi_private;
 	struct inode *inode;
 	struct page *page;
@@ -248,7 +247,6 @@ static void end_compressed_bio_write(struct bio *bio)
 	 * call back into the FS and do all the end_io operations
 	 */
 	inode = cb->inode;
-	tree = &BTRFS_I(inode)->io_tree;
 	cb->compressed_pages[0]->mapping = cb->inode->i_mapping;
 	btrfs_writepage_endio_finish_ordered(cb->compressed_pages[0],
 			cb->start, cb->start + cb->len - 1, NULL,
-- 
2.16.4

