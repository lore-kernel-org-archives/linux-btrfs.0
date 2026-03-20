Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A770D2E6CB3;
	Fri, 20 Mar 2026 07:35:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773992109; cv=none; b=VM7A2ZNP1c2L6+oDxDlUtl8WNpBsAK8fD1PMQJIwsPIidYLTfjtWKvK40tYBRhZEtzADJ+/wzQyd8ZKcmRcv+alkl5QKO9bKgOi5VAceqFy7gUJ2LUXVj6td/bchC39So5ic6wH2LTHGltoEj2c2ByGOOUIQt8ukQ8hZ1Y+RYhM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773992109; c=relaxed/simple;
	bh=e6Mi5ykL/c1zIChGVNKedSM36KIxaJbME8ig6VhakxY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ChIdOKkyYv8vRFOSQ2ZpErmaO5jfxc6rCW1SK/yvJLeTsltjPnt5l0/toyyILUEhdvAqhbS8KwkvnBNrqm6HB6THMD67oR4YiWA1pnwZmO3koB7TPeS0vzVmY73Og3sHEAIVGOh0Fs32+SdhWkNM5APTHoUOxXR6UHxt5r/yFSY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=LzkHYs1V; arc=none smtp.client-ip=91.218.175.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="LzkHYs1V"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1773992102;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=FNbNvZXXu33riENx4XuJpWuzUW3VBXZoTOCF6ytXFcA=;
	b=LzkHYs1VVpSpuPl+19cUCocktJLKZxkH4VN0EeMKclBwpbe/pe2FeDetXvzuA+j738ngt5
	eCPj+euK5hiLGg79oh6K2VeiwB+Gr1xaEfNkXNQxjQB9sg1q43k9PWjStSA2QQsF3P9zS7
	ltbewoXLIsO9zDr4g5iXVoiWJC4kkq0=
From: "JP Kobryn (Meta)" <jp.kobryn@linux.dev>
To: boris@bur.io,
	mark@harmstone.com,
	clm@fb.com,
	wqu@suse.com,
	dsterba@suse.com,
	linux-btrfs@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	linux-team@meta.com
Subject: [PATCH 0/2] btrfs: prevent direct reclaim during compressed readahead
Date: Fri, 20 Mar 2026 00:34:43 -0700
Message-ID: <20260320073445.80218-1-jp.kobryn@linux.dev>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

We're finding that while under memory pressure, direct reclaim is kicking
in during compressed readahead. This puts the associated task into D-state.
Then shrink_lruvec() disables interrupts when acquiring the LRU lock. Under
heavy pressure, reclaim can run long enough that the CPU becomes prone to
CSD lock stalls since it cannot service incoming IPIs. Although the CSD
lock stalls are the worst case scenario, we have found many more subtle
occurrences of this latency on the order of seconds, over a minute in some
cases.

Prevent direct reclaim during compressed readahead. This is achieved by
using different GFP flags whenever the bio is marked for readahead. The
flags are similar to GFP_NOFS but stripped of __GFP_DIRECT_RECLAIM.  Also,
__GFP_NOWARN is added since these allocations are allowed to fail. Demand
reads still use full GFP_NOFS and will enter reclaim if needed.

There has been some previous work done to reduce the frequency of calling
add_ra_bio_pages() [0]. This patch is complementary in that it reduces the
latency associated with those calls.

[0] https://lore.kernel.org/linux-btrfs/656838ec1232314a2657716e59f4f15a8eadba64.1751492111.git.boris@bur.io/

JP Kobryn (Meta) (2):
  btrfs: additional gfp api for allocating compressed folios
  btrfs: prevent direct reclaim during compressed readahead

 fs/btrfs/compression.c | 44 ++++++++++++++++++++++++++++++++++--------
 fs/btrfs/compression.h |  1 +
 2 files changed, 37 insertions(+), 8 deletions(-)

-- 
2.52.0

