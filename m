Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE5C02CCC5
	for <linux-btrfs@vger.kernel.org>; Mon, 19 Oct 2026 06:40:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792392029; cv=none; b=q6fFOm/88kg/DFEyefpArkveILeNvGQILDcfOM40w5HdI4zb0+JPkAWzT4sFodgsGf8HglZwwiukAo2xM4dsaihZJ+wm9V9Cn5g7OJofu7RTrD+NEYoIbQD8HslY5KoyeBj9+O8L5BFDicjYbC0o5Pc7LdZNlpd6yj0YrFXT7vE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792392029; c=relaxed/simple;
	bh=QbiZGdeJaYFhVvTt7wBEDKgYJ+4i3jGUt6JwV855ikM=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=sTOmqrHGMn6TtBf7y1BI/+lKf6HU4tcPP04sT9LExunDSaz05dI1uJKGzNvfwGPJi2p5Hq6uhiz9KfXAPmFuM92BwvORLB3hQzaNDxksxSJIlCRDgvwlkvUARWFU7jp2KBmxD2pz2hcpfzNkdR/esDYwEN3Tko4etQTTdmhD5O0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=CIzULHY9; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=CIzULHY9; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="CIzULHY9";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="CIzULHY9"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 0A9161F821
	for <linux-btrfs@vger.kernel.org>; Mon, 19 Oct 2026 06:40:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1792392026; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=9kGmhUK7k9qiQh4skLHVIIj+Mw2XgS33qys1PWoU9Gc=;
	b=CIzULHY98D6/26YxtOyEPNAvxxpsZY0xT12e7NSw7QooUCWH7vLDQ55rJKUD2RkmD0zgHf
	c8OetHP7qRwenmPMpg72/AyqeM0QOh+oLjL5iOjzKQhuACoznj8Yymt996/od4U+4NL+4X
	V+c2nGmraUmsg8KqGaw9DeZNK945X60=
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1792392026; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=9kGmhUK7k9qiQh4skLHVIIj+Mw2XgS33qys1PWoU9Gc=;
	b=CIzULHY98D6/26YxtOyEPNAvxxpsZY0xT12e7NSw7QooUCWH7vLDQ55rJKUD2RkmD0zgHf
	c8OetHP7qRwenmPMpg72/AyqeM0QOh+oLjL5iOjzKQhuACoznj8Yymt996/od4U+4NL+4X
	V+c2nGmraUmsg8KqGaw9DeZNK945X60=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id C3B551375D
	for <linux-btrfs@vger.kernel.org>; Mon, 19 Oct 2026 06:40:24 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 09jKA1i71WpsbgAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Mon, 19 Oct 2026 06:40:24 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 0/9] btrfs: prepare for variable stripe_len
Date: Mon, 19 Oct 2026 17:09:56 +1030
Message-ID: <cover.1792391732.git.wqu@suse.com>
X-Mailer: git-send-email 2.56.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Flag: NO
X-Spam-Score: -2.80
X-Spam-Level: 
X-Spamd-Result: default: False [-2.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-0.999];
	MIME_GOOD(-0.10)[text/plain];
	ARC_NA(0.00)[];
	RCPT_COUNT_ONE(0.00)[1];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	RCVD_TLS_ALL(0.00)[]

This is a preparation patchset, to support a stripe_len that is not
64KiB.

This is for the future variable stripe length RAID56 feature, where
RAID56_VSL profile is allowed for data chunks, and the stripe_len can be
as small as sectorsize, meanwhile data IO are kept to be aligned to
data_size, which is power of 2, and larger than sector size.

Finally, RAID56_VSL will always have a number of devices that nr_data ==
data_size / sector_size.

So that's why we want a variable stripe_len.

This series does all the preparation, including supporting stripe_len <
PAGE_SIZE.

For now, tree-checker will still reject stripe_len != 64K, but that
limit will be removed when RAID56_VSL feature is introduced and can be
properly tested.

Qu Wenruo (9):
  btrfs: reduce the width of num_stripes and sub_stripes
  btrfs: load the on-disk btrfs_chunk::stripe_len
  btrfs: add btrfs_io_context::stripe_len and load it
  btrfs: change scrub to use stripe_len
  btrfs: add a new 'stripe_len' parameter to btrfs_stripe_nr_to_offset()
  btrfs: convert volumes.c and block-group.c to use map->stripe_len
  btrfs: convert raid56.c to use rbio->bioc->stripe_len
  btrfs: convert zoned.c to use map->stripe_len
  btrfs: introduce extra limits on btrfs_chunk::stripe_len

 fs/btrfs/block-group.c  |   9 +--
 fs/btrfs/raid56.c       |  52 ++++++++++++------
 fs/btrfs/raid56.h       |   7 +--
 fs/btrfs/scrub.c        | 118 ++++++++++++++++++++++++++--------------
 fs/btrfs/tree-checker.c |  13 ++++-
 fs/btrfs/volumes.c      |  84 ++++++++++++++++++----------
 fs/btrfs/volumes.h      |  16 ++++--
 fs/btrfs/zoned.c        |  54 ++++++++++--------
 8 files changed, 226 insertions(+), 127 deletions(-)

-- 
2.56.0

