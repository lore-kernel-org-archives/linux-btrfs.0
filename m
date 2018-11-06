Return-Path: <SRS0=BJi/=NR=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EEC3FC46465
	for <linux-btrfs@archiver.kernel.org>; Tue,  6 Nov 2018 06:41:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A2EE32081D
	for <linux-btrfs@archiver.kernel.org>; Tue,  6 Nov 2018 06:41:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A2EE32081D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=cn.fujitsu.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387604AbeKFQFZ (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 6 Nov 2018 11:05:25 -0500
Received: from mail.cn.fujitsu.com ([183.91.158.132]:31748 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2387505AbeKFQFY (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 6 Nov 2018 11:05:24 -0500
X-IronPort-AV: E=Sophos;i="5.43,368,1503331200"; 
   d="scan'208";a="47417667"
Received: from unknown (HELO cn.fujitsu.com) ([10.167.33.5])
  by heian.cn.fujitsu.com with ESMTP; 06 Nov 2018 14:41:38 +0800
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (unknown [10.167.33.80])
        by cn.fujitsu.com (Postfix) with ESMTP id 4B5E94B714DB;
        Tue,  6 Nov 2018 14:41:36 +0800 (CST)
Received: from fnst.lan (10.167.226.155) by G08CNEXCHPEKD01.g08.fujitsu.local
 (10.167.33.89) with Microsoft SMTP Server (TLS) id 14.3.408.0; Tue, 6 Nov
 2018 14:41:39 +0800
From:   Lu Fengqi <lufq.fnst@cn.fujitsu.com>
To:     <linux-btrfs@vger.kernel.org>
CC:     Qu Wenruo <quwenruo@cn.fujitsu.com>,
        Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
Subject: [PATCH v15.1 10/13] btrfs: dedupe: Inband in-memory only de-duplication implement
Date:   Tue, 6 Nov 2018 14:41:19 +0800
Message-ID: <20181106064122.6154-11-lufq.fnst@cn.fujitsu.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20181106064122.6154-1-lufq.fnst@cn.fujitsu.com>
References: <20181106064122.6154-1-lufq.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.167.226.155]
X-yoursite-MailScanner-ID: 4B5E94B714DB.AC7AA
X-yoursite-MailScanner: Found to be clean
X-yoursite-MailScanner-From: lufq.fnst@cn.fujitsu.com
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Qu Wenruo <quwenruo@cn.fujitsu.com>

Core implement for inband de-duplication.
It reuses the async_cow_start() facility to do the calculate dedupe hash.
And use dedupe hash to do inband de-duplication at extent level.

The workflow is as below:
1) Run delalloc range for an inode
2) Calculate hash for the delalloc range at the unit of dedupe_bs
3) For hash match(duplicated) case, just increase source extent ref
   and insert file extent.
   For hash mismatch case, go through the normal cow_file_range()
   fallback, and add hash into dedupe_tree.
   Compress for hash miss case is not supported yet.

Current implement restore all dedupe hash in memory rb-tree, with LRU
behavior to control the limit.

Signed-off-by: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
Signed-off-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
---
 fs/btrfs/ctree.h       |   4 +-
 fs/btrfs/dedupe.h      |  15 ++
 fs/btrfs/extent-tree.c |  31 +++-
 fs/btrfs/extent_io.c   |   7 +-
 fs/btrfs/extent_io.h   |   1 +
 fs/btrfs/file.c        |   4 +
 fs/btrfs/inode.c       | 319 ++++++++++++++++++++++++++++++++++-------
 fs/btrfs/ioctl.c       |   1 +
 fs/btrfs/relocation.c  |  18 +++
 9 files changed, 343 insertions(+), 57 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index b119a19cbeaf..3a8e35b5328a 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -106,9 +106,11 @@ static inline u32 count_max_extents(u64 size, u64 max_extent_size)
  */
 enum btrfs_metadata_reserve_type {
 	BTRFS_RESERVE_NORMAL,
+	BTRFS_RESERVE_DEDUPE,
 };
 
