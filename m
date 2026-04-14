Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7AC81922F5
	for <linux-btrfs@vger.kernel.org>; Tue, 14 Apr 2026 01:17:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776129424; cv=none; b=IRxZwqyVrylneoNOifboJQTHJIh8aqYxiYCDp5D4l3eLGGVVtaIn9VR5W8bYREW731OormLmSB8Z+zf64JcpGfOI5Dlo17qgQeJ3+ZhW9py5K6VN6UR+8P8f3eqqE6LIkqRIjr4RoMd4/W0Csmn0Kttqq2BH44ex4JGSxNb8Ziw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776129424; c=relaxed/simple;
	bh=7QN3vIJXhsUetPhd7ZeAHzEw3nR+fCaz9aUMHyVQu3g=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=FpIP9S/3TsPILsAcOX7IRH4enChrvhncPhtI+eZw1twKDxdwjnlmZG4emLRbkgsfwHzlF9L3N/C7Qr1j97XMylBfPJ+rrpJ39EKhZktgy1KER7tXSjVxXEicdOgJU2Dc6Iv5jGcmvPqCuynWuVPdcIBYkKmj27tfkS6ooFAAQPA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=HsohylWm; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=HsohylWm; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="HsohylWm";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="HsohylWm"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 9E6745BDF9
	for <linux-btrfs@vger.kernel.org>; Tue, 14 Apr 2026 01:17:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1776129420; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=Yq78d7ICbpwhQf4AxvFRCeHX8rws/5glIhbeN9b7y+k=;
	b=HsohylWm1ehlT/Qsty7lkb6diJMatf+yJvPEJQVoXUNCJomqCjDoWX6Z/ELsUyUKfYyHua
	+O/99haWpIIgUf9LpO73e28hGILGQCn4g3KNbOsBkdyrgX3wy0Jpvh+8Pj+xS4y+jZ0CzI
	J2N0Xtg7dBybwoL0H5Q1Q9fLdrApVQg=
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=HsohylWm
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1776129420; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=Yq78d7ICbpwhQf4AxvFRCeHX8rws/5glIhbeN9b7y+k=;
	b=HsohylWm1ehlT/Qsty7lkb6diJMatf+yJvPEJQVoXUNCJomqCjDoWX6Z/ELsUyUKfYyHua
	+O/99haWpIIgUf9LpO73e28hGILGQCn4g3KNbOsBkdyrgX3wy0Jpvh+8Pj+xS4y+jZ0CzI
	J2N0Xtg7dBybwoL0H5Q1Q9fLdrApVQg=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id D95874B1A3
	for <linux-btrfs@vger.kernel.org>; Tue, 14 Apr 2026 01:16:59 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id cP0WJouV3WmEbgAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Tue, 14 Apr 2026 01:16:59 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2 0/2] btrfs: remove COW fixup and checked folio flag
Date: Tue, 14 Apr 2026 10:46:40 +0930
Message-ID: <cover.1776129347.git.wqu@suse.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-3.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCPT_COUNT_ONE(0.00)[1];
	ARC_NA(0.00)[];
	TO_DN_NONE(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[suse.com:+];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:dkim,suse.com:mid];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_TLS_ALL(0.00)[]
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spam-Score: -3.01
X-Spam-Level: 
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Queue-Id: 9E6745BDF9

Changelog:
v2:
- Also remove the fixup worker

- Slightly reword the cover letter

- Remove COW fixup related comments

- Update Kconfig to reflect this change.

For experimental builds we're already rejecting dirty folios which
don't have ordered flags since v6.15.

Unfortunately we're not yet removing that COW fixup machanism for
non-experimental builds even at v7.0, as we can still trigger the
warning when we detect dirty folios without ordered extents.

So far all those problems only happen when errors are injected into the
IO path, e.g. generic/475, and I haven't yet seen it triggered without
error handling.

Although I prefer to remove the COW fixup after all error handling
problems are fixed, I run out of ideas how those cases can happen, and
the current handling of treating such cases as write errors is not
going to make things any worse anyway.

Furthermore for the future of huge folios (order 9, 2M page on 4K page
size systems), we can not afford the extra bitmap for a huge folio.
In that case, a huge folio will need 64 bytes per bitmap, which is no
longer a small amount.

I believe it's time to remove the COW fixup mechanism even for
non-experimental builds, along with the checked folio flags.

Qu Wenruo (2):
  btrfs: remove the COW fixup mechanism
  btrfs: remove folio checked subpage bitmap tracking

 fs/btrfs/Kconfig            |   4 -
 fs/btrfs/defrag.c           |   1 -
 fs/btrfs/disk-io.c          |  16 +--
 fs/btrfs/extent_io.c        |  12 +--
 fs/btrfs/file.c             |  12 +--
 fs/btrfs/free-space-cache.c |   4 -
 fs/btrfs/fs.h               |   7 --
 fs/btrfs/inode.c            | 205 +++---------------------------------
 fs/btrfs/reflink.c          |   1 -
 fs/btrfs/subpage.c          |  39 +------
 fs/btrfs/subpage.h          |   5 +-
 11 files changed, 21 insertions(+), 285 deletions(-)

-- 
2.53.0

