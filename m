Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DEE93CF68C
	for <linux-btrfs@vger.kernel.org>; Mon, 20 Apr 2026 14:25:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776695114; cv=none; b=cZqw9fJZxGUC8bCBqQtE4D5Y2zVXKhId0J/o3Cb9IPbmraCoJw9u/cG0vNeArLT3Bs14UkL0hRT8DzgVxXLi2P2C1CVr0AZ17KMd1ickQquuTtsZe7sirQI1uKOGbyfDNukuzpV9pTeMETxMWLfctcPNHKYGMYeWQiaexqbefWE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776695114; c=relaxed/simple;
	bh=7pHAUW45jkeiisjDLmrS/eMT1lBDoot/PNN8OVFMH2k=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=rRxMWdZDMvWo1msX534JioHUo+2vOwofuUWkbiEOH3A3fa4lknYW/KGcuYb75Lvo+hSiCAlp+Qqtgtu73n3xEj1j8rmWuTL5C7qG3PhIN695U+C4Z+vxZEHTISzXdK6npDd5XoHR6C2g1vhk0K+mtzWYw46JYoT6rCp9p6wflWg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ngfLncbl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ngfLncbl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40E22C19425
	for <linux-btrfs@vger.kernel.org>; Mon, 20 Apr 2026 14:25:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776695114;
	bh=7pHAUW45jkeiisjDLmrS/eMT1lBDoot/PNN8OVFMH2k=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=ngfLncblfp1K0UYVmBii3p3QyngfeIviuQtail2pZ8uBVudNNegECiUy4d/By/4iJ
	 von+DJ1K2N/02P8lvRAVIODEJyS3IZwstlWpnHkmzPv2xcmmV/sM+OrugZMl7fZDNK
	 IDHCFOpi3Ki3umXoDaI9Rq6PJyS+MS7Jh7xjT6sbYwvtB/30dSQa17cF3RYZWu8/Sw
	 MmYgMfDz8V3ijMURcypKXQxlujgtCvQKKN3CfGMKp5Gr6ophrOcip93tGpk2PYuKsG
	 I6366VAw66fSbnxIUTky7/6g5ybWYbkefNJdxS+mDFc6Jzh1e2QpJgxap2ZqBWZOHF
	 Yn3fkSPbb3VDA==
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-b932fe2e1a7so441780266b.1
        for <linux-btrfs@vger.kernel.org>; Mon, 20 Apr 2026 07:25:14 -0700 (PDT)
X-Gm-Message-State: AOJu0Ywl/TWnvGtSrw1VVVfDRH9ur/bzedRpovOc1oj9vnn3fK8r/B2q
	uvICIFrqAX/TijjXKGLX2Du+z/w89y9ZmuLWd32kquWcs9VlQUXGjBw8eAk1RE164yMUW3Ok5Ml
	pFRQoFHS0oOU9nJPP0L3zmjYHwd6dD6c=
X-Received: by 2002:a17:907:6d19:b0:ba4:ea47:5a2b with SMTP id
 a640c23a62f3a-ba4ea47b226mr533889466b.43.1776695112708; Mon, 20 Apr 2026
 07:25:12 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <9941e0c488a0229ac9005bb0fb977823ee428ddb.1776685790.git.wqu@suse.com>
