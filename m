Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BEBE230BD5
	for <linux-btrfs@vger.kernel.org>; Thu,  7 May 2026 05:29:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778131787; cv=none; b=ChT/gEzSRoCAKCR709WKwFJLDVo3I5MSMbSqIJFAvyUwtYpw+ixDkHm0iqklMAsOQFLpLfjNdecPWS393aV6vQFyrnCsEeg1xGfDkX+fPGqs57WYBaaApXPuAgzGsWXpSFuxmxJQjysi4EjornRsoVtMLCkDsm95silUc76Jszw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778131787; c=relaxed/simple;
	bh=T0qIKQt79k+zE5uJpDp8vrkl8vLQp4P61NZrom8KkAY=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lThJN3yYWRttNvnHqZNVWMEAEJ+VtitBneKcv/H9jiGXkSwmXN+yVF/PEUNyLAfB2Tz11DT/+qilliUG4ccDyUefLRKojTgffd2oIbzr1Xb5f4SkrEsK4P1AUUpMaFoDp6xuYddekidyZz2DtojeU34Pm2AKCkYzEJooJhC0p0Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=Q60F/zOD; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=Q60F/zOD; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="Q60F/zOD";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="Q60F/zOD"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 56B166C067
	for <linux-btrfs@vger.kernel.org>; Thu,  7 May 2026 05:29:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1778131784; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=N2MsDMAGj5hR3LoBD8hE/lETlyUauOfU6egjYijem10=;
	b=Q60F/zODkFYRZ7TmvL6dGu3wmYog3qtF+XX50gOO5AKUVb44tXiwW/8cZ/x2lS2/1kGZaU
	sas1tWuSdxP0y8U/uB5eVQVVQ/p4leG67kMf081uu5I9cjy1tT9wV0kwbbrmw9G7Lmh3NM
	tWcaxLkwM2Pr9rVSXis7tD4ZjXTASFA=
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1778131784; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=N2MsDMAGj5hR3LoBD8hE/lETlyUauOfU6egjYijem10=;
	b=Q60F/zODkFYRZ7TmvL6dGu3wmYog3qtF+XX50gOO5AKUVb44tXiwW/8cZ/x2lS2/1kGZaU
	sas1tWuSdxP0y8U/uB5eVQVVQ/p4leG67kMf081uu5I9cjy1tT9wV0kwbbrmw9G7Lmh3NM
	tWcaxLkwM2Pr9rVSXis7tD4ZjXTASFA=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 8DF1E593A7
	for <linux-btrfs@vger.kernel.org>; Thu,  7 May 2026 05:29:43 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id gDC0E0cj/GmvEgAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Thu, 07 May 2026 05:29:43 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 3/5] btrfs: use dirty flag to check if an ordered extent needs to be truncated
Date: Thu,  7 May 2026 14:59:19 +0930
Message-ID: <295a9c2c5113a53d97451c0f9a47a7f422ead367.1778131118.git.wqu@suse.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <cover.1778131118.git.wqu@suse.com>
References: <cover.1778131118.git.wqu@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Flag: NO
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.com:email,suse.com:mid];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	RCVD_TLS_ALL(0.00)[]
X-Spam-Level: 

Currently there are only two folio ordered flag users:

- extent_writepage_io()
  To ensure the folio range has an ordered extent covering it.
  This is from the legacy COW fixup mechanism, which is already removed
  and only a simple check is left.

- btrfs_invalidate_folio()
  This is to avoid race with end_bbio_data_write(), where
  btrfs_finish_ordered_extent() will be called to handle the OE
  finishing.

But for btrfs_invalidate_folio() we have already waited for the folio
writeback to finish, and locked the folio.
This means we can use the dirty flag to check if a range is already
submitted or not.

If the OE range is not dirty, it means the range has been submitted and
its dirty flag was cleared. And since we have already waited for
writeback, the endio function will handle the OE finishing.
Thus if the range is not dirty, we must skip the range.

If the OE range is dirty, it means we have allocated an ordered extent but
have not yet submitted the range. And that's exactly the case where we need
to truncate the ordered extent.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/inode.c | 21 +++++++++++++--------
 1 file changed, 13 insertions(+), 8 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 4cc4643af7b4..eaae344804f2 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -7593,15 +7593,20 @@ static void btrfs_invalidate_folio(struct folio *folio, size_t offset,
 				page_end);
 		ASSERT(range_end + 1 - cur < U32_MAX);
 		range_len = range_end + 1 - cur;
-		if (!btrfs_folio_test_ordered(fs_info, folio, cur, range_len)) {
-			/*
-			 * If Ordered is cleared, it means endio has
-			 * already been executed for the range.
-			 * We can't delete the extent states as
-			 * btrfs_finish_ordered_io() may still use some of them.
-			 */
+		/*
+		 * If the range is not dirty, the range has been submitted and
+		 * since we have waited for the writeback, endio has been
+		 * executed, thus we must skip the range to avoid double
+		 * accounting for the ordered extent.
+		 */
+		if (!btrfs_folio_test_dirty(fs_info, folio, cur, range_len))
 			goto next;
-		}
+
+		/*
+		 * The range is dirty meaning it has not been submitted.
+		 * Here we need to truncate the OE range as the range will never
+		 * be submitted.
+		 */
 		btrfs_folio_clear_ordered(fs_info, folio, cur, range_len);
 
 		/*
-- 
2.54.0

