Return-Path: <SRS0=ca24=NC=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EADDEC004D3
	for <linux-btrfs@archiver.kernel.org>; Mon, 22 Oct 2018 18:51:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E396720651
	for <linux-btrfs@archiver.kernel.org>; Mon, 22 Oct 2018 18:51:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="ShX6nGHE"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E396720651
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728935AbeJWDLB (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 22 Oct 2018 23:11:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:58372 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727748AbeJWDLB (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 22 Oct 2018 23:11:01 -0400
Received: from localhost.localdomain (bl8-197-74.dsl.telepac.pt [85.241.197.74])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8DE9220651;
        Mon, 22 Oct 2018 18:51:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1540234280;
        bh=RlvoLJH125YB6RVYMsCqUnogBlFxIh3vqwc9EuuOkvw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ShX6nGHEbhqSXgRjtg9vmw6/8sufg+WXdoL0BKricYM4pgBOsQaZ2iU7YlIZUU+x6
         ITIKnDCpqOPwMcC5JMfFat02zIBQPbNAyHsOqp40iGtVMWrTGY9Z3afddn0nhx7DsH
         kjonwNfhboaiTZ98M1lRQJnWiwMDn2Q0SerbY4sY=
From:   fdmanana@kernel.org
To:     linux-btrfs@vger.kernel.org
Cc:     josef@toxicpanda.com, Filipe Manana <fdmanana@suse.com>
Subject: [PATCH v2] Btrfs: fix deadlock on tree root leaf when finding free extent
Date:   Mon, 22 Oct 2018 19:48:30 +0100
Message-Id: <20181022184830.415-1-fdmanana@kernel.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20181022090946.1150-1-fdmanana@kernel.org>
References: <20181022090946.1150-1-fdmanana@kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Filipe Manana <fdmanana@suse.com>

When we are writing out a free space cache, during the transaction commit
phase, we can end up in a deadlock which results in a stack trace like the
following:

 schedule+0x28/0x80
 btrfs_tree_read_lock+0x8e/0x120 [btrfs]
 ? finish_wait+0x80/0x80
 btrfs_read_lock_root_node+0x2f/0x40 [btrfs]
 btrfs_search_slot+0xf6/0x9f0 [btrfs]
 ? evict_refill_and_join+0xd0/0xd0 [btrfs]
 ? inode_insert5+0x119/0x190
 btrfs_lookup_inode+0x3a/0xc0 [btrfs]
 ? kmem_cache_alloc+0x166/0x1d0
 btrfs_iget+0x113/0x690 [btrfs]
 __lookup_free_space_inode+0xd8/0x150 [btrfs]
 lookup_free_space_inode+0x5b/0xb0 [btrfs]
 load_free_space_cache+0x7c/0x170 [btrfs]
 ? cache_block_group+0x72/0x3b0 [btrfs]
 cache_block_group+0x1b3/0x3b0 [btrfs]
 ? finish_wait+0x80/0x80
 find_free_extent+0x799/0x1010 [btrfs]
 btrfs_reserve_extent+0x9b/0x180 [btrfs]
 btrfs_alloc_tree_block+0x1b3/0x4f0 [btrfs]
 __btrfs_cow_block+0x11d/0x500 [btrfs]
 btrfs_cow_block+0xdc/0x180 [btrfs]
 btrfs_search_slot+0x3bd/0x9f0 [btrfs]
 btrfs_lookup_inode+0x3a/0xc0 [btrfs]
 ? kmem_cache_alloc+0x166/0x1d0
 btrfs_update_inode_item+0x46/0x100 [btrfs]
 cache_save_setup+0xe4/0x3a0 [btrfs]
 btrfs_start_dirty_block_groups+0x1be/0x480 [btrfs]
 btrfs_commit_transaction+0xcb/0x8b0 [btrfs]

At cache_save_setup() we need to update the inode item of a block group's
cache which is located in the tree root (fs_info->tree_root), which means
that it may result in COWing a leaf from that tree. If that happens we
need to find a free metadata extent and while looking for one, if we find
a block group which was not cached yet we attempt to load its cache by
calling cache_block_group(). However this function will try to load the
inode of the free space cache, which requires finding the matching inode
item in the tree root - if that inode item is located in the same leaf as
the inode item of the space cache we are updating at cache_save_setup(),
we end up in a deadlock, since we try to obtain a read lock on the same
extent buffer that we previously write locked.

So fix this by skipping the loading of free space caches of any block
groups that are not yet cached (rare cases) if we are COWing an extent
buffer from the root tree and space caching is enabled (-o space_cache
mount option). This is a rare case and its downside is failure to
find a free extent (return -ENOSPC) when all the already cached block
groups have no free extents.

Reported-by: Andrew Nelson <andrew.s.nelson@gmail.com>
Link: https://lore.kernel.org/linux-btrfs/CAPTELenq9x5KOWuQ+fa7h1r3nsJG8vyiTH8+ifjURc_duHh2Wg@mail.gmail.com/
Fixes: 9d66e233c704 ("Btrfs: load free space cache if it exists")
Tested-by: Andrew Nelson <andrew.s.nelson@gmail.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
---

V2: Made the solution more generic, since the problem could happen in any
    path COWing an extent buffer from the root tree.

    Applies on top of a previous patch titled:

     "Btrfs: fix deadlock when writing out free space caches"

 fs/btrfs/ctree.c       |  4 ++++
 fs/btrfs/ctree.h       |  3 +++
 fs/btrfs/disk-io.c     |  2 ++
 fs/btrfs/extent-tree.c | 15 ++++++++++++++-
 4 files changed, 23 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index 089b46c4d97f..646aafda55a3 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -1065,10 +1065,14 @@ static noinline int __btrfs_cow_block(struct btrfs_trans_handle *trans,
 	    root == fs_info->chunk_root ||
 	    root == fs_info->dev_root)
 		trans->can_flush_pending_bgs = false;
+	else if (root == fs_info->tree_root)
+		atomic_inc(&fs_info->tree_root_cows);
 
 	cow = btrfs_alloc_tree_block(trans, root, parent_start,
 			root->root_key.objectid, &disk_key, level,
 			search_start, empty_size);
+	if (root == fs_info->tree_root)
+		atomic_dec(&fs_info->tree_root_cows);
 	trans->can_flush_pending_bgs = true;
 	if (IS_ERR(cow))
 		return PTR_ERR(cow);
diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 2cddfe7806a4..1b73433c69e2 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -1121,6 +1121,9 @@ struct btrfs_fs_info {
 	u32 sectorsize;
 	u32 stripesize;
 
+	/* Number of tasks corrently COWing a leaf/node from the tree root. */
+	atomic_t tree_root_cows;
+
 #ifdef CONFIG_BTRFS_FS_REF_VERIFY
 	spinlock_t ref_verify_lock;
 	struct rb_root block_tree;
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 05dc3c17cb62..08c15bf69fb5 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -2782,6 +2782,8 @@ int open_ctree(struct super_block *sb,
 	fs_info->sectorsize = 4096;
 	fs_info->stripesize = 4096;
 
+	atomic_set(&fs_info->tree_root_cows, 0);
+
 	ret = btrfs_alloc_stripe_hash_table(fs_info);
 	if (ret) {
 		err = ret;
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 577878324799..14f35e020050 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -7366,7 +7366,20 @@ static noinline int find_free_extent(struct btrfs_fs_info *fs_info,
 
 have_block_group:
 		cached = block_group_cache_done(block_group);
-		if (unlikely(!cached)) {
+		/*
+		 * If we are COWing a leaf/node from the root tree, we can not
+		 * start caching of a block group because we could deadlock on
+		 * an extent buffer of the root tree.
+		 * Because if we are COWing a leaf from the root tree, we are
+		 * holding a write lock on the respective extent buffer, and
+		 * loading the space cache of a block group requires searching
+		 * for its inode item in the root tree, which can be located
+		 * in the same leaf that we previously write locked, in which
+		 * case we will deadlock.
+		 */
+		if (unlikely(!cached) &&
+		    (atomic_read(&fs_info->tree_root_cows) == 0 ||
+		     !btrfs_test_opt(fs_info, SPACE_CACHE))) {
 			have_caching_bg = true;
 			ret = cache_block_group(block_group, 0);
 			BUG_ON(ret < 0);
-- 
2.11.0

