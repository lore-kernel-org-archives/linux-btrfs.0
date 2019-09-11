Return-Path: <SRS0=wB72=XG=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6BC1C5ACAE
	for <linux-btrfs@archiver.kernel.org>; Wed, 11 Sep 2019 16:42:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8018920838
	for <linux-btrfs@archiver.kernel.org>; Wed, 11 Sep 2019 16:42:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1568220162;
	bh=Ch0YZyEE8nlezfSkGZExaAxguJ/6ZcEVWq4oLzdnTWo=;
	h=From:To:Subject:Date:List-ID:From;
	b=qS4wLXxlVbEbP65DAPO3X+w5P6GE8kWOwPZG8fEpy53qzI/c5VDEVezdlwEcsAOrU
	 mseVDPeWruRmNxT4e1Hs6hjRpYwcSQZ68+k1VaBChtOVvSyCIxl708HUdGX4B9m2Bt
	 Fh1F7n1XYwpHxTY2KUpKKpzEIyhppXiCVzz2ggGk=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729140AbfIKQml (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 11 Sep 2019 12:42:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:38272 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729061AbfIKQml (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 11 Sep 2019 12:42:41 -0400
Received: from localhost.localdomain (bl8-197-74.dsl.telepac.pt [85.241.197.74])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A6681206CD
        for <linux-btrfs@vger.kernel.org>; Wed, 11 Sep 2019 16:42:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568220161;
        bh=Ch0YZyEE8nlezfSkGZExaAxguJ/6ZcEVWq4oLzdnTWo=;
        h=From:To:Subject:Date:From;
        b=oLyA/SNhx1rXAKALBrEihUq9Hgi+HK6AzG2Gf5/iMWl60zhvwUVH1FQLECBWWHYmu
         SG6Mji2Gcgmfyb6eR3KjmZAS8Nsok6vTcxniIyQeWchiAf9ljI2MtoCuPW6nKTovlx
         Ddo62VKrrj7qbgFspphbPC9kWWnOgIYTiwJn/nxs=
From:   fdmanana@kernel.org
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: make btrfs_wait_extents() static
Date:   Wed, 11 Sep 2019 17:42:38 +0100
Message-Id: <20190911164238.19524-1-fdmanana@kernel.org>
X-Mailer: git-send-email 2.11.0
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Filipe Manana <fdmanana@suse.com>

It's not used ouside of transaction.c

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/transaction.c | 2 +-
 fs/btrfs/transaction.h | 2 --
 2 files changed, 1 insertion(+), 3 deletions(-)

diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index e3adb714c04b..84a42e388aa4 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -988,7 +988,7 @@ static int __btrfs_wait_marked_extents(struct btrfs_fs_info *fs_info,
 	return werr;
 }
 
-int btrfs_wait_extents(struct btrfs_fs_info *fs_info,
+static int btrfs_wait_extents(struct btrfs_fs_info *fs_info,
 		       struct extent_io_tree *dirty_pages)
 {
 	bool errors = false;
diff --git a/fs/btrfs/transaction.h b/fs/btrfs/transaction.h
index 2c5a6f6e5bb0..c51135d9b448 100644
--- a/fs/btrfs/transaction.h
+++ b/fs/btrfs/transaction.h
@@ -218,8 +218,6 @@ int btrfs_record_root_in_trans(struct btrfs_trans_handle *trans,
 				struct btrfs_root *root);
 int btrfs_write_marked_extents(struct btrfs_fs_info *fs_info,
 				struct extent_io_tree *dirty_pages, int mark);
-int btrfs_wait_extents(struct btrfs_fs_info *fs_info,
-		       struct extent_io_tree *dirty_pages);
 int btrfs_wait_tree_log_extents(struct btrfs_root *root, int mark);
 int btrfs_transaction_blocked(struct btrfs_fs_info *info);
 int btrfs_transaction_in_commit(struct btrfs_fs_info *info);
-- 
2.11.0

