Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C206D3EFD06
	for <linux-btrfs@vger.kernel.org>; Mon,  4 May 2026 23:49:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777938588; cv=none; b=fk6XsK69q/aYzK5s3ADOXo/CdaQieBlu87elqBLPo8LokQ5qbcvEX8+wff2Dso9UE2B3m+VtH0Sk50taGFqa0PvI70Nv2DKJ9qhSOsmB4G1cjsDkIRji2qCFF9GBIGAb5JVo3sgZ2+qH15czPe8WIWqCA6SNsfFkSvYeLgHxabg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777938588; c=relaxed/simple;
	bh=T0qIKQt79k+zE5uJpDp8vrkl8vLQp4P61NZrom8KkAY=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OOTezOjGkalt/Jub/bCqi2c0UqSaf1/64COlE1fUpqbE7Sy3tqOrqN36fHD8HieA+IFBgkscZqq6+JOZtRLPRedpRiEVK5KaYsJwg3oNxL3x8NT8H2tHvfOtpL1XidVox8hhFSN5pym0QSmABqNUyQ5WSNJ9N0m837JjrCpakqU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=hg1RErns; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=hg1RErns; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="hg1RErns";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="hg1RErns"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 0FDAE5CA96
	for <linux-btrfs@vger.kernel.org>; Mon,  4 May 2026 23:49:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1777938585; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=N2MsDMAGj5hR3LoBD8hE/lETlyUauOfU6egjYijem10=;
	b=hg1RErnsrn6cRrSaa9lrvUoZHDbSy9maiKSR9lFzO71dSVl/WZbsCpSWcnYIq1erWKXt4f
	mNzUI94s947lhv2dLvjtHGiJohuRPWTcNHQqjSrlYqwyG5yUJd3qCD0W4sFDBQV0HCblrW
	vsUyX8kTi0NbTiNUka/kbZ9DJiivgW0=
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=hg1RErns
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1777938585; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=N2MsDMAGj5hR3LoBD8hE/lETlyUauOfU6egjYijem10=;
	b=hg1RErnsrn6cRrSaa9lrvUoZHDbSy9maiKSR9lFzO71dSVl/WZbsCpSWcnYIq1erWKXt4f
	mNzUI94s947lhv2dLvjtHGiJohuRPWTcNHQqjSrlYqwyG5yUJd3qCD0W4sFDBQV0HCblrW
	vsUyX8kTi0NbTiNUka/kbZ9DJiivgW0=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 4F53C593A3
	for <linux-btrfs@vger.kernel.org>; Mon,  4 May 2026 23:49:44 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id IDmnBJgw+WmKAgAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Mon, 04 May 2026 23:49:44 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH RFC 2/4] btrfs: use dirty flag to check if an ordered extent needs to be truncated
Date: Tue,  5 May 2026 09:19:22 +0930
Message-ID: <84e31203446611cf3b1675d47bd882f9af2aca8f.1777937175.git.wqu@suse.com>
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
X-Rspamd-Queue-Id: 0FDAE5CA96
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

