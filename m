Received: from fhigh-b6-smtp.messagingengine.com (fhigh-b6-smtp.messagingengine.com [202.12.124.157])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCC583B3883
	for <linux-btrfs@vger.kernel.org>; Fri, 29 May 2026 21:24:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.157
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780089847; cv=none; b=ALRnAlmqzEsCIwMLx4hxFOzoS2xTPbZ562q9NB/fBlacB5iyJdfLLveEs48YSaIHDNd6cGD96FFEAdvOCOq5wxLP5tZw47bwNSToom8tA2RxD1TDBqKttytKL7n1qOOTx3N04qJpCNMTrmfI48nwcyMj21hsRu3+AaDGi1z90jg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780089847; c=relaxed/simple;
	bh=eWlz7HB7pvXa9VHMgjeJYbEC+ktB4D2e+DhJR2dJp7M=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=QhzK0Hgl/1J3fRRU0S+2O2Wb/Gs8D+EquQsV81AaqKwAmx6haYBa1/c2u6qrH75E3rjUMHoNbWe67j5nvxd3eJHseFJhnCjd8DZPZmv0rWMvvM4EQfhbwz2+MyYZwIItmZKXolH54PqVcL4bMUgEXMbpNgMtOo/kAft2taoJ0sE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io; spf=pass smtp.mailfrom=bur.io; dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b=YlS929E0; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=WnfTWKSP; arc=none smtp.client-ip=202.12.124.157
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bur.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b="YlS929E0";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="WnfTWKSP"
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfhigh.stl.internal (Postfix) with ESMTP id BFF857A0042;
	Fri, 29 May 2026 17:24:04 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-01.internal (MEProxy); Fri, 29 May 2026 17:24:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc
	:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:message-id:mime-version:reply-to:subject:subject:to
	:to; s=fm1; t=1780089844; x=1780176244; bh=NEWC9E7vnNrs3O05FzKVu
	SZK3RI8wJsPmPXFqNgeEt8=; b=YlS929E04WxvFTTvmCXAKfd+8FkKEAj9cfFmT
	0AZo3IWO5JX4mR7jrVuBeIaKvmYPJyb69Hz6BSCvDCOuMK4NEeju+KdxjHm7UDzp
	AKI/I3An3EyqzovNJ5CxVkT7+D9dybDMgFYdht5r3sGjlb83IktYcPiBdI6CtRvD
	kTLxEkfCoxXGf1cSDzGBerp8PP9gQATvI1HTjQbD+fYthTj5helHmUXIGtUqI0aY
	RXARvl1k73iYM125l2F1TlQ8IE7B286oi3nMxUZBEFz2XciFZ1M3F0tqYCOOPALO
	t9FCktNWcUuv38EpR315V3EkAftXoQyXoRiahWgwlR3oX7yyA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:content-transfer-encoding:content-type
	:date:date:feedback-id:feedback-id:from:from:in-reply-to
	:message-id:mime-version:reply-to:subject:subject:to:to
	:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=
	1780089844; x=1780176244; bh=NEWC9E7vnNrs3O05FzKVuSZK3RI8wJsPmPX
	FqNgeEt8=; b=WnfTWKSPxs4pAVajpBxBrJJjbRy4+i+1/In5o5r+t9lnt+7XibY
	I9h8zbSlLIn/jIqd7WZirqh7JdTZNKI2+Ziow5bFrI+cXqY281f36oBIYVYmxQao
	LB4utGylJ94kuVQCw1LefOBmpG55JHyb0ZgQcY771fPK1arF+sa3Ij4NLbmVjvjA
	ei61UFgyAzr+Q1vtlYBv1Wv6eI9K5MmcnDinimzuC41dYfXLfBPZgJ/bvzRsDmwd
	/SBd5i2cYGNXs5dFnVPTNGUvqLq18rEl+qv7PoDDwCk4zvulLkr3Z2KZFUFarIon
	qr2NdgEz/OQMyghc3EL3R94Q7Q9vmzBZdzg==
X-ME-Sender: <xms:9AMaavQUJr9jQyAfJK9bnUdY5erma0cdieaCgwXoZC3Jcw9vM4qPiA>
    <xme:9AMaamzDjVv6PR8mTqhk-d8D-t5i4eDqwZ3QPM91BVx4MFpbw_inCE1Ccea0d9m0p
    NHzAQkoNMjE_7L5GRPLTxoxKUWNW28urI3tUPsYTqH4wVcqsGHzoj8>
