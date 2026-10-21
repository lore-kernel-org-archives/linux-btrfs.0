Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792554011;
	b=fafL2R3MRQTGOI7bNJKCd10P71koN8DWXifEOYoIiZmGDOjlgbkggqUeEVm8odjx4Sqz
	 +ZB3ukn9ZAl6Tzj8sw8PVLZIf4Ks1OK9nAIeLN5UD12oMlGgBO9GDiMVrAfP32vvVhgRm
	 j8fX348+DK3t/N8HwHnjmLOhtWk8R9bWzp0CU4SdmVZTyGjOH+50yU0hXtaUsMhiaBdvk
	 YtsFvHS/kLQTrh6qUmAacbmGvdb5EIuzTkWsRZ/jGd8tHzzezco71G97d/M5c+LelYrQ8
	 GvV5OJ/TZeIZ1nr0d5a7iGQS+vq8CQDktj9wjMn5+0RuNEufB0XgbsC/9kY33Vj53Tg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792554011;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:Received:
	 Received:From:To:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding:X-Rspamd-Action:X-Spam-Score:X-Spam-Flag:
	 X-Spamd-Result:X-Spam-Level:X-Rspamd-Queue-Id:X-Rspamd-Server;
	bh=RHqpHAatB7tJ38MH49KZKCqcI7wRl6NRFRCcGdT2vV0=;
	b=EoFZhftG2JN5xSaVWDt8vVGFjkvThiRGFFRBPGZJKb7sFpCEzDm9y45XCrMsw6DCSbc4
	 bBaLiPKfpCSORMn1cgVi/Sqd+YIQa8KSorJt3HpnxhnmzvDKnYcL3tjby7ZHRCxxQWvVX
	 Hajwach/Ry5FMQNuj3EKBuVgotBg7QJMu7oZeYPgl5pyreQx7GOV6oDf59GiBQcwiGDWZ
	 c+PB9yf/dm1oDsCm7byR6zye1DvzfeKhW2jbPamYURWLR3bv82JmQE9i2qYCzzSNPTdH4
	 gV5I49PkoLFdh0H1ycq7r9HeEJm/iBoCIKkxL7UiX2vxkV4ImJuKPx5ZMfUGjAWFlog==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=hKDMoPTq;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=hKDMoPTq;
	arc=none smtp.remote-ip=195.135.223.131
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F7A8606A319
	for <linux-btrfs@vger.kernel.org>; Wed, 21 Oct 2026 03:40:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9F7A8606A319
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=hKDMoPTq;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=hKDMoPTq
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 80FDF1F7E9
	for <linux-btrfs@vger.kernel.org>; Wed, 21 Oct 2026 03:40:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1792554007; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=RHqpHAatB7tJ38MH49KZKCqcI7wRl6NRFRCcGdT2vV0=;
	b=hKDMoPTqg+fc8KXaDlhbGFTIX+7QatwaDUTkd2Z6l37/1gHA+1I5Fj8f2JgOljc8n4VBJB
	DM5oQdtGkc32WNt5Hv1QaNpDWpoXBk3Wi2wj8XZt2CYYAS/MWgDd/ob3gRkVgKgKu3OYRZ
	IPDwpJqOH0AiSlX3IJiVSiUdV6idddU=
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=hKDMoPTq
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1792554007; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=RHqpHAatB7tJ38MH49KZKCqcI7wRl6NRFRCcGdT2vV0=;
	b=hKDMoPTqg+fc8KXaDlhbGFTIX+7QatwaDUTkd2Z6l37/1gHA+1I5Fj8f2JgOljc8n4VBJB
	DM5oQdtGkc32WNt5Hv1QaNpDWpoXBk3Wi2wj8XZt2CYYAS/MWgDd/ob3gRkVgKgKu3OYRZ
	IPDwpJqOH0AiSlX3IJiVSiUdV6idddU=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 454C8134A5
	for <linux-btrfs@vger.kernel.org>; Wed, 21 Oct 2026 03:40:05 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 4EIhJRU02GpeeQAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Wed, 21 Oct 2026 03:40:05 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2 0/9] btrfs: prepare for variable stripe_len
Date: Wed, 21 Oct 2026 14:09:34 +1030
Message-ID: <cover.1792553748.git.wqu@suse.com>
X-Mailer: git-send-email 2.56.0
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Action: no action
X-Spam-Score: -3.01
X-Spam-Flag: NO
X-Spamd-Result: default: False [-3.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	URIBL_BLOCKED(0.00)[suse.com:dkim,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCPT_COUNT_ONE(0.00)[1];
	ARC_NA(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	DKIM_TRACE(0.00)[suse.com:+];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:dkim,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns]
X-Spam-Level: 
X-Rspamd-Queue-Id: 80FDF1F7E9
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org

[CHANGELOG]
v2:
- Use IS_ALINGED() when possible
  Mostly affecting zoned.c

- Refactor is_same_chunk_map()
  Not only reduce the length of the parameter list, but also make it
  easier to expand, with extra unlikely() calls.

- Refactor alloc_scrub_bbio()
  Since the @private is always a scrub_stripe pointer, use scrub_stripe
  as the type instead, so we can grab stripe_len without introducing a
  new parameter.

All are suggested by Johannes.


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
 fs/btrfs/raid56.c       |  57 ++++++++++++------
 fs/btrfs/raid56.h       |   7 +--
 fs/btrfs/scrub.c        | 129 ++++++++++++++++++++++++++--------------
 fs/btrfs/tree-checker.c |  13 +++-
 fs/btrfs/volumes.c      |  95 +++++++++++++++++++----------
 fs/btrfs/volumes.h      |  16 +++--
 fs/btrfs/zoned.c        |  56 +++++++++--------
 8 files changed, 246 insertions(+), 136 deletions(-)

-- 
2.56.0

