Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D360E288517
	for <linux-btrfs@vger.kernel.org>; Sun,  5 Apr 2026 04:56:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775365010; cv=none; b=S5UO481smvcmv5bmJ/dWVpsffD8FqGrBUWjA5yFjxjfPitHCoXXJjBqo2R7bCTWZQPt7tHOJMw7iDz8P0lKAzZwwYQzq1E1JWLRiqw8hanoPnnkwAfX2aYElY89lwV1kn1k4FDZvDDINSEzl8Q2Bn3y15xUO+TZPh7fUDY16ugU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775365010; c=relaxed/simple;
	bh=3OmIsDRTNnyGwrOZ0UxaZlp/jT2lfbXlr+1g04XFFfA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=QirVHVT449Cnaj+/LsaXfQl9A4sdLOZwjAd1EsoSCrYc04EypKTBgoIM931ksG0FY9OtmcDt8bna9M7ZsBPQu8yRBOMdEJTyJDPENHL0lDShtYku/TdnYKUj1GFQ7zejDpGZhIbSXHzDZG4OzNfiBcz17sKQ/DWvckesH29728I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=o6mhUPYD; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=qD8apKIT; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="o6mhUPYD";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="qD8apKIT"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id BEF015BD2D;
	Sun,  5 Apr 2026 04:56:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1775365007; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=IX4+7UASYdNG1F0DLG791Zdcb62MgIWealtEbZ3Mtoc=;
	b=o6mhUPYDdRQ55NojzpnOmO26ZU81cNceHCl8l1BXlLB8SstxQ5w2uStkj1bOZ/Hc/IKjD5
	MaJ0yV48W00hqJiUU7FXtu2M8Bwrt+U5tYFElDETLJmlmECtAdr9sIyE5BltuSlgFg51bW
	lLmZ1rZklk4E+F/BkJ3vqJBxBhduZPY=
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=qD8apKIT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1775365006; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=IX4+7UASYdNG1F0DLG791Zdcb62MgIWealtEbZ3Mtoc=;
	b=qD8apKIT5qODAetppN5dScg4jdFre9l2+DWWfR0uYXF7o8WxaTpg6ScfvPtkaSE5Pt9HAq
	L3/QQDmcdk/qSXN4dzHXDt11P4jPrr/wlUxECcRkumv3QhLCq/ug6OAneQbtMnlm/XpzZk
	mXhosKqu8ZeaQimZCOqp61TmgWJnNyI=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 195284A0B0;
	Sun,  5 Apr 2026 04:56:44 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id aA8QLozr0WmnfQAAD6G6ig
	(envelope-from <wqu@suse.com>); Sun, 05 Apr 2026 04:56:44 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: AHN SEOK-YOUNG <iamsyahn@gmail.com>,
	Teng Liu <27rabbitlt@gmail.com>
Subject: [PATCH] btrfs: warn about extent buffer that can not be released
Date: Sun,  5 Apr 2026 14:26:11 +0930
Message-ID: <1c3a439e1e21c4ee32575b264ac0bc3935ea4f53.1775364843.git.wqu@suse.com>
X-Mailer: git-send-email 2.53.0
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
	ARC_NA(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	RCVD_TLS_ALL(0.00)[];
	FREEMAIL_CC(0.00)[gmail.com];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.com:mid,suse.com:dkim,suse.com:email];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from,2a07:de40:b281:106:10:150:64:167:received];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	RCPT_COUNT_THREE(0.00)[3];
	DKIM_TRACE(0.00)[suse.com:+]
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spam-Score: -3.01
X-Spam-Level: 
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Queue-Id: BEF015BD2D

When we unmount the fs or during mount failures, btrfs will call
invalidate_inode_pages() to release all btree inode folios.

However that function can return -EBUSY if any folios can not be
invalidated.
This can be caused by:

- Some extent buffers are still held by btrfs
  This is a logic error, as we should release all tree root nodes
  during unmount and mount failure handling.

- Some extent buffers are under readahead and haven't yet finished
  This is much rarer but valid cases.
  In that case we should wait for those extent buffers.

Introduce a new helper invalidate_btree_folios() which will:

- Call invalidate_inode_pages2() and catch its return value
  If it returned 0 as expected, that's great and we can call it a day.

