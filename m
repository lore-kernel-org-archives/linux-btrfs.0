Received: from fout-a6-smtp.messagingengine.com (fout-a6-smtp.messagingengine.com [103.168.172.149])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3BF8376468
	for <linux-btrfs@vger.kernel.org>; Tue, 23 Jun 2026 22:36:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.149
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782254210; cv=none; b=mfWwlcKiC0rcllEiO8JG3Xk6Pb3hgPNWvy56oTXg4W94dNQBn+heLx3KnexYnYIyIF10MtnVnl9by7ipyJwcFKWL2u3++7gF8j7Qy8qlqsq5Zib/uICesUoRDzUDhej+76hP36TO2r9c0DyJykX1vjebn3LBAcApYjdu3L3f1/E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782254210; c=relaxed/simple;
	bh=vIy5Huf/0qyprJDU/8ac1/EsIEpqz/YatJ0FWMENyjg=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=CMKpTvXrecrsRSWg+U95umlCzMoesRoKwhP9Qk8ewRnG5kz5Vee3/p2wTO8f3c0GzP9PA8m/vjr+P8ggXcImdBgFW5z8qP+HBadYXWxbLOHHRX/7gTQPAJUmiYw5r3TjVvAEIz57OAz/Vc/hSnl1/D97s31SgnMKxuEiKRwFTrk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io; spf=pass smtp.mailfrom=bur.io; dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b=CBECv6+H; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=PaoXKlQ1; arc=none smtp.client-ip=103.168.172.149
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bur.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b="CBECv6+H";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="PaoXKlQ1"
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfout.phl.internal (Postfix) with ESMTP id D3E5EEC0316;
	Tue, 23 Jun 2026 18:36:47 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-04.internal (MEProxy); Tue, 23 Jun 2026 18:36:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc
	:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:message-id:mime-version:reply-to:subject:subject:to
	:to; s=fm2; t=1782254207; x=1782340607; bh=0EaWX49qSdgDJgf4Ufwku
	YyRUJpZkYjAiSPotEInpXk=; b=CBECv6+HX2q2TqFxV1xFrtY0wYRHUJkacRafB
	6o/I0Qcf/HscE6Hu/FrTsuFr+TsAKwPZf/LXrtXkeeCBT9Mb9585o6giByI14N29
	mimV0LfLrcXUiJNqgCg25l85UN4c7HU9cNnECvcLwrOIUFBx6BV5TU50tUz1K1dT
	h4Mpi3Jj8wUSTpBbO4EgSEQZUZPymIcVQ/torRkoa+uQ2rqaMSlSW4glhvp0elPR
	8rA5aY9xB7AheLR5DZSmEHOS/RwE3lTtyEt5VqVUEVYRoDNZK0gcw2wPiVzOBYYA
	Khk6z6/3UZxszc7N8Gj7ujEZTjxN2lHC11niUcYnmO5gTIyVg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:content-transfer-encoding:content-type
	:date:date:feedback-id:feedback-id:from:from:in-reply-to
	:message-id:mime-version:reply-to:subject:subject:to:to
	:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=
	1782254207; x=1782340607; bh=0EaWX49qSdgDJgf4UfwkuYyRUJpZkYjAiSP
	otEInpXk=; b=PaoXKlQ1scL7DQMfkNxTGWuRg9kQnUqlUZa7D25SWHZhg2uqbeg
	rsWQxhKGKcTJAeK2KbssYhQDQGOZYRfYZEZElh9JvrHa2WFSYEr855RnhB+EeQ8b
	LQVXyRFiXhXhBwskbIz/Jv131u7/L6E8c/bHC5SZM6m+5ZpdZzSMUbo+0jSgRivK
	cjkJkTpTyQgbMOtmmDLlraOygjrpZdQ4RbyrjLE6T50slAlkMIezK1T+fD5PYfzz
	VSYXoS+QcOdABXBa+JFyjArbmJXAgbpCJudzl7KEezldAi/g0qmyCKiUdKqlAVfc
	S/1VbxmwAe0h43CBKyC3p6kLoGHLURj0adQ==
X-ME-Sender: <xms:fwo7ap9ad6deTsn2fPzeRW0QcODctDrg_w2WA2yayOV1nEqqtIuGkQ>
    <xme:fwo7ajsPZM6N86u4gItM2otWgntYw6d2XQ6AChZ0lA4fAKs67nHMcr93DPwmPTkFD
    YSctnPjjKUg-9XEdkIksA26KNBCBmLmzu5kfr8IKb0VtZxo66o2-A>
