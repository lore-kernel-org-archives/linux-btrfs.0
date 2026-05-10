Received: from flow-a1-smtp.messagingengine.com (flow-a1-smtp.messagingengine.com [103.168.172.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B23368834
	for <linux-btrfs@vger.kernel.org>; Sun, 10 May 2026 17:46:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778435211; cv=none; b=ntYMvFUKhsR6zIk8VC8a8+OFpnjdPIodzXvwS0autICMEp6pQRcanNPLPvsZWyolNnva2Y8+2+oqddVND+M6uDEVW6b2mM2iyYIfr5nBlrKVjgyxUE4KMJuqtsLdhn2BPKGRsaM1ECv8J8Jmh3M1es11sAfyw/QVOcH3K7hjPis=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778435211; c=relaxed/simple;
	bh=JCaHw4pvCZEvkyECOf1JWNt0kWxlKf87k/10TK7cWrg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=LERaO9V1vaWJd7d9zRpZlhqslZA15aMi4BKShwI0+95Ng4sTbJDGK67BqFNaQmSIzo6egxQPkizSwVhtwvRHAPzw/qRfCQozRs1j0W6u7TL1sfUA493JtbI1PpylSNxuj51DvSHjJ+2pmmyhuaZNKRB9VwIMLGvWQFs02XMTKSo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io; spf=pass smtp.mailfrom=bur.io; dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b=NcVIobDs; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=q++8swPl; arc=none smtp.client-ip=103.168.172.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bur.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b="NcVIobDs";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="q++8swPl"
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailflow.phl.internal (Postfix) with ESMTP id B87FB138008C;
	Sun, 10 May 2026 13:46:48 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-06.internal (MEProxy); Sun, 10 May 2026 13:46:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc:cc
	:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:message-id:mime-version:reply-to:subject:subject:to
	:to; s=fm1; t=1778435208; x=1778442408; bh=DFTguNZYm9sTJ+uqEabDD
	ZRd35ux+2HTEDD0zCywYB8=; b=NcVIobDsdfHo+zCaTGchf/pSjseyR+VesQBQ6
	KEAywhS8PpNjZ/GdOJvSO30ZfFwE9r9/Acw2xZfHitJSB49VJJoMWWAK39g7sjwx
	NGaYeRUtr1Fx6oS90HqoOF72Y0IvFW6gKM1wbhKShPfyDrxom7XabLizhOk4YL+0
	63rGC9G4k9B4hUy0uZG1gchRBYAN4+WoN/YVGb9cAYYo9BJhrv3Jo/8F60KN2A79
	4O7QjeaUX1JAc2h7NE1mFBXHp1OfX9RP74oQBnsgGtlEnN7cVXgz8bXbljt20lPX
	rGOmtiVKsL0TuE8sa6Fk46vyDJ3GOcNFnkj9cq6dzy/RW3ang==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:message-id:mime-version:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=
	1778435208; x=1778442408; bh=DFTguNZYm9sTJ+uqEabDDZRd35ux+2HTEDD
	0zCywYB8=; b=q++8swPloiYve/rquoucFZEpw0Ud91pL4Kfr7YatuAhQObJuZ5x
	Z++v7YGOM5JkRsFiQRJlTw5IMFj5qB6b++eq+1Iyg05f2A5ebZxnt8BG89Z95Ads
	ZHmM2fZo/zSsiHPbg/cxzjX+3zO5DOonwRxIayc89cSjpQi8OlVE4pkAlI8HnZax
	UYypyNF0b3ly9BOAuGTBo6tGa29WRexnw4gOoEHSjwN0zz/L9V9YBOSWifOCQoQA
	i8+WfszdT4IYICPvoXuyzy0vwrAKceJ1Eaj2Rz8CjjdsBcIqHelsMzis4soFhRxr
	MGEYjd0shEBIKAy3tRWZdWcb6pa84ND7UNA==
X-ME-Sender: <xms:iMQAajjAKtc7ELgqHQ6b9irsAKubak0C45KEmrpyCQcUIE5Z8APoUg>
    <xme:iMQAancfWHvTTCr7wygdRKB4BLYu1tsYBxB5binybLmasSo2IMJltq0t4K2G_nqxI
    HqbFVbuXuToFvoHhZKCHwVosS7KPdzeGN7BSddD0aXbGHoMTjCFVSk>
X-ME-Received: <xmr:iMQAagdY_BgGan5ca-y81X0YpZDTaLwqnzhbu-N4dSSwZ0NIUWkwprc23-Ifm2l6heeKZ55E3jQq4MIlFRK59cMkQos>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefhedrtddtgdduudeijeegucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucenucfjughrpefhvfevufffkffoggfgsedtkeertdertd
    dtnecuhfhrohhmpeeuohhrihhsuceuuhhrkhhovhcuoegsohhrihhssegsuhhrrdhioheq
    necuggftrfgrthhtvghrnhepudduhfevvddugffggefgkeeggfdvieejgfegkedvudetke
    ehhfdvffeugeevfedunecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghi
    lhhfrhhomhepsghorhhishessghurhdrihhopdhnsggprhgtphhtthhopeefpdhmohguvg
    epshhmthhpohhuthdprhgtphhtthhopehlihhnuhigqdgsthhrfhhssehvghgvrhdrkhgv
    rhhnvghlrdhorhhgpdhrtghpthhtohepkhgvrhhnvghlqdhtvggrmhesfhgsrdgtohhmpd
    hrtghpthhtoheprhhivghlsehsuhhrrhhivghlrdgtohhm
X-ME-Proxy: <xmx:iMQAap9IxntmBTSEU8wQ3poKRnNUzul3iIrdYTPyvsCjlSffqAQodQ>
    <xmx:iMQAaklBoReTj9vjiboD3LP19rSrOwB0k7gbS2huqjBAwe7yw8p0Tg>
    <xmx:iMQAaj_jLXixO9nOLI-BNLHP3ZH-smXBn3io65JMEvE3X1CN7lwAKg>
    <xmx:iMQAaqllm_MenHmOFL91ei7BsKhj2wQiDaNkpCLw6vraglnlWPJoaA>
    <xmx:iMQAakTUDUryed9RlJA96i54KUOV4Z6yKqey-P6We8Cktn9YmFJI0fxa>
Feedback-ID: i083147f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 10 May 2026 13:46:48 -0400 (EDT)
From: Boris Burkov <boris@bur.io>
To: linux-btrfs@vger.kernel.org,
	kernel-team@fb.com
Cc: riel@surriel.com
Subject: [PATCH] btrfs: always drop root->inodes lock in find_first_inode_to_shrink()
Date: Sun, 10 May 2026 10:46:36 -0700
Message-ID: <2c932910eb227ef5e9829fdc86d10a11e3170a99.1778435133.git.boris@bur.io>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

find_first_inode_to_shrink() locks root->inodes, then loops over them,
skipping those where it can't lock the extent_tree, or which have no
extent_maps or it can't igrab. When it doesn't pick an inode, it
attempts to share the cpu/lock with cond_resched_lock().

However, that has a subtle problem associated with it.
cond_resched_lock() only drops the lock if it needs to actually call
schedule(). With CONFIG_PREEMPT_NONE, this means the full timeslice as
detected at ticks. With 8+ cpus and default tunables, this is 2.8ms. So
regardless of HZ, we will run for at least 2.8ms in this loop without
dropping the lock, assuming it finds no suitable inodes. If HZ is
small enough, it might be even worse as the tick granularity becomes
bigger than the timeslice.

The knock-on effect of this is that callers to
btrfs_del_inode_from_root() like kswapd trying to shrink the inode slab
or userspace threads calling evict() will spin on xa_lock(&root->inodes)
for 2.8ms, so the extent map shrinker dominates the lock even though
ostensibly it is intending to share it. This produces memory pressure as
there is only one kswapd and it runs sequentially so it can get stuck in
the inode slab shrinking.

To fix it, simply replace cond_resched_lock() with an open coded variant
which unconditionally does unlock/lock around cond_resched. Sharing the
lock is decoupled from sharing the cpu, and all the users of the lock
now share it fairly.

I was able to reproduce this on test systems by producing a lot of empty
files (to make a big root->inodes xarray), then producing memory
pressure by reading large files larger than ram, triggering kswapd and
the extent_map shrinker. The lock contention is visible with perf or
lockstat. This patch also relieved a user-apparent bottleneck on a
production system from the original report.

Tested-by: Rik van Riel <riel@surriel.com>
Signed-off-by: Boris Burkov <boris@bur.io>
---
 fs/btrfs/extent_map.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/extent_map.c b/fs/btrfs/extent_map.c
index 514d7b59cbe5..fce9c5cc0122 100644
--- a/fs/btrfs/extent_map.c
+++ b/fs/btrfs/extent_map.c
@@ -1246,7 +1246,9 @@ static struct btrfs_inode *find_first_inode_to_shrink(struct btrfs_root *root,
 		write_unlock(&tree->lock);
 next:
 		from = btrfs_ino(inode) + 1;
-		cond_resched_lock(&root->inodes.xa_lock);
+		xa_unlock(&root->inodes);
+		cond_resched();
+		xa_lock(&root->inodes);
 	}
 	xa_unlock(&root->inodes);
 
-- 
2.54.0

