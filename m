Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 412C9280A21
	for <linux-btrfs@vger.kernel.org>; Thu, 19 Mar 2026 21:05:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773954321; cv=none; b=aVc4P6KV55ZyfpP3VJHjfEE8n5YZ/rHP+I46VeKcHrSWdBrrXOpzCPGqeZUKK1HQU94c0FCwe7a6dFHo/Q4KDpjEr4rj2rS09Vh1j5CnJdDyArz2UJucC/6eQWZvdsb0AnOrKHrbl7TrayvFmeB+u5cKMzZs7Wb/pEn3xOuyzuc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773954321; c=relaxed/simple;
	bh=lqUJoTM75V7GuF/7ON8KqezeLDngmHp9DwFzNH4Q6vk=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hss0JvJfbb1ecRF5qCCbuoEhNMmZ2pSjZHA/Y/2wtLyH8vNZjA4WF2JKWoxLhf6kyB8ouG6bjMdQMr9mEkLKo9I/2NovbrJDdV5NBlpr5t0Kax4+n2fH/HhyMBt5MZ5XBcHpoytJBtBqNtyfc5cpDsK835UBboJiGjcYeYFmN98=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=C9CPqsQC; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=XDRQwoXK; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="C9CPqsQC";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="XDRQwoXK"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id E5F255BDD4
	for <linux-btrfs@vger.kernel.org>; Thu, 19 Mar 2026 21:05:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1773954313; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TbnaGAWPcbG8ZqeInEsEeLSghrGwW1aGAPrh4xSudUM=;
	b=C9CPqsQCAuJINWlwXCx4TJ/tVuelVL2MPZm9fvM6lmOimDmSmtasDdVyjwGPQ9OxjW3P7z
	HyR3Nqt3vCqtrAQDQ0vc/wJwoAQHFtGgeDSllDxBxQ5Q71HMw4Q1JrwW/dnm2r3Ob46IMd
	whaMzz7lOkPyctM3qBWO+zSt9bA/ZOA=
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=XDRQwoXK
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1773954312; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TbnaGAWPcbG8ZqeInEsEeLSghrGwW1aGAPrh4xSudUM=;
	b=XDRQwoXKfz4+R1KyGCS8Y5qOJwhFCIhHHEV/6DXNE6Tvdr0xxGJAOnRfyO3OubCVzqhcox
	bovGUCr0AlhEYBx3+qzBx3kx9YIJ7251Y6vUjWf2GOtl3Ogdxme8ptWGHNLFlqh0GyMmML
	nkaj5oCsa7nmvrk9azWmIKnE7uDLkuc=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id E6D3A4273B
	for <linux-btrfs@vger.kernel.org>; Thu, 19 Mar 2026 21:05:11 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id gBD6JAdlvGk5FAAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Thu, 19 Mar 2026 21:05:11 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 2/6] btrfs: add delayed ordered extent support
Date: Fri, 20 Mar 2026 07:34:46 +1030
Message-ID: <f8094c4ef18252c05afd7268314bbcdbaf09e9a2.1773953307.git.wqu@suse.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1773953307.git.wqu@suse.com>
References: <cover.1773953307.git.wqu@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-3.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCPT_COUNT_ONE(0.00)[1];
	ARC_NA(0.00)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	MIME_TRACE(0.00)[0:+];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	RCVD_TLS_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.com:+];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	TO_DN_NONE(0.00)[];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from,2a07:de40:b281:106:10:150:64:167:received];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:mid,suse.com:dkim,suse.com:email,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns]
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spam-Score: -3.01
X-Spam-Level: 
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Queue-Id: E5F255BDD4

A delayed ordered extent has the following features:

- A new BTRFS_ORDERED_DELAYED flag
  And this new flag must be set along BTRFS_ORDERED_REGULAR flag.

- No allocation of any on-disk space
  As a delayed ordered extent doesn't take any on-disk space yet, it
  won't release any reserved data/meta space either.

- Zero or more real OEs can be added to the parent
  If a real OE is allocated, it must be inside the parent OE.
  And such real OE will go through the regular data/meta space
  reservation path.

- Children OEs will not be added to the per-inode OE rb-tree nor
  per-root list
  Only the parent OE is added to the per-inode rb-tree and per-root
  list.
  So anything waiting for ordered extents should only work on the parent
  one.

  There is a special corner case to btrfs_wait_ordered_extents(), as
  delayed parent OEs have 0 disk_bytenr and disk_num_bytes, they will
  be considered out of the [0, U64_MAX] range.
  Thus we have to always wait for any delayed OEs of a root, no matter
  if a block group range is given or not.