X-ME-Received: <xmr:fwo7akp09i4wM-DnxR4UtB6gpf_mi14QSC9GgTn8QgppJqtzS7aG4a7025B2WKJdYVmWnbJtGGrj7vlls0PT1uLFXbk>
X-ME-Proxy-Cause: dmFkZTGbiq/ZcOaYGTNEuTUn1E1Z3pukZgHDTc3LFFRys5+lZFZZeIi5Xb6Y2/ca3uBf6J
    mVXjGTTvoBUYuFIBmdC5NuynvHoMI9KfOC3CNFT0hjNMTGbX9CWGQO1qeVQPjj6j9kgCwI
    itgUHbeFkijMPFizv5fju2yKGqaclpaeJjlfk0mIFyW+I5cSj6JptQuh5qZjEuwaaeKxi9
    VbgXPyrLBtoun+HhvkuGjQtW4t4vkFXlXmovR1bghcJOUQQ65eBg9XiNorT10414EerXl8
    Xv9KB/pPjIFmLcaxBhIMe39c9+IVsGm6eWEOit4cCZEDtC2rSAOl40+4h+y1gnFyPg9BeT
    hzJzVSOGVbso6m69VPNIeZ9bnH+ybE4ezlduM869bknbXgppw6WDace+mAdeL/h9PJsOnj
    j2HS2hkWVuaFNp3ekArfbOsQD1+t5evb+h3q844ogTsQ8hLzT03Fe0SUGToPIqM29lmWy7
    x+zbfxlcnlqUoNjUEXn0PkmPcQH5Q11bQLTjVy12De0dl+A76POCSUBoOJa02SbKN/X1CK
    J6w5wt39zjuE7Cy1ekkc6Z3Tz0NVz8rkjUVj4FXhBEg/UrBwJG7/at0s42vyxgxQJWYGI4
    FPqAyPZLRC6e7IWECPHXCDNSI3w8GZGo7dM5ztiJnt2N12EL2HeDeXyrrzrg
X-ME-Proxy: <xmx:fwo7aolIfPOE1z2rfASlFhwmffPAdbostoqxuj5bYEtjpPrdaBxNpQ>
    <xmx:fwo7agx2KOuLMzxxnrAYiG85Ln2g0mt5Ux2Po0xFS7TWOIEXh5qxew>
    <xmx:fwo7aon28FKCrr_olGqYq6yOAhggotSSUuYv_xm2lbL0NJ4l1PJpeg>
    <xmx:fwo7ahfB-L1aGZKIYjnHIslNZ2dtuQ2yn-zWncnjICXNJCU6gwmPZg>
    <xmx:fwo7ali0zoqa8_YnYEL89NqDyYZ4YVF3Fjvm-Hh1Mn9MvWoGJpEQ6Llx>
Feedback-ID: i083147f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 23 Jun 2026 18:36:46 -0400 (EDT)
From: Boris Burkov <boris@bur.io>
To: linux-btrfs@vger.kernel.org,
	kernel-team@fb.com
Subject: [PATCH 0/5] allocate extent_buffer GFP_NOFAIL with unlocked retry
Date: Tue, 23 Jun 2026 15:35:35 -0700
Message-ID: <cover.1782249000.git.boris@bur.io>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From sampled fleet data measuring lock holders that go into direct
reclaim with a waiter present when they eventually unlock, we have
observed ~15% of those are btrfs extent_buffer allocations in
btrfs_search_slot() done while holding btree locks. This is the single
largest category. Additionally, a large source of hung_task timeouts is
both btree waiters and direct reclaiming btree allocations, which
further motivates the desire to drive down this source of stalls and
contention.

The aim of this series is to allow us to allocate the extent_buffer,
btrfs_folio_state, and the extent_buffer folios with GFP_NOWAIT then
fallback with EAGAIN to outside the critical section to retry with
GFP_NOFS | GFP_NOFAIL without any locks held.

This is analogous to how we must drop locks to read an extent_buffer and
then EAGAIN.

The series does not manage to completely eliminate allocations from this
lock holding path, as we also allocate inside xarray functions for the
extent_buffer xarray and the btree_inode mapping xarray, the latter of
which is done via filemap_add_folio() with no reserve type API. Luckily,
those particular allocations are small cached slab allocations and have
nearly no contribution to the production reclaim fueled contention.

Boris Burkov (5):
  btrfs: factor init_extent_buffer from __alloc_extent_buffer
  btrfs: add struct btrfs_eb_prealloc
  btrfs: enable unlocked NOFAIL retry for eb allocations
  btrfs: probe with GFP_NOWAIT for tree block readahead
  btrfs: use GFP_NOWAIT when inhibiting eb writeback

 fs/btrfs/ctree.c       |  36 ++++++-
 fs/btrfs/disk-io.c     |   6 +-
 fs/btrfs/disk-io.h     |   2 +
 fs/btrfs/extent-tree.c |   6 +-
 fs/btrfs/extent_io.c   | 224 ++++++++++++++++++++++++++++-------------
 fs/btrfs/extent_io.h   |  23 +++++
 fs/btrfs/subpage.c     |   7 +-
 fs/btrfs/subpage.h     |   3 +-
 fs/btrfs/tree-log.c    |   3 +-
 9 files changed, 226 insertions(+), 84 deletions(-)

-- 
2.54.0

