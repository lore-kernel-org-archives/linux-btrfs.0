Return-Path: <SRS0=CI8N=OH=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C89EC43441
	for <linux-btrfs@archiver.kernel.org>; Wed, 28 Nov 2018 14:22:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6297C20832
	for <linux-btrfs@archiver.kernel.org>; Wed, 28 Nov 2018 14:22:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="T2891lre"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6297C20832
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728664AbeK2BYY (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 28 Nov 2018 20:24:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:41942 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727979AbeK2BYY (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 28 Nov 2018 20:24:24 -0500
Received: from localhost.localdomain (bl8-197-74.dsl.telepac.pt [85.241.197.74])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 015C220832
        for <linux-btrfs@vger.kernel.org>; Wed, 28 Nov 2018 14:22:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1543414954;
        bh=HWjMgcKymqBUruY4TDm9rOKjZ6R/LTTpMLcG+knrIS4=;
        h=From:To:Subject:Date:From;
        b=T2891lre3FvznZI/SW2a7PUu0/PvN0TQHjGAzFOmK7YqT/ezHu1H4I5YPRZU1P+mB
         V1ydGhA+x6v6U4cZlkfh3faaUbcJCHhPyzOZbU/j1ocd8IUePOAUVA9ost84SogSDL
         FBiZly8OUJAsdC5R9eYRctPfqUjJ5hRenvCYMtF0=
From:   fdmanana@kernel.org
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: fix fsync of files with multiple hard links in new directories
Date:   Wed, 28 Nov 2018 14:22:31 +0000
Message-Id: <20181128142231.18822-1-fdmanana@kernel.org>
X-Mailer: git-send-email 2.11.0
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Filipe Manana <fdmanana@suse.com>

The log tree has a long standing problem that when a file is fsync'ed we
only check for new ancestors, created in the current transaction, by
following only the hard link for which the fsync was issued. We follow the
ancestors using the VFS' dget_parent() API. This means that if we create a
new link for a file in a directory that is new (or in an any other new
ancestor directory) and then fsync the file using an old hard link, we end
up not logging the new ancestor, and on log replay that new hard link and
ancestor do not exist. In some cases, involving renames, the file will not
exist at all.

Example:

  mkfs.btrfs -f /dev/sdb
  mount /dev/sdb /mnt

  mkdir /mnt/A
  touch /mnt/foo
  ln /mnt/foo /mnt/A/bar
  xfs_io -c fsync /mnt/foo

  <power failure>

In this example after log replay only the hard link named 'foo' exists
and directory A does not exist, which is unexpected. In other major linux
filesystems, such as ext4, xfs and f2fs for example, both hard links exist
and so does directory A after mounting again the filesystem.

Checking if any new ancestors are new and need to be logged was added in
2009 by commit 12fcfd22fe5b ("Btrfs: tree logging unlink/rename fixes"),
however only for the ancestors of the hard link (dentry) for which the
fsync was issued, instead of checking for all ancestors for all of the
inode's hard links.

So fix this by tracking the id of the last transaction where a hard link
was created for an inode and then on fsync fallback to a full transaction
commit when an inode has more than one hard link and at least one new hard
link was created in the current transaction. This is the simplest solution
since this is not a common use case (adding frequently hard links for
which there's an ancestor created in the current transaction and then
fsync the file). In case it ever becomes a common use case, a solution
that consists of iterating the fs/subvol btree for each hard link and
check if any ancestor is new, could be implemented.

This solves many unexpected scenarios reported by Jayashree Mohan and
Vijay Chidambaram, and for which there is a new test case for fstests
under review.

Reported-by: Vijay Chidambaram <vvijay03@gmail.com>
Reported-by: Jayashree Mohan <jayashree2912@gmail.com>
Fixes: 12fcfd22fe5b ("Btrfs: tree logging unlink/rename fixes")
Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/btrfs_inode.h |  6 ++++++
 fs/btrfs/inode.c       |  2 ++
 fs/btrfs/tree-log.c    | 16 ++++++++++++++++
 3 files changed, 24 insertions(+)

diff --git a/fs/btrfs/btrfs_inode.h b/fs/btrfs/btrfs_inode.h
index 1343ac57b438..7177d1d33584 100644
--- a/fs/btrfs/btrfs_inode.h
+++ b/fs/btrfs/btrfs_inode.h
@@ -147,6 +147,12 @@ struct btrfs_inode {
 	u64 last_unlink_trans;
 
 	/*
+	 * Track the transaction id of the last transaction used to create a
+	 * hard link for the inode. This is used by the log tree (fsync).
+	 */
+	u64 last_link_trans;
+
+	/*
 	 * Number of bytes outstanding that are going to need csums.  This is
 	 * used in ENOSPC accounting.
 	 */
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 64ea749c1ba4..2e5660eb5aa1 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -6651,6 +6651,7 @@ static int btrfs_link(struct dentry *old_dentry, struct inode *dir,
 			if (err)
 				goto fail;
 		}
+		BTRFS_I(inode)->last_link_trans = trans->transid;
 		d_instantiate(dentry, inode);
 		ret = btrfs_log_new_name(trans, BTRFS_I(inode), NULL, parent,
 					 true, NULL);
@@ -9179,6 +9180,7 @@ struct inode *btrfs_alloc_inode(struct super_block *sb)
 	ei->index_cnt = (u64)-1;
 	ei->dir_index = 0;
 	ei->last_unlink_trans = 0;
+	ei->last_link_trans = 0;
 	ei->last_log_commit = 0;
 
 	spin_lock_init(&ei->lock);
diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index aac3749f697f..896d79144052 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -5760,6 +5760,22 @@ static int btrfs_log_inode_parent(struct btrfs_trans_handle *trans,
 			goto end_trans;
 	}
 
+	/*
+	 * If a new hard link was added to the inode in the current transaction
+	 * and its link count is now greater than 1, we need to fallback to a
+	 * transaction commit, otherwise we can end up not logging all its new
+	 * parents for all the hard links. Here just from the dentry used to
+	 * fsync, we can not visit the ancestor inodes for all the other hard
+	 * links to figure out if any is new, so we fallback to a transaction
+	 * commit (instead of adding a lot of complexity of scanning a btree,
+	 * since this scenario is not a common use case).
+	 */
+	if (inode->vfs_inode.i_nlink > 1 &&
+	    inode->last_link_trans > last_committed) {
+		ret = -EMLINK;
+		goto end_trans;
+	}
+
 	while (1) {
 		if (!parent || d_really_is_negative(parent) || sb != parent->d_sb)
 			break;
-- 
2.11.0

