Return-Path: <SRS0=AHcI=SS=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9467DC10F13
	for <linux-btrfs@archiver.kernel.org>; Tue, 16 Apr 2019 05:16:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5FB392073F
	for <linux-btrfs@archiver.kernel.org>; Tue, 16 Apr 2019 05:16:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725861AbfDPFQn (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 16 Apr 2019 01:16:43 -0400
Received: from mx2.suse.de ([195.135.220.15]:33514 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725802AbfDPFQm (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 16 Apr 2019 01:16:42 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id B4AE4AEBB
        for <linux-btrfs@vger.kernel.org>; Tue, 16 Apr 2019 05:16:41 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs: Make btrfs_finish_extent_commit() return void
Date:   Tue, 16 Apr 2019 13:16:37 +0800
Message-Id: <20190416051637.18548-1-wqu@suse.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This function always return 0, and the only use case of @ret is to
output warning message for discard failure, which doesn't cause anything
wrong to the fs even discarding failed.

There is no need to make it return int.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/ctree.h       | 2 +-
 fs/btrfs/extent-tree.c | 4 +---
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index b3642367a595..129f7520dc5f 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -2758,7 +2758,7 @@ int btrfs_free_reserved_extent(struct btrfs_fs_info *fs_info,
 int btrfs_free_and_pin_reserved_extent(struct btrfs_fs_info *fs_info,
 				       u64 start, u64 len);
 void btrfs_prepare_extent_commit(struct btrfs_fs_info *fs_info);
-int btrfs_finish_extent_commit(struct btrfs_trans_handle *trans);
+void btrfs_finish_extent_commit(struct btrfs_trans_handle *trans);
 int btrfs_inc_extent_ref(struct btrfs_trans_handle *trans,
 			 struct btrfs_root *root,
 			 u64 bytenr, u64 num_bytes, u64 parent,
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index c5880329ae37..87a963d819c3 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -6907,7 +6907,7 @@ static int unpin_extent_range(struct btrfs_fs_info *fs_info,
 	return 0;
 }
 
-int btrfs_finish_extent_commit(struct btrfs_trans_handle *trans)
+void btrfs_finish_extent_commit(struct btrfs_trans_handle *trans)
 {
 	struct btrfs_fs_info *fs_info = trans->fs_info;
 	struct btrfs_block_group_cache *block_group, *tmp;
@@ -6971,8 +6971,6 @@ int btrfs_finish_extent_commit(struct btrfs_trans_handle *trans)
 				   ret, errstr);
 		}
 	}
-
-	return 0;
 }
 
 static int __btrfs_free_extent(struct btrfs_trans_handle *trans,
-- 
2.21.0

