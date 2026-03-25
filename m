Received: from fhigh-a4-smtp.messagingengine.com (fhigh-a4-smtp.messagingengine.com [103.168.172.155])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3B1C202C48
	for <linux-btrfs@vger.kernel.org>; Wed, 25 Mar 2026 00:42:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.155
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774399343; cv=none; b=jctiLP77RjxCzWOdFlp896uuXi6+7/lfdHm3rFhMoS3qNSXi9u0tnYyJEOgTywa8hSDgrEj+gN18Pmv8eMw7E7U08gZ5xQ5kGVXOYFwonmGVnyJeq7cc+iH1GGfCtTYXQ+EzJ+KAAzCFBLeewCMxrEmC9xWLrqka169pzzT31ZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774399343; c=relaxed/simple;
	bh=uuOeIuCgjX8TRU1f7lAsMlhlln42DhG4LYrBHeTt6WU=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QHJu8UKogdzpabA76v/C8mpyYpVppL7IfwHKavQaYFEXhlfmtSr5/q7daz6kKg/NTSk6TZSWSRgkmC0+c/EcgVdrR0p23obsFM/BQqrZc3wdEljI5IvQMJDP4KiaqFwaWLgcSNI7mfHPmfRDnpkAybc2yvslzgmyfVbDb46WCUQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io; spf=pass smtp.mailfrom=bur.io; dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b=ctLBmFGB; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=jzsZLHHR; arc=none smtp.client-ip=103.168.172.155
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bur.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b="ctLBmFGB";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="jzsZLHHR"
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailfhigh.phl.internal (Postfix) with ESMTP id 2CE8F1400183;
	Tue, 24 Mar 2026 20:42:21 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-06.internal (MEProxy); Tue, 24 Mar 2026 20:42:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc
	:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm2; t=1774399341; x=
	1774485741; bh=VX+ulV7dyMWsEdMHqNd4aPNJXNDx0NelnayqVA6PpuY=; b=c
	tLBmFGB2L17LQbHPesBpz85qYy6e4p9mDpTjkGyBBh8YOrigms97Qu6MUy/IoVTk
	u59SpKotwpDKXqIfy717QfV+i3GRwo2YNVwf0/sKIYucu0QK2YlWFImVMa9CjKNW
	zC8tTnJXCq98uWN7uSB/gmTxJCB1aGFLCtxZiKpAw0ELgSuY63Iz5yVzLbf9NByI
	R7xiOYiBGLZBCKXclpRvsmVR1BievyAc44y1jX1SnY7TFDu0Z/WyOyIe1RAGUZFQ
	cPgye9AfRpg2T+5Z0cocoe636K953DbKTQhmhLbH1YZyUZaFpMmLYKpkRAXzE2bg
	sRfYwDjLO2iBRfHmhCQfg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:content-transfer-encoding:content-type
	:date:date:feedback-id:feedback-id:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
	fm1; t=1774399341; x=1774485741; bh=VX+ulV7dyMWsEdMHqNd4aPNJXNDx
	0NelnayqVA6PpuY=; b=jzsZLHHR3IxKIpQqITanVFWh9klJ8eOHRiEXbhukvpP+
	VDWa85yiw9Vl2HJ8r71cpFNBT3Pdfj8aiz2UKw3SugNGq8jCPKfGUw4oUI2jH5v2
	b7VF1thDi0/BIUd9w0qXr5VYbB6dB9LkxcVJVKe4OPeM9ElVmdtOsWW5llGfED6/
	yKZUeWRTwhcczhhemPJB/Kl94OfNa3C9zPzA256QskOLj56CeyCMcjw2BRg/ES1i
	0kcg9SwpHwAr9HMgqckTAUL7fHOAgyooGM8fFvMw1Q3TUULunjCIKgyQyl/5OfMD
	DA8fX8oWP3EwP2ZzjTnSxlWHwOflW2Ki3wrMQGDaIg==
X-ME-Sender: <xms:bS_DaefK4bRXBIsJQffGzcscsKihBoXzvY7Br8gzsVKr7wGwpTzheg>
    <xme:bS_DaeON9hfGb4v7wJP-SNkK4Vc2muFOQjjbu2CjTTEJjyT2YCmr9Yl0VXLBarAu-
    LN-azed02XjzVZIMW04vQmSFf7iTyoIau8XfuVmuyB7v21Pt9R7COA>
