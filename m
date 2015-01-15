Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from victor.provo.novell.com ([137.65.250.26]:39101 "EHLO
	prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752743AbbAORiW (ORCPT
	<rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
	Thu, 15 Jan 2015 12:38:22 -0500
From: Filipe Manana <fdmanana@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Filipe Manana <fdmanana@suse.com>
Subject: [PATCH] Btrfs: fix race deleting block group from space_info->ro_bgs list
Date: Thu, 15 Jan 2015 17:38:08 +0000
Message-Id: <1421343488-28263-1-git-send-email-fdmanana@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When removing a block group we were deleting it from its space_info's
ro_bgs list, using list_del_init, without any synchronization.
Fix this by doing the list delete while holding the space info and
block group spinlocks.

This issue was introduced in the 3.19 kernel by the following change:

    Btrfs: move read only block groups onto their own list V2
    commit 633c0aad4c0243a506a3e8590551085ad78af82d

I ran into a kernel crash while a block group was being removed, another
task was executing statfs in parallel (iterating the space_info->ro_bgs
list) and other another task was setting another block group to readonly
mode (which adds it to the list space_info->ro_bgs). This happened while
running the stress test xfstests/generic/038 I recently made.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/extent-tree.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 5a45253..09145ac 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -9424,7 +9424,6 @@ int btrfs_remove_block_group(struct btrfs_trans_handle *trans,
 	 * are still on the list after taking the semaphore
 	 */
 	list_del_init(&block_group->list);
-	list_del_init(&block_group->ro_list);
 	if (list_empty(&block_group->space_info->block_groups[index])) {
 		kobj = block_group->space_info->block_group_kobjs[index];
 		block_group->space_info->block_group_kobjs[index] = NULL;
@@ -9466,6 +9465,9 @@ int btrfs_remove_block_group(struct btrfs_trans_handle *trans,
 	btrfs_remove_free_space_cache(block_group);
 
 	spin_lock(&block_group->space_info->lock);
+	spin_lock(&block_group->lock);
+	list_del_init(&block_group->ro_list);
+	spin_unlock(&block_group->lock);
 	block_group->space_info->total_bytes -= block_group->key.offset;
 	block_group->space_info->bytes_readonly -= block_group->key.offset;
 	block_group->space_info->disk_total -= block_group->key.offset * factor;
-- 
2.1.3

