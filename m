Return-Path: <SRS0=MIpn=R5=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A252C43381
	for <linux-btrfs@archiver.kernel.org>; Tue, 26 Mar 2019 19:03:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EDC1D20823
	for <linux-btrfs@archiver.kernel.org>; Tue, 26 Mar 2019 19:03:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732744AbfCZTDv (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 26 Mar 2019 15:03:51 -0400
Received: from mx2.suse.de ([195.135.220.15]:37192 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1732739AbfCZTDu (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 26 Mar 2019 15:03:50 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id AE5DCADF2;
        Tue, 26 Mar 2019 19:03:48 +0000 (UTC)
From:   Goldwyn Rodrigues <rgoldwyn@suse.de>
To:     linux-btrfs@vger.kernel.org
Cc:     linux-fsdevel@vger.kernel.org,
        Goldwyn Rodrigues <rgoldwyn@suse.com>
Subject: [PATCH 15/15] btrfs: Writeprotect mmap pages on snapshot
Date:   Tue, 26 Mar 2019 14:03:01 -0500
Message-Id: <20190326190301.32365-16-rgoldwyn@suse.de>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20190326190301.32365-1-rgoldwyn@suse.de>
References: <20190326190301.32365-1-rgoldwyn@suse.de>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Goldwyn Rodrigues <rgoldwyn@suse.com>

Inorder to make sure mmap'd files don't change after snapshot,
writeprotect the mmap pages on snapshot. This is done by performing
a data writeback on the pages (which simply mark the pages are
wrprotected). This way if the user process tries to access the memory
we will get another fault and we can perform a CoW.

In order to accomplish this, we tag all CoW pages as
PAGECACHE_TAG_TOWRITE, and add the mmapd inode in delalloc_inodes.
During snapshot, it starts writeback of all delalloc'd inodes and
here we perform a data writeback. We don't want to keep the inodes
in delalloc_inodes until it umount (WARN_ON), so we remove it
during inode evictions.

This looks hackish. Other alternatives could be to create another
list for mmap'd files or rename delalloc_inodes to writeback_inodes.
Suggestions?

Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
---
 fs/btrfs/ctree.h |  3 ++-
 fs/btrfs/dax.c   |  7 +++++++
 fs/btrfs/inode.c | 13 ++++++++++++-
 fs/dax.c         |  3 +++
 4 files changed, 24 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 21068dc4a95a..68a63d93556a 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -3252,7 +3252,8 @@ int btrfs_create_subvol_root(struct btrfs_trans_handle *trans,
 			     struct btrfs_root *new_root,
 			     struct btrfs_root *parent_root,
 			     u64 new_dirid);
- void btrfs_set_delalloc_extent(struct inode *inode, struct extent_state *state,
+void btrfs_add_delalloc_inodes(struct btrfs_root *root, struct inode *inode);
+void btrfs_set_delalloc_extent(struct inode *inode, struct extent_state *state,
 			       unsigned *bits);
 void btrfs_clear_delalloc_extent(struct inode *inode,
 				 struct extent_state *state, unsigned *bits);
diff --git a/fs/btrfs/dax.c b/fs/btrfs/dax.c
index d73945d50b88..bcb961242c74 100644
--- a/fs/btrfs/dax.c
+++ b/fs/btrfs/dax.c
@@ -166,10 +166,17 @@ vm_fault_t btrfs_dax_fault(struct vm_fault *vmf)
 {
 	vm_fault_t ret;
 	pfn_t pfn;
+	struct inode *inode = file_inode(vmf->vma->vm_file);
+	struct btrfs_inode *binode = BTRFS_I(inode);
 	ret = dax_iomap_fault(vmf, PE_SIZE_PTE, &pfn, NULL, &btrfs_iomap_ops);
 	if (ret & VM_FAULT_NEEDDSYNC)
 		ret = dax_finish_sync_fault(vmf, PE_SIZE_PTE, pfn);
 
+	/* Insert into delalloc so we get writeback calls on snapshots */
+	if (vmf->flags & FAULT_FLAG_WRITE &&
+			!test_bit(BTRFS_INODE_IN_DELALLOC_LIST, &binode->runtime_flags))
+		btrfs_add_delalloc_inodes(binode->root, inode);
+
 	return ret;
 }
 
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 5350e5f23728..3b72c1c96b34 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -1713,7 +1713,7 @@ void btrfs_merge_delalloc_extent(struct inode *inode, struct extent_state *new,
 	spin_unlock(&BTRFS_I(inode)->lock);
 }
 
-static void btrfs_add_delalloc_inodes(struct btrfs_root *root,
+void btrfs_add_delalloc_inodes(struct btrfs_root *root,
 				      struct inode *inode)
 {
 	struct btrfs_fs_info *fs_info = btrfs_sb(inode->i_sb);
@@ -5358,12 +5358,17 @@ void btrfs_evict_inode(struct inode *inode)
 {
 	struct btrfs_fs_info *fs_info = btrfs_sb(inode->i_sb);
 	struct btrfs_trans_handle *trans;
+	struct btrfs_inode *binode = BTRFS_I(inode);
 	struct btrfs_root *root = BTRFS_I(inode)->root;
 	struct btrfs_block_rsv *rsv;
 	int ret;
 
 	trace_btrfs_inode_evict(inode);
 
+	if (IS_DAX(inode)
+	    && test_bit(BTRFS_INODE_IN_DELALLOC_LIST, &binode->runtime_flags))
+		btrfs_del_delalloc_inode(root, binode);
+
 	if (!root) {
 		clear_inode(inode);
 		return;
@@ -8683,6 +8688,10 @@ static int btrfs_dax_writepages(struct address_space *mapping,
 {
 	struct inode *inode = mapping->host;
 	struct btrfs_fs_info *fs_info = btrfs_sb(inode->i_sb);
+	struct btrfs_inode *binode = BTRFS_I(inode);
+	if ((wbc->sync_mode == WB_SYNC_ALL) &&
+	    test_bit(BTRFS_INODE_IN_DELALLOC_LIST, &binode->runtime_flags))
+		btrfs_del_delalloc_inode(binode->root, binode);
 	return dax_writeback_mapping_range(mapping, fs_info->fs_devices->latest_bdev,
 			wbc);
 }
@@ -9981,6 +9990,8 @@ static void btrfs_run_delalloc_work(struct btrfs_work *work)
 	delalloc_work = container_of(work, struct btrfs_delalloc_work,
 				     work);
 	inode = delalloc_work->inode;
+	if (IS_DAX(inode))
+		filemap_fdatawrite(inode->i_mapping);
 	filemap_flush(inode->i_mapping);
 	if (test_bit(BTRFS_INODE_HAS_ASYNC_EXTENT,
 				&BTRFS_I(inode)->runtime_flags))
diff --git a/fs/dax.c b/fs/dax.c
index 93146142bb00..c42e9cb486ef 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -753,6 +753,9 @@ static void *dax_insert_entry(struct xa_state *xas,
 	if (dirty)
 		xas_set_mark(xas, PAGECACHE_TAG_DIRTY);
 
+	if (cow)
+		xas_set_mark(xas, PAGECACHE_TAG_TOWRITE);
+
 	xas_unlock_irq(xas);
 	return entry;
 }
-- 
2.16.4

