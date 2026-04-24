Received: from fhigh-b2-smtp.messagingengine.com (fhigh-b2-smtp.messagingengine.com [202.12.124.153])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEE8630B501
	for <linux-btrfs@vger.kernel.org>; Fri, 24 Apr 2026 15:27:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.153
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777044434; cv=none; b=Yg7HHzU5X+PLXOq2Byyl1kHxXw6EdVaVOlQgir8F/E3bcFOs1jtFnmsJS/3rcHFPKNWFiih4x0aEomqEJqaTuwtILRLEblODcoE9ed6lAgL+70WX+aJhs2+e8fRAi4jyt+4IzRDZ4Zl+2tL9Xxec9Y2xqY2Wo4bNIwKFvMBCZYc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777044434; c=relaxed/simple;
	bh=HrYpvdW0bE+cKSwY/yMhvBvKHlnS68AvkQQv7vS9R1o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FdlN4VkbmdYcJfWzMkBBvWPbLmCAuPyFS9ShmQ/WQ9/UyVltW8n0NL9DbSJybR2sU4AcS5xg39fwY21MInaX0zGYupi8y0RoQhvDKMb9rvuAmNcLHvwfiuJ6WFoAcoTu2W0FXjQHSMzgq7/9pxtUIhjpSXHomV7MI9qpx2C6GlQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io; spf=pass smtp.mailfrom=bur.io; dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b=I1I1mcWq; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=ifM6Wm5K; arc=none smtp.client-ip=202.12.124.153
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bur.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b="I1I1mcWq";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="ifM6Wm5K"
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailfhigh.stl.internal (Postfix) with ESMTP id C1FE97A026B;
	Fri, 24 Apr 2026 11:27:11 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-06.internal (MEProxy); Fri, 24 Apr 2026 11:27:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc:cc
	:content-transfer-encoding:content-type:content-type:date:date
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm3; t=1777044431;
	 x=1777130831; bh=xZEDDT+qx/l0C3oKKpJoqz+LN0TvQ+jZfPwPx4gGhtM=; b=
	I1I1mcWqlW1TF2sC+OlR/AC/U08b5RKPRY0x3vlnJ+4phTXs/v5OOSLyQ82vrRmn
	NuLIpPFTjcRwwxAoAzH55n2FohLUGRlFeoLPpQUdP0bKUTKZRDsPdZTOMad5JbHQ
	LZywEviyN2cwbOdgB0ILZMQ0daufjfyNknlo/tl5lfdXZughY9r6hd8QU1yypqML
	8hzAxV+pnE3+vXxuuWMpDLYbuT2Yzz6JPUYN2zz5IvbTSPt+EXingdekLwQplgU9
	k6jpV9yWZ4jpY9ESefTozu5MLywNmLP5S1geog06i9fIKc9ZF4Aw5aD8AAPKgcLW
	BVr4i4Z3RME7sSjfccI4MA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=1777044431; x=
	1777130831; bh=xZEDDT+qx/l0C3oKKpJoqz+LN0TvQ+jZfPwPx4gGhtM=; b=i
	fM6Wm5K33HeBSZ4rSbQvlLK0AoTIumUHRUy/g7sPfXgTws1oUJZ+F+PLydc16yFc
	M1KFOs+7xhIbSAUqXPCprArUIPddPpz8hO6aoTDFnD70lUr48ztCxq9WkQTETCAO
	ezoiUQrW4GC/uKCCfjAVtgmfGH8yMX1pdyPraBIGPy7UqOrZTdJjo9EV7LR5H9/T
	sNKAEiXgTsQH6arZDmPPHRdvb7xi53qArVcbLPmJNaR3LXpb6zULkZ7f6ZMIAeim
	H3cOBtJFaUv5+7w8T9T8qTgPJNkPdLgMj4efggLLZQkd6M5mH4F6e1/vyih8Ufjp
	Kz/9LX5JuDTZS73XmGjtQ==
