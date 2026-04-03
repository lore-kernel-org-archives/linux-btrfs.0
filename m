Received: from fout-a8-smtp.messagingengine.com (fout-a8-smtp.messagingengine.com [103.168.172.151])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47AFA3596E3
	for <linux-btrfs@vger.kernel.org>; Fri,  3 Apr 2026 22:27:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.151
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775255281; cv=none; b=bxYDqPFN214Ps6eiAbFW9k5hHNaN4y0BitGsQwUCBGkrTXmlJh7r35APuEz8HXRVxDNNVcUV95giP/9s6OYZfIz6E153rA9CcFj/qsQSU6BR66HPc8iOlTZO3I9lXq0aWc/x36g/h/PJ2acdFAFb3JUtEs4+QkPSLXWDckFg3KA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775255281; c=relaxed/simple;
	bh=ur8p6FrPJEOsCAptyOB8+CISsT5E4qWHVvx/KG5pwpA=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=Yt4aPILM5qk1C9io3u88+UcJCAJBbSQlqZQ7D8y/59GueaPqzU1kLHa+fFQu28M2AWR7Ci0SXvKVAUwWMRenta7Gc2OFh1gxylHf+kU8Fvp88gKPW53sezp9gEF3QHXzkqlAawvgWjU8FEel1sHtJwzCrI5921hfBS+J1HdWxYk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io; spf=pass smtp.mailfrom=bur.io; dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b=GEtepGVn; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=eejKl2uH; arc=none smtp.client-ip=103.168.172.151
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bur.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b="GEtepGVn";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="eejKl2uH"
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailfout.phl.internal (Postfix) with ESMTP id 595BAEC00B5;
	Fri,  3 Apr 2026 18:27:58 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-05.internal (MEProxy); Fri, 03 Apr 2026 18:27:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc
	:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:message-id:mime-version:reply-to:subject:subject:to
	:to; s=fm3; t=1775255278; x=1775341678; bh=KwKgR4MFlPmcg5BCyZ3tm
	7btdNp94enb6AzOibDRtNw=; b=GEtepGVnfLOmedEBW48cyKERh2ZHTp9HH2d3O
	TmiCb//3Ki6GYL9g9hI74vp4EFCd/2ibVq6nTSTHy0o6+FHoixMbXYIM/JJxyB/2
	d+QacxNCG18LPB8LbSPbqKXKXzXEXZe4sC8lHtD1jilaRP2TeUYutAtjvrHpMUtf
	mXYt7yXBMo03i1gxkaRPmuFqM/kTuEtFmvswdLH68BhASZVjOHuW9klMjGuA7rH3
	tK2DvnwQAUi+Fdy564HNEQaov7wvX2jEjybZEL5MTsVaL4uiIHXel+SctQbbJXTy
	3/oGZ1yvIlzQlRMjqS4Qi3Ona1ioiCLXP0ZgNh0VavGpN+2ug==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:content-transfer-encoding:content-type
	:date:date:feedback-id:feedback-id:from:from:in-reply-to
	:message-id:mime-version:reply-to:subject:subject:to:to
	:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=
	1775255278; x=1775341678; bh=KwKgR4MFlPmcg5BCyZ3tm7btdNp94enb6Az
	OibDRtNw=; b=eejKl2uHJGhNhyz79UVixiqnFRllh+ZQbxGUurIv6t3Wlw8d9MA
	XK6Yb1A0DvVnbiCYbHhfro9FFfnG5zYHn5s8AUMzebNsLDKIyl5FGbwTNKNY2kK5
	yXH+8RdcbxssDBt60GIHTUZanrU8fUURskWCO2NweiDamZ00yXi6CUcnVLXsnVIe
	26GYtKB00wo9MhhGiQgBReZGVfKBdQ5qP02IVkaZER1gnx2i2Pl3tl7pJMNHr+r+
	2UA69dx+BVa2KFg54CzraIHmVybsoEGRzqRGMvs6HUylM/VMtQrsiF5tMMJNmmlc
	HLClx37tWhTryscJ7dDkEYutdifH6cWZZuQ==
