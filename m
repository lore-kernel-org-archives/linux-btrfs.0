Return-Path: <SRS0=BJi/=NR=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49303C46464
	for <linux-btrfs@archiver.kernel.org>; Tue,  6 Nov 2018 06:41:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F152020862
	for <linux-btrfs@archiver.kernel.org>; Tue,  6 Nov 2018 06:41:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org F152020862
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=cn.fujitsu.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387609AbeKFQF0 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 6 Nov 2018 11:05:26 -0500
Received: from mail.cn.fujitsu.com ([183.91.158.132]:44988 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2387579AbeKFQFZ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 6 Nov 2018 11:05:25 -0500
X-IronPort-AV: E=Sophos;i="5.43,368,1503331200"; 
   d="scan'208";a="47417671"
Received: from unknown (HELO cn.fujitsu.com) ([10.167.33.5])
  by heian.cn.fujitsu.com with ESMTP; 06 Nov 2018 14:41:38 +0800
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (unknown [10.167.33.80])
        by cn.fujitsu.com (Postfix) with ESMTP id B463F4B714AA;
        Tue,  6 Nov 2018 14:41:35 +0800 (CST)
Received: from fnst.lan (10.167.226.155) by G08CNEXCHPEKD01.g08.fujitsu.local
 (10.167.33.89) with Microsoft SMTP Server (TLS) id 14.3.408.0; Tue, 6 Nov
 2018 14:41:39 +0800
From:   Lu Fengqi <lufq.fnst@cn.fujitsu.com>
To:     <linux-btrfs@vger.kernel.org>
CC:     Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>,
        Qu Wenruo <quwenruo@cn.fujitsu.com>
Subject: [PATCH v15.1 09/13] btrfs: introduce type based delalloc metadata reserve
Date:   Tue, 6 Nov 2018 14:41:18 +0800
Message-ID: <20181106064122.6154-10-lufq.fnst@cn.fujitsu.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20181106064122.6154-1-lufq.fnst@cn.fujitsu.com>
References: <20181106064122.6154-1-lufq.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.167.226.155]
X-yoursite-MailScanner-ID: B463F4B714AA.AC81E
X-yoursite-MailScanner: Found to be clean
X-yoursite-MailScanner-From: lufq.fnst@cn.fujitsu.com
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>

Introduce type based metadata reserve parameter for delalloc space
reservation/freeing function.

The problem we are going to solve is, btrfs use different max extent
size for different mount options.

For de-duplication, the max extent size can be set by the dedupe ioctl,
while for normal write it's 128M.
And furthermore, split/merge extent hook highly depends that max extent
size.

Such situation contributes to quite a lot of false ENOSPC.

So this patch introduces the facility to help solve these false ENOSPC
related to different max extent size.

Currently, only normal 128M extent size is supported. More types will
follow soon.

Signed-off-by: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
Signed-off-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
---
 fs/btrfs/ctree.h             |  43 ++++++++++---
 fs/btrfs/extent-tree.c       |  48 ++++++++++++---
 fs/btrfs/file.c              |  30 +++++----
 fs/btrfs/free-space-cache.c  |   6 +-
 fs/btrfs/inode-map.c         |   9 ++-
 fs/btrfs/inode.c             | 115 +++++++++++++++++++++++++----------
 fs/btrfs/ioctl.c             |  23 +++----
 fs/btrfs/ordered-data.c      |   6 +-
 fs/btrfs/ordered-data.h      |   3 +-
 fs/btrfs/relocation.c        |  22 ++++---
 fs/btrfs/tests/inode-tests.c |  15 +++--
 11 files changed, 223 insertions(+), 97 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 910050d904ef..b119a19cbeaf 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -92,11 +92,24 @@ static const int btrfs_csum_sizes[] = { 4 };
 /*
  * Count how many BTRFS_MAX_EXTENT_SIZE cover the @size
  */
-static inline u32 count_max_extents(u64 size)
+static inline u32 count_max_extents(u64 size, u64 max_extent_size)
 {
-	return div_u64(size + BTRFS_MAX_EXTENT_SIZE - 1, BTRFS_MAX_EXTENT_SIZE);
+	return div_u64(size + max_extent_size - 1, max_extent_size);
 }
 
+/*
+ * Type based metadata reserve type
+ * This affects how btrfs reserve metadata space for buffered write.
+ *
+ * This is caused by the different max extent size for normal COW
+ * and further in-band dedupe
+ */
+enum btrfs_metadata_reserve_type {
+	BTRFS_RESERVE_NORMAL,
+};
+
+u64 btrfs_max_extent_size(enum btrfs_metadata_reserve_type reserve_type);
+
 struct btrfs_mapping_tree {
 	struct extent_map_tree map_tree;
 };
@@ -2732,8 +2745,9 @@ int btrfs_check_data_free_space(struct inode *inode,
 void btrfs_free_reserved_data_space(struct inode *inode,
 			struct extent_changeset *reserved, u64 start, u64 len);
 void btrfs_delalloc_release_space(struct inode *inode,
-				  struct extent_changeset *reserved,
-				  u64 start, u64 len, bool qgroup_free);
+				struct extent_changeset *reserved,
+				u64 start, u64 len, bool qgroup_free,
+				enum btrfs_metadata_reserve_type reserve_type);
 void btrfs_free_reserved_data_space_noquota(struct inode *inode, u64 start,
 					    u64 len);
 void btrfs_trans_release_chunk_metadata(struct btrfs_trans_handle *trans);
@@ -2743,13 +2757,17 @@ int btrfs_subvolume_reserve_metadata(struct btrfs_root *root,
 void btrfs_subvolume_release_metadata(struct btrfs_fs_info *fs_info,
 				      struct btrfs_block_rsv *rsv);
 void btrfs_delalloc_release_extents(struct btrfs_inode *inode, u64 num_bytes,
-				    bool qgroup_free);
+				bool qgroup_free,
+				enum btrfs_metadata_reserve_type reserve_type);
 
-int btrfs_delalloc_reserve_metadata(struct btrfs_inode *inode, u64 num_bytes);
+int btrfs_delalloc_reserve_metadata(struct btrfs_inode *inode, u64 num_bytes,
+				enum btrfs_metadata_reserve_type reserve_type);
 void btrfs_delalloc_release_metadata(struct btrfs_inode *inode, u64 num_bytes,
-				     bool qgroup_free);
+				bool qgroup_free,
+				enum btrfs_metadata_reserve_type reserve_type);
 int btrfs_delalloc_reserve_space(struct inode *inode,
-			struct extent_changeset **reserved, u64 start, u64 len);
+			struct extent_changeset **reserved, u64 start, u64 len,
+			enum btrfs_metadata_reserve_type reserve_type);
 void btrfs_init_block_rsv(struct btrfs_block_rsv *rsv, unsigned short type);
 struct btrfs_block_rsv *btrfs_alloc_block_rsv(struct btrfs_fs_info *fs_info,
 					      unsigned short type);
