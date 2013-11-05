Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:55155 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750759Ab3KEHCO (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 5 Nov 2013 02:02:14 -0500
From: Aldo Iljazi <mail@aldo.io>
To: chris.mason@fusionio.com
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] BTRFS: fixed coding style issues
Date: Tue,  5 Nov 2013 09:02:01 +0200
Message-Id: <1383634921-4271-1-git-send-email-mail@aldo.io>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Line 4989: Inserted a space after the comma.
Lines 7986 and 8274: Inserted a space before the open parenthesis.

Signed-off-by: Aldo Iljazi <mail@aldo.io>
---
 fs/btrfs/extent-tree.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index d58bef1..3bcd7c0 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -4986,7 +4986,7 @@ int btrfs_delalloc_reserve_metadata(struct inode *inode, u64 num_bytes)
 		mutex_unlock(&BTRFS_I(inode)->delalloc_mutex);
 
 	if (to_reserve)
-		trace_btrfs_space_reservation(root->fs_info,"delalloc",
+		trace_btrfs_space_reservation(root->fs_info, "delalloc",
 					      btrfs_ino(inode), to_reserve, 1);
 	block_rsv_add_bytes(block_rsv, to_reserve, 1);
 
@@ -7983,7 +7983,7 @@ u64 btrfs_account_ro_block_groups_free_space(struct btrfs_space_info *sinfo)
 
 	spin_lock(&sinfo->lock);
 
-	for(i = 0; i < BTRFS_NR_RAID_TYPES; i++)
+	for (i = 0; i < BTRFS_NR_RAID_TYPES; i++)
 		if (!list_empty(&sinfo->block_groups[i]))
 			free_bytes += __btrfs_get_ro_block_group_free_space(
 						&sinfo->block_groups[i]);
@@ -8271,7 +8271,7 @@ int btrfs_free_block_groups(struct btrfs_fs_info *info)
 
 	release_global_block_rsv(info);
 
-	while(!list_empty(&info->space_info)) {
+	while (!list_empty(&info->space_info)) {
 		space_info = list_entry(info->space_info.next,
 					struct btrfs_space_info,
 					list);
-- 
1.8.3.2

