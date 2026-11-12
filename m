Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.130
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794506942;
	b=ofZ/57aZAPj92RsYifIjIUQ19t58Nwg4UeXhxqHp7qT4yP6SCTmmZ+O5NmjeVlxZL4tt
	 ftDrjlPOEQBe7x9b+DYptddeAXg1vM9viK6g2tkeFYCfecG9ACEy6qPHgZS+tC1fSm42c
	 J7mKv0nnsy+HNuDQuZJdzUsD/RbfKh850LRZdDKJkf0JvHUj8GOLn7mepB+GPY0uVXhX8
	 JpPBTug0yQ8Lbz+3nPRTKEVVEXNzN6tffJBlJr+1xBwAlr83gCqBiecA3OAoV8IJrglcQ
	 0wAC7UbeSDjcdyLihzY5t0GnyED6QvjI2lSeIBWvhdZbzirP5KhhcXhkz7l3hVGgprw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794506942;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:Received:
	 Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding:X-Rspamd-Queue-Id:X-Spam-Level:
	 X-Rspamd-Server:X-Rspamd-Action:X-Spam-Flag:X-Spamd-Result:
	 X-Spam-Score;
	bh=0uqFwBn+9Y/5L04B28BEdx1Vva9wKMxDDuER2cKqQQY=;
	b=ZCuHu4KPCa53eUZW/01xvv0PiO5RcQT6noIwyNacGWQIV4PdinpCO/Ttioo2YN9l4HPm
	 H/8iKzcJuVaAUH05qCJ6e8SWZH+dpaA5oaJH0xelaMiHCKEEgjlCPhzZa1Jbv2c04Utum
	 GMGJ110g376jXVil/f51S2aooJ8n7qOryAVSu/RGijHbrkkFDcE/1yVtVT5xX5MCW7XhT
	 1bbK0D/fvkWh76K8S2yEEelPovmQOfCTepbTrrufub0CSBn9aVFcdX293wTRcalJjzzfk
	 dVr+9kmzOFWUJSTyTDsDNpavNWpOhF+3VMWlFGZN1te0XE9nUlLEX8Wv1Woc3W8wylQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=HZ4Kg0Ko;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b="oQD/PD1H";
	arc=none smtp.remote-ip=195.135.223.130
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4B6B606A31C;
	Thu, 12 Nov 2026 18:09:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D4B6B606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=HZ4Kg0Ko;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=oQD/PD1H
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id C14A221FAF;
	Thu, 12 Nov 2026 18:08:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1794506940; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=0uqFwBn+9Y/5L04B28BEdx1Vva9wKMxDDuER2cKqQQY=;
	b=HZ4Kg0KofldsTFC0g7akEVAbx3P6HdGjEA++iBa32I3qGyYJjJ77Zz+5oeG/kcOmGQRRPE
	G8RnestCrtueRtjgr8gznI5rZL/rYatlsllFYNnUCDeKN9bhSYFwAYuzM/izh7hISkHRBL
	56A1WYWRiGzKjQkTsOR/q8sAyx+Glvk=
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b="oQD/PD1H"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1794506939; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=0uqFwBn+9Y/5L04B28BEdx1Vva9wKMxDDuER2cKqQQY=;
	b=oQD/PD1H/AGoAjfACqF4LZB7KOJodIKVL04hIAxi2ztyKAM2J82caBMCSuYmBmWUDMcOfd
	KoR3GchNKm8Jz8dZ2izisPF83eUDZdx3+vc260mF4EfVZydv5wEEZwHxOkp+5AWIVambBN
	j1Z/BMvi8+5z2WAeXVi7r21VsdoQa+k=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 9A35513432;
	Thu, 12 Nov 2026 18:08:59 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id AU4dHbsA9mqFJwAAD6G6ig
	(envelope-from <dsterba@suse.com>); Thu, 12 Nov 2026 18:08:59 +0000
From: David Sterba <dsterba@suse.com>
To: torvalds@linux-foundation.org
Cc: David Sterba <dsterba@suse.com>,
	linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [GIT PULL] Btrfs fixes for 7.4-rc3
Date: Thu, 12 Nov 2026 19:08:57 +0100
Message-ID: <cover.1794506624.git.dsterba@suse.com>
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
X-Rspamd-Queue-Id: C14A221FAF
X-Spam-Level: 
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spamd-Result: default: False [-12.01 / 50.00];
	SUSE_INTERNAL_BYPASS(-9.00)[];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:dkim,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo];
	FROM_EQ_ENVFROM(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	RCVD_TLS_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DKIM_TRACE(0.00)[suse.com:+]
X-Spam-Score: -12.01

Hi,

please pull a few fixes. Thanks.

- zoned mode fixes
  - fix counting active zones after activation
  - redo zone reset after error
  - update device lock range during mount and zone loading to avoid lockdep
    warnings with device drivers (virtio)
  - space accounting and extent buffer handling fixes

- fix keeping zstd workspace for the last level

- in SUBVOL_SYNC ioctl handle a real case of a subvolume with 0 refs

- properly handle case of zero num_stripes when reading chunk items

- exclude reloc tree from xarray as it's special and it's key does not fit
  unsigned long on 32bit platforms

- in tree-checker, handle extent item tree owner depending on the features
  (enabled in simple quota mode)

- fix bio control structure leak when checksumming fails

----------------------------------------------------------------
The following changes since commit 8c66a6aa59a5df1d672d72b7cd379d897ff73200:

  btrfs: zoned: fix double free of bitmaps on clone failure (2026-10-30 23:17:16 +0100)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git tags/for-7.4-rc2-tag

for you to fetch changes up to d27d0039bc1334be8a72c769e14c0b0c3efc317d:

  btrfs: fix bio counter and bioc leak when async checksumming fails (2026-11-09 18:50:58 +0100)

----------------------------------------------------------------
Cheng Yongkang (2):
      btrfs: reject refs=0 subvolume without DEAD in SUBVOL_SYNC_WAIT
      btrfs: handle zero num_stripes in btrfs_chunk_item_size()

Filipe Manana (1):
      btrfs: zstd: prevent leak of workspace below maximum level

Johannes Thumshirn (6):
      btrfs: zoned: only change active zone counter on successful (de)activation
      btrfs: zoned: fix possible UAF in wait_eb_writebacks()
      btrfs: zoned: requeue block group if zone reset bails out
      btrfs: zoned: avoid underflow of space info bytes_zone_unusable
      btrfs: zoned: don't wait for ordered extents in do_zone_finish()
      btrfs: zoned: fix lockdep splat on mount

Mani Tofigh (1):
      btrfs: fix bio counter and bioc leak when async checksumming fails

Qu Wenruo (1):
      btrfs: do not insert the data reloc tree into fs_roots_radix

Siddharth Mishra (1):
      btrfs: tree-checker: reject extent owner ref without simple quota

 fs/btrfs/bio.c          |  4 +++
 fs/btrfs/block-group.c  |  2 +-
 fs/btrfs/disk-io.c      | 53 +++++++++++++++++++++++++++------
 fs/btrfs/ioctl.c        |  8 +++--
 fs/btrfs/tree-checker.c |  6 +++-
 fs/btrfs/volumes.h      |  5 ++--
 fs/btrfs/zoned.c        | 78 +++++++++++++++++++++++++++++++++++--------------
 fs/btrfs/zstd.c         |  3 +-
 8 files changed, 120 insertions(+), 39 deletions(-)
