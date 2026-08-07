Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A73163EE1E0
	for <linux-btrfs@vger.kernel.org>; Fri,  7 Aug 2026 09:38:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786095532; cv=none; b=b3DZIZAgtjKyOGA0Azp0D5ZgaJ5Vlbgh4YPoWPDM6hDE8is5hCDvPVbfpjYgi2cdqJZZCNWkGPk9DoivHyAgz8zotzzB17PWot78JuMTa6X6U7qByQZceIOKw3twiUS55pWl80tL7QhLkAT/tCTRZHBIGmdQCwLaX6Kdwwgf+zA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786095532; c=relaxed/simple;
	bh=OIRb8/4GilL7NKsK0eXtmHQ3JS738cGA+g2ZOtchSSw=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ulZ5ckazGuaLs4WtiHDBC0R00fHd4dUo/jDVanp9A/qs+RENA1iPC1BCz+/sm51O/zg/H4acNxej/XwXbjE+WiMAdQSUWeD459HYf9tog38cgGMqBlWhAFabh4b7u4tsLLMsrPIAjAel39qpajNlYaB2s68fDLmF+voh8m7lPFM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=usJfmPVv; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=ciTvXHu4; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="usJfmPVv";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="ciTvXHu4"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 9A86580541
	for <linux-btrfs@vger.kernel.org>; Fri,  7 Aug 2026 09:38:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1786095524; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=d/iGcir491uu3575i0nZCOkJLZIU3yMyBmXvxkJ4Uv4=;
	b=usJfmPVvD+md91SotNX5RT0TvZrF68vxBj5l1UszL00ZnNdT5yg8SFNxpUyYqixbUSkfeP
	7Uk4bqRO5zuHhLHlRfBr33dyw47XLHkUeZOKbfzQ3pPLCdA4gFqcMCuXOBSBhlD0w+4Br3
	EapWvZHk0u6gozmtzUwGfAeKcyhxaxQ=
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1786095520; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=d/iGcir491uu3575i0nZCOkJLZIU3yMyBmXvxkJ4Uv4=;
	b=ciTvXHu4Cg2jgb9eT0VIg2zY34Vyr64hq+7Saa4PIWv9oJxRUawcXq92iWOATU2tZRN9ex
	aWs2BeJzIn7D/XB0FR8Nfr3LXtcsftXKOX46OKF/WxmrRBWwYHIjjDNwZ4t7ZaOF3V0oFR
	s183204lCBmsmm2UgB/Vyy0/t2rgeL4=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 9B439779C3
	for <linux-btrfs@vger.kernel.org>; Fri,  7 Aug 2026 09:38:39 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id QDrIEp+ndWp0EwAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Fri, 07 Aug 2026 09:38:39 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 2/2] btrfs: unify data and metadata subpage handling
Date: Fri,  7 Aug 2026 19:08:09 +0930
Message-ID: <9ac2d271797c1baada373e4825728ceb08f08fc7.1786095309.git.wqu@suse.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <cover.1786095309.git.wqu@suse.com>
References: <cover.1786095309.git.wqu@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Score: -2.80
X-Spam-Level: 
X-Spam-Flag: NO
X-Spamd-Result: default: False [-2.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-0.999];
	MIME_GOOD(-0.10)[text/plain];
	ARC_NA(0.00)[];
	RCPT_COUNT_ONE(0.00)[1];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.com:email,suse.com:mid];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	RCVD_TLS_ALL(0.00)[]

Currently we have split data and metadata subpage handling, this is due
to the fact that data and metadata have very different conditions to
determine if a folio needs subpage handling.

But the condition different is not that huge, it's just checking
different values.
For data it's checking if the sectorsize is smaller than folio size, for
metadata it doesn't even need to bother folio size yet, as we have not
yet support large folios for metadata.

The idea is to merge btrfs_meta_is_subpage() into btrfs_is_subpage(),
so that btrfs_is_subpage() is the only entrance to check if a folio
needs subpage handling.

With that said, all the existing btrfs_meta_folio_*() helpers can be
updated to a very simple wrapper to the corresponding btrfs_folio_*()
helper.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/subpage.c | 23 +----------------------
 fs/btrfs/subpage.h | 45 ++++++++++++++++++++++++++++++++-------------
 2 files changed, 33 insertions(+), 35 deletions(-)

diff --git a/fs/btrfs/subpage.c b/fs/btrfs/subpage.c
index 72402ea156d3..7e760934cab8 100644
--- a/fs/btrfs/subpage.c
+++ b/fs/btrfs/subpage.c
@@ -742,29 +742,8 @@ bool btrfs_folio_clamp_test_##name(const struct btrfs_fs_info *fs_info,	\
 		return folio_test_func(folio);				\
 	btrfs_subpage_clamp_range(folio, &start, &len);			\
 	return btrfs_subpage_test_##name(fs_info, folio, start, len);	\
