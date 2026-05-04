Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E0053DD501
	for <linux-btrfs@vger.kernel.org>; Mon,  4 May 2026 23:49:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777938598; cv=none; b=g/vi5jTkv1LbRCHwxBNm3zy+4wbsYkDuhwJnepx/8Cl5TAQs506Z1LldSn/odksFgfPCwWEZY9zjzfzblqEgOzdbO+l84j+u5BkAxz2kZXP0RVpCo3AS/tyCLoW5a+GrCilVR4gdWqWcAo56wo4MB+kKNEwBookTp9MpuGrEXaI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777938598; c=relaxed/simple;
	bh=lGVLjx0elB4aSxZEJc2WGJEwPActhCgf4EJ+QeFvloU=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uitQ1GKbflVNiXJ8QTQ37+29OzprC7SGMWvfXAfm5/Yr/6ToRkJk41OgAxRayqFc5OGFPr7MzqxF62sEChMtK4XGX+MSooBq81s27QYxKviYJ8ml3e54ASfIbnZ3WXKUEb3jxuGxczCFcVYXSIraPhiEuxhRLdlzp8HmiyvqvZU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=ZHusguAR; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=ZHusguAR; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="ZHusguAR";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="ZHusguAR"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 425CA6B565
	for <linux-btrfs@vger.kernel.org>; Mon,  4 May 2026 23:49:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1777938586; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Z4Fgr5wnWpoHh7Cl18mhlSlveiM6BjdyxiPcnnTczso=;
	b=ZHusguARxpx7eleYqGQUaO2A7jLKlKt8p6+J7TKc2Ab/t7ciKTq+QuL46MdKtVVQvIdLcK
	vQqzDYnGJKhNDvqSdZPXzeY+95FOhE5dHlZEkyRf3o+UFiHDD6uN8aQy2D9wUO3A525j/h
	T/6WeYsCELpduc/Iup3NQS5hbwqA964=
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=ZHusguAR
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1777938586; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Z4Fgr5wnWpoHh7Cl18mhlSlveiM6BjdyxiPcnnTczso=;
	b=ZHusguARxpx7eleYqGQUaO2A7jLKlKt8p6+J7TKc2Ab/t7ciKTq+QuL46MdKtVVQvIdLcK
	vQqzDYnGJKhNDvqSdZPXzeY+95FOhE5dHlZEkyRf3o+UFiHDD6uN8aQy2D9wUO3A525j/h
	T/6WeYsCELpduc/Iup3NQS5hbwqA964=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 81BE0593A3
	for <linux-btrfs@vger.kernel.org>; Mon,  4 May 2026 23:49:45 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 2GhTEZkw+WmKAgAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Mon, 04 May 2026 23:49:45 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH RFC 3/4] btrfs: remove folio_test_ordered() usage
Date: Tue,  5 May 2026 09:19:23 +0930
Message-ID: <34b5bc3b5f2b6b2b869cd8a00d3ac14154507df9.1777937175.git.wqu@suse.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <cover.1777937175.git.wqu@suse.com>
References: <cover.1777937175.git.wqu@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Flag: NO
X-Spam-Score: -3.01
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-3.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCPT_COUNT_ONE(0.00)[1];
	MIME_TRACE(0.00)[0:+];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	RCVD_TLS_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.com:+]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Queue-Id: 425CA6B565
X-Spam-Level: 

This involves:

- The ASSERT() inside end_bbio_data_write()
  It's only an ASSERT() and it has never been triggered as far as I
  know.

- The unlikely() check inside extent_writepage_io()
  Introduce a helper, btrfs_ordered_extent_in_range(), to replace the
  folio_test_ordered().

- btrfs_migrate_folio()
  Since all folio_test_ordered() will be removed, there is no need to
  copy the folio ordered flag.

- The ASSERT() inside btrfs_invalidate_folio()
  This one has its usefulness as it indeed caught some bugs during
  development.
  But that's the last user and will not be worth the folio flag nor
  subpage bitmap.

This will allow btrfs to finally remove the ordered flags.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/extent_io.c    |  3 +--
 fs/btrfs/inode.c        | 12 ------------
 fs/btrfs/ordered-data.h | 16 ++++++++++++++++
 3 files changed, 17 insertions(+), 14 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 5cab9e7a5762..d178f48ee5f0 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -531,7 +531,6 @@ static void end_bbio_data_write(struct btrfs_bio *bbio)
 		u32 len = fi.length;
 
 		bio_size += len;
-		ASSERT(btrfs_folio_test_ordered(fs_info, folio, start, len));
 		btrfs_folio_clear_ordered(fs_info, folio, start, len);
 		btrfs_folio_clear_writeback(fs_info, folio, start, len);
 	}
@@ -1754,7 +1753,7 @@ static noinline_for_stack int extent_writepage_io(struct btrfs_inode *inode,
 	ASSERT(end <= folio_end, "start=%llu len=%u folio_start=%llu folio_size=%zu",
 	       start, len, folio_start, folio_size(folio));
 
-	if (unlikely(!folio_test_ordered(folio))) {
+	if (unlikely(!btrfs_ordered_extent_in_range(inode, start, len))) {
 		DEBUG_WARN();
 		btrfs_err_rl(fs_info,
 	"root %lld ino %llu folio %llu is marked dirty without notifying the fs",
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index eaae344804f2..61cec1a66baf 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -7499,12 +7499,6 @@ static int btrfs_migrate_folio(struct address_space *mapping,
 
 	if (ret)
 		return ret;
-
-	if (folio_test_ordered(src)) {
-		folio_clear_ordered(src);
-		folio_set_ordered(dst);
-	}
-
 	return 0;
 }
 #else
@@ -7672,12 +7666,6 @@ static void btrfs_invalidate_folio(struct folio *folio, size_t offset,
 	}
 	btrfs_folio_clear_dirty(fs_info, folio, page_start, folio_size(folio));
 	btrfs_clear_folio_dirty_tag(folio);
-	/*
-	 * We have iterated through all ordered extents of the page, the page
-	 * should not have Ordered anymore, or the above iteration
-	 * did something wrong.
-	 */
-	ASSERT(!folio_test_ordered(folio));
 	if (!inode_evicting)
 		__btrfs_release_folio(folio, GFP_NOFS);
 	clear_folio_extent_mapped(folio);
diff --git a/fs/btrfs/ordered-data.h b/fs/btrfs/ordered-data.h
index 03e12380a2fd..3a4ed8d59aca 100644
--- a/fs/btrfs/ordered-data.h
+++ b/fs/btrfs/ordered-data.h
@@ -208,6 +208,22 @@ struct btrfs_ordered_extent *
 btrfs_lookup_first_ordered_extent(struct btrfs_inode *inode, u64 file_offset);
 struct btrfs_ordered_extent *btrfs_lookup_first_ordered_range(
 			struct btrfs_inode *inode, u64 file_offset, u64 len);
+
+/* Check if there is an ordered extent in range. */
+static inline bool btrfs_ordered_extent_in_range(struct btrfs_inode *inode,
+						 u64 file_offset, u64 len)
+{
+	struct btrfs_ordered_extent *ordered;
+	bool ret = false;
+
+	ordered = btrfs_lookup_first_ordered_range(inode, file_offset, len);
+	if (ordered) {
+		ret = true;
+		btrfs_put_ordered_extent(ordered);
+	}
+	return ret;
+}
+
 struct btrfs_ordered_extent *btrfs_lookup_ordered_range(
 		struct btrfs_inode *inode,
 		u64 file_offset,
-- 
2.54.0

