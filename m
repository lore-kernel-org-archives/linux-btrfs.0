Return-Path: <SRS0=AHcI=SS=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9AF0CC10F13
	for <linux-btrfs@archiver.kernel.org>; Tue, 16 Apr 2019 07:15:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 71ACB2073F
	for <linux-btrfs@archiver.kernel.org>; Tue, 16 Apr 2019 07:15:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728477AbfDPHPf (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 16 Apr 2019 03:15:35 -0400
Received: from mx2.suse.de ([195.135.220.15]:46222 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725865AbfDPHPf (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 16 Apr 2019 03:15:35 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 449C6ACD0
        for <linux-btrfs@vger.kernel.org>; Tue, 16 Apr 2019 07:15:34 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH 2/3] btrfs-progs: Refactor btrfs_finish_extent_commit()
Date:   Tue, 16 Apr 2019 15:15:25 +0800
Message-Id: <20190416071526.3576-3-wqu@suse.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190416071526.3576-1-wqu@suse.com>
References: <20190416071526.3576-1-wqu@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This patch will refactor btrfs_finish_extent_commit() by:
- Make it return void
  There is no failure pattern for btrfs_finish_extent_commit(), thus it
  always return 0. And the caller doesn't care about the return value.
  So no need to return int.

- Remove @root and @unpin parameters
  @root is only used to extract fs_info, which can be extracted from
  transaction handler already.
  @unpin is always fs_info->pinned_extents.
  All these parameters can be extracted from @trans, no need to pass
  them.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 ctree.h       |  4 +---
 extent-tree.c | 14 ++++++--------
 transaction.c |  3 +--
 3 files changed, 8 insertions(+), 13 deletions(-)

diff --git a/ctree.h b/ctree.h
index 3357290d7045..76f52b1c9b08 100644
--- a/ctree.h
+++ b/ctree.h
@@ -2516,9 +2516,7 @@ int btrfs_free_extent(struct btrfs_trans_handle *trans,
 		      struct btrfs_root *root,
 		      u64 bytenr, u64 num_bytes, u64 parent,
 		      u64 root_objectid, u64 owner, u64 offset);
-int btrfs_finish_extent_commit(struct btrfs_trans_handle *trans,
-			       struct btrfs_root *root,
-			       struct extent_io_tree *unpin);
+void btrfs_finish_extent_commit(struct btrfs_trans_handle *trans);
 int btrfs_inc_extent_ref(struct btrfs_trans_handle *trans,
 				struct btrfs_root *root,
 				u64 bytenr, u64 num_bytes, u64 parent,
diff --git a/extent-tree.c b/extent-tree.c
index b7ece0ccc237..1140ebfc61ff 100644
--- a/extent-tree.c
+++ b/extent-tree.c
@@ -1977,27 +1977,25 @@ next:
 	return 0;
 }
 
-int btrfs_finish_extent_commit(struct btrfs_trans_handle *trans,
-			       struct btrfs_root *root,
-			       struct extent_io_tree *unpin)
+void btrfs_finish_extent_commit(struct btrfs_trans_handle *trans)
 {
 	u64 start;
 	u64 end;
 	int ret;
-	struct extent_io_tree *free_space_cache;
-	free_space_cache = &root->fs_info->free_space_cache;
+	struct btrfs_fs_info *fs_info = trans->fs_info;
+	struct extent_io_tree *free_space_cache = &fs_info->free_space_cache;
+	struct extent_io_tree *pinned_extents = &fs_info->pinned_extents;
 
 	while(1) {
-		ret = find_first_extent_bit(unpin, 0, &start, &end,
+		ret = find_first_extent_bit(pinned_extents, 0, &start, &end,
 					    EXTENT_DIRTY);
 		if (ret)
 			break;
 		update_pinned_extents(trans->fs_info, start, end + 1 - start,
 				      0);
-		clear_extent_dirty(unpin, start, end);
+		clear_extent_dirty(pinned_extents, start, end);
 		set_extent_dirty(free_space_cache, start, end);
 	}
-	return 0;
 }
 
 static int pin_down_bytes(struct btrfs_trans_handle *trans, u64 bytenr,
diff --git a/transaction.c b/transaction.c
index 3a63988b0969..8d15eb11c7b5 100644
--- a/transaction.c
+++ b/transaction.c
@@ -198,8 +198,7 @@ commit_tree:
 	if (ret < 0)
 		goto out;
 	ret = write_ctree_super(trans);
-	btrfs_finish_extent_commit(trans, fs_info->extent_root,
-			           &fs_info->pinned_extents);
+	btrfs_finish_extent_commit(trans);
 	kfree(trans);
 	free_extent_buffer(root->commit_root);
 	root->commit_root = NULL;
-- 
2.21.0

