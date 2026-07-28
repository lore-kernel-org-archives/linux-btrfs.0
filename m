Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C7B53FB067
	for <linux-btrfs@vger.kernel.org>; Tue, 28 Jul 2026 09:17:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785230280; cv=pass; b=fCYoql7RDQV9e5j7cYpM+59OobDGvYKS/eACLJfhy++5JFur4K69hM4Jb8jbZ7nBVXKglVMg8Y74W6Af7EgbwsroMyxIFaxfuWEq8G2QlScYU6erLzN6DinnHQwy1TAR8RdOvu2RKxquibG0Ghus2xo9mBaCbRwLAspXidAJgc0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785230280; c=relaxed/simple;
	bh=bJabPUURD2v+WynHiEjp9V8FMyTQj0tBY3Gwob6WByM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=uwrLNyAL2O2xcUQtCMPqBQ4EdzZZ4YNs1EEJwD8apAOzVrIaFCOSP/VM/U0VaG4GHeb5RsoTF9jT+QVVV9nTd32ph2shUp+sd+dza5H1H2cev40Fyqy6ztAFHCkn8CmLcNjQvblOrDybx9G56v+kDowCCEeAr7FF8bS1LBf5OtQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=eeuVwtJ6; arc=pass smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="eeuVwtJ6"
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-493f75f7172so30554295e9.1
        for <linux-btrfs@vger.kernel.org>; Tue, 28 Jul 2026 02:17:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785230277; cv=none;
        d=google.com; s=arc-20260327;
        b=ZxNV79+K5lEnofcAkia6DxfeMFCT62ZjNu0BMrQFKVQA7nlxbh/ieLhykwjvaB4wR5
         tbNBMJztnRUB1yp254PTKDGaOjJ0c7RwwDhgf4mT6scLK6BlTI7V2AV14vC53imF6YD/
         waEsJBQsVzM75ORX5Grg6BqYoEV3DlQTCfY58JZH2PyIZbLRrKPNGHXsZ60ey8rHvkaw
         pkv32J4MMAyIOlKXhIershluBPdRqKzsRFt/rs7VXlVJDeA0LJjuM0U7ecOxziTgeGBS
         yvQc0DTzKetzIcJKtxqD67eYPtB8y2C0iVzXLwa9oA2brJ2rWXjHUZsX56uw0EL/GUqm
         yxEA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=3lZ9ye9JGGAWSLP5Q2/jK0IRHRLjzU3+2AWxgXcP728=;
        fh=gccavu6KskZuhdxKZGGZqKbRpE8AZv+Jw1v9OVMw784=;
        b=tCJw/UJKyhc5oeZBd+mAnzIPfXmuwqc5rQ2aSImJaHwndfrJg+a7qERIEOCW3H5SbM
         Gk/+N7fYJQ7C5nq1n54Sg2fAjwEKavbZ5n7S7ARvcCV6+xsTdan/2XyNvOgMOvUu0N8K
         t6MtFfFaSRbFUxKhH5u9Fqk2Z0vZuHcTdpYxQJ4Ru7VUyFfRs8jAfnAqvbiBR5xDduyi
         xFvf0VxKW4/EEe1xq4QxcFwKscaUtI7iyItOOZWTY47lWn7HJNVcROlPohzww7hsM19T
         jFhNK5/jObylt2jHQApmJfxqi1ip0qrw90APeLhttTv59lEdILJPhXVawyu5GipNUkOC
         vSiw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1785230277; x=1785835077; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=3lZ9ye9JGGAWSLP5Q2/jK0IRHRLjzU3+2AWxgXcP728=;
        b=eeuVwtJ6y8z1btWFDT5XwowjC29pQn0oYQNwxQ5mBbepLf/2LYpoj88qY3HzlQO74Q
         Dcr9H0pv9lNDonbJ7mgHFAEk1ChZDq46fqziwRBGofy7IY4QWmnh1wnQbbPgnp50L6o+
         hsdTb2NK9OtjuDyuqyGUAWDd4C86cdNxynKFdLcOK6cVGGlu7xQQpo396FveFi4aeCNm
         sHBLs57eMh1ktzMVN/mRv3LT7n+Mr2NroGitAJLzm2lzTqtgg78a/lOG327fSWlv/m+I
         dT421p7xD57hSpoCTEE06jZ/t6kuCEac+x5oz7nlkt5/jVVEOB664Kdi9EANiiVgWMcp
         ZcPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785230277; x=1785835077;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=3lZ9ye9JGGAWSLP5Q2/jK0IRHRLjzU3+2AWxgXcP728=;
        b=WfzJOhy8vSkPvmwfIQwl2RmXu4V86lxAXoQfGZaCEFbyp4QqQCVH1UO/MoM6Q4+h53
         gLzxAeuQClEKCyeUm4ehdIFKWCvKWf9Ldrr5fs+nplLBpHsjOpOsgJa/e/3zSgNpU/Tb
         lfo9Qf0lF3KfCRnE28NivOxW1HN1hW91ZiexXoriKnusUsfhpXg0cq6dnDn7zDZyM4IV
         XoRsgcK+HUjFexa0jxKgI9huffcfoxfX2sRpIKJuZwACviJbK0pkOk0y480DtMVAxIvD
         y/l+mGG6AbMHjO3grWZgkMcF2f/lmaR6ObWUZkHYpnp71x34DppBRRKhTbGi7ITTXL9S
         OxlQ==
