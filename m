Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6749F2F3632
	for <linux-btrfs@vger.kernel.org>; Thu, 10 Sep 2026 02:06:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789005985; cv=none; b=krCLonPgfpLIDOPnjO00sOH4l0B23KwI8iDJcnm1AvjFNBoiQBxz/WgBM3V6jsRBoIPOh2FT6h5YD4wLgyh8gng+NHfOn86Z88Z/CqhFQGWCqAhxDr5PQhy2z6w9zpkd/ULadTNyT10XZMJhw0Znrwbvv3weRfE2INnKBvdGUFU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789005985; c=relaxed/simple;
	bh=k8x+ezR1B4RFWchUGc6lmbpIJvYtDvuB9Y634kZkhd0=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kA+7yO4Cu1PgH/U4l/L0upo8tKgJOH+TjpJD0q5/nC9Z7zRriWyh6CK939U6swNMfPz7jZ1JYaa//fMYsrOKvO6O03aS4z1oTx1hfZTK5mZXI1th2EB/Q1ATFWEoSyqb6gN+iRZ3gNtZmtvN64KZbdV2QTxB5Eq8JvplDHbNdLU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=DdZhQBBH; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=YXVGJTwO; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="DdZhQBBH";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="YXVGJTwO"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 53EE41FD5F
	for <linux-btrfs@vger.kernel.org>; Thu, 10 Sep 2026 02:06:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1789005978; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=V0zfaIQrjLdceSAqlQQheIp1p6bRjQo4fYGCGYo48fI=;
	b=DdZhQBBHeCZmDTra+2YQIlpPynTLQLoJrWaiIHrKfkaqB2vjBy3rbH0gmft6odvLir+Umc
	JDvIdKPVIUlwfyZRpUE1v/W2rsY4H3LGOIx1R/Bt77z0IIZ9OQf/69qGYPQqNZ5VZYZxRj
	QeWZIZE9nkSKvOGf4p39v+hjbcy1jmk=
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=YXVGJTwO
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1789005974; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=V0zfaIQrjLdceSAqlQQheIp1p6bRjQo4fYGCGYo48fI=;
	b=YXVGJTwO0FeXC/zyaXk5Zz7mw/3nQtI1Bypx2AaM8ASWvrOujVXc8z7ax8sP79rAK8G4BW
	ox4TflxUbpGXtZET2WcGR6DTeIUkHDD9YhmdFe2CE8la4ah5PGGagHcxmXvXAjKBlpVElo
	8yj2qBaoAXk28tQfDJoULWYQBxdNSis=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 3D27B13883
	for <linux-btrfs@vger.kernel.org>; Thu, 10 Sep 2026 02:06:12 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id mDuVN5QQomqaHgAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Thu, 10 Sep 2026 02:06:12 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 1/2] btrfs: fix off-by-one end related to inode_need_compress()
Date: Thu, 10 Sep 2026 11:35:52 +0930
Message-ID: <a617618bc5199f045759e47022e25ee053fd15ec.1789003160.git.wqu@suse.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <cover.1789003160.git.wqu@suse.com>
References: <cover.1789003160.git.wqu@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Score: -3.01
X-Rspamd-Queue-Id: 53EE41FD5F
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spam-Level: 
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-3.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCPT_COUNT_ONE(0.00)[1];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	FROM_EQ_ENVFROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:dkim,suse.com:email,suse.com:mid,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	RCVD_TLS_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	DKIM_TRACE(0.00)[suse.com:+]
X-Spam-Flag: NO

In most cases btrfs uses @end as the inclusive end bytenr for a range,
and this applies to inode_need_compress().

However we have several sites not following the inclusive bytenr:

- run_delalloc_inline()
  Which assigned @blocksize as @end for inode_need_compress()

  This makes inode_need_compress() always skip the disk_i_size check.

- heuristic_collect_sample()
  Which assigned "start + BTRFS_MAX_UNCOMPRESSED" to @end, which is
  the exclusive bytenr.

Neither is really causing any real problem, as
heuristic_collect_sample() has proper checks to avoid reading anything
beyond @end, and the sampling read size is 16 bytes, so it has enough
headroom to handle that off-by-one problem.

