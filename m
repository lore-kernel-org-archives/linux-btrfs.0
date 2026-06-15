Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E9EB40FDB6
	for <linux-btrfs@vger.kernel.org>; Mon, 15 Jun 2026 16:57:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781542638; cv=none; b=HOyZen+ZLETTbZcYiWu/NqdcctEpm/6RsY4ZTJPDn2Z/dQIoqi605JbllNRJwp4bG5vVJObtbReUEA+AyuJoAxxv2329wE3VA+yD1BpdeTYQHtZXJ28CTBP45gvvEZyMjLcVCOihDV+qqv4tvRkzEc0e6JnoOaXf2Os7An9qoGA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781542638; c=relaxed/simple;
	bh=1bU9lPidoVYCsU5J85c/IaFiIRtqYuXqRryDSFrx9jg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=YElTWXEvqvxG+nP9E3hrw1trWppZN/zHswfRPc/QvDwx53gmz/56YJt3+yNLAjIbdgvET9QgNiheslFRSrY6lWylrbtsd5F+zh9tiWIV//KEYr14U21E1/edTyOl5X4CKW8sU3UGk/eOhZ4Gj0wMyLSsjSArEG3RlizJL41LE0U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BWN8im6E; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BWN8im6E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D7D11F0157D
	for <linux-btrfs@vger.kernel.org>; Mon, 15 Jun 2026 16:57:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781542636;
	bh=uuDBdLO21OY62ldGkdBAFAzppEmSdA1dZmltYVkG0p0=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=BWN8im6Ey+HNwEQvlOVWwCvoWga5c5MnkPOvN19vdH28IH9U5sm42HDILF8f1ioMR
	 v+cblay7w65v5gcanQhR7hOM0mn27SBFIz5+/XwlCPzgGGhEnFRjwkbxUgH+SrJgiJ
	 nXBJAVbyyBuMRDJawBTv91iDRKvRFPiEry33kMfLxzNNgyjoSf0BcoQrwkNCJ8tawq
	 uBSfT3gniiP3N87nahueqQfqdH69CWRpfcPIVbz4upbMnMk+cy2/f77iFHoUduwEKW
	 XT90bk8tx26kgpVAnCDWLKnxwkAnjRssV33xOYiVQKq39u8jy0Ty6zsjUrR9ZMZf3f
	 nOXZPjr8uozAQ==
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-bec449cf976so448782566b.2
        for <linux-btrfs@vger.kernel.org>; Mon, 15 Jun 2026 09:57:16 -0700 (PDT)
X-Gm-Message-State: AOJu0Ywo+mp7kk8SHC+xdehhqh0Z1pAksTxpnD70egikjScB1PGSkN9Z
	tKlQmvaT2pKF6wMsPy+QCZ8aWf+OGPSIULXO6FyIaTf5oooIWe7POinGYoCIQPfprMptjsyU+WU
	Y6eTPMyAe4OiECVyn9NO8pkuS1hJ6dF8=
X-Received: by 2002:a17:907:e917:b0:bfe:eda3:f8a1 with SMTP id
 a640c23a62f3a-bfeeda3fbd0mr572508466b.53.1781542634854; Mon, 15 Jun 2026
 09:57:14 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <1ebca8b7936fb1191b03071f81faae0424d9ee93.1781540038.git.boris@bur.io>
 <CAL3q7H4R6M9GAJYEWVBiu-ZQxCgj22QdDeRJNA1Dt6j6EiCnaA@mail.gmail.com> <20260615165159.GA1594826@zen.localdomain>
