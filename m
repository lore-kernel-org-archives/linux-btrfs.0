Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0594371877;
	Thu,  6 Aug 2026 19:13:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786043628; cv=none; b=bd8XFfacw+gIx8qmAPnKyo9gTYjVZI1ReQ7Q4mthNuQWelhm8v0huYqOP4vZ+OezDa9e+Q3FeH+CuZqZKNFgZchbzzhfIIxewSioKk1xw09U/wAgHYuLv6SDQAm8T76I//xaPfMTuZHXjwjqzy25jehUPPAbOXOvSZlgXdULmE4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786043628; c=relaxed/simple;
	bh=KwGu+fIcP/jZOwzyKXwIWlOiDA6aAgtWimu9WuqpFoE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=YJcEAaggAyZlVwBp0BlZUYLYwSEQuFTVPLmr9bAloRRJAtXpShEpmX6HaVQVsdG2G2jg6r6LN7+JfLBJ9zwC/EJrP//dZhb5soqgeZLZ0e+jZ6LjHm/XcyTTphY6ccj+mU+aLeCOphsb0tqgRG55uQ3xVQXpBjMRkJOkWec1Q7M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=lcwpxmD2; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=pQv1SQQa; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="lcwpxmD2";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="pQv1SQQa"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id D7A3E801C5;
	Thu,  6 Aug 2026 19:13:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1786043621; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=PeJCrYNuE4XqOPhY9I84I0MqunmX5R9RkUm8vct8Qlg=;
	b=lcwpxmD2i12jlPb3YAB0rdhtPfqCT6QN62MAQhQbwQOmZwk93pQeKP7bEHSoJZIXeE6YB2
	GNiR06VgPQHXiPqhjRjGid/d0xLxnpVtJXKr8Q4hln6epEhfdJsZRLlsi2nI2eeMQm4sp0
	h/UT7A/nKQPdwWlYvJfqLrsp50n6lD0=
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=pQv1SQQa
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1786043616; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=PeJCrYNuE4XqOPhY9I84I0MqunmX5R9RkUm8vct8Qlg=;
	b=pQv1SQQaYEGXLFy7zhDkNPVOdW9PeVi2Z7K3Iz1enm2d2UXUxvn63Y//axJCmTkjL4uzBe
	G994Frm9dlTzCVZd95Ey9Cz+kOTqvOhPjm1/9j/EHEPqdYyMrdCsYIQ9YujMUBIRjuUZvc
	Wc0utJM5ManADZuMbyMSPicg1OaIOMs=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id D1B5B779B6;
	Thu,  6 Aug 2026 19:13:36 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id RvMtM+DcdGr3ZQAAD6G6ig
	(envelope-from <dsterba@suse.com>); Thu, 06 Aug 2026 19:13:36 +0000
From: David Sterba <dsterba@suse.com>
To: torvalds@linux-foundation.org
Cc: David Sterba <dsterba@suse.com>,
	linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [GIT PULL] Btrfs fixes for 7.2-rc7, part 1
Date: Thu,  6 Aug 2026 21:13:29 +0200
Message-ID: <cover.1786042395.git.dsterba@suse.com>
X-Mailer: git-send-email 2.55.0
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
	NEURAL_HAM_SHORT(-0.20)[-0.999];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_SOME(0.00)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	DKIM_TRACE(0.00)[suse.com:+];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	DWL_DNSWL_BLOCKED(0.00)[suse.com:dkim];
	RCPT_COUNT_THREE(0.00)[4];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.com:mid,suse.com:dkim]
X-Spam-Flag: NO
X-Spam-Score: -3.01
X-Spam-Level: 
X-Rspamd-Queue-Id: D7A3E801C5
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Action: no action

Hi,

the following branch contains a few short fixes. This is separate from
the 'fixup worker' pull request, just in case.

Please pull, thanks.

- fix leak in encoded ioctl write

- disable large folios on systems with highmem

- disable block size > page size when there's no transparent hugepage
  support (under experimental config)

- reject compressed inline extents without valid LZO headers

- properly initialize cached inode mapping (if block size > page size)

----------------------------------------------------------------
The following changes since commit c4c0673e4cb15b0c127e6d00732a2427bdd12c11:

  btrfs: raid56: fix scrub read assembly submitting no reads (2026-07-21 06:44:08 +0200)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git tags/for-7.2-rc6-tag

for you to fetch changes up to 0ef349734a93227b45f65fc50a3311d1cc5f03e9:

  btrfs: initialize inode mapping flags for cached inodes (2026-07-31 16:56:05 +0200)

----------------------------------------------------------------
David Lee (1):
      btrfs: lzo: reject inline extents without valid headers

Dmitry Antipov (1):
      btrfs: fix memory leak in btrfs_do_encoded_write()

Qu Wenruo (3):
      btrfs: disable large folios for systems with highmem
      btrfs: disable bs > ps support if no transparent hugepage support
      btrfs: initialize inode mapping flags for cached inodes

 fs/btrfs/Kconfig   |  3 ++-
 fs/btrfs/disk-io.c | 10 +++++++++-
 fs/btrfs/fs.c      | 12 ++++++++++--
 fs/btrfs/inode.c   |  4 +++-
 fs/btrfs/lzo.c     |  5 +++--
 5 files changed, 27 insertions(+), 7 deletions(-)