-u64 btrfs_max_extent_size(enum btrfs_metadata_reserve_type reserve_type);
+u64 btrfs_max_extent_size(struct btrfs_inode *inode,
+			  enum btrfs_metadata_reserve_type reserve_type);
 
 struct btrfs_mapping_tree {
 	struct extent_map_tree map_tree;
diff --git a/fs/btrfs/dedupe.h b/fs/btrfs/dedupe.h
index 87f5b7ce7766..8157b17c4d11 100644
--- a/fs/btrfs/dedupe.h
+++ b/fs/btrfs/dedupe.h
@@ -7,6 +7,7 @@
 #define BTRFS_DEDUPE_H
 
 #include <crypto/hash.h>
+#include "btrfs_inode.h"
 
 /* 32 bytes for SHA256 */
 static const int btrfs_hash_sizes[] = { 32 };
@@ -47,6 +48,20 @@ struct btrfs_dedupe_info {
 	u64 current_nr;
 };
 
+static inline u64 btrfs_dedupe_blocksize(struct btrfs_inode *inode)
+{
+	struct btrfs_fs_info *fs_info = inode->root->fs_info;
+
+	return fs_info->dedupe_info->blocksize;
+}
+
+static inline int inode_need_dedupe(struct inode *inode)
+{
+	struct btrfs_fs_info *fs_info = BTRFS_I(inode)->root->fs_info;
+
+	return fs_info->dedupe_enabled;
+}
+
 static inline int btrfs_dedupe_hash_hit(struct btrfs_dedupe_hash *hash)
 {
 	return (hash && hash->bytenr);
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 2c8992b919ae..fa3654045ba8 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -28,6 +28,7 @@
 #include "sysfs.h"
 #include "qgroup.h"
 #include "ref-verify.h"
+#include "dedupe.h"
 
 #undef SCRAMBLE_DELAYED_REFS
 
@@ -2492,6 +2493,17 @@ static int cleanup_ref_head(struct btrfs_trans_handle *trans,
 		btrfs_pin_extent(fs_info, head->bytenr,
 				 head->num_bytes, 1);
 		if (head->is_data) {
+			/*
+			 * If insert_reserved is given, it means
+			 * a new extent is revered, then deleted
+			 * in one tran, and inc/dec get merged to 0.
+			 *
+			 * In this case, we need to remove its dedupe
+			 * hash.
+			 */
+			ret = btrfs_dedupe_del(fs_info, head->bytenr);
+			if (ret < 0)
+				return ret;
 			ret = btrfs_del_csums(trans, fs_info, head->bytenr,
 					      head->num_bytes);
 		}
@@ -5913,13 +5925,15 @@ static void btrfs_calculate_inode_block_rsv_size(struct btrfs_fs_info *fs_info,
 	spin_unlock(&block_rsv->lock);
 }
 
-u64 btrfs_max_extent_size(enum btrfs_metadata_reserve_type reserve_type)
+u64 btrfs_max_extent_size(struct btrfs_inode *inode,
+			  enum btrfs_metadata_reserve_type reserve_type)
 {
 	if (reserve_type == BTRFS_RESERVE_NORMAL)
 		return BTRFS_MAX_EXTENT_SIZE;
-
-	ASSERT(0);
-	return BTRFS_MAX_EXTENT_SIZE;
+	else if (reserve_type == BTRFS_RESERVE_DEDUPE)
+		return btrfs_dedupe_blocksize(inode);
+	else
+		return BTRFS_MAX_EXTENT_SIZE;
 }
 
 int btrfs_delalloc_reserve_metadata(struct btrfs_inode *inode, u64 num_bytes,
@@ -5930,7 +5944,7 @@ int btrfs_delalloc_reserve_metadata(struct btrfs_inode *inode, u64 num_bytes,
 	enum btrfs_reserve_flush_enum flush = BTRFS_RESERVE_FLUSH_ALL;
 	int ret = 0;
 	bool delalloc_lock = true;
-	u64 max_extent_size = btrfs_max_extent_size(reserve_type);
+	u64 max_extent_size = btrfs_max_extent_size(inode, reserve_type);
 
 	/* If we are a free space inode we need to not flush since we will be in
 	 * the middle of a transaction commit.  We also don't need the delalloc
@@ -6033,7 +6047,7 @@ void btrfs_delalloc_release_extents(struct btrfs_inode *inode, u64 num_bytes,
 				enum btrfs_metadata_reserve_type reserve_type)
 {
 	struct btrfs_fs_info *fs_info = inode->root->fs_info;
-	u64 max_extent_size = btrfs_max_extent_size(reserve_type);
+	u64 max_extent_size = btrfs_max_extent_size(inode, reserve_type);
 	unsigned num_extents;
 
 	spin_lock(&inode->lock);
@@ -6934,6 +6948,11 @@ static int __btrfs_free_extent(struct btrfs_trans_handle *trans,
 		btrfs_release_path(path);
 
 		if (is_data) {
+			ret = btrfs_dedupe_del(info, bytenr);
+			if (ret < 0) {
+				btrfs_abort_transaction(trans, ret);
+				goto out;
+			}
 			ret = btrfs_del_csums(trans, info, bytenr, num_bytes);
 			if (ret) {
 				btrfs_abort_transaction(trans, ret);
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index d228f706ff3e..d1d580dc1731 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -590,7 +590,7 @@ int __clear_extent_bit(struct extent_io_tree *tree, u64 start, u64 end,
 	btrfs_debug_check_extent_io_range(tree, start, end);
 
 	if (bits & EXTENT_DELALLOC)
-		bits |= EXTENT_NORESERVE;
+		bits |= EXTENT_NORESERVE | EXTENT_DEDUPE;
 
 	if (delete)
 		bits |= ~EXTENT_CTLBITS;
@@ -1470,6 +1470,7 @@ static noinline u64 find_delalloc_range(struct extent_io_tree *tree,
 	u64 cur_start = *start;
 	u64 found = 0;
 	u64 total_bytes = 0;
+	unsigned int pre_state;
 
 	spin_lock(&tree->lock);
 
@@ -1487,7 +1488,8 @@ static noinline u64 find_delalloc_range(struct extent_io_tree *tree,
 	while (1) {
 		state = rb_entry(node, struct extent_state, rb_node);
 		if (found && (state->start != cur_start ||
-			      (state->state & EXTENT_BOUNDARY))) {
+			      (state->state & EXTENT_BOUNDARY) ||
+			      (state->state ^ pre_state) & EXTENT_DEDUPE)) {
 			goto out;
 		}
 		if (!(state->state & EXTENT_DELALLOC)) {
@@ -1503,6 +1505,7 @@ static noinline u64 find_delalloc_range(struct extent_io_tree *tree,
 		found++;
 		*end = state->end;
 		cur_start = state->end + 1;
+		pre_state = state->state;
 		node = rb_next(node);
 		total_bytes += state->end - state->start + 1;
 		if (total_bytes >= max_bytes)
diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
index 369daa5d4f73..5c802139dfb6 100644
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -25,6 +25,7 @@
 #define EXTENT_QGROUP_RESERVED	(1U << 16)
 #define EXTENT_CLEAR_DATA_RESV	(1U << 17)
 #define EXTENT_DELALLOC_NEW	(1U << 18)
+#define EXTENT_DEDUPE		(1U << 19)
 #define EXTENT_IOBITS		(EXTENT_LOCKED | EXTENT_WRITEBACK)
 #define EXTENT_DO_ACCOUNTING    (EXTENT_CLEAR_META_RESV | \
 				 EXTENT_CLEAR_DATA_RESV)
diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index d655c9356d9e..3b84da9d3c00 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -26,6 +26,7 @@
 #include "volumes.h"
 #include "qgroup.h"
 #include "compression.h"
+#include "dedupe.h"
 
 static struct kmem_cache *btrfs_inode_defrag_cachep;
 /*
@@ -1612,6 +1613,9 @@ static noinline ssize_t btrfs_buffered_write(struct kiocb *iocb,
 	if (!pages)
 		return -ENOMEM;
 
+	if (inode_need_dedupe(inode))
+		reserve_type = BTRFS_RESERVE_DEDUPE;
+
 	while (iov_iter_count(i) > 0) {
 		size_t offset = pos & (PAGE_SIZE - 1);
 		size_t sector_offset;
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index ff8af15c9039..b0e718076929 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -352,6 +352,7 @@ struct async_extent {
 	struct page **pages;
 	unsigned long nr_pages;
 	int compress_type;
+	struct btrfs_dedupe_hash *hash;
 	struct list_head list;
 };
 
@@ -364,6 +365,7 @@ struct async_cow {
 	unsigned int write_flags;
 	struct list_head extents;
 	struct btrfs_work work;
+	enum btrfs_metadata_reserve_type reserve_type;
 };
 
 static noinline int add_async_extent(struct async_cow *cow,
@@ -371,7 +373,8 @@ static noinline int add_async_extent(struct async_cow *cow,
 				     u64 compressed_size,
 				     struct page **pages,
 				     unsigned long nr_pages,
-				     int compress_type)
+				     int compress_type,
+				     struct btrfs_dedupe_hash *hash)
 {
 	struct async_extent *async_extent;
 
@@ -383,6 +386,7 @@ static noinline int add_async_extent(struct async_cow *cow,
 	async_extent->pages = pages;
 	async_extent->nr_pages = nr_pages;
 	async_extent->compress_type = compress_type;
+	async_extent->hash = hash;
 	list_add_tail(&async_extent->list, &cow->extents);
 	return 0;
 }
@@ -623,7 +627,7 @@ static noinline void compress_file_range(struct inode *inode,
 			 */
 			add_async_extent(async_cow, start, total_in,
 					total_compressed, pages, nr_pages,
-					compress_type);
+					compress_type, NULL);
 
 			if (start + total_in < end) {
 				start += total_in;
@@ -669,7 +673,7 @@ static noinline void compress_file_range(struct inode *inode,
 	if (redirty)
 		extent_range_redirty_for_io(inode, start, end);
 	add_async_extent(async_cow, start, end - start + 1, 0, NULL, 0,
-			 BTRFS_COMPRESS_NONE);
+			 BTRFS_COMPRESS_NONE, NULL);
 	*num_added += 1;
 
 	return;
@@ -698,6 +702,38 @@ static void free_async_extent_pages(struct async_extent *async_extent)
 	async_extent->pages = NULL;
 }
 
+static void end_dedupe_extent(struct inode *inode, u64 start,
+			      u32 len, unsigned long page_ops)
+{
+	int i;
+	unsigned int nr_pages = len / PAGE_SIZE;
+	struct page *page;
+
+	for (i = 0; i < nr_pages; i++) {
+		page = find_get_page(inode->i_mapping,
+				     start >> PAGE_SHIFT);
+		/* page should be already locked by caller */
+		if (WARN_ON(!page))
+			continue;
+
+		/* We need to do this by ourselves as we skipped IO */
+		if (page_ops & PAGE_CLEAR_DIRTY)
+			clear_page_dirty_for_io(page);
+		if (page_ops & PAGE_SET_WRITEBACK)
+			set_page_writeback(page);
+
+		end_extent_writepage(page, 0, start,
+				     start + PAGE_SIZE - 1);
+		if (page_ops & PAGE_END_WRITEBACK)
+			end_page_writeback(page);
+		if (page_ops & PAGE_UNLOCK)
+			unlock_page(page);
+
+		start += PAGE_SIZE;
+		put_page(page);
+	}
+}
+
 /*
  * phase two of compressed writeback.  This is the ordered portion
  * of the code, which only gets called in the order the work was
@@ -714,6 +750,7 @@ static noinline void submit_compressed_extents(struct inode *inode,
 	struct extent_map *em;
 	struct btrfs_root *root = BTRFS_I(inode)->root;
 	struct extent_io_tree *io_tree;
+	struct btrfs_dedupe_hash *hash;
 	int ret = 0;
 
 again:
@@ -723,6 +760,7 @@ static noinline void submit_compressed_extents(struct inode *inode,
 		list_del(&async_extent->list);
 
 		io_tree = &BTRFS_I(inode)->io_tree;
+		hash = async_extent->hash;
 
 retry:
 		/* did the compression code fall back to uncompressed IO? */
@@ -742,7 +780,7 @@ static noinline void submit_compressed_extents(struct inode *inode,
 					     async_extent->start +
 					     async_extent->ram_size - 1,
 					     &page_started, &nr_written, 0,
-					     NULL);
+					     hash);
 
 			/* JDM XXX */
 
@@ -752,14 +790,26 @@ static noinline void submit_compressed_extents(struct inode *inode,
 			 * and IO for us.  Otherwise, we need to submit
 			 * all those pages down to the drive.
 			 */
-			if (!page_started && !ret)
-				extent_write_locked_range(inode,
-						  async_extent->start,
-						  async_extent->start +
-						  async_extent->ram_size - 1,
-						  WB_SYNC_ALL);
-			else if (ret)
+			if (!page_started && !ret) {
+				/* Skip IO for dedupe async_extent */
+				if (btrfs_dedupe_hash_hit(hash))
+					end_dedupe_extent(inode,
+						async_extent->start,
+						async_extent->ram_size,
+						PAGE_CLEAR_DIRTY |
+						PAGE_SET_WRITEBACK |
+						PAGE_END_WRITEBACK |
+						PAGE_UNLOCK);
+				else
+					extent_write_locked_range(inode,
+						async_extent->start,
+						async_extent->start +
+						async_extent->ram_size - 1,
+						WB_SYNC_ALL);
+			} else if (ret) {
 				unlock_page(async_cow->locked_page);
+			}
+			kfree(hash);
 			kfree(async_extent);
 			cond_resched();
 			continue;
@@ -863,6 +913,7 @@ static noinline void submit_compressed_extents(struct inode *inode,
 			free_async_extent_pages(async_extent);
 		}
 		alloc_hint = ins.objectid + ins.offset;
+		kfree(hash);
 		kfree(async_extent);
 		cond_resched();
 	}
@@ -883,6 +934,7 @@ static noinline void submit_compressed_extents(struct inode *inode,
 				     PAGE_SET_WRITEBACK | PAGE_END_WRITEBACK |
 				     PAGE_SET_ERROR);
 	free_async_extent_pages(async_extent);
+	kfree(hash);
 	kfree(async_extent);
 	goto again;
 }
@@ -997,13 +1049,19 @@ static noinline int cow_file_range(struct inode *inode,
 
 	while (num_bytes > 0) {
 		cur_alloc_size = num_bytes;
-		ret = btrfs_reserve_extent(root, cur_alloc_size, cur_alloc_size,
+		if (btrfs_dedupe_hash_hit(hash)) {
+			ins.objectid = hash->bytenr;
+			ins.offset = hash->num_bytes;
+		} else {
+			ret = btrfs_reserve_extent(root, cur_alloc_size,
+					   cur_alloc_size,
 					   fs_info->sectorsize, 0, alloc_hint,
 					   &ins, 1, 1);
-		if (ret < 0)
-			goto out_unlock;
+			if (ret < 0)
+				goto out_unlock;
+			extent_reserved = true;
+		}
 		cur_alloc_size = ins.offset;
-		extent_reserved = true;
 
 		ram_size = ins.offset;
 		em = create_io_em(inode, start, ins.offset, /* len */
@@ -1020,8 +1078,9 @@ static noinline int cow_file_range(struct inode *inode,
 		}
 		free_extent_map(em);
 
-		ret = btrfs_add_ordered_extent(inode, start, ins.objectid,
-					       ram_size, cur_alloc_size, 0);
+		ret = btrfs_add_ordered_extent_dedupe(inode, start,
+				ins.objectid, cur_alloc_size, ins.offset,
+				0, hash);
 		if (ret)
 			goto out_drop_extent_cache;
 
@@ -1045,7 +1104,14 @@ static noinline int cow_file_range(struct inode *inode,
 						start + ram_size - 1, 0);
 		}
 
-		btrfs_dec_block_group_reservations(fs_info, ins.objectid);
+		/*
+		 * Hash hit didn't allocate extent, no need to dec bg
+		 * reservation.
+		 * Or we will underflow reservations and block balance.
+		 */
+		if (!btrfs_dedupe_hash_hit(hash))
+			btrfs_dec_block_group_reservations(fs_info,
+							   ins.objectid);
 
 		/* we're not doing compressed IO, don't unlock the first
 		 * page (which the caller expects to stay locked), don't
@@ -1119,6 +1185,79 @@ static noinline int cow_file_range(struct inode *inode,
 	goto out;
 }
 
+static int hash_file_ranges(struct inode *inode, u64 start, u64 end,
+			    struct async_cow *async_cow, int *num_added)
+{
+	struct btrfs_root *root = BTRFS_I(inode)->root;
+	struct btrfs_fs_info *fs_info = root->fs_info;
+	struct btrfs_dedupe_info *dedupe_info = fs_info->dedupe_info;
+	struct page *locked_page = async_cow->locked_page;
+	u16 hash_algo;
+	u64 dedupe_bs;
+	u64 cur_offset = start;
+	int ret = 0;
+
+	/* If dedupe is not enabled, don't split extent into dedupe_bs */
+	if (fs_info->dedupe_enabled && dedupe_info) {
+		dedupe_bs = dedupe_info->blocksize;
+		hash_algo = dedupe_info->hash_algo;
+	} else {
+		dedupe_bs = SZ_128M;
+		/* Just dummy, to avoid access NULL pointer */
+		hash_algo = BTRFS_DEDUPE_HASH_SHA256;
+	}
+
+	while (cur_offset < end) {
+		struct btrfs_dedupe_hash *hash = NULL;
+		u64 len;
+
+		len = min(end + 1 - cur_offset, dedupe_bs);
+		if (len < dedupe_bs)
+			goto next;
+
+		hash = btrfs_dedupe_alloc_hash(hash_algo);
+		if (!hash) {
+			ret = -ENOMEM;
+			goto out;
+		}
+		ret = btrfs_dedupe_calc_hash(fs_info, inode, cur_offset, hash);
+		if (ret < 0) {
+			kfree(hash);
+			goto out;
+		}
+
+		ret = btrfs_dedupe_search(fs_info, inode, cur_offset, hash);
+		if (ret < 0) {
+			kfree(hash);
+			goto out;
+		}
+		ret = 0;
+
+next:
+		/* Redirty the locked page if it corresponds to our extent */
+		if (page_offset(locked_page) >= start &&
+		    page_offset(locked_page) <= end)
+			__set_page_dirty_nobuffers(locked_page);
+
+		add_async_extent(async_cow, cur_offset, len, 0, NULL, 0,
+				 BTRFS_COMPRESS_NONE, hash);
+		cur_offset += len;
+		(*num_added)++;
+	}
+out:
+	/*
+	 * Caller won't unlock pages, so if error happens, we must unlock
+	 * pages by ourselves.
+	 */
+	if (ret)
+		extent_clear_unlock_delalloc(inode, cur_offset,
+			end, end, NULL, EXTENT_LOCKED | EXTENT_DO_ACCOUNTING |
+			EXTENT_DELALLOC | EXTENT_DEFRAG, PAGE_UNLOCK |
+			PAGE_CLEAR_DIRTY | PAGE_SET_WRITEBACK |
+			PAGE_END_WRITEBACK | PAGE_SET_ERROR);
+	return ret;
+}
+
 /*
  * work queue call back to started compression on a file and pages
  */
@@ -1126,11 +1265,17 @@ static noinline void async_cow_start(struct btrfs_work *work)
 {
 	struct async_cow *async_cow;
 	int num_added = 0;
+	int ret = 0;
 	async_cow = container_of(work, struct async_cow, work);
 
-	compress_file_range(async_cow->inode, async_cow->locked_page,
-			    async_cow->start, async_cow->end, async_cow,
-			    &num_added);
+	if (async_cow->reserve_type == BTRFS_RESERVE_DEDUPE)
+		ret = hash_file_ranges(async_cow->inode, async_cow->start,
+				       async_cow->end, async_cow, &num_added);
+	else
+		compress_file_range(async_cow->inode, async_cow->locked_page,
+				    async_cow->start, async_cow->end, async_cow,
+				    &num_added);
+
 	if (num_added == 0) {
 		btrfs_add_delayed_iput(async_cow->inode);
 		async_cow->inode = NULL;
@@ -1175,11 +1320,13 @@ static noinline void async_cow_free(struct btrfs_work *work)
 static int cow_file_range_async(struct inode *inode, struct page *locked_page,
 				u64 start, u64 end, int *page_started,
 				unsigned long *nr_written,
-				unsigned int write_flags)
+				unsigned int write_flags,
+				enum btrfs_metadata_reserve_type reserve_type)
 {
 	struct btrfs_fs_info *fs_info = btrfs_sb(inode->i_sb);
 	struct async_cow *async_cow;
 	struct btrfs_root *root = BTRFS_I(inode)->root;
+	struct btrfs_dedupe_info *dedupe_info = fs_info->dedupe_info;
 	unsigned long nr_pages;
 	u64 cur_end;
 
@@ -1193,11 +1340,16 @@ static int cow_file_range_async(struct inode *inode, struct page *locked_page,
 		async_cow->locked_page = locked_page;
 		async_cow->start = start;
 		async_cow->write_flags = write_flags;
+		async_cow->reserve_type = reserve_type;
 
 		if (BTRFS_I(inode)->flags & BTRFS_INODE_NOCOMPRESS &&
 		    !btrfs_test_opt(fs_info, FORCE_COMPRESS))
 			cur_end = end;
-		else
+		else if (reserve_type == BTRFS_RESERVE_DEDUPE) {
+			u64 len = max_t(u64, SZ_512K, dedupe_info->blocksize);
+
+			cur_end = min(end, start + len - 1);
+		} else
 			cur_end = min(end, start + SZ_512K - 1);
 
 		async_cow->end = cur_end;
@@ -1588,6 +1740,14 @@ static int run_delalloc_range(void *private_data, struct page *locked_page,
 	int ret;
 	int force_cow = need_force_cow(inode, start, end);
 	unsigned int write_flags = wbc_to_write_flags(wbc);
+	struct extent_io_tree *io_tree = &BTRFS_I(inode)->io_tree;
+	enum btrfs_metadata_reserve_type reserve_type = BTRFS_RESERVE_NORMAL;
+	int need_dedupe;
+
+	need_dedupe = test_range_bit(io_tree, start, end,
+				     EXTENT_DEDUPE, 1, NULL);
+	if (need_dedupe)
+		reserve_type = BTRFS_RESERVE_DEDUPE;
 
 	if (BTRFS_I(inode)->flags & BTRFS_INODE_NODATACOW && !force_cow) {
 		ret = run_delalloc_nocow(inode, locked_page, start, end,
@@ -1595,7 +1755,7 @@ static int run_delalloc_range(void *private_data, struct page *locked_page,
 	} else if (BTRFS_I(inode)->flags & BTRFS_INODE_PREALLOC && !force_cow) {
 		ret = run_delalloc_nocow(inode, locked_page, start, end,
 					 page_started, 0, nr_written);
-	} else if (!inode_need_compress(inode, start, end)) {
+	} else if (!inode_need_compress(inode, start, end) && !need_dedupe) {
 		ret = cow_file_range(inode, locked_page, start, end, end,
 				      page_started, nr_written, 1, NULL);
 	} else {
@@ -1603,7 +1763,7 @@ static int run_delalloc_range(void *private_data, struct page *locked_page,
 			&BTRFS_I(inode)->runtime_flags);
 		ret = cow_file_range_async(inode, locked_page, start, end,
 					   page_started, nr_written,
-					   write_flags);
+					   write_flags, reserve_type);
 	}
 	if (ret)
 		btrfs_cleanup_ordered_extents(inode, start, end - start + 1);
@@ -1622,7 +1782,9 @@ static void btrfs_split_extent_hook(void *private_data,
 	if (!(orig->state & EXTENT_DELALLOC))
 		return;
 
-	max_extent_size = btrfs_max_extent_size(reserve_type);
+	if (orig->state & EXTENT_DEDUPE)
+		reserve_type = BTRFS_RESERVE_DEDUPE;
+	max_extent_size = btrfs_max_extent_size(BTRFS_I(inode), reserve_type);
 
 	size = orig->end - orig->start + 1;
 	if (size > max_extent_size) {
@@ -1666,7 +1828,9 @@ static void btrfs_merge_extent_hook(void *private_data,
 	if (!(other->state & EXTENT_DELALLOC))
 		return;
 
-	max_extent_size = btrfs_max_extent_size(reserve_type);
+	if (other->state & EXTENT_DEDUPE)
+		reserve_type = BTRFS_RESERVE_DEDUPE;
+	max_extent_size = btrfs_max_extent_size(BTRFS_I(inode), reserve_type);
 
 	if (new->start > other->start)
 		new_size = new->end - other->start + 1;
@@ -1791,7 +1955,10 @@ static void btrfs_set_bit_hook(void *private_data,
 							BTRFS_RESERVE_NORMAL;
 		bool do_list = !btrfs_is_free_space_inode(BTRFS_I(inode));
 
-		max_extent_size = btrfs_max_extent_size(reserve_type);
+		if (*bits & EXTENT_DEDUPE)
+			reserve_type = BTRFS_RESERVE_DEDUPE;
+		max_extent_size = btrfs_max_extent_size(BTRFS_I(inode),
+							reserve_type);
 		num_extents = count_max_extents(len, max_extent_size);
 
 		spin_lock(&BTRFS_I(inode)->lock);
@@ -1852,7 +2019,9 @@ static void btrfs_clear_bit_hook(void *private_data,
 		struct btrfs_root *root = inode->root;
 		bool do_list = !btrfs_is_free_space_inode(inode);
 
-		max_extent_size = btrfs_max_extent_size(reserve_type);
+		if (state->state & EXTENT_DEDUPE)
+			reserve_type = BTRFS_RESERVE_DEDUPE;
+		max_extent_size = btrfs_max_extent_size(inode, reserve_type);
 		num_extents = count_max_extents(len, max_extent_size);
 
 		spin_lock(&inode->lock);
@@ -2078,9 +2247,17 @@ int btrfs_set_extent_delalloc(struct inode *inode, u64 start, u64 end,
 			      struct extent_state **cached_state,
 			      enum btrfs_metadata_reserve_type reserve_type)
 {
+	unsigned int bits;
+
+	if (reserve_type == BTRFS_RESERVE_DEDUPE)
+		bits = EXTENT_DELALLOC | EXTENT_DEDUPE | EXTENT_UPTODATE |
+			extra_bits;
+	else
+		bits = EXTENT_DELALLOC | EXTENT_UPTODATE | extra_bits;
+
 	WARN_ON((end & (PAGE_SIZE - 1)) == 0);
 	return set_extent_delalloc(&BTRFS_I(inode)->io_tree, start, end,
-				   extra_bits, cached_state);
+				   bits, cached_state);
 }
 
 
@@ -2143,6 +2320,9 @@ static void btrfs_writepage_fixup_worker(struct btrfs_work *work)
 		goto again;
 	}
 
+	if (inode_need_dedupe(inode))
+		reserve_type = BTRFS_RESERVE_DEDUPE;
+
 	ret = btrfs_delalloc_reserve_space(inode, &data_reserved, page_start,
 					   PAGE_SIZE, reserve_type);
 	if (ret) {
@@ -2217,7 +2397,8 @@ static int insert_reserved_file_extent(struct btrfs_trans_handle *trans,
 				       u64 disk_bytenr, u64 disk_num_bytes,
 				       u64 num_bytes, u64 ram_bytes,
 				       u8 compression, u8 encryption,
-				       u16 other_encoding, int extent_type)
+				       u16 other_encoding, int extent_type,
+				       struct btrfs_dedupe_hash *hash)
 {
 	struct btrfs_root *root = BTRFS_I(inode)->root;
 	struct btrfs_file_extent_item *fi;
@@ -2281,17 +2462,43 @@ static int insert_reserved_file_extent(struct btrfs_trans_handle *trans,
 	ins.offset = disk_num_bytes;
 	ins.type = BTRFS_EXTENT_ITEM_KEY;
 
-	/*
-	 * Release the reserved range from inode dirty range map, as it is
-	 * already moved into delayed_ref_head
-	 */
-	ret = btrfs_qgroup_release_data(inode, file_pos, ram_bytes);
-	if (ret < 0)
-		goto out;
-	qg_released = ret;
-	ret = btrfs_alloc_reserved_file_extent(trans, root,
-					       btrfs_ino(BTRFS_I(inode)),
-					       file_pos, qg_released, &ins);
+	if (btrfs_dedupe_hash_hit(hash)) {
+		/*
+		 * Hash hit won't create a new data extent, so its reserved
+		 * space won't be freed by new delayed_ref_head.
+		 * Manually free it.
+		 */
+		btrfs_free_reserved_data_space(inode, NULL, file_pos,
+					       ram_bytes);
+	} else {
+		/*
+		 * Hash miss or none-dedupe write, will create a new data
+		 * extent, we need to release the qgroup reserved data space.
+		 */
+		ret = btrfs_qgroup_release_data(inode, file_pos, ram_bytes);
+		if (ret < 0)
+			goto out;
+		qg_released = ret;
+		ret = btrfs_alloc_reserved_file_extent(trans, root,
+				btrfs_ino(BTRFS_I(inode)), file_pos,
+				qg_released, &ins);
+		if (ret < 0)
+			goto out;
+	}
+
+	/* Add missed hash into dedupe tree */
+	if (hash && hash->bytenr == 0) {
+		hash->bytenr = ins.objectid;
+		hash->num_bytes = ins.offset;
+
+		/*
+		 * Here we ignore dedupe_add error, as even it failed,
+		 * it won't corrupt the filesystem. It will only only slightly
+		 * reduce dedup rate
+		 */
+		btrfs_dedupe_add(root->fs_info, hash);
+	}
+
 out:
 	btrfs_free_path(path);
 
@@ -2976,6 +3183,7 @@ static int btrfs_finish_ordered_io(struct btrfs_ordered_extent *ordered_extent)
 	bool clear_new_delalloc_bytes = false;
 	bool clear_reserved_extent = true;
 	enum btrfs_metadata_reserve_type reserve_type = BTRFS_RESERVE_NORMAL;
+	int hash_hit = btrfs_dedupe_hash_hit(ordered_extent->hash);
 
 	if (!test_bit(BTRFS_ORDERED_NOCOW, &ordered_extent->flags) &&
 	    !test_bit(BTRFS_ORDERED_PREALLOC, &ordered_extent->flags) &&
@@ -3062,6 +3270,9 @@ static int btrfs_finish_ordered_io(struct btrfs_ordered_extent *ordered_extent)
 
 	if (test_bit(BTRFS_ORDERED_COMPRESSED, &ordered_extent->flags))
 		compress_type = ordered_extent->compress_type;
+	else if (ordered_extent->hash)
+		reserve_type = BTRFS_RESERVE_DEDUPE;
+
 	if (test_bit(BTRFS_ORDERED_PREALLOC, &ordered_extent->flags)) {
 		BUG_ON(compress_type);
 		btrfs_qgroup_free_data(inode, NULL, ordered_extent->file_offset,
@@ -3078,13 +3289,16 @@ static int btrfs_finish_ordered_io(struct btrfs_ordered_extent *ordered_extent)
 						ordered_extent->disk_len,
 						logical_len, logical_len,
 						compress_type, 0, 0,
-						BTRFS_FILE_EXTENT_REG);
-		if (!ret) {
+						BTRFS_FILE_EXTENT_REG,
+						ordered_extent->hash);
+		if (!ret)
 			clear_reserved_extent = false;
+
+		/* Hash hit case doesn't reserve delalloc bytes */
+		if (!ret && !hash_hit)
 			btrfs_release_delalloc_bytes(fs_info,
 						     ordered_extent->start,
 						     ordered_extent->disk_len);
-		}
 	}
 	unpin_extent_cache(&BTRFS_I(inode)->extent_tree,
 			   ordered_extent->file_offset, ordered_extent->len,
@@ -3149,9 +3363,12 @@ static int btrfs_finish_ordered_io(struct btrfs_ordered_extent *ordered_extent)
 		 * If we made it past insert_reserved_file_extent before we
 		 * errored out then we don't need to do this as the accounting
 		 * has already been done.
+		 *
+		 * For hash hit case, never free that extent, as it's being used
+		 * by others.
 		 */
 		if ((ret || !logical_len) &&
-		    clear_reserved_extent &&
+		    clear_reserved_extent && !hash_hit &&
 		    !test_bit(BTRFS_ORDERED_NOCOW, &ordered_extent->flags) &&
 		    !test_bit(BTRFS_ORDERED_PREALLOC, &ordered_extent->flags))
 			btrfs_free_reserved_extent(fs_info,
@@ -3159,7 +3376,6 @@ static int btrfs_finish_ordered_io(struct btrfs_ordered_extent *ordered_extent)
 						   ordered_extent->disk_len, 1);
 	}
 
-
 	/*
 	 * This needs to be done to make sure anybody waiting knows we are done
 	 * updating everything for this ordered extent.
@@ -4875,6 +5091,9 @@ int btrfs_truncate_block(struct inode *inode, loff_t from, loff_t len,
 	u64 block_end;
 	enum btrfs_metadata_reserve_type reserve_type = BTRFS_RESERVE_NORMAL;
 
+	if (inode_need_dedupe(inode))
+		reserve_type = BTRFS_RESERVE_DEDUPE;
+
 	if (IS_ALIGNED(offset, blocksize) &&
 	    (!len || IS_ALIGNED(len, blocksize)))
 		goto out;
@@ -8859,6 +9078,9 @@ vm_fault_t btrfs_page_mkwrite(struct vm_fault *vmf)
 	page_end = page_start + PAGE_SIZE - 1;
 	end = page_end;
 
+	if (inode_need_dedupe(inode))
+		reserve_type = BTRFS_RESERVE_DEDUPE;
+
 	/*
 	 * Reserving delalloc space after obtaining the page lock can lead to
 	 * deadlock. For example, if a dirty page is locked by this function
@@ -10301,7 +10523,8 @@ static int __btrfs_prealloc_file_range(struct inode *inode, int mode,
 						  cur_offset, ins.objectid,
 						  ins.offset, ins.offset,
 						  ins.offset, 0, 0, 0,
-						  BTRFS_FILE_EXTENT_PREALLOC);
+						  BTRFS_FILE_EXTENT_PREALLOC,
+						  NULL);
 		if (ret) {
 			btrfs_free_reserved_extent(fs_info, ins.objectid,
 						   ins.offset, 0);
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 93c75f6323f6..4b84048e7e9e 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -43,6 +43,7 @@
 #include "qgroup.h"
 #include "tree-log.h"
 #include "compression.h"
+#include "dedupe.h"
 
 #ifdef CONFIG_64BIT
 /* If we have a 32-bit userspace and 64-bit kernel, then the UAPI
diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index 11476ad7387a..b7c304c6e741 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -20,6 +20,7 @@
 #include "inode-map.h"
 #include "qgroup.h"
 #include "print-tree.h"
+#include "dedupe.h"
 
 /*
  * backref_node, mapping_node and tree_block start with this
@@ -3151,6 +3152,9 @@ static int relocate_file_extent_cluster(struct inode *inode,
 	if (!cluster->nr)
 		return 0;
 
+	if (inode_need_dedupe(inode))
+		reserve_type = BTRFS_RESERVE_DEDUPE;
+
 	ra = kzalloc(sizeof(*ra), GFP_NOFS);
 	if (!ra)
 		return -ENOMEM;
@@ -4023,6 +4027,20 @@ static noinline_for_stack int relocate_block_group(struct reloc_control *rc)
 				rc->search_start = key.objectid;
 			}
 		}
+		/*
+		 * This data extent will be replaced, but normal dedupe_del()
+		 * will only happen at run_delayed_ref() time, which is too
+		 * late, so delete dedupe_hash early to prevent its ref get
+		 * increased during relocation
+		 */
+		if (rc->stage == MOVE_DATA_EXTENTS &&
+		    (flags & BTRFS_EXTENT_FLAG_DATA)) {
+			ret = btrfs_dedupe_del(fs_info, key.objectid);
+			if (ret < 0) {
+				err = ret;
+				break;
+			}
+		}
 
 		btrfs_end_transaction_throttle(trans);
 		btrfs_btree_balance_dirty(fs_info);
-- 
2.19.1