But still I do not like anything out of the common scheme, so fix the
off-by-one @end for both call sites, and add extra ASSERT()s to catch
such unaligned parameters.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/compression.c | 15 +++++++--------
 fs/btrfs/inode.c       |  5 ++++-
 2 files changed, 11 insertions(+), 9 deletions(-)

diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
index 20169d028961..0134b9253702 100644
--- a/fs/btrfs/compression.c
+++ b/fs/btrfs/compression.c
@@ -1488,11 +1488,14 @@ static bool sample_repeated_patterns(struct heuristic_ws *ws)
 static void heuristic_collect_sample(struct inode *inode, u64 start, u64 end,
 				     struct heuristic_ws *ws)
 {
+	const u32 blocksize = BTRFS_I(inode)->root->fs_info->sectorsize;
 	struct folio *folio;
 	pgoff_t index, index_end;
 	u32 i, curr_sample_pos;
 	u8 *in_data;
 
+	ASSERT(IS_ALIGNED(start, blocksize) && IS_ALIGNED(end + 1, blocksize));
+
 	/*
 	 * Compression handles the input data by chunks of 128KiB
 	 * (defined by BTRFS_MAX_UNCOMPRESSED)
@@ -1502,18 +1505,14 @@ static void heuristic_collect_sample(struct inode *inode, u64 start, u64 end,
 	 * MAX_SAMPLE_SIZE - calculated under assumption that heuristic will
 	 * process no more than BTRFS_MAX_UNCOMPRESSED at a time.
 	 */
-	if (end - start > BTRFS_MAX_UNCOMPRESSED)
-		end = start + BTRFS_MAX_UNCOMPRESSED;
+	if (end + 1 - start > BTRFS_MAX_UNCOMPRESSED)
+		end = start + BTRFS_MAX_UNCOMPRESSED - 1;
 
 	index = start >> PAGE_SHIFT;
 	index_end = end >> PAGE_SHIFT;
 
-	/* Don't miss unaligned end */
-	if (!PAGE_ALIGNED(end))
-		index_end++;
-
 	curr_sample_pos = 0;
-	while (index < index_end) {
+	while (index <= index_end) {
 		folio = filemap_get_folio(inode->i_mapping, index);
 		ASSERT(!IS_ERR(folio));
 		in_data = kmap_local_folio(folio,
@@ -1522,7 +1521,7 @@ static void heuristic_collect_sample(struct inode *inode, u64 start, u64 end,
 		i = start % PAGE_SIZE;
 		while (i < PAGE_SIZE - SAMPLING_READ_SIZE) {
 			/* Don't sample any garbage from the last page */
-			if (start > end - SAMPLING_READ_SIZE)
+			if (start > end + 1 - SAMPLING_READ_SIZE)
 				break;
 			memcpy(&ws->sample[curr_sample_pos], &in_data[i],
 					SAMPLING_READ_SIZE);
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index a85a7c561cf8..79f2181dc631 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -730,6 +730,9 @@ static inline int inode_need_compress(struct btrfs_inode *inode, u64 start,
 				      u64 end, bool check_inline)
 {
 	struct btrfs_fs_info *fs_info = inode->root->fs_info;
+	const u32 blocksize = fs_info->sectorsize;
+
+	ASSERT(IS_ALIGNED(start, blocksize) && IS_ALIGNED(end + 1, blocksize));
 
 	if (unlikely(!btrfs_inode_can_compress(inode))) {
 		DEBUG_WARN("BTRFS: unexpected compression for ino %llu", btrfs_ino(inode));
@@ -2331,7 +2334,7 @@ static int run_delalloc_inline(struct btrfs_inode *inode, struct folio *locked_f
 	btrfs_check_folio_write_protected(locked_folio);
 
 	if (btrfs_inode_can_compress(inode) &&
-	    inode_need_compress(inode, 0, blocksize, true)) {
+	    inode_need_compress(inode, 0, blocksize - 1, true)) {
 		if (inode->defrag_compress > 0 &&
 		    inode->defrag_compress < BTRFS_NR_COMPRESS_TYPES) {
 			compress_type = inode->defrag_compress;
-- 
2.55.0

