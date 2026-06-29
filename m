Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D92453BB4A
	for <linux-btrfs@vger.kernel.org>; Mon, 29 Jun 2026 12:12:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782735122; cv=none; b=KOBJwHASyD2Kls933nVaorTUfTC9CNxMM/iEYrCxKX52cNKlVJCMTwDoDXWr/NiFE1d/6WokdrDv7Ps1U0c668XByn7TfafAOPp7kcuL6oNcCyMDed92862Ww22GLMoOQu9Y+IoKp1mWaFl4XDqwfBO156jX0hPSDpcgjA2jyvM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782735122; c=relaxed/simple;
	bh=ApiQIkYRaA+eonQW02MuFYhJeF9zrXlF6e01TBxgb3s=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=uAcxrPUO007mzgyOJHh3tLwwFsOzntlX0ih1Ona1qGxmwDmlEKsXPP9ACGa1vdC0wb0MV6byXznztn6ZYHnAUWPxDQsBJ384BrxigrA0vN4Nsww8FZrlEHPjNxC+mBsSw5M8bsRPl2rycUYjpAKLlaP815zmYN5WwJpNTyWXfvg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AsmgnnnF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AsmgnnnF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 704621F00AC4
	for <linux-btrfs@vger.kernel.org>; Mon, 29 Jun 2026 12:12:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782735120;
	bh=W78s1NRc452tFoGuJIGNMahSTwg3n0CVvhlAnob50kY=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=AsmgnnnFmAChqE/KUAmJE97X/Xyht+NhIx3NC5RsumFyhGRzhgGepJsPY+UFrpLzR
	 HJWY/HqtprC16pbbFVhRKcLqrqE6Q3smhdP5zHRxtOrqAlXHZaw+kZdDA/T74unFuC
	 pFM41EowQggjqupoq2YKXx/zzg7THSMoPBdpvfmplFb6aMmpahACG7+8pk0023sRar
	 MjTMpTwxUs1/vXSOCEF75x5irPd7uQ+dPobDFUnsKOs4G+IrsIOe0aePtpdQHf+62v
	 apFzkROjJ/F4X1gHYluCXfCY/bJLGYQC2fcBMdEVZ4yLvgf4bsj6tSwjJXhMLqNkcL
	 V9rg4Anvidt6Q==
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-697edb1bf6eso4717422a12.1
        for <linux-btrfs@vger.kernel.org>; Mon, 29 Jun 2026 05:12:00 -0700 (PDT)
X-Gm-Message-State: AOJu0YyaeSQ1763OVo+rcyjvswKjXkmUw9oSqwdfcHd+5WmDuQpOVwtZ
	vAk8SuGaOn7CG4339T5zhVEhDRxj+6fOS8Z6TEd5sYzDLLIIouwTblkJ7nJYPQnrRUMEegF1U2n
	FD3BxtLyaqOSH46xutKGgMPZwOuwnSv4=
X-Received: by 2002:a17:907:934b:b0:c11:f9d1:6263 with SMTP id
 a640c23a62f3a-c120617b800mr883180166b.47.1782735118970; Mon, 29 Jun 2026
 05:11:58 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <9c7c44767a2f1b94dc46626e81e2efd9cbd67824.1782516739.git.wqu@suse.com>