X-ME-Sender: <xms:z4vraT8hoOyFZ6VFHM2uYqbAuuIUVAzaFcCVXCl3WM6kF_sdCLAPRQ>
    <xme:z4vraXK58pdMIJaLSkbwJpzAxaNQRgfFLVUIi0M1FOLc--N3t5pUplhrg_vgV-Imi
    bt81LStwc1dNVeyNcm5t67hbRJJBsKT_vGN5bF4djrCdTZ0boI8YPo>
X-ME-Received: <xmr:z4vraeZpi8oWooZeUUKq7ZqT14YtLGoP-laraDvxUMv1nGeQltGIr5pFzW7Bdu1m2miFuYquABi4ay0_wdKsnwdfCo8>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefhedrtddtgdejtdeflecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecunecujfgurhepfffhvfevuffkfhggtggugfgjsehtkeertd
    dttdejnecuhfhrohhmpeeuohhrihhsuceuuhhrkhhovhcuoegsohhrihhssegsuhhrrdhi
    oheqnecuggftrfgrthhtvghrnhepudelhfdthfetuddvtefhfedtiedtteehvddtkedvle
    dtvdevgedtuedutdeitdeinecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehm
    rghilhhfrhhomhepsghorhhishessghurhdrihhopdhnsggprhgtphhtthhopeefpdhmoh
    guvgepshhmthhpohhuthdprhgtphhtthhopehquhifvghnrhhuohdrsghtrhhfshesghhm
    gidrtghomhdprhgtphhtthhopehlihhnuhigqdgsthhrfhhssehvghgvrhdrkhgvrhhnvg
    hlrdhorhhgpdhrtghpthhtohepkhgvrhhnvghlqdhtvggrmhesfhgsrdgtohhm
X-ME-Proxy: <xmx:z4vraZI-U3u0Xn3eOB4VUuoTgAE1AHKNI9QMMlb2j6nt8-51fptWgg>
    <xmx:z4vracBLogHl4c4A63muEf1m8yUVLh6QlTKrP7R-zv0l252dCRHrxw>
    <xmx:z4vraepBuuF64KpCOxKQUgHia2v0vESwkCKTNfHErXPYQnh67L88Bw>
    <xmx:z4vraXhWEZFlc7oGLiJIVaU9tvRAtxGstnK6yYRwu7P2eB5QfmLmoA>
    <xmx:z4vraZsCX7xay9Qtwd2vrtw2gfdw7pGaNoPLB0j2P-Q-Bbz1RBbBmQS4>
Feedback-ID: i083147f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 24 Apr 2026 11:27:10 -0400 (EDT)
Date: Fri, 24 Apr 2026 08:26:32 -0700
From: Boris Burkov <boris@bur.io>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH v4 4/4] btrfs: cap shrink_delalloc iterations to 128M
Message-ID: <20260424152632.GA2637332@zen.localdomain>
References: <cover.1775756789.git.boris@bur.io>
 <b990d13d17d8f6eeb341457801fdaabdf123f8e3.1775756790.git.boris@bur.io>
 <54030bf6-56a5-4633-9bc2-0008ca43191e@gmx.com>
 <d916e8e3-0c25-4540-b829-a13ef058c762@gmx.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <d916e8e3-0c25-4540-b829-a13ef058c762@gmx.com>

