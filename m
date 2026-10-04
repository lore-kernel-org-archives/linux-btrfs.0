Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A19A2868B4
	for <linux-btrfs@vger.kernel.org>; Sun,  4 Oct 2026 22:50:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791154228; cv=none; b=iNJmNRNM7RWDhgq5NJtUW0Jg11V7fbz6+bCY8wHFKz17RyN97O3ThCmg4miuNWbs9hgu6BQtPaaC7Hxlez+55Hx8RVrCxKBOIi49yfyPXMk5e4JWFh6rFjqA5c3r3B+HDKwjaVSnuGDzAogG5UWUPsvogOS/Q36A/D+OhWDA2rE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791154228; c=relaxed/simple;
	bh=ZtXMLX6oC2qBVMUi7qESIjSBK2wUM5OtqwfdNVG0h1g=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=EGUZ3PInDkyubzWGFDREO29SEL+pb9+rMblsqAGwkAGI+OsDdR7M+jnCVVYHBiL5qI9JslDp7bTpgywSZT/Uj3nN3cjDqepIKTV6knyLaDyj3iubkdC+TGk6uJ9XU7jIzq9MuAORSAzQb+JogDDCLr+4BlE14iuIKso5QCKeZPg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=nvPtSEXk; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=l+ML+qnY; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="nvPtSEXk";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="l+ML+qnY"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 29D1421D37
	for <linux-btrfs@vger.kernel.org>; Sun,  4 Oct 2026 22:50:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1791154220; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=gDduDwB0/MQ3IeKRl6o61lWTtzwzWLH0n0S0jLTggVc=;
	b=nvPtSEXkP815/r3HdxW5ucCoH0rPNB+Gkq3A5GY9BB/+WdnqkeZW+eMnIJpn9b/9I7ewrT
	bBZkgBV0Q65g1XZ6e2ujUQMQNps7P77ssfBfyxcFyChY8Kd98YBtvXuIsPI26uSQr3BYye
	Hib5Fo+CdMpjZSUYUX5ErWe2n+1oC3U=
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=l+ML+qnY
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1791154216; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=gDduDwB0/MQ3IeKRl6o61lWTtzwzWLH0n0S0jLTggVc=;
	b=l+ML+qnY8LkCdSm7Yhck8FTVuzYpdcKO31shqX4oaxJHUk4U04tJgLx+kxZPkxV4p636An
	4Pslv0wJyQtsMusjpGopfNWdWWhSVSnVc1YcLdS2IMPb8Y2aINpIjW4l5l1aLiHJ11HpxG
	MSSSNyBhhgKQrFYWhxcgusca33tvwLo=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id CCF78133CF
	for <linux-btrfs@vger.kernel.org>; Sun,  4 Oct 2026 22:50:14 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id CriGCibYwmqLWgAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Sun, 04 Oct 2026 22:50:14 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v3 0/2] btrfs: go extent-by-extent submission for buffered reads and writes
Date: Mon,  5 Oct 2026 09:19:39 +1030
Message-ID: <cover.1791154046.git.wqu@suse.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Queue-Id: 29D1421D37
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-3.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
	NEURAL_HAM_SHORT(-0.20)[-0.999];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	ARC_NA(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_ONE(0.00)[1];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	TO_DN_NONE(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:mid,suse.com:dkim];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[suse.com:+]
X-Spam-Flag: NO
X-Spam-Score: -3.01
X-Spam-Level: 

[CHANGELOG]
v3:
- Enhance the writeback_bio_size limit check
  Now we limit the writeback size early.

  This will follow the writeback_bio_size better.

- Do a better microbenchmark for the writeback patch
  It turns out that writeback throttle is making submit_bio() sleep,
  masking the improvement in extent_writepage_io().

  With wbt_late_nsec set to 0, now the improvement is way more obvious.
  Now it's over 90% reduce in average runtime, other than no improvement
  in the average runtime.

v2:
- Fix the length of advancement when no OE is found
  We should still retry the next block, as there may be only a block of
  gap.

  Exposed by Sashiko on the 2nd patch.

  Although it also exposed a false alert on the
  truncate_ordered_extents_beyond_eof().
  Where all the blocks in the range should have an OE, or we're having
  a bigger problem.

Although we have large data folio support for a while, the buffered
reads and writes are still iterating a large folio block-by-block.

For a large buffered IO, the large folio has a very high chance to
contain only one single extent.

In that case, although doing block-by-block checks is good for
readability, it's not really performant.

The series changes the behavior to do extent-by-extent iteration
instead, this can bring a very slight performance improve.

For best case scenario, the runtime to submit a folio read can be
reduced from 32us to 2.5us, and a much better distribution.
The runtime to submit a folio write can be reduced from 177us to 9us.

Qu Wenruo (2):
  btrfs: read a folio extent-by-extent instead of block-by-block
  btrfs: write back a folio extent-by-extent instead of block-by-block

 fs/btrfs/extent_io.c | 321 ++++++++++++++++++++++++++-----------------
 fs/btrfs/subpage.c   |  49 +++++++
 fs/btrfs/subpage.h   |   4 +
 3 files changed, 245 insertions(+), 129 deletions(-)

-- 
2.55.0

