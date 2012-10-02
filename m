Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:35887 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753317Ab2JBPZA (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 2 Oct 2012 11:25:00 -0400
Received: by yenm12 with SMTP id m12so1726788yen.19
        for <linux-btrfs@vger.kernel.org>; Tue, 02 Oct 2012 08:24:59 -0700 (PDT)
From: Mitch Harder <mitch.harder@sabayonlinux.org>
To: linux-btrfs@vger.kernel.org
Cc: Mitch Harder <mitch.harder@sabayonlinux.org>
Subject: [PATCH] Btrfs: Remove orphaned comment.
Date: Tue,  2 Oct 2012 10:24:51 -0500
Message-Id: <1349191491-13238-1-git-send-email-mitch.harder@sabayonlinux.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Remove a comment that was orphaned by a previous commit which
removed the function associated with the comment.

See commit efd049fb26a162c3830fd3cb1001fdc09b147f3b

This left the comment in a confusing context that seemed to be
associated with another function.

Signed-off-by: Mitch Harder <mitch.harder@sabayonlinux.org>
---
 fs/btrfs/inode.c |    6 ------
 1 files changed, 0 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 2c785c0..93e1351 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -2441,12 +2441,6 @@ out_kfree:
 	return NULL;
 }
 
-/*
- * helper function for btrfs_finish_ordered_io, this
- * just reads in some of the csum leaves to prime them into ram
- * before we start the transaction.  It limits the amount of btree
- * reads required while inside the transaction.
- */
 /* as ordered data IO finishes, this gets called so we can finish
  * an ordered extent if the range of bytes in the file it covers are
  * fully written.
-- 
1.7.8.6

