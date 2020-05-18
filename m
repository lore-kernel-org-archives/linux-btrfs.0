Return-Path: <SRS0=lV6b=7A=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7A72C433DF
	for <linux-btrfs@archiver.kernel.org>; Mon, 18 May 2020 16:34:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7BE6E207D8
	for <linux-btrfs@archiver.kernel.org>; Mon, 18 May 2020 16:34:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1589819655;
	bh=CcM+vaPHpdCH+p3FHLSD9OYD5bIx91YUltDg5al6FDk=;
	h=From:To:Subject:Date:List-ID:From;
	b=RBgJGRaDoQVfYILkhv43ALDW/ihRcq2BEWSVUr1JgincBbsnZ2p9xcVgsRKX3v91e
	 pOh/VCAL11IiM3rn/67rG3/E07B+HPcA/urQ9BgXvvpkMcx3ghNvvWpjzeOgLVp+E0
	 ppzERYmZHxfKDMKdpS2zfVLrcj/ngIfnQ/4UYu8I=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728045AbgERQeO (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 18 May 2020 12:34:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:33340 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727020AbgERQeO (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 18 May 2020 12:34:14 -0400
Received: from debian6.Home (bl8-197-74.dsl.telepac.pt [85.241.197.74])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E260720709
        for <linux-btrfs@vger.kernel.org>; Mon, 18 May 2020 16:34:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589819654;
        bh=CcM+vaPHpdCH+p3FHLSD9OYD5bIx91YUltDg5al6FDk=;
        h=From:To:Subject:Date:From;
        b=bacaEUNbHTckzqccUeqJISkEPmqWmmbNV6FS5tVNl9Aj6g4XYP+gwdF6Q74vkhZ88
         eRrtfomva+s//O9NTa7BPCdVmI7B9LN7ScgtCFVp+Kxhpdg1LJKRWPL++4DqApSPAE
         UkT4PKYM/7twxpFjQ06IFAxaoZ5fCR0shqj0rMzE=
From:   fdmanana@kernel.org
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH 1/2] Btrfs: include error on messages about failure to write space/inode caches
Date:   Mon, 18 May 2020 17:34:11 +0100
Message-Id: <20200518163411.18660-1-fdmanana@kernel.org>
X-Mailer: git-send-email 2.11.0
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Filipe Manana <fdmanana@suse.com>

Currently the error messages logged when we fail to write a free space
cache or an inode cache are not very useful as they don't mention what
was the error. So include the error number in the messages.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/free-space-cache.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index 3c353a337b91..3f63deb9f188 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -1193,8 +1193,8 @@ static int __btrfs_wait_cache_io(struct btrfs_root *root,
 		if (block_group) {
 #ifdef CONFIG_BTRFS_DEBUG
 			btrfs_err(root->fs_info,
-				  "failed to write free space cache for block group %llu",
-				  block_group->start);
+	  "failed to write free space cache for block group %llu error %d",
+				  block_group->start, ret);
 #endif
 		}
 	}
@@ -1417,8 +1417,8 @@ int btrfs_write_out_cache(struct btrfs_trans_handle *trans,
 	if (ret) {
 #ifdef CONFIG_BTRFS_DEBUG
 		btrfs_err(fs_info,
-			  "failed to write free space cache for block group %llu",
-			  block_group->start);
+	  "failed to write free space cache for block group %llu error %d",
+			  block_group->start, ret);
 #endif
 		spin_lock(&block_group->lock);
 		block_group->disk_cache_state = BTRFS_DC_ERROR;
@@ -3997,8 +3997,8 @@ int btrfs_write_out_ino_cache(struct btrfs_root *root,
 					inode->i_size, true);
 #ifdef CONFIG_BTRFS_DEBUG
 		btrfs_err(fs_info,
-			  "failed to write free ino cache for root %llu",
-			  root->root_key.objectid);
+			  "failed to write free ino cache for root %llu error %d",
+			  root->root_key.objectid, ret);
 #endif
 	}
 
-- 
2.11.0

