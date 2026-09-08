Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32684370ADA
	for <linux-btrfs@vger.kernel.org>; Tue,  8 Sep 2026 07:16:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788851773; cv=none; b=DnceLbBZSpOBVC8mlLVCGFTW9NtwFfDMw2XGgY6rYDNyEcTqAsLyd2ib+rkm7V/bvOwBMuNlstl6CcvGVK0NjT33wJn3uR0iTZH4w5T4gue2yKkgAPvsjJgNE2A1p1i3hIKijFZfZ5WX6D4MsoKQv6lJXvmB1BoZyAi+zbOnIsc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788851773; c=relaxed/simple;
	bh=4Km7FKedOZrqnMj0nouGi9XrjorPPpyBzq14qJKyjBk=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=Y06DQcbJdKBhSiNIW+kPSwEG5XibO0I58xlURsZkLs/ZGerF8xqnBP176pCPOxSYKF2qVbISbK3MXRq8xUzYFMBYJ78bFVEOXvwR+gfS35dH7C4hyED22TiP/mRJ9NotM6VJYF8n8Yjn8Z1k1f+/qCeFfwsdCbDhWaPi5Pr5JJc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=AxfoI+A3; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=f4S7/1LU; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="AxfoI+A3";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="f4S7/1LU"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 1BE1B1F385
	for <linux-btrfs@vger.kernel.org>; Tue,  8 Sep 2026 07:16:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1788851765; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=0/gS0Nw8CW1y2qQHVi83ZW3/BHpmrImrvtB6loRXTN4=;
	b=AxfoI+A3LanhWxV6+imAydsWFlnwTW5Tqs10GVn5lq6NXup4g/kHBfgSKEAP0Jn6B81VSJ
	+NSfIMo7KCLJDAzq9zzvt+JrpF3MFKjSHIPssoC30FokEU2SNeS9tQ3dhEb9U+IhyaUMb/
	XGdM6dKyibZ2H6K8km00kRon6O6TPfw=
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1788851761; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=0/gS0Nw8CW1y2qQHVi83ZW3/BHpmrImrvtB6loRXTN4=;
	b=f4S7/1LUZ4pbMJzqF0Zv73fMv3bQjebKOs7K5jJHtgVzkNfIsh63Tn7qBBkVZQ2ZTiuhBI
	gwaunYQZDmCCXv+WEOGrc/nj7Jf6+Fk1GqVihiRdR2qNBo69CsLMLFTIuVeF/wsNY0LmUe
	bWnc0mwMCOr8RJYQdrwP9WKjYPrEcY4=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 083D81347F
	for <linux-btrfs@vger.kernel.org>; Tue,  8 Sep 2026 07:15:59 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id EzllKi+2n2qWVAAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Tue, 08 Sep 2026 07:15:59 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 0/3] btrfs: use kvmalloc() for allocations that can be larger than page size
Date: Tue,  8 Sep 2026 16:45:38 +0930
Message-ID: <cover.1788851649.git.wqu@suse.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Level: 
X-Spam-Score: -2.80
X-Spam-Flag: NO
X-Spamd-Result: default: False [-2.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-0.993];
	MIME_GOOD(-0.10)[text/plain];
	ARC_NA(0.00)[];
	RCPT_COUNT_ONE(0.00)[1];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:mid];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	RCVD_TLS_ALL(0.00)[]

With the experimental bs > ps support, btrfs can hit several kmalloc()
call sites requesting physically contiguous memory that are larger
than a page, sometimes such allocation can be as large as 64K.

This means those kmalloc() has a much higher chance to fail if the
system's available memory is very fragmented on 4K page sized systems.

And there is already a report that with 64K nodesize, even bs == ps we
can still hit such kmalloc() failure.
(https://lore.kernel.org/linux-btrfs/250decb0-d940-4fe6-9b54-d06e1b293a1b@suse.com/)

But we do not really require any physically contiguous memory for a lot
of kmalloc() call sites, we just want a buffer to save some data
temporarily.

So change those possible larger than page size kmalloc() to kvmalloc()
to reduce the chance of memory allocation failure.

And since kvmalloc() falls back to kmalloc() if the allocation is not
larger than a page, it means for most cases it's still calling
kmalloc(), not affecting the most common cases anyway.

The first patch is a special case that affects the existing bs == ps
cases already.
The second one only affects bs > ps cases.
The third one mostly affects bs > ps cases, but can still improve S390's
hardware accelerated path with 4K page size.

Qu Wenruo (3):
  btrfs: use kvmalloc() for overwrite_item()
  btrfs: use kvmalloc() for uncompress_inline()
  btrfs: use kvmalloc() to allocate compression workspace buffer

 fs/btrfs/inode.c    |  4 ++--
 fs/btrfs/tree-log.c |  4 ++--
 fs/btrfs/zlib.c     | 10 +++++-----
 fs/btrfs/zstd.c     |  4 ++--
 4 files changed, 11 insertions(+), 11 deletions(-)

-- 
2.55.0

