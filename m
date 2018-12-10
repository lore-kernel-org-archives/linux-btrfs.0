Return-Path: <SRS0=qyTl=OT=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C17D8C04EB8
	for <linux-btrfs@archiver.kernel.org>; Mon, 10 Dec 2018 17:55:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7ED392081F
	for <linux-btrfs@archiver.kernel.org>; Mon, 10 Dec 2018 17:55:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1544464508;
	bh=D/vahTja57+xC4E/QmKUqeg8FPLp4ai4ZkDATghECt0=;
	h=From:To:Subject:Date:List-ID:From;
	b=fWMSHUyt9L9qd8D3p+zOwSvJnG+jN2PMtFyMdH6a/DCg1ubeHIGRUgEPdaJPgD2cc
	 B+R3n3XBCuHF3rtpKbPliAONps6dPEG2a5SRXLjdpTU++u3KxreGL/RaNWUJjh0b/d
	 YxBZ3XY96smGOlhQHx5UzJFLRb7DZ+SmSV1mu+8k=
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7ED392081F
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728108AbeLJRzH (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 10 Dec 2018 12:55:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:33262 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727264AbeLJRzH (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 10 Dec 2018 12:55:07 -0500
Received: from localhost.localdomain (bl8-197-74.dsl.telepac.pt [85.241.197.74])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0EC902081F
        for <linux-btrfs@vger.kernel.org>; Mon, 10 Dec 2018 17:55:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1544464505;
        bh=D/vahTja57+xC4E/QmKUqeg8FPLp4ai4ZkDATghECt0=;
        h=From:To:Subject:Date:From;
        b=Zmjr3vKdOo1dws0Wj1LQTfY7pBN1KTxxuVxaTdbcB7HQcRfAJAtnTt0Wi9D8YlMpj
         Yas21tn77FlnlpEesMd1iTdphuAwwz16UTIDV6CMDdovbhCu0VCTWW9Ee3LWvW76Wd
         2V+bsgzpO3I2fwid92ch84rODjitNwN53M9KYeaU=
From:   fdmanana@kernel.org
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: send, fix race with transaction commits that create snapshots
Date:   Mon, 10 Dec 2018 17:55:02 +0000
Message-Id: <20181210175502.16620-1-fdmanana@kernel.org>
X-Mailer: git-send-email 2.11.0
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Filipe Manana <fdmanana@suse.com>

If we create a snapshot of a snapshot currently being used by a send
operation, we can end up with send failing unexpectedly (returning
-ENOENT error to user space for example). The following diagram shows
how this happens.

            CPU 1                                   CPU2                                CPU3

 btrfs_ioctl_send()
  (...)
                                     create_snapshot()
                                      -> creates snapshot of a
                                         root used by the send
                                         task
                                      btrfs_commit_transaction()
                                       create_pending_snapshot()
  __get_inode_info()
   btrfs_search_slot()
    btrfs_search_slot_get_root()
     down_read commit_root_sem

     get reference on eb of the
     commit root
      -> eb with bytenr == X

     up_read commit_root_sem

                                        btrfs_cow_block(root node)
                                         btrfs_free_tree_block()
                                          -> creates delayed ref to
                                             free the extent

                                       btrfs_run_delayed_refs()
                                        -> runs the delayed ref,
                                           adds extent to
                                           fs_info->pinned_extents

                                       btrfs_finish_extent_commit()
                                        unpin_extent_range()
                                         -> marks extent as free
                                            in the free space cache

                                      transaction commit finishes

                                                                       btrfs_start_transaction()
                                                                        (...)
                                                                        btrfs_cow_block()
                                                                         btrfs_alloc_tree_block()
                                                                          btrfs_reserve_extent()
                                                                           -> allocates extent at
                                                                              bytenr == X
                                                                          btrfs_init_new_buffer(bytenr X)
                                                                           btrfs_find_create_tree_block()
                                                                            alloc_extent_buffer(bytenr X)
                                                                             find_extent_buffer(bytenr X)
                                                                              -> returns existing eb,
                                                                                 which the send task got

                                                                        (...)
                                                                         -> modifies content of the
                                                                            eb with bytenr == X

    -> uses an eb that now
       belongs to some other
       tree and no more matches
       the commit root of the
       snapshot, resuts will be
       unpredictable

The consequences of this race can be various, and can lead to searches in
the commit root performed by the send task failing unexpectedly (unable to
find inode items, returning -ENOENT to user space, for example) or not
failing because an inode item with the same number was added to the tree
that reused the metadata extent, in which case send can behave incorrectly
in the worst case or just fail later for some reason.

Fix this by performing a copy of the commit root's extent buffer when doing
a search in the context of a send operation.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/ctree.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index 539901fb5165..b3ab47cca384 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -2587,11 +2587,12 @@ static struct extent_buffer *btrfs_search_slot_get_root(struct btrfs_root *root,
 		/* The commit roots are read only so we always do read locks */
 		if (p->need_commit_sem)
 			down_read(&fs_info->commit_root_sem);
-		b = root->commit_root;
-		extent_buffer_get(b);
-		level = btrfs_header_level(b);
+		b = btrfs_clone_extent_buffer(root->commit_root);
 		if (p->need_commit_sem)
 			up_read(&fs_info->commit_root_sem);
+		if (!b)
+			return ERR_PTR(-ENOMEM);
+		level = btrfs_header_level(b);
 		/*
 		 * Ensure that all callers have set skip_locking when
 		 * p->search_commit_root = 1.
@@ -2717,6 +2718,10 @@ int btrfs_search_slot(struct btrfs_trans_handle *trans, struct btrfs_root *root,
 again:
 	prev_cmp = -1;
 	b = btrfs_search_slot_get_root(root, p, write_lock_level);
+	if (IS_ERR(b)) {
+		ret = PTR_ERR(b);
+		goto done;
+	}
 
 	while (b) {
 		level = btrfs_header_level(b);
-- 
2.11.0