-}									\
-void btrfs_meta_folio_set_##name(struct folio *folio, const struct extent_buffer *eb) \
-{									\
-	if (!btrfs_meta_is_subpage(eb->fs_info)) {			\
-		folio_set_func(folio);					\
-		return;							\
-	}								\
-	btrfs_subpage_set_##name(eb->fs_info, folio, eb->start, eb->len); \
-}									\
-void btrfs_meta_folio_clear_##name(struct folio *folio, const struct extent_buffer *eb) \
-{									\
-	if (!btrfs_meta_is_subpage(eb->fs_info)) {			\
-		folio_clear_func(folio);				\
-		return;							\
-	}								\
-	btrfs_subpage_clear_##name(eb->fs_info, folio, eb->start, eb->len); \
-}									\
-bool btrfs_meta_folio_test_##name(struct folio *folio, const struct extent_buffer *eb) \
-{									\
-	if (!btrfs_meta_is_subpage(eb->fs_info))			\
-		return folio_test_func(folio);				\
-	return btrfs_subpage_test_##name(eb->fs_info, folio, eb->start, eb->len); \
 }
+
 IMPLEMENT_BTRFS_PAGE_OPS(uptodate, folio_mark_uptodate, folio_clear_uptodate,
 			 folio_test_uptodate);
 IMPLEMENT_BTRFS_PAGE_OPS(dirty, btrfs_folio_mark_dirty_reserved,
diff --git a/fs/btrfs/subpage.h b/fs/btrfs/subpage.h
index 9b106a73d682..7e25d8d1d3bb 100644
--- a/fs/btrfs/subpage.h
+++ b/fs/btrfs/subpage.h
@@ -95,11 +95,23 @@ static inline bool btrfs_meta_is_subpage(const struct btrfs_fs_info *fs_info)
 {
 	return fs_info->nodesize < PAGE_SIZE;
 }
-static inline bool btrfs_is_subpage(const struct btrfs_fs_info *fs_info,
-				    struct folio *folio)
+
+static inline bool btrfs_folio_is_data(const struct folio *folio)
 {
-	if (folio->mapping && folio->mapping->host)
-		ASSERT(is_data_inode(BTRFS_I(folio->mapping->host)));
+	const struct address_space *mapping = folio_mapping(folio);
+
+	/* Only metadata folio can have no mapping for dummy ebs. */
+	if (!mapping || !mapping->host)
+		return false;
+	return is_data_inode(BTRFS_I(mapping->host));
+}
+
+/* This helper can be called on both data and metadata folios. */
+static inline bool btrfs_is_subpage(const struct btrfs_fs_info *fs_info,
+				    const struct folio *folio)
+{
+	if (!btrfs_folio_is_data(folio))
+		return btrfs_meta_is_subpage(fs_info);
 	return fs_info->sectorsize < folio_size(folio);
 }
 
@@ -140,12 +152,7 @@ void btrfs_folio_end_lock_bitmap(const struct btrfs_fs_info *fs_info,
  * need to be inside the page. Those functions will truncate the range
  * automatically.
  *
- * Both btrfs_folio_*() and btrfs_folio_clamp_*() are for data folios.
- *
- * For metadata, one should use btrfs_meta_folio_*() helpers instead, and there
- * is no clamp version for metadata helpers, as we either go subpage
- * (nodesize < PAGE_SIZE) or go regular folio helpers (nodesize >= PAGE_SIZE,
- * and our folio is never larger than nodesize).
+ * All helpers can be called on both data and metadata folios.
  */
 #define DECLARE_BTRFS_SUBPAGE_OPS(name)					\
 void btrfs_subpage_set_##name(const struct btrfs_fs_info *fs_info,	\
@@ -166,9 +173,21 @@ void btrfs_folio_clamp_clear_##name(const struct btrfs_fs_info *fs_info,	\
 		struct folio *folio, u64 start, u32 len);			\
 bool btrfs_folio_clamp_test_##name(const struct btrfs_fs_info *fs_info,	\
 		struct folio *folio, u64 start, u32 len);		\
-void btrfs_meta_folio_set_##name(struct folio *folio, const struct extent_buffer *eb); \
-void btrfs_meta_folio_clear_##name(struct folio *folio, const struct extent_buffer *eb); \
-bool btrfs_meta_folio_test_##name(struct folio *folio, const struct extent_buffer *eb);
+static inline void btrfs_meta_folio_set_##name(struct folio *folio,		\
+					       const struct extent_buffer *eb)	\
+{										\
+	btrfs_folio_set_##name(eb->fs_info, folio, eb->start, eb->len);		\
+}										\
+static inline void btrfs_meta_folio_clear_##name(struct folio *folio,		\
+						 const struct extent_buffer *eb) \
+{										\
+	btrfs_folio_clear_##name(eb->fs_info, folio, eb->start, eb->len);	\
+}										\
+static inline bool btrfs_meta_folio_test_##name(struct folio *folio,		\
+				  const struct extent_buffer *eb)		\
+{										\
+	return btrfs_folio_test_##name(eb->fs_info, folio, eb->start, eb->len);	\
+}
 
 DECLARE_BTRFS_SUBPAGE_OPS(uptodate);
 DECLARE_BTRFS_SUBPAGE_OPS(dirty);
-- 
2.54.0

