Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.182
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795315692;
	b=osMKlD6Q5lNcl+eCY4X5gAetsxNYgHbO0HhApT2rdY0LKA9cx0buEGeZijVSYKl7VunZ
	 U/OycdZjfPMehixDhmkq+wVBZ7/JJe5FGG7bskNhwwAjDjoEP7OnZTinDHr7WcDcrzjci
	 +CEAmeKJxYA2QlOidwfJQRweCUijCRT9j1McDEGDUtAEB4GQs/p5pWtgeCqKKgBiwIe16
	 ENa8VPTEIQFpnv7KlnSZ+finBHofngAH6xgmyFRui86mFgSvZShHhMBy18dMa6BWMi/AK
	 tZQRxgXDli8wyQzC4ILD2xR/ZQ6bfC+ahdwLs5CSPFv4cb6zwKodbFpGP+G+cnyvBTw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795315692;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=kAE5NOdIS0At3Jh5k02AXwppwZhtnhWNnu4TdJThSWc=;
	b=V3MRl0rWGOJ7g50z5ntIW5vTKla+0FIEG9OhFK5JWiXuya2KRcTvRZTsd45nTJ2eCL9J
	 MZa7Rv1VqSB/oYIi4aulEDn57x/xKbO3W2pls+H90JuWSz76GCg8OCRg4jQG39m5vqUa3
	 fezzfkkpkJSuZFoJIURx0phr84lVUNAc+s5U5vVb/6Af2cOKI/wHDRmnAzxE/QwbXH/Eg
	 uGnBf6/KLexV/OThSwtSKJLSoysh9ioyvrgP1B6D6rDR9fm8VQe+uzR/8iM/bDNYi7CVK
	 FC3zgXarCDNbf08Z/fqQAwvgoA/OJVIkSN5K6lkDykxXcEtJpDgwBRchFKb9awgzcyg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=IVKicsEJ;
	arc=none smtp.remote-ip=95.215.58.182
Received: from mta1.migadu.com (out-182.mta1.migadu.com [95.215.58.182])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F75B606A335
	for <linux-btrfs@vger.kernel.org>; Sun, 22 Nov 2026 02:48:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7F75B606A335
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=IVKicsEJ
X-Envelope-To: linux-btrfs@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=rf+KgpXOB1eGgKM+XYvnpxenhFFTGz2oUtU9DXBh1Sk=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795315689; v=1; x=1795920489;
 b=IVKicsEJXNAKfxno/Kp7uAN9lKaGVXM31V/OlAcTkNUiqcInsY9HcohqbaruKBNUi59YoWv6
 zIOyfH+lX2pgNiAwJAGNPhTPpqhisrnSDlyGT1D3S1ZquOINWJW5B00/nY10cB+fXoN0GrAuF50
 swEwHjvAR5ChboOv1dFubP9o=
X-Envelope-To: linux-btrfs@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 0558d52f41647cbc;
	Sun, 22 Nov 2026 02:48:09 +0000
X-Mizu-Trace-ID: 0558d52f41647cbc
X-Migadu-Flow: FLOW_OUT
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Tejun Heo <tj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
	Michal Koutny <mkoutny@suse.com>,
	Christian Brauner <brauner@kernel.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Jan Kara <jack@suse.cz>,
	Matthew Wilcox <willy@infradead.org>,
	David Hildenbrand <david@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Nico Pache <nico.pache@linux.dev>,
	Usama Arif <usama.arif@linux.dev>,
	Kiryl Shutsemau <kas@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Meta kernel team <kernel-team@meta.com>,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org,
	linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [RFC PATCH 5/7] mm/khugepaged: handle memory.high overage in MADV_COLLAPSE
Date: Sat, 21 Nov 2026 18:47:35 -0800
Message-ID: <20261122024737.2741569-6-shakeel.butt@linux.dev>
X-Mailer: git-send-email 2.53.1
In-Reply-To: <20261122024737.2741569-1-shakeel.butt@linux.dev>
References: <20261122024737.2741569-1-shakeel.butt@linux.dev>
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

MADV_COLLAPSE doesn't limit empty PTEs, so it can turn a PMD range with
one resident page into a 2MiB THP. Over a large sparse range, one
madvise() call can charge far more than the range used before. Today
the charge path throttles it for memory.high.

A later patch stops enforcing memory.high in the charge path, where
the task may hold locks other tasks need. Handle the overage right
after each collapse that dropped mmap_lock instead:
collapse_single_pmd() drops it to allocate and charge the THP. This
also covers the last PMD of each call, so madvise() over many small
VMAs, or a process_madvise() vector of small ranges, is throttled too.

process_madvise() on another process charges that process's cgroup.
If the caller is in that cgroup or below it, the caller handles the
overage here. Otherwise high_work reclaims it and no task is
throttled, as before.

Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
---
 mm/khugepaged.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 2dc4245814df..1ede7d30853d 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -3306,6 +3306,14 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
 
 		result = collapse_single_pmd(addr, vma, &mmap_unlocked, cc);
 
+		/*
+		 * collapse_single_pmd() drops mmap_lock to allocate and charge
+		 * a THP. Handle memory.high overage before taking it again,
+		 * including after the last PMD.
+		 */
+		if (mmap_unlocked)
+			mem_cgroup_over_high_throttle(GFP_KERNEL);
+
 		switch (result) {
 		case SCAN_SUCCEED:
 		case SCAN_PMD_MAPPED:
-- 
2.53.1-Meta

