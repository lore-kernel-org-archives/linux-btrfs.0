Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF5503D9042;
	Thu,  6 Aug 2026 20:21:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786047664; cv=none; b=e+gkZtvklCEH31Al9VApSrcMWSUH2df57vpUieWI0xtJroKXR6Q5L31R2PRkxirK1Hs9iVMM6p3SUQbMAGnI8UtSog8WI79bYctVi4GA8AmgTNa/w+YoVlu+jT9YE2hTlwgUPZPgQ8upulb+bIF4xzMB9CPmFi9CRbWOGqbsfwA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786047664; c=relaxed/simple;
	bh=L4vEesCfMxKJDEvNe2RxFQNGLCRuKZpgZbRjR7fNG7A=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=jZiTAa7OZg+b+dYKdQqO/VbvvjbTSVrrP5CVQ/DFW7VPIsaneyWvQfu8WS+63jfOWH8ekbViKz+T7uX65PZtmx7BSy82qlfS7g31wOt6XZ4lT5+vlIihiGXxT/9I9MHiUOLleqS2pRIHbjblMuBZSHzOiwoRVXWhXxEQOSKV5UQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=NYUP1Oji; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=FgC/dDQQ; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="NYUP1Oji";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="FgC/dDQQ"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 85301801FA;
	Thu,  6 Aug 2026 20:20:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1786047656; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=BEy6ND5aDEAOh4TNTRPJzCOOqoieTIPp1H0a+9pcyuw=;
	b=NYUP1OjiszXY8PBX/JXnBmEtKHkt3zUFA4qFWqOKE47NpQB/8cV80YfGAJusudjg4SlEA6
	n29vVQPewOzMjERHRm64TIOYNH/rNGGnwYtq2PyKrvW3bw7AQDlP3RS48lpfARapGJbPzv
	IseeTBf/D2JaTPAUYW6c1za92i1uQf0=
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1786047652; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=BEy6ND5aDEAOh4TNTRPJzCOOqoieTIPp1H0a+9pcyuw=;
	b=FgC/dDQQJI6W6nIYj87Nv1BFUJ39thODWBTom8oaroc1b71Z4odeESKIIsdUVfSmb3mM9X
	dRo2+nmB5VmTcyoqj1zoAriioYjNcIU8du0MOnAv5sNhXL2ZxlN7HoxyOGG3Jk7OdOW/vT
	bs/RGAE+ZB8BTPzPZeDWf1nkIPVIRIc=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 7E878779B6;
	Thu,  6 Aug 2026 20:20:52 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id geLfHqTsdGrxJAAAD6G6ig
	(envelope-from <dsterba@suse.com>); Thu, 06 Aug 2026 20:20:52 +0000
From: David Sterba <dsterba@suse.com>
To: torvalds@linux-foundation.org
Cc: David Sterba <dsterba@suse.com>,
	linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [GIT PULL] Btrfs fixes for 7.2-rc7, part 2
Date: Thu,  6 Aug 2026 22:20:45 +0200
Message-ID: <cover.1786044747.git.dsterba@suse.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-2.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-0.993];
	MIME_GOOD(-0.10)[text/plain];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	FROM_EQ_ENVFROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.com:mid];
	RCVD_COUNT_TWO(0.00)[2];
	RCVD_TLS_ALL(0.00)[]
X-Spam-Flag: NO
X-Spam-Score: -2.80
X-Spam-Level: 

Hi,

this pull request brings back the fixup worker infrastructure. It's a
mechanism to detect pages/folios that are marked dirty without filesystem
knowledge and require COW fixup. The consequence of not doing so is
silent data loss.

The first patch covers the scenarios in detail, also reflecting folio
API port and subpage block size support added in recent years. The
original fixup worker was only for pages.

The patch is relatively big, half of the code is debugging and support
code, the rest is the core design around the detection and fix.

The second patch handles an unlikely case when there's work left during
unmount.

Commits with additional or historical info:

- b2a9f217ad3fa8 ("btrfs: remove the COW fixup mechanism")
- 25f3c5021985e8 ("Btrfs: keep pages dirty when using btrfs_writepage_fixup_worker")
- 87826df0ec36fc ("btrfs: delalloc for page dirtied out-of-band in fixup worker")
- 247e743cbe6e65 ("Btrfs: Use async helpers to deal with pages that have been improperly dirtied")

Please pull, thanks.

----------------------------------------------------------------
The following changes since commit c4c0673e4cb15b0c127e6d00732a2427bdd12c11:

  btrfs: raid56: fix scrub read assembly submitting no reads (2026-07-21 06:44:08 +0200)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git tags/for-7.2-rc6-fixup-worker-tag

for you to fetch changes up to ae2567b11c3df43861d05f856bdb3434b3961aa1:

  btrfs: flush the fixup workers during close_ctree (2026-08-04 00:59:16 +0200)

----------------------------------------------------------------
Boris Burkov (2):
      btrfs: trigger cow fixup via dirty_folio()
      btrfs: flush the fixup workers during close_ctree

 fs/btrfs/btrfs_inode.h       |   1 +
 fs/btrfs/disk-io.c           |  28 +++++-
 fs/btrfs/extent_io.c         | 113 ++++++++++++++++++++++
 fs/btrfs/fs.h                |  12 +++
 fs/btrfs/inode.c             | 217 ++++++++++++++++++++++++++++++++++++++++++-
 fs/btrfs/subpage.c           | 216 +++++++++++++++++++++++++++++++++++++++++-
 fs/btrfs/subpage.h           |  41 +++++++-
 include/trace/events/btrfs.h |  35 +++++++
 8 files changed, 651 insertions(+), 12 deletions(-)
