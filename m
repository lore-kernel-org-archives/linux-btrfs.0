Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C04DF35D5FC
	for <linux-btrfs@vger.kernel.org>; Wed, 11 Feb 2026 21:14:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770844489; cv=none; b=Up86BV5/0qa2xMhH7rMSKtHAF2K6UWwTJHxzCVa+9HcLNBUBMTNoEY9WmhQDhB5jUtcVLHFuAguZmNn0XDAdD0Z49N8iowqTcwRGAUJhAuWi/1pbCJCISZSGGlLcwjFjPZ7sRnirRl9o50jFB7wg+He+FlDr17hANvFJGa4qxaM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770844489; c=relaxed/simple;
	bh=ev7JI9cO3LeGE0qq8cySkX71aGIWdCy29S2zZdyIA7Q=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=HQ0MUvKCGiRvuaS45qk3axQGprT1u3J7lpBLFVfJw2ihJX97sfK2S5q3B5HgW6AJUNo9JpR0t9ISGNa3MdMa2UTJIpgN00RgonWL6/SbOWdt22iAW7HG3EEJdRNfgSwbi6g9m1CublBPEkrQmrklL5HLy3NMsOrel5MBqLF/Vao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=dVNKGCah; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=dVNKGCah; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="dVNKGCah";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="dVNKGCah"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 897BD5BDEC
	for <linux-btrfs@vger.kernel.org>; Wed, 11 Feb 2026 21:14:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1770844485; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=kXA3FzzcrnDmj8CVCHh8kkqgM5mTaoFtFd+t3PUqRco=;
	b=dVNKGCahjjzIq/eEhHhfUQwnrwed39c9+06JQ5YuVrKBhaW4lB7P4aZ2D5KMMDFgNMBy6m
	qkNt9I3tKmr9Fo7bdL4T45UkhGw+0iAb6RUkF98oKe9wq26tgglqZu/sLxN7sUrXEQRyuL
	c8XlhceBnNrH+Vdf2953FYd20TBDR0I=
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1770844485; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=kXA3FzzcrnDmj8CVCHh8kkqgM5mTaoFtFd+t3PUqRco=;
	b=dVNKGCahjjzIq/eEhHhfUQwnrwed39c9+06JQ5YuVrKBhaW4lB7P4aZ2D5KMMDFgNMBy6m
	qkNt9I3tKmr9Fo7bdL4T45UkhGw+0iAb6RUkF98oKe9wq26tgglqZu/sLxN7sUrXEQRyuL
	c8XlhceBnNrH+Vdf2953FYd20TBDR0I=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 7665A3EA62
	for <linux-btrfs@vger.kernel.org>; Wed, 11 Feb 2026 21:14:44 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id hIqxCETxjGmZWgAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Wed, 11 Feb 2026 21:14:44 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2] btrfs: remove out-of-date comments in btree_writepages()
Date: Thu, 12 Feb 2026 07:44:21 +1030
Message-ID: <270c2de0f0f5380088e8899e783471843a1f0172.1770844117.git.wqu@suse.com>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Score: -2.80
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
X-Spam-Level: 
X-Spam-Flag: NO

There is a lengthy comment introduced in commit b3ff8f1d380e ("btrfs:
Don't submit any btree write bio if the fs has errors") and commit
c9583ada8cc4 ("btrfs: avoid double clean up when submit_one_bio()
failed"), explaining two things:

- Why we don't want to submit metadata write if the fs has errors

- Why we re-set @ret to 0 if it's positive

However it's no longer uptodate by the following reasons:

- We have better checks nowadays

  Commit 2618849f31e7 ("btrfs: ensure no dirty metadata is written back
  for an fs with errors") has introduced better checks, that if the
  fs is in an error state, metadata writes will not result in any bio
  but instead complete immediately.

  That covers all metadata writes better.

- Mentioned incorrect function name

  The commit c9583ada8cc4 ("btrfs: avoid double clean up when
  submit_one_bio() failed") introduced this ret > 0 handling, but at that
  time the function name submit_extent_page() is already incorrect.

  It was submit_eb_page() that could return >0 at that time,
  and submit_extent_page() could only return 0 or <0 for errors, never >0.

  Later commit b35397d1d325 ("btrfs: convert submit_extent_page() to use
  a folio") changed "submit_extent_page()" to "submit_extent_folio()" in
  the comment, but it doesn't make any difference since the function name
  is wrong from day 1.

  Finally commit 5e121ae687b8 ("btrfs: use buffer xarray for extent
  buffer writeback operations") completely reworked how metadata
  writeback works, and removed submit_eb_page(), leaving only the wrong
  function name in the comment.

  Furthermore the function submit_extent_folio() still exists in the
  latest code base, but is never utilized for metadata writeback, causing
  more confusion.

Just remove the lengthy comment, and replace the "if (ret > 0)" check
with an ASSERT(), since only btrfs_check_meta_write_pointer() can modify
@ret and it returns 0 or <0 for errors.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
Changelog:
v2:
- Fix grammar errors
- Add a more comprehensive history for the bad "submit_extent_folio()"
  mention
  It's incorrect from day 1.
---
 fs/btrfs/extent_io.c | 34 ++++------------------------------
 1 file changed, 4 insertions(+), 30 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 3df399dc8856..9999c3f4afa4 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -2386,38 +2386,12 @@ int btree_writepages(struct address_space *mapping, struct writeback_control *wb
 		index = 0;
 		goto retry;
 	}
+
 	/*
-	 * If something went wrong, don't allow any metadata write bio to be
-	 * submitted.
-	 *
-	 * This would prevent use-after-free if we had dirty pages not
-	 * cleaned up, which can still happen by fuzzed images.
-	 *
-	 * - Bad extent tree
-	 *   Allowing existing tree block to be allocated for other trees.
-	 *
-	 * - Log tree operations
-	 *   Exiting tree blocks get allocated to log tree, bumps its
-	 *   generation, then get cleaned in tree re-balance.
-	 *   Such tree block will not be written back, since it's clean,
-	 *   thus no WRITTEN flag set.
-	 *   And after log writes back, this tree block is not traced by
-	 *   any dirty extent_io_tree.
-	 *
-	 * - Offending tree block gets re-dirtied from its original owner
-	 *   Since it has bumped generation, no WRITTEN flag, it can be
-	 *   reused without COWing. This tree block will not be traced
-	 *   by btrfs_transaction::dirty_pages.
-	 *
-	 *   Now such dirty tree block will not be cleaned by any dirty
-	 *   extent io tree. Thus we don't want to submit such wild eb
-	 *   if the fs already has error.
-	 *
-	 * We can get ret > 0 from submit_extent_folio() indicating how many ebs
-	 * were submitted. Reset it to 0 to avoid false alerts for the caller.
+	 * Only btrfs_check_meta_write_pointer() can update @ret,
+	 * and it only returns 0 or errors.
 	 */
-	if (ret > 0)
-		ret = 0;
+	ASSERT(ret <= 0);
 	if (!ret && BTRFS_FS_ERROR(fs_info))
 		ret = -EROFS;
 
-- 
2.52.0

