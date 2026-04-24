Received: from fout-a4-smtp.messagingengine.com (fout-a4-smtp.messagingengine.com [103.168.172.147])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5F483E2758
	for <linux-btrfs@vger.kernel.org>; Fri, 24 Apr 2026 20:12:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.147
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777061534; cv=none; b=CnRBNk/5g9C78WNAfGvLlV6zbxAbhymPXnnNuhILNDB6nxovq1Osfa/HDgzGZccCq+UAgSL1zs7Izbgl6WmrhHdOoY3GuFF/IaasJnPb+1JFz4kDfgf9eGX2GefpBAic5talgP3Y/FVG1UGLd1Bl/U4Gq2mj4P86fmges22EwSU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777061534; c=relaxed/simple;
	bh=rdJRKZV10lI0ts7hR5XS8Z5FzkcSrLXfLzDjr07nBeU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TexnnR23tU2OKKWC6bN2u5ll5bDbEkIX2VVe2PSkQ/lPOAQPKxSEWiyBrWGqfIB4r0A1USkf0Z8Wa4O7EJyQnRBqg1YmV6Yf04FXW3M+AEwhwu3pDGNWAsr5U3027Wc0x02843tqcY1QuOWjx4sGxUpdYpFcGWYEyRJ99O5dBLE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io; spf=pass smtp.mailfrom=bur.io; dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b=LOY2JboG; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=NyZJ47c4; arc=none smtp.client-ip=103.168.172.147
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bur.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b="LOY2JboG";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="NyZJ47c4"
Received: from phl-compute-07.internal (phl-compute-07.internal [10.202.2.47])
	by mailfout.phl.internal (Postfix) with ESMTP id 110DEEC0128;
	Fri, 24 Apr 2026 16:12:11 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-07.internal (MEProxy); Fri, 24 Apr 2026 16:12:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc:cc
	:content-transfer-encoding:content-type:content-type:date:date
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm3; t=1777061531;
	 x=1777147931; bh=WTZyvm3vpvpMmwWh4sjLkSshRbZi9FKQ6YkZ+9mUT7k=; b=
	LOY2JboGHzeeWjmBzp593b7XAcQ2RP457fDfiNsgGhuKy0jhdyEqUq8fJ0OpRFmF
	5pMnc8D+r4b6NtVi3SG3dWZkVXdT3PdTMjllQ4ERLaZ1DHjF+T24/kzyITPz1v0k
	uNgFWBqgJPr/4XWWq0sd2bcAJ3i/SY4889KdCir73CdfHxA+X1lmoK35m6RDvcQu
	SROENdiRnBxLVlxZ7vqhqfYq+WT/DQ3Q99tA7h8yfNqlDe4fpwZAJarg/6F+ptfq
	vP9cL+I56N3B6Ba7Z6JuBy9gMTGJmIf0oWAK/Fu7sA7ALnQrt6/1FiJMFUhjhiAu
	L6YZZxGfpO6O7gf+DzBk1Q==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=1777061531; x=
	1777147931; bh=WTZyvm3vpvpMmwWh4sjLkSshRbZi9FKQ6YkZ+9mUT7k=; b=N
	yZJ47c40WxvenmYazAtE5eg4LT3/flfZKdNKKwitur/nL5TytWO9MKaTZXRIksgi
	bzCUUUIR06IKejkChOM+UaSGuFN9UHqVmbfdfxYVXUmNlyt2FwRyz7U8rC9o3bxR
	zFS84PDJ5SLlmn5Gr3L7IGehOMYD94E+n/xpc/khT5SrbtEDig+AFnoLF9eGuHRT
	PKGCavzHwG92lpaqSdY10RUcna+5vvMwsYzgcdpIAEx29t/PR/vnewiHaEMm/yVw
	+xilge2aTIN5ZIilKa1VQ3bkfWeciDri42dxCe1PAyJXnJqPDom9wHk8hdyw3t96
	ECjgKioRbfMHNlTKxHMqw==
X-ME-Sender: <xms:ms7rafuXH-28fI__qkJ1IknOwnfHsgVRtarD_XYgIwlFHzWZQILQPw>
    <xme:ms7raX4vNdApFJOmbZOPGhHUnv5Wx8pKGOve-pFkRl0DnLBfM11O855Fk4pYByS-o
    XhxrAxUucenQhVW7BUUhILLScKDXeTQAOXFkYcsT7C2zf5QFibYaE3K>