@@ -3152,7 +3170,11 @@ int btrfs_start_delalloc_inodes(struct btrfs_root *root);
 int btrfs_start_delalloc_roots(struct btrfs_fs_info *fs_info, int nr);
 int btrfs_set_extent_delalloc(struct inode *inode, u64 start, u64 end,
 			      unsigned int extra_bits,
-			      struct extent_state **cached_state, int dedupe);
+			      struct extent_state **cached_state,
+			      enum btrfs_metadata_reserve_type reserve_type);
+int btrfs_set_extent_defrag(struct inode *inode, u64 start, u64 end,
+			    struct extent_state **cached_state,
+			    enum btrfs_metadata_reserve_type reserve_type);
 int btrfs_create_subvol_root(struct btrfs_trans_handle *trans,
 			     struct btrfs_root *new_root,
 			     struct btrfs_root *parent_root,
@@ -3235,7 +3257,8 @@ int btrfs_mark_extent_written(struct btrfs_trans_handle *trans,
 int btrfs_release_file(struct inode *inode, struct file *file);
 int btrfs_dirty_pages(struct inode *inode, struct page **pages,
 		      size_t num_pages, loff_t pos, size_t write_bytes,
-		      struct extent_state **cached);
+		      struct extent_state **cached,
+		      enum btrfs_metadata_reserve_type reserve_type);
 int btrfs_fdatawrite_range(struct inode *inode, loff_t start, loff_t end);
 loff_t btrfs_remap_file_range(struct file *file_in, loff_t pos_in,
 			      struct file *file_out, loff_t pos_out,
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index a1febf155747..2c8992b919ae 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -5913,13 +5913,24 @@ static void btrfs_calculate_inode_block_rsv_size(struct btrfs_fs_info *fs_info,
 	spin_unlock(&block_rsv->lock);
 }
 
-int btrfs_delalloc_reserve_metadata(struct btrfs_inode *inode, u64 num_bytes)
+u64 btrfs_max_extent_size(enum btrfs_metadata_reserve_type reserve_type)
+{
+	if (reserve_type == BTRFS_RESERVE_NORMAL)
+		return BTRFS_MAX_EXTENT_SIZE;
+
+	ASSERT(0);
+	return BTRFS_MAX_EXTENT_SIZE;
+}
+
+int btrfs_delalloc_reserve_metadata(struct btrfs_inode *inode, u64 num_bytes,
+			enum btrfs_metadata_reserve_type reserve_type)
 {
 	struct btrfs_fs_info *fs_info = inode->root->fs_info;
 	unsigned nr_extents;
 	enum btrfs_reserve_flush_enum flush = BTRFS_RESERVE_FLUSH_ALL;
 	int ret = 0;
 	bool delalloc_lock = true;
+	u64 max_extent_size = btrfs_max_extent_size(reserve_type);
 
 	/* If we are a free space inode we need to not flush since we will be in
 	 * the middle of a transaction commit.  We also don't need the delalloc
@@ -5947,7 +5958,7 @@ int btrfs_delalloc_reserve_metadata(struct btrfs_inode *inode, u64 num_bytes)
 
 	/* Add our new extents and calculate the new rsv size. */
 	spin_lock(&inode->lock);
-	nr_extents = count_max_extents(num_bytes);
+	nr_extents = count_max_extents(num_bytes, max_extent_size);
 	btrfs_mod_outstanding_extents(inode, nr_extents);
 	inode->csum_bytes += num_bytes;
 	btrfs_calculate_inode_block_rsv_size(fs_info, inode);
@@ -5963,7 +5974,7 @@ int btrfs_delalloc_reserve_metadata(struct btrfs_inode *inode, u64 num_bytes)
 
 out_fail:
 	spin_lock(&inode->lock);
-	nr_extents = count_max_extents(num_bytes);
+	nr_extents = count_max_extents(num_bytes, max_extent_size);
 	btrfs_mod_outstanding_extents(inode, -nr_extents);
 	inode->csum_bytes -= num_bytes;
 	btrfs_calculate_inode_block_rsv_size(fs_info, inode);
@@ -5980,13 +5991,16 @@ int btrfs_delalloc_reserve_metadata(struct btrfs_inode *inode, u64 num_bytes)
  * @inode: the inode to release the reservation for.
  * @num_bytes: the number of bytes we are releasing.
  * @qgroup_free: free qgroup reservation or convert it to per-trans reservation
+ * @reserve_type: the type when we reserve delalloc space for this range.
+ *                must be the same passed to btrfs_delalloc_reserve_metadata()
  *
  * This will release the metadata reservation for an inode.  This can be called
  * once we complete IO for a given set of bytes to release their metadata
  * reservations, or on error for the same reason.
  */
 void btrfs_delalloc_release_metadata(struct btrfs_inode *inode, u64 num_bytes,
-				     bool qgroup_free)
+				bool qgroup_free,
+				enum btrfs_metadata_reserve_type reserve_type)
 {
 	struct btrfs_fs_info *fs_info = inode->root->fs_info;
 
@@ -6015,13 +6029,15 @@ void btrfs_delalloc_release_metadata(struct btrfs_inode *inode, u64 num_bytes,
  * with btrfs_delalloc_reserve_metadata.
  */
 void btrfs_delalloc_release_extents(struct btrfs_inode *inode, u64 num_bytes,
-				    bool qgroup_free)
+				bool qgroup_free,
+				enum btrfs_metadata_reserve_type reserve_type)
 {
 	struct btrfs_fs_info *fs_info = inode->root->fs_info;
+	u64 max_extent_size = btrfs_max_extent_size(reserve_type);
 	unsigned num_extents;
 
 	spin_lock(&inode->lock);
-	num_extents = count_max_extents(num_bytes);
+	num_extents = count_max_extents(num_bytes, max_extent_size);
 	btrfs_mod_outstanding_extents(inode, -num_extents);
 	btrfs_calculate_inode_block_rsv_size(fs_info, inode);
 	spin_unlock(&inode->lock);
@@ -6040,6 +6056,8 @@ void btrfs_delalloc_release_extents(struct btrfs_inode *inode, u64 num_bytes,
  * @len: how long the range we are writing to
  * @reserved: mandatory parameter, record actually reserved qgroup ranges of
  * 	      current reservation.
+ * @reserve_type: the type of write we're reserving for.
+ *		  determine the max extent size.
  *
  * This will do the following things
  *
@@ -6058,14 +6076,16 @@ void btrfs_delalloc_release_extents(struct btrfs_inode *inode, u64 num_bytes,
  * Return <0 for error(-ENOSPC or -EQUOT)
  */
 int btrfs_delalloc_reserve_space(struct inode *inode,
-			struct extent_changeset **reserved, u64 start, u64 len)
+			struct extent_changeset **reserved, u64 start, u64 len,
+			enum btrfs_metadata_reserve_type reserve_type)
 {
 	int ret;
 
 	ret = btrfs_check_data_free_space(inode, reserved, start, len);
 	if (ret < 0)
 		return ret;
-	ret = btrfs_delalloc_reserve_metadata(BTRFS_I(inode), len);
+	ret = btrfs_delalloc_reserve_metadata(BTRFS_I(inode), len,
+					      reserve_type);
 	if (ret < 0)
 		btrfs_free_reserved_data_space(inode, *reserved, start, len);
 	return ret;
@@ -6077,6 +6097,12 @@ int btrfs_delalloc_reserve_space(struct inode *inode,
  * @start: start position of the space already reserved
  * @len: the len of the space already reserved
  * @release_bytes: the len of the space we consumed or didn't use
+ * @reserve_type: the type of write we're releasing for
+ *		  must match the type passed to btrfs_delalloc_reserve_space()
+ *
+ * This must be matched with a call to btrfs_delalloc_reserve_space.  This is
+ * called in the case that we don't need the metadata AND data reservations
+ * anymore.  So if there is an error or we insert an inline extent.
  *
  * This function will release the metadata space that was not used and will
  * decrement ->delalloc_bytes and remove it from the fs_info delalloc_inodes
@@ -6085,9 +6111,11 @@ int btrfs_delalloc_reserve_space(struct inode *inode,
  */
 void btrfs_delalloc_release_space(struct inode *inode,
 				  struct extent_changeset *reserved,
-				  u64 start, u64 len, bool qgroup_free)
+				  u64 start, u64 len, bool qgroup_free,
+				  enum btrfs_metadata_reserve_type reserve_type)
 {
-	btrfs_delalloc_release_metadata(BTRFS_I(inode), len, qgroup_free);
+	btrfs_delalloc_release_metadata(BTRFS_I(inode), len, qgroup_free,
+					reserve_type);
 	btrfs_free_reserved_data_space(inode, reserved, start, len);
 }
 
diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index a3c22e16509b..d655c9356d9e 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -513,7 +513,8 @@ static int btrfs_find_new_delalloc_bytes(struct btrfs_inode *inode,
  */
 int btrfs_dirty_pages(struct inode *inode, struct page **pages,
 		      size_t num_pages, loff_t pos, size_t write_bytes,
-		      struct extent_state **cached)
+		      struct extent_state **cached,
+		      enum btrfs_metadata_reserve_type reserve_type)
 {
 	struct btrfs_fs_info *fs_info = btrfs_sb(inode->i_sb);
 	int err = 0;
@@ -558,7 +559,7 @@ int btrfs_dirty_pages(struct inode *inode, struct page **pages,
 	}
 
 	err = btrfs_set_extent_delalloc(inode, start_pos, end_of_last_block,
-					extra_bits, cached, 0);
+					extra_bits, cached, reserve_type);
 	if (err)
 		return err;
 
@@ -1601,6 +1602,7 @@ static noinline ssize_t btrfs_buffered_write(struct kiocb *iocb,
 	int ret = 0;
 	bool only_release_metadata = false;
 	bool force_page_uptodate = false;
+	enum btrfs_metadata_reserve_type reserve_type = BTRFS_RESERVE_NORMAL;
 
 	nrptrs = min(DIV_ROUND_UP(iov_iter_count(i), PAGE_SIZE),
 			PAGE_SIZE / (sizeof(struct page *)));
@@ -1669,7 +1671,7 @@ static noinline ssize_t btrfs_buffered_write(struct kiocb *iocb,
 
 		WARN_ON(reserve_bytes == 0);
 		ret = btrfs_delalloc_reserve_metadata(BTRFS_I(inode),
-				reserve_bytes);
+				reserve_bytes, reserve_type);
 		if (ret) {
 			if (!only_release_metadata)
 				btrfs_free_reserved_data_space(inode,
@@ -1692,7 +1694,8 @@ static noinline ssize_t btrfs_buffered_write(struct kiocb *iocb,
 				    force_page_uptodate);
 		if (ret) {
 			btrfs_delalloc_release_extents(BTRFS_I(inode),
-						       reserve_bytes, true);
+						       reserve_bytes, true,
+						       reserve_type);
 			break;
 		}
 
@@ -1704,7 +1707,8 @@ static noinline ssize_t btrfs_buffered_write(struct kiocb *iocb,
 			if (extents_locked == -EAGAIN)
 				goto again;
 			btrfs_delalloc_release_extents(BTRFS_I(inode),
-						       reserve_bytes, true);
+						       reserve_bytes, true,
+						       reserve_type);
 			ret = extents_locked;
 			break;
 		}
@@ -1739,7 +1743,8 @@ static noinline ssize_t btrfs_buffered_write(struct kiocb *iocb,
 						fs_info->sb->s_blocksize_bits;
 			if (only_release_metadata) {
 				btrfs_delalloc_release_metadata(BTRFS_I(inode),
-							release_bytes, true);
+							release_bytes, true,
+							reserve_type);
 			} else {
 				u64 __pos;
 
@@ -1748,7 +1753,8 @@ static noinline ssize_t btrfs_buffered_write(struct kiocb *iocb,
 					(dirty_pages << PAGE_SHIFT);
 				btrfs_delalloc_release_space(inode,
 						data_reserved, __pos,
-						release_bytes, true);
+						release_bytes, true,
+						reserve_type);
 			}
 		}
 
@@ -1757,12 +1763,13 @@ static noinline ssize_t btrfs_buffered_write(struct kiocb *iocb,
 
 		if (copied > 0)
 			ret = btrfs_dirty_pages(inode, pages, dirty_pages,
-						pos, copied, &cached_state);
+						pos, copied, &cached_state,
+						reserve_type);
 		if (extents_locked)
 			unlock_extent_cached(&BTRFS_I(inode)->io_tree,
 					     lockstart, lockend, &cached_state);
 		btrfs_delalloc_release_extents(BTRFS_I(inode), reserve_bytes,
-					       true);
+					       true, reserve_type);
 		if (ret) {
 			btrfs_drop_pages(pages, num_pages);
 			break;
@@ -1802,11 +1809,12 @@ static noinline ssize_t btrfs_buffered_write(struct kiocb *iocb,
 		if (only_release_metadata) {
 			btrfs_end_write_no_snapshotting(root);
 			btrfs_delalloc_release_metadata(BTRFS_I(inode),
-					release_bytes, true);
+					release_bytes, true,
+					reserve_type);
 		} else {
 			btrfs_delalloc_release_space(inode, data_reserved,
 					round_down(pos, fs_info->sectorsize),
-					release_bytes, true);
+					release_bytes, true, reserve_type);
 		}
 	}
 
diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index 4ba0aedc878b..3f6c7be4665e 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -1294,7 +1294,8 @@ static int __btrfs_write_out_cache(struct btrfs_root *root, struct inode *inode,
 
 	/* Everything is written out, now we dirty the pages in the file. */
 	ret = btrfs_dirty_pages(inode, io_ctl->pages, io_ctl->num_pages, 0,
-				i_size_read(inode), &cached_state);
+				i_size_read(inode), &cached_state,
+				BTRFS_RESERVE_NORMAL);
 	if (ret)
 		goto out_nospc;
 
@@ -3546,7 +3547,8 @@ int btrfs_write_out_ino_cache(struct btrfs_root *root,
 	if (ret) {
 		if (release_metadata)
 			btrfs_delalloc_release_metadata(BTRFS_I(inode),
-					inode->i_size, true);
+					inode->i_size, true,
+					BTRFS_RESERVE_NORMAL);
 #ifdef DEBUG
 		btrfs_err(fs_info,
 			  "failed to write free ino cache for root %llu",
diff --git a/fs/btrfs/inode-map.c b/fs/btrfs/inode-map.c
index ffca2abf13d0..4890e4053a2f 100644
--- a/fs/btrfs/inode-map.c
+++ b/fs/btrfs/inode-map.c
@@ -476,19 +476,22 @@ int btrfs_save_ino_cache(struct btrfs_root *root,
 	/* Just to make sure we have enough space */
 	prealloc += 8 * PAGE_SIZE;
 
-	ret = btrfs_delalloc_reserve_space(inode, &data_reserved, 0, prealloc);
+	ret = btrfs_delalloc_reserve_space(inode, &data_reserved, 0, prealloc,
+					   BTRFS_RESERVE_NORMAL);
 	if (ret)
 		goto out_put;
 
 	ret = btrfs_prealloc_file_range_trans(inode, trans, 0, 0, prealloc,
 					      prealloc, prealloc, &alloc_hint);
 	if (ret) {
-		btrfs_delalloc_release_extents(BTRFS_I(inode), prealloc, true);
+		btrfs_delalloc_release_extents(BTRFS_I(inode), prealloc, true,
+					       BTRFS_RESERVE_NORMAL);
 		goto out_put;
 	}
 
 	ret = btrfs_write_out_ino_cache(root, trans, path, inode);
-	btrfs_delalloc_release_extents(BTRFS_I(inode), prealloc, false);
+	btrfs_delalloc_release_extents(BTRFS_I(inode), prealloc, false,
+				       BTRFS_RESERVE_NORMAL);
 out_put:
 	iput(inode);
 out_release:
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index d3df5b52278c..ff8af15c9039 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -1615,13 +1615,17 @@ static void btrfs_split_extent_hook(void *private_data,
 {
 	struct inode *inode = private_data;
 	u64 size;
+	enum btrfs_metadata_reserve_type reserve_type = BTRFS_RESERVE_NORMAL;
+	u64 max_extent_size;
 
 	/* not delalloc, ignore it */
 	if (!(orig->state & EXTENT_DELALLOC))
 		return;
 
+	max_extent_size = btrfs_max_extent_size(reserve_type);
+
 	size = orig->end - orig->start + 1;
-	if (size > BTRFS_MAX_EXTENT_SIZE) {
+	if (size > max_extent_size) {
 		u32 num_extents;
 		u64 new_size;
 
@@ -1630,10 +1634,10 @@ static void btrfs_split_extent_hook(void *private_data,
 		 * applies here, just in reverse.
 		 */
 		new_size = orig->end - split + 1;
-		num_extents = count_max_extents(new_size);
+		num_extents = count_max_extents(new_size, max_extent_size);
 		new_size = split - orig->start;
-		num_extents += count_max_extents(new_size);
-		if (count_max_extents(size) >= num_extents)
+		num_extents += count_max_extents(new_size, max_extent_size);
+		if (count_max_extents(size, max_extent_size) >= num_extents)
 			return;
 	}
 
@@ -1654,19 +1658,23 @@ static void btrfs_merge_extent_hook(void *private_data,
 {
 	struct inode *inode = private_data;
 	u64 new_size, old_size;
+	u64 max_extent_size;
 	u32 num_extents;
+	enum btrfs_metadata_reserve_type reserve_type = BTRFS_RESERVE_NORMAL;
 
 	/* not delalloc, ignore it */
 	if (!(other->state & EXTENT_DELALLOC))
 		return;
 
+	max_extent_size = btrfs_max_extent_size(reserve_type);
+
 	if (new->start > other->start)
 		new_size = new->end - other->start + 1;
 	else
 		new_size = other->end - new->start + 1;
 
 	/* we're not bigger than the max, unreserve the space and go */
-	if (new_size <= BTRFS_MAX_EXTENT_SIZE) {
+	if (new_size <= max_extent_size) {
 		spin_lock(&BTRFS_I(inode)->lock);
 		btrfs_mod_outstanding_extents(BTRFS_I(inode), -1);
 		spin_unlock(&BTRFS_I(inode)->lock);
@@ -1692,10 +1700,10 @@ static void btrfs_merge_extent_hook(void *private_data,
 	 * this case.
 	 */
 	old_size = other->end - other->start + 1;
-	num_extents = count_max_extents(old_size);
+	num_extents = count_max_extents(old_size, max_extent_size);
 	old_size = new->end - new->start + 1;
-	num_extents += count_max_extents(old_size);
-	if (count_max_extents(new_size) >= num_extents)
+	num_extents += count_max_extents(old_size, max_extent_size);
+	if (count_max_extents(new_size, max_extent_size) >= num_extents)
 		return;
 
 	spin_lock(&BTRFS_I(inode)->lock);
@@ -1777,9 +1785,15 @@ static void btrfs_set_bit_hook(void *private_data,
 	if (!(state->state & EXTENT_DELALLOC) && (*bits & EXTENT_DELALLOC)) {
 		struct btrfs_root *root = BTRFS_I(inode)->root;
 		u64 len = state->end + 1 - state->start;
-		u32 num_extents = count_max_extents(len);
+		u64 max_extent_size;
+		u64 num_extents;
+		enum btrfs_metadata_reserve_type reserve_type =
+							BTRFS_RESERVE_NORMAL;
 		bool do_list = !btrfs_is_free_space_inode(BTRFS_I(inode));
 
+		max_extent_size = btrfs_max_extent_size(reserve_type);
+		num_extents = count_max_extents(len, max_extent_size);
+
 		spin_lock(&BTRFS_I(inode)->lock);
 		btrfs_mod_outstanding_extents(BTRFS_I(inode), num_extents);
 		spin_unlock(&BTRFS_I(inode)->lock);
@@ -1818,8 +1832,10 @@ static void btrfs_clear_bit_hook(void *private_data,
 {
 	struct btrfs_inode *inode = BTRFS_I((struct inode *)private_data);
 	struct btrfs_fs_info *fs_info = btrfs_sb(inode->vfs_inode.i_sb);
+	enum btrfs_metadata_reserve_type reserve_type = BTRFS_RESERVE_NORMAL;
 	u64 len = state->end + 1 - state->start;
-	u32 num_extents = count_max_extents(len);
+	u64 max_extent_size;
+	u32 num_extents;
 
 	if ((state->state & EXTENT_DEFRAG) && (*bits & EXTENT_DEFRAG)) {
 		spin_lock(&inode->lock);
@@ -1836,6 +1852,9 @@ static void btrfs_clear_bit_hook(void *private_data,
 		struct btrfs_root *root = inode->root;
 		bool do_list = !btrfs_is_free_space_inode(inode);
 
+		max_extent_size = btrfs_max_extent_size(reserve_type);
+		num_extents = count_max_extents(len, max_extent_size);
+
 		spin_lock(&inode->lock);
 		btrfs_mod_outstanding_extents(inode, -num_extents);
 		spin_unlock(&inode->lock);
@@ -1847,7 +1866,8 @@ static void btrfs_clear_bit_hook(void *private_data,
 		 */
 		if (*bits & EXTENT_CLEAR_META_RESV &&
 		    root != fs_info->tree_root)
-			btrfs_delalloc_release_metadata(inode, len, false);
+			btrfs_delalloc_release_metadata(inode, len, false,
+							reserve_type);
 
 		/* For sanity tests. */
 		if (btrfs_is_testing(fs_info))
@@ -2055,13 +2075,24 @@ static noinline int add_pending_csums(struct btrfs_trans_handle *trans,
 
 int btrfs_set_extent_delalloc(struct inode *inode, u64 start, u64 end,
 			      unsigned int extra_bits,
-			      struct extent_state **cached_state, int dedupe)
+			      struct extent_state **cached_state,
+			      enum btrfs_metadata_reserve_type reserve_type)
 {
 	WARN_ON((end & (PAGE_SIZE - 1)) == 0);
 	return set_extent_delalloc(&BTRFS_I(inode)->io_tree, start, end,
 				   extra_bits, cached_state);
 }
 
+
+int btrfs_set_extent_defrag(struct inode *inode, u64 start, u64 end,
+			    struct extent_state **cached_state,
+			    enum btrfs_metadata_reserve_type reserve_type)
+{
+	WARN_ON((end & (PAGE_SIZE - 1)) == 0);
+	return set_extent_defrag(&BTRFS_I(inode)->io_tree, start, end,
+				 cached_state);
+}
+
 /* see btrfs_writepage_start_hook for details on why this is required */
 struct btrfs_writepage_fixup {
 	struct page *page;
@@ -2079,6 +2110,7 @@ static void btrfs_writepage_fixup_worker(struct btrfs_work *work)
 	u64 page_start;
 	u64 page_end;
 	int ret;
+	enum btrfs_metadata_reserve_type reserve_type = BTRFS_RESERVE_NORMAL;
 
 	fixup = container_of(work, struct btrfs_writepage_fixup, work);
 	page = fixup->page;
@@ -2112,7 +2144,7 @@ static void btrfs_writepage_fixup_worker(struct btrfs_work *work)
 	}
 
 	ret = btrfs_delalloc_reserve_space(inode, &data_reserved, page_start,
-					   PAGE_SIZE);
+					   PAGE_SIZE, reserve_type);
 	if (ret) {
 		mapping_set_error(page->mapping, ret);
 		end_extent_writepage(page, ret, page_start, page_end);
@@ -2121,7 +2153,7 @@ static void btrfs_writepage_fixup_worker(struct btrfs_work *work)
 	 }
 
 	ret = btrfs_set_extent_delalloc(inode, page_start, page_end, 0,
-					&cached_state, 0);
+					&cached_state, reserve_type);
 	if (ret) {
 		mapping_set_error(page->mapping, ret);
 		end_extent_writepage(page, ret, page_start, page_end);
@@ -2131,7 +2163,8 @@ static void btrfs_writepage_fixup_worker(struct btrfs_work *work)
 
 	ClearPageChecked(page);
 	set_page_dirty(page);
-	btrfs_delalloc_release_extents(BTRFS_I(inode), PAGE_SIZE, false);
+	btrfs_delalloc_release_extents(BTRFS_I(inode), PAGE_SIZE, false,
+				       reserve_type);
 out:
 	unlock_extent_cached(&BTRFS_I(inode)->io_tree, page_start, page_end,
 			     &cached_state);
@@ -2942,6 +2975,7 @@ static int btrfs_finish_ordered_io(struct btrfs_ordered_extent *ordered_extent)
 	bool range_locked = false;
 	bool clear_new_delalloc_bytes = false;
 	bool clear_reserved_extent = true;
+	enum btrfs_metadata_reserve_type reserve_type = BTRFS_RESERVE_NORMAL;
 
 	if (!test_bit(BTRFS_ORDERED_NOCOW, &ordered_extent->flags) &&
 	    !test_bit(BTRFS_ORDERED_PREALLOC, &ordered_extent->flags) &&
@@ -3130,7 +3164,7 @@ static int btrfs_finish_ordered_io(struct btrfs_ordered_extent *ordered_extent)
 	 * This needs to be done to make sure anybody waiting knows we are done
 	 * updating everything for this ordered extent.
 	 */
-	btrfs_remove_ordered_extent(inode, ordered_extent);
+	btrfs_remove_ordered_extent(inode, ordered_extent, reserve_type);
 
 	/* for snapshot-aware defrag */
 	if (new) {
@@ -4839,6 +4873,7 @@ int btrfs_truncate_block(struct inode *inode, loff_t from, loff_t len,
 	int ret = 0;
 	u64 block_start;
 	u64 block_end;
+	enum btrfs_metadata_reserve_type reserve_type = BTRFS_RESERVE_NORMAL;
 
 	if (IS_ALIGNED(offset, blocksize) &&
 	    (!len || IS_ALIGNED(len, blocksize)))
@@ -4848,7 +4883,8 @@ int btrfs_truncate_block(struct inode *inode, loff_t from, loff_t len,
 	block_end = block_start + blocksize - 1;
 
 	ret = btrfs_delalloc_reserve_space(inode, &data_reserved,
-					   block_start, blocksize);
+					   block_start, blocksize,
+					   reserve_type);
 	if (ret)
 		goto out;
 
@@ -4856,8 +4892,10 @@ int btrfs_truncate_block(struct inode *inode, loff_t from, loff_t len,
 	page = find_or_create_page(mapping, index, mask);
 	if (!page) {
 		btrfs_delalloc_release_space(inode, data_reserved,
-					     block_start, blocksize, true);
-		btrfs_delalloc_release_extents(BTRFS_I(inode), blocksize, true);
+					     block_start, blocksize, true,
+					     reserve_type);
+		btrfs_delalloc_release_extents(BTRFS_I(inode), blocksize, true,
+					       reserve_type);
 		ret = -ENOMEM;
 		goto out;
 	}
@@ -4897,7 +4935,7 @@ int btrfs_truncate_block(struct inode *inode, loff_t from, loff_t len,
 			  0, 0, &cached_state);
 
 	ret = btrfs_set_extent_delalloc(inode, block_start, block_end, 0,
-					&cached_state, 0);
+					&cached_state, reserve_type);
 	if (ret) {
 		unlock_extent_cached(io_tree, block_start, block_end,
 				     &cached_state);
@@ -4924,8 +4962,9 @@ int btrfs_truncate_block(struct inode *inode, loff_t from, loff_t len,
 out_unlock:
 	if (ret)
 		btrfs_delalloc_release_space(inode, data_reserved, block_start,
-					     blocksize, true);
-	btrfs_delalloc_release_extents(BTRFS_I(inode), blocksize, (ret != 0));
+					     blocksize, true, reserve_type);
+	btrfs_delalloc_release_extents(BTRFS_I(inode), blocksize, (ret != 0),
+				       reserve_type);
 	unlock_page(page);
 	put_page(page);
 out:
@@ -8520,7 +8559,8 @@ static ssize_t btrfs_direct_IO(struct kiocb *iocb, struct iov_iter *iter)
 			goto out;
 		}
 		ret = btrfs_delalloc_reserve_space(inode, &data_reserved,
-						   offset, count);
+						   offset, count,
+						   BTRFS_RESERVE_NORMAL);
 		if (ret)
 			goto out;
 
@@ -8552,7 +8592,8 @@ static ssize_t btrfs_direct_IO(struct kiocb *iocb, struct iov_iter *iter)
 		if (ret < 0 && ret != -EIOCBQUEUED) {
 			if (dio_data.reserve)
 				btrfs_delalloc_release_space(inode, data_reserved,
-					offset, dio_data.reserve, true);
+					offset, dio_data.reserve, true,
+					BTRFS_RESERVE_NORMAL);
 			/*
 			 * On error we might have left some ordered extents
 			 * without submitting corresponding bios for them, so
@@ -8568,8 +8609,10 @@ static ssize_t btrfs_direct_IO(struct kiocb *iocb, struct iov_iter *iter)
 					false);
 		} else if (ret >= 0 && (size_t)ret < count)
 			btrfs_delalloc_release_space(inode, data_reserved,
-					offset, count - (size_t)ret, true);
-		btrfs_delalloc_release_extents(BTRFS_I(inode), count, false);
+					offset, count - (size_t)ret, true,
+					BTRFS_RESERVE_NORMAL);
+		btrfs_delalloc_release_extents(BTRFS_I(inode), count, false,
+					       BTRFS_RESERVE_NORMAL);
 	}
 out:
 	if (wakeup)
@@ -8797,6 +8840,7 @@ vm_fault_t btrfs_page_mkwrite(struct vm_fault *vmf)
 	struct btrfs_ordered_extent *ordered;
 	struct extent_state *cached_state = NULL;
 	struct extent_changeset *data_reserved = NULL;
+	enum btrfs_metadata_reserve_type reserve_type = BTRFS_RESERVE_NORMAL;
 	char *kaddr;
 	unsigned long zero_start;
 	loff_t size;
@@ -8824,7 +8868,7 @@ vm_fault_t btrfs_page_mkwrite(struct vm_fault *vmf)
 	 * being processed by btrfs_page_mkwrite() function.
 	 */
 	ret2 = btrfs_delalloc_reserve_space(inode, &data_reserved, page_start,
-					   reserved_space);
+					   reserved_space, reserve_type);
 	if (!ret2) {
 		ret2 = file_update_time(vmf->vma->vm_file);
 		reserved = 1;
@@ -8873,7 +8917,7 @@ vm_fault_t btrfs_page_mkwrite(struct vm_fault *vmf)
 			end = page_start + reserved_space - 1;
 			btrfs_delalloc_release_space(inode, data_reserved,
 					page_start, PAGE_SIZE - reserved_space,
-					true);
+					true, reserve_type);
 		}
 	}
 
@@ -8890,7 +8934,7 @@ vm_fault_t btrfs_page_mkwrite(struct vm_fault *vmf)
 			  0, 0, &cached_state);
 
 	ret2 = btrfs_set_extent_delalloc(inode, page_start, end, 0,
-					&cached_state, 0);
+					&cached_state, reserve_type);
 	if (ret2) {
 		unlock_extent_cached(io_tree, page_start, page_end,
 				     &cached_state);
@@ -8922,7 +8966,8 @@ vm_fault_t btrfs_page_mkwrite(struct vm_fault *vmf)
 	unlock_extent_cached(io_tree, page_start, page_end, &cached_state);
 
 	if (!ret2) {
-		btrfs_delalloc_release_extents(BTRFS_I(inode), PAGE_SIZE, true);
+		btrfs_delalloc_release_extents(BTRFS_I(inode), PAGE_SIZE, true,
+					       reserve_type);
 		sb_end_pagefault(inode->i_sb);
 		extent_changeset_free(data_reserved);
 		return VM_FAULT_LOCKED;
@@ -8931,9 +8976,11 @@ vm_fault_t btrfs_page_mkwrite(struct vm_fault *vmf)
 out_unlock:
 	unlock_page(page);
 out:
-	btrfs_delalloc_release_extents(BTRFS_I(inode), PAGE_SIZE, (ret != 0));
+	btrfs_delalloc_release_extents(BTRFS_I(inode), PAGE_SIZE, (ret != 0),
+				       reserve_type);
 	btrfs_delalloc_release_space(inode, data_reserved, page_start,
-				     reserved_space, (ret != 0));
+				     reserved_space, (ret != 0),
+				     reserve_type);
 out_noreserve:
 	sb_end_pagefault(inode->i_sb);
 	extent_changeset_free(data_reserved);
@@ -9199,6 +9246,7 @@ void btrfs_destroy_inode(struct inode *inode)
 	struct btrfs_fs_info *fs_info = btrfs_sb(inode->i_sb);
 	struct btrfs_ordered_extent *ordered;
 	struct btrfs_root *root = BTRFS_I(inode)->root;
+	enum btrfs_metadata_reserve_type reserve_type = BTRFS_RESERVE_NORMAL;
 
 	WARN_ON(!hlist_empty(&inode->i_dentry));
 	WARN_ON(inode->i_data.nrpages);
@@ -9226,7 +9274,8 @@ void btrfs_destroy_inode(struct inode *inode)
 			btrfs_err(fs_info,
 				  "found ordered extent %llu %llu on inode cleanup",
 				  ordered->file_offset, ordered->len);
-			btrfs_remove_ordered_extent(inode, ordered);
+			btrfs_remove_ordered_extent(inode, ordered,
+						    reserve_type);
 			btrfs_put_ordered_extent(ordered);
 			btrfs_put_ordered_extent(ordered);
 		}
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 3ca6943827ef..93c75f6323f6 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -1229,6 +1229,7 @@ static int cluster_pages_for_defrag(struct inode *inode,
 	struct extent_state *cached_state = NULL;
 	struct extent_io_tree *tree;
 	struct extent_changeset *data_reserved = NULL;
+	enum btrfs_metadata_reserve_type reserve_type = BTRFS_RESERVE_NORMAL;
 	gfp_t mask = btrfs_alloc_write_mask(inode->i_mapping);
 
 	file_end = (isize - 1) >> PAGE_SHIFT;
@@ -1239,7 +1240,7 @@ static int cluster_pages_for_defrag(struct inode *inode,
 
 	ret = btrfs_delalloc_reserve_space(inode, &data_reserved,
 			start_index << PAGE_SHIFT,
-			page_cnt << PAGE_SHIFT);
+			page_cnt << PAGE_SHIFT, reserve_type);
 	if (ret)
 		return ret;
 	i_done = 0;
@@ -1330,13 +1331,12 @@ static int cluster_pages_for_defrag(struct inode *inode,
 		spin_unlock(&BTRFS_I(inode)->lock);
 		btrfs_delalloc_release_space(inode, data_reserved,
 				start_index << PAGE_SHIFT,
-				(page_cnt - i_done) << PAGE_SHIFT, true);
+				(page_cnt - i_done) << PAGE_SHIFT, true,
+				reserve_type);
 	}
 
-
-	set_extent_defrag(&BTRFS_I(inode)->io_tree, page_start, page_end - 1,
-			  &cached_state);
-
+	btrfs_set_extent_defrag(inode, page_start,
+				page_end - 1, &cached_state, reserve_type);
 	unlock_extent_cached(&BTRFS_I(inode)->io_tree,
 			     page_start, page_end - 1, &cached_state);
 
@@ -1349,7 +1349,7 @@ static int cluster_pages_for_defrag(struct inode *inode,
 		put_page(pages[i]);
 	}
 	btrfs_delalloc_release_extents(BTRFS_I(inode), page_cnt << PAGE_SHIFT,
-				       false);
+				       false, reserve_type);
 	extent_changeset_free(data_reserved);
 	return i_done;
 out:
@@ -1358,13 +1358,14 @@ static int cluster_pages_for_defrag(struct inode *inode,
 		put_page(pages[i]);
 	}
 	btrfs_delalloc_release_space(inode, data_reserved,
-			start_index << PAGE_SHIFT,
-			page_cnt << PAGE_SHIFT, true);
+				     start_index << PAGE_SHIFT,
+				     page_cnt << PAGE_SHIFT, true,
+				     reserve_type);
 	btrfs_delalloc_release_extents(BTRFS_I(inode), page_cnt << PAGE_SHIFT,
-				       true);
+				       true, reserve_type);
 	extent_changeset_free(data_reserved);
-	return ret;
 
+	return ret;
 }
 
 int btrfs_defrag_file(struct inode *inode, struct file *file,
diff --git a/fs/btrfs/ordered-data.c b/fs/btrfs/ordered-data.c
index 4b112258a79b..47554e0550d7 100644
--- a/fs/btrfs/ordered-data.c
+++ b/fs/btrfs/ordered-data.c
@@ -491,7 +491,8 @@ void btrfs_put_ordered_extent(struct btrfs_ordered_extent *entry)
  * and waiters are woken up.
  */
 void btrfs_remove_ordered_extent(struct inode *inode,
-				 struct btrfs_ordered_extent *entry)
+				 struct btrfs_ordered_extent *entry,
+				 enum btrfs_metadata_reserve_type reserve_type)
 {
 	struct btrfs_fs_info *fs_info = btrfs_sb(inode->i_sb);
 	struct btrfs_ordered_inode_tree *tree;
@@ -505,7 +506,8 @@ void btrfs_remove_ordered_extent(struct inode *inode,
 	btrfs_mod_outstanding_extents(btrfs_inode, -1);
 	spin_unlock(&btrfs_inode->lock);
 	if (root != fs_info->tree_root)
-		btrfs_delalloc_release_metadata(btrfs_inode, entry->len, false);
+		btrfs_delalloc_release_metadata(btrfs_inode, entry->len, false,
+						reserve_type);
 
 	tree = &btrfs_inode->ordered_tree;
 	spin_lock_irq(&tree->lock);
diff --git a/fs/btrfs/ordered-data.h b/fs/btrfs/ordered-data.h
index 08c7ee986bb9..0124b14e56e7 100644
--- a/fs/btrfs/ordered-data.h
+++ b/fs/btrfs/ordered-data.h
@@ -159,7 +159,8 @@ btrfs_ordered_inode_tree_init(struct btrfs_ordered_inode_tree *t)
 
 void btrfs_put_ordered_extent(struct btrfs_ordered_extent *entry);
 void btrfs_remove_ordered_extent(struct inode *inode,
-				struct btrfs_ordered_extent *entry);
+				struct btrfs_ordered_extent *entry,
+				enum btrfs_metadata_reserve_type reserve_type);
 int btrfs_dec_test_ordered_pending(struct inode *inode,
 				   struct btrfs_ordered_extent **cached,
 				   u64 file_offset, u64 io_size, int uptodate);
diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index 924116f654a1..11476ad7387a 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -3143,6 +3143,7 @@ static int relocate_file_extent_cluster(struct inode *inode,
 	unsigned long last_index;
 	struct page *page;
 	struct file_ra_state *ra;
+	enum btrfs_metadata_reserve_type reserve_type = BTRFS_RESERVE_NORMAL;
 	gfp_t mask = btrfs_alloc_write_mask(inode->i_mapping);
 	int nr = 0;
 	int ret = 0;
@@ -3169,7 +3170,7 @@ static int relocate_file_extent_cluster(struct inode *inode,
 	last_index = (cluster->end - offset) >> PAGE_SHIFT;
 	while (index <= last_index) {
 		ret = btrfs_delalloc_reserve_metadata(BTRFS_I(inode),
-				PAGE_SIZE);
+				PAGE_SIZE, reserve_type);
 		if (ret)
 			goto out;
 
@@ -3182,7 +3183,8 @@ static int relocate_file_extent_cluster(struct inode *inode,
 						   mask);
 			if (!page) {
 				btrfs_delalloc_release_metadata(BTRFS_I(inode),
-							PAGE_SIZE, true);
+							PAGE_SIZE, true,
+							reserve_type);
 				ret = -ENOMEM;
 				goto out;
 			}
@@ -3201,9 +3203,11 @@ static int relocate_file_extent_cluster(struct inode *inode,
 				unlock_page(page);
 				put_page(page);
 				btrfs_delalloc_release_metadata(BTRFS_I(inode),
-							PAGE_SIZE, true);
+							PAGE_SIZE, true,
+							reserve_type);
 				btrfs_delalloc_release_extents(BTRFS_I(inode),
-							       PAGE_SIZE, true);
+							       PAGE_SIZE, true,
+							       reserve_type);
 				ret = -EIO;
 				goto out;
 			}
@@ -3225,14 +3229,16 @@ static int relocate_file_extent_cluster(struct inode *inode,
 		}
 
 		ret = btrfs_set_extent_delalloc(inode, page_start, page_end, 0,
-						NULL, 0);
+						NULL, reserve_type);
 		if (ret) {
 			unlock_page(page);
 			put_page(page);
 			btrfs_delalloc_release_metadata(BTRFS_I(inode),
-							 PAGE_SIZE, true);
+							PAGE_SIZE, true,
+							reserve_type);
 			btrfs_delalloc_release_extents(BTRFS_I(inode),
-			                               PAGE_SIZE, true);
+						       PAGE_SIZE, true,
+						       reserve_type);
 
 			clear_extent_bits(&BTRFS_I(inode)->io_tree,
 					  page_start, page_end,
@@ -3249,7 +3255,7 @@ static int relocate_file_extent_cluster(struct inode *inode,
 
 		index++;
 		btrfs_delalloc_release_extents(BTRFS_I(inode), PAGE_SIZE,
-					       false);
+					       false, reserve_type);
 		balance_dirty_pages_ratelimited(inode->i_mapping);
 		btrfs_throttle(fs_info);
 	}
diff --git a/fs/btrfs/tests/inode-tests.c b/fs/btrfs/tests/inode-tests.c
index 64043f028820..f885beff4b11 100644
--- a/fs/btrfs/tests/inode-tests.c
+++ b/fs/btrfs/tests/inode-tests.c
@@ -931,6 +931,7 @@ static int test_extent_accounting(u32 sectorsize, u32 nodesize)
 	struct btrfs_fs_info *fs_info = NULL;
 	struct inode *inode = NULL;
 	struct btrfs_root *root = NULL;
+	enum btrfs_metadata_reserve_type reserve_type = BTRFS_RESERVE_NORMAL;
 	int ret = -ENOMEM;
 
 	inode = btrfs_new_test_inode();
@@ -956,7 +957,7 @@ static int test_extent_accounting(u32 sectorsize, u32 nodesize)
 
 	/* [BTRFS_MAX_EXTENT_SIZE] */
 	ret = btrfs_set_extent_delalloc(inode, 0, BTRFS_MAX_EXTENT_SIZE - 1, 0,
-					NULL, 0);
+					NULL, reserve_type);
 	if (ret) {
 		test_err("btrfs_set_extent_delalloc returned %d", ret);
 		goto out;
@@ -971,7 +972,7 @@ static int test_extent_accounting(u32 sectorsize, u32 nodesize)
 	/* [BTRFS_MAX_EXTENT_SIZE][sectorsize] */
 	ret = btrfs_set_extent_delalloc(inode, BTRFS_MAX_EXTENT_SIZE,
 					BTRFS_MAX_EXTENT_SIZE + sectorsize - 1,
-					0, NULL, 0);
+					0, NULL, reserve_type);
 	if (ret) {
 		test_err("btrfs_set_extent_delalloc returned %d", ret);
 		goto out;
@@ -1004,7 +1005,7 @@ static int test_extent_accounting(u32 sectorsize, u32 nodesize)
 	ret = btrfs_set_extent_delalloc(inode, BTRFS_MAX_EXTENT_SIZE >> 1,
 					(BTRFS_MAX_EXTENT_SIZE >> 1)
 					+ sectorsize - 1,
-					0, NULL, 0);
+					0, NULL, reserve_type);
 	if (ret) {
 		test_err("btrfs_set_extent_delalloc returned %d", ret);
 		goto out;
@@ -1022,7 +1023,7 @@ static int test_extent_accounting(u32 sectorsize, u32 nodesize)
 	ret = btrfs_set_extent_delalloc(inode,
 			BTRFS_MAX_EXTENT_SIZE + 2 * sectorsize,
 			(BTRFS_MAX_EXTENT_SIZE << 1) + 3 * sectorsize - 1,
-			0, NULL, 0);
+			0, NULL, reserve_type);
 	if (ret) {
 		test_err("btrfs_set_extent_delalloc returned %d", ret);
 		goto out;
@@ -1039,7 +1040,8 @@ static int test_extent_accounting(u32 sectorsize, u32 nodesize)
 	*/
 	ret = btrfs_set_extent_delalloc(inode,
 			BTRFS_MAX_EXTENT_SIZE + sectorsize,
-			BTRFS_MAX_EXTENT_SIZE + 2 * sectorsize - 1, 0, NULL, 0);
+			BTRFS_MAX_EXTENT_SIZE + 2 * sectorsize - 1, 0, NULL,
+			reserve_type);
 	if (ret) {
 		test_err("btrfs_set_extent_delalloc returned %d", ret);
 		goto out;
@@ -1074,7 +1076,8 @@ static int test_extent_accounting(u32 sectorsize, u32 nodesize)
 	 */
 	ret = btrfs_set_extent_delalloc(inode,
 			BTRFS_MAX_EXTENT_SIZE + sectorsize,
-			BTRFS_MAX_EXTENT_SIZE + 2 * sectorsize - 1, 0, NULL, 0);
+			BTRFS_MAX_EXTENT_SIZE + 2 * sectorsize - 1, 0, NULL,
+			reserve_type);
 	if (ret) {
 		test_err("btrfs_set_extent_delalloc returned %d", ret);
 		goto out;
-- 
2.19.1



