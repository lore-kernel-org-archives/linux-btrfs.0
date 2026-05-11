Received: from fout-a8-smtp.messagingengine.com (fout-a8-smtp.messagingengine.com [103.168.172.151])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2159B31282F
	for <linux-btrfs@vger.kernel.org>; Mon, 11 May 2026 15:33:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.151
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778513612; cv=none; b=TehIv1dyQkutjNPw5AXJ+mA5HkSMs+itEeHhkJF7teIbp+0Uy80OgA4QNMwB07bbQfFkSuPBk4+W9OtF3/Xp/NTtIOkc/l2Nxsr3o9OEvWZA/pXn/TthkvJCZlxHjby6ZGSzAcJj/XZba5kBczprgSjZeW8qCcc4S0ZBOP1uPYo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778513612; c=relaxed/simple;
	bh=3EtU/zot0/9XqejCjttYtF9/135pjMrwEbSMlK+zcvc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MRKFAJRkCBdRxhdV+8k5hOlxeEnN1c3lUGnB9q+joF7foxpLuPKYxsHZ4XWomrODyrgUv6PTw0QOEZPGv9rjkAguGEiTqDvRUUifs4pyrONbK7B6N/Gq9Rc8uCe13wIXlKKJKqfG9oVDZg2pnNfFD5CqKkTrnv1oLdrk9b6gboE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io; spf=pass smtp.mailfrom=bur.io; dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b=BZHneHlX; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=dvi9c51u; arc=none smtp.client-ip=103.168.172.151
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bur.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b="BZHneHlX";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="dvi9c51u"
Received: from phl-compute-03.internal (phl-compute-03.internal [10.202.2.43])
	by mailfout.phl.internal (Postfix) with ESMTP id 60361EC0100;
	Mon, 11 May 2026 11:33:30 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-03.internal (MEProxy); Mon, 11 May 2026 11:33:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc:cc
	:content-transfer-encoding:content-type:content-type:date:date
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm1; t=1778513610;
	 x=1778600010; bh=CvkccEYxIo+1h0QjEj1IqD3q1WH5Tv8pMJaxmwd7CZs=; b=
	BZHneHlXAfG0gr3wNW/OJOeClADea99BX3i5orA+YZCjiSaWmp22VRxl2sYt/Vca
	WL55WBhnw6/1T5yW8AIhKsXviM4vrsO4Vw0RlxGY/16CtxgGEJeP+xgxQmUixHm+
	84q8vOs5Ye56MZgF8xZpm7HZfKG0IReYLE0+xjlhGY/tnKkUDreRZHGuxRfJddIF
	X7Lvpyb0d0cMppNJkD1aO6Twb7Mp0FUJA0OHBc8LoPIqRd0IttqvJOR8fm8V0hVR
	dJtB4qEgOJjpimk7BInrsoXTFYEUViUWQ51QoSSWTDXq2j5u3eEqEWX6nT1xfKqx
	sMuZ8gz57+iWNEj7ODdYHg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1778513610; x=
	1778600010; bh=CvkccEYxIo+1h0QjEj1IqD3q1WH5Tv8pMJaxmwd7CZs=; b=d
	vi9c51uf54SZ7f0/6p7c+LjiYrs6t3ChQUfTqpuKDeO04yvXLfpmrIQqBn++eEDF
	0fKVEFYr+oLU0pcUb9Xw2u6ByOWMPSEe5xnPXMACoy6x4fqDferejNkviBaJpFdB
	YzNpguOuGUo/2u6VM39/Ah1WYEIUZjc1PcVpRd7jSYpAoVPzgyAFgj4cqTKErsde
	qFw6iTy66svONvnI/OcgEWRD8vi6NJbPiUazwyzOBOozlZ5Mu0Yxw9Ew8vEVhwOi
	0a5/yzL+jH6v5QanpbSIey1XOws8aKvil7dQwFrqZMV/1TwP4ODoO0a9gZ3fQkAR
	u7IHv8IVOhGgKzSwuLpyQ==
X-ME-Sender: <xms:yvYBao5dUs-h6aUmMd52qfG_ye3ir3qCHp2O83VQ2ohiWzz43xT-5A>
    <xme:yvYBag4qNgyavsRDSVqgBpVnOStJKazJnEbPhF0CQeWiJpKK02d5vEVaWtZsSXrUK
    XiYl4HQlZ8kicyGUkTLO4UoWJNkwyXU3qoWey4SZjHR5DemwqjbwnSO>
X-ME-Received: <xmr:yvYBaseJqjOmwV40qkK-UiRg-pyuGMj708drwuBOxKy36rOpV-pt5rPfEfAUL4o7a1xdA1rHUHn8yF9pL0h-rlK1RRM>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefhedrtddtgdduudelfedtucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepfffhvfevuffkfhggtggugfgjsehtkeertddttdejnecuhfhrohhmpeeuohhrihhs
    uceuuhhrkhhovhcuoegsohhrihhssegsuhhrrdhioheqnecuggftrfgrthhtvghrnhepud
    elhfdthfetuddvtefhfedtiedtteehvddtkedvledtvdevgedtuedutdeitdeinecuvehl
    uhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepsghorhhishessg
    hurhdrihhopdhnsggprhgtphhtthhopeegpdhmohguvgepshhmthhpohhuthdprhgtphht
    thhopehfughmrghnrghnrgeskhgvrhhnvghlrdhorhhgpdhrtghpthhtoheplhhinhhugi
    dqsghtrhhfshesvhhgvghrrdhkvghrnhgvlhdrohhrghdprhgtphhtthhopehkvghrnhgv
    lhdqthgvrghmsehfsgdrtghomhdprhgtphhtthhopehrihgvlhesshhurhhrihgvlhdrtg
    homh
