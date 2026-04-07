Received: from fhigh-a3-smtp.messagingengine.com (fhigh-a3-smtp.messagingengine.com [103.168.172.154])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BC2132D0D8
	for <linux-btrfs@vger.kernel.org>; Tue,  7 Apr 2026 19:30:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.154
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775590226; cv=none; b=PB0OxspzVqrpes/b0AlXClffiCXAoEJCFknGhYC0boRWc4K+XGhwejwfuitgpWgjFLxxCR8xSXutWUq41v0Lz0DpIaH6G4XSsXflWiZyT2vS5OD1Yr8hrRQ0R965IKzcp+p8eAfVOwdjL9W5GcLQD5uJVvOxGZBbiJlBRCOa86o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775590226; c=relaxed/simple;
	bh=Hj57VSEJmWegHfbVlKz1LUMnfZZ3sh5HS9E6BGqtHFI=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=p24aRMoEeXFXPa1CbGtvpkzGkxz15PzR1a/FZn5+3AzB1mgMY7CdlQ2NYFRvzjiMoxPqjFHEoS4qpReLoylHcEc9Vfr2D2U4NxwGne3HUhBUbFzKz3DXvfFfAGgsRAKhxg6ki4ns02sYyvepEZ5l0z/EqHMVwzuEJWPmqBil5/Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io; spf=pass smtp.mailfrom=bur.io; dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b=n+1+sLKC; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=X2aH4/ok; arc=none smtp.client-ip=103.168.172.154
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bur.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b="n+1+sLKC";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="X2aH4/ok"
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailfhigh.phl.internal (Postfix) with ESMTP id 7ACA9140011C;
	Tue,  7 Apr 2026 15:30:24 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-06.internal (MEProxy); Tue, 07 Apr 2026 15:30:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc
	:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:message-id:mime-version:reply-to:subject:subject:to
	:to; s=fm3; t=1775590224; x=1775676624; bh=o1yySHK+Vkxi8gZ2xIMqv
	fjoAQE5sohXmiMUAiAzxUQ=; b=n+1+sLKCDs8Eq3Po4bTn3G+PxI7gkCRvHpAi7
	qPx8fRxviQRC56ICg1TDX2+VnTDrrk07BQ5F0vG4jJYNE6wElDlnqI98QxRrz5Qz
	B3//qOv6WZFLT5inAJc1NCly2d/n+hOK++D3gwQrUztCpfcN+3kcYOb4LcO8MzMU
	mgk5UOPK1BSE24j03E5FjuqNzwquq3er+6IhEf0NBVnITsmtB5wloyN6zwnVLJ9X
	II/HSqR1BAxN0csrOq4V8KC/f2NEXVPhsNtN8iWbh5hw2OANCIDBY2g/Ev86L9hk
	iFuSCe/PdhR/C6yvICswurMWVr3dJUUog3r8G/pcW229N2YWQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:content-transfer-encoding:content-type
	:date:date:feedback-id:feedback-id:from:from:in-reply-to
	:message-id:mime-version:reply-to:subject:subject:to:to
	:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=
	1775590224; x=1775676624; bh=o1yySHK+Vkxi8gZ2xIMqvfjoAQE5sohXmiM
	UAiAzxUQ=; b=X2aH4/okZf+t37V5yTGQSqxm2Qywr83eIEIGM2tSX9/iJBKhC6C
	bsJB60rZ6awkrTFLNytT9I/ItjkCvZ6bqUzN+sRoC3MNjmyepJJfUFUAnBmjWUgO
	2AnrHLcmIWBlbDkTlb8W9cP7c6XyFvjWYjhoIzMcKhnZPWMJ5qlZJlw+P0dLFc+K
	Xn5E0L96X8rakuV7HbAgWrCmQ2OAg1mp3HZJbR5OyD8Z3ejogxvz1bX5lUByYAhX
	7G6irM5Nb0LM52hMMSHZrbpMGp05ZdV1DYeuXWJoJfVyeurE60iP+JVGB+xBHoXZ
	lvNxmNLhyzg4iQDn0wTHr0UKxJsdQagRkKw==
X-ME-Sender: <xms:UFvVaZ3VglTr6VnLSKnrkA36uRm8zYjvu7bWn_gKcO0Ct8k09Y_hlw>
    <xme:UFvVaWGh73K2Oug1jFsl9Ja1KarwXLkxCGRsvJB5EHGUTW9Hr_-eNMgmWh8SY2Bld
    5CuEsBAShI4LH-95ck7SCPl8wJDUMSWAp1hzp-3JZoTE7nYhXMlPkkH>
X-ME-Received: <xmr:UFvVaXjSuVIwesCFMCNnZ1iAJjlhaBmtin7Qdq2z2CDxQhrecfajS05GnrYALSCdDRGhuJr_-5Oy0ErW4HOxGCoEd6Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefhedrtddtgddvudehtdcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecunecujfgurhephffvufffkffoggfgsedtkeertdertddtne
    cuhfhrohhmpeeuohhrihhsuceuuhhrkhhovhcuoegsohhrihhssegsuhhrrdhioheqnecu
    ggftrfgrthhtvghrnhepudeitdelueeijeefleffveelieefgfejjeeigeekudduteefke
    fffeethfdvjeevnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhf
    rhhomhepsghorhhishessghurhdrihhopdhnsggprhgtphhtthhopedvpdhmohguvgepsh
    hmthhpohhuthdprhgtphhtthhopehlihhnuhigqdgsthhrfhhssehvghgvrhdrkhgvrhhn
    vghlrdhorhhgpdhrtghpthhtohepkhgvrhhnvghlqdhtvggrmhesfhgsrdgtohhm