- When the parent OE finishes, all children OEs will also be finished
  And reserved space handling is all handled by the children OEs.

- Any range not covered by child OE will be manually cleaned up

Above features allows us to use the existing ordered extent interfaces
to allocate new real OEs, and wait for them properly.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/inode.c        |  76 +++++++++++++++++
 fs/btrfs/ordered-data.c | 181 ++++++++++++++++++++++++++++++----------
 fs/btrfs/ordered-data.h |  14 ++++
 3 files changed, 225 insertions(+), 46 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 0551b8e755ed..799e3d5c80f3 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -3162,6 +3162,79 @@ static int insert_ordered_extent_file_extent(struct btrfs_trans_handle *trans,
 					   update_inode_bytes, oe->qgroup_rsv);
 }
 
+static int finish_delayed_ordered(struct btrfs_ordered_extent *oe)
+{
+	struct btrfs_inode *inode = oe->inode;
+	struct btrfs_fs_info *fs_info = inode->root->fs_info;
+	struct btrfs_ordered_extent *child;
+	struct btrfs_ordered_extent *tmp;
+	struct extent_state *cached = NULL;
+	const u32 nr_bits = oe->num_bytes >> fs_info->sectorsize_bits;
+	bool io_error = test_bit(BTRFS_ORDERED_IOERR, &oe->flags);
+	u64 cur = oe->file_offset;
+	int ret = 0;
+	int saved_ret = 0;
+
+	/* Finish each child OE. */
+	list_for_each_entry_safe(child, tmp, &oe->child_list, child_list) {
+		list_del_init(&child->child_list);
+		refcount_inc(&child->refs);
+
+		/* The range should have been marked in the bitmap. */
+		ASSERT(bitmap_test_range_all_set(oe->child_bitmap,
+			(child->file_offset - oe->file_offset) >> fs_info->sectorsize_bits,
+			child->num_bytes >> fs_info->sectorsize_bits));
+
+		if (io_error)
+			set_bit(BTRFS_ORDERED_IOERR, &child->flags);
+
+		ret = btrfs_finish_one_ordered(child);
+		if (ret && !saved_ret)
+			saved_ret = ret;
+	}
+
+	/* For ranges that doesn't have a child OE, manually clean them up. */
+	while (cur < oe->file_offset + oe->num_bytes) {
+		const u32 cur_bit = (cur - oe->file_offset) >> fs_info->sectorsize_bits;
+		u32 first_zero;
+		u32 next_set;
+		u64 range_start;
+		u64 range_end;
+		u32 range_len;
+
+		first_zero = find_next_zero_bit(oe->child_bitmap, nr_bits, cur_bit);
+		if (first_zero >= nr_bits)
+			break;
+		next_set = find_next_bit(oe->child_bitmap, nr_bits, first_zero);
+		ASSERT(next_set > first_zero);
+
+		range_start = oe->file_offset + (first_zero << fs_info->sectorsize_bits);
+		range_len = (next_set - first_zero) << fs_info->sectorsize_bits;
+		range_end = range_start + range_len - 1;
+
+		btrfs_lock_extent(&inode->io_tree, range_start, range_end, &cached);
+		/*
+		 * The range has reserved data/metadata but no real OE, thus we have
+		 * to manually release them.
+		 */
+		btrfs_delalloc_release_space(inode, NULL, range_start, range_len, true);
+		/*
+		 * Also need to remove/drop the pinned extent map range.
+		 * Here we do not want the extent map to stay, as they do not represent
+		 * any real extent map.
+		 */
+		btrfs_drop_extent_map_range(inode, range_start, range_end, false);
+		btrfs_clear_extent_bit(&inode->io_tree, range_start, range_end,
+				EXTENT_LOCKED | EXTENT_DELALLOC_NEW | EXTENT_DEFRAG |
+				EXTENT_DO_ACCOUNTING, &cached);
+		cur = range_end + 1;
+	}
+	btrfs_remove_ordered_extent(oe);
+	btrfs_put_ordered_extent(oe);
+	btrfs_put_ordered_extent(oe);
+	return saved_ret;
+}
+
 /*
  * As ordered data IO finishes, this gets called so we can finish
  * an ordered extent if the range of bytes in the file it covers are
@@ -3184,6 +3257,9 @@ int btrfs_finish_one_ordered(struct btrfs_ordered_extent *ordered_extent)
 	bool clear_reserved_extent = true;
 	unsigned int clear_bits = EXTENT_DEFRAG;
 
+	if (test_bit(BTRFS_ORDERED_DELAYED, &ordered_extent->flags))
+		return finish_delayed_ordered(ordered_extent);
+
 	start = ordered_extent->file_offset;
 	end = start + ordered_extent->num_bytes - 1;
 
diff --git a/fs/btrfs/ordered-data.c b/fs/btrfs/ordered-data.c
index bc88b904d024..c013609b6192 100644
--- a/fs/btrfs/ordered-data.c
+++ b/fs/btrfs/ordered-data.c
@@ -155,6 +155,7 @@ static struct btrfs_ordered_extent *alloc_ordered_extent(
 	u64 qgroup_rsv = 0;
 	const bool is_nocow = (flags &
 	       ((1U << BTRFS_ORDERED_NOCOW) | (1U << BTRFS_ORDERED_PREALLOC)));
+	const bool is_delayed = test_bit(BTRFS_ORDERED_DELAYED, &flags);
 
 	/* Only one type flag can be set. */
 	ASSERT(hweight_long(flags & BTRFS_ORDERED_EXCLUSIVE_FLAGS) == 1);