In-Reply-To: <9941e0c488a0229ac9005bb0fb977823ee428ddb.1776685790.git.wqu@suse.com>
From: Filipe Manana <fdmanana@kernel.org>
Date: Mon, 20 Apr 2026 15:24:35 +0100
X-Gmail-Original-Message-ID: <CAL3q7H7BPxykccZUR4x2uOMA7gs1mf=pGz9Z-WxyENnPeb9WKw@mail.gmail.com>
X-Gm-Features: AQROBzCuc-XAJbm9X3rmTY_3AttIlNz5RqQBXpsbgGBQaSCMjH8cLYD7-hd3rRA
Message-ID: <CAL3q7H7BPxykccZUR4x2uOMA7gs1mf=pGz9Z-WxyENnPeb9WKw@mail.gmail.com>
Subject: Re: [PATCH v2] btrfs: check and set EXTENT_DELALLOC_NEW before
 clearing EXTENT_DELALLOC
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Apr 20, 2026 at 12:51=E2=80=AFPM Qu Wenruo <wqu@suse.com> wrote:
>
> [WARNING]
> When running test cases with injected errors or shutdown, e.g.
> generic/388 or generic/475, there is a chance that the following kernel
> warning is triggered:
>
>  BTRFS info (device dm-2): first mount of filesystem d8a19a28-3232-4809-b=
0df-38df83e71bff
>  BTRFS info (device dm-2): using crc32c checksum algorithm
>  BTRFS info (device dm-2): checking UUID tree
>  BTRFS info (device dm-2): turning on async discard
>  BTRFS info (device dm-2): enabling free space tree
>  BTRFS critical (device dm-2 state E): emergency shutdown
>  ------------[ cut here ]------------
>  WARNING: extent_io.c:1742 at extent_writepage_io+0x437/0x520 [btrfs], CP=
U#2: kworker/u43:2/651591
>  CPU: 2 UID: 0 PID: 651591 Comm: kworker/u43:2 Tainted: G        W  OE   =
    7.0.0-rc6-custom+ #365 PREEMPT(full)  5804053f02137e627472d94b5128cc9fc=
b110e88
>  RIP: 0010:extent_writepage_io+0x437/0x520 [btrfs]
>  Call Trace:
>   <TASK>
>   extent_write_cache_pages+0x2a5/0x820 [btrfs 70299925d0856939e93b17d4806=
51713b3cbba58]
>   btrfs_writepages+0x74/0x130 [btrfs 70299925d0856939e93b17d480651713b3cb=
ba58]
>   do_writepages+0xd0/0x160
>   __writeback_single_inode+0x42/0x340
>   writeback_sb_inodes+0x22d/0x580
>   wb_writeback+0xc6/0x360
>   wb_workfn+0xbd/0x470
>   process_one_work+0x198/0x3b0
>   worker_thread+0x1c8/0x330
>   kthread+0xee/0x120
>   ret_from_fork+0x2a6/0x330
>   ret_from_fork_asm+0x11/0x20
>   </TASK>
>  ---[ end trace 0000000000000000 ]---
>  BTRFS error (device dm-2 state E): root 5 ino 259 folio 1323008 is marke=
d dirty without notifying the fs
>  BTRFS error (device dm-2 state E): failed to submit blocks, root=3D5 ino=
de=3D259 folio=3D1323008 submit_bitmap=3D0: -117
>  BTRFS info (device dm-2 state E): last unmount of filesystem d8a19a28-32=
32-4809-b0df-38df83e71bff
>
> [CAUSE]
> Inside btrfs we have the following pattern in several locations, for
> example inside btrfs_dirty_folio():
>
>         btrfs_clear_extent_bit(&inode->io_tree, start_pos, end_of_last_bl=
ock,
>                                EXTENT_DELALLOC | EXTENT_DO_ACCOUNTING | E=
XTENT_DEFRAG,
>                                cached);
>
>         ret =3D btrfs_set_extent_delalloc(inode, start_pos, end_of_last_b=
lock,
>                                         extra_bits, cached);
>         if (ret)
>                 return ret;
>
> However btrfs_set_extent_delalloc() can return IO errors other than -ENOM=
EM
> through the following callchain:
>
>  btrfs_set_extent_delalloc()
>  \- btrfs_find_new_delalloc_bytes()
>     \- btrfs_get_extent()
>        \- btrfs_lookup_file_extent()
>           \- btrfs_search_slot()
>
> When such IO error happened, the previous btrfs_clear_extent_bit() has
> cleared the EXTENT_DELALLOC for the range, and we're expecting
> btrfs_set_extent_delalloc() to re-set EXTENT_DELALLOC.
>
> But since btrfs_set_extent_delalloc() failed before
> btrfs_set_extent_bit(), EXTENT_DELALLOC flag is no longere present.

