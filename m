Return-Path: <SRS0=yXFy=OU=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B67EC5CFFE
	for <linux-btrfs@archiver.kernel.org>; Tue, 11 Dec 2018 10:19:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 37A1420811
	for <linux-btrfs@archiver.kernel.org>; Tue, 11 Dec 2018 10:19:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1544523595;
	bh=AMeTwxsY6Gsb4QvI1hVZh2yIsuqw7rId0rnVv7V1bvU=;
	h=From:To:Subject:Date:In-Reply-To:References:List-ID:From;
	b=AuKoJsZcru1uyEpElf1e+qNYnBupq+ERbsLy0E+WI5PR2HkLWl8EyWHG4ZArtXIGF
	 1AYgEBxZdm4ffYHEbeujreUKJGuc+3ZYkEJ+a5UPXvkDZ+yHJFuN27mexPyFJXMkHz
	 Sq8mfr8QRE7fun8ro2k8vzoiaNT29iO4tjs/FkwI=
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 37A1420811
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726573AbeLKKTv (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 11 Dec 2018 05:19:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:33092 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726397AbeLKKTt (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 11 Dec 2018 05:19:49 -0500
Received: from localhost.localdomain (bl8-197-74.dsl.telepac.pt [85.241.197.74])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 72E5F20811
        for <linux-btrfs@vger.kernel.org>; Tue, 11 Dec 2018 10:19:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1544523588;
        bh=AMeTwxsY6Gsb4QvI1hVZh2yIsuqw7rId0rnVv7V1bvU=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=JBAY3zHOgf9pV/5kWGJ0Io4vCtdMkSnz9u3EuJPpfSJBJhi22ZrKrVEIR1WPDt6/z
         J6P9GvyuOPsmM6ufmYMaNtCt+cLFur5Hb92jRw2os+2tHAW28ithDY3gAe64th6VA6
         ngj6LsGUGIEN92cXXR33WcIWTIFYbKvAHM7tk48g=
From:   fdmanana@kernel.org
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH v2] Btrfs: send, fix race with transaction commits that create snapshots
Date:   Tue, 11 Dec 2018 10:19:45 +0000
Message-Id: <20181211101945.28695-1-fdmanana@kernel.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20181210175502.16620-1-fdmanana@kernel.org>
References: <20181210175502.16620-1-fdmanana@kernel.org>
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

V2: Updated comment and made it clone the extent buffer really only in the
    send context, and not for every search on the commit root (all searches
    other from the ones done by send are well behaved hold the commit_root_sem).

 fs/btrfs/ctree.c | 29 +++++++++++++++++++++++------
 1 file changed, 23 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index 539901fb5165..99e7645ad94e 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -2584,14 +2584,27 @@ static struct extent_buffer *btrfs_search_slot_get_root(struct btrfs_root *root,
 	root_lock = BTRFS_READ_LOCK;
 
 	if (p->search_commit_root) {
-		/* The commit roots are read only so we always do read locks */
-		if (p->need_commit_sem)
+		/*
+		 * The commit roots are read only so we always do read locks,
+		 * and we always must hold the commit_root_sem when doing
+		 * searches on them, the only exception is send where we don't
+		 * want to block transaction commits for a long time, so
+		 * we need to clone the commit root in order to avoid races
+		 * with transaction commits that create a snapshot of one of
+		 * the roots used by a send operation.
+		 */
+		if (p->need_commit_sem) {
 			down_read(&fs_info->commit_root_sem);
-		b = root->commit_root;
-		extent_buffer_get(b);
-		level = btrfs_header_level(b);
-		if (p->need_commit_sem)
+			b = btrfs_clone_extent_buffer(root->commit_root);
 			up_read(&fs_info->commit_root_sem);
+			if (!b)
+				return ERR_PTR(-ENOMEM);
+
+		} else {
+			b = root->commit_root;
+			extent_buffer_get(b);
+		}
+		level = btrfs_header_level(b);
 		/*
 		 * Ensure that all callers have set skip_locking when
 		 * p->search_commit_root = 1.
@@ -2717,6 +2730,10 @@ int btrfs_search_slot(struct btrfs_trans_handle *trans, struct btrfs_root *root,
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

