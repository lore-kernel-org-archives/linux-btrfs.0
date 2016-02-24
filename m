Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:48628 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751240AbcBXP5Y (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 24 Feb 2016 10:57:24 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 6707B20373
	for <linux-btrfs@vger.kernel.org>; Wed, 24 Feb 2016 15:57:23 +0000 (UTC)
Received: from debian3.lan (bl8-199-62.dsl.telepac.pt [85.241.199.62])
	(using TLSv1.2 with cipher AES128-SHA256 (128/128 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPSA id 4DF6F2037C
	for <linux-btrfs@vger.kernel.org>; Wed, 24 Feb 2016 15:57:22 +0000 (UTC)
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: fix race when checking if we can skip fsync'ing an inode
Date: Wed, 24 Feb 2016 15:57:19 +0000
Message-Id: <1456329439-32034-1-git-send-email-fdmanana@kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Filipe Manana <fdmanana@suse.com>

If we're about to do a fast fsync for an inode and btrfs_inode_in_log()
returns false, it's possible that we had an ordered extent in progress
(btrfs_finish_ordered_io() not run yet) when we noticed that the inode's
last_trans field was not greater than the id of the last committed
transaction, but shortly after, before we checked if there were any
ongoing ordered extents, the ordered extent had just completed and
removed itself from the inode's ordered tree, in which case we end up not
logging the inode, losing some data if a power failure or crash happens
after the fsync handler returns and before the transaction is committed.

Fix this by checking first if there are any ongoing ordered extents
before comparing the inode's last_trans with the id of the last committed
transaction - when it completes, an ordered extent always updates the
inode's last_trans before it removes itself from the inode's ordered
tree (at btrfs_finish_ordered_io()).

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/file.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 4ab4b5c..59a6a2a 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -2021,10 +2021,11 @@ int btrfs_sync_file(struct file *file, loff_t start, loff_t end, int datasync)
 	 */
 	smp_mb();
 	if (btrfs_inode_in_log(inode, root->fs_info->generation) ||
-	    (BTRFS_I(inode)->last_trans <=
-	     root->fs_info->last_trans_committed &&
-	     (full_sync ||
-	      !btrfs_have_ordered_extents_in_range(inode, start, len)))) {
+	    (full_sync && BTRFS_I(inode)->last_trans <=
+	     root->fs_info->last_trans_committed) ||
+	    (!btrfs_have_ordered_extents_in_range(inode, start, len) &&
+	     BTRFS_I(inode)->last_trans
+	     <= root->fs_info->last_trans_committed)) {
 		/*
 		 * We'v had everything committed since the last time we were
 		 * modified so clear this flag in case it was set for whatever
-- 
2.7.0.rc3

