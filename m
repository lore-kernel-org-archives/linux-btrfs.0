Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.0 required=3.0 tests=BAYES_00,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A414C4361B
	for <linux-btrfs@archiver.kernel.org>; Mon, 14 Dec 2020 10:11:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 66F3B225A9
	for <linux-btrfs@archiver.kernel.org>; Mon, 14 Dec 2020 10:11:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731383AbgLNKLm (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 14 Dec 2020 05:11:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:33428 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729091AbgLNKLg (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 14 Dec 2020 05:11:36 -0500
From:   fdmanana@kernel.org
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH 4/5] btrfs: add assertion for empty list of transactions at late stage of umount
Date:   Mon, 14 Dec 2020 10:10:48 +0000
Message-Id: <5b18343b09b45fb2b9ae9cb5e6c91337059b243b.1607940240.git.fdmanana@suse.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1607940240.git.fdmanana@suse.com>
References: <cover.1607940240.git.fdmanana@suse.com>
In-Reply-To: <cover.1607940240.git.fdmanana@suse.com>
References: <cover.1607940240.git.fdmanana@suse.com>
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Filipe Manana <fdmanana@suse.com>

Add an assertion to close_ctree(), after destroying all the work queues,
to verify we do not have any transaction still open or committing at that
at that point. If we have any, it means something is seriously wrong and
that can cause memory leaks and use-after-free problems. This is motivated
by the previous patches that fixed bugs where we ended up leaking an open
transaction after unmmounting the filesystem.

Tested-by: Fabian Vogt <fvogt@suse.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/disk-io.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index e7bcbd0b93ef..a567d578d0c8 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -4181,6 +4181,9 @@ void __cold close_ctree(struct btrfs_fs_info *fs_info)
 	invalidate_inode_pages2(fs_info->btree_inode->i_mapping);
 	btrfs_stop_all_workers(fs_info);
 
+	/* We shouldn't have any transaction open at this point. */
+	ASSERT(list_empty(&fs_info->trans_list));
+
 	clear_bit(BTRFS_FS_OPEN, &fs_info->flags);
 	free_root_pointers(fs_info, true);
 	btrfs_free_fs_roots(fs_info);
-- 
2.28.0

