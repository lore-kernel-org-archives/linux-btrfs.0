Received: from fhigh-b5-smtp.messagingengine.com (fhigh-b5-smtp.messagingengine.com [202.12.124.156])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5ECD88BE9
	for <linux-btrfs@vger.kernel.org>; Thu,  9 Apr 2026 17:49:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.156
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775756947; cv=none; b=bUmUx0iUZqtuHH75v1we2NEb3xXR25UknsfD4pObrcT7Zapn4AqoXDIjlvCcWwkakq9x+I0JRrRu5aiR3Bre2nyzL4c1pDpea1CgY8W1ExpXzj+yBpTo6P55+jN9jvgIawtje/IsiA4idALppx43yhJ8Fpx+E+EuR0KA6XmC8PE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775756947; c=relaxed/simple;
	bh=jE2gU9sOM89JCL7yCmcZBkka9hOjHexvEb6s+8euhjk=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=EzueEbnX/TabUis+hZ3rs4WJ2EsYdRXpDBC6beEuY4jOhdDT/2ug1PpgaFJOjY099pKJUnWmT6a3tsn8bqDchBA7KKf5Vi/vDeS8tlqevi1o7tXjVPiQ8Eg9gJDxBzXfFy4DLAUyE0HFnYMT/AA8M6eB6BkstgenT8WmQLUVL4o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io; spf=pass smtp.mailfrom=bur.io; dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b=L3dDSvXH; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=Jra6lrqo; arc=none smtp.client-ip=202.12.124.156
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bur.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b="L3dDSvXH";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="Jra6lrqo"
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfhigh.stl.internal (Postfix) with ESMTP id 5C5E97A01B9;
	Thu,  9 Apr 2026 13:49:04 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-04.internal (MEProxy); Thu, 09 Apr 2026 13:49:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc
	:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:message-id:mime-version:reply-to:subject:subject:to
	:to; s=fm3; t=1775756944; x=1775843344; bh=3DZdMVEC9atc94Vg4hhFr
	u8bNPFpV9kTBG6mz0LV6jI=; b=L3dDSvXHjS9AnxDQVpyUWulkgAhpHlC2/BUEI
	FVznmdMb1VHgugyxxkuKqLpg1cj46pdIPOgkT3mWUVKStVnaoxFjsiv8FJwvf03e
	PjIxthw4ShqSN2VsBqZEDn0Gb1maoKgVtJaNoHXCXEQokJbflXcIaqGKzLyEiKkB
	PILHPCNkSXVkEKRr/4QAhBPyj0Lih/KrWByxOVE+/ITN3ORE7v5K4BcVoAdKP0t/
	LyWx3R2+twQs2XvtF8TJDZQxGMxW+YIbsubvgsRmScevBLwfOAhDjPpQ9uYcsyfL
	3y5xVg802sANUtnigcr221HXrkH9dG7mjTdz2YBJb539AEfqg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:content-transfer-encoding:content-type
	:date:date:feedback-id:feedback-id:from:from:in-reply-to
	:message-id:mime-version:reply-to:subject:subject:to:to
	:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=
	1775756944; x=1775843344; bh=3DZdMVEC9atc94Vg4hhFru8bNPFpV9kTBG6
	mz0LV6jI=; b=Jra6lrqo5gSRqXgVj5dhw0moZMD5HzaYUz53VyB2wjhU7Juj+J2
	i8MKXIuUzRKxavvVFdwVPXtiSFUaHwAZg0O0xoD7c+wb7DvmSctvzc1Yo4Oxh/e9
	ptEo/FExavfues+4h9Ql9cG0rrZ9AofQUB575WBciSeZLEIoKogslJoec4/yIWpZ
	+03PwEYVGxRWfTUl0/F0Tcbyixe1+GITo3EZz5Aj5FLP9YkoCO35Qq1Eqs1g69T5
	lgD6v4m+K+QTUjChk6pzrtpO4qKjXyTv4YZwjBrs1spmT7Tn+qgQi3WTiGZrUHOu
	1t9nZIVeq4LhukwRkOe0dfY5OYR7P91wXvg==
X-ME-Sender: <xms:kObXaaUl5hpbc82CBysTqawf6lQz2oFCwEziNoD7BTTqCarxQkgSBw>
    <xme:kObXacnkf9zDbkZssEYmGN5ODsaSGCtEiwdzuAtbIe3CEWlYbgtYauw0efrPzT051
    6zT3kt9eEvKb7AtAl8e6eqRaqv-NwKK71CL20qaFgT3cJILIeb-N2E>
X-ME-Received: <xmr:kObXacD1lTW7pmsc0K5jQNUYrq0DGWs6YneaCLmb0HWlqbZc1yXBHolgAYTQloa_45Dmr28H3Jk2s_VOOAZh96wf67o>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefhedrtddtgddvjedufecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecunecujfgurhephffvufffkffoggfgsedtkeertdertddtne
    cuhfhrohhmpeeuohhrihhsuceuuhhrkhhovhcuoegsohhrihhssegsuhhrrdhioheqnecu
    ggftrfgrthhtvghrnhepudeitdelueeijeefleffveelieefgfejjeeigeekudduteefke
    fffeethfdvjeevnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhf
    rhhomhepsghorhhishessghurhdrihhopdhnsggprhgtphhtthhopedvpdhmohguvgepsh
    hmthhpohhuthdprhgtphhtthhopehlihhnuhigqdgsthhrfhhssehvghgvrhdrkhgvrhhn
    vghlrdhorhhgpdhrtghpthhtohepkhgvrhhnvghlqdhtvggrmhesfhgsrdgtohhm
X-ME-Proxy: <xmx:kObXacdrfsCK7Ol3QBZhTk8pMtkccvluOqqQnjkGzfG4a41CXHOxig>
    <xmx:kObXaXIr42H5Phf_P2oHEL9CQPTJqZupwNrqRwPzAmm5Ru5v4GnA_A>
    <xmx:kObXaffWcU3ucWacd5UngAWtZwkBQC8u-ggpYxKZ2dgy2_I7g1EXcQ>
    <xmx:kObXae0j43n-OahZ_QGmBdJNkezqkEXcYwsaREl6b2XD3KQ_woh0Ew>
    <xmx:kObXab4UfmCdWjJweQufXeM1M5aiEKC61JoTcuIQ2LhAanNyEmyFpwcq>
Feedback-ID: i083147f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 9 Apr 2026 13:49:03 -0400 (EDT)
From: Boris Burkov <boris@bur.io>
To: linux-btrfs@vger.kernel.org,
	kernel-team@fb.com
Subject: [PATCH v4 0/4] btrfs: improve stalls under sudden writeback
Date: Thu,  9 Apr 2026 10:48:47 -0700
Message-ID: <cover.1775756789.git.boris@bur.io>
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
v4:
- Treat the extent tree data delayed ref as needing reservation for two cow
  operations.
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
 fs/btrfs/delalloc-space.c    | 79 +++++++++++++++++++++++++------
 fs/btrfs/delalloc-space.h    |  3 ++
 fs/btrfs/fs.h                | 13 ------
 fs/btrfs/inode.c             | 90 ++++++++++++++++++++++++++++--------
 fs/btrfs/ordered-data.c      |  4 +-
 fs/btrfs/space-info.c        | 31 ++++++++-----
 fs/btrfs/tests/inode-tests.c | 18 ++++----
 fs/btrfs/transaction.c       | 36 ++++++---------
 include/trace/events/btrfs.h |  8 ++--
 10 files changed, 205 insertions(+), 97 deletions(-)

-- 
2.53.0

