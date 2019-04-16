Return-Path: <SRS0=AHcI=SS=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37093C10F13
	for <linux-btrfs@archiver.kernel.org>; Tue, 16 Apr 2019 05:57:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F3A2F2073F
	for <linux-btrfs@archiver.kernel.org>; Tue, 16 Apr 2019 05:57:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726857AbfDPF5o (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 16 Apr 2019 01:57:44 -0400
Received: from mx2.suse.de ([195.135.220.15]:36978 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726590AbfDPF5o (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 16 Apr 2019 01:57:44 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 4AE81ABDC
        for <linux-btrfs@vger.kernel.org>; Tue, 16 Apr 2019 05:57:43 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs: Cleanup btrfs_destroy_delayed_refs()
Date:   Tue, 16 Apr 2019 13:57:39 +0800
Message-Id: <20190416055739.25771-1-wqu@suse.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This patches cleans up btrfs_destroy_delayed_refs() by:
- Remove the forward declaration
  The caller comes after the implementation, no need to do forward
  declaration.

- Remove the @fs_info parameter
  @fs_info can be extracted from @trans parameter.

- Make it return void
  Again, no failure pattern.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/disk-io.c | 13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 6fe9197f6ee4..d83298570bdb 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -54,8 +54,6 @@
 static const struct extent_io_ops btree_extent_io_ops;
 static void end_workqueue_fn(struct btrfs_work *work);
 static void btrfs_destroy_ordered_extents(struct btrfs_root *root);
-static int btrfs_destroy_delayed_refs(struct btrfs_transaction *trans,
-				      struct btrfs_fs_info *fs_info);
 static void btrfs_destroy_delalloc_inodes(struct btrfs_root *root);
 static int btrfs_destroy_marked_extents(struct btrfs_fs_info *fs_info,
 					struct extent_io_tree *dirty_pages,
@@ -4224,13 +4222,12 @@ static void btrfs_destroy_all_ordered_extents(struct btrfs_fs_info *fs_info)
 	btrfs_wait_ordered_roots(fs_info, U64_MAX, 0, (u64)-1);
 }
 
-static int btrfs_destroy_delayed_refs(struct btrfs_transaction *trans,
-				      struct btrfs_fs_info *fs_info)
+static void btrfs_destroy_delayed_refs(struct btrfs_transaction *trans)
 {
+	struct btrfs_fs_info *fs_info = trans->fs_info;
 	struct rb_node *node;
 	struct btrfs_delayed_ref_root *delayed_refs;
 	struct btrfs_delayed_ref_node *ref;
-	int ret = 0;
 
 	delayed_refs = &trans->delayed_refs;
 
@@ -4238,7 +4235,7 @@ static int btrfs_destroy_delayed_refs(struct btrfs_transaction *trans,
 	if (atomic_read(&delayed_refs->num_entries) == 0) {
 		spin_unlock(&delayed_refs->lock);
 		btrfs_info(fs_info, "delayed_refs has NO entry");
-		return ret;
+		return;
 	}
 
 	while ((node = rb_first_cached(&delayed_refs->href_root)) != NULL) {
@@ -4281,8 +4278,6 @@ static int btrfs_destroy_delayed_refs(struct btrfs_transaction *trans,
 	}
 
 	spin_unlock(&delayed_refs->lock);
-
-	return ret;
 }
 
 static void btrfs_destroy_delalloc_inodes(struct btrfs_root *root)
@@ -4488,7 +4483,7 @@ void btrfs_cleanup_one_transaction(struct btrfs_transaction *cur_trans,
 	ASSERT(list_empty(&cur_trans->dirty_bgs));
 	ASSERT(list_empty(&cur_trans->io_bgs));
 
-	btrfs_destroy_delayed_refs(cur_trans, fs_info);
+	btrfs_destroy_delayed_refs(cur_trans);
 
 	cur_trans->state = TRANS_STATE_COMMIT_START;
 	wake_up(&fs_info->transaction_blocked_wait);
-- 
2.21.0

