Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 635DF3E5EFB
	for <linux-btrfs@vger.kernel.org>; Tue, 28 Jul 2026 09:51:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785232276; cv=none; b=iGWi/WtC1k4eYmGDfX3pIgl/DXb5OH4o6+asg7PsczQG5rvrnEamH2QJUGz4prJa89Vg655L9aJII8qkCom1PhzX/UIngDfJBbpCaIFvUtccsmvPj7pPHJ3wKj0ZttGac2xaogBOs6ZHNmaIQ4Cd8cMkYts+lKpd93P6TXdYKxg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785232276; c=relaxed/simple;
	bh=DAWkfDuQ7FNctJ9vub7lSirTLNVucDPHWJEdRuSIH/Y=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Ox2lP+Xy0/ooClk7Pw/p8cl8IHKa6ap8P0p0nDYchoP304vecpeAOcIUmovLVqLbluE05qVug7PnAzNBwogt3wCtbPxcSBriYbATjK3lOx8Z9D49I0EJfSvyVBug5s8vdcDVFwwYjOK0Ht/Uk+5okkHsk5B5YFojYqzspuJl7Sc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=W52DOj45; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="W52DOj45"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFC8E1F00A3A
	for <linux-btrfs@vger.kernel.org>; Tue, 28 Jul 2026 09:51:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785232274;
	bh=/v7NKOMedrwFOF4mVefkH2cu67szDX0heqMRLjg/+s4=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=W52DOj45+GGoDVFvWWkKwDI5usE3Fr11Al73V+VfrqgZybjjleJ5Sev8yEVhvj3Ff
	 8wZ5wSmE+rqMqqQg2lAFYIDAOtzkUrwPTM/GPet0RJMQCZEHIqJd9hQyAmNyMjyK/U
	 6BDro+9KHJxw7O7E2bPQkKeSrIE2AYlgh22EPFI9h4ilPiBRS5qBTaWVnLQGVqzwkI
	 YZJZS6FL+Td//1rTweBhb2Heq7HBspTQIHKQCM3tMSPHqNI1yE2WCTSklc6hGjR2pR
	 ATM32yjfgROxvIjwa7xkq0lfWnXZehFCy7xQLfN0jNd52pkbPX3ugF5rSoptVqg8JZ
	 EAgxqMOafR2Dg==
Received: by mail-ua1-f48.google.com with SMTP id a1e0cc1a2514c-96723c7151eso971781241.2
        for <linux-btrfs@vger.kernel.org>; Tue, 28 Jul 2026 02:51:14 -0700 (PDT)
X-Gm-Message-State: AOJu0YzeqAk7weJODf5AOmR8KwGrgX3InoHOnq7e9i/hEj37RQxK1EMr
	Z9z3M50SW+4pGSECpVg5GtZd2s4Fcx1/rJ42fRUO30v1qeR/32ljphMeb+wtNbhDv0OPCymRa/5
	Yrprv1IdvZA2YKQY63f6wTgYvKeTxlyw=
X-Received: by 2002:a05:6102:80aa:b0:738:bf0f:d0c7 with SMTP id
 ada2fe7eead31-754a22bcc36mr618466137.25.1785232274145; Tue, 28 Jul 2026
 02:51:14 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1785229591.git.wqu@suse.com> <f5f77acc88e5ca314e4b41733a3c60e691fb6aaf.1785229591.git.wqu@suse.com>
 <CAL3q7H4Tqtt2pDmRWrLbmHeW7oPJfqNoJz28x6aAy4uAHX-FSQ@mail.gmail.com> <e222a1c1-0d48-45b1-993c-f7d889ac49fa@suse.com>
