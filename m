Return-Path: <SRS0=uD29=Q4=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94393C43381
	for <linux-btrfs@archiver.kernel.org>; Thu, 21 Feb 2019 08:23:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5BC1D20818
	for <linux-btrfs@archiver.kernel.org>; Thu, 21 Feb 2019 08:23:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727071AbfBUIXD (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 21 Feb 2019 03:23:03 -0500
Received: from mx2.suse.de ([195.135.220.15]:40854 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725943AbfBUIXD (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 21 Feb 2019 03:23:03 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id F2197AD95
        for <linux-btrfs@vger.kernel.org>; Thu, 21 Feb 2019 08:23:01 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: [RFC PATCH] btrfs: Introduce developer-oriented check to ensure all tree blocks are written back before writing super blocks
Date:   Thu, 21 Feb 2019 16:22:49 +0800
Message-Id: <20190221082249.24187-1-wqu@suse.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

There are a lot of error reports complaining about transid error in the
mail list.

Under most case, the on-disk transid is lower than expected transid.
This may indicate that some tree blocks are not written back to disk
before writing super blocks.

This patch will add a safe net for developers, by calling
btrfs_write_and_wait_transaction() before setting transaction unblocked
and double check btree_inode and dirty_pages io_tree, to ensure no tree
blocks are still dirty or under writeback.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
The reason for RFC is, I'm not sure why we currently call
btrfs_write_and_wait_transaction() after setting transaction UNBLOCKED.

It looks like an optimization, but I don't see much performance
difference during regression test.

I hope to move the call before we unblock transaction so we can do such
sanity check for all builds and hope to catch some clue of transid
error.
---
 fs/btrfs/transaction.c | 38 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 38 insertions(+)

diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 4ec2b660d014..30b7ed0bf873 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -2213,6 +2213,44 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans)
 
 	btrfs_trans_release_chunk_metadata(trans);
 
+	/* Last safenet or developer to catch any unwritten tree blocks */
+	if (IS_ENABLED(CONFIG_BTRFS_DEBUG)) {
+		u64 found_start = 0;
+		u64 found_end = 0;
+
+		ret = btrfs_write_and_wait_transaction(trans);
+		if (ret) {
+			btrfs_handle_fs_error(fs_info, ret,
+					      "Error while writing out transaction");
+			mutex_unlock(&fs_info->tree_log_mutex);
+			goto scrub_continue;
+		}
+
+		/* No dirty extent should exist in btree inode */
+		ret = test_range_bit(&trans->transaction->dirty_pages, 0,
+				(u64)-1, EXTENT_DIRTY | EXTENT_WRITEBACK,
+				0, NULL);
+		if (ret > 0) {
+			WARN(1,
+		"dirty_pages not fully written back, start=%llu len=%llu\n",
+			     found_start, found_end + 1 - found_start);
+			ret = -EUCLEAN;
+			mutex_unlock(&fs_info->tree_log_mutex);
+			goto scrub_continue;
+		}
+		ret = test_range_bit(&BTRFS_I(fs_info->btree_inode)->io_tree, 0,
+				     (u64)-1, EXTENT_DIRTY | EXTENT_WRITEBACK,
+				     0, NULL);
+		if (ret > 0) {
+			WARN(1,
+		"btree io_tree not fully written back, start=%llu len=%llu\n",
+			     found_start, found_end + 1 - found_start);
+			ret = -EUCLEAN;
+			mutex_unlock(&fs_info->tree_log_mutex);
+			goto scrub_continue;
+		}
+	}
+
 	spin_lock(&fs_info->trans_lock);
 	cur_trans->state = TRANS_STATE_UNBLOCKED;
 	fs_info->running_transaction = NULL;
-- 
2.20.1

