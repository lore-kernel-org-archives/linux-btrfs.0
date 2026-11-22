Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=109.224.244.106
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795319324;
	b=2BchUzTO3AI6OB7vhQ3HTTT46vJDEFHGuu0olEX9P1u6IkkujMJakpM8awP84j/J2f8o
	 TCcr8/tsnFKFtMiQlL7RZh74hOXiKLmdMw7xDZQ8lC8Rs2Juw846A4N0bSBvHOU68Qdsb
	 651h30YVS+JjVM94vchu5kkMAr4pUNwrpPD5rhw1UJ+ALOsptgjlz7CoedDRuoKFHukqE
	 zHoBQ00dCrMd8sw6q27yvIBxpsmik8/TOetI4cqWBeahN8PKuTtliVlSboR4v4IAADEk8
	 JTW4Y2eWa+u2vnb9wea2s+PgeW57pxBiHLgeCSLkdBLN7GgoCdtr/8eHmR9OBXZ3ggg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795319324;
	h=DMARC-Filter:DKIM-Signature:X-Pm-Submission-Id:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=RyU7YdsCSE9NZ/HZtKI1qnE8BlGhZjWmP1tf2jCOzm0=;
	b=DjMwegTTfcTioUZoXqXQwrbm9xIPIpNI8k/5Tx5gy5kKi4Fhk8qFaC8tTuqo80c9vnGQ
	 kERxS082P3vV/i0/yvfaobIUAXUhirLMLblCr6lfQBCPbh7/a83Ms/4q9Ec/HmFT26nSQ
	 7U+c4XkBak9ifcLSaW/HFR7NugIlxc2/dYxZ1uGPy14NQk9Jyz3U/4hnjkLoX1NyWEwzO
	 QUalqbXoQPT+Zw7zLXBfU7PFhRk1TcrTNC7lJWV+8N7SzTNEVlBZGklEz1SO+ugf6Z3uB
	 ov3XMQshxtg7oz7o28gLSX77da2ffWQHZc48xxv5GXKLclX+5BW0JCZqXwqt1e1or7g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=raidlab.org;
	spf=pass smtp.mailfrom=raidlab.org;
	dkim=pass header.d=raidlab.org header.i=@raidlab.org header.a=rsa-sha256 header.s=protonmail header.b=xffsamjJ;
	arc=none smtp.remote-ip=109.224.244.106
Received: from mail-244106.protonmail.ch (mail-244106.protonmail.ch [109.224.244.106])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4450606A320
	for <linux-btrfs@vger.kernel.org>; Sun, 22 Nov 2026 03:48:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B4450606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=raidlab.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=raidlab.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=raidlab.org header.i=@raidlab.org header.a=rsa-sha256 header.s=protonmail header.b=xffsamjJ
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=raidlab.org;
	s=protonmail; t=1795319320; x=1795578520;
	bh=RyU7YdsCSE9NZ/HZtKI1qnE8BlGhZjWmP1tf2jCOzm0=;
	h=From:To:Cc:Subject:Date:Message-ID:From:To:Cc:Date:Subject:
	 Reply-To:Feedback-ID:Message-ID:BIMI-Selector;
	b=xffsamjJDirpVZQaYeCvxA8AS6XZuTsYU8qNRIT3ruZ9/Ljis2buJZ2gHspmiFbtz
	 yW4999/B5OOaOLxTtGqyVP5zS91uxcJnCHVs1M9l1/U0K9fLPrXh0D6KuK7tXUbOgj
	 leur70IiGcUTQYPhyB4B5pGJMVe1mOxiCqcktWQAa/m9eTQa6ZSYTmxN7aL8sjBJgV
	 /nVCywBztkJly1EAR1XFtDMzLxMGPZoWviZ0GHwXDZ05hGwBLG+flfF5Ge6TVnb8uq
	 grI3FsSd4/YHP2e56PVA6hQmEwYighz7tXgOdxHUQ5kmDdH0p1/roBm2u5mpvFdygH
	 qP7yM+ZZzf0AQ==
X-Pm-Submission-Id: 4jXFRW13wNz1DDqy
From: Miroslav Cimerman <mc@raidlab.org>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>,
	Chris Mason <mason@kernel.org>,
	Naohiro Aota <naohiro.aota@wdc.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Qu Wenruo <wqu@suse.com>,
	linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] btrfs: zoned: unwritten copies of mirrored data writes
Date: Sun, 22 Nov 2026 03:48:23 +0000
Message-ID: <20261122034826.2333981-1-mc@raidlab.org>
X-Mailer: git-send-email 2.53.0
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

On a zoned filesystem, a mirrored data write can lose a copy, or fail,
without any problem on the devices. Two bugs cause it. Both need writes
to one zone to arrive in a different order than they were allocated,
which parallel writers do.

1/2: since 7.0, every copy but the last is a regular write. A regular
write that arrives before an earlier one fails.

2/2: since 6.7, with the raid stripe tree, the zones of a block group
are finished when the extent at its end completes. Zone append writes of
other extents that are still queued then fail.

Tested in QEMU with KASAN on for-next 184fa2c40f5c, with two zoned
null_blk devices (1 GiB, 16 MiB zones, 8 active zones) and RAID1 data
and metadata on the raid stripe tree. 8 direct writers each wrote 4
files of 8 MiB, and 16 buffered writers did the same with fsync. At
least two runs each:

                direct, 8 writers          buffered, 16 writers
  for-next      5 to 8 of 32 writes        writes succeed, but some
                fail with EIO              copies are not written
  with 1/2      writes succeed, but some   no errors
                copies are not written
  with 2/2      writes succeed, but some   writes succeed, but some
                copies are not written     copies are not written
  with both     no errors                  no errors

A copy that is not written shows up as a write error in the device
statistics ("errs: wr").

The series is based on 6b72ea3e75f4, which differs from the tested
commit only in qgroup.c.

On for-next, the next mount failed in 3 of 4 runs with "write pointer
offset mismatch". With both patches, it worked in every run. With the
single data profile, for-next shows no failure in the same tests. A set
of degraded-mount tests and the btrfs self-tests show no new failure
with the patches, also on top of my RAID1 series [1].

Each patch alone leaves the failures of the other, so they are sent
together. They apply to for-next without [1].

Found by an LLM while testing a fix on zoned RAID1. The analysis, the
fixes and the tests were done with the help of an LLM. I reviewed
everything.

FuzzyRAID, a fault-injection tester for RAID that is not public at the
moment, reproduced both bugs on its own and found no error with the
patches. With 1/2 missing, a scrub found the copy on one device corrupt
after the writes had succeeded.

[1] https://lore.kernel.org/linux-btrfs/20261121134550.216217-1-mc@raidlab.org/

Miroslav Cimerman (2):
  btrfs: zoned: use zone append for every copy of a mirrored write
  btrfs: zoned: finish raid stripe tree zones once all data is written

 fs/btrfs/bio.c         |  1 +
 fs/btrfs/block-group.h |  6 ++++++
 fs/btrfs/zoned.c       | 33 +++++++++++++++++++++++++++++----
 3 files changed, 36 insertions(+), 4 deletions(-)


base-commit: 6b72ea3e75f4d20a0ad1e9c95d7f9f1b8f192b92
-- 
2.53.0

