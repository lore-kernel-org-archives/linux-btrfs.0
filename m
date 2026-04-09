Received: from fout-b7-smtp.messagingengine.com (fout-b7-smtp.messagingengine.com [202.12.124.150])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB5683CB2D9
	for <linux-btrfs@vger.kernel.org>; Thu,  9 Apr 2026 17:49:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.150
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775756954; cv=none; b=lOtDs+dyvhvT23tWTdwcb49zOT/Wjkq6tvXxDDWN3OzW/xDMs/UnDmkBvQOo4cfTwuvlyJxXcUSUVtJhWUnMjzrZWdCNoSroMJCQY/vZWkxyjJLuZnGNOId+eMpy1NxPylmdVehY7oC1r+8Nuy4FJT0T9NiDjfogfUQvL+/IaXw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775756954; c=relaxed/simple;
	bh=3WlcKhdrF9GDPTYua5Y2LSCAMEFmnAYKs2pTfaKgECY=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ncMZEpdzxijOb+iWJxvYvPHeuvqeu+2CMcH2i2bRKSl+cH6Hv6Ttm92Sxs9QU0AKxpfnglpI4LDX7+Hs31W8d7zeW0orAQefthBah08OK6fiiJlxUwH8TDPtziAA1T7BACqDR7oIQ8ONW8c6VOKSCE2gbG0S81j6cWYygmV7pXs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io; spf=pass smtp.mailfrom=bur.io; dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b=Igszks1x; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=EWkdOjhh; arc=none smtp.client-ip=202.12.124.150
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bur.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b="Igszks1x";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="EWkdOjhh"
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfout.stl.internal (Postfix) with ESMTP id 1CCBF1D000F5;
	Thu,  9 Apr 2026 13:49:11 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-01.internal (MEProxy); Thu, 09 Apr 2026 13:49:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc
	:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm3; t=1775756951; x=
	1775843351; bh=go7qzjkTEJ2hPhLdhnwDEvQm07KoOIiCQZ1NPD+7Vyw=; b=I
	gszks1xdQfvKvLKMCOo+57raz6qf5AgJOEKKyB/7pAfnTkYXJ6wvgeguGPnZt/pQ
	3JzA/uIG5FYxf6AxCfneSU9g+o4sVj7p6HDMFbmEvRQgJoSYffN7K9wjPd+LIvgz
	G62rme2mNktaSL3EIDsQA/yOYE7huYmB4Mk91bMEaCAv1WafJPtNS+saxMUoD4cA
	oumuMjFZSaFva4ednapUQyFDKAp7MsH1isBMchsr+ijEJbF0AS7yvtXW4e/ymgDA
	rkDEaAe2bxlVd9jdDVXtTdl/hIeeNSFrNDFSuzM0HShL3o3o/5P2zAyQJYamHxQs
	6Czoj83FStk/2XIjDDPnw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:content-transfer-encoding:content-type
	:date:date:feedback-id:feedback-id:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
	fm2; t=1775756951; x=1775843351; bh=go7qzjkTEJ2hPhLdhnwDEvQm07Ko
	OIiCQZ1NPD+7Vyw=; b=EWkdOjhhbbFfKWq3df9wvqldZfa5Kijrhl3BRHaUCBgy
	O9ovD4nD7iGvTy87YuYxi7dBU01u9lKrMopD7YoXS9CwF3BNCRwR5odKyJlhuM2V
	lyUp6zWK4uD/Zo2b476vBPpMR68qbsobCU7ndGpQenPpJA8ysVhR8PQnLMM1h3Zc
	/CONVSslLShs7/iJvbYEItN2jcXAu0J28FvDf8mMPGVw8b9hu1y5BvPMUeT/LPdL
	QA56hZy+Q2CJ7SyL3iX+eyHoyr8p+7/rJLogZSrU33Oh5NMKVzmK8BRwPIM5siKQ
	wNg1mrjfLriOiiyF/eqI/SMtHSac9M1NhWR5/dfqLQ==
X-ME-Sender: <xms:l-bXaU9yp68R-BQqJPdwMI3lZOD63VFhqy86fI1WgbC18Jaaj-dA5Q>
    <xme:l-bXaStFZvYgD3PTLtBA5ipvW6ZKQuVHJCW_TfVk4fz3FwP25epM75uvzyd7TT2VA
    PxsrzyNhaQzYA_a4psJwufbd2qFJrsKybxy_Tr8tzUIpzg6Ikb4T4M>