X-ME-Received: <xmr:bS_DadJRAZPevHe_xPxClnapXzwGLM7ScS2DASa9C2Kexii_syiNaHPMALgNgMzhgibQVjtEl9MerPbxPNFAynPjsSI>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgdefvdeftdehucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekredtre
    dttdenucfhrhhomhepuehorhhishcuuehurhhkohhvuceosghorhhishessghurhdrihho
    qeenucggtffrrghtthgvrhhnpeeiueffuedvieeujefhheeigfekvedujeejjeffvedvhe
    dtudefiefhkeegueehleenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgr
    ihhlfhhrohhmpegsohhrihhssegsuhhrrdhiohdpnhgspghrtghpthhtohepvddpmhhoug
    gvpehsmhhtphhouhhtpdhrtghpthhtoheplhhinhhugidqsghtrhhfshesvhhgvghrrdhk
    vghrnhgvlhdrohhrghdprhgtphhtthhopehkvghrnhgvlhdqthgvrghmsehfsgdrtghomh
X-ME-Proxy: <xmx:bS_DaXHLhHiLjyiYRhVfwyP5me6G-c9pbY1hDkki-XlpdG0gSptZrA>
    <xmx:bS_DadSiRBNvge6sdcNpTE111Pl8y8Xs2RTKH-po7od5Wqb0imnxAQ>
    <xmx:bS_DabG3i2-2zvrfP8d7f_LnUh21oTFdVWvxGjbrgAE5VsdbfcxEcg>
    <xmx:bS_DaR_vRrb7edacLc65PJTq_N-XzHNmXK4ZjP9T_PjNTkoRmCQKHA>
    <xmx:bS_DaSDlqDmO4NsadzDTI5Knf94-O5nj-X7sS2FB8hVuOf8vV8OMe8aI>
Feedback-ID: i083147f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 24 Mar 2026 20:42:20 -0400 (EDT)
From: Boris Burkov <boris@bur.io>
To: linux-btrfs@vger.kernel.org,
	kernel-team@fb.com
Subject: [PATCH 5/5] btrfs: cap shrink_delalloc iterations to 128M
Date: Tue, 24 Mar 2026 17:41:53 -0700
Message-ID: <62b90bf5df8d281f65c36bfc8d62df5455ae82f4.1774398665.git.boris@bur.io>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1774398665.git.boris@bur.io>
References: <cover.1774398665.git.boris@bur.io>
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
index e017bb182c8c..42f7d63e2464 100644
--- a/fs/btrfs/space-info.c
+++ b/fs/btrfs/space-info.c
@@ -729,7 +729,7 @@ static void shrink_delalloc(struct btrfs_space_info *space_info,
 	u64 ordered_bytes;
 	u64 items;
 	long time_left;
-	int loops;
+	u64 orig_tickets_id;
 
 	delalloc_bytes = percpu_counter_sum_positive(&fs_info->delalloc_bytes);
 	ordered_bytes = percpu_counter_sum_positive(&fs_info->ordered_bytes);
@@ -737,9 +737,7 @@ static void shrink_delalloc(struct btrfs_space_info *space_info,
 		return;
 
 	/* Calc the number of the pages we need flush for space reservation */
-	if (to_reclaim == U64_MAX) {
-		items = U64_MAX;
-	} else {
+	if (to_reclaim != U64_MAX) {
 		/*
 		 * to_reclaim is set to however much metadata we need to
 		 * reclaim, but reclaiming that much data doesn't really track
@@ -753,7 +751,6 @@ static void shrink_delalloc(struct btrfs_space_info *space_info,
 		 * aggressive.
 		 */
 		to_reclaim = max(to_reclaim, delalloc_bytes >> 3);
-		items = calc_reclaim_items_nr(fs_info, to_reclaim) * 2;
 	}
 
 	trans = current->journal_info;
@@ -766,12 +763,17 @@ static void shrink_delalloc(struct btrfs_space_info *space_info,
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
@@ -813,7 +815,7 @@ static void shrink_delalloc(struct btrfs_space_info *space_info,
 			   atomic_read(&fs_info->async_delalloc_pages) <=
 			   async_pages);
 skip_async:
-		loops++;
+		to_reclaim -= iter_reclaim;
 		if (wait_ordered && !trans) {
 			btrfs_wait_ordered_roots(fs_info, items, NULL);
 		} else {
@@ -836,6 +838,15 @@ static void shrink_delalloc(struct btrfs_space_info *space_info,
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

