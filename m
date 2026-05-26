Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D28822E7F25
	for <linux-btrfs@vger.kernel.org>; Tue, 26 May 2026 11:33:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779795206; cv=none; b=fKaYZWgPzQnNxodI4jsWr2lLenhHQO4gOhTaPWAZnTdMBj94/oycGLa+Y4wCHRZfPcX+XcfCZNVs8suuUQR60j6RDLk21jwSsoRwrPUwk56n4RGaCbWU4+UzjYALr/ggVERRK43GcKITLGUmu7MrUQCe9wfomENst0mWFKrXDV0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779795206; c=relaxed/simple;
	bh=EDc7cTI0n5CsUn/aoRNy++3wGKOkdLcPS1r/LqLCYIk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=LHhKc6aa+8wnQo2c/kffOQ/DPc/vojiQif39NbUsnjcaJRm/W6t9tu3SWJdFRuefZ0WFszOblwxIJsWT5Hs3O0GQ1gzcCIpTO+54SnM8Ipn7Y4hex/M3uX1vmmHhhJrxnrg1U+MI2I0X9oJXul2Ivv62X9YJp1/hbuoKqoib3iw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=c5oj9qid; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=c5oj9qid; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="c5oj9qid";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="c5oj9qid"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id F283375CED;
	Tue, 26 May 2026 11:33:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1779795202; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=d994azDAGC6oRDEUT73DNsJkI4dxDsBtB9X+ZFZSxF0=;
	b=c5oj9qidfrTsKSsNEGZlCPG/fk7vKNZZvTtTrvdvCFUUSOQ/qG3tOsQOv4cQT7geAbBvoX
	hMRiaQ4gIdnXecYawQYnHxTQZMZgx+HwXNUYTyhhJCn9+6Owgo8pBPHY6VkkzpZcQVyjgK
	kwK89csgjCYTSErXchWXXu0i6vLxczg=
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1779795202; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=d994azDAGC6oRDEUT73DNsJkI4dxDsBtB9X+ZFZSxF0=;
	b=c5oj9qidfrTsKSsNEGZlCPG/fk7vKNZZvTtTrvdvCFUUSOQ/qG3tOsQOv4cQT7geAbBvoX
	hMRiaQ4gIdnXecYawQYnHxTQZMZgx+HwXNUYTyhhJCn9+6Owgo8pBPHY6VkkzpZcQVyjgK
	kwK89csgjCYTSErXchWXXu0i6vLxczg=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id EB0B65A1A7;
	Tue, 26 May 2026 11:33:21 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 9IJgOQGFFWp4fgAAD6G6ig
	(envelope-from <dsterba@suse.com>); Tue, 26 May 2026 11:33:21 +0000
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH] btrfs: switch local indicator variables to bools
Date: Tue, 26 May 2026 13:33:21 +0200
Message-ID: <20260526113321.127533-1-dsterba@suse.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Score: -2.80
X-Spam-Level: 
X-Spamd-Result: default: False [-2.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-0.998];
	MIME_GOOD(-0.10)[text/plain];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCPT_COUNT_TWO(0.00)[2];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	internal_greylist_whitelist(0.00)[10.150.64.97];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.com:email,suse.com:mid];
	RCVD_TLS_ALL(0.00)[]
X-Spam-Flag: NO

For all local indicator variables do simple switch to bool, done on all
files.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/block-group.c      |  8 ++++----
 fs/btrfs/ctree.c            | 17 +++++++----------
 fs/btrfs/disk-io.c          |  4 ++--
 fs/btrfs/extent-io-tree.c   |  4 ++--
 fs/btrfs/extent-tree.c      | 12 ++++++------
 fs/btrfs/extent_io.c        | 32 ++++++++++++++++----------------
 fs/btrfs/file.c             |  4 ++--
 fs/btrfs/free-space-cache.c | 12 ++++++------
 fs/btrfs/free-space-tree.c  | 15 +++++++++------
 fs/btrfs/inode.c            |  4 ++--
 fs/btrfs/raid56.c           | 12 ++++++------
 fs/btrfs/relocation.c       | 28 ++++++++++++++--------------
 fs/btrfs/root-tree.c        |  6 +++---
 fs/btrfs/send.c             | 32 ++++++++++++++++----------------
 fs/btrfs/super.c            |  4 ++--
 fs/btrfs/transaction.c      |  4 ++--
 fs/btrfs/volumes.c          |  8 ++++----
 fs/btrfs/zoned.c            |  2 +-
 18 files changed, 104 insertions(+), 104 deletions(-)