X-ME-Sender: <xms:7j7QaZj0p1_3tFlsT8tS6diz1kfImNVbNLJMpL0_CbmRe-nle-dBSw>
    <xme:7j7QaUBU98QbRtVuScimaETSqt9dsftSma8-xZG6p7lCYkuRK00RaZzZ5RyHf_UWT
    vmtXIRfSoC17xR0LLR-IMhbAYK8f-Sde9bUOaDRIT7caplrxRqh6pE>
X-ME-Received: <xmr:7j7QaWtVSXIQkPbVUXKQp1awF7PCS-VRqOj-rq3byzM4MYleKyztARAlq9SEO8vs-pDXO5GrV5Kuj8xIiO6k09hYIPw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefhedrtddtgddutddugecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecunecujfgurhephffvufffkffoggfgsedtkeertdertddtne
    cuhfhrohhmpeeuohhrihhsuceuuhhrkhhovhcuoegsohhrihhssegsuhhrrdhioheqnecu
    ggftrfgrthhtvghrnhepudeitdelueeijeefleffveelieefgfejjeeigeekudduteefke
    fffeethfdvjeevnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhf
    rhhomhepsghorhhishessghurhdrihhopdhnsggprhgtphhtthhopedvpdhmohguvgepsh
    hmthhpohhuthdprhgtphhtthhopehlihhnuhigqdgsthhrfhhssehvghgvrhdrkhgvrhhn
    vghlrdhorhhgpdhrtghpthhtohepkhgvrhhnvghlqdhtvggrmhesfhgsrdgtohhm
X-ME-Proxy: <xmx:7j7QaZbJdTy2pvhOgoUuqS5AYxENtBfMygggV0jERGka9DhCNnLGFQ>
    <xmx:7j7QaZUWUmUebOVJFYXh01CzWpCO7-_HeJIVtk4irLT88ca911VFYQ>
    <xmx:7j7Qad5mMYnr0iLDrbblMHj0yZboPziFWcbGnPBUhWzQ6HcPSLb8MA>
    <xmx:7j7QaUjzsAClWRdO7IWdESXkeogLWu64ZHj_Z-RhYUyu5Pk5Ej9yFw>
    <xmx:7j7QaWFNKBN8zNf3FztJdLrCX3bjC1cHWjRfEB1GDUz31fN7TGq05mJD>
Feedback-ID: i083147f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 3 Apr 2026 18:27:57 -0400 (EDT)
From: Boris Burkov <boris@bur.io>
To: linux-btrfs@vger.kernel.org,
	kernel-team@fb.com
Subject: [PATCH v2 0/5] btrfs: improve stalls under sudden writeback
Date: Fri,  3 Apr 2026 15:27:50 -0700
Message-ID: <cover.1775255085.git.boris@bur.io>
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
---
Changelog:
v2:
- patch 1 no longer embeds a new block_rsv on btrfs_inode for the
  delayed reservation. Instead it does the reservation on
  inode->block_rsv and migrates it to trans->delayed_rsv at the moment
  of truth.

Boris Burkov (5):
  btrfs: reserve space for delayed_refs in delalloc
  btrfs: account for csum delayed_refs in delalloc
  btrfs: account for compression in delalloc extent reservation
  btrfs: make inode->outstanding_extents a u64
  btrfs: cap shrink_delalloc iterations to 128M

 fs/btrfs/btrfs_inode.h       | 17 +++++--
 fs/btrfs/delalloc-space.c    | 78 +++++++++++++++++++++++-------
 fs/btrfs/delalloc-space.h    |  3 ++
 fs/btrfs/fs.h                | 13 -----
 fs/btrfs/inode.c             | 93 ++++++++++++++++++++++++++++--------
 fs/btrfs/ordered-data.c      |  4 +-
 fs/btrfs/space-info.c        | 31 ++++++++----
 fs/btrfs/tests/inode-tests.c | 18 +++----
 fs/btrfs/transaction.c       | 36 ++++++--------
 include/trace/events/btrfs.h |  8 ++--
 10 files changed, 201 insertions(+), 100 deletions(-)

-- 
2.53.0