In-Reply-To: <9c7c44767a2f1b94dc46626e81e2efd9cbd67824.1782516739.git.wqu@suse.com>
From: Filipe Manana <fdmanana@kernel.org>
Date: Mon, 29 Jun 2026 13:11:20 +0100
X-Gmail-Original-Message-ID: <CAL3q7H48BRoE9D-4CeADdiA-503dF6ObM-Lb_gSFkRhW95=sHw@mail.gmail.com>
X-Gm-Features: AVVi8Cdfg7e5qW2w7SYvbbwEgc1uIfhgJrOwraod-N4t_Gaw5iuVQZ_XsD3h16w
Message-ID: <CAL3q7H48BRoE9D-4CeADdiA-503dF6ObM-Lb_gSFkRhW95=sHw@mail.gmail.com>
Subject: Re: [PATCH v2] btrfs: always wait for ordered extents to avoid OE races
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org, 
	syzbot+ba2afde329fc27e3f22e@syzkaller.appspotmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Jun 27, 2026 at 12:32=E2=80=AFAM Qu Wenruo <wqu@suse.com> wrote:
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
> Normally we rely on lock_and_cleanup_extent_if_need() function during
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
> And since lock_and_cleanup_extent_if_need() now either lock the
> extents or return -EAGAIN, also remove the branches that handles
> no-extent-locked cases, and rename it to remove the "_if_need" suffix.
>
> The following micro benchmark shows the runtime difference for
> btrfs_buffered_write(), doing `xfs_io -f -c "pwrite 0 1m"` workload,
> all values are the average runtime in nano seconds.
>
>       function runtime              |   before    |     after
>  -----------------------------------+-------------+---------------
>  lock_and_cleanup_extent_if_need()  |     58.2    |    183.0
>  btrfs_buffered_write()             |   2115.6    |   2973.3
>
> The overall runtime of btrfs_buffered_write() is still pretty
> tiny (still less than 3 micro seconds), I'd say the extra cost is still
> acceptable.
>
> An alternative to fix this problem is to wait ordered extents during
> iomap_end() where the isize revert is done.
>
> But that solution will break nowait requirement, as if a nowait direct
> IO finished short, we have to wait for the OEs unconditionally or the
> next append buffered IO can still hit the same problem.
>
> So here we have to move the wait cost to buffered write, but at least
> the code is slightly more streamline.
>
> Reported-by: syzbot+ba2afde329fc27e3f22e@syzkaller.appspotmail.com
> Link: https://syzkaller.appspot.com/bug?extid=3Dba2afde329fc27e3f22e
> Fixes: ff66fe666233 ("btrfs: fix incorrect buffered IO fallback for appen=
d direct writes")
> Signed-off-by: Qu Wenruo <wqu@suse.com>

Reviewed-by: Filipe Manana <fdmanana@suse.com>

Looks good now, thanks.

> ---
> Changelog:
> v2:
> - Further cleanup the handling of lock_and_cleanup_extent_if_need()
>   As it no longer return without locking extents, cleanup the caller
>   furthermore to remove unnecessary local variables.
>
> - Add a micro bench mark for the performance impact
>
> - Explain why we have to do the wait inside buffered write not
>   in direct write path
> ---
>  fs/btrfs/file.c | 104 +++++++++++++++++++-----------------------------
>  1 file changed, 41 insertions(+), 63 deletions(-)
>
> diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
> index df8f6f565070..62f41314df04 100644
> --- a/fs/btrfs/file.c
> +++ b/fs/btrfs/file.c
> @@ -875,70 +875,64 @@ static noinline int prepare_one_folio(struct inode =
*inode, struct folio **folio_
>
>  /*
>   * Locks the extent and properly waits for data=3Dordered extents to fin=
ish
> - * before allowing the folios to be modified if need.
> + * before allowing the folios to be modified.
>   *
>   * Return:
> - * 1 - the extent is locked
> - * 0 - the extent is not locked, and everything is OK
> + * 0 - the extent is locked
>   * -EAGAIN - need to prepare the folios again
>   */
>  static noinline int
> -lock_and_cleanup_extent_if_need(struct btrfs_inode *inode, struct folio =
*folio,
> -                               loff_t pos, size_t write_bytes,
> -                               u64 *lockstart, u64 *lockend, bool nowait=
,
> -                               struct extent_state **cached_state)
> +lock_and_cleanup_extent(struct btrfs_inode *inode, struct folio *folio,
> +                       loff_t pos, size_t write_bytes,
> +                       u64 *lockstart, u64 *lockend, bool nowait,
> +                       struct extent_state **cached_state)
>  {
>         struct btrfs_fs_info *fs_info =3D inode->root->fs_info;
> +       struct btrfs_ordered_extent *ordered;
>         u64 start_pos;
>         u64 last_pos;
> -       int ret =3D 0;
>
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
> +
>         /*
>          * We should be called after prepare_one_folio() which should hav=
e locked
>          * all pages in the range.
>          */
>         WARN_ON(!folio_test_locked(folio));
>
> -       return ret;
> +       return 0;
>  }
>
>  /*
> @@ -1195,7 +1189,6 @@ static int copy_one_range(struct btrfs_inode *inode=
, struct iov_iter *iter,
>         const u64 reserved_start =3D round_down(start, fs_info->sectorsiz=
e);
>         u64 reserved_len;
>         struct folio *folio =3D NULL;
> -       int extents_locked;
>         u64 lockstart;
>         u64 lockend;
>         bool only_release_metadata =3D false;
> @@ -1253,18 +1246,16 @@ static int copy_one_range(struct btrfs_inode *ino=
de, struct iov_iter *iter,
>                 reserved_len =3D last_block - reserved_start;
>         }
>
> -       extents_locked =3D lock_and_cleanup_extent_if_need(inode, folio, =
start,
> -                                                        write_bytes, &lo=
ckstart,
> -                                                        &lockend, nowait=
,
> -                                                        &cached_state);
> -       if (extents_locked < 0) {
> -               if (!nowait && extents_locked =3D=3D -EAGAIN)
> +       ret =3D lock_and_cleanup_extent(inode, folio, start, write_bytes,
> +                                     &lockstart, &lockend, nowait, &cach=
ed_state);
> +       if (ret < 0) {
> +               if (!nowait)
>                         goto again;
>
>                 btrfs_delalloc_release_extents(inode, reserved_len);
>                 release_space(inode, *data_reserved, reserved_start, rese=
rved_len,
>                               only_release_metadata);
> -               return extents_locked;
> +               return ret;
>         }
>
>         copied =3D copy_folio_from_iter_atomic(folio, offset_in_folio(fol=
io, start),
> @@ -1288,11 +1279,8 @@ static int copy_one_range(struct btrfs_inode *inod=
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
> @@ -1311,17 +1299,7 @@ static int copy_one_range(struct btrfs_inode *inod=
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