On Fri, Apr 24, 2026 at 07:37:38PM +0930, Qu Wenruo wrote:
> 
> 
> 在 2026/4/24 16:08, Qu Wenruo 写道:
> > 
> > 
> > 在 2026/4/10 03:18, Boris Burkov 写道:
> > [...] > > > 
> > > This means iterating over to_reclaim by 128MiB at a time until it is
> > > drained or we satisfy a ticket, rather than trying 3 times to do the
> > > whole thing.
> > > 
> > > Reviewed-by: Filipe Manana <fdmanana@suse.com>
> > > Signed-off-by: Boris Burkov <boris@bur.io>
> > 
> > Hi Boris,
> > 
> > I'm testing the latest for-next base as the baseline for the incoming
> > huge folio support.
> > 
> > On arm64 64K page size, 4K fs block size, I'm seeing a very weird
> > behavior on generic/027.
> > On 7.0-rc7, the test case takes less than 5 seconds and passes as expected.
> > 
> > But on for-next it never finished, furthermore there is always a kworker
> > taking a full core, deadlooping inside
> > btrfs_async_reclaim_metadata_space(), and you can not unmount the fs.
> > 
> > Here is the "echo l > /proc/sysrq-trigger" stack dump for the involved
> > btrfs kworker:
> > 
> > [ 6616.093728] CPU: 0 UID: 0 PID: 501715 Comm: kworker/u33:0 Not tainted
> > 7.0.0-rc7-custom-64k+ #9 PREEMPT(full)
> > [ 6616.093732] Hardware name: QEMU KVM Virtual Machine, BIOS unknown
> > 2/2/2022
> > [ 6616.093734] Workqueue: events_unbound
> > btrfs_async_reclaim_metadata_space [btrfs]
> > [ 6616.093849] pstate: 63400005 (nZCv daif +PAN -UAO +TCO +DIT -SSBS
> > BTYPE=--)
> > [ 6616.093852] pc : btrfs_start_delalloc_roots+0xf0/0x268 [btrfs]
> > [ 6616.093923] lr : btrfs_start_delalloc_roots+0x88/0x268 [btrfs]
> > [ 6616.093987] sp : ffff80008af0fbd0
> > [...]
> > [ 6616.094008] Call trace:
> > [ 6616.094009]  btrfs_start_delalloc_roots+0xf0/0x268 [btrfs] (P)
> > [ 6616.094073]  flush_space+0x3d4/0x6b0 [btrfs]
> > [ 6616.094138]  do_async_reclaim_metadata_space+0x88/0x1d8 [btrfs]
> > [ 6616.094201]  btrfs_async_reclaim_metadata_space+0x50/0x80 [btrfs]
> > [ 6616.094263]  process_one_work+0x174/0x540
> > [ 6616.094277]  worker_thread+0x1a0/0x318
> > [ 6616.094279]  kthread+0x140/0x158
> > [ 6616.094285]  ret_from_fork+0x10/0x20
> > 
> > So it's a regression, and bisection points to this patch.
> > 
> > And I tried the following steps to further confirm it's caused by this
> > commit:
> > 
> > - The test passes just before the commit
> >    The previous commit is "btrfs: make inode->outstanding_extents a u64".
> > 
> > - The test failed at that commit
> >    The test case never finish and one kworker dead looping.
> > 
> > - The test case pass at for-next with this commit reverted
> >    The test case finishes in seconds as usual.
> 
> Furthermore, even with this particular patch *reverted*, I'm still seeing
> generic/224 hitting the same problem.
> 
> Currently I'm testing at the commit before the whole series, which is
> "btrfs: abort transaction in do_remap_reloc_trans() on failure", and no
> generic/224 hang nor 100% kworker CPU usage.
> 
> Thus I'm afraid the whole series may be involved.
> 
> Thanks,
> Qu
> 

Thank you very much for the thorough debugging, and sorry for the
disruption. I suspect Sun's idea will be at least one bug with the async
reclaim pacing patch. I think I need to go away from the infinite loop
loop entirely, or at least make sure it has other escape hatches.

However, I am really struggling to conceptually see how changing the
reservation sizing at delalloc or fussing with the types of
outstanding_extents would make us spin forever in async metadata
reclaim. Are you 100% sure that the hang reproduces with this series
minus 'btrfs: cap shrink_delalloc iterations to 128M'?

I will try to hunt down an arm machine and reproduce myself. And keep
thinking on what could be wrong with the new delalloc rsv numbers to make
async reclaim loop forever.

Thanks again,
Boris

