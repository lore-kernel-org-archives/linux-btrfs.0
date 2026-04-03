Received: from fout-a8-smtp.messagingengine.com (fout-a8-smtp.messagingengine.com [103.168.172.151])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 584C5367F3A
	for <linux-btrfs@vger.kernel.org>; Fri,  3 Apr 2026 22:28:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.151
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775255288; cv=none; b=aurpw6zC/bb1gbet4YxtUguJyY6zWOVh0HjQdE3H1k1MbIMvJrZTV6MDZWz41xdrAFHmH6ar7W3DpLGwpEgOVCuVQSE4t9Ch4CzTvoD31SG5sqVUg4KazDXOFuDRd5+nP7TxGY3VDYcV7VUYo2cxtJpdjhY+colqRr8uAjCnUQM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775255288; c=relaxed/simple;
	bh=DDO9Uegk9fi4hkTPPk3bBgNKP8Kwu3PdVRTgLGxub8Q=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g/xU7kV3jesfzcKkzqofGv8cpx09eeT2+1HSvEd2wvnrjd4nDvCIm2LKSczUPpXZ6YajERFkoKBKzhz4APrrWbBByllSIJA166G1QG12QMZ8VbYWBNhKzrcLA4j3FPkx9QBI8QxxFQY67Gy4hrJc3kLToXvDpscOj7dP3f7TylM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io; spf=pass smtp.mailfrom=bur.io; dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b=tGWjdJ1x; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=Oj9wSfvU; arc=none smtp.client-ip=103.168.172.151
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bur.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b="tGWjdJ1x";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="Oj9wSfvU"
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailfout.phl.internal (Postfix) with ESMTP id 8D37FEC00B5;
	Fri,  3 Apr 2026 18:28:06 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-05.internal (MEProxy); Fri, 03 Apr 2026 18:28:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc
	:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm3; t=1775255286; x=
	1775341686; bh=ycWNY2iQLhGVaxcEwPI+NMAMXsEQbFNlHdBk9NRldBY=; b=t
	GWjdJ1x6dPptsVsqy86cR1n5ARhXQDKkWh2Oa6H66JZvyeNdAtsCa01/r706lWSu
	aAxeUc1mwWjLz9bwBlD1dmH56cfHZeU+HeZ4oVP81yHxNJZFsJWy3P0CS2qPyHv0
	EEWLTLMJkHHA6R25B6+2C8TYg9jt1PtpRq1vvm82pqAqOgytqFgUXj9vOH+8ASMj
	Fdw8uqQ3Rx+tlIz/K4qg3nE0wUA49xwHE8xU1XBe87fWQ95hJSO1nT6Cl9vX7/Os
	aHKtJ7lQhtq5pMFk4LaYYkAoGi5JecQrUuHgqsoIMR3ODsCTXK+l4qs1To10CRSn
	zje+WnVQcPBng/CHgXlOQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:content-transfer-encoding:content-type
	:date:date:feedback-id:feedback-id:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
	fm2; t=1775255286; x=1775341686; bh=ycWNY2iQLhGVaxcEwPI+NMAMXsEQ
	bFNlHdBk9NRldBY=; b=Oj9wSfvU1ZIs5jeAK051GUKz4Ej7lAMcCz8B2sX7xUZd
	w9xKtbN1UjErNYM/eGIvH6HcDdiF89MQNb6PuHvBZAOk/V22Q0ALSy2W26JNjCYY
	VAIdTOqic6/Vm6+2wMYOYdnNMgfl6Wygmb1GsSjLKchXaukfxzhcdkwGG5GJGLRb
	nLFiFKW6rEKdALpzMyKPqaAb9vjzfDe9o/5jF1DJWqGxkiTVBc2+8pl/ETLSv4gX
	DEB7mZVBrF/zm4xHyF5buHsb+bvNCZlZaXNQcyU2Gyr68hxcQ++QkqI657CmZ8JE
	qNOnMt0vWSxoY7bCrx6fMUJAHQ8oeGM+h9NCBPHqNQ==
X-ME-Sender: <xms:9j7QaRMESjoXwjpbYFuW3anG5W5L2J0kPPLX6xyent_ylQiWKoSjaA>
    <xme:9j7QaZ9tRGUs6j6Klg2-SQlUfUlxrmB0e7PQRdwd3c74zLAndjfYvh7Xe_fAOx6Fe
    d_5cqFbKUs469rpClkfVMvuVsvhdMeA7tsGFmWgyCGvg3ONCoRvG1En>