X-ME-Received: <xmr:ms7raQJ19q-nsdLh12r7HabQw_VKz1sW6KeVTtBnav0YZpiGL93bIPsiB53zFO4avNYNJmdQ9Jcy6-jIOr6YjRVUcFI>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefhedrtddtgdejtdeliecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecunecujfgurhepfffhvfevuffkfhggtggugfgjsehtkeertd
    dttdejnecuhfhrohhmpeeuohhrihhsuceuuhhrkhhovhcuoegsohhrihhssegsuhhrrdhi
    oheqnecuggftrfgrthhtvghrnhepudelhfdthfetuddvtefhfedtiedtteehvddtkedvle
    dtvdevgedtuedutdeitdeinecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehm
    rghilhhfrhhomhepsghorhhishessghurhdrihhopdhnsggprhgtphhtthhopeefpdhmoh
    guvgepshhmthhpohhuthdprhgtphhtthhopehquhifvghnrhhuohdrsghtrhhfshesghhm
    gidrtghomhdprhgtphhtthhopehlihhnuhigqdgsthhrfhhssehvghgvrhdrkhgvrhhnvg
    hlrdhorhhgpdhrtghpthhtohepkhgvrhhnvghlqdhtvggrmhesfhgsrdgtohhm
X-ME-Proxy: <xmx:ms7raX4hstuksREC2ic3yQmVq8hDXk2L39qlQ_zhTbI5xF0UTYnq7w>
    <xmx:ms7raTzyeCMC3nMnNj5LOCPlQW6Apq9Vfzvw_58319SB-msqqNB1_Q>
    <xmx:ms7rabaMAiZraUVwEzgBR6BrFhTcJqByH5VLSPY5A_LBDw2V_ZmtTg>
    <xmx:ms7raVR3HHOJWFkmO0aT4IVOcd-YW32uCHCGO5ZNOVyDB_mKxXlU4w>
    <xmx:m87raaeJFBdKTFbKJ66uQyyTpIqMKJfmpji79NkR3wuL06ec_zYhoz7G>
Feedback-ID: i083147f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 24 Apr 2026 16:12:10 -0400 (EDT)
Date: Fri, 24 Apr 2026 13:11:31 -0700
From: Boris Burkov <boris@bur.io>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH v4 4/4] btrfs: cap shrink_delalloc iterations to 128M
Message-ID: <20260424201054.GA2801466@zen.localdomain>
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
> > [...]
> > > 
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

Now that I have had a good chance to try and repro, here is what I have
seen so far on my desktop x86 machine and a cloud arm machine.

x86:
a41c84ba2f51 ("btrfs: abort transaction in do_remap_reloc_trans() on failure")
  consistently done in 1 second
8099a837f487 ("btrfs: cap shrink_delalloc iterations to 128M")
  finishes, but in ~500s
ea60045d9b1b ("btrfs: reserve space for delayed_refs in delalloc")
  finishes, but in ~500s

arm:
a41c84ba2f51 ("btrfs: abort transaction in do_remap_reloc_trans() on failure")
  consistently done in ~300 seconds
ea60045d9b1b ("btrfs: reserve space for delayed_refs in delalloc")
  done in ~600s

The two inconsistencies are that I didn't see it go fast on g/027 with just
the shrink_delalloc iterations patch reverted, and I don't have a 2
second baseline on my arm setup.

So I agree that this patch series effectively breaks those tests, on x86
as well. I didn't notice the change in runtime, unfortunately, as I only
looked for success/failure.

As to the cause:
Both g/027 and g/224 are explicitly testing lots of writes to a small
filesystem.

I suspect that what is happening is what Filipe warned about with
excessive space reclaim/pinning reclaim/etc. choking the workload
due to excessive reservation. I have played around with reducing the
reservation sizes in various ways (set it back to 0, set the level
estimate to 4 as test, etc.) and the result varies from back to full
speed or a 60s run. So in my setup, at least, it looks like the
performance of g/027 is very sensitive to how much we reserve.

Would you be willing to let it run for 5-10m to see if you also
reproduce this behavior?

I will try to instrument the reservations and reclaim codepaths and see
if I can think of a nice fix to reserve "enough but not too much".

I can also try to attack the "stuck big fs under big reclaim" more
directly by trying to make reclaim less stuck-prone, rather than messing
with reservations. Though it would be quite disappointing if we
practically cannot make the reservation choices more accurate..

Thanks,
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
