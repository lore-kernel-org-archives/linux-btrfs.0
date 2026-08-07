Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8DAA3D668F
	for <linux-btrfs@vger.kernel.org>; Fri,  7 Aug 2026 09:38:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786095530; cv=none; b=SIAE/kjvtajz+oXkZzuN131/WnBtkQxVIvhaz6bxNp34LWwx93YAHaXWSqNucCmgzSFkEO57jQPF5TSK4pJ3lnWI1i9646yW3lwbAZimk+5vGNVNjjxdhsmyR9nDVxadslLZjpURWooZsAms4V+7eGzG8c4s8TwuQuY8W2hq070=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786095530; c=relaxed/simple;
	bh=L5bjYpMA2ptempYRe2AqK47zrKs06czBFKM2Uswe8yc=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k8erVw1HsdD771wyn9q6r8LHmgAAkKUD14mysfi3f8DgkIXnmRhbSUbncUaWfn4cF4OoYLdMphyJdmgeV0feDdwXysK58XJsF9IPfSyH50x3TbDiNjnl2nrw4i3/TiUO0M5tCz2U+B9Jy43UApTw4M8xA2RsJKW2dk2hNoQ+Ssw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=U/dBDtVH; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=VahAw37Q; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="U/dBDtVH";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="VahAw37Q"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 074F73E07
	for <linux-btrfs@vger.kernel.org>; Fri,  7 Aug 2026 09:38:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1786095523; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jCXZFAIh3WtBIgT56N9ENzwihdgLDEI+3lXA/r09AFQ=;
	b=U/dBDtVHL32WoOfzodAH2chY4MMP0QkVSPIXqbujAe7ophTmnZJOWVDhblZ3bEO6bFzUiU
	7weV78q9928Jp6kFTbtik7Fmlbqko7osn/aojYOMlS9pEBc+6Beh5JIvYJct354TnM777x
	NldqnC9EdDMuPXuPXEkhXFPVeXf/bUg=
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1786095519; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jCXZFAIh3WtBIgT56N9ENzwihdgLDEI+3lXA/r09AFQ=;
	b=VahAw37Q35cEy6v+CC6J9Zr1cqmjAaMNpZzKnX+Eya/hB83bsYn3AW9c/Q1a+5P17rhu5X
	MPTj1w2Eg3XUR4F/GhRqvnV3HuBlXDpuZoNscjh5iUGEWUP0E02A2M1MMMEAxFxRmE2Bsv
	ZgBFqCVsg0NlMNoWreAB0qR27DTGOak=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 0850C779BF
	for <linux-btrfs@vger.kernel.org>; Fri,  7 Aug 2026 09:38:37 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id iLKfKp2ndWp0EwAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Fri, 07 Aug 2026 09:38:37 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 1/2] btrfs: remove NULL fs_info checks in subpage helpers
Date: Fri,  7 Aug 2026 19:08:08 +0930
Message-ID: <6bc3cb3de847ebe8f9c472766ec940b4dc03f5d8.1786095309.git.wqu@suse.com>
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.com:mid,suse.com:email];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	RCVD_TLS_ALL(0.00)[]
X-Spam-Flag: NO
X-Spam-Score: -2.80
X-Spam-Level: 

We have several "unlikely(!fs_info)" checks inside subpage helpers, this
behavior was to avoid NULL pointer dereference for extent-io-tests,
where we have a dummy inode for testing but without an fs_info/root for
that testing inode.

