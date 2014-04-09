Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:37111 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933736AbaDIVXZ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 9 Apr 2014 17:23:25 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id D7B69ACEC
	for <linux-btrfs@vger.kernel.org>; Wed,  9 Apr 2014 21:23:24 +0000 (UTC)
Message-ID: <5345BA4B.5010007@suse.com>
Date: Wed, 09 Apr 2014 17:23:23 -0400
From: Jeff Mahoney <jeffm@suse.com>
MIME-Version: 1.0
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: [PATCH] btrfs: fix lockdep warning with reclaim lock inversion
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When encountering memory pressure, testers have run into the following
lockdep warning. It was caused by __link_block_group calling kobject_add
with the groups_sem held. kobject_add calls kvasprintf with GFP_KERNEL,
which gets us into reclaim context. The kobject doesn't actually need
to be added under the lock -- it just needs to ensure that it's only
added for the first block group to be linked. We also need to release
the lock before removing the kobjects.

=========================================================
[ INFO: possible irq lock inversion dependency detected ]
3.14.0-rc8-default #1 Not tainted
---------------------------------------------------------
kswapd0/169 just changed the state of lock:
 (&delayed_node->mutex){+.+.-.}, at: [<ffffffffa018baea>] __btrfs_release_delayed_node+0x3a/0x200 [btrfs]
but this lock took another, RECLAIM_FS-unsafe lock in the past:
 (&found->groups_sem){+++++.}

and interrupts could create inverse lock ordering between them.

other info that might help us debug this:
 Possible interrupt unsafe locking scenario:
       CPU0                    CPU1
       ----                    ----
  lock(&found->groups_sem);
                               local_irq_disable();
                               lock(&delayed_node->mutex);
                               lock(&found->groups_sem);
  <Interrupt>
    lock(&delayed_node->mutex);

 *** DEADLOCK ***
2 locks held by kswapd0/169:
 #0:  (shrinker_rwsem){++++..}, at: [<ffffffff81159e8a>] shrink_slab+0x3a/0x160
 #1:  (&type->s_umount_key#27){++++..}, at: [<ffffffff811bac6f>] grab_super_passive+0x3f/0x90

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 fs/btrfs/extent-tree.c |   20 ++++++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)

--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -8343,9 +8343,15 @@ static void __link_block_group(struct bt
 			       struct btrfs_block_group_cache *cache)
 {
 	int index = get_block_group_index(cache);
+	bool first = false;
 
 	down_write(&space_info->groups_sem);
-	if (list_empty(&space_info->block_groups[index])) {
+	if (list_empty(&space_info->block_groups[index]))
+		first = true;
+	list_add_tail(&cache->list, &space_info->block_groups[index]);
+	up_write(&space_info->groups_sem);
+
+	if (first) {
 		struct kobject *kobj = &space_info->block_group_kobjs[index];
 		int ret;
 
@@ -8357,8 +8363,6 @@ static void __link_block_group(struct bt
 			kobject_put(&space_info->kobj);
 		}
 	}
-	list_add_tail(&cache->list, &space_info->block_groups[index]);
-	up_write(&space_info->groups_sem);
 }
 
 static struct btrfs_block_group_cache *
@@ -8693,6 +8697,7 @@ int btrfs_remove_block_group(struct btrf
 	struct btrfs_root *tree_root = root->fs_info->tree_root;
 	struct btrfs_key key;
 	struct inode *inode;
+	bool cleanup_needed = false;
 	int ret;
 	int index;
 	int factor;
@@ -8791,12 +8796,15 @@ int btrfs_remove_block_group(struct btrf
 	 * are still on the list after taking the semaphore
 	 */
 	list_del_init(&block_group->list);
-	if (list_empty(&block_group->space_info->block_groups[index])) {
+	if (list_empty(&block_group->space_info->block_groups[index]))
+		cleanup_needed = true;
+	up_write(&block_group->space_info->groups_sem);
+
+	if (cleanup_needed) {
+		clear_avail_alloc_bits(root->fs_info, block_group->flags);
 		kobject_del(&block_group->space_info->block_group_kobjs[index]);
 		kobject_put(&block_group->space_info->block_group_kobjs[index]);
-		clear_avail_alloc_bits(root->fs_info, block_group->flags);
 	}
-	up_write(&block_group->space_info->groups_sem);
 
 	if (block_group->cached == BTRFS_CACHE_STARTED)
 		wait_block_group_cache_done(block_group);

-- 
Jeff Mahoney
SUSE Labs