- Otherwise go through each extent buffer in buffer_tree
  For eb that still has EXTENT_BUFFER_READING flag, wait for them to
  finish first.

  Then check if the refs of the eb is greater than 1, if so it means
  it's still held by someone, give it a warning.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=221270
Reported-by: AHN SEOK-YOUNG <iamsyahn@gmail.com>
Cc: Teng Liu <27rabbitlt@gmail.com>
Signed-off-by: Qu Wenruo <wqu@suse.com>
---
This new debug feature has exposed some problems, e.g. generic/648,
after an injected failure for device barrier, transaction is aborted but
we have a lot of dirty tree blocks unreleased and triggered the new
warning.

We still need to fix these corner cases.

Meanwhile if Ahn or Teng can give this patch a try for the existing
use-after-free problem, it would be appreciated a lot.
---
 fs/btrfs/disk-io.c   | 52 ++++++++++++++++++++++++++++++++++++++++++--
 fs/btrfs/extent_io.c |  6 -----
 fs/btrfs/extent_io.h |  6 +++++
 3 files changed, 56 insertions(+), 8 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index b8ac3275d8f8..d450bfc6d89b 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -3276,6 +3276,54 @@ static bool fs_is_full_ro(const struct btrfs_fs_info *fs_info)
 	return false;
 }
 
+static void invalidate_btree_folios(struct btrfs_fs_info *fs_info)
+{
+	XA_STATE(xas, &fs_info->buffer_tree, 0);
+	unsigned int checked = 0;
+	void *tmp;
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
+	xas_lock_irq(&xas);
+	xas_for_each(&xas, tmp, ULONG_MAX) {
+		struct extent_buffer *eb = tmp;
+
+		/* Wait for any readahead first. */
+		if (test_bit(EXTENT_BUFFER_READING, &eb->bflags)) {
+			xas_pause(&xas);
+			xas_unlock_irq(&xas);
+			wait_on_bit_io(&eb->bflags, EXTENT_BUFFER_READING,
+				       TASK_UNINTERRUPTIBLE);
+			xas_lock_irq(&xas);
+		}
+
+		spin_lock(&eb->refs_lock);
+		if (refcount_read(&eb->refs) > 1 || extent_buffer_under_io(eb)) {
+			btrfs_warn(fs_info,
+			"unbale to release extent buffer %llu owner %llu flags 0x%lx",
+				   eb->start, btrfs_header_owner(eb), eb->bflags);
+			if (IS_ENABLED(CONFIG_BTRFS_DEBUG))
+				WARN_ON_ONCE(true);
+		}
+		spin_unlock(&eb->refs_lock);
+		if (++checked % XA_CHECK_SCHED)
+			continue;
+		xas_pause(&xas);
+		xas_unlock_irq(&xas);
+		cond_resched();
+		xas_lock_irq(&xas);
+	}
+	xas_unlock_irq(&xas);
+	invalidate_inode_pages2(fs_info->btree_inode->i_mapping);
+}
+
 int __cold open_ctree(struct super_block *sb, struct btrfs_fs_devices *fs_devices)
 {
 	u32 sectorsize;
@@ -3706,7 +3754,7 @@ int __cold open_ctree(struct super_block *sb, struct btrfs_fs_devices *fs_device
 	if (fs_info->data_reloc_root)
 		btrfs_drop_and_free_fs_root(fs_info, fs_info->data_reloc_root);
 	free_root_pointers(fs_info, true);
-	invalidate_inode_pages2(fs_info->btree_inode->i_mapping);
+	invalidate_btree_folios(fs_info);
 
 fail_sb_buffer:
 	btrfs_stop_all_workers(fs_info);
@@ -4445,7 +4493,7 @@ void __cold close_ctree(struct btrfs_fs_info *fs_info)
 	 * We must make sure there is not any read request to
 	 * submit after we stop all workers.
 	 */
-	invalidate_inode_pages2(fs_info->btree_inode->i_mapping);
+	invalidate_btree_folios(fs_info);
 	btrfs_stop_all_workers(fs_info);
 
 	/*
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 1ba8a7d3587b..a8887285deda 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -2877,12 +2877,6 @@ bool try_release_extent_mapping(struct folio *folio, gfp_t mask)
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
index fd209233317f..b284aee1bfb0 100644
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -326,6 +326,12 @@ static inline bool extent_buffer_uptodate(const struct extent_buffer *eb)
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
2.53.0

