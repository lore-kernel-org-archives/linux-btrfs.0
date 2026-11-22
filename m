Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.192
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795315680;
	b=3UeqYyumT52xCvt/uXzETR+8Sx//6u/pZ+256/sJzj9EV7ZqIptlzt9CB2ywZCyLuPHV
	 y/1dpGWVIHzTK3Wr5mAp6nUR37215/g5b0HSvY/1/OBXbKYdJrrI2fxd9yyao9rxm5wKy
	 vzg3EuK7J9bLcV+VEdJog8kWuu3K+DbeZpylkWcU68ur6+JHs8hfiA8l97ok1zaofkdmm
	 VDjpm5UwycW8syoJtguu5mZfMtBIzIfB87AAizvKw1W7j999kVAId5qMT+AedvVuplPNj
	 zno9QJlO+SnyIBcZBiJTcJusveVX8+Gp2Y+7uoVJtN9o/l/Cknbrsr/WYa/tH/hrQpQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795315680;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=n0ndatV38PZlrFixRGq/e4s2juhZcDcXxdZkxAcE0Zo=;
	b=sVspJ7yAKue7GqHDzd1NRVQvzxb4iWk4LUe9LfwUcNj2cZ9bHnlZYMHKgS2NYX48I4ob
	 wN8YHlquhhc9Zuog1Ecjl8YEW9yqbTv1lBR34Md4BQ8XC4Eounjloboa04eRwYm1dapVx
	 kwvr5cz//mLxo7nBTWB/vJk19CEvuukylFEOmmrCaHq52d5jLTErkfI9qOiv6GjHtG6k3
	 auCF8Sx06OFte9Op5535hDOMwcPNTG/TCxWfri0QmiuYJTLji5bGzZHMltEnJQ8wOPqmX
	 xaChfs7dabrvGlyFs8UI+LprMDcGGwZmIOgYrlYEBmeYAH9Z/Wt1PrG85ntlIwtolug==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=PDjGsYxU;
	arc=none smtp.remote-ip=91.218.175.192
Received: from mta0.migadu.com (out-192.mta0.migadu.com [91.218.175.192])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2289606A691
	for <linux-btrfs@vger.kernel.org>; Sun, 22 Nov 2026 02:47:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A2289606A691
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=PDjGsYxU
X-Envelope-To: linux-btrfs@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=kDOoaIFLPqlwHJe2rIGpKq27GnOdOA9p/d3hHbZ9COc=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795315678; v=1; x=1795920478;
 b=PDjGsYxU+zpTvZpMs4x2nP10+LGyeyGf1BZIV6pO0b6t3VzD/+J/hkCRUZJAyp92zbUhFODM
 vgEfMn6tNx/EkUAQDbic6/RNTED+jFeUSL57dvliBLixiINl9wMpN5zM6KFzl4YItd52QTQbg3a
 l8ey5JPc7wobUSIwu6riEG8Q=
X-Envelope-To: linux-btrfs@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 70b8762278188cd6;
	Sun, 22 Nov 2026 02:47:57 +0000
X-Mizu-Trace-ID: 70b8762278188cd6
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
Subject: [RFC PATCH 2/7] mm/gup: handle memory.high overage while populating
Date: Sat, 21 Nov 2026 18:47:32 -0800
Message-ID: <20261122024737.2741569-3-shakeel.butt@linux.dev>
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

mlock(), mlockall(), mmap() with MAP_POPULATE or MAP_LOCKED, and
MADV_POPULATE_READ/WRITE can fault in a lot of memory in one call,
with mmap_lock held. When their charges can block, the charge path
throttles them for memory.high with mmap_lock still held. In a VM with
THP on, mlock() of an 80M MADV_HUGEPAGE range under memory.high=64M
made another thread wait up to 17.2s to mmap(), and a task in another
cgroup wait up to 15.3s to read the process's /proc/<pid>/cmdline.
THP charges in VMAs without MADV_HUGEPAGE can't block under the
default defrag setting, so they are not throttled at all: mlock(512M)
reached 513M.

Throttle these calls with mmap_lock dropped instead. The populate
loops, __mm_populate() and madvise_populate(), now fault in at most
2MiB per GUP call. Between calls, if more than a batch of overage is
pending, they drop mmap_lock, handle it, and go on. GUP itself doesn't
change. One fault can still charge a whole folio.

