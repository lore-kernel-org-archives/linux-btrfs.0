Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 564CC3DBD74
	for <linux-btrfs@vger.kernel.org>; Thu, 25 Jun 2026 11:30:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782387021; cv=none; b=IPLxoOC+xGcgIBEsmJnYQtele01yHd9p5pRqzwRzg2Aapsz1wZdj3Zb0cjcGyJctgxazvMCc8AovHGNPOJaw/OfQppQ1inRyLb+s0fvZEsXh1GaG6eSmA40H5dM4Ig88b36/wnbBb4M7VU4UAAiR8/yUzcWMVZLaRt/x+FPC3no=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782387021; c=relaxed/simple;
	bh=X8ossaoM2zPUh0MHR5pcQTMfEroDQ3ITT+S7R2vVsO8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=FrghdXh1N36IEqrtlz7Z9cON15wvFnyWEiXc7nxcIYYxYtqDBMHD4liqwFeTYAagWwagYPBTpLzeOQ7zcZhG67iL+do7rcs6bWBiBv1w6CCL4uf7r20X49W5oxtRF4shHmF4NYWlaujUiGT4qdhYTJsLoB7S9frHoduK/DqAa1M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NoyHOcAZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NoyHOcAZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAA1A1F00A3A
	for <linux-btrfs@vger.kernel.org>; Thu, 25 Jun 2026 11:30:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782387020;
	bh=/PWdKuWngGyrMS6h01Bp6vFnzQ1rhY0QLM6XxT+qqYI=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=NoyHOcAZqxIkszIMMv3SiuzVXYVRnU16D/Cj6LlWw+FTYEOesrdS+FwE0Wwgl6M8L
	 ZN0XCtkZCO10mWB6KHpv+/ELg6pJOmoFjL09IsVkNNP9Q+E9oqM1ucg7DSMo4fPbGs
	 2nv/eiPWk7oIeeDiyfrHNpKjmQov+TOaeFij+S2ioUAbPwSp0k8N8Rx2nczadeDVUe
	 mVEFhhZ8oxA6F7Ni084c7IRDngNjlQE1ymVwvKBrNGDBMRLX+kFYU07gnX4STq3nWt
	 F0tW3g+DU53YCVZ2Y4d3Mz3XmR+chWAUAfhsj5Aw/RwIJ8tduIbJuuezoJEdbyxQcH
	 uVDhpqJQysF6w==
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-c0e12cb1d90so336784966b.2
        for <linux-btrfs@vger.kernel.org>; Thu, 25 Jun 2026 04:30:19 -0700 (PDT)
X-Gm-Message-State: AOJu0YxbhFowY9r0REmZ4aCcvmjXiAkKsieYY0AWF15TnZfCVPyu+32G
	LPI0X4VFCXEDgdZnCKjrmJDfDNQw+eEyxTAvoLTCRaGR/jYPRnJo5+rlRkWsN0kWE3+YrWTB/dt
	+LqoyV1LDY4EuZ9NwihUMwZeTLG42GqE=
X-Received: by 2002:a17:907:3d4e:b0:c0e:883e:e4f2 with SMTP id
 a640c23a62f3a-c1205f66475mr135697866b.30.1782387018480; Thu, 25 Jun 2026
 04:30:18 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <aaabe0f2bee07800fb0490d24fab5cd162e5241d.1782366056.git.wqu@suse.com>
In-Reply-To: <aaabe0f2bee07800fb0490d24fab5cd162e5241d.1782366056.git.wqu@suse.com>
From: Filipe Manana <fdmanana@kernel.org>
Date: Thu, 25 Jun 2026 12:29:41 +0100
X-Gmail-Original-Message-ID: <CAL3q7H7+WAQMV76+-AuU=dR_qoe6Gu1_CNmwUFD=zW81d2Hz0g@mail.gmail.com>
X-Gm-Features: AVVi8CfSV9VTNR7g2L6926zvBT6V0iwEtPwhYCLHWTt-r9tDrxOxLXle4yHYXXg
Message-ID: <CAL3q7H7+WAQMV76+-AuU=dR_qoe6Gu1_CNmwUFD=zW81d2Hz0g@mail.gmail.com>
Subject: Re: [PATCH] btrfs: always wait for ordered extents to avoid OE races
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org, 
	syzbot+ba2afde329fc27e3f22e@syzkaller.appspotmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 25, 2026 at 6:41=E2=80=AFAM Qu Wenruo <wqu@suse.com> wrote:
>
> [BUG]
> Syzbot reported a bug that there can be conflicting OEs for the same
> range:
>
>  BTRFS critical (device loop4): panic in insert_ordered_extent:264: overl=
apping ordered extents, existing oe file_offset 16384 num_bytes 430080 flag=
s 0x1089, new oe file_offset 16384 num_bytes 430080 flags 0x80 (errno=3D-17=
 Object alrea[  179.162726][ T6897] BTRFS critical (device loop4): panic in=
 insert_ordered_extent:264: overlapping ordered extents, existing oe file_o=
ffset 16384 num_bytes 430080 flags 0x1089, new oe file_offset 16384 num_byt=
es 430080 flags 0x80 (errno=3D-17 Object already exists)
>  ------------[ cut here ]------------
>  kernel BUG at fs/btrfs/ordered-data.c:264!
>  Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS =
Google 05/09/2026
>  RIP: 0010:btrfs_alloc_ordered_extent+0x943/0xad0
>  Call Trace:
>   <TASK>
>   cow_file_range+0x744/0x12a0
>   fallback_to_cow+0x5ea/0xa00
>   run_delalloc_nocow+0x110c/0x17a0
>   btrfs_run_delalloc_range+0xbe4/0x1c20
>   writepage_delalloc+0x104d/0x1ba0
>   btrfs_writepages+0x1667/0x28b0
>   do_writepages+0x338/0x560
>   filemap_fdatawrite_range+0x1f2/0x300
>   btrfs_fdatawrite_range+0x54/0xf0
>   btrfs_direct_write+0x6a0/0xc30
>   btrfs_do_write_iter+0x329/0x790
>   do_iter_readv_writev+0x624/0x8d0
>   vfs_writev+0x34c/0x990
>   __se_sys_pwritev2+0x17a/0x2a0
>   do_syscall_64+0x174/0x580
>   entry_SYSCALL_64_after_hwframe+0x77/0x7f
>   </TASK>
>  ---[ end trace 0000000000000000 ]---
>
> [CAUSE]
> Since commit ff66fe666233 ("btrfs: fix incorrect buffered IO fallback
> for append direct writes"), if the direct IO finished short, we will
> revert the isize back to the original one, so that append writes can be
> respected during the buffered fallback.
>
> Normally we rely on lock_and_cleanup_extent_if_needed() function during
> buffered writeback to wait for any existing ordered extents.
>
> But that ordered extent waiting only happens if the start_pos is inside
> the isize.
> Since we have reverted the isize during failed direct IO, we will not
> wait for any ordered extents.
>
> This means we can have a race where the direct IO OE is still in the
> tree, finished but not yet removed, then we're inserting the OE for the
> buffered write, causing the above crash.
>
> [FIX]
> Make the OE wait to be unconditional, to handle the reverted isize
> situation.
>
> And since lock_and_cleanup_extent_if_needed() can no longer turn 0, we
> can also remove the branches that handles no-extent-locked cases.
>
> Reported-by: syzbot+ba2afde329fc27e3f22e@syzkaller.appspotmail.com
> Link: https://syzkaller.appspot.com/bug?extid=3Dba2afde329fc27e3f22e
> Fixes: ff66fe666233 ("btrfs: fix incorrect buffered IO fallback for appen=
d direct writes")
> Signed-off-by: Qu Wenruo <wqu@suse.com>
> ---
>  fs/btrfs/file.c | 77 +++++++++++++++++++------------------------------
>  1 file changed, 30 insertions(+), 47 deletions(-)
>
> diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
> index df8f6f565070..ef31140e0942 100644
> --- a/fs/btrfs/file.c
> +++ b/fs/btrfs/file.c
> @@ -879,7 +879,6 @@ static noinline int prepare_one_folio(struct inode *i=
node, struct folio **folio_
>   *
>   * Return:
>   * 1 - the extent is locked
> - * 0 - the extent is not locked, and everything is OK

So it stops making sense to return 1...
Just change the function to always return 0, meaning the extent range
is locked, or -EAGAIN.

>   * -EAGAIN - need to prepare the folios again
>   */
>  static noinline int
> @@ -889,6 +888,7 @@ lock_and_cleanup_extent_if_need(struct btrfs_inode *i=
node, struct folio *folio,
>                                 struct extent_state **cached_state)
>  {
>         struct btrfs_fs_info *fs_info =3D inode->root->fs_info;
> +       struct btrfs_ordered_extent *ordered;
>         u64 start_pos;
>         u64 last_pos;
>         int ret =3D 0;

Here initialized to 0, but we can never return such value anymore.

> @@ -896,42 +896,38 @@ lock_and_cleanup_extent_if_need(struct btrfs_inode =
*inode, struct folio *folio,
>         start_pos =3D round_down(pos, fs_info->sectorsize);
>         last_pos =3D round_up(pos + write_bytes, fs_info->sectorsize) - 1=
;
>
> -       if (start_pos < inode->vfs_inode.i_size) {
> -               struct btrfs_ordered_extent *ordered;
> -
> -               if (nowait) {
> -                       if (!btrfs_try_lock_extent(&inode->io_tree, start=
_pos,
> -                                                  last_pos, cached_state=
)) {
> -                               folio_unlock(folio);
> -                               folio_put(folio);
> -                               return -EAGAIN;
> -                       }
> -               } else {
> -                       btrfs_lock_extent(&inode->io_tree, start_pos, las=
t_pos,
> -                                         cached_state);
> -               }
> -
> -               ordered =3D btrfs_lookup_ordered_range(inode, start_pos,
> -                                                    last_pos - start_pos=
 + 1);
> -               if (ordered &&
> -                   ordered->file_offset + ordered->num_bytes > start_pos=
 &&
> -                   ordered->file_offset <=3D last_pos) {
> -                       btrfs_unlock_extent(&inode->io_tree, start_pos, l=
ast_pos,
> -                                           cached_state);
> +       if (nowait) {
> +               if (!btrfs_try_lock_extent(&inode->io_tree, start_pos,
> +                                          last_pos, cached_state)) {
>                         folio_unlock(folio);
>                         folio_put(folio);
> -                       btrfs_start_ordered_extent(ordered);
> -                       btrfs_put_ordered_extent(ordered);
>                         return -EAGAIN;
>                 }
> -               if (ordered)
> -                       btrfs_put_ordered_extent(ordered);
> -
> -               *lockstart =3D start_pos;
> -               *lockend =3D last_pos;
> -               ret =3D 1;
> +       } else {
> +               btrfs_lock_extent(&inode->io_tree, start_pos, last_pos,
> +                                 cached_state);
>         }
>
> +       ordered =3D btrfs_lookup_ordered_range(inode, start_pos,
> +                                            last_pos - start_pos + 1);
> +       if (ordered &&
> +           ordered->file_offset + ordered->num_bytes > start_pos &&
> +           ordered->file_offset <=3D last_pos) {
> +               btrfs_unlock_extent(&inode->io_tree, start_pos, last_pos,
> +                                   cached_state);
> +               folio_unlock(folio);
> +               folio_put(folio);
> +               btrfs_start_ordered_extent(ordered);
> +               btrfs_put_ordered_extent(ordered);
> +               return -EAGAIN;
> +       }
> +       if (ordered)
> +               btrfs_put_ordered_extent(ordered);
> +
> +       *lockstart =3D start_pos;
> +       *lockend =3D last_pos;
> +       ret =3D 1;

And this is pointless, right below we can use "return 1;" and get rid
of the 'ret' variable.

Since returning 1 no longer makes sense, just make it return 0 and remove '=
ret'.

Also in the caller, since lock_and_cleanup_extent_if_need() now always
returns with the extent range locked, we can get rid of it's local
variable named 'extents_locked' and use 'ret' as it does not make
sense anymore.

Finally, with this change we now always look for ordered extents and
lock the range. Previously, we only did this if writes were within
i_size - which makes sense because, except for his new direct IO case
falling back to buffered IO, we could never find ordered extents
beyond i_size.

Have you checked whether performance is affected?

Thanks.

> +
>         /*
>          * We should be called after prepare_one_folio() which should hav=
e locked
>          * all pages in the range.
> @@ -1288,11 +1284,8 @@ static int copy_one_range(struct btrfs_inode *inod=
e, struct iov_iter *iter,
>
>                 /* No copied bytes, unlock, release reserved space and ex=
it. */
>                 if (copied =3D=3D 0) {
> -                       if (extents_locked)
> -                               btrfs_unlock_extent(&inode->io_tree, lock=
start, lockend,
> -                                                   &cached_state);
> -                       else
> -                               btrfs_free_extent_state(cached_state);
> +                       btrfs_unlock_extent(&inode->io_tree, lockstart, l=
ockend,
> +                                           &cached_state);
>                         btrfs_delalloc_release_extents(inode, reserved_le=
n);
>                         release_space(inode, *data_reserved, reserved_sta=
rt, reserved_len,
>                                       only_release_metadata);
> @@ -1311,17 +1304,7 @@ static int copy_one_range(struct btrfs_inode *inod=
e, struct iov_iter *iter,
>
>         ret =3D btrfs_dirty_folio(inode, folio, start, copied, &cached_st=
ate,
>                                 only_release_metadata);
> -       /*
> -        * If we have not locked the extent range, because the range's st=
art
> -        * offset is >=3D i_size, we might still have a non-NULL cached e=
xtent
> -        * state, acquired while marking the extent range as delalloc thr=
ough
> -        * btrfs_dirty_page(). Therefore free any possible cached extent =
state
> -        * to avoid a memory leak.
> -        */
> -       if (extents_locked)
> -               btrfs_unlock_extent(&inode->io_tree, lockstart, lockend, =
&cached_state);
> -       else
> -               btrfs_free_extent_state(cached_state);
> +       btrfs_unlock_extent(&inode->io_tree, lockstart, lockend, &cached_=
state);
>
>         btrfs_delalloc_release_extents(inode, reserved_len);
>         if (ret) {
> --
> 2.54.0
>
>
