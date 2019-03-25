Return-Path: <SRS0=58CB=R4=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5FD3FC10F03
	for <linux-btrfs@archiver.kernel.org>; Mon, 25 Mar 2019 18:45:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 36B2720700
	for <linux-btrfs@archiver.kernel.org>; Mon, 25 Mar 2019 18:45:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730056AbfCYSpI (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 25 Mar 2019 14:45:08 -0400
Received: from mx2.suse.de ([195.135.220.15]:38880 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728991AbfCYSpI (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 25 Mar 2019 14:45:08 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 4EFF6AF94
        for <linux-btrfs@vger.kernel.org>; Mon, 25 Mar 2019 18:45:07 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 8A4EBDA98F; Mon, 25 Mar 2019 19:46:20 +0100 (CET)
From:   David Sterba <dsterba@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     David Sterba <dsterba@suse.com>
Subject: [PATCH 03/30] btrfs: get fs_info from eb in write_one_eb
Date:   Mon, 25 Mar 2019 19:46:20 +0100
Message-Id: <8bb108235f5745bf047644a6735154c4273efd04.1553539114.git.dsterba@suse.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <cover.1553539114.git.dsterba@suse.com>
References: <cover.1553539114.git.dsterba@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

We can read fs_info from extent buffer and can drop it from the
parameters.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/extent_io.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index a74278187fcd..ae3746829e41 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -3677,10 +3677,10 @@ static void end_bio_extent_buffer_writepage(struct bio *bio)
 }
 
 static noinline_for_stack int write_one_eb(struct extent_buffer *eb,
-			struct btrfs_fs_info *fs_info,
 			struct writeback_control *wbc,
 			struct extent_page_data *epd)
 {
+	struct btrfs_fs_info *fs_info = eb->fs_info;
 	struct block_device *bdev = fs_info->fs_devices->latest_bdev;
 	struct extent_io_tree *tree = &BTRFS_I(fs_info->btree_inode)->io_tree;
 	u64 offset = eb->start;
@@ -3749,7 +3749,6 @@ int btree_write_cache_pages(struct address_space *mapping,
 				   struct writeback_control *wbc)
 {
 	struct extent_io_tree *tree = &BTRFS_I(mapping->host)->io_tree;
-	struct btrfs_fs_info *fs_info = BTRFS_I(mapping->host)->root->fs_info;
 	struct extent_buffer *eb, *prev_eb = NULL;
 	struct extent_page_data epd = {
 		.bio = NULL,
@@ -3830,7 +3829,7 @@ int btree_write_cache_pages(struct address_space *mapping,
 				continue;
 			}
 
-			ret = write_one_eb(eb, fs_info, wbc, &epd);
+			ret = write_one_eb(eb, wbc, &epd);
 			if (ret) {
 				done = 1;
 				free_extent_buffer(eb);
-- 
2.21.0