In-Reply-To: <e222a1c1-0d48-45b1-993c-f7d889ac49fa@suse.com>
From: Filipe Manana <fdmanana@kernel.org>
Date: Tue, 28 Jul 2026 10:50:37 +0100
X-Gmail-Original-Message-ID: <CAL3q7H6hB6n5NOaxgaj=8Ddp9A3UGsnKcJ3vHeOJ+UftU+Jkmg@mail.gmail.com>
X-Gm-Features: AUfX_my5GaxL76H_FKD_CP5Wcy6_OiK6DXySHQ5ZeM2XoWrh6eTPYgBssBgK8xA
Message-ID: <CAL3q7H6hB6n5NOaxgaj=8Ddp9A3UGsnKcJ3vHeOJ+UftU+Jkmg@mail.gmail.com>
Subject: Re: [PATCH v2 1/3] btrfs: use aligned range for locking in extent_fiemap()
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 28, 2026 at 10:41=E2=80=AFAM Qu Wenruo <wqu@suse.com> wrote:
>
>
>
> =E5=9C=A8 2026/7/28 19:08, Filipe Manana =E5=86=99=E9=81=93:
> > On Tue, Jul 28, 2026 at 10:23=E2=80=AFAM Qu Wenruo <wqu@suse.com> wrote=
:
> >>
> >> The @end parameter for all extent io tree helpers is inclusive, but
> >> the call site in extent_fiemap() is passing an exclusive end into
> >> btrfs_lock_extent(), which will step into the next block unexpectedly.
> >>
> >> Fix @range_end to be inclusive, so that btrfs_lock_extent() and
> >> btrfs_unlock_extent() will lock/unlock the correct aligned range.
> >>
> >> Fixes: ac3c0d36a2a2 ("btrfs: make fiemap more efficient and accurate r=
eporting extent sharedness")
> >> Signed-off-by: Qu Wenruo <wqu@suse.com>
> >> ---
> >>   fs/btrfs/fiemap.c | 8 ++++----
> >>   1 file changed, 4 insertions(+), 4 deletions(-)
> >>
> >> diff --git a/fs/btrfs/fiemap.c b/fs/btrfs/fiemap.c
> >> index ba6a360074c0..2f2ae0b76799 100644
> >> --- a/fs/btrfs/fiemap.c
> >> +++ b/fs/btrfs/fiemap.c
> >> @@ -657,7 +657,7 @@ static int extent_fiemap(struct btrfs_inode *inode=
,
> >>
> >>   restart:
> >>          range_start =3D round_down(start, sectorsize);
> >> -       range_end =3D round_up(start + len, sectorsize);
> >> +       range_end =3D round_up(start + len, sectorsize) - 1;
> >>          prev_extent_end =3D range_start;
> >>
> >>          btrfs_lock_extent(&inode->io_tree, range_start, range_end, &c=
ached_state);
> >> @@ -710,7 +710,7 @@ static int extent_fiemap(struct btrfs_inode *inode=
,
> >>
> >>                  /* We have in implicit hole (NO_HOLES feature enabled=
). */
> >>                  if (prev_extent_end < key.offset) {
> >> -                       const u64 hole_end =3D min(key.offset, range_e=
nd) - 1;
> >> +                       const u64 hole_end =3D min(key.offset - 1, ran=
ge_end);
> >>
> >>                          ret =3D fiemap_process_hole(inode, fieinfo, &=
cache,
> >>                                                    &delalloc_cached_st=
ate,
> >> @@ -812,10 +812,10 @@ static int extent_fiemap(struct btrfs_inode *ino=
de,
> >>          if (!stopped && prev_extent_end < range_end) {
> >>                  ret =3D fiemap_process_hole(inode, fieinfo, &cache,
> >>                                            &delalloc_cached_state, bac=
kref_ctx,
> >> -                                         0, 0, 0, prev_extent_end, ra=
nge_end - 1);
> >> +                                         0, 0, 0, prev_extent_end, ra=
nge_end);
> >>                  if (ret < 0)
> >>                          goto out_unlock;
> >> -               prev_extent_end =3D range_end;
> >> +               prev_extent_end =3D range_end + 1;
> >
> > If the problem is passing an exclusive end to btrfs_lock_extent(),
> > then rather than doing all these changes to this variables, which is
> > error prone since they are used in several places and generally we use
> > exclusive ends everywhere, I'd prefer to simply change the call to
> > btrfs_lock_extent() and btrfs_unlock_extent() to receive 'range_end -
> > 1'. That also makes the fix much clearer.
>
> Thanks for the advice, indeed that is much safer.

After that you can add:

Reviewed-by: Filipe Manana <fdmanana@suse.com>

Thanks.

>
> Thanks,
> Qu>
> > Thanks.
> >
> >>          }
> >>
> >>          if (cache.cached && cache.offset + cache.len >=3D last_extent=
_end) {
> >> --
> >> 2.54.0
> >>
> >>
>
