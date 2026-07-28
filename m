Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EDF641A51B
	for <linux-btrfs@vger.kernel.org>; Tue, 28 Jul 2026 09:47:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.221.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785232044; cv=pass; b=bxONaIBub3HQaESHSpbMmHa6IwgQ+BCu4KupVAvOdrKYLqEeNe8slqoQFVShDZo3UKpu0ak0xsNSc+4Pv8oDMoofaTH8vFdOWAjCNe+dRcZUf2JVUvmZk01gKYmZvCB6FWXpTa4+vUByoef8mdZDfxoAQcmp2f1Q/mX3VPpG1nA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785232044; c=relaxed/simple;
	bh=I9kYBC4eYzDjTB+YUqCWcA4nS2rWUi7z7PVRiuOgM4U=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Opi+5QH04wNlviOorHUfx7NOgx1vphxom1oIY6J3CkrbYiSCEaEmdnSELAJBBFFyGxGZiHx7wb5occ6Am8c6f2wPAH5OwOys+1euFmzzvKEYpnqODZyrTV1EHx1a1AKK+7bSU7dKnvKA+m7iwPvNbfyb4HfBp3qhFmEwrXu2DMQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=VPkD25N5; arc=pass smtp.client-ip=209.85.221.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="VPkD25N5"
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-47c6e9a694bso2169116f8f.1
        for <linux-btrfs@vger.kernel.org>; Tue, 28 Jul 2026 02:47:22 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785232040; cv=none;
        d=google.com; s=arc-20260327;
        b=mFWzF4xoq4/J5gh9OJPX29hmqduutgWQYKFnyjN8muh2l+RW78T044kJON3NrjPOGl
         mlk672p1qJ/EfS+hNb++obXJsEgm4yC6grmmNCW88F9Y4Q3mgpFOfBUp8CFs6sEOqKiQ
         4hVOxS2FDGOoRDMGUHgwS0g/vFwNJTzbZYABaq+xIgTiS13MwntAWLZpBn5VD2DRmuG6
         Pp4yJaSMgzeQz4Lhya0xAzh0z4gs+b75/yZ4ksusIzcwJ6Ze1p7Bbo6oaQIaXM2DB31F
         YGvKynGTxRM5tqR1Q4IesXhj6b/m4p2kgU+bdncTgRFOWeanQlbXWNVkAIQ0B8uK67g+
         r54Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=32Td07qe70UVmm++uNVsZFZWCSmpjeL3sh0LpX5ZlTw=;
        fh=gccavu6KskZuhdxKZGGZqKbRpE8AZv+Jw1v9OVMw784=;
        b=c2mKkEl+pKo1D8pd06d0cbfQjO4/iqgjas0evhmDz3HKrrHbjcnNL5gxcHWqEq2ZU9
         DrnZJoSU2Y0vx0EacwkkyNLSaIHSr0JX3V9d0tbjBGByyLxZwFxRxHYV1Yuklns811ZX
         /4jqeiH0MeVJaKRijUK2U4gG+0dKCbMtFR+emIWxT39orJX6p6Q/LNUgfd9pqNzu266r
         pepYlM+LRo2HQ3j3mIq35yCDvGWLckmeK6TCiBgTI7jIJISX5gInYfkldomyZrwKTQnf
         b4V/0/C406p2eJ1sBQC6wmjMh4uELVb5fYwZnAWgRczu5xG5rPH1icyXakD7krAqFEVp
         MF1g==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1785232040; x=1785836840; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=32Td07qe70UVmm++uNVsZFZWCSmpjeL3sh0LpX5ZlTw=;
        b=VPkD25N5nmUhjDhayQiAr15fF20o8W6D1AYZ1OPctY+us7dIpCTlAuXqPgJsPq42A0
         Ya4dpnsYLhz2QMjGp751RXfimwpBs2jRdMHy5x+IebWLNnc5cX9Kti/pc6qhhInWdA1N
         x4suixsRazAZIV7bZ4xxb7UMfgW0loN5GLaBX7lSB0Z+A81SxMHXneCC0bmQJWCArfmM
         JlX40YKeoIWhVthC0vWbztHs2Iy7GDYaJ/PPOXz58pxWNlIfg1wKuoa5/Nk/XPJYs1r5
         k9y0mSlpPTgpQ98fO1uRhNE8rYL+f1P0QsRrR55cv13IhHY2EmYlKUvrrJepv7+LOfl6
         cx6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785232040; x=1785836840;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=32Td07qe70UVmm++uNVsZFZWCSmpjeL3sh0LpX5ZlTw=;
        b=r55jCAEI51yvGyiIsEnuXvdMga7RhXIa0XpF6rTt/QAvbJ+VIHunm6xLLomRUwRIsv
         bQKvo0Zgon1EJvUT1KOEpLIIWTRPcH96hWS9kvsuvsKx8Qo7E7pLOiKf4Yn6Hy5VUE4g
         pIvHuDmqdOin/VfSI18MX4YX5uFLuF5OSMLnIgm3r3aECPkHMfMfT0+VgZR9RzMgPBNE
         fK2p16H+R9iG9CH0LroKcow09k/M8Y4wWOaoi4tV3FgoTZbxMh1F5RwI23uge9SXGqZ7
         AYs1yAkHw81+NqJZZVYqw7hkrwtvusDLVGU4OcBTwNuGovjwxDQlZezpiDFXcGI90sQk
         HabA==