longere -> longer

>
> And if the folio range is dirty before entering
> btrfs_set_extent_delalloc(), we got a dirty folio but no EXTENT_DELALLOC
> flag now.
>
> Then we hit the folio writeback:
>
>  extent_writepage()
>  |- writepage_delalloc()
>  |  No ordered extent is created, as there is no EXTENT_DELALLOC set
>  |  for the folio range.
>  |  This also means the folio has no ordered flag set.
>  |
>  |- extent_writepage_io()
>     \- if (unlikely(!folio_test_ordered(folio))
>        Now we hit the warning.
>
> [FIX]
> Introduce a new helper, btrfs_reset_extent_delalloc() to replace the
> currently open-coded btrfs_clear_extent_bit() +
> btrfs_set_extent_delalloc() combination.
>
> Instead of calling btrfs_clear_extent_bit() first, update
> EXTENT_DELALLOC_NEW first, as that part can fail due to metadata IO,
> meanwhile btrfs_clear_extent_bit() and btrfs_set_extent_bit() can really
> only fail with -ENOMEM.

No, they don't fail with -ENOMEM. They keep looping until allocation succee=
ds.

Boris also misunderstood this recently, see:

https://lore.kernel.org/linux-btrfs/CAL3q7H7v-9M485_svy_5BCaWVaf+61DvFB6gMU=
EWhR=3D2ykM+qw@mail.gmail.com/

So please correct that statement.

>
> This allows us to fail early without clearing EXTENT_DELALLOC bit, so
> even if that new btrfs_reset_extent_delalloc() failed before touching
> EXTENT_DELALLOC, the existing dirty range will still have their old
> EXTENT_DELALLOC flag present, thus avoid the warning.
>
> Cc: stable@vger.kernel.org # 6.1+
> Signed-off-by: Qu Wenruo <wqu@suse.com>
> ---
> Changelog:
> v2:
> - Use NULL as @cached_extent for btrfs_find_new_delalloc_bytes()
>   Unlike later btrfs_clear_extent_bit(), btrfs_find_new_delalloc_bytes()
>   can hit several different extent maps and update @cached_state.
>
>   This makes later btrfs_set/clear_extent_bit() to discard the cache,
>   making the original optimization less useful.
> ---
>  fs/btrfs/btrfs_inode.h |  3 +++
>  fs/btrfs/file.c        | 25 +++---------------
>  fs/btrfs/inode.c       | 58 +++++++++++++++++++++++++++++++++++++-----
>  fs/btrfs/reflink.c     |  4 +--
>  4 files changed, 58 insertions(+), 32 deletions(-)
>
> diff --git a/fs/btrfs/btrfs_inode.h b/fs/btrfs/btrfs_inode.h
> index 6e696b350dc5..ad523549d8b4 100644
> --- a/fs/btrfs/btrfs_inode.h
> +++ b/fs/btrfs/btrfs_inode.h
> @@ -569,6 +569,9 @@ int btrfs_start_delalloc_roots(struct btrfs_fs_info *=
fs_info, long nr,
>  int btrfs_set_extent_delalloc(struct btrfs_inode *inode, u64 start, u64 =
end,
>                               unsigned int extra_bits,
>                               struct extent_state **cached_state);
> +int btrfs_reset_extent_delalloc(struct btrfs_inode *inode, u64 start, u6=
4 end,
> +                               unsigned int extra_bits,
> +                               struct extent_state **cached_state);
>
>  struct btrfs_new_inode_args {
>         /* Input */
> diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
> index a6f641a41d99..ab536a304500 100644
> --- a/fs/btrfs/file.c
> +++ b/fs/btrfs/file.c
> @@ -85,16 +85,8 @@ int btrfs_dirty_folio(struct btrfs_inode *inode, struc=
t folio *folio, loff_t pos
>
>         end_of_last_block =3D start_pos + num_bytes - 1;
>
> -       /*
> -        * The pages may have already been dirty, clear out old accountin=
g so
> -        * we can set things up properly
> -        */
> -       btrfs_clear_extent_bit(&inode->io_tree, start_pos, end_of_last_bl=
ock,
> -                              EXTENT_DELALLOC | EXTENT_DO_ACCOUNTING | E=
XTENT_DEFRAG,
> -                              cached);
> -
> -       ret =3D btrfs_set_extent_delalloc(inode, start_pos, end_of_last_b=
lock,
> -                                       extra_bits, cached);
> +       ret =3D btrfs_reset_extent_delalloc(inode, start_pos, end_of_last=
_block,
> +                                         extra_bits, cached);
>         if (ret)
>                 return ret;
>
> @@ -1952,18 +1944,7 @@ static vm_fault_t btrfs_page_mkwrite(struct vm_fau=
lt *vmf)
>                 }
>         }
>
> -       /*
> -        * page_mkwrite gets called when the page is firstly dirtied afte=
r it's
> -        * faulted in, but write(2) could also dirty a page and set delal=
loc
> -        * bits, thus in this case for space account reason, we still nee=
d to
> -        * clear any delalloc bits within this page range since we have t=
o
> -        * reserve data&meta space before lock_page() (see above comments=
).
> -        */
> -       btrfs_clear_extent_bit(io_tree, page_start, end,
> -                              EXTENT_DELALLOC | EXTENT_DO_ACCOUNTING |
> -                              EXTENT_DEFRAG, &cached_state);
> -
> -       ret =3D btrfs_set_extent_delalloc(inode, page_start, end, 0, &cac=
hed_state);
> +       ret =3D btrfs_reset_extent_delalloc(inode, page_start, end, 0, &c=
ached_state);
>         if (ret < 0) {
>                 btrfs_unlock_extent(io_tree, page_start, page_end, &cache=
d_state);
>                 goto out_unlock;
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index 71129502333a..ec2300698a6a 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -2810,7 +2810,10 @@ int btrfs_set_extent_delalloc(struct btrfs_inode *=
inode, u64 start, u64 end,
>                               unsigned int extra_bits,
>                               struct extent_state **cached_state)
>  {
> -       WARN_ON(PAGE_ALIGNED(end));
> +       const u32 blocksize =3D inode->root->fs_info->sectorsize;
> +
> +       ASSERT(IS_ALIGNED(start, blocksize), "start=3D%llu", start);
> +       ASSERT(IS_ALIGNED(end + 1, blocksize), "end=3D%llu", end);

When not print blocksize too? It's useful.

>
>         if (start >=3D i_size_read(&inode->vfs_inode) &&
>             !(inode->flags & BTRFS_INODE_PREALLOC)) {
> @@ -2833,6 +2836,52 @@ int btrfs_set_extent_delalloc(struct btrfs_inode *=
inode, u64 start, u64 end,
>                                     EXTENT_DELALLOC | extra_bits, cached_=
state);
>  }
>
> +/*
> + * Clear the old accounting flags and set EXTENT_DELALLOC for the range.
> + *
> + * Return <0 for error, in that case no range has EXTENT_DELALLOC bit cl=
eared or set.
> + */
> +int btrfs_reset_extent_delalloc(struct btrfs_inode *inode, u64 start, u6=
4 end,
> +                               unsigned int extra_bits,
> +                               struct extent_state **cached_state)
> +{
> +       const u32 blocksize =3D inode->root->fs_info->sectorsize;
> +
> +       /* The @extra_bits can only be EXTENT_NORESERVE for now. */
> +       ASSERT(!(extra_bits & ~EXTENT_NORESERVE));

Please make the assert verbose to print extra_bits in hex too.

> +
> +       /* Basic alignment check. */
> +       ASSERT(IS_ALIGNED(start, blocksize), "start=3D%llu", start);
> +       ASSERT(IS_ALIGNED(end + 1, blocksize), "end=3D%llu", end);

Same here, printing blocksize is useful.

> +
> +       /*
> +        * Check and set DELALLOC_NEW flags, this needs to search tree th=
us

flags -> flag (it's just one).

> +        * can fail early.
> +        * Thus we want to do this before clearing DELALLOC_EXTENT.

DELALLOC_EXTENT -> EXTENT_DELALLOC

Otherwise it looks fine, and with those small things addressed:

Reviewed-by: Filipe Manana <fdmanana@suse.com>

Thanks.

> +        */
> +       if (start >=3D i_size_read(&inode->vfs_inode) &&
> +           !(inode->flags & BTRFS_INODE_PREALLOC)) {
> +               /*
> +                * There can't be any extents following eof in this case =
so just
> +                * set the delalloc new bit for the range directly.
> +                */
> +               extra_bits |=3D EXTENT_DELALLOC_NEW;
> +       } else {
> +               int ret;
> +
> +               ret =3D btrfs_find_new_delalloc_bytes(inode, start, end +=
 1 - start,
> +                                                   NULL);
> +               if (unlikely(ret))
> +                       return ret;
> +       }
> +       /* Clear the old accounting as the range may already be dirty. */
> +       btrfs_clear_extent_bit(&inode->io_tree, start, end,
> +                              EXTENT_DELALLOC | EXTENT_DO_ACCOUNTING |
> +                              EXTENT_DEFRAG, cached_state);
> +       return btrfs_set_extent_bit(&inode->io_tree, start, end,
> +                                   EXTENT_DELALLOC | extra_bits, cached_=
state);
> +}
> +
>  static int insert_reserved_file_extent(struct btrfs_trans_handle *trans,
>                                        struct btrfs_inode *inode, u64 fil=
e_pos,
>                                        struct btrfs_file_extent_item *sta=
ck_fi,
> @@ -4973,12 +5022,7 @@ int btrfs_truncate_block(struct btrfs_inode *inode=
, u64 offset, u64 start, u64 e
>                 goto again;
>         }
>
> -       btrfs_clear_extent_bit(&inode->io_tree, block_start, block_end,
> -                              EXTENT_DELALLOC | EXTENT_DO_ACCOUNTING | E=
XTENT_DEFRAG,
> -                              &cached_state);
> -
> -       ret =3D btrfs_set_extent_delalloc(inode, block_start, block_end, =
0,
> -                                       &cached_state);
> +       ret =3D btrfs_reset_extent_delalloc(inode, block_start, block_end=
, 0, &cached_state);
>         if (ret) {
>                 btrfs_unlock_extent(io_tree, block_start, block_end, &cac=
hed_state);
>                 goto out_unlock;
> diff --git a/fs/btrfs/reflink.c b/fs/btrfs/reflink.c
> index 14742abe0f92..fb34598a77ff 100644
> --- a/fs/btrfs/reflink.c
> +++ b/fs/btrfs/reflink.c
> @@ -94,9 +94,7 @@ static int copy_inline_to_page(struct btrfs_inode *inod=
e,
>         if (ret < 0)
>                 goto out_unlock;
>
> -       btrfs_clear_extent_bit(&inode->io_tree, file_offset, range_end,
> -                              EXTENT_DELALLOC | EXTENT_DO_ACCOUNTING | E=
XTENT_DEFRAG, NULL);
> -       ret =3D btrfs_set_extent_delalloc(inode, file_offset, range_end, =
0, NULL);
> +       ret =3D btrfs_reset_extent_delalloc(inode, file_offset, range_end=
, 0, NULL);
>         if (ret)
>                 goto out_unlock;
>
> --
> 2.53.0
>
>
