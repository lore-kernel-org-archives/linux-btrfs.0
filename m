Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0378F407562
	for <linux-btrfs@vger.kernel.org>; Mon, 11 May 2026 16:26:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778516812; cv=none; b=DymnmmvnqZzCRFNapqtCAN5Koo+i/5I2g9m4LAObZWFxqaOWTdahFPIPnHPptzGblyRL9VW4zNf7h6yTAh1ax0JelKN2j1Dn9LgrRfa1pV29zswNLA9DKx1jTsxL/Rs8jJvm+lFIQZhxqxIOTFPR6lZl/aIx7GRG3ScXjK7gspI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778516812; c=relaxed/simple;
	bh=0wjJns6VtNjBUiRGhG7TJTrHZd3ADhl4bEDcb7Qe+Bo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=kNffhYa6u1QQz2remChqaRB1e7Z3EZLY4iDQQqPOhp2+qznef7nGWGLj0HTUmR/ToPvMoC/X5ZiOWOaRadqm8yxvjSMaWWaOnf2ppFh+EpM5j8gUBd656Hddhm4S1oT4d9rwTMB+fpms1TXcVEHeRITApfCybITg70wBiH9UETY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ys+n0w/J; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ys+n0w/J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A999BC2BCF6
	for <linux-btrfs@vger.kernel.org>; Mon, 11 May 2026 16:26:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778516811;
	bh=0wjJns6VtNjBUiRGhG7TJTrHZd3ADhl4bEDcb7Qe+Bo=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=Ys+n0w/J9ysEVhuuiUEEwiybosgJ+y3NQkLOijXiEkkKg/T84B4r1Wgz6/PBx26hl
	 LBFtWGxMI/pFfaSWVhT/IihKUg+hC4BN8MyBy1H7DtKfWArcsVPnMcOEMho7ZJQ++0
	 o4h9L1sD8rvNZGO8PHP2kdCz0/p5HTKqEMUtsTlTa7jeEd51cAltUKdagwXg6n6qGQ
	 k9TxuGo0ufHRfCkGM8w/Sw6IB5lzvfawilgdk5z1G/ptcxK7GR5NNnJc07oOUrjDNW
	 USuHNGB5jnz2Px9B1FXA71/zcfDbt8NA/e2yp/5kl42GH07e8Fw/T0zCWPpluMKwMC
	 l+cSXoaHoSmzw==
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-b8f9568e074so695809966b.0
        for <linux-btrfs@vger.kernel.org>; Mon, 11 May 2026 09:26:51 -0700 (PDT)
X-Gm-Message-State: AOJu0YwDxArOZ6rlsLFEXrLp9x9WLlDAxmX6R/ckeRSdQzhw48dO5eG3
	zCCm7PbbiRP5FTWP23LEkankqj3n8YM9m+nVAU8AlkmqaazD8WdLDDXQhQQ/RtU4rF8p/3xDSjB
	9xYjUim44B8YoTqvIQsIGHgzbgvGzxGQ=
X-Received: by 2002:a17:906:7944:b0:bc4:c901:20fc with SMTP id
 a640c23a62f3a-bc56e5fea09mr1344523166b.30.1778516810233; Mon, 11 May 2026
 09:26:50 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <2c932910eb227ef5e9829fdc86d10a11e3170a99.1778435133.git.boris@bur.io>
 <CAL3q7H7esm_4ATxg=VXqY9HtMFZZZ-Km24SEQJjNK1-o9EunMg@mail.gmail.com> <20260511153323.GA534007@zen.localdomain>