X-ME-Proxy: <xmx:UFvVaR-2sGpT-ZrmOlKe8ABxoGsj9Q22lTKCZkcMKtvHmYuJHJIVyw>
    <xmx:UFvVaeriN-GhbK0g7fWEpyn5Dmx1gA6QBMLzZKolvuoweSJM9Rh6PA>
    <xmx:UFvVaQ_F-dMKzGW3e-lvqjIDEOeQHW2V9lulnxDe0SKxV4KQdsuuNg>
    <xmx:UFvVaSUUzS_opHAdivNA0mYpgLG30vkufQK8h7-WcQoC7N5zlWkvDg>
    <xmx:UFvVaRdeM5Ncki7KSyW7QJY434ZiUd_4HNjKQVmMkxIb0_lJg64oeRKD>
Feedback-ID: i083147f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 7 Apr 2026 15:30:23 -0400 (EDT)
From: Boris Burkov <boris@bur.io>
To: linux-btrfs@vger.kernel.org,
	kernel-team@fb.com
Subject: [PATCH v3 0/4] btrfs: improve stalls under sudden writeback
Date: Tue,  7 Apr 2026 12:30:10 -0700
Message-ID: <cover.1775589916.git.boris@bur.io>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

If you have a system with very large memory (TiBs) and a normal
percentage based dirty_ratio/dirty_background_ratio like the defaults of
20%/10%, then we can theoretically rack up 100s of GiB of dirty pages
before doing any writeback. This is further exacerbated if we also see a
sudden drop in the free memory due to a large allocation. If we
(relatively likely for a large ram system) also have a large disk, we are
unlikely to do trigger much preemptive metadata reclaim either.

Once we do start doing writeback with such a large supply, the results
are somewhat ugly. The delalloc work generates a huge amount of delayed
refs without proper reservations which sends the metadata space system
into a tailspin trying to run yet more delalloc to free space.
Ultimately, the system stalls waiting for huge amounts of ordered
extents and delayed refs blocking all users in start_transaction() on
tickets in reserve_space().

This patch series aims to address these issues in a relatively targeted
way by improving our reservations for delalloc delayed refs and by doing
some very basic smoothing of the work in flush_space(). Further work
could be done to improve flush_space() heuristics and latency but this
is already a big help on my observed workloads.

I was able to reproduce stalls on a more "modest" system with 264GiB of
ram by using a somewhat silly 80% dirty_ratio.

I was unfortunately unable to reproduce any stalls on a yet smaller
system with only 32GiB of ram.

The first 2 patches do the delayed_ref rsv accounting on btrfs_inode,
mirroring inode->block_rsv.
The 3th patch is a cleanup to the types counting max extents
The 4th patch reduces the size of the unit of work in shrink_delalloc()
to further reduce stalls.
---
Changelog:
v3:
- Merge csum reservation patch (2) into main delalloc delrefs rsv patch (1)
- Add delayed refs reservations for RST and subvol tree metadata cow to
  patch 1.
- Do the migration in the nocow/prealloc finish_one_ordered() cases as
  there are still metadata delayed refs generated.
- Double delref rsv for cows (add+drop). This seems really conservative
  to me, but I think it is correct. If we like it, it needs to happen
  more places too...
- Upgrade ASSERTs in patch 3 (old patch 4) to log unexpected values.
- Remove unused return value in migrate function.
- Various stylistic issues in several patches.
v2:
- patch 1 no longer embeds a new block_rsv on btrfs_inode for the
  delayed reservation. Instead it does the reservation on
  inode->block_rsv and migrates it to trans->delayed_rsv at the moment
  of truth.

Boris Burkov (4):
  btrfs: reserve space for delayed_refs in delalloc
  btrfs: account for compression in delalloc extent reservation
  btrfs: make inode->outstanding_extents a u64
  btrfs: cap shrink_delalloc iterations to 128M

 fs/btrfs/btrfs_inode.h       | 20 ++++++--
 fs/btrfs/delalloc-space.c    | 84 +++++++++++++++++++++++++++------
 fs/btrfs/delalloc-space.h    |  3 ++
 fs/btrfs/fs.h                | 13 ------
 fs/btrfs/inode.c             | 90 ++++++++++++++++++++++++++++--------
 fs/btrfs/ordered-data.c      |  4 +-
 fs/btrfs/space-info.c        | 31 ++++++++-----
 fs/btrfs/tests/inode-tests.c | 18 ++++----
 fs/btrfs/transaction.c       | 36 ++++++---------
 include/trace/events/btrfs.h |  8 ++--
 10 files changed, 210 insertions(+), 97 deletions(-)

-- 
2.53.0