X-Gm-Message-State: AOJu0YxficWwugwJbbn00LujArH3u35LZ8QfPy1CrsfCXq8EK7JzGFNj
	gU1HkjSE2ZPHDBWLrp1rFw0/JsXDqusZdRZJk1phU/tyEjxPhUPb7T5wWhMGCfN6yJ6Fi5V3R2W
	Jni5GutkG1y48gR0r8ktbczhiQqiRdqMHtk0mPYUY7w==
X-Gm-Gg: AR+sD12ABUS7XAjY/F6NXYRkZ8cdG4wdphLvNCrQt5XCuP3sO9jM2xMMO363ce/93sd
	irolY0USynNbaXrazlfKcyfC4iqFnzu2EDs9ZHbpd7SNU5LZQuHJQeemZ8V7LFFIjYd5gumql5+
	uC0MLz8X97t799HS5DqnxTmWGUt73+mh1xvC/w/QvbrEJOz2jc5WA+lCRX+Edkk3stSbB61n4Mq
	kbX3CeLbuLM9spODBQmbe+KvlMo/TGFlZvfaZXCj3yocOxOE2r7CzyGqmJpJD/eRYe7e35ZrB/2
	OXqTZsqlhDL2Uvjty3V0oiHpK8Smn3Sc4G7AUGijDlwZQPSQnZusYVdhMdQ=
X-Received: by 2002:a5d:5f53:0:b0:47f:91e3:3cc9 with SMTP id
 ffacd0b85a97d-47fb1ecddc6mr1914641f8f.39.1785232040396; Tue, 28 Jul 2026
 02:47:20 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1785220613.git.wqu@suse.com> <44822c23fc6764aa93a855648a1533a5faf4925c.1785220613.git.wqu@suse.com>
 <CAPjX3Fez2At9ZX1ga3YJt-rs+TGcXsV8WfJLXcmr64-4gjVQnQ@mail.gmail.com>
 <9b591ffd-808f-45ac-8109-85de8ba2b798@suse.com> <CAPjX3FenCVAukra4Djz8r4ShRi4M6DxpHH5-Lm1XyrsahFn=nQ@mail.gmail.com>