In-Reply-To: <20260615165159.GA1594826@zen.localdomain>
From: Filipe Manana <fdmanana@kernel.org>
Date: Mon, 15 Jun 2026 17:56:37 +0100
X-Gmail-Original-Message-ID: <CAL3q7H6a+d=GaC1W5u42JXkhrnVWJyjWg4cL0kf-aWdeFcAK_g@mail.gmail.com>
X-Gm-Features: AVVi8CcigfMvYEdnPN0W2Rc9nHTKZYxstErBmX4TO4z1JfCzEdduTyLEpytMjAQ
Message-ID: <CAL3q7H6a+d=GaC1W5u42JXkhrnVWJyjWg4cL0kf-aWdeFcAK_g@mail.gmail.com>
Subject: Re: [PATCH v2] btrfs: release extent lock per folio in readahead
To: Boris Burkov <boris@bur.io>
Cc: linux-btrfs@vger.kernel.org, kernel-team@fb.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 15, 2026 at 5:52=E2=80=AFPM Boris Burkov <boris@bur.io> wrote:
>
> On Mon, Jun 15, 2026 at 05:32:26PM +0100, Filipe Manana wrote:
> > On Mon, Jun 15, 2026 at 5:26=E2=80=AFPM Boris Burkov <boris@bur.io> wro=
te:
> > >
> > > In Meta production, we have observed a large number of hosts running
> > > kernels newer than 6.13 which hit hung tasks on
> > > btrfs_read_folio()->lock_extents_for_read().
> >
> > You mean a deadlock?
> >
> > > Looking through the history
> > > in this codepath reveals an interesting history.
> > >
> > > in 6.12, we merged
> > > commit ac325fc2aad5 ("btrfs: do not hold the extent lock for entire r=
ead")
> > > which holds the extent lock very narrowly while looking up the
> > > extent_map. However, this proved to introduce a serious race with DIO
> > > writes which was fixed in 6.14 with
> > > commit acc18e1c1d8c0 ("btrfs: fix stale page cache after race between=
 readahead and direct IO write")
> > >
> > > That latter fix subtly changed the extent unlock point from the pre-6=
.12
> > > regime. In 6.11, each read endio unlocked the extent it finished
> > > reading, but in 6.14, the extent is locked/unlocked as a unit around =
the
> > > entire readahead loop, while the individual folios are still unlocked=
 as
> > > the endios finish. This is mostly the same behavior, as all successfu=
l
> > > reads will populate the page cache, so subsequent reads won't enter
> > > btrfs and hit the extent lock. But in the case where the readahead
> > > fails, perhaps because of a memory allocation failure doing compresse=
d
> > > reads, the page will not be brought up to date and a later read of an
> > > overlapping range *will* block on the extent lock.
> >
> > Ok, but is it blocking indefinitely, a deadlock?
> >
> > What is the problem exactly? The entire locked range is unlocked later.
> > Can you explain this more clearly?
> >
> > Thanks.
> >
>
> Sorry for being insufficiently clear. I don't think that there is a
> deadlock here. I think it is just a (hopefully) unnecessary degree of
> contention on the extent lock that is showing in the tails of memory
> pressure delays.
>
> If you allow that on a sufficiently large, loaded system that direct
> reclaim can run for minutes, and consider two tasks on such a system
> reading an overlapping range of a compressed file:
>
> Task 1 locks the whole range and starts to read. Some allocation for
> the compressed read for folio F fails and we carry on while holding the
> extent lock for the full range.
>
> Task 2 wants to read F, which is not uptodate and in page cache, so it
> blocks on the extent lock held by Task 1.
>
> Task 1 is attempting to do compressed reads and keeps getting stuck in
> direct reclaim.
>
> The system wouldn't be all that healthy anyway, so this is not a
> critical improvement, but it does alleviate just a bit of stress and one
> thread's slowdown escalating to others.
>
> There could be other delays/interactions from Task 1 besides getting
> stuck in reclaim  after it passes a folio without bringing it uptodate
> that I haven't thought of or reproduced yet, I just figured this was
> sufficient to demonstrate something worth improving.

Than please add that information to the change log.
It's unclear whether this patch fixes a functional or a performance problem=
.

>
> Unfortunately, I don't have rigorously collected holder data from the
> prod instances. I am inferring some of the details from circumstantial
> evidence and what I was able to reproduce (and delays I have observed in
> the fleet generally). If you would like, I can attempt to gather more
> prod evidence about the lock holder directly, but it's not trivial since
> I can't predict when and where this sort of slowdown will happen.

No need for data/numbers on that.

Thanks.

>
> Thanks,
> Boris
>
> > >
> > > To bring this behavior back to the old model, we should unlock the
> > > extent at each loop of the readahead loop rather than in one shot at =
the
> > > end. This allows such overlapping reads to proceed as they should.
> > > Writes are fine because either the page has already been read and has=
 an
> > > appropriate state in the page cache to be invalidated (or not uptodat=
e)
> > > or it is still-to-be-read and the extent lock is still held protectin=
g
> > > it.
> > >
> > > Signed-off-by: Boris Burkov <boris@bur.io>
> > > ---
> > > Changelog:
> > > v2:
> > > - fixed the bug of unlocking readahead expansion extents that we did =
not
> > >   ourselves lock.
> > >
> > >  fs/btrfs/extent_io.c | 17 ++++++++++++++---
> > >  1 file changed, 14 insertions(+), 3 deletions(-)
> > >
> > > diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
> > > index ce9aa0f6bc35..e0d24e69441a 100644
> > > --- a/fs/btrfs/extent_io.c
> > > +++ b/fs/btrfs/extent_io.c
> > > @@ -2745,12 +2745,23 @@ void btrfs_readahead(struct readahead_control=
 *rac)
> > >         struct fsverity_info *vi =3D NULL;
> > >
> > >         lock_extents_for_read(inode, start, end, &cached_state);
> > > +       /* We don't use cached state for a bulk unlock, just free it.=
 */
> > > +       btrfs_free_extent_state(cached_state);
> > >         if (start < i_size_read(vfs_inode))
> > >                 vi =3D fsverity_get_info(vfs_inode);
> > > -       while ((folio =3D readahead_folio(rac)) !=3D NULL)
> > > -               btrfs_do_readpage(folio, &em_cached, &bio_ctrl, vi);
> > > +       while ((folio =3D readahead_folio(rac)) !=3D NULL) {
> > > +               /*
> > > +                * Read start and end before btrfs_do_readpage(). It =
unlocks the
> > > +                * folio, so our reference might not be valid after.
> > > +                */
> > > +               const u64 folio_start =3D folio_pos(folio);
> > > +               const u64 folio_end =3D folio_start + folio_size(foli=
o) - 1;
> > >
> > > -       btrfs_unlock_extent(&inode->io_tree, start, end, &cached_stat=
e);
> > > +               btrfs_do_readpage(folio, &em_cached, &bio_ctrl, vi);
> > > +               /* Only unlock the range we locked, even if readahead=
 expands. */
> > > +               if (folio_start >=3D start && folio_end <=3D end)
> > > +                       btrfs_unlock_extent(&inode->io_tree, folio_st=
art, folio_end, NULL);
> > > +       }
> > >
> > >         if (em_cached)
> > >                 btrfs_free_extent_map(em_cached);
> > > --
> > > 2.54.0
> > >
> > >
