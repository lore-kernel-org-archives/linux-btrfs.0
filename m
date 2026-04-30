Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E16151A9FA0
	for <linux-btrfs@vger.kernel.org>; Thu, 30 Apr 2026 01:07:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777511280; cv=none; b=ktIflW0o+rvBGr655Q0CkJgndiO1eASOWo7eHQEWyuLfTPOxoPGtSf+7e50vghFRuJ1xZUghVBceXlDvIuY09vUHCJsAX5GwegDkEGNMN7DZDAfYiINwZilpduJEqAm4a7NLpCj5vsCgKrFG3ccrWqQowCgpJhsW3xp4U/vqrNs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777511280; c=relaxed/simple;
	bh=TBCmL6LnnHGHe2rcDfdM37U3RDXOoGwo1ZtG89ot9hs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rMg/33ttZMldsyL/TNWlOZpSZmN0jrf3qGNQ1H66wtcDoCfLwlpL6EeAeQMFQxyP/BogGB+znw9FnRj4HNSDSMMdBvJKqH4ycJCkLMYrYtB9xeT/TL9WKNxcA6+YEBG5b8IALZIBpyVavnb8+ETFJd57ATC5rKUg7PIblofjjtQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=qfGtsJs+; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=qfGtsJs+; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="qfGtsJs+";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="qfGtsJs+"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id C1AE66A7C3;
	Thu, 30 Apr 2026 01:07:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1777511272; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=UcX3BdUUD3PLBKWpwdDopnjw6haRMbbunH8XILttGcM=;
	b=qfGtsJs+JMjcPVG+f0kaQuyCIIe1gplwQaZQ7IwpRtJVWgYKjdXLN73ssm6ElqpMDqfLmF
	uhxlWaOuHGdd/dIUdHcMkFc5PtgoocvIPMFVwLU95qz4/PdAe3mfeMTnNR5C8W+2wwA9RP
	+pZa0p/b4MaICAHYz/oic6w7IV5Vee8=
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1777511272; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=UcX3BdUUD3PLBKWpwdDopnjw6haRMbbunH8XILttGcM=;
	b=qfGtsJs+JMjcPVG+f0kaQuyCIIe1gplwQaZQ7IwpRtJVWgYKjdXLN73ssm6ElqpMDqfLmF
	uhxlWaOuHGdd/dIUdHcMkFc5PtgoocvIPMFVwLU95qz4/PdAe3mfeMTnNR5C8W+2wwA9RP
	+pZa0p/b4MaICAHYz/oic6w7IV5Vee8=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 8B56D593B0;
	Thu, 30 Apr 2026 01:07:51 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id SL2lE2er8mlyWgAAD6G6ig
	(envelope-from <wqu@suse.com>); Thu, 30 Apr 2026 01:07:51 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: AHN SEOK-YOUNG <iamsyahn@gmail.com>,
	Teng Liu <27rabbitlt@gmail.com>
Subject: [PATCH v4 2/2] btrfs: warn about extent buffer that can not be released
Date: Thu, 30 Apr 2026 10:37:23 +0930
Message-ID: <ecc473cee5a79c8c8b1006febbfeb24963c46714.1777510825.git.wqu@suse.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <cover.1777510825.git.wqu@suse.com>
References: <cover.1777510825.git.wqu@suse.com>
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
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FREEMAIL_CC(0.00)[gmail.com];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:mid,suse.com:email,imap1.dmz-prg2.suse.org:helo];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	RCVD_TLS_ALL(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	FREEMAIL_ENVRCPT(0.00)[gmail.com]
X-Spam-Flag: NO

When we unmount the fs or during mount failures, btrfs will call
invalidate_inode_pages() to release all btree inode folios.

However that function can return -EBUSY if any folios can not be
invalidated.
This can be caused by:

- Some extent buffers are still held by btrfs
  This is a logic error, as we should release all tree root nodes
  during unmount and mount failure handling.

- Some extent buffers are under readahead and haven't yet finished
  These are much rarer but valid cases.
  In that case we should wait for those extent buffers.

Introduce a new helper invalidate_and_check_btree_folios() which will:

- Call invalidate_inode_pages2() and catch its return value
  If it returned 0 as expected, that's great and we can call it a day.

- Otherwise go through each extent buffer in buffer_tree
  Increase the ref by one first for the eb we're checking.
  This is to ensure the eb won't be freed after the readahead is
  finished.

  For ebs that still have EXTENT_BUFFER_READING flag, wait for them to
  finish first.

  After waiting for the readahead, check the refs of the eb and if it's
  still dirty.

  If the eb ref count is greater than 2 (one for the buffer tree, one
  held by us), it means we are still holding the extent buffer somewhere
  else, which is a code bug.

  If the eb is still dirty, it means a bug in transaction handling, e.g.
  the bug fixed by patch "btrfs: only release the dirty pages io tree
  after successful writes".

  For either case, show a warning message about the eb, including its
  bytenr, owner, refs and flags.
  And if it's a debug build, also trigger WARN_ON_ONCE() so that fstests
  can properly catch such situation.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=221270
Reported-by: AHN SEOK-YOUNG <iamsyahn@gmail.com>
Cc: Teng Liu <27rabbitlt@gmail.com>
Tested-by: Teng Liu <27rabbitlt@gmail.com>
Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/disk-io.c   | 54 ++++++++++++++++++++++++++++++++++++++++++--
 fs/btrfs/extent_io.c |  6 -----
 fs/btrfs/extent_io.h |  6 +++++
 3 files changed, 58 insertions(+), 8 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index f28cef8217de..97299394515b 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -3272,6 +3272,56 @@ static bool fs_is_full_ro(const struct btrfs_fs_info *fs_info)
 	return false;
 }
 
