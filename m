Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 842E01F1513
	for <linux-btrfs@vger.kernel.org>; Sun, 26 Jul 2026 23:20:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785108022; cv=none; b=flLpECVhwCzyE/O3ElFO5ZFkOa956VmRvfh+1+bskq3+J06m0U6in5L9ZjGWNlcmlpMMiHbBPPxpt212FrcUpstNePaKN4DcnPBqWhAj5b5t/avW7pzvuelrF5J1FE/7B9mbJ+wkUHlnJ/LNcKe+PyFqmR5YwcxcGeEewXIJMXI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785108022; c=relaxed/simple;
	bh=RL2C+sSSVU+abGQw8zzMqg9vL3tZTTIkR8iby57Kv3M=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=UNJpo+aAYMA86bZP+S+Tx+bXiShVGAs+9YMTsIyq0FfOVdawWUmzTQQdvyCN0wTcObJLrlmQsn6fQkeB9NCXndExvfrSTu1LZaXFbc/A9fLsly9W8eo8ODtvPWmIY09O/zwMzAfF4ShmuyMutrQCBel3ADTmBT3RlN6cHKMJsOo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=COC4c9RW; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=Sr/0X1y4; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="COC4c9RW";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="Sr/0X1y4"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 1E2BA7D836
	for <linux-btrfs@vger.kernel.org>; Sun, 26 Jul 2026 23:20:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1785108014; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=lYkNSm6E0ekh1gwRvbOA2FEasmoAZtk8fsy2xpCsWxs=;
	b=COC4c9RWSB7bqCsogOEM48H+J1K4SuCB7Bd/BUwpkRqYMpRfihz63C1K8uuZafauyfBVqm
	58+5+ShjGFt284DtsGA28yMlIaCJPn2p7IcHPBgT2I6N49G/+OJFMcZqhGVsXz4iMxgsWw
	PnBJRC7wQADmWhHAU2tTAN91tcYzco8=
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b="Sr/0X1y4"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1785108010; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=lYkNSm6E0ekh1gwRvbOA2FEasmoAZtk8fsy2xpCsWxs=;
	b=Sr/0X1y4Yjtx8HPbm6Fnzg1QQ2Ij+T1dd3u/FdJoF6MxJ2uciEAA80hxUTUrbGjLM43nXn
	vPaHU74oCDEHOFbHKH2zv6N7Sp87aI4rxX0FW/0EqD7rLSD383ReTzudH1aZAeoUB7fSxM
	57GX5aMtO/Ge0mDnjH/9C8QEegynGrI=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 1EBC8779B9
	for <linux-btrfs@vger.kernel.org>; Sun, 26 Jul 2026 23:20:08 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id dluYLyiWZmoKawAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Sun, 26 Jul 2026 23:20:08 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs: convert reflink.c to use btrfs_inode as parameters
Date: Mon, 27 Jul 2026 08:49:46 +0930
Message-ID: <36ca71a749dbd364736747bc23c3ca8c44ef6cbc.1785107778.git.wqu@suse.com>
X-Mailer: git-send-email 2.54.0
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
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCPT_COUNT_ONE(0.00)[1];
	ARC_NA(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	MIME_TRACE(0.00)[0:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.com:email,suse.com:mid,suse.com:dkim];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from,2a07:de40:b281:106:10:150:64:167:received];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	RCVD_TLS_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.com:+]
X-Spam-Flag: NO
X-Spam-Score: -3.01
X-Spam-Level: 
X-Rspamd-Queue-Id: 1E2BA7D836
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Action: no action

Inside reflink.c we still have a lot of functions passing vanilla inode
pointers, then internally convert them into btrfs_inode pointers.

For example, inside btrfs_clone(), we have 12 BTRFS_I() call sites,
meanwhile only 3 callsites that really require a vanilla inode pointer.

This patch do the cleanup to convert the following functions to pass a
btrfs_inode pointer instead of a vanilla inode pointer:

