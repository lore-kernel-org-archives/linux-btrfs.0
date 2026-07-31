Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69D2A298CC4
	for <linux-btrfs@vger.kernel.org>; Fri, 31 Jul 2026 00:45:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785458732; cv=none; b=nEEiRDakgexF0kN0pHhaORemmPyJwZu7AKpc5l8c1j20SrvgtDdoFuoJ1LP8U4D8b3/nRXyekWj5YJyUGOIeeTWLsM1+a6I2bnTTkuB88D1AO6BSoYmQeVgZOpGgrZGS1rj5mHtCFupvoSUhR5PrLF5LvY6E5js7P//TSbrfhz0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785458732; c=relaxed/simple;
	bh=BzUg1vrNL7qcLUwJdqm8f6vH/rfeER7kubVAB3CeN/k=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y0LyPBvn5MyFSrSdS8t/s/1fUZnwOG+uwK8z8RU9cIkEStwM1aEY6v+aQHunJjYNWKYQHcis/JCBNte6quj7bhXn2F6mAGekxVjKLQgFwZxwOL3O5adSc17j/f8ETEefIen8Q6Rw33SsfZ0eZ9pqoP//28+VswRuUHZqhK3hlK0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=u11wj1IG; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=nA7Gr1gQ; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="u11wj1IG";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="nA7Gr1gQ"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 029683F69
	for <linux-btrfs@vger.kernel.org>; Fri, 31 Jul 2026 00:45:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1785458725; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=OneAryGj9u+XGCeILQNS7oGgGG6z6n+gbmlzBoLNzg4=;
	b=u11wj1IGS2n/oA3ztdnAGo2mtFKa+4o9Zc+8MrBR3Jvz1omuVd1U7eW/uWXhyyG/3zfZLR
	lNFb3iye47CmUw/JuFURPB/3nJH3npMOOnFA+/hiwG7YWVwCrSFPpxSrSnjBK+7NsokTgX
	8C5f3k8BIoka4yhr6RNFaQtJbyHB0jk=
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1785458721; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=OneAryGj9u+XGCeILQNS7oGgGG6z6n+gbmlzBoLNzg4=;
	b=nA7Gr1gQ2VeiERLnXuoariKHQEkxhv84AbXQCsuYlwOeLdhCG0L/RIhUPeF8qWF4Tc2OgV
	xZCtJsIXNvqJl1QY41dzL3I90F7v21OZelZ/HqVTpLCXtlAc8HTx2dSHa0OY5Jass4oUUp
	tKFciNTSPm6Ko7OGOw/UXvfFBMu+jxI=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 03870779C7
	for <linux-btrfs@vger.kernel.org>; Fri, 31 Jul 2026 00:45:19 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id aH9iKR/wa2qCZgAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Fri, 31 Jul 2026 00:45:19 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 2/2] btrfs: add extra ASSERT()s to make sure the folio size is correct
Date: Fri, 31 Jul 2026 10:14:50 +0930
Message-ID: <b3bfbf9e4941eff362b6d987c88be91365748500.1785457950.git.wqu@suse.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <cover.1785457950.git.wqu@suse.com>
References: <cover.1785457950.git.wqu@suse.com>
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,suse.com:mid,imap1.dmz-prg2.suse.org:helo];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	RCVD_TLS_ALL(0.00)[]

Inspired by the previous crash exposed by generic/795, we want to make
sure every folio from btrfs page cache is properly aligned to block
size.

This is especially important for bs > ps support, as every btrfs
infrastructure, e.g. extent map and extent state, requires strong block
alignment checks.

Furthermore, also output the minimal folio order from the inode mapping,
which is the determining factor during debugging, helping a lot pinning
down the final cause.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/extent_io.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index c7c3f138fb69..5641eb88e3d0 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -1392,6 +1392,22 @@ static void lock_extents_for_read(struct btrfs_inode *inode, u64 start, u64 end,
 	}
 }
 
+static void assert_folio_range(const struct btrfs_inode *inode,
+			       u64 start, u64 end)
+{
+	const u32 blocksize = inode->root->fs_info->sectorsize;
+
+	/*
+	 * For btrfs page cache, a folio always contains at least one block,
+	 * so the range should always be block size aligned.
+	 */
+	ASSERT(IS_ALIGNED(start, blocksize) && IS_ALIGNED(end + 1, blocksize),
+	       "blocksize=%u root=%lld ino=%llu start=%llu end=%llu mapping min order=%u",
+	       blocksize, btrfs_root_id(inode->root), btrfs_ino(inode),
+	       start, end,
+	       mapping_min_folio_order(inode->vfs_inode.i_mapping));
+}
+
 int btrfs_read_folio(struct file *file, struct folio *folio)
 {
 	struct inode *vfs_inode = folio->mapping->host;
@@ -1407,6 +1423,7 @@ int btrfs_read_folio(struct file *file, struct folio *folio)
 	struct fsverity_info *vi = NULL;
 	int ret;
 
+	assert_folio_range(inode, start, end);
 	lock_extents_for_read(inode, start, end, &cached_state);
 	if (folio_pos(folio) < i_size_read(vfs_inode))
 		vi = fsverity_get_info(vfs_inode);
@@ -1914,6 +1931,7 @@ static noinline_for_stack int extent_writepage_io(struct btrfs_inode *inode,
 	ASSERT(start >= folio_start, "start=%llu folio_start=%llu", start, folio_start);
 	ASSERT(end <= folio_end, "start=%llu len=%u folio_start=%llu folio_size=%zu",
 	       start, len, folio_start, folio_size(folio));
+	assert_folio_range(inode, folio_start, folio_end - 1);
 
 	/*
 	 * We are about to checksum and write out the data, so it must not be
@@ -2976,6 +2994,7 @@ void btrfs_readahead(struct readahead_control *rac)
 	struct extent_map *em_cached = NULL;
 	struct fsverity_info *vi = NULL;
 
+	assert_folio_range(inode, start, end);
 	lock_extents_for_read(inode, start, end, &cached_state);
 	/* We don't use cached state for a bulk unlock, just free it. */
 	btrfs_free_extent_state(cached_state);
-- 
2.54.0