X-ME-Received: <xmr:9j7Qad58fL134olcHOCosH0doexMwlPWmCcu2eZDZK4irZj7UQhOub-lM1zMoBFQ7e0XG41XTlvJ1L_1nKDEV__eX-c>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefhedrtddtgddutddugecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertdertd
    dtnecuhfhrohhmpeeuohhrihhsuceuuhhrkhhovhcuoegsohhrihhssegsuhhrrdhioheq
    necuggftrfgrthhtvghrnhepieeuffeuvdeiueejhfehiefgkeevudejjeejffevvdehtd
    dufeeihfekgeeuheelnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghi
    lhhfrhhomhepsghorhhishessghurhdrihhopdhnsggprhgtphhtthhopedvpdhmohguvg
    epshhmthhpohhuthdprhgtphhtthhopehlihhnuhigqdgsthhrfhhssehvghgvrhdrkhgv
    rhhnvghlrdhorhhgpdhrtghpthhtohepkhgvrhhnvghlqdhtvggrmhesfhgsrdgtohhm
X-ME-Proxy: <xmx:9j7QaY3nsk5Ndxq7iezgLwECX4lbwW4YIpXCOA8FP-IlexXFrK5Qyw>
    <xmx:9j7QacDC9-MaIPT5a0E1M9fZqIuyMzrYxbBK3mxa9W1j--HJPQCSRw>
    <xmx:9j7QaS1XDlC51GMG6kFelcOkhBPdutifNk8n3IzJ6sqYDIbgi6ZYgw>
    <xmx:9j7Qaes-fje-0A8fm6zmVgP2Hst1qKuMQkeYSw_IdRzsKzDNFvc_mw>
    <xmx:9j7QaQxr5icG8VwDGHqtt9mbrOHa4kuPL9fVi2eQ5Dvxs9XIJZMhUzY6>
Feedback-ID: i083147f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 3 Apr 2026 18:28:06 -0400 (EDT)
From: Boris Burkov <boris@bur.io>
To: linux-btrfs@vger.kernel.org,
	kernel-team@fb.com
Subject: [PATCH v2 5/5] btrfs: cap shrink_delalloc iterations to 128M
Date: Fri,  3 Apr 2026 15:27:55 -0700
Message-ID: <115dd08f8ba76b0a2a6fdd19a8ac4d4fb335cc49.1775255085.git.boris@bur.io>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1775255085.git.boris@bur.io>
References: <cover.1775255085.git.boris@bur.io>
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

Signed-off-by: Boris Burkov <boris@bur.io>
---
 fs/btrfs/space-info.c | 31 +++++++++++++++++++++----------
 1 file changed, 21 insertions(+), 10 deletions(-)

diff --git a/fs/btrfs/space-info.c b/fs/btrfs/space-info.c
index f0436eea1544..15c5be97a123 100644
--- a/fs/btrfs/space-info.c
+++ b/fs/btrfs/space-info.c
@@ -727,7 +727,7 @@ static void shrink_delalloc(struct btrfs_space_info *space_info,
 	u64 ordered_bytes;
 	u64 items;
 	long time_left;
-	int loops;
+	u64 orig_tickets_id;
 
 	delalloc_bytes = percpu_counter_sum_positive(&fs_info->delalloc_bytes);
 	ordered_bytes = percpu_counter_sum_positive(&fs_info->ordered_bytes);
@@ -735,9 +735,7 @@ static void shrink_delalloc(struct btrfs_space_info *space_info,
 		return;
 
 	/* Calc the number of the pages we need flush for space reservation */
-	if (to_reclaim == U64_MAX) {
-		items = U64_MAX;
-	} else {
+	if (to_reclaim != U64_MAX) {
 		/*
 		 * to_reclaim is set to however much metadata we need to
 		 * reclaim, but reclaiming that much data doesn't really track
@@ -751,7 +749,6 @@ static void shrink_delalloc(struct btrfs_space_info *space_info,
 		 * aggressive.
 		 */
 		to_reclaim = max(to_reclaim, delalloc_bytes >> 3);
-		items = calc_reclaim_items_nr(fs_info, to_reclaim) * 2;
 	}
 
 	trans = current->journal_info;
@@ -764,12 +761,17 @@ static void shrink_delalloc(struct btrfs_space_info *space_info,
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
 		int async_pages;
 
+		items = calc_reclaim_items_nr(fs_info, iter_reclaim) * 2;
+
 		btrfs_start_delalloc_roots(fs_info, nr_pages, true);
 
 		/*
@@ -811,7 +813,7 @@ static void shrink_delalloc(struct btrfs_space_info *space_info,
 			   atomic_read(&fs_info->async_delalloc_pages) <=
 			   async_pages);
 skip_async:
-		loops++;
+		to_reclaim -= iter_reclaim;
 		if (wait_ordered && !trans) {
 			btrfs_wait_ordered_roots(fs_info, items, NULL);
 		} else {
@@ -834,6 +836,15 @@ static void shrink_delalloc(struct btrfs_space_info *space_info,
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

