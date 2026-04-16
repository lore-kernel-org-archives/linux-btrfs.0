Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58C7D40DFDF
	for <linux-btrfs@vger.kernel.org>; Thu, 16 Apr 2026 00:36:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776299792; cv=none; b=Lkmt1gqrlJCdDWA9g3wbnROGZeqnDDRq+9d6A8xBMOyRR13FTfJuUZy77CytamIgz1IsKbJ4A6DpltQvio1fuG034VaiGnFCF6KrETSNXLkpHq5Gd6peWMLiFJiQyvOaVqihi37YzwsT/Y0HXYwl4EFWzRkaVuOvzzAUN43JKPg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776299792; c=relaxed/simple;
	bh=tTc7XvR9B++8LLgatkd+eX7Ww1ttRGcqMRN392zH4ew=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Tv4mQY47yHF+4XPhBB/DLZMbo5EThnjsSBdkgz5oy1vh7KRdkWbRfR6wEmlyVsL6WIOmEJXbITfygZVQQLrcD0crHzYNFQSzxJEesMjNs244ATqk1VdxPg6eVs2c/3ntL/ZEg2bmGSVOvjYIRGChhsClZ2cQhCZbxSBINEx2yUQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=o/G0ez3C; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=o/G0ez3C; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="o/G0ez3C";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="o/G0ez3C"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 32AB75BD7D;
	Thu, 16 Apr 2026 00:36:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1776299788; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=JajkqWR1R+KmYnTWAADGMDsUGjw/Epe/Jj4N/u74KZg=;
	b=o/G0ez3CXMOcn5/PnMcqw/OjKYdLE1gc+ZBpz6Z0idXUV+U9hx4AE9AalObth/4XZ7Pk18
	fpDR2r8Hftn8NFLUFkhnrdF3jfj8/MbeEiSLPn1FGiv91cLWdku6+sp8/O06GDSFn1GsPU
	bdt1n8JaKvdOiaAQnEuw3nnDT5GZr7w=
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b="o/G0ez3C"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1776299788; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=JajkqWR1R+KmYnTWAADGMDsUGjw/Epe/Jj4N/u74KZg=;
	b=o/G0ez3CXMOcn5/PnMcqw/OjKYdLE1gc+ZBpz6Z0idXUV+U9hx4AE9AalObth/4XZ7Pk18
	fpDR2r8Hftn8NFLUFkhnrdF3jfj8/MbeEiSLPn1FGiv91cLWdku6+sp8/O06GDSFn1GsPU
	bdt1n8JaKvdOiaAQnEuw3nnDT5GZr7w=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id E9A2C4BCA2;
	Thu, 16 Apr 2026 00:36:26 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id DJ4MKgov4GnvZwAAD6G6ig
	(envelope-from <wqu@suse.com>); Thu, 16 Apr 2026 00:36:26 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: AHN SEOK-YOUNG <iamsyahn@gmail.com>,
	Teng Liu <27rabbitlt@gmail.com>
Subject: [PATCH v2] btrfs: warn about extent buffer that can not be released
Date: Thu, 16 Apr 2026 10:06:09 +0930
Message-ID: <5428d866cacad4c0772fd35322978c632192adf3.1776299673.git.wqu@suse.com>
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
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	URIBL_BLOCKED(0.00)[suse.com:mid,suse.com:dkim,suse.com:email];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	ASN_FAIL(0.00)[7.9.0.0.4.6.0.0.0.5.1.0.0.1.0.0.4.0.1.0.1.8.2.b.0.4.e.d.7.0.a.2.asn6.rspamd.com:server fail];
	MIME_TRACE(0.00)[0:+];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	FREEMAIL_CC(0.00)[gmail.com];
	RCVD_TLS_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received,2a07:de40:b281:104:10:150:64:97:from];
	RCPT_COUNT_THREE(0.00)[3];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DKIM_TRACE(0.00)[suse.com:+];
	FREEMAIL_ENVRCPT(0.00)[gmail.com]
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spam-Score: -3.01
X-Spam-Level: 
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Queue-Id: 32AB75BD7D

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
  Increase the ref by one first for the eb we're checking.
  This is to ensure the eb won't be freed after the readahead is
  finished.

  For eb that still has EXTENT_BUFFER_READING flag, wait for them to
  finish first.

  After waiting for the readahead, check the refs of the eb and if it's
  still dirty.

  If the eb refs is greater than 2 (one for the buffer tree, one hold by
  us), it means we are still holding the extent buffer somewhere else,
  which is a logic bug.

  If the eb is still dirty, it means a bug in transaction handling.
  Unfortunately there are already test cases triggering this warning, so
  our transaction cleanup hasn't done its work reliably.

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
Changelog:
v2:
- Add one extra ref before checking the eb
  Although readahead has one extra ref, after the readahead finished the
  extra ref will be dropped, and memory pressure can kick in to free the
  extent buffer.