X-Gm-Message-State: AOJu0YwoBesL1izSpwLa70IjbL8nksBo/5kLBrBnnWZ7Mte2AsadxuwO
	ALHXHqe006wNIOLwrh01KWa3dBcZ95W2MhVic+QNGcIkZV6E407QoodVV0VhQIlmi7qyiqsVM46
	V7dYzHEubEakIBqMjjnJr8w7k4pQXK2L9h1C8x3PjB5T3dhOb+OibY/M=
X-Gm-Gg: AR+sD13iUU2U3jsq2iJmwR5GkRu3TEyAGrjppIXYdVHQcy8ClPPpQCSb8KWewxv921J
	K7jukA3XHZlhZqMs2giOnZckQJ2i3b8r0PA9ZTTW2d5zV3bmRuZcQ/urnoWvCDvcRb/X7OTjOKU
	hMYRMVuaLVweDX3HmYeoS9Vp2KZgB7FctxYAmJG0c9nOO3gsHj7CzkqwpoN1fZc7nQdByWkZPTH
	x37D4hn08UosUnuIsQq45CQUueUyhZuPV0Y+18Im3XR1RaZpJkvO/UKXUFdQJHDu41cmZ614Eni
	qa2eYuoVRzRCfWru4qJed43gFzF9712VujHrpkCzaqv7lssrkM6sksE94WU=
X-Received: by 2002:a05:600c:4755:b0:492:4e09:9fc1 with SMTP id
 5b1f17b1804b1-496c6440c93mr16832175e9.15.1785230276755; Tue, 28 Jul 2026
 02:17:56 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1785220613.git.wqu@suse.com> <44822c23fc6764aa93a855648a1533a5faf4925c.1785220613.git.wqu@suse.com>
 <CAPjX3Fez2At9ZX1ga3YJt-rs+TGcXsV8WfJLXcmr64-4gjVQnQ@mail.gmail.com> <9b591ffd-808f-45ac-8109-85de8ba2b798@suse.com>
In-Reply-To: <9b591ffd-808f-45ac-8109-85de8ba2b798@suse.com>
From: Daniel Vacek <neelx@suse.com>
Date: Tue, 28 Jul 2026 11:17:45 +0200
X-Gm-Features: AUfX_mz0dPKaxs8MoUoUWGI-BXgIENc_9sXN_pWt48xDalECHA6zjKB-DYaVjfU
Message-ID: <CAPjX3FenCVAukra4Djz8r4ShRi4M6DxpHH5-Lm1XyrsahFn=nQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] btrfs: use proper inclusive end in extent_fiemap()
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 28 Jul 2026 at 10:40, Qu Wenruo <wqu@suse.com> wrote:
> =E5=9C=A8 2026/7/28 17:35, Daniel Vacek =E5=86=99=E9=81=93:
> > On Tue, 28 Jul 2026 at 08:46, Qu Wenruo <wqu@suse.com> wrote:
> >> The @end parameter for all extent io tree helpers is inclusive, but
> >> the call site in extent_fiemap() is passing exclusive end.
> >>
> >> Fix it to follow the common pattern.
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
> >>          }
> >>
> >>          if (cache.cached && cache.offset + cache.len >=3D last_extent=
_end) {
> >> --
> >> 2.54.0
> >
> > I don't really get why you left out these:
> >
> > @@ -680,7 +680,7 @@ static int extent_fiemap(struct btrfs_inode *inode,
> >                  goto check_eof_delalloc;
> >          }
> >
> > -       while (prev_extent_end < range_end) {
> > +       while (prev_extent_end <=3D range_end) {
> >                  struct extent_buffer *leaf =3D path->nodes[0];
> >                  struct btrfs_file_extent_item *ei;
> >                  struct btrfs_key key;
> > @@ -809,13 +809,13 @@ static int extent_fiemap(struct btrfs_inode *inod=
e,
> >          }
> >
> >   check_eof_delalloc:
> > -       if (!stopped && prev_extent_end < range_end) {
> > +       if (!stopped && prev_extent_end <=3D range_end) {
> >                  ret =3D fiemap_process_hole(inode, fieinfo, &cache,
> >                                            &delalloc_cached_state, back=
ref_ctx,
> >
> > Am I missing something?
>
> Because we won't reach the =3D=3D case at all.
>
> The start is always increased by a value aligned to sectorsize.

I understand round_down() possibly decreases not increases. So if
start and start + len - 1 fall into the same block you get the =3D=3D
case. Am I wrong?

> For inclusive range_end, we either completely pass it by 1, or smaller
> than it.
>
> So that "=3D=3D" will never be hit.>
> > --nX
>
