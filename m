Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2383438DC7C
	for <linux-btrfs@vger.kernel.org>; Sat, 10 Oct 2026 06:30:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791613818; cv=none; b=EDkmuvYSOQGK3LYhwIkfTj5JryjOqEi2NBAr9yLDSYvVbWlVm8tY8q9dVbaF/9qjH9+0btKNA1CGNtgjlYemaXDbs4/cOS1O/ZfWrXcSlU494twKYq2Ygwj9FYo9QbT82kINBna+1/HU4xAd2W74Ca2YCW85VMxI/9tI4r5dSbU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791613818; c=relaxed/simple;
	bh=21nOG/wZr9CElTzbpIGFITRWm1m+lQP062Na1IYsAOA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=sVPlDOd/8Ta+DvASS0d8cPwGtVXh+FQf6cqjcVmHUaZp55dGqXWSLmqmgjklXceWKdHDbO27MWsRnynk/ciC3IIO6vd4R3Fq3TGLrHALujymOFV3+AqnydA4JL7VPiDWjzwY3/sf90DGd4ARiRDw3oGlly63dTtnBrKoZfODDto=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=WOd5RRmb; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=WOd5RRmb; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="WOd5RRmb";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="WOd5RRmb"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 214D51F445;
	Sat, 10 Oct 2026 06:30:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1791613814; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=6ADNXKs73PpQhC2qH4cka73viEjzOkr9L6iB5WNU13U=;
	b=WOd5RRmbuAOHkfzEsi7aBu36M+kPhDcRw0Kk17MSiqeD/U1EoMPdCGmsxYH/UMN5zK49pq
	XKvk5QV01VTUL7jHJnXDROQ4Lx1J2Q2qqhVgZvtTae3bm9Sku8KpmbdOH+Br/5dZTlEoTq
	qD2z9gZOl401+0+faOFscVumNCLXxfE=
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=WOd5RRmb
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1791613814; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=6ADNXKs73PpQhC2qH4cka73viEjzOkr9L6iB5WNU13U=;
	b=WOd5RRmbuAOHkfzEsi7aBu36M+kPhDcRw0Kk17MSiqeD/U1EoMPdCGmsxYH/UMN5zK49pq
	XKvk5QV01VTUL7jHJnXDROQ4Lx1J2Q2qqhVgZvtTae3bm9Sku8KpmbdOH+Br/5dZTlEoTq
	qD2z9gZOl401+0+faOFscVumNCLXxfE=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 96F7B133F6;
	Sat, 10 Oct 2026 06:30:12 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 8ylDN3PbyWrHcQAAD6G6ig
	(envelope-from <wqu@suse.com>); Sat, 10 Oct 2026 06:30:12 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: =?UTF-8?q?Roger=20Alas=C3=A0?= <vonbloom@gmail.com>
Subject: [PATCH v2] btrfs: fix the fsverity callback where unexpected range is verified
Date: Sat, 10 Oct 2026 16:59:49 +1030
Message-ID: <15f4ef9f50e1f4af375e45cf976717041f1a96d4.1791613764.git.wqu@suse.com>
X-Mailer: git-send-email 2.56.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Action: no action
X-Spam-Score: -3.51
X-Spam-Flag: NO
X-Spamd-Result: default: False [-3.51 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	RCPT_COUNT_TWO(0.00)[2];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[gmail.com];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,suse.com:dkim];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.com:+]
X-Spam-Level: 
X-Rspamd-Queue-Id: 214D51F445
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org

[BUG]
There is a bug report that on v7.2 kernel, compressed extents with
fsverity enabled can lead to warnings like the following:

 fs-verity (dm-3, inode 257): FILE CORRUPTED! pos=7471104, level=-1, want_hash=sha256:bedf0e7bc93b48694db719001a8d3e79229cc58ee638b41d4149193505090774, real_hash=sha256:ad7facb2586fc6e966c004d7d1d16b024f5805ff7cb47c7a85dabd8b48892ca7

The read itself eventually succeeds, and no read error is returned to
user space.

[CAUSE]
Since v7.2 btrfs has enabled large data folio support, now a folio can
contain multiple blocks even if the page size matches the fs block size.
And even before that, btrfs already has block size < page size support,
thus all involved code should assume a folio can contain multiple
blocks.

However the function btrfs_verify_folio() calls fsverity_verify_folio(),
which verifies the whole folio, even if the read range only covers part
of the folio.

This forces fsverity to verify garbage data that is not yet read from
disk, and causes verification failure.

This is a long-standing bug, but previously it only affected bs < ps
cases which is not that common.
Now with the large folio support, it's much easier to trigger with bs ==
ps cases.

[FIX]
Instead of calling fsverity_verify_folio(), call
fsverity_verify_blocks() to verify only the read range.

Reported-by: Roger Alasà <vonbloom@gmail.com>
Link: https://lore.kernel.org/linux-btrfs/CAELqY9==Ter2XQPRp=gjW5T75T+7kcZCXpn5roF2L6tY6mQNxw@mail.gmail.com/
Fixes: 146054090b08 ("btrfs: initial fsverity support")
Tested-by: Roger Alasà <vonbloom@gmail.com>
Signed-off-by: Qu Wenruo <wqu@suse.com>
---
Changelog
v2:
- Refresh the [BUG] section to show the symptom better
---
 fs/btrfs/extent_io.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 55e9144d4759..5ff630630490 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -504,7 +504,7 @@ static bool btrfs_verify_folio(struct fsverity_info *vi, struct folio *folio,
 
 	if (!vi || btrfs_folio_test_uptodate(fs_info, folio, start, len))
 		return true;
-	return fsverity_verify_folio(vi, folio);
+	return fsverity_verify_blocks(vi, folio, len, offset_in_folio(folio, start));
 }
 
 static void end_folio_read(struct fsverity_info *vi, struct folio *folio,
-- 
2.56.0

