Return-Path: <SRS0=ca24=NC=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40ACEC67863
	for <linux-btrfs@archiver.kernel.org>; Mon, 22 Oct 2018 09:09:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E363120779
	for <linux-btrfs@archiver.kernel.org>; Mon, 22 Oct 2018 09:09:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="O/7PIAne"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E363120779
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728225AbeJVR1a (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 22 Oct 2018 13:27:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:45890 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727218AbeJVR13 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 22 Oct 2018 13:27:29 -0400
Received: from localhost.localdomain (bl8-197-74.dsl.telepac.pt [85.241.197.74])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 91ABC2083A
        for <linux-btrfs@vger.kernel.org>; Mon, 22 Oct 2018 09:09:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1540199390;
        bh=3agwm2dPqVWFWVFQewEbSHCp2f6vBI2xeZInxh9FM3g=;
        h=From:To:Subject:Date:From;
        b=O/7PIAneh5dqG7QcVNe2Z3vqNwKEnA9MATFDXzX5EO1kiLiScLjYjp+dZT7UZ8A9c
         2aN9qoBN0O8nchDnFu37w0i0rM7xFDt0EQDE1X9B2tiWXVh77h4/aF/LDrkMtMEHBc
         VyfS02ViSLBrHHXLXlzwuBECESRlbamaRln1wUWY=
From:   fdmanana@kernel.org
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: fix deadlock on tree root leaf when finding free extent
Date:   Mon, 22 Oct 2018 10:09:46 +0100
Message-Id: <20181022090946.1150-1-fdmanana@kernel.org>
X-Mailer: git-send-email 2.11.0
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
groups that are not yet cached (rare cases) if we are updating the inode
of a free space cache. This is a rare case and its downside is failure to
find a free extent (return -ENOSPC) when all the already cached block
groups have no free extents.

Reported-by: Andrew Nelson <andrew.s.nelson@gmail.com>
Link: https://lore.kernel.org/linux-btrfs/CAPTELenq9x5KOWuQ+fa7h1r3nsJG8vyiTH8+ifjURc_duHh2Wg@mail.gmail.com/
Fixes: 9d66e233c704 ("Btrfs: load free space cache if it exists")
Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/ctree.h       |  3 +++
 fs/btrfs/disk-io.c     |  2 ++
 fs/btrfs/extent-tree.c | 22 +++++++++++++++++++++-
 3 files changed, 26 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 2cddfe7806a4..d23ee26eb17d 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -1121,6 +1121,9 @@ struct btrfs_fs_info {
 	u32 sectorsize;
 	u32 stripesize;
 
+	/* The task currently updating a free space cache inode item. */
+	struct task_struct *space_cache_updater;
+
 #ifdef CONFIG_BTRFS_FS_REF_VERIFY
 	spinlock_t ref_verify_lock;
 	struct rb_root block_tree;
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 05dc3c17cb62..aa5e9a91e560 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -2782,6 +2782,8 @@ int open_ctree(struct super_block *sb,
 	fs_info->sectorsize = 4096;
 	fs_info->stripesize = 4096;
 
+	fs_info->space_cache_updater = NULL;
+
 	ret = btrfs_alloc_stripe_hash_table(fs_info);
 	if (ret) {
 		err = ret;
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 577878324799..e93040449771 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -3364,7 +3364,9 @@ static int cache_save_setup(struct btrfs_block_group_cache *block_group,
 	 * time.
 	 */
 	BTRFS_I(inode)->generation = 0;
+	fs_info->space_cache_updater = current;
 	ret = btrfs_update_inode(trans, root, inode);
+	fs_info->space_cache_updater = NULL;
 	if (ret) {
 		/*
 		 * So theoretically we could recover from this, simply set the
@@ -7366,7 +7368,25 @@ static noinline int find_free_extent(struct btrfs_fs_info *fs_info,
 
 have_block_group:
 		cached = block_group_cache_done(block_group);
-		if (unlikely(!cached)) {
+		/*
+		 * If we are updating the inode of a free space cache, we can
+		 * not start the caching of any block group because we could
+		 * deadlock on an extent buffer of the root tree.
+		 * At cache_save_setup() we update the inode item of a free
+		 * space cache, so we may need to COW a leaf of the root tree,
+		 * which implies finding a free metadata extent. So if when
+		 * searching for such an extent we find a block group that was
+		 * not yet cached (which is unlikely), we can not start loading
+		 * or building its free space cache because that implies reading
+		 * its inode from disk (load_free_space_cache()) which implies
+		 * searching the root tree for its inode item, which can be
+		 * located in the same leaf that we previously locked at
+		 * cache_save_setup() for updating the inode item of the former
+		 * free space cache, therefore leading to an attempt to lock the
+		 * same leaf twice.
+		 */
+		if (unlikely(!cached) &&
+		    fs_info->space_cache_updater != current) {
 			have_caching_bg = true;
 			ret = cache_block_group(block_group, 0);
 			BUG_ON(ret < 0);
-- 
2.11.0

