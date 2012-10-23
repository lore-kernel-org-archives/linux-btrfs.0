Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from xp-ob.rzone.de ([81.169.146.137]:61607 "EHLO xp-ob.rzone.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757041Ab2JWNz3 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 23 Oct 2012 09:55:29 -0400
From: Jan Schmidt <list.btrfs@jan-o-sch.net>
To: chris.mason@fusionio.com
Cc: linux-btrfs@vger.kernel.org, bo.li.liu@oracle.com
Subject: [PATCH 6/6] Btrfs: comment for loop in tree_mod_log_insert_move
Date: Tue, 23 Oct 2012 15:55:27 +0200
Message-Id: <1351000527-24952-7-git-send-email-list.btrfs@jan-o-sch.net>
In-Reply-To: <1351000527-24952-1-git-send-email-list.btrfs@jan-o-sch.net>
References: <1351000527-24952-1-git-send-email-list.btrfs@jan-o-sch.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Emphasis the way tree_mod_log_insert_move avoids adding
MOD_LOG_KEY_REMOVE_WHILE_MOVING operations, depending on the direction of
the move operation.

Signed-off-by: Jan Schmidt <list.btrfs@jan-o-sch.net>
---
 fs/btrfs/ctree.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index bed06e8..c608b3c 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -596,6 +596,11 @@ tree_mod_log_insert_move(struct btrfs_fs_info *fs_info,
 	if (tree_mod_dont_log(fs_info, eb))
 		return 0;
 
+	/*
+	 * When we override something during the move, we log these removals.
+	 * This can only happen when we move towards the beginning of the
+	 * buffer, i.e. dst_slot < src_slot.
+	 */
 	for (i = 0; i + dst_slot < src_slot && i < nr_items; i++) {
 		ret = tree_mod_log_insert_key_locked(fs_info, eb, i + dst_slot,
 					      MOD_LOG_KEY_REMOVE_WHILE_MOVING);
-- 
1.7.1

