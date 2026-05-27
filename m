Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 766DB3EF665
	for <linux-btrfs@vger.kernel.org>; Wed, 27 May 2026 11:16:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779880622; cv=none; b=tJPtz9Ji2zT3tVUzAOMNBWg5JB6nfZ6Jh9hZwpv9x/kAo8qK+6cGhumT/7Kbl1oEpEVDkA1PAD+1AGggMuRRvZd9clWucwDx99xICGYb+3aL38qy3uxt0La0W7wHfCe1Nl+obc/8s6XUblXjzsm+xXULP8X0CJE6S3BFkWDX1co=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779880622; c=relaxed/simple;
	bh=4sJbynu7iGddn0xcZZRwcIisZIHSdMDilpQpODJ9tVU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=CfciJNxHbrgQL2+3gd0JQz6COMZNF8xWUQ8bWKVVdPs0ZLAm/AxGJt9tCL+NKiMYdE0Zthq6nb9pbWDovO6a25fDuwGu6R4GF5aI++MPOevqoqQqyuBGJIOAzoQJnJhX/pKibUdUrjDO0EduzitM1vfFCSI57MewOD73VM/hZLM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=QI4Lgpib; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=QI4Lgpib; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="QI4Lgpib";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="QI4Lgpib"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 977E967082;
	Wed, 27 May 2026 11:16:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1779880614; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=/tAyMHmc05C69SwKnkr4CROcNIvzZkoIH4vn2lBvKKw=;
	b=QI4LgpibJyJw22KkkH9It7tmd6Jf65uaLy/osYvScKsWQkNECa/3UyhLNB7CVnuKiSJdUf
	FNP8I3Wprx7POmOd5jV1S+ThS0rOX6aRHbnkXnrSAYdoPUCmoKFuDiQvoIr24LfrPwpBmj
	d9DmYz8jQ3ayix/ul9bfPtOmLMuDH/c=
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1779880614; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=/tAyMHmc05C69SwKnkr4CROcNIvzZkoIH4vn2lBvKKw=;
	b=QI4LgpibJyJw22KkkH9It7tmd6Jf65uaLy/osYvScKsWQkNECa/3UyhLNB7CVnuKiSJdUf
	FNP8I3Wprx7POmOd5jV1S+ThS0rOX6aRHbnkXnrSAYdoPUCmoKFuDiQvoIr24LfrPwpBmj
	d9DmYz8jQ3ayix/ul9bfPtOmLMuDH/c=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 911B35A7D9;
	Wed, 27 May 2026 11:16:54 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id TMBrI6bSFmr9HgAAD6G6ig
	(envelope-from <dsterba@suse.com>); Wed, 27 May 2026 11:16:54 +0000
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH] btrfs: use shifts for sectorsize and nodesize
Date: Wed, 27 May 2026 13:16:52 +0200
Message-ID: <20260527111652.944584-1-dsterba@suse.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Level: 
X-Spam-Score: -2.78
X-Spam-Flag: NO
X-Spamd-Result: default: False [-2.78 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.18)[-0.888];
	MIME_GOOD(-0.10)[text/plain];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_TWO(0.00)[2];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,suse.com:mid,imap1.dmz-prg2.suse.org:helo]

Convert more multiplications of sectorsize or nodesize to use the
shifts. The remaining cases are multiplications by constants that
compiler can optimize by itself, and in tests.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/delalloc-space.c | 4 ++--
 fs/btrfs/disk-io.c        | 2 +-
 fs/btrfs/file-item.c      | 2 +-
 fs/btrfs/relocation.c     | 4 ++--
 fs/btrfs/transaction.c    | 2 +-
 5 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/fs/btrfs/delalloc-space.c b/fs/btrfs/delalloc-space.c
index 0970799d0aa443..5d5ff5a0280844 100644
--- a/fs/btrfs/delalloc-space.c
+++ b/fs/btrfs/delalloc-space.c
@@ -279,7 +279,7 @@ static void btrfs_calculate_inode_block_rsv_size(struct btrfs_fs_info *fs_info,
 	 *
 	 * This is overestimating in most cases.
 	 */
-	qgroup_rsv_size = (u64)outstanding_extents * fs_info->nodesize;
+	qgroup_rsv_size = ((u64)outstanding_extents << fs_info->nodesize_bits);
 
 	spin_lock(&block_rsv->lock);
 	block_rsv->size = reserve_size;
@@ -309,7 +309,7 @@ static void calc_inode_reservations(struct btrfs_inode *inode,
 	 * for an inode update.
 	 */
 	*meta_reserve += inode_update;
-	*qgroup_reserve = nr_extents * fs_info->nodesize;
+	*qgroup_reserve = (nr_extents << fs_info->nodesize_bits);
 }
 
 int btrfs_delalloc_reserve_metadata(struct btrfs_inode *inode, u64 num_bytes,
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index e6ed52f5cd6d99..590da1ba5de485 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -563,7 +563,7 @@ static bool btree_dirty_folio(struct address_space *mapping,
 			continue;
 		}
 		spin_unlock_irqrestore(&subpage->lock, flags);
-		cur = page_start + cur_bit * fs_info->sectorsize;
+		cur = page_start + (cur_bit << fs_info->sectorsize_bits);
 
 		eb = find_extent_buffer(fs_info, cur);
 		ASSERT(eb);
diff --git a/fs/btrfs/file-item.c b/fs/btrfs/file-item.c
index 82ae4a2afd3471..9f6454e9db8186 100644
--- a/fs/btrfs/file-item.c
+++ b/fs/btrfs/file-item.c
@@ -1309,7 +1309,7 @@ int btrfs_insert_data_csums(struct btrfs_trans_handle *trans,
 
 	index += ins_size;
 	ins_size /= csum_size;
-	total_bytes += ins_size * fs_info->sectorsize;
+	total_bytes += (ins_size << fs_info->sectorsize_bits);
 
 	if (total_bytes < sums->len) {
 		btrfs_release_path(path);
diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index 67af02e732d0ce..8212abc2d13652 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -1560,7 +1560,7 @@ static noinline_for_stack int merge_reloc_root(struct reloc_control *rc,
 	 * and * 2 since we have two trees to COW.
 	 */
 	reserve_level = max_t(int, 1, btrfs_root_level(root_item));
-	min_reserved = fs_info->nodesize * reserve_level * 2;
+	min_reserved = (reserve_level << fs_info->nodesize_bits) * 2;
 	memset(&next_key, 0, sizeof(next_key));
 
 	while (1) {
@@ -2558,7 +2558,7 @@ static int relocate_cowonly_block(struct btrfs_trans_handle *trans,
 
 	nr_levels = max(btrfs_header_level(root->node) - block->level, 0) + 1;
 
-	num_bytes = fs_info->nodesize * nr_levels;
+	num_bytes = (nr_levels << fs_info->nodesize_bits);
 	ret = refill_metadata_space(trans, rc, num_bytes);
 	if (ret) {
 		btrfs_put_root(root);
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index a289a8fa237c8a..2263cb6bd8ca47 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -631,7 +631,7 @@ start_transaction(struct btrfs_root *root, unsigned int num_items,
 	 * the appropriate flushing if need be.
 	 */
 	if (num_items && root != fs_info->chunk_root) {
-		qgroup_reserved = num_items * fs_info->nodesize;
+		qgroup_reserved = (num_items << fs_info->nodesize_bits);
 		/*
 		 * Use prealloc for now, as there might be a currently running
 		 * transaction that could free this reserved space prematurely
-- 
2.54.0

