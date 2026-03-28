Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 129AE24B28
	for <linux-btrfs@vger.kernel.org>; Sat, 28 Mar 2026 21:20:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774732829; cv=none; b=s4/Mi0hViEZ+/SAvA9HqTFEQ54ZAmtcUnt4UlfmYUcST74uII1ydLspYYOogTD8mBcF8qjR/r48gEXqUG7lcXxmuDiBhA+Hs0pYAHSqvsCG3hOqxLsCf6i2qVx97VjftMHx+Zv9RZvryJPdoK3JpNmTgAIqMxAxDj96ALmn9wAc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774732829; c=relaxed/simple;
	bh=kFHIb0/roPqDA9fjpM8BEwcGe6XjtqzXUdQPPOqr/dA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=jiyF9maXHzGAydfmqon3Q0Ym/QoMsWUZRMzSkqAJ6pA6izD7kWHdjxfPVkhH4uCp460cmt+ihLstIb6M+5PVg+N1P2g0Iii0VJN61Ve/afdsjr9i+Z1NSERIMTU+BltLCArmjgFPtopieLxKJNuHEj76wBaBAkrjTGdqcmNLmXg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=P2XO4vSX; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=P2XO4vSX; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="P2XO4vSX";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="P2XO4vSX"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 52F745BE53;
	Sat, 28 Mar 2026 21:20:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1774732826; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=GYObJGwX4VU9wc3UBqOQbAR1ut+7yprgz/Ct0kOv41o=;
	b=P2XO4vSXszk0Zsq5CYPpnJcqqNTiUHjMDYz/pB+Ly5i6SmtSUR2zgR6W29+Z3D+usnDQGc
	P0VqkaMgiLOkcgRrHuRwjhtG/SXbMxUmvTf2gu1hPQCzGtfMsLN/w1WgQFsGJ32hmqB2iR
	ktbayfw0fAt0w3hISlavLMMNLhCcuiU=
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1774732826; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=GYObJGwX4VU9wc3UBqOQbAR1ut+7yprgz/Ct0kOv41o=;
	b=P2XO4vSXszk0Zsq5CYPpnJcqqNTiUHjMDYz/pB+Ly5i6SmtSUR2zgR6W29+Z3D+usnDQGc
	P0VqkaMgiLOkcgRrHuRwjhtG/SXbMxUmvTf2gu1hPQCzGtfMsLN/w1WgQFsGJ32hmqB2iR
	ktbayfw0fAt0w3hISlavLMMNLhCcuiU=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 4728D4A0A3;
	Sat, 28 Mar 2026 21:20:26 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id aiHrEBpGyGkpXwAAD6G6ig
	(envelope-from <dsterba@suse.com>); Sat, 28 Mar 2026 21:20:26 +0000
From: David Sterba <dsterba@suse.com>
To: torvalds@linux-foundation.org
Cc: David Sterba <dsterba@suse.com>,
	linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [GIT PULL] Btrfs fixes for 7.0-rc6
Date: Sat, 28 Mar 2026 22:18:56 +0100
Message-ID: <cover.1774730316.git.dsterba@suse.com>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-2.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-0.999];
	MIME_GOOD(-0.10)[text/plain];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FROM_HAS_DN(0.00)[];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	RCPT_COUNT_THREE(0.00)[4];
	RCVD_TLS_ALL(0.00)[]
X-Spam-Flag: NO
X-Spam-Score: -2.80
X-Spam-Level: 

Hi,

please pull a few more fixes. There's one that stands out in size as it
fixes an edge case in fsync. Thanks.

- fix issue on fsync where file with zero size appears as a non-zero
  after log replay

- in zlib compression, handle a crash when data alignment causes folio
  reference issues

- fix possible crash with enabled tracepoints on a overlayfs mount

- handle device stats update error

- on zoned filesystems, fix kobject leak on sub-block groups

- fix super block offset in an error message in validation

----------------------------------------------------------------
The following changes since commit b17b79ff896305fd74980a5f72afec370ee88ca4:

  btrfs: reject root items with drop_progress and zero drop_level (2026-03-17 11:43:08 +0100)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git tags/for-7.0-rc5-tag

for you to fetch changes up to 1c37d896b12dfd0d4c96e310b0033c6676933917:

  btrfs: fix lost error when running device stats on multiple devices fs (2026-03-23 20:12:12 +0100)

----------------------------------------------------------------
Filipe Manana (2):
      btrfs: fix zero size inode with non-zero size after log replay
      btrfs: fix lost error when running device stats on multiple devices fs

Goldwyn Rodrigues (1):
      btrfs: tracepoints: get correct superblock from dentry in event btrfs_sync_file()

Mark Harmstone (1):
      btrfs: fix super block offset in error message in btrfs_validate_super()

Qu Wenruo (1):
      btrfs: zlib: handle page aligned compressed size correctly

Shin'ichiro Kawasaki (1):
      btrfs: fix leak of kobject name for sub-group space_info

 fs/btrfs/block-group.c       |  2 +-
 fs/btrfs/disk-io.c           |  4 +-
 fs/btrfs/tree-log.c          | 98 +++++++++++++++++++++++++++++---------------
 fs/btrfs/volumes.c           |  5 ++-
 fs/btrfs/zlib.c              |  4 +-
 include/trace/events/btrfs.h | 11 +++--
 6 files changed, 81 insertions(+), 43 deletions(-)