- btrfs_clone()
- btrfs_extent_same_range()
- clone_finish_inode_update().

Which covers all ad-hoc BTRFS_I() call sites inside reflink.c.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/reflink.c | 96 +++++++++++++++++++++++-----------------------
 1 file changed, 48 insertions(+), 48 deletions(-)

diff --git a/fs/btrfs/reflink.c b/fs/btrfs/reflink.c
index 28bb05a92106..a3b71d2067b7 100644
--- a/fs/btrfs/reflink.c
+++ b/fs/btrfs/reflink.c
@@ -20,17 +20,18 @@
 #define BTRFS_MAX_DEDUPE_LEN	SZ_16M
 
 static int clone_finish_inode_update(struct btrfs_trans_handle *trans,
-				     struct inode *inode,
+				     struct btrfs_inode *inode,
 				     u64 endoff,
 				     const u64 destoff,
 				     const u64 olen,
 				     bool no_time_update)
 {
+	struct inode *vfs_inode = &inode->vfs_inode;
 	int ret;
 
-	inode_inc_iversion(inode);
+	inode_inc_iversion(vfs_inode);
 	if (!no_time_update) {
-		inode_set_mtime_to_ts(inode, inode_set_ctime_current(inode));
+		inode_set_mtime_to_ts(vfs_inode, inode_set_ctime_current(vfs_inode));
 	}
 	/*
 	 * We round up to the block size at eof when determining which
@@ -38,12 +39,12 @@ static int clone_finish_inode_update(struct btrfs_trans_handle *trans,
 	 */
 	if (endoff > destoff + olen)
 		endoff = destoff + olen;
-	if (endoff > inode->i_size) {
-		i_size_write(inode, endoff);
-		btrfs_inode_safe_disk_i_size_write(BTRFS_I(inode), 0);
+	if (endoff > vfs_inode->i_size) {
+		i_size_write(vfs_inode, endoff);
+		btrfs_inode_safe_disk_i_size_write(inode, 0);
 	}
 
-	ret = btrfs_update_inode(trans, BTRFS_I(inode));
+	ret = btrfs_update_inode(trans, inode);
 	if (unlikely(ret)) {
 		btrfs_abort_transaction(trans, ret);
 		btrfs_end_transaction(trans);
@@ -392,11 +393,11 @@ static int clone_copy_inline_extent(struct btrfs_inode *inode,
  * @destoff:         Offset within @inode to start clone
  * @no_time_update:  Whether to update mtime/ctime on the target inode
  */
-static int btrfs_clone(struct inode *src, struct inode *inode,
+static int btrfs_clone(struct btrfs_inode *src, struct btrfs_inode *inode,
 		       const u64 off, const u64 olen, const u64 olen_aligned,
 		       const u64 destoff, bool no_time_update)
 {
-	struct btrfs_fs_info *fs_info = inode_to_fs_info(inode);
+	struct btrfs_fs_info *fs_info = inode->root->fs_info;
 	BTRFS_PATH_AUTO_FREE(path);
 	struct extent_buffer *leaf;
 	struct btrfs_trans_handle *trans;
@@ -420,7 +421,7 @@ static int btrfs_clone(struct inode *src, struct inode *inode,
 
 	path->reada = READA_FORWARD;
 	/* Clone data */
-	key.objectid = btrfs_ino(BTRFS_I(src));
+	key.objectid = btrfs_ino(src);
 	key.type = BTRFS_EXTENT_DATA_KEY;
 	key.offset = off;
 
@@ -436,8 +437,7 @@ static int btrfs_clone(struct inode *src, struct inode *inode,
 		u64 drop_start;
 
 		/* Note the key will change type as we walk through the tree */
-		ret = btrfs_search_slot(NULL, BTRFS_I(src)->root, &key, path,
-				0, 0);
+		ret = btrfs_search_slot(NULL, src->root, &key, path, 0, 0);
 		if (ret < 0)
 			goto out;
 		/*
@@ -455,7 +455,7 @@ static int btrfs_clone(struct inode *src, struct inode *inode,
 		nritems = btrfs_header_nritems(path->nodes[0]);
 process_slot:
 		if (path->slots[0] >= nritems) {
-			ret = btrfs_next_leaf(BTRFS_I(src)->root, path);
+			ret = btrfs_next_leaf(src->root, path);
 			if (ret < 0)
 				goto out;
 			if (ret > 0)
@@ -467,7 +467,7 @@ static int btrfs_clone(struct inode *src, struct inode *inode,
 
 		btrfs_item_key_to_cpu(leaf, &key, slot);
 		if (key.type > BTRFS_EXTENT_DATA_KEY ||
-		    key.objectid != btrfs_ino(BTRFS_I(src)))
+		    key.objectid != btrfs_ino(src))
 			break;
 
 		ASSERT(key.type == BTRFS_EXTENT_DATA_KEY, "key.type=%u", key.type);
@@ -514,7 +514,7 @@ static int btrfs_clone(struct inode *src, struct inode *inode,
 		btrfs_release_path(path);
 
 		memcpy(&new_key, &key, sizeof(new_key));
-		new_key.objectid = btrfs_ino(BTRFS_I(inode));
+		new_key.objectid = btrfs_ino(inode);
 		if (off <= key.offset)
 			new_key.offset = key.offset + destoff - off;
 		else
@@ -558,7 +558,7 @@ static int btrfs_clone(struct inode *src, struct inode *inode,
 			clone_info.extent_buf = buf;
 			clone_info.is_new_extent = false;
 			clone_info.update_times = !no_time_update;
-			ret = btrfs_replace_file_extents(BTRFS_I(inode), path,
+			ret = btrfs_replace_file_extents(inode, path,
 					drop_start, new_key.offset + datal - 1,
 					&clone_info, &trans);
 			if (ret)
@@ -582,7 +582,7 @@ static int btrfs_clone(struct inode *src, struct inode *inode,
 				goto out;
 			}
 
-			ret = clone_copy_inline_extent(BTRFS_I(inode), path, &new_key,
+			ret = clone_copy_inline_extent(inode, path, &new_key,
 						       drop_start, datal, size,
 						       comp, buf, &trans);
 			if (ret)
@@ -605,9 +605,9 @@ static int btrfs_clone(struct inode *src, struct inode *inode,
 		 * the checksums problem on fsync.
 		 */
 		if (extent_gen == trans->transid && disko > 0)
-			BTRFS_I(src)->last_reflink_trans = trans->transid;
+			src->last_reflink_trans = trans->transid;
 
-		BTRFS_I(inode)->last_reflink_trans = trans->transid;
+		inode->last_reflink_trans = trans->transid;
 
 		last_dest_end = ALIGN(new_key.offset + datal,
 				      fs_info->sectorsize);
@@ -653,10 +653,10 @@ static int btrfs_clone(struct inode *src, struct inode *inode,
 		 * set by previous calls to btrfs_replace_file_extents() that
 		 * replaced file extent items.
 		 */
-		if (last_dest_end >= i_size_read(inode))
-			btrfs_set_inode_full_sync(BTRFS_I(inode));
+		if (last_dest_end >= i_size_read(&inode->vfs_inode))
+			btrfs_set_inode_full_sync(inode);
 
-		ret = btrfs_replace_file_extents(BTRFS_I(inode), path,
+		ret = btrfs_replace_file_extents(inode, path,
 				last_dest_end, destoff + len - 1, NULL, &trans);
 		if (ret)
 			goto out;
@@ -666,7 +666,7 @@ static int btrfs_clone(struct inode *src, struct inode *inode,
 	}
 
 out:
-	clear_bit(BTRFS_INODE_NO_DELALLOC_FLUSH, &BTRFS_I(inode)->runtime_flags);
+	clear_bit(BTRFS_INODE_NO_DELALLOC_FLUSH, &inode->runtime_flags);
 
 	return ret;
 }
@@ -701,8 +701,7 @@ static int btrfs_extent_same_range(struct btrfs_inode *src, u64 loff, u64 len,
 	 * mode.
 	 */
 	btrfs_lock_extent(&dst->io_tree, dst_loff, end, &cached_state);
-	ret = btrfs_clone(&src->vfs_inode, &dst->vfs_inode, loff, len,
-			  ALIGN(len, bs), dst_loff, true);
+	ret = btrfs_clone(src, dst, loff, len, ALIGN(len, bs), dst_loff, true);
 	btrfs_unlock_extent(&dst->io_tree, dst_loff, end, &cached_state);
 
 	btrfs_btree_balance_dirty(fs_info);
@@ -710,12 +709,12 @@ static int btrfs_extent_same_range(struct btrfs_inode *src, u64 loff, u64 len,
 	return ret;
 }
 
-static int btrfs_extent_same(struct inode *src, u64 loff, u64 olen,
-			     struct inode *dst, u64 dst_loff)
+static int btrfs_extent_same(struct btrfs_inode *src, u64 loff, u64 olen,
+			     struct btrfs_inode *dst, u64 dst_loff)
 {
 	int ret = 0;
 	u64 i, tail_len, chunk_count;
-	struct btrfs_root *root_dst = BTRFS_I(dst)->root;
+	struct btrfs_root *root_dst = dst->root;
 
 	spin_lock(&root_dst->root_item_lock);
 	if (root_dst->send_in_progress) {
@@ -733,8 +732,8 @@ static int btrfs_extent_same(struct inode *src, u64 loff, u64 olen,
 	chunk_count = div_u64(olen, BTRFS_MAX_DEDUPE_LEN);
 
 	for (i = 0; i < chunk_count; i++) {
-		ret = btrfs_extent_same_range(BTRFS_I(src), loff, BTRFS_MAX_DEDUPE_LEN,
-					      BTRFS_I(dst), dst_loff);
+		ret = btrfs_extent_same_range(src, loff, BTRFS_MAX_DEDUPE_LEN,
+					      dst, dst_loff);
 		if (ret)
 			goto out;
 
@@ -743,8 +742,8 @@ static int btrfs_extent_same(struct inode *src, u64 loff, u64 olen,
 	}
 
 	if (tail_len > 0)
-		ret = btrfs_extent_same_range(BTRFS_I(src), loff, tail_len,
-					      BTRFS_I(dst), dst_loff);
+		ret = btrfs_extent_same_range(src, loff, tail_len,
+					      dst, dst_loff);
 out:
 	spin_lock(&root_dst->root_item_lock);
 	root_dst->dedupe_in_progress--;
@@ -757,9 +756,11 @@ static noinline int btrfs_clone_files(struct file *file, struct file *file_src,
 					u64 off, u64 olen, u64 destoff)
 {
 	struct extent_state *cached_state = NULL;
-	struct inode *inode = file_inode(file);
-	struct inode *src = file_inode(file_src);
-	struct btrfs_fs_info *fs_info = inode_to_fs_info(inode);
+	struct btrfs_inode *inode = BTRFS_I(file_inode(file));
+	struct btrfs_inode *src = BTRFS_I(file_inode(file_src));
+	struct btrfs_fs_info *fs_info = inode->root->fs_info;
+	const u64 src_isize = src->vfs_inode.i_size;
+	const u64 inode_isize = inode->vfs_inode.i_size;
 	int ret;
 	u64 len = olen;
 	const u32 bs = fs_info->sectorsize;
@@ -771,13 +772,13 @@ static noinline int btrfs_clone_files(struct file *file, struct file *file_src,
 	 * if the file size is not blocksize aligned. So we don't need to check
 	 * for that case here.
 	 */
-	if (off + len == src->i_size)
-		len = ALIGN(src->i_size, bs) - off;
+	if (off + len == src_isize)
+		len = ALIGN(src_isize, bs) - off;
 
-	if (destoff > inode->i_size) {
-		const u64 wb_start = ALIGN_DOWN(inode->i_size, bs);
+	if (destoff > inode_isize) {
+		const u64 wb_start = ALIGN_DOWN(inode_isize, bs);
 
-		ret = btrfs_cont_expand(BTRFS_I(inode), inode->i_size, destoff);
+		ret = btrfs_cont_expand(inode, inode_isize, destoff);
 		if (ret)
 			return ret;
 		/*
@@ -789,7 +790,7 @@ static noinline int btrfs_clone_files(struct file *file, struct file *file_src,
 		 * we found the previous extent covering eof and before we
 		 * attempted to increment its reference count).
 		 */
-		ret = btrfs_wait_ordered_range(BTRFS_I(inode), wb_start,
+		ret = btrfs_wait_ordered_range(inode, wb_start,
 					       destoff - wb_start);
 		if (ret)
 			return ret;
@@ -802,9 +803,9 @@ static noinline int btrfs_clone_files(struct file *file, struct file *file_src,
 	 * mode.
 	 */
 	end = destoff + len - 1;
-	btrfs_lock_extent(&BTRFS_I(inode)->io_tree, destoff, end, &cached_state);
+	btrfs_lock_extent(&inode->io_tree, destoff, end, &cached_state);
 	ret = btrfs_clone(src, inode, off, olen, len, destoff, false);
-	btrfs_unlock_extent(&BTRFS_I(inode)->io_tree, destoff, end, &cached_state);
+	btrfs_unlock_extent(&inode->io_tree, destoff, end, &cached_state);
 	if (ret < 0)
 		return ret;
 
@@ -818,7 +819,7 @@ static noinline int btrfs_clone_files(struct file *file, struct file *file_src,
 	 * could come from some range other than the copied inline extent's
 	 * destination range and we have no way to know that.
 	 */
-	ret = btrfs_wait_ordered_range(BTRFS_I(inode), destoff, len);
+	ret = btrfs_wait_ordered_range(inode, destoff, len);
 	if (ret < 0)
 		return ret;
 
@@ -826,7 +827,7 @@ static noinline int btrfs_clone_files(struct file *file, struct file *file_src,
 	 * Invalidate page cache so that future reads will see the cloned data
 	 * immediately and not the previous data.
 	 */
-	ret = filemap_invalidate_inode(inode, false, destoff, end);
+	ret = filemap_invalidate_inode(&inode->vfs_inode, false, destoff, end);
 	if (ret < 0)
 		return ret;
 
@@ -934,7 +935,7 @@ loff_t btrfs_remap_file_range(struct file *src_file, loff_t off,
 	bool same_inode = dst_inode == src_inode;
 	int ret;
 
-	if (btrfs_is_shutdown(inode_to_fs_info(file_inode(src_file))))
+	if (btrfs_is_shutdown(src_inode->root->fs_info))
 		return -EIO;
 
 	if (remap_flags & ~(REMAP_FILE_DEDUP | REMAP_FILE_ADVISORY))
@@ -953,8 +954,7 @@ loff_t btrfs_remap_file_range(struct file *src_file, loff_t off,
 		goto out_unlock;
 
 	if (remap_flags & REMAP_FILE_DEDUP)
-		ret = btrfs_extent_same(&src_inode->vfs_inode, off, len,
-					&dst_inode->vfs_inode, destoff);
+		ret = btrfs_extent_same(src_inode, off, len, dst_inode, destoff);
 	else
 		ret = btrfs_clone_files(dst_file, src_file, off, len, destoff);
 
-- 
2.54.0

