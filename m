Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71BC32F7EF4
	for <linux-btrfs@vger.kernel.org>; Fri, 26 Jun 2026 09:16:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782465393; cv=none; b=i6dcSHuNsSeOmNOSMetCOlok/JdW4dbAFsabG599uRURk0DgsdanbKApEkKQApKh1mKUMko6sn0OH7LcLnlTFCv0xG2ClfmNqGlEIdFyJyT5DAVo0uancrQzPu8nfcQMMTfkN5HVnky5ls7SCxSmQO3fLOsMbHjNsZDob7H6JHg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782465393; c=relaxed/simple;
	bh=4xHFQC2NrbenMsbhHjR1+Fhj880HDtKaQHawo6LE210=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=DOVbbwP0Ij1nm0kYJ9OtGZjwgLheuQTDvDY7cw02IuTN82vC1BGR79Vi91hEr7bfAjOKRIHYeU6SoPsFzxWqXiMschbwifF3f/ZuofaPRkhFHAP+9FUMmy6foAsoMCeVdWmBmCuMMm240bpSho9IBr7+kwUj9ZMByZ4hPDKqWd0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jHjXNSC3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jHjXNSC3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 591F21F000E9
	for <linux-btrfs@vger.kernel.org>; Fri, 26 Jun 2026 09:16:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782465392;
	bh=T1Eaukj+yOnCV8ruWUa7wQtdUn9TBTDA/GLpzGeIU0U=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=jHjXNSC34SbQqzwxYt4o4Tx/AduHnmq6xIowX6Z4f7L9VXUfa5PE7vPeWR4RF3x0R
	 HgIXluYdPWT5ExQ5kefZade8egr19ZWkYIpyxRMrEEa7TyhZvDj8P2XES3PF9r1Z6v
	 oXw4SIaDSLGKo5oXt4Q7mQ0FHvVFK4T9eSoDA0lDDkRZv0J1WeGpZNBqbLXd3zyLIH
	 Vv9tl0IcJ281mygIvbZiYwIb3MeUukGQ4oj8jJ+fHiKfYd1pyVo8PHXyHEEC+71IPk
	 hEnMbgr4dZIkGeUILo8cHnAvCpTn+Uk7WM0NKrmq+tZNrRAewXTdoxvVpxK651SlWY
	 o3fIkvombt0Kw==
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-697ebe536b6so1168799a12.1
        for <linux-btrfs@vger.kernel.org>; Fri, 26 Jun 2026 02:16:32 -0700 (PDT)
X-Gm-Message-State: AOJu0YyYfTvsnIXSmCwPVJNSs+E8r3I9eqTigkc1XX+as61dH7kGuWtf
	r7u9tbe9wKOAZz5iwXalEgxSNoohLfvmhgL68DGyM0q543yyFo65zaVA6VatnEIhDIfOQAZV48v
	WymBs4uSxs+i0NMHQxeC6r2kiu/2h9Pc=
X-Received: by 2002:a17:907:e895:b0:c05:21a7:6b0d with SMTP id
 a640c23a62f3a-c120617b59dmr432004566b.47.1782465390976; Fri, 26 Jun 2026
 02:16:30 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <aaabe0f2bee07800fb0490d24fab5cd162e5241d.1782366056.git.wqu@suse.com>
 <CAL3q7H7+WAQMV76+-AuU=dR_qoe6Gu1_CNmwUFD=zW81d2Hz0g@mail.gmail.com> <9efd034f-fa6b-485c-aca7-a38f526d4083@suse.com>
In-Reply-To: <9efd034f-fa6b-485c-aca7-a38f526d4083@suse.com>
From: Filipe Manana <fdmanana@kernel.org>
Date: Fri, 26 Jun 2026 10:15:53 +0100
X-Gmail-Original-Message-ID: <CAL3q7H6sNSPqkE+h7PgX+Vv+7o5zTokBi52F5SooMmxEEH-phQ@mail.gmail.com>
X-Gm-Features: AVVi8CdLni8jTHNxdRzx4_B911SgUphtqbqGbTkCSYeQPSgGteP_n3yV4_LcLTw
Message-ID: <CAL3q7H6sNSPqkE+h7PgX+Vv+7o5zTokBi52F5SooMmxEEH-phQ@mail.gmail.com>
Subject: Re: [PATCH] btrfs: always wait for ordered extents to avoid OE races
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org, 
	syzbot+ba2afde329fc27e3f22e@syzkaller.appspotmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 25, 2026 at 11:39=E2=80=AFPM Qu Wenruo <wqu@suse.com> wrote:
>
>
>
> =E5=9C=A8 2026/6/25 20:59, Filipe Manana =E5=86=99=E9=81=93:
> [...]
> >
> >> @@ -896,42 +896,38 @@ lock_and_cleanup_extent_if_need(struct btrfs_ino=
de *inode, struct folio *folio,
> >>          start_pos =3D round_down(pos, fs_info->sectorsize);
> >>          last_pos =3D round_up(pos + write_bytes, fs_info->sectorsize)=
 - 1;
> >>
> >> -       if (start_pos < inode->vfs_inode.i_size) {
> >> -               struct btrfs_ordered_extent *ordered;
> >> -
> >> -               if (nowait) {
> >> -                       if (!btrfs_try_lock_extent(&inode->io_tree, st=
art_pos,
> >> -                                                  last_pos, cached_st=
ate)) {
> >> -                               folio_unlock(folio);
> >> -                               folio_put(folio);
> >> -                               return -EAGAIN;
> >> -                       }
> >> -               } else {
> >> -                       btrfs_lock_extent(&inode->io_tree, start_pos, =
last_pos,
> >> -                                         cached_state);
> >> -               }
> >> -
> >> -               ordered =3D btrfs_lookup_ordered_range(inode, start_po=
s,
> >> -                                                    last_pos - start_=
pos + 1);
> >> -               if (ordered &&
> >> -                   ordered->file_offset + ordered->num_bytes > start_=
pos &&
> >> -                   ordered->file_offset <=3D last_pos) {
> >> -                       btrfs_unlock_extent(&inode->io_tree, start_pos=
, last_pos,
> >> -                                           cached_state);
> >> +       if (nowait) {
> >> +               if (!btrfs_try_lock_extent(&inode->io_tree, start_pos,
> >> +                                          last_pos, cached_state)) {
> >>                          folio_unlock(folio);
> >>                          folio_put(folio);
> >> -                       btrfs_start_ordered_extent(ordered);
> >> -                       btrfs_put_ordered_extent(ordered);
> >>                          return -EAGAIN;
> >>                  }
> >> -               if (ordered)
> >> -                       btrfs_put_ordered_extent(ordered);
> >> -
> >> -               *lockstart =3D start_pos;
> >> -               *lockend =3D last_pos;
> >> -               ret =3D 1;
> >> +       } else {
> >> +               btrfs_lock_extent(&inode->io_tree, start_pos, last_pos=
,
> >> +                                 cached_state);
> >>          }
> >>
> >> +       ordered =3D btrfs_lookup_ordered_range(inode, start_pos,
> >> +                                            last_pos - start_pos + 1)=
;
> >> +       if (ordered &&
> >> +           ordered->file_offset + ordered->num_bytes > start_pos &&
> >> +           ordered->file_offset <=3D last_pos) {
> >> +               btrfs_unlock_extent(&inode->io_tree, start_pos, last_p=
os,
> >> +                                   cached_state);
> >> +               folio_unlock(folio);
> >> +               folio_put(folio);
> >> +               btrfs_start_ordered_extent(ordered);
> >> +               btrfs_put_ordered_extent(ordered);
> >> +               return -EAGAIN;
> >> +       }
> >> +       if (ordered)
> >> +               btrfs_put_ordered_extent(ordered);
> >> +
> >> +       *lockstart =3D start_pos;
> >> +       *lockend =3D last_pos;
> >> +       ret =3D 1;
> >
> > And this is pointless, right below we can use "return 1;" and get rid
> > of the 'ret' variable.
> >
> > Since returning 1 no longer makes sense, just make it return 0 and remo=
ve 'ret'.
> >
> > Also in the caller, since lock_and_cleanup_extent_if_need() now always
> > returns with the extent range locked, we can get rid of it's local
> > variable named 'extents_locked' and use 'ret' as it does not make
> > sense anymore.
> >
> > Finally, with this change we now always look for ordered extents and
> > lock the range. Previously, we only did this if writes were within
> > i_size - which makes sense because, except for his new direct IO case
> > falling back to buffered IO, we could never find ordered extents
> > beyond i_size.
> >
> > Have you checked whether performance is affected?
>
> Here is the microbenchmark for the runtime of btrfs_buffered_write() and
> lock_and_cleanup_extent_if_need().
>
> The workload is a very basic xfs_io -f -c "pwrite 0 1m", which is always
> appending the isize for every 4K block.
>
> Before patch:
> - lock_and_cleanup_extent_if_need():
>
>    runtime avg =3D 58.16 ns
>    runtime stdev =3D 4.2
>
> - btrfs_buffered_write():
>
>    runtime avg =3D 2115.6 ns
>    runtime stdev =3D 1822.1
>
>
> Patched:
> - lock_and_cleanup_extent_if_need():
>
>    runtime avg =3D 183.0 ns
>    runtime stdev =3D 161.6
>
> - btrfs_buffered_write():
>
>    runtime avg =3D 2973.3 ns
>    runtime stdev =3D 4225.1
>
> So yes, the runtime of lock_and_cleanup_extent_if_need() has greatly
> increased, by more than 3 times, but still less than 1 micro second.
>
> The btrfs_buffered_write() itself is also much slower due to the extra
> extent unlock, the runtime is increased by 40%, but still less than 3 us.
>
> I'm not sure if the cost is acceptable or not. The increased runtime is
> pretty huge for the affected worst case scenario, and that's undeniable.
>
> But the overall runtime of btrfs_buffered_write() itself is still at
> single digit microsecond level.
>
> If acceptable, I'll add the microbenchmark into the commit message in
> the next update.

Instead of this approach, can we wait for the ordered extent(s) in DIO
path that reverts i_size after the short write?

>
> Thanks,
> Qu
>
> >
> > Thanks.
> >
> >> +
> >>          /*
> >>           * We should be called after prepare_one_folio() which should=
 have locked
> >>           * all pages in the range.
> >> @@ -1288,11 +1284,8 @@ static int copy_one_range(struct btrfs_inode *i=
node, struct iov_iter *iter,
> >>
> >>                  /* No copied bytes, unlock, release reserved space an=
d exit. */
> >>                  if (copied =3D=3D 0) {
> >> -                       if (extents_locked)
> >> -                               btrfs_unlock_extent(&inode->io_tree, l=
ockstart, lockend,
> >> -                                                   &cached_state);
> >> -                       else
> >> -                               btrfs_free_extent_state(cached_state);
> >> +                       btrfs_unlock_extent(&inode->io_tree, lockstart=
, lockend,
> >> +                                           &cached_state);
> >>                          btrfs_delalloc_release_extents(inode, reserve=
d_len);
> >>                          release_space(inode, *data_reserved, reserved=
_start, reserved_len,
> >>                                        only_release_metadata);
> >> @@ -1311,17 +1304,7 @@ static int copy_one_range(struct btrfs_inode *i=
node, struct iov_iter *iter,
> >>
> >>          ret =3D btrfs_dirty_folio(inode, folio, start, copied, &cache=
d_state,
> >>                                  only_release_metadata);
> >> -       /*
> >> -        * If we have not locked the extent range, because the range's=
 start
> >> -        * offset is >=3D i_size, we might still have a non-NULL cache=
d extent
> >> -        * state, acquired while marking the extent range as delalloc =
through
> >> -        * btrfs_dirty_page(). Therefore free any possible cached exte=
nt state
> >> -        * to avoid a memory leak.
> >> -        */
> >> -       if (extents_locked)
> >> -               btrfs_unlock_extent(&inode->io_tree, lockstart, locken=
d, &cached_state);
> >> -       else
> >> -               btrfs_free_extent_state(cached_state);
> >> +       btrfs_unlock_extent(&inode->io_tree, lockstart, lockend, &cach=
ed_state);
> >>
> >>          btrfs_delalloc_release_extents(inode, reserved_len);
> >>          if (ret) {
> >> --
> >> 2.54.0
> >>
> >>
>