X-ME-Received: <xmr:l-bXaXoLnQ0eT4rQltLraUOdsHosqQ-yvqkQrTn3O5glZCSkM14uRntEPY3Ou6qR8Ik3io_HzyiNesR5Ndfv8fYCK0w>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefhedrtddtgddvjedufecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertdertd
    dtnecuhfhrohhmpeeuohhrihhsuceuuhhrkhhovhcuoegsohhrihhssegsuhhrrdhioheq
    necuggftrfgrthhtvghrnhepieeuffeuvdeiueejhfehiefgkeevudejjeejffevvdehtd
    dufeeihfekgeeuheelnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghi
    lhhfrhhomhepsghorhhishessghurhdrihhopdhnsggprhgtphhtthhopedvpdhmohguvg
    epshhmthhpohhuthdprhgtphhtthhopehlihhnuhigqdgsthhrfhhssehvghgvrhdrkhgv
    rhhnvghlrdhorhhgpdhrtghpthhtohepkhgvrhhnvghlqdhtvggrmhesfhgsrdgtohhm
X-ME-Proxy: <xmx:l-bXafnHf2ydk-ZiMXdhlJ45LyjXfNIIWFWq6WNKDJNbWkSAe3MVOg>
    <xmx:l-bXabxYZDGwJ9dJRCuFH516z2yrTtg2ED873v_oFSKVwwvQ7-0JvA>
    <xmx:l-bXaXmbWqJTQul-6uJM22QX7enEta-u5nOH2lYVwDubY0gLpyEEBA>
    <xmx:l-bXaUebY6VNd7p6hzviS-BDEc4pAwwYQRwAWFV47muQs9YgKH7H1Q>
    <xmx:l-bXaQivoVkFEOvJMn5dOQrhEIi3dJNoFwZt5uJZAoheIDNhU5N_DW8I>
Feedback-ID: i083147f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 9 Apr 2026 13:49:11 -0400 (EDT)
From: Boris Burkov <boris@bur.io>
To: linux-btrfs@vger.kernel.org,
	kernel-team@fb.com
Subject: [PATCH v4 4/4] btrfs: cap shrink_delalloc iterations to 128M
Date: Thu,  9 Apr 2026 10:48:51 -0700
Message-ID: <b990d13d17d8f6eeb341457801fdaabdf123f8e3.1775756790.git.boris@bur.io>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1775756789.git.boris@bur.io>
References: <cover.1775756789.git.boris@bur.io>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Even with more accurate delayed_refs reservations, preemptive reclaim is
not perfect and we might generate tickets, especially in cases with a
very large flood of writeback outstanding.

Ultimately, if we do get into a situation with tickets pending and async
reclaim blocking the system, we want to try to make as much progress as
quickly as possible to unblock tasks. We want space reclaim to be
effective, and to have a good chance at making progress, but not to
block arbitrarily as this leads to untenable syscall latencies, long
commits, and even hung task warnings.

I traced such cases of heavy writeback async reclaim hung tasks and
observed that we were blocking for long periods of time in
shrink_delalloc(). This was particularly bad when doing writeback of
incompressible data with the compress-force mount option.

e.g.
dd if=/dev/urandom of=urandom.seed bs=1G count=1
dd if=urandom.seed of=urandom.big bs=1G count=300

shrink_delalloc() computes to_reclaim as delalloc_bytes >> 3. With
hundreds of gigs of delalloc (again imagine a large dirty_ratio and lots
of ram), this is still 10-20+ GiB. Particularly in the wait phases, this
can be quite slow, and generates even more delayed-refs as mentioned in
the previous patch, so it doesn't even help that much with the immediate
space shortfall.

We do satisfy some tickets, but we are ultimately keep the system in
essentially the same state, and with long stalling reclaim calls into
shrink_delalloc().

It would be much better to start some good chunk of I/O and also to work
through the new delayed_refs and keep things moving through the system
while releasing the conservative over-estimated metadata reservations.

To acheive this, tighten up the delalloc work to be in units of the
maximum extent size. If we issue 128MiB of delalloc, we don't leave too
much (any?) extent merging on the table, but don't ever block on
pathological 10GiB+ chunks of delalloc. If we do detect that we
satisfied a ticket, break out of shrink_delalloc() and run some of the
new delayed_refs as well before going again. This way we strike a nice
balance of making delalloc progress, but not at the cost of every other
sort of reservation, as they all feed into each other.

