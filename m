Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D659329B77C
	for <linux-btrfs@vger.kernel.org>; Thu, 29 Jan 2026 14:25:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769696725; cv=none; b=r8uG9fv2+srABMtJFepsxD3/S8/MIQVV1wJ3i+C2BQQ4idSOqQVGlA+O5UcAx6s3QgVjXDS1FvdJ7wUxIg1h0Ed5A2yaGsyu0QT1dO00g9Jyj416YircUQizmkadvFn86uowiII1LGUyulvKbAJRNSlhxkWQqkCc1kTv5aZJvLs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769696725; c=relaxed/simple;
	bh=iQDdQIFGAnPrcNVUWGB/cjWNsKPHwmABCKqKezCZ9xo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=KzxxJjOGKjsXl7Jh9jvPTY61r9CqETlZk450evc5wWESCK8ydJuKORTvzwjns5MfOrQ6ON5+DJEPcloOkcvx7quPKdMZOJnJGCd6BZxoGKsHY8FS3Th/OT3gDPs8acC/sBK4YogKIeZnHGTl+LqlCE+5Vdq1RY8mBqov8b3jQ2Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=n67O2w15; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=n67O2w15; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="n67O2w15";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="n67O2w15"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 345F134147;
	Thu, 29 Jan 2026 14:25:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1769696721; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=2dHA4HGa5g0ZJ00nFuexWfaXQLbD38v3RmJkw8tEPm8=;
	b=n67O2w15/H3pSq2tHXOtCNwJOnd2Wrt4eyReIChHn+k6XXcByw2nxnWlJZjgBfla8TGo3u
	Oz8KuM4hsf1qoeZr9dYRTf6+PWD/tF3pLE9WGt/0bfQ/Uv0zmcQfxilrtBHI/rttZgrtxs
	9u2nF03KhzFdu7KQycgwf998hoGQceM=
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1769696721; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=2dHA4HGa5g0ZJ00nFuexWfaXQLbD38v3RmJkw8tEPm8=;
	b=n67O2w15/H3pSq2tHXOtCNwJOnd2Wrt4eyReIChHn+k6XXcByw2nxnWlJZjgBfla8TGo3u
	Oz8KuM4hsf1qoeZr9dYRTf6+PWD/tF3pLE9WGt/0bfQ/Uv0zmcQfxilrtBHI/rttZgrtxs
	9u2nF03KhzFdu7KQycgwf998hoGQceM=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 233EE3EA61;
	Thu, 29 Jan 2026 14:25:21 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id pTuSCNFte2lkZAAAD6G6ig
	(envelope-from <dsterba@suse.com>); Thu, 29 Jan 2026 14:25:21 +0000
From: David Sterba <dsterba@suse.com>
To: torvalds@linux-foundation.org
Cc: David Sterba <dsterba@suse.com>,
	linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [GIT PULL] Btrfs fixes fro 6.19-rc8
Date: Thu, 29 Jan 2026 15:25:19 +0100
Message-ID: <cover.1769696202.git.dsterba@suse.com>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Score: -2.80
X-Spamd-Result: default: False [-2.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FROM_HAS_DN(0.00)[];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.com:mid];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	RCPT_COUNT_THREE(0.00)[4];
	RCVD_TLS_ALL(0.00)[]
X-Spam-Level: 
X-Spam-Flag: NO

Hi,

please pull two fixes for bugs with serious consequences. Thanks.

- fix leaked folio refcount on s390x when using hw zlib compression
  acceleration

- remove own threshold from ->writepages() which could collide with
  cgroup limits and lead to a deadlock when metadadata are not written
  because the amount is under the internal limit

----------------------------------------------------------------
The following changes since commit 34308187395ff01f2d54007eb8b222f843bdf445:

  btrfs: add extra device item checks at mount (2026-01-20 17:18:48 +0100)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git tags/for-6.19-rc7-tag

for you to fetch changes up to 0d0f1314e8f86f5205f71f9e31e272a1d008e40b:

  btrfs: zlib: fix the folio leak on S390 hardware acceleration (2026-01-21 19:35:41 +0100)

----------------------------------------------------------------
Qu Wenruo (2):
      btrfs: do not strictly require dirty metadata threshold for metadata writepages
      btrfs: zlib: fix the folio leak on S390 hardware acceleration

 fs/btrfs/disk-io.c   | 22 ----------------------
 fs/btrfs/extent_io.c |  3 +--
 fs/btrfs/extent_io.h |  3 +--
 fs/btrfs/zlib.c      |  1 +
 4 files changed, 3 insertions(+), 26 deletions(-)