In-Reply-To: <20260511153323.GA534007@zen.localdomain>
From: Filipe Manana <fdmanana@kernel.org>
Date: Mon, 11 May 2026 17:26:12 +0100
X-Gmail-Original-Message-ID: <CAL3q7H5EEoxcAddBN1YAnkA88LXDVnC1u1=rZnzjfhKO-nQ2YQ@mail.gmail.com>
X-Gm-Features: AVHnY4JuKP105ZySxfW5NrEexnZAn2RGY06soE0IxUBBQyYCch_rHiupWDlTD80
Message-ID: <CAL3q7H5EEoxcAddBN1YAnkA88LXDVnC1u1=rZnzjfhKO-nQ2YQ@mail.gmail.com>
Subject: Re: [PATCH] btrfs: always drop root->inodes lock in find_first_inode_to_shrink()
To: Boris Burkov <boris@bur.io>
Cc: linux-btrfs@vger.kernel.org, kernel-team@fb.com, riel@surriel.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, May 11, 2026 at 4:33=E2=80=AFPM Boris Burkov <boris@bur.io> wrote:
>
> On Mon, May 11, 2026 at 01:37:05PM +0100, Filipe Manana wrote:
> > On Sun, May 10, 2026 at 6:46=E2=80=AFPM Boris Burkov <boris@bur.io> wro=
te:
> > >
> > > find_first_inode_to_shrink() locks root->inodes, then loops over them=
,
> > > skipping those where it can't lock the extent_tree, or which have no
> > > extent_maps or it can't igrab. When it doesn't pick an inode, it
> > > attempts to share the cpu/lock with cond_resched_lock().
> > >
> > > However, that has a subtle problem associated with it.
> > > cond_resched_lock() only drops the lock if it needs to actually call
> > > schedule(). With CONFIG_PREEMPT_NONE, this means the full timeslice a=
s
> > > detected at ticks. With 8+ cpus and default tunables, this is 2.8ms. =
So
> > > regardless of HZ, we will run for at least 2.8ms in this loop without
> > > dropping the lock, assuming it finds no suitable inodes. If HZ is
> > > small enough, it might be even worse as the tick granularity becomes
> > > bigger than the timeslice.
> > >
> > > The knock-on effect of this is that callers to
> > > btrfs_del_inode_from_root() like kswapd trying to shrink the inode sl=
ab
> > > or userspace threads calling evict() will spin on xa_lock(&root->inod=
es)
> > > for 2.8ms, so the extent map shrinker dominates the lock even though
> > > ostensibly it is intending to share it. This produces memory pressure=
 as
> > > there is only one kswapd and it runs sequentially so it can get stuck=
 in
> > > the inode slab shrinking.
> > >
> > > To fix it, simply replace cond_resched_lock() with an open coded vari=
ant
> > > which unconditionally does unlock/lock around cond_resched. Sharing t=
he
> > > lock is decoupled from sharing the cpu, and all the users of the lock
> > > now share it fairly.
> > >
> > > I was able to reproduce this on test systems by producing a lot of em=
pty
> > > files (to make a big root->inodes xarray), then producing memory
> > > pressure by reading large files larger than ram, triggering kswapd an=
d
> > > the extent_map shrinker. The lock contention is visible with perf or
> > > lockstat. This patch also relieved a user-apparent bottleneck on a
> > > production system from the original report.
> > >
> > > Tested-by: Rik van Riel <riel@surriel.com>
> > > Signed-off-by: Boris Burkov <boris@bur.io>
> > > ---
> > >  fs/btrfs/extent_map.c | 4 +++-
> > >  1 file changed, 3 insertions(+), 1 deletion(-)
> > >
> > > diff --git a/fs/btrfs/extent_map.c b/fs/btrfs/extent_map.c
> > > index 514d7b59cbe5..fce9c5cc0122 100644
> > > --- a/fs/btrfs/extent_map.c
> > > +++ b/fs/btrfs/extent_map.c
> > > @@ -1246,7 +1246,9 @@ static struct btrfs_inode *find_first_inode_to_=
shrink(struct btrfs_root *root,
> > >                 write_unlock(&tree->lock);
> > >  next:
> > >                 from =3D btrfs_ino(inode) + 1;
> > > -               cond_resched_lock(&root->inodes.xa_lock);
> > > +               xa_unlock(&root->inodes);
> > > +               cond_resched();
> > > +               xa_lock(&root->inodes);
> >
> > We call cond_resched_lock() in other places, including
> > btrfs_find_first_inode(), which uses the same lock.
> > Why do that only here?
> >
> > Thanks.
>
> Good point. I was just narrowly following the profile and what I managed
> to reproduce directly.
>
> I did consider whether it made sense to change cond_resched_lock()
> itself but decided to do just this to try out the idea to start.
>
> I will definitely change btrfs_find_first_inode() in v2. Would you like
> me to also get rid of the other uses of cond_resched_lock() from btrfs,
> assuming it makes similar sense at each callsite?

I think this patch should only address the lock root->inodes.xa_lock
(all the places that call cond_resched_lock() for it).
And then other patches for other locks.

Thanks.

>
> >
> >
> > >         }
> > >         xa_unlock(&root->inodes);
> > >
> > > --
> > > 2.54.0
> > >
> > >