X-ME-Received: <xmr:9AMaaiczyFzyPs3eX5YqRPVT-bYGewiCuZ-ytZa0xRvnPScSgFaJxc31tla-l6Sy16V4uPQkggGPGu2wGbFhReJla5Y>
X-ME-Proxy-Cause: dmFkZTE8EgL1/5uc7/cYyVAnNrNEtp5gq5jp30Ais3VPdyzz80oFB/dtSkJuNXzmYUdkk5
    FWA2qyX3qzoPAdvNopLPFuPtm2vMQTzR7d+keusMm8MDnIAyKVVHru3BUESCqhxzfdl90A
    1mOFfTGMAur3BrWtfACwDnPb/xY/99VXbS3yJddRaEhVnupSpGlR6/kar6W9hPKFu/RLm7
    yCloIWTQ2fmRM4yb4Gc91VPCfgchAy2K5pJGU0e+3YECpeNmk9kwAjc1kxyVPT9HsrTW+s
    QyZdKpZNg99uYb7FYnZjOfFweDSCcbrMErvPnqy791APB5P3wB5p7h46UiCk3syNc76yJu
    t0ddfB0N8vm9qLkR6ySCE9/G0UDk8KVhT2PFQmkMpGWlSszBu9dTRIyH4Lb7OsPxRKbXJb
    0sv/WBDwg1fTSD1eaT7c9ZSBCQ8BTkO2zj6e+enHkEHrjcaSm5Y0GPcXiWH/5qCCZIk/7H
    6GRZK0sUIEnMdiB681gelDofwFkjD8pIFcSwE4ep9xDkwWgWR4cCpr79JyJWydhYY1GSWl
    g9eDklY5rK4ckVLePiFe0OvHal48ciXgBhBK/XvI/ny0R/meLNNzuUoQK3NHBhXXPMz8dP
    c6GEOBNqgJ8qmQkSfZ+luhXg3/gjFnKGKuoWf3pX1uX6Dut1V7f7zq+nNgCA
X-ME-Proxy: <xmx:9AMaaqIaAYHM6cM_CrKv0AYkJuj9hsLtJtn9i7Bao0z-oIAEPrxtQA>
    <xmx:9AMaarFghN5CYHs8M9crfKHngFziDStIRuTi3P4fn1PnRk3VDqDU3g>
    <xmx:9AMaasocAOzHVFr8x1EpxjoHeEQy6uu3LN5iRe6UUCYFshY6KacrwA>
    <xmx:9AMaasRwticL20lxgN9cQ4TmzEjrEPCIq-kEzDeTnSjOA7u7DjEBWg>
    <xmx:9AMaan3VNcdhRM2o_-RaLu2QaY9UE76sO3cAQGvSMfin7imicJRmYoio>
Feedback-ID: i083147f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 29 May 2026 17:24:03 -0400 (EDT)
From: Boris Burkov <boris@bur.io>
To: linux-btrfs@vger.kernel.org,
	kernel-team@fb.com
Subject: [PATCH] btrfs: use lockless read in nr_cached_objects shrinker callback
Date: Fri, 29 May 2026 14:23:46 -0700
Message-ID: <4c64ed769cbb827b8c55de8f89372fc27290feea.1780089816.git.boris@bur.io>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Ben Maurer <bmaurer@meta.com>

Under heavy memcg-driven slab reclaim with many memcgs and CPUs,
shrink_slab_memcg() invokes the per-superblock count callback once
per (memcg, NUMA node) tuple. For btrfs that callback reaches
percpu_counter_sum_positive() on fs_info->evictable_extent_maps,
which takes the percpu_counter's raw spinlock with IRQs disabled and
walks every online CPU. With hundreds of memcgs driving reclaim on a
host with dozens of CPUs, this counter lock becomes a global
serialization point: profiles show CPU pinned in the spin_lock_irqsave
acquire under __percpu_counter_sum, with cross-CPU IPIs hitting
csd_lock_wait_toolong while waiting for spinning vCPUs.

The shrinker count is advisory -- super_cache_count() already notes
"counts can change between super_cache_count and super_cache_scan, so
we really don't need locks here." Use percpu_counter_read_positive(),
which is lockless. Worst-case skew is bounded by batch * num_online_cpus
(a few thousand), negligible compared to the millions of extent maps a
busy filesystem accumulates and well within the noise that the shrinker
already tolerates.

Tested-by: Boris Burkov <boris@bur.io>
Signed-off-by: Ben Maurer <bmaurer@meta.com>
---
 fs/btrfs/super.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 958dd185c0d6..c946bccf0748 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -2432,7 +2432,7 @@ static int btrfs_show_devname(struct seq_file *m, struct dentry *root)
 static long btrfs_nr_cached_objects(struct super_block *sb, struct shrink_control *sc)
 {
 	struct btrfs_fs_info *fs_info = btrfs_sb(sb);
-	const s64 nr = percpu_counter_sum_positive(&fs_info->evictable_extent_maps);
+	const s64 nr = percpu_counter_read_positive(&fs_info->evictable_extent_maps);
 
 	trace_btrfs_extent_map_shrinker_count(fs_info, nr);
 
-- 
2.54.0

