Received: from fout-a1-smtp.messagingengine.com (fout-a1-smtp.messagingengine.com [103.168.172.144])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC9BD257423
	for <linux-btrfs@vger.kernel.org>; Tue,  7 Apr 2026 19:30:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.144
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775590233; cv=none; b=t22pfSYElsf6z+6cxIc/QmEzOJBJiZIktTsBkrI5Ysx2AUh9wxzmdqxLTOJEVvB+2/cRmDchw940XVF0nF5pf4ErCd9KoS/wWom5fXyjeiW3O7egEZ/6dJxgjVJO9cuF4RSVfpiS3JZl1EIZmkXcqg14jX3zo5X5VH8MCqS/Okk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775590233; c=relaxed/simple;
	bh=3WlcKhdrF9GDPTYua5Y2LSCAMEFmnAYKs2pTfaKgECY=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ijr0hfxrIko4DVH0jMHrls5ws8E9L25Q7Lqneev3LeaobY8pcMQh+ntZ6FYU3ENJpKC3RDYNbLvuvOzp/qwQ8N/AO1aTUOO6TDlKnP6u96ZPfS5Aw47zii+At558mXtpHkxeUh7yvmHSrM/xjScdlXrWqxFdMUUqKb7gbofh3fs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io; spf=pass smtp.mailfrom=bur.io; dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b=DESi7Zdp; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=vj3oelVC; arc=none smtp.client-ip=103.168.172.144
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bur.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b="DESi7Zdp";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="vj3oelVC"
Received: from phl-compute-03.internal (phl-compute-03.internal [10.202.2.43])
	by mailfout.phl.internal (Postfix) with ESMTP id 27D07EC0463;
	Tue,  7 Apr 2026 15:30:31 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-03.internal (MEProxy); Tue, 07 Apr 2026 15:30:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc
	:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm3; t=1775590231; x=
	1775676631; bh=go7qzjkTEJ2hPhLdhnwDEvQm07KoOIiCQZ1NPD+7Vyw=; b=D
	ESi7ZdpVbixylXAlpMh+r2EH84zh0knij8Jiny0BCdQ/mNDHgQiJjkyFDrWvWyYr
	OBraHViKe62ozymkGEpYaPqLPa4/mgQ5yzGLTnxpLzCkLrhwBR0RINB9EIx8580P
	akz9qAP2x4R03IB6ai3c71jiu+2UCc1VwsOWTKhYXHO605CRj3ftSsUgU93F3QZ7
	Q+h8bquXJ4cgDs3oh5d+pPNbukuA/QMOPKigIOhVJb8EJclQwfvVaXDL06oAlfhE
	1hkya0+EVRnQsA4/qTJxPXBg9zS7BeGZOQgLmgY4+ela9J48dGj5joJEYHR8VZ4O
	RvCCSHgNz9WAUPVWL3gfA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:content-transfer-encoding:content-type
	:date:date:feedback-id:feedback-id:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
	fm2; t=1775590231; x=1775676631; bh=go7qzjkTEJ2hPhLdhnwDEvQm07Ko
	OIiCQZ1NPD+7Vyw=; b=vj3oelVCU2EsqvHNh2hEVlv71E285xvAIFO0XAHTBN9J
	IBkcDopMPTiexxKqhvmBRex7Yj+TlsMcpQiTM+4fYPJ8DIw2BhjScmgqGogATmzH
	cUCvliOKvr9wOUjJOOn7TJIBVbGTHNhsn3thwbaoLqkf7o8FtFv/1NnnYVBrIhre
	p3py3qkZeZZY+GP0zRsQmtfA/38pDgWFrR8cbtgRztzZJ59WlQ84c0Y7RNdbAunO
	36AbtYxrnZPkgP78j9oMLPvUM9+RYadfgExUfe3+mFNQqqtzrnQBLDP4dWOQKvRn
	kKHcV38Bgx1EdqLr5WVo0eusRqKpRgXnG04pSHXWYw==
X-ME-Sender: <xms:V1vVaW5_4tl7Pv2h3bVV5sNEYWanp5l6mb2ab7ZIKEVUDXtTs4a52A>
    <xme:V1vVaV616PmSzg-d_Dtdc-W9nsDoY9ZF8tNGO1jKXbFJnRtGk_WSGURmlWq88l0Sc
    -6WwhISp4XQEq_0gswRzo5AnBwhJ2S3Zh_RJLs1wK977XoOe1XMzKo>
X-ME-Received: <xmr:V1vVaTGj-GUL0Hex7iJlbgFep-zL-y7p2GlgxjmJ_2kHyiXyanwxHV01igJBIF6GG-d6dYKcjhxyQfCUlFA7WL770B4>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefhedrtddtgddvudehtdcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertdertd
    dtnecuhfhrohhmpeeuohhrihhsuceuuhhrkhhovhcuoegsohhrihhssegsuhhrrdhioheq
    necuggftrfgrthhtvghrnhepieeuffeuvdeiueejhfehiefgkeevudejjeejffevvdehtd
    dufeeihfekgeeuheelnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghi
    lhhfrhhomhepsghorhhishessghurhdrihhopdhnsggprhgtphhtthhopedvpdhmohguvg
    epshhmthhpohhuthdprhgtphhtthhopehlihhnuhigqdgsthhrfhhssehvghgvrhdrkhgv
    rhhnvghlrdhorhhgpdhrtghpthhtohepkhgvrhhnvghlqdhtvggrmhesfhgsrdgtohhm
X-ME-Proxy: <xmx:V1vVaeTKgeQ3Xeh8_YqrMJ9_rviY7KIMpTZvjS2ugNV5fNsAggdL_g>
    <xmx:V1vVacu4gpNmK7A9J3NNPvmNbcJ2xH1zcfhcIKLS0bwB3RYEQe-bqA>
    <xmx:V1vVadz7akP8kjx71HI3Nx-C2t1VN7sX8CMNWTBLNtg-W15sc4LGjw>
    <xmx:V1vVaW6XOaX69Z6IkJV2WpvOBt20kzxNeq8kR-A5xP1O7MclMFcjdQ>
    <xmx:V1vVaZdCVO6e4Ewzze00py3M2BqXn9OeIMkcIHViogLNNU35jC2NNW16>
Feedback-ID: i083147f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 7 Apr 2026 15:30:30 -0400 (EDT)
From: Boris Burkov <boris@bur.io>
To: linux-btrfs@vger.kernel.org,
	kernel-team@fb.com
Subject: [PATCH v3 4/4] btrfs: cap shrink_delalloc iterations to 128M
Date: Tue,  7 Apr 2026 12:30:14 -0700
Message-ID: <61ef50bdf31d861e009319af657bffcdf058a5c1.1775589916.git.boris@bur.io>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1775589916.git.boris@bur.io>
References: <cover.1775589916.git.boris@bur.io>
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