+/*
+ * Try to wait for any metadata readahead, and invalidate all btree folios.
+ *
+ * If the invalidation failed, report any dirty/held extent buffers.
+ */
+static void invalidate_and_check_btree_folios(struct btrfs_fs_info *fs_info)
+{
+	unsigned long index = 0;
+	struct extent_buffer *eb;
+	int ret;
+
+	ret = invalidate_inode_pages2(fs_info->btree_inode->i_mapping);
+	if (likely(ret == 0))
+		return;
+
+	/*
+	 * Some btree pages can not be invalidated, this happens when some
+	 * tree blocks are still held (either by some pointer or readahead).
+	 */
+	rcu_read_lock();
+	xa_for_each(&fs_info->buffer_tree, index, eb) {
+		/* Increase the ref so that the eb won't disappear. */
+		if (!refcount_inc_not_zero(&eb->refs))
+			continue;
+		rcu_read_unlock();
+
+		/* Wait for any readahead first. */
+		if (test_bit(EXTENT_BUFFER_READING, &eb->bflags))
+			wait_on_bit_io(&eb->bflags, EXTENT_BUFFER_READING,
+				       TASK_UNINTERRUPTIBLE);
+		/*
+		 * The refs threshold is 2, one held by us at the beginning
+		 * of the loop, one for the ownership in the buffer tree.
+		 */
+		if (unlikely(refcount_read(&eb->refs) > 2 ||
+			     extent_buffer_under_io(eb))) {
+			WARN_ON_ONCE(IS_ENABLED(CONFIG_BTRFS_DEBUG));
+			btrfs_warn(fs_info,
+			"unable to release extent buffer %llu owner %llu gen %llu refs %u flags 0x%lx",
+				   eb->start, btrfs_header_owner(eb),
+				   btrfs_header_generation(eb),
+				   refcount_read(&eb->refs), eb->bflags);
+		}
+		free_extent_buffer(eb);
+		rcu_read_lock();
+	}
+	rcu_read_unlock();
+	invalidate_inode_pages2(fs_info->btree_inode->i_mapping);
+}
+
 int __cold open_ctree(struct super_block *sb, struct btrfs_fs_devices *fs_devices)
 {
 	u32 sectorsize;
@@ -3709,7 +3759,7 @@ int __cold open_ctree(struct super_block *sb, struct btrfs_fs_devices *fs_device
 	if (fs_info->data_reloc_root)
 		btrfs_drop_and_free_fs_root(fs_info, fs_info->data_reloc_root);
 	free_root_pointers(fs_info, true);
-	invalidate_inode_pages2(fs_info->btree_inode->i_mapping);
+	invalidate_and_check_btree_folios(fs_info);
 
 fail_sb_buffer:
 	btrfs_stop_all_workers(fs_info);
@@ -4438,7 +4488,7 @@ void __cold close_ctree(struct btrfs_fs_info *fs_info)
 	 * We must make sure there is not any read request to
 	 * submit after we stop all workers.
 	 */
-	invalidate_inode_pages2(fs_info->btree_inode->i_mapping);
+	invalidate_and_check_btree_folios(fs_info);
 	btrfs_stop_all_workers(fs_info);
 
 	/*
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 8800faa8b4be..9c9dffda2b07 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -2882,12 +2882,6 @@ bool try_release_extent_mapping(struct folio *folio, gfp_t mask)
 	return try_release_extent_state(io_tree, folio);
 }
 
-static int extent_buffer_under_io(const struct extent_buffer *eb)
-{
-	return (test_bit(EXTENT_BUFFER_WRITEBACK, &eb->bflags) ||
-		test_bit(EXTENT_BUFFER_DIRTY, &eb->bflags));
-}
-
 static bool folio_range_has_eb(struct folio *folio)
 {
 	struct btrfs_folio_state *bfs;
diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
index b310a5145cf6..7b4152387d88 100644
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -327,6 +327,12 @@ static inline bool extent_buffer_uptodate(const struct extent_buffer *eb)
 	return test_bit(EXTENT_BUFFER_UPTODATE, &eb->bflags);
 }
 
+static inline bool extent_buffer_under_io(const struct extent_buffer *eb)
+{
+	return (test_bit(EXTENT_BUFFER_WRITEBACK, &eb->bflags) ||
+		test_bit(EXTENT_BUFFER_DIRTY, &eb->bflags));
+}
+
 int memcmp_extent_buffer(const struct extent_buffer *eb, const void *ptrv,
 			 unsigned long start, unsigned long len);
 void read_extent_buffer(const struct extent_buffer *eb, void *dst,
-- 
2.54.0

