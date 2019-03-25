Return-Path: <SRS0=58CB=R4=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A19EC43381
	for <linux-btrfs@archiver.kernel.org>; Mon, 25 Mar 2019 18:45:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4B49D20700
	for <linux-btrfs@archiver.kernel.org>; Mon, 25 Mar 2019 18:45:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729994AbfCYSpE (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 25 Mar 2019 14:45:04 -0400
Received: from mx2.suse.de ([195.135.220.15]:38866 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728991AbfCYSpD (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 25 Mar 2019 14:45:03 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id BC06AAF94
        for <linux-btrfs@vger.kernel.org>; Mon, 25 Mar 2019 18:45:02 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id E8290DA98F; Mon, 25 Mar 2019 19:46:15 +0100 (CET)
From:   David Sterba <dsterba@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     David Sterba <dsterba@suse.com>
Subject: [PATCH 01/30] btrfs: get fs_info from eb in lock_extent_buffer_for_io
Date:   Mon, 25 Mar 2019 19:46:15 +0100
Message-Id: <cfd3dbef0b825c16a671278e06307864a2e584cc.1553539114.git.dsterba@suse.com>
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
 fs/btrfs/extent_io.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 75062e2b1912..af720b2c2aeb 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -3494,11 +3494,10 @@ void wait_on_extent_buffer_writeback(struct extent_buffer *eb)
  * Return >0 is same as 0, except bio is not submitted
  * Return <0 if something went wrong, no page is locked
  */
-static noinline_for_stack int
-lock_extent_buffer_for_io(struct extent_buffer *eb,
-			  struct btrfs_fs_info *fs_info,
+static noinline_for_stack int lock_extent_buffer_for_io(struct extent_buffer *eb,
 			  struct extent_page_data *epd)
 {
+	struct btrfs_fs_info *fs_info = eb->fs_info;
 	int i, num_pages, failed_page_nr;
 	int flush = 0;
 	int ret = 0;
@@ -3825,7 +3824,7 @@ int btree_write_cache_pages(struct address_space *mapping,
 				continue;
 
 			prev_eb = eb;
-			ret = lock_extent_buffer_for_io(eb, fs_info, &epd);
+			ret = lock_extent_buffer_for_io(eb, &epd);
 			if (!ret) {
 				free_extent_buffer(eb);
 				continue;
-- 
2.21.0

