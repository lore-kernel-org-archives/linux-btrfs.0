Return-Path: <SRS0=9Rtw=NG=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0C69ECDE44
	for <linux-btrfs@archiver.kernel.org>; Fri, 26 Oct 2018 20:26:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AA135207DD
	for <linux-btrfs@archiver.kernel.org>; Fri, 26 Oct 2018 20:26:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="CsfY5iTC"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AA135207DD
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728373AbeJ0FFL (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sat, 27 Oct 2018 01:05:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:35934 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728100AbeJ0FFL (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 27 Oct 2018 01:05:11 -0400
Received: from localhost.localdomain (bl8-197-74.dsl.telepac.pt [85.241.197.74])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6314F207DD
        for <linux-btrfs@vger.kernel.org>; Fri, 26 Oct 2018 20:26:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1540585604;
        bh=/hQXoedTnJ7PscQMp5MpGqTWU9zqDc0SGni2VcsTa0I=;
        h=From:To:Subject:Date:From;
        b=CsfY5iTCf3UpbPTuLj4qkTvh1ZBfds6KEGWy5Y/Z0Sd01eDiKq684EF8dcPG+g1rn
         iF61DLqNHnTg2Mgc/uF/3p0s8JzlkHHZSnwlHnWjbJsgNOK75H84gdXEkHEqH0WrEE
         cybckKOAST/QZZEc1kayqEISq8qme1rsIRIEW3x0=
From:   fdmanana@kernel.org
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: remove no longer used logged range variables when logging extents
Date:   Fri, 26 Oct 2018 21:26:40 +0100
Message-Id: <20181026202640.24131-1-fdmanana@kernel.org>
X-Mailer: git-send-email 2.11.0
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Filipe Manana <fdmanana@suse.com>

The logged_start and logged_end variables, at btrfs_log_changed_extents(),
were added in commit 8c6c592831a0 ("btrfs: log csums for all modified
extents"). However since the recent simplification for fsync, which makes
us wait for all ordered extents to complete before logging extents, we
no longer need those variables. Commit a2120a473a80 ("btrfs: clean up the
left over logged_list usage") forgot to remove them.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/tree-log.c | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index 1673dccc76c2..c86c5dd100b2 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -4383,7 +4383,6 @@ static int btrfs_log_changed_extents(struct btrfs_trans_handle *trans,
 	struct extent_map *em, *n;
 	struct list_head extents;
 	struct extent_map_tree *tree = &inode->extent_tree;
-	u64 logged_start, logged_end;
 	u64 test_gen;
 	int ret = 0;
 	int num = 0;
@@ -4393,8 +4392,6 @@ static int btrfs_log_changed_extents(struct btrfs_trans_handle *trans,
 	down_write(&inode->dio_sem);
 	write_lock(&tree->lock);
 	test_gen = root->fs_info->last_trans_committed;
-	logged_start = start;
-	logged_end = end;
 
 	list_for_each_entry_safe(em, n, &tree->modified_extents, list) {
 		list_del_init(&em->list);
@@ -4418,11 +4415,6 @@ static int btrfs_log_changed_extents(struct btrfs_trans_handle *trans,
 		    em->start >= i_size_read(&inode->vfs_inode))
 			continue;
 
-		if (em->start < logged_start)
-			logged_start = em->start;
-		if ((em->start + em->len - 1) > logged_end)
-			logged_end = em->start + em->len - 1;
-
 		/* Need a ref to keep it from getting evicted from cache */
 		refcount_inc(&em->refs);
 		set_bit(EXTENT_FLAG_LOGGING, &em->flags);
-- 
2.11.0

