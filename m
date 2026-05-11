Received: from fout-b1-smtp.messagingengine.com (fout-b1-smtp.messagingengine.com [202.12.124.144])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2CDF28C2BF
	for <linux-btrfs@vger.kernel.org>; Mon, 11 May 2026 18:20:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.144
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778523660; cv=none; b=OynA9DrqfM6MlOBOcfEGWFZqQHSK4lZlD1SMWwmKtcutyZESsigwiwSA5SyfEjZsbRB5EodnWOSTti8ZQ6Uv5AbsbtiU/FFFAl7JzTno/FLaFAi/gXEM2ixM1hJbgtPo/F97eThKLTwGlZIPtiS14zQfpgj7pRbzn+W+HzkPFGY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778523660; c=relaxed/simple;
	bh=NigGOOwuFFIEebt1iW8QWUdpQo0jWXV9EgXT54cY+zY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=dWDyzQLzUe2VwJigTVETxjb8cHG7nWRIQk6dzCWjUP9zFvcuJcXZDuBGyR6AqL8e5wE9qgM601WyatWxpXo7MZeB74qOyLxezp3x3aUKIX+xdNp6UC91EMlBgbq20MVxwR9SK2Rs3/6v8WHIB89HUu36gjRMJ3aZdQtO3bY+JWQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io; spf=pass smtp.mailfrom=bur.io; dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b=VwM7hS5H; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=m9Kyghif; arc=none smtp.client-ip=202.12.124.144
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bur.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b="VwM7hS5H";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="m9Kyghif"
Received: from phl-compute-03.internal (phl-compute-03.internal [10.202.2.43])
	by mailfout.stl.internal (Postfix) with ESMTP id 1F7371D0014E;
	Mon, 11 May 2026 14:20:58 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-03.internal (MEProxy); Mon, 11 May 2026 14:20:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc:cc
	:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:message-id:mime-version:reply-to:subject:subject:to
	:to; s=fm1; t=1778523657; x=1778610057; bh=GgWYERqyldTlbzlV4hQCz
	XQzaQlCyCa3U/Ppx546vdw=; b=VwM7hS5H1n475WzvUYfp5k/KOX17UouTaQnNQ
	jA7Q7hyNMEOe9lczNiaZqcOk+3tzwtzq8UQb4mkidmPXHjw4z2T/W3l+cZzHii6D
	iKHawuhnkMwXEQW6axEg1XlpmxZgD5xlrVgWIpu5wR6SABK9dG14InBjKBhM8TUX
	XoEMItVGKYsNbB0X+cRBi8aWESeftL0bFHAUwzRxco3fp6vyFEqr/VJn65QKOCK1
	G4FTIpqVgfvi+onrLjTlUDZ+1/osQHV9IJZy5XOz6Xy4zaWJneY0PT0BNRHLlqVk
	xyPyccCymx6bZogH9NYCXt3rQJd4qlcgYrlq35tPyyCqkdt7g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:message-id:mime-version:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=
	1778523657; x=1778610057; bh=GgWYERqyldTlbzlV4hQCzXQzaQlCyCa3U/P
	px546vdw=; b=m9KyghifEPABA4/Ls6d94k78OVvH2+aNkj8u8LPd/Ymu/KZmshh
	wNN5eb99iK5wopHVIirO7005OBDIH1sA11h6/je8y7a49OfZheuWB1Q8khJLeq0t
	t87H4A5ZBxaygglpr/xQdZwDh1BHwC82MWIAnRUV+XLK3CbGXczI/QuNN+qy6DzI
	LNCY9am2O9iydvad+rDchaXFtzhOnqQwgxuvvmZ+TK8oRZhC9HpRF06bU1Dk5z0M
	tsX2hRQjgJwucjFYqwQgcWE8PuWdBGYuhGT43uUtBaG+ENQLeGDE5NwvngrOgyvX
	fiHQo2Afz9jmf3Q5aggD5KYSUdpW8HnvVKQ==