> > 
> > Do you have any clue on what's going wrong? I guess it's pretty hard to
> > hit on x86_64.
> > 
> > I have a local btrfs branch with huge folios support, with that it's
> > pretty easy to hit similar problems on x86_64, but without that branch,
> > no hit is observed so far on x86_64.
> > 
> > Thanks,
> > Qu
> > 
> > > ---
> > >   fs/btrfs/space-info.c | 31 ++++++++++++++++++++-----------
> > >   1 file changed, 20 insertions(+), 11 deletions(-)
> > > 
> > > diff --git a/fs/btrfs/space-info.c b/fs/btrfs/space-info.c
> > > index f0436eea1544..e931deb3d013 100644
> > > --- a/fs/btrfs/space-info.c
> > > +++ b/fs/btrfs/space-info.c
> > > @@ -725,9 +725,8 @@ static void shrink_delalloc(struct
> > > btrfs_space_info *space_info,
> > >       struct btrfs_trans_handle *trans;
> > >       u64 delalloc_bytes;
> > >       u64 ordered_bytes;
> > > -    u64 items;
> > >       long time_left;
> > > -    int loops;
> > > +    u64 orig_tickets_id;
> > >       delalloc_bytes = percpu_counter_sum_positive(&fs_info-
> > > >delalloc_bytes);
> > >       ordered_bytes = percpu_counter_sum_positive(&fs_info-
> > > >ordered_bytes);
> > > @@ -735,9 +734,7 @@ static void shrink_delalloc(struct
> > > btrfs_space_info *space_info,
> > >           return;
> > >       /* Calc the number of the pages we need flush for space
> > > reservation */
> > > -    if (to_reclaim == U64_MAX) {
> > > -        items = U64_MAX;
> > > -    } else {
> > > +    if (to_reclaim != U64_MAX) {
> > >           /*
> > >            * to_reclaim is set to however much metadata we need to
> > >            * reclaim, but reclaiming that much data doesn't really track
> > > @@ -751,7 +748,6 @@ static void shrink_delalloc(struct
> > > btrfs_space_info *space_info,
> > >            * aggressive.
> > >            */
> > >           to_reclaim = max(to_reclaim, delalloc_bytes >> 3);
> > > -        items = calc_reclaim_items_nr(fs_info, to_reclaim) * 2;
> > >       }
> > >       trans = current->journal_info;
> > > @@ -764,10 +760,14 @@ static void shrink_delalloc(struct
> > > btrfs_space_info *space_info,
> > >       if (ordered_bytes > delalloc_bytes && !for_preempt)
> > >           wait_ordered = true;
> > > -    loops = 0;
> > > -    while ((delalloc_bytes || ordered_bytes) && loops < 3) {
> > > -        u64 temp = min(delalloc_bytes, to_reclaim) >> PAGE_SHIFT;
> > > -        long nr_pages = min_t(u64, temp, LONG_MAX);
> > > +    spin_lock(&space_info->lock);
> > > +    orig_tickets_id = space_info->tickets_id;
> > > +    spin_unlock(&space_info->lock);
> > > +
> > > +    while ((delalloc_bytes || ordered_bytes) && to_reclaim) {
> > > +        u64 iter_reclaim = min_t(u64, to_reclaim, SZ_128M);
> > > +        long nr_pages = min_t(u64, delalloc_bytes, iter_reclaim) >>
> > > PAGE_SHIFT;
> > > +        u64 items = calc_reclaim_items_nr(fs_info, iter_reclaim) * 2;
> > >           int async_pages;
> > >           btrfs_start_delalloc_roots(fs_info, nr_pages, true);
> > > @@ -811,7 +811,7 @@ static void shrink_delalloc(struct
> > > btrfs_space_info *space_info,
> > >                  atomic_read(&fs_info->async_delalloc_pages) <=
> > >                  async_pages);
> > >   skip_async:
> > > -        loops++;
> > > +        to_reclaim -= iter_reclaim;
> > >           if (wait_ordered && !trans) {
> > >               btrfs_wait_ordered_roots(fs_info, items, NULL);
> > >           } else {
> > > @@ -834,6 +834,15 @@ static void shrink_delalloc(struct
> > > btrfs_space_info *space_info,
> > >               spin_unlock(&space_info->lock);
> > >               break;
> > >           }
> > > +        /*
> > > +         * If a ticket was satisfied since we started, break out
> > > +         * so the async reclaim state machine can process delayed
> > > +         * refs before we flush more delalloc.
> > > +         */
> > > +        if (space_info->tickets_id != orig_tickets_id) {
> > > +            spin_unlock(&space_info->lock);
> > > +            break;
> > > +        }
> > >           spin_unlock(&space_info->lock);
> > >           delalloc_bytes = percpu_counter_sum_positive(
> > 
> > 
> 
