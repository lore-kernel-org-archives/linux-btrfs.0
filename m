Return-Path: <SRS0=Si37=PQ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07506C43387
	for <linux-btrfs@archiver.kernel.org>; Tue,  8 Jan 2019 11:44:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C26EC206B7
	for <linux-btrfs@archiver.kernel.org>; Tue,  8 Jan 2019 11:44:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1546947886;
	bh=WKXn6zBzmDiDraRTqEOFYwwL2E3sUO+414bL4w9WQUI=;
	h=From:To:Subject:Date:List-ID:From;
	b=MvdOGc5z3wWgjVmMbfQRrnBXmVCHhxx4w7SULYk8CsUlrhFULNGaX5Xy4t5FfQ6JK
	 u9lXEh0t/bMJAl2++ZVOqFeyf2/Fc5xDDfgtefhtOUsWC4eUxSHKSGh+iFGCnKXGH3
	 VFm0gNWkum0geGihy2b1/Gom+yYTPXNuxYcUQGW4=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728573AbfAHLop (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 8 Jan 2019 06:44:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:51390 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727587AbfAHLop (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 8 Jan 2019 06:44:45 -0500
Received: from localhost.localdomain (bl8-197-74.dsl.telepac.pt [85.241.197.74])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 00A2B206B7
        for <linux-btrfs@vger.kernel.org>; Tue,  8 Jan 2019 11:44:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1546947884;
        bh=WKXn6zBzmDiDraRTqEOFYwwL2E3sUO+414bL4w9WQUI=;
        h=From:To:Subject:Date:From;
        b=JcCAeSKSmJZ1GLbMTjM+4Vg//erqueSoMUN/+gPI6GuD/bGoo0MhPtmWtoiwIz2PQ
         ZfsqN5c5TiPRKrakOdr3i2ezjkpthMfETSGkU0Mqu1Czl5BZAb5Q/eRYtLEaYSVJIu
         2JTTpKsrkGgAZjUbYHQly06P8ONZUKzb3PfeiqCg=
From:   fdmanana@kernel.org
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: fix deadlock when using free space tree due to block group creation
Date:   Tue,  8 Jan 2019 11:44:41 +0000
Message-Id: <20190108114441.5573-1-fdmanana@kernel.org>
X-Mailer: git-send-email 2.11.0
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Filipe Manana <fdmanana@suse.com>

When modifying the free space tree we can end up COWing one of its extent
buffers which in turn might result in allocating a new chunk, which in
turn can result in flushing (finish creation) of pending block groups. If
that happens we can deadlock because creating a pending block group needs
to update the free space tree, and if any of the updates tries to modify
the same extent buffer that we are COWing, we end up in a deadlock since
we try to write lock twice the same extent buffer.

So fix this by skipping pending block group creation if we are COWing an
extent buffer from the free space tree. This is a case missed by commit
5ce555578e091 ("Btrfs: fix deadlock when writing out free space caches").

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=202173
Fixes: 5ce555578e091 ("Btrfs: fix deadlock when writing out free space caches
Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/ctree.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index d92462fe66c8..f64aad613727 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -1016,19 +1016,21 @@ static noinline int __btrfs_cow_block(struct btrfs_trans_handle *trans,
 		parent_start = parent->start;
 
 	/*
-	 * If we are COWing a node/leaf from the extent, chunk or device trees,
-	 * make sure that we do not finish block group creation of pending block
-	 * groups. We do this to avoid a deadlock.
+	 * If we are COWing a node/leaf from the extent, chunk, device or free
+	 * space trees, make sure that we do not finish block group creation of
+	 * pending block groups. We do this to avoid a deadlock.
 	 * COWing can result in allocation of a new chunk, and flushing pending
 	 * block groups (btrfs_create_pending_block_groups()) can be triggered
 	 * when finishing allocation of a new chunk. Creation of a pending block
-	 * group modifies the extent, chunk and device trees, therefore we could
-	 * deadlock with ourselves since we are holding a lock on an extent
-	 * buffer that btrfs_create_pending_block_groups() may try to COW later.
+	 * group modifies the extent, chunk, device and free space trees,
+	 * therefore we could deadlock with ourselves since we are holding a
+	 * lock on an extent buffer that btrfs_create_pending_block_groups() may
+	 * try to COW later.
 	 */
 	if (root == fs_info->extent_root ||
 	    root == fs_info->chunk_root ||
-	    root == fs_info->dev_root)
+	    root == fs_info->dev_root ||
+	    root == fs_info->free_space_root)
 		trans->can_flush_pending_bgs = false;
 
 	cow = btrfs_alloc_tree_block(trans, root, parent_start,
-- 
2.11.0

