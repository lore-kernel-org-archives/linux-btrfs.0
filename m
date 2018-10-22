Return-Path: <SRS0=ca24=NC=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6EF73C004D3
	for <linux-btrfs@archiver.kernel.org>; Mon, 22 Oct 2018 19:10:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 799FB20645
	for <linux-btrfs@archiver.kernel.org>; Mon, 22 Oct 2018 19:10:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="Bcxgcfyr"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 799FB20645
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728605AbeJWDaj (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 22 Oct 2018 23:30:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:33326 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728161AbeJWDai (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 22 Oct 2018 23:30:38 -0400
Received: from localhost.localdomain (bl8-197-74.dsl.telepac.pt [85.241.197.74])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5848120663;
        Mon, 22 Oct 2018 19:10:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1540235454;
        bh=z0tHsBgjVR2C11Tx4cYWCxFhsAswsxiXeMszx646dhc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BcxgcfyrNuDzIVaHcH09px2L6/4rSqeWCsXfaKg687ZRGK2uGro6oJtP4+FNZUrxt
         QwLLLCki6cM+be4QABLZ3up/yVq0FIBGrIfHp5Q8vYJ5eusnyu+VFc6pRX4aQa13DM
         XobcaozE3+8slvvIQFKD3ukUlWKhyQplIOLP3lVg=
From:   fdmanana@kernel.org
To:     linux-btrfs@vger.kernel.org
Cc:     josef@toxicpanda.com, Filipe Manana <fdmanana@suse.com>
Subject: [PATCH v3] Btrfs: fix deadlock on tree root leaf when finding free extent
Date:   Mon, 22 Oct 2018 20:10:37 +0100
Message-Id: <20181022191037.18471-1-fdmanana@kernel.org>
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

V3: Made it more simple by avoiding the atomic from V2 and pass the root
    to find_free_extent().

 fs/btrfs/extent-tree.c | 22 ++++++++++++++++++----
 1 file changed, 18 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 577878324799..e5fd086799ab 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -7218,12 +7218,13 @@ btrfs_release_block_group(struct btrfs_block_group_cache *cache,
  * the free space extent currently.
  */
 static noinline int find_free_extent(struct btrfs_fs_info *fs_info,
+				struct btrfs_root *root,
 				u64 ram_bytes, u64 num_bytes, u64 empty_size,
 				u64 hint_byte, struct btrfs_key *ins,
 				u64 flags, int delalloc)
 {
 	int ret = 0;
-	struct btrfs_root *root = fs_info->extent_root;
+	struct btrfs_root *extent_root = fs_info->extent_root;
 	struct btrfs_free_cluster *last_ptr = NULL;
 	struct btrfs_block_group_cache *block_group = NULL;
 	u64 search_start = 0;
@@ -7366,7 +7367,20 @@ static noinline int find_free_extent(struct btrfs_fs_info *fs_info,
 
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
+		    (root != fs_info->tree_root ||
+		     !btrfs_test_opt(fs_info, SPACE_CACHE))) {
 			have_caching_bg = true;
 			ret = cache_block_group(block_group, 0);
 			BUG_ON(ret < 0);
@@ -7633,7 +7647,7 @@ static noinline int find_free_extent(struct btrfs_fs_info *fs_info,
 			if (trans)
 				exist = 1;
 			else
-				trans = btrfs_join_transaction(root);
+				trans = btrfs_join_transaction(extent_root);
 
 			if (IS_ERR(trans)) {
 				ret = PTR_ERR(trans);
@@ -7796,7 +7810,7 @@ int btrfs_reserve_extent(struct btrfs_root *root, u64 ram_bytes,
 	flags = get_alloc_profile_by_root(root, is_data);
 again:
 	WARN_ON(num_bytes < fs_info->sectorsize);
-	ret = find_free_extent(fs_info, ram_bytes, num_bytes, empty_size,
+	ret = find_free_extent(fs_info, root, ram_bytes, num_bytes, empty_size,
 			       hint_byte, ins, flags, delalloc);
 	if (!ret && !is_data) {
 		btrfs_dec_block_group_reservations(fs_info, ins->objectid);
-- 
2.11.0

