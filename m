Received: from fout-a4-smtp.messagingengine.com (fout-a4-smtp.messagingengine.com [103.168.172.147])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A1C41F4634
	for <linux-btrfs@vger.kernel.org>; Wed, 25 Mar 2026 00:42:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.147
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774399335; cv=none; b=UzPQIQ6UPGfae5Othfuaq3sPRjJvJll14JsH4UVhCdFFdQGqTCYURmBoh9Mez5p32A3Ye+OraOmJqIpncYAt6OuzVA1UEf1LWRZrMzEMclyFn/aXDKTZZSwTEamgzYfBh1vH40CiTt0wuwRY566O1XtXFshbgJcl+ZVJ/gGiIyI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774399335; c=relaxed/simple;
	bh=iYsEw34kmY6RXGhBzPeDH9S4N2QSo8XN2R52P/wUAc4=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=MYoxju2GjSGl8o2LwvKvPyb2UH8epI1WyGmOc43g1BGvAJnZgGZEa9nbI9pLkMTLPsoVXMXFAZ/dLD+3mVDgrAfIaTYgtXaOrUwVr2s/XvYNS4q7k0G9rcXmiBYRQFOzncB9YTR/CkvlpwsQQJJPSDofA4qXG734g2R4YBBaLk4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io; spf=pass smtp.mailfrom=bur.io; dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b=TmXAuJtR; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=lCbkcjQv; arc=none smtp.client-ip=103.168.172.147
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bur.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b="TmXAuJtR";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="lCbkcjQv"
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfout.phl.internal (Postfix) with ESMTP id 0B37BEC00AC;
	Tue, 24 Mar 2026 20:42:13 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-01.internal (MEProxy); Tue, 24 Mar 2026 20:42:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc
	:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:message-id:mime-version:reply-to:subject:subject:to
	:to; s=fm2; t=1774399333; x=1774485733; bh=St5To7HrsAs3+/8+JEw17
	Jm2KeSZVSSxsV8WEiaXBys=; b=TmXAuJtRxwqn74V9sLS0XSWpdaNBzyqyIh2Ow
	1uN0nMRSnXA+iwxz6uR57HTfG2JJwwOzdiAEZe3EfYI8KLpU+l71YndoS0VbxbUv
	ScEV3hg1X9n41l9f/Ry2I97Xgql2cvXup0G0/WoA2WpIY8lnbm9hQNm9YfVf6/k0
	Q+RSuVuno8ZQoeAx6kPEwdAM0zWfOCoFjcnJsyLHVKe8gMtRLtSzDUekTrnz3vCZ
	MfqSQ0D5uFp1FzrWnE4bxX0bT3JyLP9001CKBVMOhXVP9yhHYqJCWLXAzm0N74ho
	elEA6a/K1rVIFECmuDWYCQRYAaR7Df+gKJ8jr3RnOoRoZBXIg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:content-transfer-encoding:content-type
	:date:date:feedback-id:feedback-id:from:from:in-reply-to
	:message-id:mime-version:reply-to:subject:subject:to:to
	:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=
	1774399333; x=1774485733; bh=St5To7HrsAs3+/8+JEw17Jm2KeSZVSSxsV8
	WEiaXBys=; b=lCbkcjQvx2gn56sKphg1z1hBckQA0cLnCR6Jz0eG39XJyB28JXO
	wo+lMY+5zWclLuWKcSWLT1oemaPmICB6dUU2S7oVIW/Xp1dp8WJEVxMPk06cLijt
	xymnsmCWgm2JctPyM1zW/q0ayN1LUu5ut4dnilIEVB7tbSOUs//f50STnf7lAH9a
	hztzaEDau9iUxu174CdGcFStHFbY1K+W6LBdzmygV9AbxqekMwYCsNvzHP6M4uJS
	VtxliHT43Gsz+7pTK2XTSSeZP1ZniWI0Ex7usvv3cqM/8NLrB3rHhBnJHq6ZDGua
	Opx2CJzT2P7I7KsuL/xzWhXR83T7EYi3oiA==