X-ME-Proxy: <xmx:yvYBasCB-aVqSbq1ykTy-YzxRnxUs88Eg9VF7qfuCxIgVgZRohT1Zg>
    <xmx:yvYBan_0D6B_06M1ojO8QIC3dlVDCFdg1nc2I3pqfi0-HIvzPGwWaQ>
    <xmx:yvYBavKBH1KomIbxXzgK4clGRxgLh6KeMrCbthYb-xhYl5TcLaXuRw>
    <xmx:yvYBaojTLHWGiMmc7I0AvN4O1zBK3c0XzUmZbo3zUGqngpPHOHhJdw>
    <xmx:yvYBarwZVBqzDU7U4zXiMAjQGrC0fKOkQGyRLoGKuoqagNQuG3tRieci>
Feedback-ID: i083147f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 11 May 2026 11:33:29 -0400 (EDT)
Date: Mon, 11 May 2026 08:33:23 -0700
From: Boris Burkov <boris@bur.io>
To: Filipe Manana <fdmanana@kernel.org>
Cc: linux-btrfs@vger.kernel.org, kernel-team@fb.com, riel@surriel.com
Subject: Re: [PATCH] btrfs: always drop root->inodes lock in
 find_first_inode_to_shrink()
Message-ID: <20260511153323.GA534007@zen.localdomain>
References: <2c932910eb227ef5e9829fdc86d10a11e3170a99.1778435133.git.boris@bur.io>
 <CAL3q7H7esm_4ATxg=VXqY9HtMFZZZ-Km24SEQJjNK1-o9EunMg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAL3q7H7esm_4ATxg=VXqY9HtMFZZZ-Km24SEQJjNK1-o9EunMg@mail.gmail.com>

On Mon, May 11, 2026 at 01:37:05PM +0100, Filipe Manana wrote:
> On Sun, May 10, 2026 at 6:46 PM Boris Burkov <boris@bur.io> wrote:
> >
> > find_first_inode_to_shrink() locks root->inodes, then loops over them,
> > skipping those where it can't lock the extent_tree, or which have no
> > extent_maps or it can't igrab. When it doesn't pick an inode, it
> > attempts to share the cpu/lock with cond_resched_lock().
> >
> > However, that has a subtle problem associated with it.
> > cond_resched_lock() only drops the lock if it needs to actually call
> > schedule(). With CONFIG_PREEMPT_NONE, this means the full timeslice as
> > detected at ticks. With 8+ cpus and default tunables, this is 2.8ms. So
> > regardless of HZ, we will run for at least 2.8ms in this loop without
> > dropping the lock, assuming it finds no suitable inodes. If HZ is
> > small enough, it might be even worse as the tick granularity becomes
> > bigger than the timeslice.
> >
> > The knock-on effect of this is that callers to
> > btrfs_del_inode_from_root() like kswapd trying to shrink the inode slab
> > or userspace threads calling evict() will spin on xa_lock(&root->inodes)
> > for 2.8ms, so the extent map shrinker dominates the lock even though
> > ostensibly it is intending to share it. This produces memory pressure as
> > there is only one kswapd and it runs sequentially so it can get stuck in
> > the inode slab shrinking.
> >
> > To fix it, simply replace cond_resched_lock() with an open coded variant
> > which unconditionally does unlock/lock around cond_resched. Sharing the
> > lock is decoupled from sharing the cpu, and all the users of the lock
> > now share it fairly.
> >
> > I was able to reproduce this on test systems by producing a lot of empty
> > files (to make a big root->inodes xarray), then producing memory
> > pressure by reading large files larger than ram, triggering kswapd and
> > the extent_map shrinker. The lock contention is visible with perf or
> > lockstat. This patch also relieved a user-apparent bottleneck on a
> > production system from the original report.
> >
> > Tested-by: Rik van Riel <riel@surriel.com>
> > Signed-off-by: Boris Burkov <boris@bur.io>
> > ---
> >  fs/btrfs/extent_map.c | 4 +++-
> >  1 file changed, 3 insertions(+), 1 deletion(-)
> >
> > diff --git a/fs/btrfs/extent_map.c b/fs/btrfs/extent_map.c
> > index 514d7b59cbe5..fce9c5cc0122 100644
> > --- a/fs/btrfs/extent_map.c
> > +++ b/fs/btrfs/extent_map.c
> > @@ -1246,7 +1246,9 @@ static struct btrfs_inode *find_first_inode_to_shrink(struct btrfs_root *root,
> >                 write_unlock(&tree->lock);
> >  next:
> >                 from = btrfs_ino(inode) + 1;
> > -               cond_resched_lock(&root->inodes.xa_lock);
> > +               xa_unlock(&root->inodes);
> > +               cond_resched();
> > +               xa_lock(&root->inodes);
> 
> We call cond_resched_lock() in other places, including
> btrfs_find_first_inode(), which uses the same lock.
> Why do that only here?
> 
> Thanks.

Good point. I was just narrowly following the profile and what I managed
to reproduce directly.

I did consider whether it made sense to change cond_resched_lock()
itself but decided to do just this to try out the idea to start.

I will definitely change btrfs_find_first_inode() in v2. Would you like
me to also get rid of the other uses of cond_resched_lock() from btrfs,
assuming it makes similar sense at each callsite?

> 
> 
> >         }
> >         xa_unlock(&root->inodes);
> >
> > --
> > 2.54.0
> >
> >
