Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5ED143AEF36
	for <linux-btrfs@vger.kernel.org>; Sun,  3 May 2026 09:48:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777801709; cv=none; b=k876bucIYw3KVyn5JLKWncqyf9obKPio+wrbTAYPb8KeJBdkKpYavEPFlhNl4ud/R5ZNzln64L4BL3OQRoREl9KgGQuRVYwOTrJnkrASLBYgWOP6fAhRlKpo3Wc2Msu7F2ehX6gE2ewY29BhufvI0f4+Lwdji9tGQR3XtPNPpwE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777801709; c=relaxed/simple;
	bh=ckpYGsSTOCs+E/MxUgZ5FbAr0GS47JboKKW0eA+o5ow=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h5fbSmYi/2HyQo17fOVJvD72PbSTOwIeDfQakWp+s6Snnksq38p34DJCaA98Iwa0n+iLffjWRKilaQEJ5n44YZ1mZ8UqwD0nCv8eDnoULYKbxkmVTmHXSZ1uJgsn7G0tvjYAEcCl0lHghP8U8YsW1KXbUg6eVmyCGAQPrlJzV9w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=HzAZGode; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=HzAZGode; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="HzAZGode";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="HzAZGode"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 0405C6AA8A
	for <linux-btrfs@vger.kernel.org>; Sun,  3 May 2026 09:48:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1777801695; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=mQhHKq2AfUMDXbU4tpToaEsZdT/Wqn08nRlXZ945/HM=;
	b=HzAZGodePrgcaTeWPKexJ/eQNBE8zkxtJwVbUoXPTZ8gaALSCP3Th4483iPt3hQ3e6vBXU
	ywAokOarEPgwYqmONnPxRc80nQhHYrYt3XA5QkHYPNauO9Ec9voO4EJuJ+QWVyXXlZUZiG
	t3Xd/YFxl3yet/Ta7SYkYoldKZ5g1PE=
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1777801695; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=mQhHKq2AfUMDXbU4tpToaEsZdT/Wqn08nRlXZ945/HM=;
	b=HzAZGodePrgcaTeWPKexJ/eQNBE8zkxtJwVbUoXPTZ8gaALSCP3Th4483iPt3hQ3e6vBXU
	ywAokOarEPgwYqmONnPxRc80nQhHYrYt3XA5QkHYPNauO9Ec9voO4EJuJ+QWVyXXlZUZiG
	t3Xd/YFxl3yet/Ta7SYkYoldKZ5g1PE=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 424B7593A3
	for <linux-btrfs@vger.kernel.org>; Sun,  3 May 2026 09:48:14 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id OCjQAd4Z92mUPAAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Sun, 03 May 2026 09:48:14 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 1/2] btrfs: unexport and move extent_invalidate_folio()
Date: Sun,  3 May 2026 19:17:50 +0930
Message-ID: <96ff3d0603f93ca952ff303f9b556c14d1d1ef79.1777801546.git.wqu@suse.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <cover.1777801546.git.wqu@suse.com>
References: <cover.1777801546.git.wqu@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-2.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCPT_COUNT_ONE(0.00)[1];
	ARC_NA(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:mid,suse.com:email];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	RCVD_TLS_ALL(0.00)[]
X-Spam-Flag: NO
X-Spam-Score: -2.80
X-Spam-Level: 

The function extent_invalidate_folio() has only a single caller inside
btree_invalidate_folio().

There is no need to export such a function just for a single caller inside
another file.

Unexport extent_invalidate_folio() and move it to disk-io.c.

And since we're moving the code, update the commit to match the current
style, and remove the seemingly stale comment on the extent state
removal, it's better explained by the comment just before
btrfs_unlock_extent().

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/disk-io.c   | 31 +++++++++++++++++++++++++++++++
 fs/btrfs/extent_io.c | 32 --------------------------------
 fs/btrfs/extent_io.h |  2 --
 3 files changed, 31 insertions(+), 34 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 48ddbeb18e3c..f925dcea0c46 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -488,6 +488,37 @@ static bool btree_release_folio(struct folio *folio, gfp_t gfp_flags)
 	return try_release_extent_buffer(folio);
 }
 
+/*
+ * Basic invalidate_folio code, this waits on any locked or writeback
+ * ranges corresponding to the folio.
+ */
+static int extent_invalidate_folio(struct extent_io_tree *tree,
+				   struct folio *folio, size_t offset)
+{
+	struct extent_state *cached_state = NULL;
+	u64 start = folio_pos(folio);
+	u64 end = start + folio_size(folio) - 1;
+	size_t blocksize = folio_to_fs_info(folio)->sectorsize;
+
+	/* This function is only called for the btree inode */
+	ASSERT(tree->owner == IO_TREE_BTREE_INODE_IO);
+
+	start += ALIGN(offset, blocksize);
+	if (start > end)
+		return 0;
+
+	btrfs_lock_extent(tree, start, end, &cached_state);
+	folio_wait_writeback(folio);
+
+	/*
+	 * Currently for btree io tree, only EXTENT_LOCKED is utilized,
+	 * so here we only need to unlock the extent range to free any
+	 * existing extent state.
+	 */
+	btrfs_unlock_extent(tree, start, end, &cached_state);
+	return 0;
+}
+
 static void btree_invalidate_folio(struct folio *folio, size_t offset,
 				 size_t length)
 {
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 31a65c662b65..ebf9a63946e5 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -2734,38 +2734,6 @@ void btrfs_readahead(struct readahead_control *rac)
 	submit_one_bio(&bio_ctrl);
 }
 
-/*
- * basic invalidate_folio code, this waits on any locked or writeback
- * ranges corresponding to the folio, and then deletes any extent state
- * records from the tree
- */
-int extent_invalidate_folio(struct extent_io_tree *tree,
-			  struct folio *folio, size_t offset)
-{
-	struct extent_state *cached_state = NULL;
-	u64 start = folio_pos(folio);
-	u64 end = start + folio_size(folio) - 1;
-	size_t blocksize = folio_to_fs_info(folio)->sectorsize;
-
-	/* This function is only called for the btree inode */
-	ASSERT(tree->owner == IO_TREE_BTREE_INODE_IO);
-
-	start += ALIGN(offset, blocksize);
-	if (start > end)
-		return 0;
-
-	btrfs_lock_extent(tree, start, end, &cached_state);
-	folio_wait_writeback(folio);
-
-	/*
-	 * Currently for btree io tree, only EXTENT_LOCKED is utilized,
-	 * so here we only need to unlock the extent range to free any
-	 * existing extent state.
-	 */
-	btrfs_unlock_extent(tree, start, end, &cached_state);
-	return 0;
-}
-
 /*
  * A helper for struct address_space_operations::release_folio, this tests for
  * areas of the folio that are locked or under IO and drops the related state
diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
index b310a5145cf6..ede7abbe4031 100644
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -381,8 +381,6 @@ void extent_clear_unlock_delalloc(struct btrfs_inode *inode, u64 start, u64 end,
 				  const struct folio *locked_folio,
 				  struct extent_state **cached,
 				  u32 bits_to_clear, unsigned long page_ops);
-int extent_invalidate_folio(struct extent_io_tree *tree,
-			    struct folio *folio, size_t offset);
 void btrfs_clear_buffer_dirty(struct btrfs_trans_handle *trans,
 			      struct extent_buffer *buf);
 
-- 
2.54.0