This means iterating over to_reclaim by 128MiB at a time until it is
drained or we satisfy a ticket, rather than trying 3 times to do the
whole thing.

Reviewed-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: Boris Burkov <boris@bur.io>
---
 fs/btrfs/space-info.c | 31 ++++++++++++++++++++-----------
 1 file changed, 20 insertions(+), 11 deletions(-)

diff --git a/fs/btrfs/space-info.c b/fs/btrfs/space-info.c
index f0436eea1544..e931deb3d013 100644
--- a/fs/btrfs/space-info.c
+++ b/fs/btrfs/space-info.c
@@ -725,9 +725,8 @@ static void shrink_delalloc(struct btrfs_space_info *space_info,
 	struct btrfs_trans_handle *trans;
 	u64 delalloc_bytes;
 	u64 ordered_bytes;
-	u64 items;
 	long time_left;
-	int loops;
+	u64 orig_tickets_id;
 
 	delalloc_bytes = percpu_counter_sum_positive(&fs_info->delalloc_bytes);
 	ordered_bytes = percpu_counter_sum_positive(&fs_info->ordered_bytes);
@@ -735,9 +734,7 @@ static void shrink_delalloc(struct btrfs_space_info *space_info,
 		return;
 
 	/* Calc the number of the pages we need flush for space reservation */
-	if (to_reclaim == U64_MAX) {
-		items = U64_MAX;
-	} else {
+	if (to_reclaim != U64_MAX) {
 		/*
 		 * to_reclaim is set to however much metadata we need to
 		 * reclaim, but reclaiming that much data doesn't really track
@@ -751,7 +748,6 @@ static void shrink_delalloc(struct btrfs_space_info *space_info,
 		 * aggressive.
 		 */
 		to_reclaim = max(to_reclaim, delalloc_bytes >> 3);
-		items = calc_reclaim_items_nr(fs_info, to_reclaim) * 2;
 	}
 
 	trans = current->journal_info;
@@ -764,10 +760,14 @@ static void shrink_delalloc(struct btrfs_space_info *space_info,
 	if (ordered_bytes > delalloc_bytes && !for_preempt)
 		wait_ordered = true;
 
-	loops = 0;
-	while ((delalloc_bytes || ordered_bytes) && loops < 3) {
-		u64 temp = min(delalloc_bytes, to_reclaim) >> PAGE_SHIFT;
-		long nr_pages = min_t(u64, temp, LONG_MAX);
+	spin_lock(&space_info->lock);
+	orig_tickets_id = space_info->tickets_id;
+	spin_unlock(&space_info->lock);
+
+	while ((delalloc_bytes || ordered_bytes) && to_reclaim) {
+		u64 iter_reclaim = min_t(u64, to_reclaim, SZ_128M);
+		long nr_pages = min_t(u64, delalloc_bytes, iter_reclaim) >> PAGE_SHIFT;
+		u64 items = calc_reclaim_items_nr(fs_info, iter_reclaim) * 2;
 		int async_pages;
 
 		btrfs_start_delalloc_roots(fs_info, nr_pages, true);
@@ -811,7 +811,7 @@ static void shrink_delalloc(struct btrfs_space_info *space_info,
 			   atomic_read(&fs_info->async_delalloc_pages) <=
 			   async_pages);
 skip_async:
-		loops++;
+		to_reclaim -= iter_reclaim;
 		if (wait_ordered && !trans) {
 			btrfs_wait_ordered_roots(fs_info, items, NULL);
 		} else {
@@ -834,6 +834,15 @@ static void shrink_delalloc(struct btrfs_space_info *space_info,
 			spin_unlock(&space_info->lock);
 			break;
 		}
+		/*
+		 * If a ticket was satisfied since we started, break out
+		 * so the async reclaim state machine can process delayed
+		 * refs before we flush more delalloc.
+		 */
+		if (space_info->tickets_id != orig_tickets_id) {
+			spin_unlock(&space_info->lock);
+			break;
+		}
 		spin_unlock(&space_info->lock);
 
 		delalloc_bytes = percpu_counter_sum_positive(
-- 
2.53.0

