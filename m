Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:36154 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751449AbcBZNNh (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 26 Feb 2016 08:13:37 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 83EB22039E
	for <linux-btrfs@vger.kernel.org>; Fri, 26 Feb 2016 13:13:36 +0000 (UTC)
Received: from debian3.lan (bl8-199-62.dsl.telepac.pt [85.241.199.62])
	(using TLSv1.2 with cipher AES128-SHA256 (128/128 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPSA id 6782E20394
	for <linux-btrfs@vger.kernel.org>; Fri, 26 Feb 2016 13:13:35 +0000 (UTC)
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: do not collect ordered extents when logging that inode exists
Date: Fri, 26 Feb 2016 04:35:49 +0000
Message-Id: <1456461349-17957-1-git-send-email-fdmanana@kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Filipe Manana <fdmanana@suse.com>

When logging that an inode exists, for example as part of a directory
fsync operation, we were collecting any ordered extents for the inode but
we ended up doing nothing with them except tagging them as processed, by
setting the flag BTRFS_ORDERED_LOGGED on them, which prevented a
subsequent fsync of that inode (using the LOG_INODE_ALL mode) from
collecting and processing them. This created a time window where a second
fsync against the inode, using the fast path, ended up not logging the
checksums for the new extents but it logged the extents since they were
part of the list of modified extents. This happened because the ordered
extents were not collected and checksums were not yet added to the csum
tree - the ordered extents have not gone through btrfs_finish_ordered_io()
yet (which is where we add them to the csum tree by calling
inode.c:add_pending_csums()).

So fix this by not collecting an inode's ordered extents if we are logging
it with the LOG_INODE_EXISTS mode.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/tree-log.c | 17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index 9f6372d..9d2e8ec 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -4500,7 +4500,22 @@ static int btrfs_log_inode(struct btrfs_trans_handle *trans,
 
 	mutex_lock(&BTRFS_I(inode)->log_mutex);
 
-	btrfs_get_logged_extents(inode, &logged_list, start, end);
+	/*
+	 * Collect ordered extents only if we are logging data. This is to
+	 * ensure a subsequent request to log this inode in LOG_INODE_ALL mode
+	 * will process the ordered extents if they still exists at the time,
+	 * because when we collect them we test and set for the flag
+	 * BTRFS_ORDERED_LOGGED to prevent multiple log requests to process the
+	 * same ordered extents. The consequence for the LOG_INODE_ALL log mode
+	 * not processing the ordered extents is that we end up logging the
+	 * corresponding file extent items, based on the extent maps in the
+	 * inode's extent_map_tree's modified_list, without logging the
+	 * respective checksums (since the may still be only attached to the
+	 * ordered extents and have not been inserted in the csum tree by
+	 * btrfs_finish_ordered_io() yet).
+	 */
+	if (inode_only == LOG_INODE_ALL)
+		btrfs_get_logged_extents(inode, &logged_list, start, end);
 
 	/*
 	 * a brute force approach to making sure we get the most uptodate
-- 
2.7.0.rc3