- Use rcu lock with xa_for_each() instead of xas lock and xas_for_each()
  Since we're holding one extra eb ref to prevent eb from disappearing,
  we no longer needs the more strict xas lock nor the extra xas
  pause/unlock.

  Although xa_for_each() is more time consuming, we're at the cold path
  already, not a huge cost.

- Remove the temporarary void pointer
  And pass eb pointer directly into xas_for_each().

- Introduce DEBUG_WARN_ON_ONCE() helper
  To follow the existing DEBUG_WARN() helper.

- Fix a typo

- Also fix the checkpatch warning on the exist DEBUG_WARN()
---
 fs/btrfs/disk-io.c   | 46 ++++++++++++++++++++++++++++++++++++++++++--
 fs/btrfs/extent_io.c |  6 ------
 fs/btrfs/extent_io.h |  6 ++++++
 fs/btrfs/messages.h  |  4 +++-
 4 files changed, 53 insertions(+), 9 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 7800a1b20290..c2217891f1dc 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -3272,6 +3272,48 @@ static bool fs_is_full_ro(const struct btrfs_fs_info *fs_info)
 	return false;
 }
 
+static void invalidate_btree_folios(struct btrfs_fs_info *fs_info)
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
+		 * The refs threshold is 2, one hold by us at the beginning
+		 * of the loop, one for the ownership in the buffer tree.
+		 */
+		if (DEBUG_WARN_ON_ONCE(refcount_read(&eb->refs) > 2 ||
+				       extent_buffer_under_io(eb)))
+			btrfs_warn(fs_info,
+			"unable to release extent buffer %llu owner %llu refs %u flags 0x%lx",
+				   eb->start, btrfs_header_owner(eb),
+				   refcount_read(&eb->refs), eb->bflags);
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
@@ -3702,7 +3744,7 @@ int __cold open_ctree(struct super_block *sb, struct btrfs_fs_devices *fs_device
 	if (fs_info->data_reloc_root)
 		btrfs_drop_and_free_fs_root(fs_info, fs_info->data_reloc_root);
 	free_root_pointers(fs_info, true);
-	invalidate_inode_pages2(fs_info->btree_inode->i_mapping);
+	invalidate_btree_folios(fs_info);
 
 fail_sb_buffer:
 	btrfs_stop_all_workers(fs_info);
@@ -4431,7 +4473,7 @@ void __cold close_ctree(struct btrfs_fs_info *fs_info)
 	 * We must make sure there is not any read request to
 	 * submit after we stop all workers.
 	 */
-	invalidate_inode_pages2(fs_info->btree_inode->i_mapping);
+	invalidate_btree_folios(fs_info);
 	btrfs_stop_all_workers(fs_info);
 
 	/*
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 8d241a7a880f..4eab0f9909e3 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -2872,12 +2872,6 @@ bool try_release_extent_mapping(struct folio *folio, gfp_t mask)
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
diff --git a/fs/btrfs/messages.h b/fs/btrfs/messages.h
index 556d4e79cde6..d6167d5d8f94 100644
--- a/fs/btrfs/messages.h
+++ b/fs/btrfs/messages.h
@@ -162,8 +162,10 @@ do {										\
 #ifdef CONFIG_BTRFS_DEBUG
 /* Verbose warning only under debug build. */
 #define DEBUG_WARN(args...)			WARN(1, KERN_ERR args)
+#define DEBUG_WARN_ON_ONCE(condition)		WARN_ON_ONCE(condition)
 #else
-#define DEBUG_WARN(...)				do {} while(0)
+#define DEBUG_WARN(...)				do {} while (0)
+#define DEBUG_WARN_ON_ONCE(condition)		(unlikely(condition))
 #endif
 
 __printf(5, 6)
-- 
2.53.0

