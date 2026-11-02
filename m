Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.130
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793611744;
	b=AiGaRftkc6N8Qzs7a7TS01+9IwPRnY+cQ0lQ0tYsNQOpnVPcoWwWCBCylBMgC2g51hhq
	 oSpNERev+Y7wmAR7XQ2hwIb/PbxLx1M6ZIHx2+XbYLi0WVqztiHhAu7B8TaEYpVpQlN8Z
	 fs/1lXyi3rwQsQWdMzIEOkHzVvjxq9uge82xZI6oRj3rYaeawbs9IpGGg7IwahPj0SF4r
	 OE4L3tPf0olUVl42L3wr9Vt7a3bP7abuw1yl9JwyCjCQ1oJ0ZQuwnYDcEeEh3CC8YmHFH
	 ptbDqbCF3FAdJPkX0n32oQs2JMshdByVT1iI2X4f77fSsO2bmy7tgaKyxALT0Rb3BEA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793611744;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:Received:
	 Received:From:To:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding:X-Spam-Flag:X-Spam-Level:X-Spamd-Result:
	 X-Spam-Score;
	bh=vjkk6WroC0wqbbb/JdURns56Iw+JTq/mFGbrkyraMDU=;
	b=LZL55ygaKU/xWSgQX+yZMsMwy4BZXpVC60hsAB6iIHvkkzFqOUFnLjc9a+vYnKzBaOUK
	 CkykUAXoFyMKqLd07OdU0tuysIMuQf7alKRWL6wiQ1tGjifMXZeWEaDAed+EEHaQxAlBZ
	 +JUZOEzK9L2853hq/BV70Up1RvDnVU90M42bEWGSC3kbiQJcg8q260yEVVjr8nHJgT9Jg
	 LQ4404Y3vdxRgzwQeAfVNiV3iV1HXX/mBXwwdatr3RdkD5yomNja6wi+d+u4FvJ2sU6+o
	 FvImGg3dB8Hjgm6XSoOzmkZ9wBvrho++wbGxCmYUviK0ybImXMO21uDlb4Xebw6XyTQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=XYnuC25G;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=XYnuC25G;
	arc=none smtp.remote-ip=195.135.223.130
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C29BA606A326
	for <linux-btrfs@vger.kernel.org>; Mon,  2 Nov 2026 09:29:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C29BA606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=XYnuC25G;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=XYnuC25G
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 1260C22074
	for <linux-btrfs@vger.kernel.org>; Mon,  2 Nov 2026 09:29:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1793611742; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=vjkk6WroC0wqbbb/JdURns56Iw+JTq/mFGbrkyraMDU=;
	b=XYnuC25Gi/yxgfQ8/vsgzzaCxyfma9i7aVard0L0o27pAZrl3Z9e0GaUjqZANrDhHMp0om
	k34v3ihc2ch+hSPBs+RDmN73iwasRcStgHAqM34FQQ2GoLPAxGW4r+vrR0ZUwiyqMCpGG4
	QQesFWr7BZQS4Lslu1H/+erKp5vGSMk=
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1793611742; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=vjkk6WroC0wqbbb/JdURns56Iw+JTq/mFGbrkyraMDU=;
	b=XYnuC25Gi/yxgfQ8/vsgzzaCxyfma9i7aVard0L0o27pAZrl3Z9e0GaUjqZANrDhHMp0om
	k34v3ihc2ch+hSPBs+RDmN73iwasRcStgHAqM34FQQ2GoLPAxGW4r+vrR0ZUwiyqMCpGG4
	QQesFWr7BZQS4Lslu1H/+erKp5vGSMk=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id E58CE134B3
	for <linux-btrfs@vger.kernel.org>; Mon,  2 Nov 2026 09:29:00 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id R7qPENxX6GprcgAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Mon, 02 Nov 2026 09:29:00 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 0/2] btrfs: hardening against radix tree conflicts on 32bit systems
Date: Mon,  2 Nov 2026 19:58:36 +1030
Message-ID: <cover.1793611601.git.wqu@suse.com>
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
X-Spam-Flag: NO
X-Spam-Level: 
X-Spamd-Result: default: False [-11.80 / 50.00];
	SUSE_INTERNAL_BYPASS(-9.00)[];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-0.998];
	MIME_GOOD(-0.10)[text/plain];
	RCPT_COUNT_ONE(0.00)[1];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	RCVD_TLS_ALL(0.00)[]
X-Spam-Score: -11.80

Inspired by a recent patch touching btrfs_ioctl_subvol_sync() function,
it turns out that we have a very rare (I'd even call it unpractical) but
still real (one can even craft one image) problem, that on 32-bit
systems, we always truncate the subvolid down to 32bit unsigned long.

This means the following two valid subvolume trees will get the same
index:

  Subvolume 257 (0x101) and subvolume 4294967553 (0x100000101)

It should really be very rare, as we have other limits like anon_dev,
which should hit way before subvolumeid limits.
But one can craft an image with only above two subvolumes, and on 32bit
systems only one subvolume can be reached.

Address the situation by:

- Do not insert data reloc tree into fs_roots_radix
  As we will reject subvolume ids > ULONG_MAX on 32 bit systems, we
  don't want to insert data reloc tree into that radix tree in the first
  place.

- Reject subvolume ids > ULONG_MAX
  For 64 bits this will become an no-op.

  For 32 bits, most subvolumes should still have their ids <= ULONG_MAX.

  For crafted images, subvolumes ids larger than ULONG_MAX will be
  rejected with a rate-limited error message every time such subvolume
  is going to be inserted.

  This can lead to some transaction abort, e.g. createing a snapshot
  whose id is too large.

  But I don't have better solution than rejecting them.


Qu Wenruo (2):
  btrfs: do not insert the data reloc tree into fs_roots_radix
  btrfs: reject subvolume ids that do not fit into unsigned long

 fs/btrfs/disk-io.c | 64 +++++++++++++++++++++++++++++++++++++++-------
 fs/btrfs/disk-io.h | 19 ++++++++++++++
 fs/btrfs/ioctl.c   |  2 +-
 3 files changed, 75 insertions(+), 10 deletions(-)

-- 
2.56.0

