Return-Path: <SRS0=Si37=PQ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E207FC43387
	for <linux-btrfs@archiver.kernel.org>; Tue,  8 Jan 2019 11:43:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AA4C2206B7
	for <linux-btrfs@archiver.kernel.org>; Tue,  8 Jan 2019 11:43:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1546947802;
	bh=3vL/rRppxFo6EHrCqxEhe0EvIcqb3zH2dsfE2IYqMQA=;
	h=From:To:Subject:Date:List-ID:From;
	b=09wV083VS9PoUzGAobAEEBoTlcX+hknxP25/CsaIoU9rPt80HYlEnH2ENFjFhQQRI
	 rgK8S6aAcslpYo/ABX7hzVNWg/fIYtO8zCV7FzQK71TTVaKazM/XHFsRAF4kfRWkJF
	 EZPpCoc7iHRJlK5uPBtCXU0LbIZj0sln6GpRV14I=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728767AbfAHLnV (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 8 Jan 2019 06:43:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:50004 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727701AbfAHLnV (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 8 Jan 2019 06:43:21 -0500
Received: from localhost.localdomain (bl8-197-74.dsl.telepac.pt [85.241.197.74])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9472C206B7
        for <linux-btrfs@vger.kernel.org>; Tue,  8 Jan 2019 11:43:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1546947801;
        bh=3vL/rRppxFo6EHrCqxEhe0EvIcqb3zH2dsfE2IYqMQA=;
        h=From:To:Subject:Date:From;
        b=thWWjQwnat2Sz10EUbBXhpKg29vQh0ckfv6ZFyY2wNsvV/oPLO9fQh/Byn1f6do7N
         UL5PbG/j6IDiC+YW8CccT0Uecdr52XQrh5JzDRvUipplU8KzVV11E6heZOc+rxrFW3
         74a7YPXnOEL5VGN89irlJZCOPPrwp1sR9Bs/l4kk=
From:   fdmanana@kernel.org
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: remove redundant check for swapfiles when reflinking
Date:   Tue,  8 Jan 2019 11:43:18 +0000
Message-Id: <20190108114318.3711-1-fdmanana@kernel.org>
X-Mailer: git-send-email 2.11.0
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Filipe Manana <fdmanana@suse.com>

Checking if either of the inodes corresponds to a swapfile is already
performed by generic_remap_file_range_prep(), so we do not need to do
it in the btrfs clone and deduplication functions.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/ioctl.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 996a26befc1d..c8749e0a36f3 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -3286,9 +3286,6 @@ static int btrfs_extent_same(struct inode *src, u64 loff, u64 olen,
 	    (BTRFS_I(dst)->flags & BTRFS_INODE_NODATASUM))
 		return -EINVAL;
 
-	if (IS_SWAPFILE(src) || IS_SWAPFILE(dst))
-		return -ETXTBSY;
-
 	tail_len = olen % BTRFS_MAX_DEDUPE_LEN;
 	chunk_count = div_u64(olen, BTRFS_MAX_DEDUPE_LEN);
 	if (chunk_count == 0)
@@ -3913,9 +3910,6 @@ static noinline int btrfs_clone_files(struct file *file, struct file *file_src,
 	    (BTRFS_I(inode)->flags & BTRFS_INODE_NODATASUM))
 		return -EINVAL;
 
-	if (IS_SWAPFILE(src) || IS_SWAPFILE(inode))
-		return -ETXTBSY;
-
 	/*
 	 * VFS's generic_remap_file_range_prep() protects us from cloning the
 	 * eof block into the middle of a file, which would result in corruption
-- 
2.11.0