X-ME-Sender: <xms:CR4CaiVxSVb1vkUW08W4l8Mn3IFpVRZ24IcoG2PcuWqF_y09T14W8g>
    <xme:CR4CamBi2s6fr4mFwD-ZCQ5Q71_v14Vf9GwUp9aOCQOxBtvt9NiSatWWOvgHliujw
    2rsXCdNcapoUi88JJzMoRTczUYt2zgwvXTA15zRCvZ_EOtESsIw2Ao>
X-ME-Received: <xmr:CR4CajwrXGyo4FcGgi2sQQKR8DvVIrpRV5-J7SClf8gBiYKkfxhAwa6axrpC7k4l8K7U3KPflux-HvFc8sUbS0PHzJ0>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefhedrtddtgdduudelieegucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucenucfjughrpefhvfevufffkffoggfgsedtkeertdertd
    dtnecuhfhrohhmpeeuohhrihhsuceuuhhrkhhovhcuoegsohhrihhssegsuhhrrdhioheq
    necuggftrfgrthhtvghrnhepudduhfevvddugffggefgkeeggfdvieejgfegkedvudetke
    ehhfdvffeugeevfedunecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghi
    lhhfrhhomhepsghorhhishessghurhdrihhopdhnsggprhgtphhtthhopeefpdhmohguvg
    epshhmthhpohhuthdprhgtphhtthhopehlihhnuhigqdgsthhrfhhssehvghgvrhdrkhgv
    rhhnvghlrdhorhhgpdhrtghpthhtohepkhgvrhhnvghlqdhtvggrmhesfhgsrdgtohhmpd
    hrtghpthhtoheprhhivghlsehsuhhrrhhivghlrdgtohhm
X-ME-Proxy: <xmx:CR4CajDUML79admXTxvVqbZfLNbeSemg_qzqsGadpZGmJMR0teCCoQ>
    <xmx:CR4Cagb0DoAWTvyX6uu03HU5L44_8pRNzFX_sIBhPifVi_q3WGJ1ew>
    <xmx:CR4CarjLtCk8_USCj2zT_AjhpiRq-8vr105ixSIjnm3-pFKh3-vF9g>
    <xmx:CR4Cai4XdfyO24UNHxgfYHZ3Lthq7egRd0tww9If3z_DjXMJh9cUgA>
    <xmx:CR4CaiqhmS0r7YxWLfp6mPXPuHxVun6QmaxR0cqVZ-EAQ4i-yjY-WJQ7>
Feedback-ID: i083147f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 11 May 2026 14:20:57 -0400 (EDT)
From: Boris Burkov <boris@bur.io>
To: linux-btrfs@vger.kernel.org,
	kernel-team@fb.com
Cc: riel@surriel.com
Subject: [PATCH v2] btrfs: always drop root->inodes lock before cond_resched()
Date: Mon, 11 May 2026 11:20:45 -0700
Message-ID: <c02edfd2e71891c095d0b70e530f41ed3d97a874.1778523510.git.boris@bur.io>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

find_first_inode() and find_first_inode_to_shrink() lock root->inodes,
then loop over them, occasionally skipping some inodes. When they skip
an inode, they attempt to share the cpu/lock with cond_resched_lock().

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
Changelog:
v2:
- apply the pattern to btrfs_find_first_inode() as well.

---
 fs/btrfs/extent_map.c | 4 +++-
 fs/btrfs/inode.c      | 4 +++-
 2 files changed, 6 insertions(+), 2 deletions(-)

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
 
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 0e72408c8612..201010ced09d 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -10540,7 +10540,9 @@ struct btrfs_inode *btrfs_find_first_inode(struct btrfs_root *root, u64 min_ino)
 			break;
 
 		from = btrfs_ino(inode) + 1;
-		cond_resched_lock(&root->inodes.xa_lock);
+		xa_unlock(&root->inodes);
+		cond_resched();
+		xa_lock(&root->inodes);
 	}
 	xa_unlock(&root->inodes);
 
-- 
2.54.0