In-Reply-To: <CAPjX3FenCVAukra4Djz8r4ShRi4M6DxpHH5-Lm1XyrsahFn=nQ@mail.gmail.com>
From: Daniel Vacek <neelx@suse.com>
Date: Tue, 28 Jul 2026 11:47:09 +0200
X-Gm-Features: AUfX_myWUaRF7wfOUrd5rq5cxno2OTT5W6qirGoWXw_gHU7pmHzeDIZ1qVrK9pY
Message-ID: <CAPjX3FesY+U9BMUVjUM3Cbwsdbac0-4RK4pH9WR5-5nvKoTH1w@mail.gmail.com>
Subject: Re: [PATCH 1/2] btrfs: use proper inclusive end in extent_fiemap()
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 28 Jul 2026 at 11:17, Daniel Vacek <neelx@suse.com> wrote:
> On Tue, 28 Jul 2026 at 10:40, Qu Wenruo <wqu@suse.com> wrote:
> > =E5=9C=A8 2026/7/28 17:35, Daniel Vacek =E5=86=99=E9=81=93:
> > > On Tue, 28 Jul 2026 at 08:46, Qu Wenruo <wqu@suse.com> wrote:
> > >> The @end parameter for all extent io tree helpers is inclusive, but
> > >> the call site in extent_fiemap() is passing exclusive end.
> > >>
> > >> Fix it to follow the common pattern.
> > >>
> > >> Fixes: ac3c0d36a2a2 ("btrfs: make fiemap more efficient and accurate=
 reporting extent sharedness")
> > >> Signed-off-by: Qu Wenruo <wqu@suse.com>
> > >> ---
> > >>   fs/btrfs/fiemap.c | 8 ++++----
> > >>   1 file changed, 4 insertions(+), 4 deletions(-)
> > >>
> > >> diff --git a/fs/btrfs/fiemap.c b/fs/btrfs/fiemap.c
> > >> index ba6a360074c0..2f2ae0b76799 100644
> > >> --- a/fs/btrfs/fiemap.c
> > >> +++ b/fs/btrfs/fiemap.c
> > >> @@ -657,7 +657,7 @@ static int extent_fiemap(struct btrfs_inode *ino=
de,
> > >>
> > >>   restart:
> > >>          range_start =3D round_down(start, sectorsize);
> > >> -       range_end =3D round_up(start + len, sectorsize);
> > >> +       range_end =3D round_up(start + len, sectorsize) - 1;
> > >>          prev_extent_end =3D range_start;
> > >>
> > >>          btrfs_lock_extent(&inode->io_tree, range_start, range_end, =
&cached_state);
> > >> @@ -710,7 +710,7 @@ static int extent_fiemap(struct btrfs_inode *ino=
de,
> > >>
> > >>                  /* We have in implicit hole (NO_HOLES feature enabl=
ed). */
> > >>                  if (prev_extent_end < key.offset) {
> > >> -                       const u64 hole_end =3D min(key.offset, range=
_end) - 1;
> > >> +                       const u64 hole_end =3D min(key.offset - 1, r=
ange_end);
> > >>
> > >>                          ret =3D fiemap_process_hole(inode, fieinfo,=
 &cache,
> > >>                                                    &delalloc_cached_=
state,
> > >> @@ -812,10 +812,10 @@ static int extent_fiemap(struct btrfs_inode *i=
node,
> > >>          if (!stopped && prev_extent_end < range_end) {
> > >>                  ret =3D fiemap_process_hole(inode, fieinfo, &cache,
> > >>                                            &delalloc_cached_state, b=
ackref_ctx,
> > >> -                                         0, 0, 0, prev_extent_end, =
range_end - 1);
> > >> +                                         0, 0, 0, prev_extent_end, =
range_end);
> > >>                  if (ret < 0)
> > >>                          goto out_unlock;
> > >> -               prev_extent_end =3D range_end;
> > >> +               prev_extent_end =3D range_end + 1;
> > >>          }
> > >>
> > >>          if (cache.cached && cache.offset + cache.len >=3D last_exte=
nt_end) {
> > >> --
> > >> 2.54.0
> > >
> > > I don't really get why you left out these:
> > >
> > > @@ -680,7 +680,7 @@ static int extent_fiemap(struct btrfs_inode *inod=
e,
> > >                  goto check_eof_delalloc;
> > >          }
> > >
> > > -       while (prev_extent_end < range_end) {
> > > +       while (prev_extent_end <=3D range_end) {
> > >                  struct extent_buffer *leaf =3D path->nodes[0];
> > >                  struct btrfs_file_extent_item *ei;
> > >                  struct btrfs_key key;
> > > @@ -809,13 +809,13 @@ static int extent_fiemap(struct btrfs_inode *in=
ode,
> > >          }
> > >
> > >   check_eof_delalloc:
> > > -       if (!stopped && prev_extent_end < range_end) {
> > > +       if (!stopped && prev_extent_end <=3D range_end) {
> > >                  ret =3D fiemap_process_hole(inode, fieinfo, &cache,
> > >                                            &delalloc_cached_state, ba=
ckref_ctx,
> > >
> > > Am I missing something?
> >
> > Because we won't reach the =3D=3D case at all.
> >
> > The start is always increased by a value aligned to sectorsize.
>
> I understand round_down() possibly decreases not increases. So if
> start and start + len - 1 fall into the same block you get the =3D=3D
> case. Am I wrong?

Of course I am, as it's not divided, just rounded. For some reason I
imagined these were block numbers not bytes. My bad.
Sorry about the noise.

> > For inclusive range_end, we either completely pass it by 1, or smaller
> > than it.
> >
> > So that "=3D=3D" will never be hit.>
> > > --nX
> >