diff --git a/fs/btrfs/block-group.c b/fs/btrfs/block-group.c
index a0cb0db68c9a4f..ab76a5173272a1 100644
--- a/fs/btrfs/block-group.c
+++ b/fs/btrfs/block-group.c
@@ -2482,7 +2482,7 @@ static int check_chunk_block_group_mappings(struct btrfs_fs_info *fs_info)
 static int read_one_block_group(struct btrfs_fs_info *info,
 				struct btrfs_block_group_item_v2 *bgi,
 				const struct btrfs_key *key,
-				int need_clear)
+				bool need_clear)
 {
 	struct btrfs_block_group *cache;
 	const bool mixed = btrfs_fs_incompat(info, MIXED_GROUPS);
@@ -2663,7 +2663,7 @@ int btrfs_read_block_groups(struct btrfs_fs_info *info)
 	struct btrfs_block_group *cache;
 	struct btrfs_space_info *space_info;
 	struct btrfs_key key;
-	int need_clear = 0;
+	bool need_clear = false;
 	u64 cache_gen;
 
 	/*
@@ -2688,9 +2688,9 @@ int btrfs_read_block_groups(struct btrfs_fs_info *info)
 	cache_gen = btrfs_super_cache_generation(info->super_copy);
 	if (btrfs_test_opt(info, SPACE_CACHE) &&
 	    btrfs_super_generation(info->super_copy) != cache_gen)
-		need_clear = 1;
+		need_clear = true;
 	if (btrfs_test_opt(info, CLEAR_CACHE))
-		need_clear = 1;
+		need_clear = true;
 
 	while (1) {
 		struct btrfs_block_group_item_v2 bgi;
diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index 829d8be7f423b5..49fb6b816aa940 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -475,13 +475,10 @@ int btrfs_force_cow_block(struct btrfs_trans_handle *trans,
 	struct extent_buffer *cow;
 	int level, ret;
 	int last_ref = 0;
-	int unlock_orig = 0;
+	const bool unlock_orig = (*cow_ret == buf);
 	u64 parent_start = 0;
 	u64 reloc_src_root = 0;
 
-	if (*cow_ret == buf)
-		unlock_orig = 1;
-
 	btrfs_assert_tree_write_locked(buf);
 
 	WARN_ON(test_bit(BTRFS_ROOT_SHAREABLE, &root->state) &&
@@ -2069,7 +2066,7 @@ int btrfs_search_slot(struct btrfs_trans_handle *trans, struct btrfs_root *root,
 	}
 
 	while (b) {
-		int dec = 0;
+		bool dec = false;
 		int ret2;
 
 		level = btrfs_header_level(b);
@@ -2152,7 +2149,7 @@ int btrfs_search_slot(struct btrfs_trans_handle *trans, struct btrfs_root *root,
 		prev_cmp = ret;
 
 		if (ret && slot > 0) {
-			dec = 1;
+			dec = true;
 			slot--;
 		}
 		p->slots[level] = slot;
@@ -2282,7 +2279,7 @@ int btrfs_search_old_slot(struct btrfs_root *root, const struct btrfs_key *key,
 	p->locks[level] = BTRFS_READ_LOCK;
 
 	while (b) {
-		int dec = 0;
+		bool dec = false;
 		int ret2;
 
 		level = btrfs_header_level(b);
@@ -2307,7 +2304,7 @@ int btrfs_search_old_slot(struct btrfs_root *root, const struct btrfs_key *key,
 		}
 
 		if (ret && slot > 0) {
-			dec = 1;
+			dec = true;
 			slot--;
 		}
 		p->slots[level] = slot;
@@ -3668,7 +3665,7 @@ static noinline int split_leaf(struct btrfs_trans_handle *trans,
 	int wret;
 	int split;
 	int num_doubles = 0;
-	int tried_avoid_double = 0;
+	bool tried_avoid_double = false;
 
 	l = path->nodes[0];
 	slot = path->slots[0];
@@ -3830,7 +3827,7 @@ static noinline int split_leaf(struct btrfs_trans_handle *trans,
 
 push_for_double:
 	push_for_double_split(trans, root, path, data_size);
-	tried_avoid_double = 1;
+	tried_avoid_double = true;
 	if (btrfs_leaf_free_space(path->nodes[0]) >= data_size)
 		return 0;
 	goto again;
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index e6ed52f5cd6d99..aba00c45016084 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -215,7 +215,7 @@ int btrfs_read_extent_buffer(struct extent_buffer *eb,
 			     const struct btrfs_tree_parent_check *check)
 {
 	struct btrfs_fs_info *fs_info = eb->fs_info;
-	int failed = 0;
+	bool failed = false;
 	int ret;
 	int num_copies = 0;
 	int mirror_num = 0;
@@ -234,7 +234,7 @@ int btrfs_read_extent_buffer(struct extent_buffer *eb,
 			break;
 
 		if (!failed_mirror) {
-			failed = 1;
+			failed = true;
 			failed_mirror = eb->read_mirror;
 		}
 
diff --git a/fs/btrfs/extent-io-tree.c b/fs/btrfs/extent-io-tree.c
index 62670224480976..c18ea5ef2974a8 100644
--- a/fs/btrfs/extent-io-tree.c
+++ b/fs/btrfs/extent-io-tree.c
@@ -1763,7 +1763,7 @@ u64 btrfs_count_range_bits(struct extent_io_tree *tree,
 	u64 cur_start = *start;
 	u64 total_bytes = 0;
 	u64 last = 0;
-	int found = 0;
+	bool found = false;
 
 	if (WARN_ON(search_end < cur_start))
 		return 0;
@@ -1817,7 +1817,7 @@ u64 btrfs_count_range_bits(struct extent_io_tree *tree,
 				break;
 			if (!found) {
 				*start = max(cur_start, state->start);
-				found = 1;
+				found = true;
 			}
 			last = state->end;
 		} else if (contig && found) {
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 6030cdbdb74210..b20f5a887a536b 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -1699,13 +1699,13 @@ static int run_delayed_extent_op(struct btrfs_trans_handle *trans,
 	struct extent_buffer *leaf;
 	u32 item_size;
 	int ret;
-	int metadata = 1;
+	bool metadata = true;
 
 	if (TRANS_ABORTED(trans))
 		return 0;
 
 	if (!btrfs_fs_incompat(fs_info, SKINNY_METADATA))
-		metadata = 0;
+		metadata = false;
 
 	path = btrfs_alloc_path();
 	if (!path)
@@ -1745,7 +1745,7 @@ static int run_delayed_extent_op(struct btrfs_trans_handle *trans,
 			}
 			if (ret > 0) {
 				btrfs_release_path(path);
-				metadata = 0;
+				metadata = false;
 
 				key.objectid = head->bytenr;
 				key.type = BTRFS_EXTENT_ITEM_KEY;
@@ -3283,7 +3283,7 @@ static int __btrfs_free_extent(struct btrfs_trans_handle *trans,
 	int ret;
 	int is_data;
 	int extent_slot = 0;
-	int found_extent = 0;
+	bool found_extent = false;
 	int num_to_del = 1;
 	int refs_to_drop = node->ref_mod;
 	u32 item_size;
@@ -3339,12 +3339,12 @@ static int __btrfs_free_extent(struct btrfs_trans_handle *trans,
 				break;
 			if (key.type == BTRFS_EXTENT_ITEM_KEY &&
 			    key.offset == num_bytes) {
-				found_extent = 1;
+				found_extent = true;
 				break;
 			}
 			if (key.type == BTRFS_METADATA_ITEM_KEY &&
 			    key.offset == owner_objectid) {
-				found_extent = 1;
+				found_extent = true;
 				break;
 			}
 
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 8cf1e4c5105f49..dbdd42114185d3 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -379,7 +379,7 @@ noinline_for_stack bool find_lock_delalloc_range(struct inode *inode,
 	bool found;
 	struct extent_state *cached_state = NULL;
 	int ret;
-	int loops = 0;
+	bool loops = false;
 
 	/* Caller should pass a valid @end to indicate the search range end */
 	ASSERT(orig_end > orig_start);
@@ -436,7 +436,7 @@ noinline_for_stack bool find_lock_delalloc_range(struct inode *inode,
 		cached_state = NULL;
 		if (!loops) {
 			max_bytes = fs_info->sectorsize;
-			loops = 1;
+			loops = true;
 			goto again;
 		} else {
 			return false;
@@ -2349,13 +2349,13 @@ int btree_writepages(struct address_space *mapping, struct writeback_control *wb
 	struct btrfs_eb_write_context ctx = { .wbc = wbc };
 	struct btrfs_fs_info *fs_info = inode_to_fs_info(mapping->host);
 	int ret = 0;
-	int done = 0;
+	bool done = false;
 	int nr_to_write_done = 0;
 	struct eb_batch batch;
 	unsigned int nr_ebs;
 	unsigned long index;
 	unsigned long end;
-	int scanned = 0;
+	bool scanned = false;
 	xa_mark_t tag;
 
 	eb_batch_init(&batch);
@@ -2372,7 +2372,7 @@ int btree_writepages(struct address_space *mapping, struct writeback_control *wb
 		index = (wbc->range_start >> fs_info->nodesize_bits);
 		end = (wbc->range_end >> fs_info->nodesize_bits);
 
-		scanned = 1;
+		scanned = true;
 	}
 	if (wbc->sync_mode == WB_SYNC_ALL)
 		tag = PAGECACHE_TAG_TOWRITE;
@@ -2395,7 +2395,7 @@ int btree_writepages(struct address_space *mapping, struct writeback_control *wb
 					ret = 0;
 
 				if (ret) {
-					done = 1;
+					done = false;
 					break;
 				}
 				continue;
@@ -2421,7 +2421,7 @@ int btree_writepages(struct address_space *mapping, struct writeback_control *wb
 		 * We hit the last page and there is more work to be done: wrap
 		 * back to the start of the file
 		 */
-		scanned = 1;
+		scanned = true;
 		index = 0;
 		goto retry;
 	}
@@ -2461,15 +2461,15 @@ static int extent_write_cache_pages(struct address_space *mapping,
 	struct writeback_control *wbc = bio_ctrl->wbc;
 	struct inode *inode = mapping->host;
 	int ret = 0;
-	int done = 0;
+	bool done = false;
 	int nr_to_write_done = 0;
 	struct folio_batch fbatch;
 	unsigned int nr_folios;
 	pgoff_t index;
 	pgoff_t end;		/* Inclusive */
 	pgoff_t done_index;
-	int range_whole = 0;
-	int scanned = 0;
+	bool range_whole = false;
+	bool scanned = false;
 	xa_mark_t tag;
 
 	/*
@@ -2497,8 +2497,8 @@ static int extent_write_cache_pages(struct address_space *mapping,
 		index = wbc->range_start >> PAGE_SHIFT;
 		end = wbc->range_end >> PAGE_SHIFT;
 		if (wbc->range_start == 0 && wbc->range_end == LLONG_MAX)
-			range_whole = 1;
-		scanned = 1;
+			range_whole = true;
+		scanned = true;
 	}
 
 	/*
@@ -2582,7 +2582,7 @@ static int extent_write_cache_pages(struct address_space *mapping,
 
 			ret = extent_writepage(folio, bio_ctrl);
 			if (ret < 0) {
-				done = 1;
+				done = true;
 				break;
 			}
 
@@ -2602,7 +2602,7 @@ static int extent_write_cache_pages(struct address_space *mapping,
 		 * We hit the last page and there is more work to be done: wrap
 		 * back to the start of the file
 		 */
-		scanned = 1;
+		scanned = true;
 		index = 0;
 
 		/*
@@ -3434,7 +3434,7 @@ struct extent_buffer *alloc_extent_buffer(struct btrfs_fs_info *fs_info,
 	struct btrfs_folio_state *prealloc = NULL;
 	u64 lockdep_owner = owner_root;
 	bool page_contig = true;
-	int uptodate = 1;
+	bool uptodate = true;
 	int ret;
 
 	if (check_eb_alignment(fs_info, start))
@@ -3544,7 +3544,7 @@ struct extent_buffer *alloc_extent_buffer(struct btrfs_fs_info *fs_info,
 			page_contig = false;
 
 		if (!btrfs_meta_folio_test_uptodate(folio, eb))
-			uptodate = 0;
+			uptodate = false;
 
 		/*
 		 * We can't unlock the pages just yet since the extent buffer
diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index d786b9666755ad..a2a2df2df78669 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -141,7 +141,7 @@ int btrfs_drop_extents(struct btrfs_trans_handle *trans,
 	int ret;
 	int modify_tree = -1;
 	int update_refs;
-	int found = 0;
+	bool found = false;
 	struct btrfs_path *path = args->path;
 
 	args->bytes_found = 0;
@@ -249,7 +249,7 @@ int btrfs_drop_extents(struct btrfs_trans_handle *trans,
 			goto next_slot;
 		}
 
-		found = 1;
+		found = true;
 		search_start = max(key.offset, args->start);
 		if (recow || !modify_tree) {
 			modify_tree = -1;
diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index 2354cb6fce369e..6009b1477232db 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -1373,7 +1373,7 @@ static int __btrfs_write_out_cache(struct inode *inode,
 	int entries = 0;
 	int bitmaps = 0;
 	int ret;
-	int must_iput = 0;
+	bool must_iput = false;
 	int i_size;
 
 	if (!i_size_read(inode))
@@ -1393,7 +1393,7 @@ static int __btrfs_write_out_cache(struct inode *inode,
 			up_write(&block_group->data_rwsem);
 			BTRFS_I(inode)->generation = 0;
 			ret = 0;
-			must_iput = 1;
+			must_iput = true;
 			goto out;
 		}
 		spin_unlock(&block_group->lock);
@@ -2306,7 +2306,7 @@ static int insert_into_bitmap(struct btrfs_free_space_ctl *ctl,
 {
 	struct btrfs_free_space *bitmap_info;
 	struct btrfs_block_group *block_group = ctl->block_group;
-	int added = 0;
+	bool added = false;
 	u64 bytes, offset, bytes_added;
 	enum btrfs_trim_state trim_state;
 	int ret;
@@ -2365,7 +2365,7 @@ static int insert_into_bitmap(struct btrfs_free_space_ctl *ctl,
 	bitmap_info = tree_search_offset(ctl, offset_to_bitmap(ctl, offset),
 					 1, 0);
 	if (!bitmap_info) {
-		ASSERT(added == 0);
+		ASSERT(!added);
 		goto new_bitmap;
 	}
 
@@ -2373,7 +2373,7 @@ static int insert_into_bitmap(struct btrfs_free_space_ctl *ctl,
 					  trim_state);
 	bytes -= bytes_added;
 	offset += bytes_added;
-	added = 0;
+	added = false;
 
 	if (!bytes) {
 		ret = 1;
@@ -2384,7 +2384,7 @@ static int insert_into_bitmap(struct btrfs_free_space_ctl *ctl,
 new_bitmap:
 	if (info && info->bitmap) {
 		add_new_bitmap(ctl, info, offset);
-		added = 1;
+		added = true;
 		info = NULL;
 		goto again;
 	} else {
diff --git a/fs/btrfs/free-space-tree.c b/fs/btrfs/free-space-tree.c
index 5e61612f961287..1b3d82ae3de80e 100644
--- a/fs/btrfs/free-space-tree.c
+++ b/fs/btrfs/free-space-tree.c
@@ -209,7 +209,8 @@ int btrfs_convert_free_space_to_bitmaps(struct btrfs_trans_handle *trans,
 	u64 bitmap_range, i;
 	u32 bitmap_size, flags, expected_extent_count;
 	u32 extent_count = 0;
-	int done = 0, nr;
+	bool done = false;
+	int nr;
 	int ret;
 
 	bitmap_size = free_space_bitmap_size(fs_info, block_group->length);
@@ -240,7 +241,7 @@ int btrfs_convert_free_space_to_bitmaps(struct btrfs_trans_handle *trans,
 			if (found_key.type == BTRFS_FREE_SPACE_INFO_KEY) {
 				ASSERT(found_key.objectid == block_group->start);
 				ASSERT(found_key.offset == block_group->length);
-				done = 1;
+				done = true;
 				break;
 			} else if (found_key.type == BTRFS_FREE_SPACE_EXTENT_KEY) {
 				u64 first, last;
@@ -353,7 +354,8 @@ int btrfs_convert_free_space_to_extents(struct btrfs_trans_handle *trans,
 	u32 bitmap_size, flags, expected_extent_count;
 	unsigned long nrbits, start_bit, end_bit;
 	u32 extent_count = 0;
-	int done = 0, nr;
+	bool done = false;
+	int nr;
 	int ret;
 
 	bitmap_size = free_space_bitmap_size(fs_info, block_group->length);
@@ -384,7 +386,7 @@ int btrfs_convert_free_space_to_extents(struct btrfs_trans_handle *trans,
 			if (found_key.type == BTRFS_FREE_SPACE_INFO_KEY) {
 				ASSERT(found_key.objectid == block_group->start);
 				ASSERT(found_key.offset == block_group->length);
-				done = 1;
+				done = true;
 				break;
 			} else if (found_key.type == BTRFS_FREE_SPACE_BITMAP_KEY) {
 				unsigned long ptr;
@@ -1473,7 +1475,8 @@ int btrfs_remove_block_group_free_space(struct btrfs_trans_handle *trans,
 	struct btrfs_key key, found_key;
 	struct extent_buffer *leaf;
 	u64 start, end;
-	int done = 0, nr;
+	bool done = false;
+	int nr;
 	int ret;
 
 	if (!btrfs_fs_compat_ro(trans->fs_info, FREE_SPACE_TREE))
@@ -1514,7 +1517,7 @@ int btrfs_remove_block_group_free_space(struct btrfs_trans_handle *trans,
 			if (found_key.type == BTRFS_FREE_SPACE_INFO_KEY) {
 				ASSERT(found_key.objectid == block_group->start);
 				ASSERT(found_key.offset == block_group->length);
-				done = 1;
+				done = true;
 				nr++;
 				path->slots[0]--;
 				break;
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 973a89301baaa7..95bc442e9662ee 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -3623,7 +3623,7 @@ int btrfs_orphan_cleanup(struct btrfs_root *root)
 
 		if (!inode && root == fs_info->tree_root) {
 			struct btrfs_root *dead_root;
-			int is_dead_root = 0;
+			bool is_dead_root = false;
 
 			/*
 			 * This is an orphan in the tree root. Currently these
@@ -3645,7 +3645,7 @@ int btrfs_orphan_cleanup(struct btrfs_root *root)
 			dead_root = radix_tree_lookup(&fs_info->fs_roots_radix,
 							 (unsigned long)found_key.objectid);
 			if (dead_root && btrfs_root_refs(&dead_root->root_item) == 0)
-				is_dead_root = 1;
+				is_dead_root = true;
 			spin_unlock(&fs_info->fs_roots_radix_lock);
 
 			if (is_dead_root) {
diff --git a/fs/btrfs/raid56.c b/fs/btrfs/raid56.c
index 08ee8f316d96d2..264f86eac7855a 100644
--- a/fs/btrfs/raid56.c
+++ b/fs/btrfs/raid56.c
@@ -466,7 +466,7 @@ static void __remove_rbio_from_cache(struct btrfs_raid_bio *rbio)
 	int bucket = rbio_bucket(rbio);
 	struct btrfs_stripe_hash_table *table;
 	struct btrfs_stripe_hash *h;
-	int freeit = 0;
+	bool freeit = false;
 
 	/*
 	 * check the bit again under the hash table lock.
@@ -491,7 +491,7 @@ static void __remove_rbio_from_cache(struct btrfs_raid_bio *rbio)
 	if (test_and_clear_bit(RBIO_CACHE_BIT, &rbio->flags)) {
 		list_del_init(&rbio->stripe_cache);
 		table->cache_size -= 1;
-		freeit = 1;
+		freeit = true;
 
 		/* if the bio list isn't empty, this rbio is
 		 * still involved in an IO.  We take it out
@@ -855,7 +855,7 @@ static noinline void unlock_stripe(struct btrfs_raid_bio *rbio)
 {
 	int bucket;
 	struct btrfs_stripe_hash *h;
-	int keep_cache = 0;
+	bool keep_cache = false;
 
 	bucket = rbio_bucket(rbio);
 	h = rbio->bioc->fs_info->stripe_hash_table->table + bucket;
@@ -874,7 +874,7 @@ static noinline void unlock_stripe(struct btrfs_raid_bio *rbio)
 		 */
 		if (list_empty(&rbio->plug_list) &&
 		    test_bit(RBIO_CACHE_BIT, &rbio->flags)) {
-			keep_cache = 1;
+			keep_cache = true;
 			clear_bit(RBIO_RMW_LOCKED_BIT, &rbio->flags);
 			BUG_ON(!bio_list_empty(&rbio->bio_list));
 			goto done;
@@ -2695,7 +2695,7 @@ static int finish_parity_scrub(struct btrfs_raid_bio *rbio)
 	phys_addr_t p_paddr = INVALID_PADDR;
 	phys_addr_t q_paddr = INVALID_PADDR;
 	struct bio_list bio_list;
-	int is_replace = 0;
+	bool is_replace = false;
 	int ret;
 
 	bio_list_init(&bio_list);
@@ -2712,7 +2712,7 @@ static int finish_parity_scrub(struct btrfs_raid_bio *rbio)
 	 * need to duplicate the final write to replace target.
 	 */
 	if (bioc->replace_nr_stripes && bioc->replace_stripe_src == rbio->scrubp) {
-		is_replace = 1;
+		is_replace = true;
 		bitmap_copy(pbitmap, &rbio->dbitmap, rbio->stripe_nsectors);
 	}
 
diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index 67af02e732d0ce..becc256ee6d9ec 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -701,7 +701,7 @@ int btrfs_init_reloc_root(struct btrfs_trans_handle *trans,
 	struct btrfs_root *reloc_root;
 	struct reloc_control *rc = fs_info->reloc_ctl;
 	struct btrfs_block_rsv *rsv;
-	int clear_rsv = 0;
+	bool clear_rsv = false;
 	int ret;
 
 	if (!rc)
@@ -738,7 +738,7 @@ int btrfs_init_reloc_root(struct btrfs_trans_handle *trans,
 	if (!trans->reloc_reserved) {
 		rsv = trans->block_rsv;
 		trans->block_rsv = rc->block_rsv;
-		clear_rsv = 1;
+		clear_rsv = true;
 	}
 	reloc_root = create_reloc_root(trans, root, btrfs_root_id(root));
 	if (clear_rsv)
@@ -868,7 +868,7 @@ int replace_file_extents(struct btrfs_trans_handle *trans,
 	u32 nritems;
 	u32 i;
 	int ret = 0;
-	int first = 1;
+	bool first = true;
 
 	if (rc->stage != UPDATE_DATA_PTRS)
 		return 0;
@@ -906,7 +906,7 @@ int replace_file_extents(struct btrfs_trans_handle *trans,
 		if (btrfs_root_id(root) != BTRFS_TREE_RELOC_OBJECTID) {
 			if (first) {
 				inode = btrfs_find_first_inode(root, key.objectid);
-				first = 0;
+				first = false;
 			} else if (inode && btrfs_ino(inode) < key.objectid) {
 				btrfs_add_delayed_iput(inode);
 				inode = btrfs_find_first_inode(root, key.objectid);
@@ -1020,7 +1020,7 @@ int replace_path(struct btrfs_trans_handle *trans, struct reloc_control *rc,
 	u64 new_ptr_gen;
 	u64 last_snapshot;
 	u32 blocksize;
-	int cow = 0;
+	bool cow = false;
 	int level;
 	int ret;
 	int slot;
@@ -1126,7 +1126,7 @@ int replace_path(struct btrfs_trans_handle *trans, struct reloc_control *rc,
 		if (!cow) {
 			btrfs_tree_unlock(parent);
 			free_extent_buffer(parent);
-			cow = 1;
+			cow = true;
 			goto again;
 		}
 
@@ -1514,7 +1514,7 @@ static noinline_for_stack int merge_reloc_root(struct reloc_control *rc,
 	int reserve_level;
 	int level;
 	int max_level;
-	int replaced = 0;
+	bool replaced = false;
 	int ret = 0;
 	u32 min_reserved;
 
@@ -1589,7 +1589,7 @@ static noinline_for_stack int merge_reloc_root(struct reloc_control *rc,
 		btrfs_set_root_last_trans(reloc_root, trans->transid);
 		trans->block_rsv = rc->block_rsv;
 
-		replaced = 0;
+		replaced = false;
 		max_level = level;
 
 		ret = walk_down_reloc_tree(reloc_root, path, &level);
@@ -1611,7 +1611,7 @@ static noinline_for_stack int merge_reloc_root(struct reloc_control *rc,
 			level = ret;
 			btrfs_node_key_to_cpu(path->nodes[level], &key,
 					      path->slots[level]);
-			replaced = 1;
+			replaced = true;
 		}
 
 		ret = walk_up_reloc_tree(reloc_root, path, &level);
@@ -1809,7 +1809,7 @@ void merge_reloc_roots(struct reloc_control *rc)
 	struct btrfs_root *root;
 	struct btrfs_root *reloc_root;
 	LIST_HEAD(reloc_roots);
-	int found = 0;
+	bool found = false;
 	int ret = 0;
 again:
 	root = rc->extent_root;
@@ -1825,7 +1825,7 @@ void merge_reloc_roots(struct reloc_control *rc)
 	mutex_unlock(&fs_info->reloc_mutex);
 
 	while (!list_empty(&reloc_roots)) {
-		found = 1;
+		found = true;
 		reloc_root = list_first_entry(&reloc_roots, struct btrfs_root, root_list);
 
 		root = btrfs_get_fs_root(fs_info, reloc_root->root_key.offset,
@@ -1878,7 +1878,7 @@ void merge_reloc_roots(struct reloc_control *rc)
 	}
 
 	if (found) {
-		found = 0;
+		found = false;
 		goto again;
 	}
 out:
@@ -5711,7 +5711,7 @@ int btrfs_reloc_cow_block(struct btrfs_trans_handle *trans,
 	struct btrfs_fs_info *fs_info = root->fs_info;
 	struct reloc_control *rc;
 	struct btrfs_backref_node *node;
-	int first_cow = 0;
+	bool first_cow = false;
 	int level;
 	int ret = 0;
 
@@ -5724,7 +5724,7 @@ int btrfs_reloc_cow_block(struct btrfs_trans_handle *trans,
 	level = btrfs_header_level(buf);
 	if (btrfs_header_generation(buf) <=
 	    btrfs_root_last_snapshot(&root->root_item))
-		first_cow = 1;
+		first_cow = true;
 
 	if (btrfs_root_id(root) == BTRFS_TREE_RELOC_OBJECTID && rc->create_reloc_tree) {
 		WARN_ON(!first_cow && level == 0);
diff --git a/fs/btrfs/root-tree.c b/fs/btrfs/root-tree.c
index d85a09ae173378..90659b287d90de 100644
--- a/fs/btrfs/root-tree.c
+++ b/fs/btrfs/root-tree.c
@@ -27,20 +27,20 @@ static void btrfs_read_root_item(struct extent_buffer *eb, int slot,
 				struct btrfs_root_item *item)
 {
 	u32 len;
-	int need_reset = 0;
+	bool need_reset = false;
 
 	len = btrfs_item_size(eb, slot);
 	read_extent_buffer(eb, item, btrfs_item_ptr_offset(eb, slot),
 			   min_t(u32, len, sizeof(*item)));
 	if (len < sizeof(*item))
-		need_reset = 1;
+		need_reset = true;
 	if (!need_reset && btrfs_root_generation(item)
 		!= btrfs_root_generation_v2(item)) {
 		if (btrfs_root_generation_v2(item) != 0) {
 			btrfs_warn(eb->fs_info,
 					"mismatching generation and generation_v2 found in root item. This root was probably mounted with an older kernel. Resetting all new fields.");
 		}
-		need_reset = 1;
+		need_reset = true;
 	}
 	if (need_reset) {
 		/* Clear all members from generation_v2 onwards. */
diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
index 89d72d8cb85fdf..9071ebd838b3a9 100644
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -2378,7 +2378,7 @@ static int get_cur_path(struct send_ctx *sctx, u64 ino, u64 gen,
 	struct fs_path *name = NULL;
 	u64 parent_inode = 0;
 	u64 parent_gen = 0;
-	int stop = 0;
+	bool stop = false;
 	const bool is_cur_inode = (ino == sctx->cur_ino && gen == sctx->cur_inode_gen);
 
 	if (is_cur_inode && fs_path_len(&sctx->cur_inode_path) > 0) {
@@ -2413,7 +2413,7 @@ static int get_cur_path(struct send_ctx *sctx, u64 ino, u64 gen,
 		wdm = get_waiting_dir_move(sctx, ino);
 		if (wdm && wdm->orphanized) {
 			ret = gen_unique_name(sctx, ino, gen, name);
-			stop = 1;
+			stop = true;
 		} else if (wdm) {
 			ret = get_first_ref(sctx->parent_root, ino,
 					    &parent_inode, &parent_gen, name);
@@ -2422,7 +2422,7 @@ static int get_cur_path(struct send_ctx *sctx, u64 ino, u64 gen,
 							&parent_inode,
 							&parent_gen, name);
 			if (ret)
-				stop = 1;
+				stop = true;
 		}
 
 		if (ret < 0)
@@ -3349,7 +3349,7 @@ static int add_pending_dir_move(struct send_ctx *sctx,
 	struct rb_node *parent = NULL;
 	struct pending_dir_move *entry = NULL, *pm;
 	struct recorded_ref *cur;
-	int exists = 0;
+	bool exists = false;
 	int ret;
 
 	pm = kmalloc_obj(*pm);
@@ -3370,7 +3370,7 @@ static int add_pending_dir_move(struct send_ctx *sctx,
 		} else if (parent_ino > entry->parent_ino) {
 			p = &(*p)->rb_right;
 		} else {
-			exists = 1;
+			exists = true;
 			break;
 		}
 	}
@@ -6559,10 +6559,10 @@ static int finish_inode_if_needed(struct send_ctx *sctx, bool at_end)
 	u64 right_uid;
 	u64 right_gid;
 	u64 right_fileattr;
-	int need_chmod = 0;
-	int need_chown = 0;
+	bool need_chmod = false;
+	bool need_chown = false;
 	bool need_fileattr = false;
-	int need_truncate = 1;
+	bool need_truncate = true;
 	int pending_move = 0;
 	int refs_processed = 0;
 
@@ -6602,11 +6602,11 @@ static int finish_inode_if_needed(struct send_ctx *sctx, bool at_end)
 	left_fileattr = info.fileattr;
 
 	if (!sctx->parent_root || sctx->cur_inode_new) {
-		need_chown = 1;
+		need_chown = true;
 		if (!S_ISLNK(sctx->cur_inode_mode))
-			need_chmod = 1;
+			need_chmod = true;
 		if (sctx->cur_inode_next_write_offset == sctx->cur_inode_size)
-			need_truncate = 0;
+			need_truncate = false;
 	} else {
 		u64 old_size;
 
@@ -6620,15 +6620,15 @@ static int finish_inode_if_needed(struct send_ctx *sctx, bool at_end)
 		right_fileattr = info.fileattr;
 
 		if (left_uid != right_uid || left_gid != right_gid)
-			need_chown = 1;
+			need_chown = true;
 		if (!S_ISLNK(sctx->cur_inode_mode) && left_mode != right_mode)
-			need_chmod = 1;
+			need_chmod = true;
 		if (!S_ISLNK(sctx->cur_inode_mode) && left_fileattr != right_fileattr)
 			need_fileattr = true;
 		if ((old_size == sctx->cur_inode_size) ||
 		    (sctx->cur_inode_size > old_size &&
 		     sctx->cur_inode_next_write_offset == sctx->cur_inode_size))
-			need_truncate = 0;
+			need_truncate = false;
 	}
 
 	if (S_ISREG(sctx->cur_inode_mode)) {
@@ -7986,7 +7986,7 @@ long btrfs_ioctl_send(struct btrfs_root *send_root, const struct btrfs_ioctl_sen
 	u64 *clone_sources_tmp = NULL;
 	int clone_sources_to_rollback = 0;
 	size_t alloc_size;
-	int sort_clone_roots = 0;
+	bool sort_clone_roots = false;
 	struct btrfs_lru_cache_entry *entry;
 	struct btrfs_lru_cache_entry *tmp;
 
@@ -8209,7 +8209,7 @@ long btrfs_ioctl_send(struct btrfs_root *send_root, const struct btrfs_ioctl_sen
 	sort(sctx->clone_roots, sctx->clone_roots_cnt,
 			sizeof(*sctx->clone_roots), __clone_root_cmp_sort,
 			NULL);
-	sort_clone_roots = 1;
+	sort_clone_roots = true;
 
 	ret = flush_delalloc_roots(sctx);
 	if (ret)
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 9de67276a8edd6..3dd34218285b3d 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -1737,7 +1737,7 @@ static int btrfs_statfs(struct dentry *dentry, struct kstatfs *buf)
 	struct btrfs_block_rsv *block_rsv = &fs_info->global_block_rsv;
 	int ret;
 	u64 thresh = 0;
-	int mixed = 0;
+	bool mixed = false;
 
 	list_for_each_entry(found, &fs_info->space_info, list) {
 		if (found->flags & BTRFS_BLOCK_GROUP_DATA) {
@@ -1759,7 +1759,7 @@ static int btrfs_statfs(struct dentry *dentry, struct kstatfs *buf)
 		 */
 		if (!mixed && found->flags & BTRFS_BLOCK_GROUP_METADATA) {
 			if (found->flags & BTRFS_BLOCK_GROUP_DATA)
-				mixed = 1;
+				mixed = true;
 			else
 				total_free_meta += found->disk_total -
 					found->disk_used;
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index a289a8fa237c8a..81146c24db4a19 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -2267,7 +2267,7 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans)
 	btrfs_create_pending_block_groups(trans);
 
 	if (!test_bit(BTRFS_TRANS_DIRTY_BG_RUN, &cur_trans->flags)) {
-		int run_it = 0;
+		bool run_it = false;
 
 		/* this mutex is also taken before trying to set
 		 * block groups readonly.  We need to make sure
@@ -2285,7 +2285,7 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans)
 		mutex_lock(&fs_info->ro_block_group_mutex);
 		if (!test_and_set_bit(BTRFS_TRANS_DIRTY_BG_RUN,
 				      &cur_trans->flags))
-			run_it = 1;
+			run_it = true;
 		mutex_unlock(&fs_info->ro_block_group_mutex);
 
 		if (run_it) {
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 93a923e4ecaf41..e58b5bbe630cb8 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -4361,7 +4361,7 @@ static int __btrfs_balance(struct btrfs_fs_info *fs_info)
 	u32 count_data = 0;
 	u32 count_meta = 0;
 	u32 count_sys = 0;
-	int chunk_reserved = 0;
+	bool chunk_reserved = false;
 	struct remap_chunk_info *rci;
 	unsigned int num_remap_chunks = 0;
 	LIST_HEAD(remap_chunks);
@@ -4530,7 +4530,7 @@ static int __btrfs_balance(struct btrfs_fs_info *fs_info)
 				mutex_unlock(&fs_info->reclaim_bgs_lock);
 				goto error;
 			} else if (ret == 1) {
-				chunk_reserved = 1;
+				chunk_reserved = true;
 			}
 		}
 
@@ -4791,7 +4791,7 @@ int btrfs_balance(struct btrfs_fs_info *fs_info,
 {
 	u64 meta_target, data_target;
 	u64 allowed;
-	int mixed = 0;
+	bool mixed = false;
 	int ret;
 	u64 num_devices;
 	unsigned seq;
@@ -4808,7 +4808,7 @@ int btrfs_balance(struct btrfs_fs_info *fs_info,
 
 	allowed = btrfs_super_incompat_flags(fs_info->super_copy);
 	if (allowed & BTRFS_FEATURE_INCOMPAT_MIXED_GROUPS)
-		mixed = 1;
+		mixed = true;
 
 	/*
 	 * In case of mixed groups both data and meta should be picked,
diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
index 5f75cf0e14b951..b7cf8de44e1822 100644
--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -1313,7 +1313,7 @@ static int btrfs_load_zone_info(struct btrfs_fs_info *fs_info, int zone_idx,
 {
 	struct btrfs_dev_replace *dev_replace = &fs_info->dev_replace;
 	struct btrfs_device *device;
-	int dev_replace_is_ongoing = 0;
+	bool dev_replace_is_ongoing = false;
 	unsigned int nofs_flag;
 	struct blk_zone zone;
 	int ret;
-- 
2.54.0