With this patch, mlock(512M) stays at 84M, and populating 2G with no
limit takes as long as before. The mmap_lock stall goes away when a
later patch removes the synchronous step.

Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
---
 mm/gup.c      |  9 +++++++--
 mm/internal.h | 27 +++++++++++++++++++++++++++
 mm/madvise.c  | 11 +++++++++--
 3 files changed, 43 insertions(+), 4 deletions(-)

diff --git a/mm/gup.c b/mm/gup.c
index 7605da0e06d8..d93d89f6aad0 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -1951,6 +1951,7 @@ int __mm_populate(unsigned long start, unsigned long len, int ignore_errors)
 	end = start + len;
 
 	for (nstart = start; nstart < end; nstart = nend) {
+		populate_handle_over_high(mm, &locked);
 		/*
 		 * We want to fault in pages for [nstart; end) address range.
 		 * Find first corresponding VMA.
@@ -1976,9 +1977,13 @@ int __mm_populate(unsigned long start, unsigned long len, int ignore_errors)
 		/*
 		 * Now fault in a range of pages. populate_vma_page_range()
 		 * double checks the vma flags, so that it won't mlock pages
-		 * if the vma was already munlocked.
+		 * if the vma was already munlocked. Do one chunk at a time,
+		 * see POPULATE_CHUNK_SIZE. On error, nend skips the rest of
+		 * the VMA.
 		 */
-		ret = populate_vma_page_range(vma, nstart, nend, &locked);
+		ret = populate_vma_page_range(vma, nstart,
+					      populate_chunk_end(nstart, nend),
+					      &locked);
 		if (ret < 0) {
 			if (ignore_errors) {
 				ret = 0;
diff --git a/mm/internal.h b/mm/internal.h
index de4593b3e3b6..12f7b4b1254f 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -948,6 +948,33 @@ extern long populate_vma_page_range(struct vm_area_struct *vma,
 		unsigned long start, unsigned long end, int *locked);
 extern long faultin_page_range(struct mm_struct *mm, unsigned long start,
 		unsigned long end, bool write, int *locked);
+
+/*
+ * __mm_populate() and madvise_populate() fault in at most
+ * POPULATE_CHUNK_SIZE at a time, and handle memory.high overage between
+ * chunks with mmap_lock dropped, so other tasks don't wait for them.
+ */
+#define POPULATE_CHUNK_SIZE	SZ_2M
+
+static inline unsigned long populate_chunk_end(unsigned long start,
+					       unsigned long end)
+{
+	return min(end, round_down(start, POPULATE_CHUNK_SIZE) +
+			POPULATE_CHUNK_SIZE);
+}
+
+static inline void populate_handle_over_high(struct mm_struct *mm,
+					     int *locked)
+{
+	if (!mem_cgroup_over_high_pending())
+		return;
+	if (*locked) {
+		mmap_read_unlock(mm);
+		*locked = 0;
+	}
+	mem_cgroup_handle_over_high(GFP_KERNEL);
+}
+
 bool mlock_future_ok(const struct mm_struct *mm, bool is_vma_locked,
 		unsigned long bytes);
 
diff --git a/mm/madvise.c b/mm/madvise.c
index 2d54cb9863ea..c77924e52d79 100644
--- a/mm/madvise.c
+++ b/mm/madvise.c
@@ -992,8 +992,15 @@ static long madvise_populate(struct madvise_behavior *madv_behavior)
 	long pages;
 
 	while (start < end) {
-		/* Populate (prefault) page tables readable/writable. */
-		pages = faultin_page_range(mm, start, end, write, &locked);
+		/*
+		 * Populate (prefault) page tables readable/writable, at most a
+		 * chunk at a time, see POPULATE_CHUNK_SIZE.
+		 */
+		pages = faultin_page_range(mm, start,
+					   populate_chunk_end(start, end),
+					   write, &locked);
+		if (pages >= 0)
+			populate_handle_over_high(mm, &locked);
 		if (!locked) {
 			mmap_read_lock(mm);
 			locked = 1;
-- 
2.53.1-Meta