@@ -169,6 +170,17 @@ static struct btrfs_ordered_extent *alloc_ordered_extent(
 	if (test_bit(BTRFS_ORDERED_ENCODED, &flags))
 		ASSERT(test_bit(BTRFS_ORDERED_COMPRESSED, &flags));
 
+	/*
+	 * DELAYED can only be set with REGULAR, no DIRECT/ENCODED, and should
+	 * not exceed BTRFS_MAX_COMPRESSED size.
+	 */
+	if (test_bit(BTRFS_ORDERED_DELAYED, &flags)) {
+		ASSERT(test_bit(BTRFS_ORDERED_REGULAR, &flags));
+		ASSERT(!test_bit(BTRFS_ORDERED_DIRECT, &flags));
+		ASSERT(!test_bit(BTRFS_ORDERED_ENCODED, &flags));
+		ASSERT(num_bytes <= BTRFS_MAX_COMPRESSED);
+	}
+
 	/*
 	 * For a NOCOW write we can free the qgroup reserve right now. For a COW
 	 * one we transfer the reserved space from the inode's iotree into the
@@ -177,13 +189,14 @@ static struct btrfs_ordered_extent *alloc_ordered_extent(
 	 * completing the ordered extent, when running the data delayed ref it
 	 * creates, we free the reserved data with btrfs_qgroup_free_refroot().
 	 */
-	if (is_nocow)
-		ret = btrfs_qgroup_free_data(inode, NULL, file_offset, num_bytes, &qgroup_rsv);
-	else
-		ret = btrfs_qgroup_release_data(inode, file_offset, num_bytes, &qgroup_rsv);
-
-	if (ret < 0)
-		return ERR_PTR(ret);
+	if (!is_delayed) {
+		if (is_nocow)
+			ret = btrfs_qgroup_free_data(inode, NULL, file_offset, num_bytes, &qgroup_rsv);
+		else
+			ret = btrfs_qgroup_release_data(inode, file_offset, num_bytes, &qgroup_rsv);
+		if (ret < 0)
+			return ERR_PTR(ret);
+	}
 
 	entry = kmem_cache_zalloc(btrfs_ordered_extent_cache, GFP_NOFS);
 	if (!entry) {
@@ -215,19 +228,23 @@ static struct btrfs_ordered_extent *alloc_ordered_extent(
 	INIT_LIST_HEAD(&entry->root_extent_list);
 	INIT_LIST_HEAD(&entry->work_list);
 	INIT_LIST_HEAD(&entry->bioc_list);
+	INIT_LIST_HEAD(&entry->child_list);
 	init_completion(&entry->completion);
+	RB_CLEAR_NODE(&entry->rb_node);
 
 	/*
 	 * We don't need the count_max_extents here, we can assume that all of
 	 * that work has been done at higher layers, so this is truly the
 	 * smallest the extent is going to get.
 	 */
-	spin_lock(&inode->lock);
-	btrfs_mod_outstanding_extents(inode, 1);
-	spin_unlock(&inode->lock);
+	if (!is_delayed) {
+		spin_lock(&inode->lock);
+		btrfs_mod_outstanding_extents(inode, 1);
+		spin_unlock(&inode->lock);
+	}
 
 out:
-	if (IS_ERR(entry) && !is_nocow)
+	if (IS_ERR(entry) && !is_nocow && !is_delayed)
 		btrfs_qgroup_free_refroot(inode->root->fs_info,
 					  btrfs_root_id(inode->root),
 					  qgroup_rsv, BTRFS_QGROUP_RSV_DATA);
@@ -235,12 +252,43 @@ static struct btrfs_ordered_extent *alloc_ordered_extent(
 	return entry;
 }
 
+static void add_child_oe(struct btrfs_ordered_extent *parent,
+			 struct btrfs_ordered_extent *child)
+{
+	struct btrfs_inode *inode = parent->inode;
+	struct btrfs_fs_info *fs_info = inode->root->fs_info;
+	const u32 start_bit = (child->file_offset - parent->file_offset) >>
+			      fs_info->sectorsize_bits;
+	const u32 nr_bits = child->num_bytes >> fs_info->sectorsize_bits;
+
+	lockdep_assert_held(&inode->ordered_tree_lock);
+	/* Basic flags check for parent and child. */
+	ASSERT(test_bit(BTRFS_ORDERED_DELAYED, &parent->flags));
+	ASSERT(!test_bit(BTRFS_ORDERED_DELAYED, &child->flags));
+
+	/* Child should not belong to any parent yet. */
+	ASSERT(list_empty(&child->child_list));
+
+	/* Child should be fully inside parent's range. */
+	ASSERT(child->file_offset >= parent->file_offset);
+	ASSERT(child->file_offset + child->num_bytes <=
+	       parent->file_offset + parent->num_bytes);
+
+	/* There should be no existing child in the range. */
+	ASSERT(bitmap_test_range_all_zero(parent->child_bitmap, start_bit, nr_bits));
+
+	list_add_tail(&child->child_list, &parent->child_list);
+
+	bitmap_set(parent->child_bitmap, start_bit, nr_bits);
+}
+
 static void insert_ordered_extent(struct btrfs_ordered_extent *entry)
 {
 	struct btrfs_inode *inode = entry->inode;
 	struct btrfs_root *root = inode->root;
 	struct btrfs_fs_info *fs_info = root->fs_info;
 	struct rb_node *node;
+	bool is_child = false;
 
 	trace_btrfs_ordered_extent_add(inode, entry);
 
@@ -253,17 +301,25 @@ static void insert_ordered_extent(struct btrfs_ordered_extent *entry)
 	spin_lock(&inode->ordered_tree_lock);
 	node = tree_insert(&inode->ordered_tree, entry->file_offset,
 			   &entry->rb_node);
-	if (unlikely(node)) {
+	if (node) {
 		struct btrfs_ordered_extent *exist =
 			rb_entry(node, struct btrfs_ordered_extent, rb_node);
 
-		btrfs_panic(fs_info, -EEXIST,
+		if (test_bit(BTRFS_ORDERED_DELAYED, &exist->flags)) {
+			add_child_oe(exist, entry);
+			is_child = true;
+		} else {
+			btrfs_panic(fs_info, -EEXIST,
 "existing oe file_offset=%llu num_bytes=%llu flags=0x%lx new oe file_offset=%llu num_bytes=%llu flags=0x%lx",
-			    exist->file_offset, exist->num_bytes, exist->flags,
-			    entry->file_offset, entry->num_bytes, entry->flags);
+				    exist->file_offset, exist->num_bytes, exist->flags,
+				    entry->file_offset, entry->num_bytes, entry->flags);
+		}
 	}
 	spin_unlock(&inode->ordered_tree_lock);
 
+	/* Child OE shouldn't be added to per-root oe list. */
+	if (is_child)
+		return;
 	spin_lock(&root->ordered_extent_lock);
 	list_add_tail(&entry->root_extent_list,
 		      &root->ordered_extents);
@@ -336,6 +392,20 @@ struct btrfs_ordered_extent *btrfs_alloc_ordered_extent(
 	return entry;
 }
 
+struct btrfs_ordered_extent *btrfs_alloc_delayed_ordered_extent(
+			struct btrfs_inode *inode, u64 file_offset, u32 length)
+{
+	struct btrfs_ordered_extent *entry;
+
+	entry = alloc_ordered_extent(inode, file_offset, length, length, 0, 0, 0,
+				     (1UL << BTRFS_ORDERED_REGULAR) |
+				     (1UL << BTRFS_ORDERED_DELAYED),
+				     BTRFS_COMPRESS_NONE);
+	if (!IS_ERR(entry))
+		insert_ordered_extent(entry);
+	return entry;
+}
+
 /*
  * Add a struct btrfs_ordered_sum into the list of checksums to be inserted
  * when an ordered extent is finished.  If the list covers more than one
@@ -643,8 +713,9 @@ void btrfs_remove_ordered_extent(struct btrfs_ordered_extent *entry)
 	struct btrfs_root *root = btrfs_inode->root;
 	struct btrfs_fs_info *fs_info = root->fs_info;
 	struct rb_node *node;
-	bool pending;
+	bool pending = false;
 	bool freespace_inode;
+	const bool is_delayed = test_bit(BTRFS_ORDERED_DELAYED, &entry->flags);
 
 	/*
 	 * If this is a free space inode the thread has not acquired the ordered
@@ -653,33 +724,37 @@ void btrfs_remove_ordered_extent(struct btrfs_ordered_extent *entry)
 	freespace_inode = btrfs_is_free_space_inode(btrfs_inode);
 
 	btrfs_lockdep_acquire(fs_info, btrfs_trans_pending_ordered);
-	/* This is paired with alloc_ordered_extent(). */
-	spin_lock(&btrfs_inode->lock);
-	btrfs_mod_outstanding_extents(btrfs_inode, -1);
-	spin_unlock(&btrfs_inode->lock);
-	if (root != fs_info->tree_root) {
-		u64 release;
+	if (!is_delayed) {
+		/* This is paired with alloc_ordered_extent(). */
+		spin_lock(&btrfs_inode->lock);
+		btrfs_mod_outstanding_extents(btrfs_inode, -1);
+		spin_unlock(&btrfs_inode->lock);
 
-		if (test_bit(BTRFS_ORDERED_ENCODED, &entry->flags))
-			release = entry->disk_num_bytes;
-		else
-			release = entry->num_bytes;
-		btrfs_delalloc_release_metadata(btrfs_inode, release,
+		if (root != fs_info->tree_root) {
+			u64 release;
+
+			if (test_bit(BTRFS_ORDERED_ENCODED, &entry->flags))
+				release = entry->disk_num_bytes;
+			else
+				release = entry->num_bytes;
+			btrfs_delalloc_release_metadata(btrfs_inode, release,
 						test_bit(BTRFS_ORDERED_IOERR,
 							 &entry->flags));
+		}
 	}
-
 	percpu_counter_add_batch(&fs_info->ordered_bytes, -entry->num_bytes,
 				 fs_info->delalloc_batch);
 
 	spin_lock(&btrfs_inode->ordered_tree_lock);
-	node = &entry->rb_node;
-	rb_erase(node, &btrfs_inode->ordered_tree);
-	RB_CLEAR_NODE(node);
-	if (btrfs_inode->ordered_tree_last == node)
-		btrfs_inode->ordered_tree_last = NULL;
-	set_bit(BTRFS_ORDERED_COMPLETE, &entry->flags);
-	pending = test_and_clear_bit(BTRFS_ORDERED_PENDING, &entry->flags);
+	if (!RB_EMPTY_NODE(&entry->rb_node)) {
+		node = &entry->rb_node;
+		rb_erase(node, &btrfs_inode->ordered_tree);
+		RB_CLEAR_NODE(node);
+		if (btrfs_inode->ordered_tree_last == node)
+			btrfs_inode->ordered_tree_last = NULL;
+		set_bit(BTRFS_ORDERED_COMPLETE, &entry->flags);
+		pending = test_and_clear_bit(BTRFS_ORDERED_PENDING, &entry->flags);
+	}
 	spin_unlock(&btrfs_inode->ordered_tree_lock);
 
 	/*
@@ -711,17 +786,21 @@ void btrfs_remove_ordered_extent(struct btrfs_ordered_extent *entry)
 
 	btrfs_lockdep_release(fs_info, btrfs_trans_pending_ordered);
 
-	spin_lock(&root->ordered_extent_lock);
-	list_del_init(&entry->root_extent_list);
-	root->nr_ordered_extents--;
-
 	trace_btrfs_ordered_extent_remove(btrfs_inode, entry);
 
-	if (!root->nr_ordered_extents) {
-		spin_lock(&fs_info->ordered_root_lock);
-		BUG_ON(list_empty(&root->ordered_root));
-		list_del_init(&root->ordered_root);
-		spin_unlock(&fs_info->ordered_root_lock);
+	spin_lock(&root->ordered_extent_lock);
+	/* For child OEs, they are not added to per-root OEs. */
+	if (!list_empty(&entry->root_extent_list)) {
+		list_del_init(&entry->root_extent_list);
+		root->nr_ordered_extents--;
+
+
+		if (!root->nr_ordered_extents) {
+			spin_lock(&fs_info->ordered_root_lock);
+			BUG_ON(list_empty(&root->ordered_root));
+			list_del_init(&root->ordered_root);
+			spin_unlock(&fs_info->ordered_root_lock);
+		}
 	}
 	spin_unlock(&root->ordered_extent_lock);
 	wake_up(&entry->wait);
@@ -770,8 +849,18 @@ u64 btrfs_wait_ordered_extents(struct btrfs_root *root, u64 nr,
 		ordered = list_first_entry(&splice, struct btrfs_ordered_extent,
 					   root_extent_list);
 
-		if (range_end <= ordered->disk_bytenr ||
-		    ordered->disk_bytenr + ordered->disk_num_bytes <= range_start) {
+		/*
+		 * Delayed OEs have 0 disk_bytenr and 0 disk_num_bytes, thus
+		 * they will be considered out of the [0, U64_MAX) range.
+		 * And we do not know where they will really land until the
+		 * writeback finished.
+		 *
+		 * So here we must exclude delayed OEs from the bg range check,
+		 * and always wait for them.
+		 */
+		if (!test_bit(BTRFS_ORDERED_DELAYED, &ordered->flags) &&
+		    (range_end <= ordered->disk_bytenr ||
+		     ordered->disk_bytenr + ordered->disk_num_bytes <= range_start)) {
 			list_move_tail(&ordered->root_extent_list, &skipped);
 			cond_resched_lock(&root->ordered_extent_lock);
 			continue;
diff --git a/fs/btrfs/ordered-data.h b/fs/btrfs/ordered-data.h
index 2664ea455229..8a1800f109e8 100644
--- a/fs/btrfs/ordered-data.h
+++ b/fs/btrfs/ordered-data.h
@@ -13,6 +13,7 @@
 #include <linux/rbtree.h>
 #include <linux/wait.h>
 #include "async-thread.h"
+#include "compression.h"
 
 struct inode;
 struct page;
@@ -87,6 +88,12 @@ enum {
 	 */
 	BTRFS_ORDERED_DIRECT,
 
+	/*
+	 * Extra bit for delayed OE, can only be set for REGULAR.
+	 * Can not be set with COMPRESSED/ENCODED/DIRECT.
+	 */
+	BTRFS_ORDERED_DELAYED,
+
 	BTRFS_ORDERED_NR_FLAGS,
 };
 static_assert(BTRFS_ORDERED_NR_FLAGS <= BITS_PER_LONG);
@@ -155,6 +162,11 @@ struct btrfs_ordered_extent {
 	/* a per root list of all the pending ordered extents */
 	struct list_head root_extent_list;
 
+	/* Child ordered extent list for delayed OE. */
+	struct list_head child_list;
+
+	unsigned long child_bitmap[BITS_TO_LONGS(BTRFS_MAX_COMPRESSED / BTRFS_MIN_BLOCKSIZE)];
+
 	struct btrfs_work work;
 
 	struct completion completion;
@@ -192,6 +204,8 @@ struct btrfs_file_extent {
 struct btrfs_ordered_extent *btrfs_alloc_ordered_extent(
 			struct btrfs_inode *inode, u64 file_offset,
 			const struct btrfs_file_extent *file_extent, unsigned long flags);
+struct btrfs_ordered_extent *btrfs_alloc_delayed_ordered_extent(
+			struct btrfs_inode *inode, u64 file_offset, u32 length);
 void btrfs_add_ordered_sum(struct btrfs_ordered_extent *entry,
 			   struct btrfs_ordered_sum *sum);
 struct btrfs_ordered_extent *btrfs_lookup_ordered_extent(struct btrfs_inode *inode,
-- 
2.53.0

