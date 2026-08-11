Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E8A840A94A
	for <linux-btrfs@vger.kernel.org>; Tue, 11 Aug 2026 06:46:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786430776; cv=none; b=DRae6lXl5XbLkA2bcNSwCsraumJQc3kpKW4GLxwtkDxFFkYapG+DJEKw7nFoGrYHUqRdyUKgiLS6bmj1H/umgSxM7YcaZJovYtqz1eFyI4cYHTwFtGRJbGb6iMGauZs74jsoLD0SgdLOtAcxy1iOYn7S0in4WHHZgdI0aDcXFJ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786430776; c=relaxed/simple;
	bh=FguOy2720Vaq5OXlNbIDR14kxZa4YzgreZytGIzFN4E=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=pZlUE8EEhvFaEwnw6Ubz0oGL5hjh577qHGQmN6UX0oKpHKSJq/dM2GW0fsYqPz2qK0+N52Fb2duTYatiIoQRb8+4J2NGNBxb0oNQWB3Xlr3pwGhByZvi5M2w8Lvymqj60yUxahigdkcYnxPM/sNke7xR/r9mpCvT7W6IG2PV+6s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=hwNf14Ff; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=H81dcF1o; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="hwNf14Ff";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="H81dcF1o"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 9ADD33DF2
	for <linux-btrfs@vger.kernel.org>; Tue, 11 Aug 2026 06:45:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1786430761; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=7ilepfcfXoBoyrJlrFidKPBNv4p7RnPnmiTWUnqvGCY=;
	b=hwNf14Ffxdn3HElqTmWjpiHHNhqaSmalr6f3lZB6b6oslU1nRJuAELk8InIBxFOV+S5tV3
	3JAqrLss8GIktYw9KIiIoKvba/xFA4CCTQLYLc3mxuT8nBCG7aheu4jHZ6vp5NcZI4SUmk
	pcpiYW+J/8s33h3wxI52N0nXsP//IfE=
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1786430757; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=7ilepfcfXoBoyrJlrFidKPBNv4p7RnPnmiTWUnqvGCY=;
	b=H81dcF1oLQi5rDSwy2Fc/DcGz6rajOM0bHrwgtBPAcmPFCWswR5ajmXexBd5Ht6YDXElOc
	kfPk7uAG3G1+ukN0g1nv1Xhjl6mkM+pGaiCpZV+EPh582MDKpXIyb4OhNhQeL+5Oxb77m/
	tc0E6kHwG6zOujUV96r93EueN+yQVXQ=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 82520779B2
	for <linux-btrfs@vger.kernel.org>; Tue, 11 Aug 2026 06:45:56 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id mVc+CiTFemrnXQAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Tue, 11 Aug 2026 06:45:56 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs: prevent length underflow in extent_fiemap()
Date: Tue, 11 Aug 2026 16:15:29 +0930
Message-ID: <bb1a42fcf03d1c3f74382459b47bb9af0c7c3f24.1786430714.git.wqu@suse.com>
X-Mailer: git-send-email 2.54.0
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
	NEURAL_HAM_SHORT(-0.20)[-1.000];
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

When doing a ranged fiemap ioctl, if we have filled the fiemap buffer,
emit_fiemap_extent() will return a special code,
BTRFS_FIEMAP_FLUSH_CACHE, to indicate that we need to unlock the inode
and flush the fiemap cache and retry.

However inside that BTRFS_FIEMAP_FLUSH_CACHE handling, we're reducing
@len by "cache.next_search_offset - @start".

Meanwhile cache.next_search_offset can be beyond @start + @len, this is
common for any extent that crosses @start + @len, as we do not clamp the
extent range to the original range.

This means if we hit an extent extending beyond @start + @len, and we
need to flush the fiemap cache, our @len will underflow to a very large
value.
Then on the next loop, @start is larger than @start + @len, causing an
invalid range to be passed into btrfs_lock_extent().

Prevent such underflow by clamping down the range before retry, and also
enhance validate_extent_state() to catch such odd extent state.

This was reported by Sashiko, which caught this pre-existing bug while
reviewing another patch.

Link: https://sashiko.dev/#/patchset/cover.1785220613.git.wqu%40suse.com
Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/extent-io-tree.c |  5 +++--
 fs/btrfs/fiemap.c         | 10 +++++++---
 2 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/extent-io-tree.c b/fs/btrfs/extent-io-tree.c
index d6df11f6088c..28ed8e04ecfe 100644
--- a/fs/btrfs/extent-io-tree.c
+++ b/fs/btrfs/extent-io-tree.c
@@ -344,8 +344,9 @@ static void validate_extent_state(const struct extent_io_tree *tree,
 
 	blocksize = btrfs_extent_io_tree_to_fs_info(tree)->sectorsize;
 	ASSERT(IS_ALIGNED(state->start, blocksize) &&
-	       IS_ALIGNED(state->end + 1, blocksize),
-	       "unaligned extent state, blocksize=%u start=%llu end=%llu state=0x%x",
+	       IS_ALIGNED(state->end + 1, blocksize) &&
+	       state->end > state->start,
+	       "invalid extent state, blocksize=%u start=%llu end=%llu state=0x%x",
 	       blocksize, state->start, state->end, state->state);
 }
 
diff --git a/fs/btrfs/fiemap.c b/fs/btrfs/fiemap.c
index 7a2a97180099..53dd186d71f6 100644
--- a/fs/btrfs/fiemap.c
+++ b/fs/btrfs/fiemap.c
@@ -843,13 +843,17 @@ static int extent_fiemap(struct btrfs_inode *inode,
 	btrfs_unlock_extent(&inode->io_tree, range_start, range_end - 1, &cached_state);
 
 	if (ret == BTRFS_FIEMAP_FLUSH_CACHE) {
+		const u64 orig_start = start;
+		const u64 orig_len = len;
+
 		btrfs_release_path(path);
 		ret = flush_fiemap_cache(fieinfo, &cache);
 		if (ret)
 			goto out;
-		len -= cache.next_search_offset - start;
-		start = cache.next_search_offset;
-		goto restart;
+		start = min(orig_start + orig_len, cache.next_search_offset);
+		len = orig_start + orig_len - start;
+		if (len)
+			goto restart;
 	} else if (ret < 0) {
 		goto out;
 	}
-- 
2.54.0