However commit b2136cc288fc ("btrfs: tests: allocate dummy fs_info and
root in test_find_delalloc()") changed the test to properly allocate an
fs_info and root, so even for that selftest, we will have a proper
fs_info for btrfs_folio_*() helpers.

So there is no need to do that "unlikely(!fs_info)" check, as it will
always return false now.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/subpage.c | 27 ++++++++-------------------
 1 file changed, 8 insertions(+), 19 deletions(-)

diff --git a/fs/btrfs/subpage.c b/fs/btrfs/subpage.c
index ebf18efe1ea3..72402ea156d3 100644
--- a/fs/btrfs/subpage.c
+++ b/fs/btrfs/subpage.c
@@ -246,7 +246,7 @@ void btrfs_folio_end_lock(const struct btrfs_fs_info *fs_info,
 
 	ASSERT(folio_test_locked(folio));
 
-	if (unlikely(!fs_info) || !btrfs_is_subpage(fs_info, folio)) {
+	if (!btrfs_is_subpage(fs_info, folio)) {
 		folio_unlock(folio);
 		return;
 	}
@@ -688,18 +688,12 @@ IMPLEMENT_BTRFS_SUBPAGE_TEST_OP(dirty);
 IMPLEMENT_BTRFS_SUBPAGE_TEST_OP(writeback);
 IMPLEMENT_BTRFS_SUBPAGE_TEST_OP(fixup);
 
-/*
- * Note that, in selftests (extent-io-tests), we can have empty fs_info passed
- * in.  We only test sectorsize == PAGE_SIZE cases so far, thus we can fall
- * back to regular sectorsize branch.
- */
 #define IMPLEMENT_BTRFS_PAGE_OPS(name, folio_set_func,			\
 				 folio_clear_func, folio_test_func)	\
 void btrfs_folio_set_##name(const struct btrfs_fs_info *fs_info,	\
 			    struct folio *folio, u64 start, u32 len)	\
 {									\
-	if (unlikely(!fs_info) ||					\
-	    !btrfs_is_subpage(fs_info, folio)) {			\
+	if (!btrfs_is_subpage(fs_info, folio)) {			\
 		folio_set_func(folio);					\
 		return;							\
 	}								\
@@ -708,8 +702,7 @@ void btrfs_folio_set_##name(const struct btrfs_fs_info *fs_info,	\
 void btrfs_folio_clear_##name(const struct btrfs_fs_info *fs_info,	\
 			      struct folio *folio, u64 start, u32 len)	\
 {									\
-	if (unlikely(!fs_info) ||					\
-	    !btrfs_is_subpage(fs_info, folio)) {			\
+	if (!btrfs_is_subpage(fs_info, folio)) {			\
 		folio_clear_func(folio);				\
 		return;							\
 	}								\
@@ -718,16 +711,14 @@ void btrfs_folio_clear_##name(const struct btrfs_fs_info *fs_info,	\
 bool btrfs_folio_test_##name(const struct btrfs_fs_info *fs_info,	\
 			     struct folio *folio, u64 start, u32 len)	\
 {									\
-	if (unlikely(!fs_info) ||					\
-	    !btrfs_is_subpage(fs_info, folio))				\
+	if (!btrfs_is_subpage(fs_info, folio))				\
 		return folio_test_func(folio);				\
 	return btrfs_subpage_test_##name(fs_info, folio, start, len);	\
 }									\
 void btrfs_folio_clamp_set_##name(const struct btrfs_fs_info *fs_info,	\
 				  struct folio *folio, u64 start, u32 len) \
 {									\
-	if (unlikely(!fs_info) ||					\
-	    !btrfs_is_subpage(fs_info, folio)) {			\
+	if (!btrfs_is_subpage(fs_info, folio)) {			\
 		folio_set_func(folio);					\
 		return;							\
 	}								\
@@ -737,8 +728,7 @@ void btrfs_folio_clamp_set_##name(const struct btrfs_fs_info *fs_info,	\
 void btrfs_folio_clamp_clear_##name(const struct btrfs_fs_info *fs_info, \
 				    struct folio *folio, u64 start, u32 len) \
 {									\
-	if (unlikely(!fs_info) ||					\
-	    !btrfs_is_subpage(fs_info, folio)) {			\
+	if (!btrfs_is_subpage(fs_info, folio)) {			\
 		folio_clear_func(folio);				\
 		return;							\
 	}								\
@@ -748,8 +738,7 @@ void btrfs_folio_clamp_clear_##name(const struct btrfs_fs_info *fs_info, \
 bool btrfs_folio_clamp_test_##name(const struct btrfs_fs_info *fs_info,	\
 				   struct folio *folio, u64 start, u32 len) \
 {									\
-	if (unlikely(!fs_info) ||					\
-	    !btrfs_is_subpage(fs_info, folio))				\
+	if (!btrfs_is_subpage(fs_info, folio))				\
 		return folio_test_func(folio);				\
 	btrfs_subpage_clamp_range(folio, &start, &len);			\
 	return btrfs_subpage_test_##name(fs_info, folio, start, len);	\
@@ -882,7 +871,7 @@ void btrfs_folio_set_lock(const struct btrfs_fs_info *fs_info,
 	int ret;
 
 	ASSERT(folio_test_locked(folio));
-	if (unlikely(!fs_info) || !btrfs_is_subpage(fs_info, folio))
+	if (!btrfs_is_subpage(fs_info, folio))
 		return;
 
 	bfs = folio_get_private(folio);
-- 
2.54.0

