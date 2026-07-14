Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 455E11C84DC
	for <linux-btrfs@vger.kernel.org>; Tue, 14 Jul 2026 05:01:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784005263; cv=none; b=g5QaNykrvaBN0M9n6Boy4jFEiEUozncyOClH/tKflZ3rTPTfvy88wuru3JwBCrSUpKmPitVlKFe9SfbK1/OgIGoTKbIsyugHZ2FkaWHW7oMQBFdSo57tyvYESX3cFD24zUWk1Xuhf3bbZ/rP/LEwsxIdoAE3V0g0a/KCjpUMUSI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784005263; c=relaxed/simple;
	bh=q7go7UaziO9W/+d+jciSEvdotrQiSjPtX/yFROVW2NY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ZhwrWeXXLVyiNBmnxAT7P7rDKRKJ3SHQSsldtijb6PAtf8zH6S/sSI/4ETQIaZ/HwjlqQM/cNsuyD9Z3RZhrIvK2qFkWB/cUW2qGp7933Q2aCQbA5R14lAaHvow3tXWfWmlIBHxhVh8/dWxBcu3h9tAoFc1bsYbz4ryfGZB7pkk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=MPxkjG6J; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=MPxkjG6J; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="MPxkjG6J";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="MPxkjG6J"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 657E177CA0;
	Tue, 14 Jul 2026 05:01:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1784005260; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=3aObJVwYYjlWV6bz7uWOLeKclvVKbSvz1b8aK/Pz9Z4=;
	b=MPxkjG6Jk/dhDWOVzm6p+rKD+/hlo1F0TqzIcplDvA7vp0UscDAhJZFpfCvb7C+RUjkL31
	BknG1UkToVOzbANLoP3zuCcHZSLI/FPRckNJQb/BkfKWnKOtXV2NVmD6SAL1U8/qE58YhV
	s0hY27NNLhmC7OjrXfNtbdZz+tZAwCE=
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1784005260; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=3aObJVwYYjlWV6bz7uWOLeKclvVKbSvz1b8aK/Pz9Z4=;
	b=MPxkjG6Jk/dhDWOVzm6p+rKD+/hlo1F0TqzIcplDvA7vp0UscDAhJZFpfCvb7C+RUjkL31
	BknG1UkToVOzbANLoP3zuCcHZSLI/FPRckNJQb/BkfKWnKOtXV2NVmD6SAL1U8/qE58YhV
	s0hY27NNLhmC7OjrXfNtbdZz+tZAwCE=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 5EDA4779AE;
	Tue, 14 Jul 2026 05:01:00 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id qrgmF4zCVWriYwAAD6G6ig
	(envelope-from <dsterba@suse.com>); Tue, 14 Jul 2026 05:01:00 +0000
From: David Sterba <dsterba@suse.com>
To: torvalds@linux-foundation.org
Cc: David Sterba <dsterba@suse.com>,
	linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [GIT PULL] Btrfs fixes for 7.2-rc4
Date: Tue, 14 Jul 2026 07:00:53 +0200
Message-ID: <cover.1784004728.git.dsterba@suse.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Flag: NO
X-Spam-Score: -2.80
X-Spamd-Result: default: False [-2.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-0.999];
	MIME_GOOD(-0.10)[text/plain];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	MIME_TRACE(0.00)[0:+];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	ARC_NA(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_TLS_ALL(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.com:mid]
X-Spam-Level: 

Hi,

please pull a few fixes. Thanks.

- fix root structure leak after relocation error

- fix optimization when checksums are read from commit root, fall back
  to checksum root during relocation

- in tree-checker, validate length of inode reference in items

- validate properties before setting them

- validate free space cache entries on load

- transaction abort fixes

- fix printing of internal trees as signed numbers

- add error messages after critical lzo compression errors

----------------------------------------------------------------
The following changes since commit ae2eb64bfd9762536f60b690840adcdf622cdcce:

  btrfs: fix use-after-free after relocation failure with concurrent COW (2026-06-09 18:22:47 +0200)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git tags/for-7.2-rc3-tag

for you to fetch changes up to c0041b502e579a5c52e5cae918b90678f03faddd:

  btrfs: print-tree: print header owner as signed (2026-06-30 02:02:03 +0200)

----------------------------------------------------------------
Boris Burkov (1):
      btrfs: fallback to transaction csum tree on a commit root csum miss

Filipe Manana (3):
      btrfs: validate properties before setting them
      btrfs: fix transaction abort logic in btrfs_fileattr_set()
      btrfs: fix root leak if its reloc root is unexpected in merge_reloc_roots()

Johannes Thumshirn (1):
      btrfs: decentralize transaction aborts in create_reloc_root()

Qu Wenruo (2):
      btrfs: lzo: add error message for invalid headers
      btrfs: print-tree: print header owner as signed

Weiming Shi (1):
      btrfs: tree-checker: validate INODE_REF's namelen

Xiang Mei (1):
      btrfs: reject free space cache with more entries than pages

 fs/btrfs/file-item.c        | 26 +++++++++++++++++++++++++-
 fs/btrfs/free-space-cache.c |  3 +++
 fs/btrfs/ioctl.c            | 18 ++++++++++++------
 fs/btrfs/lzo.c              | 15 ++++++++++++---
 fs/btrfs/print-tree.c       |  8 ++++----
 fs/btrfs/props.c            | 16 +++++++++++++---
 fs/btrfs/relocation.c       | 15 +++++++--------
 fs/btrfs/tree-checker.c     |  6 ++++++
 8 files changed, 82 insertions(+), 25 deletions(-)