X-ME-Sender: <xms:ZC_DafCUPpe69LS4HEiidpwEckof0ZDTxK-bQUpGbIinOv0XmKrTGw>
    <xme:ZC_DabipSOVBOFtEdDH9nDhFiYyVraF1I0yGs72lfqPmp4KvXVDVRiudaiUwXE4Mv
    UwDybZRnsToNjPZrtZDd368fMWCKn8cjKBAfbpu6wEeArLb1VbWuyI>
X-ME-Received: <xmr:ZC_DaYOJVCIneTYlQAX85pPPjp9wnUZ-NideNkdGIkoYKClbourhZQBukJSTb5-Ib23tvU47yM4bajxUjEVzfq5nrZ4>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgdefvdeftdehucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgggfestdekredtredttd
    enucfhrhhomhepuehorhhishcuuehurhhkohhvuceosghorhhishessghurhdrihhoqeen
    ucggtffrrghtthgvrhhnpeduiedtleeuieejfeelffevleeifefgjeejieegkeduudetfe
    ekffeftefhvdejveenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhl
    fhhrohhmpegsohhrihhssegsuhhrrdhiohdpnhgspghrtghpthhtohepvddpmhhouggvpe
    hsmhhtphhouhhtpdhrtghpthhtoheplhhinhhugidqsghtrhhfshesvhhgvghrrdhkvghr
    nhgvlhdrohhrghdprhgtphhtthhopehkvghrnhgvlhdqthgvrghmsehfsgdrtghomh
X-ME-Proxy: <xmx:ZC_Dac6HKBinrNjwrurszXu1WeWySio4yhwtx2RBlpEXh62MELnBvQ>
    <xmx:ZC_DaW1k83LVev76mL6ccyEp7FHquUw7LdW1nzasYRz4PlgMlAX91Q>
    <xmx:ZC_Dadab71WKNk_FtlYkdE45lmq9fP8rYls_V5vafWI5VV8MvoYWyQ>
    <xmx:ZC_DaeBQ5PVEdmQiG3O9-iWGj2bO9_ch5_dqdZrawLB9gmDzLR4bOg>
    <xmx:ZS_DaTlnfQyPe1vugYW8Nl8JFcx5cbDlWrBDzTaza2JVXAKsfFNKT9Jo>
Feedback-ID: i083147f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 24 Mar 2026 20:42:12 -0400 (EDT)
From: Boris Burkov <boris@bur.io>
To: linux-btrfs@vger.kernel.org,
	kernel-team@fb.com
Subject: [PATCH 0/5] btrfs: improve stalls under sudden writeback
Date: Tue, 24 Mar 2026 17:41:48 -0700
Message-ID: <cover.1774398665.git.boris@bur.io>
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

The first 3 patches do the delayed_ref rsv accounting on btrfs_inode,
mirroring inode->block_rsv.
The 4th patch is a cleanup to the types counting max extents
The 5th patch reduces the size of the unit of work in shrink_delalloc()
to further reduce stalls.

Boris Burkov (5):
  btrfs: reserve space for delayed_refs in delalloc
  btrfs: account for csum delayed_refs in delalloc
  btrfs: account for compression in delalloc extent reservation
  btrfs: make inode->outstanding_extents a u64
  btrfs: cap shrink_delalloc iterations to 128M

 fs/btrfs/btrfs_inode.h       | 20 ++++++--
 fs/btrfs/delalloc-space.c    | 75 +++++++++++++++++++++-------
 fs/btrfs/delayed-ref.c       |  2 +-
 fs/btrfs/fs.h                | 13 -----
 fs/btrfs/inode.c             | 97 ++++++++++++++++++++++++++++--------
 fs/btrfs/ordered-data.c      |  4 +-
 fs/btrfs/space-info.c        | 31 ++++++++----
 fs/btrfs/tests/inode-tests.c | 18 +++----
 fs/btrfs/transaction.c       |  7 +--
 fs/btrfs/transaction.h       |  3 +-
 include/trace/events/btrfs.h |  8 +--
 11 files changed, 193 insertions(+), 85 deletions(-)

-- 
2.53.0

