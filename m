Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793989356;
	b=gF7uAWbmeZzCo9tWJHgxaUBobpYUcXeBHL5N25aiNpD/2PV7SlVDWRqa1tjc4pyvFSSE
	 N5b07veUCVwqtVOYATsjTmPppCR14GkwVMs5ySdKuJg7E/XaXv6M68va84NMpLj+00FSC
	 mEfnIEz74DLB3V1nnh8BVLRqfIhHDI5aWAaHU1ppipEHg4gPIyzH/SwR/MGGsGi2Or7QJ
	 fhTC7Y7SI4BXdGwuDOeEZrGQ/V8xs/fX6/l650WPt1romKclnIMxvaZvT7y6A//VdG5Ec
	 k6jZxEauB7XRYNMOqCbpyY3h/+qMCEZvjpSUykM3u5Xz4vogAB+l8/z0bh3Qdejn5Aw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793989356;
	h=Received:DKIM-Signature:Received:X-Gm-Message-State:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:
	 X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:Subject:To:Cc:
	 Content-Type:Content-Transfer-Encoding;
	bh=MUUdH0p417yxZEhr0FFyZlfNJvYIx5aVRmhct5nE8rE=;
	b=JTwE6amrSTyU6a2HiP9SkZpm/ujR5Qw/bOvjhjOMGebZDnV1HN/JEb6BP8ifczgTj0Od
	 6RMCB9GgdUnsFooJV5zPOHYRnZti/4oiGNVA+CvxZsKQmWvuE/zhEByOX51mZ1yuhBahY
	 AcRHjUhVv6b1V/NxLAte8IylNSj8VSmjlk6jqO2ff7BGfj1wB9SM0/N8NBbgvdHnw9agY
	 pAn/PPu1DumyIHeV5M4ky/jv5Oa/bPRE7HgooMpsdGxFxrS+qbLSW73r9vYDRF7+Cwavb
	 qiiFsj/5aWH7f3xmEu+nczjUK5xrxjUjYfBBU9dRjHs3OIUe9s0nc4usjcvRkow5Z0g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=l8x+d7FG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 787FA606A32D
	for <linux-btrfs@vger.kernel.org>; Fri,  6 Nov 2026 18:22:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=l8x+d7FG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1627E1F008A3
	for <linux-btrfs@vger.kernel.org>; Fri,  6 Nov 2026 18:22:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793989356;
	bh=MUUdH0p417yxZEhr0FFyZlfNJvYIx5aVRmhct5nE8rE=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=l8x+d7FGivQZhvGgboKBYo0zdZV186ufY2Y6K9Po0qk1EIco821FYS80bOW/x8MsD
	 hEiebw+ya2i326sxFHQuAjr3EPZSy1AKdGewAKLkBwW/yVRJJYIEF7BzT36MUSOQI/
	 45oIg7TIdoSVMn7msISimGDqLrgloSVjVeHVjSd7oyIyymq5COL0ddphg4VfMCs8/2
	 NdXc4NoEaUmWuLm1rkfZ1AyJCJOgMcNu1993Zj7PMwFveugQgoBHbvWeWZmzT7I5WZ
	 9SU2/7ahdWi80OmBjuiEH5Yarp6V2GoEDpi+pb+iYGZEyz9J9GETFTskKL1mSNVl8G
	 XCLM2VbvkzrUA==
Received: by mail-vs1-f46.google.com with SMTP id ada2fe7eead31-78fb1fb9508so1602469137.1
        for <linux-btrfs@vger.kernel.org>; Fri, 06 Nov 2026 10:22:36 -0800 (PST)
X-Gm-Message-State: APuU4Z8hMBnApUxTISisiOl6+S9oGCw4V406NFE5A82jUQmUu+0p4xpP
	QWa5TxgBdGLzlG58BeEuZAH6IeXOWD2uYh04JRL5t/Nisqx7xCBKZZN4/xTbEh0FaY29sGUupJx
	LsJXqAwCBFdSVfsfNTRJxBDnJSptRiaQ=
X-Received: by 2002:a05:6102:3e83:b0:7b3:5b2f:7030 with SMTP id
 ada2fe7eead31-7d286744c22mr3009658137.4.1793989355152; Fri, 06 Nov 2026
 10:22:35 -0800 (PST)
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <38f007be87d8d8889912b9be373460e32741b9b5.1793840873.git.wqu@suse.com>
In-Reply-To: <38f007be87d8d8889912b9be373460e32741b9b5.1793840873.git.wqu@suse.com>
From: Filipe Manana <fdmanana@kernel.org>
Date: Fri, 6 Nov 2026 18:21:58 +0000
X-Gmail-Original-Message-ID: <CAL3q7H5LGc7CDZH7JU_Qe-LSUhfnfDjvF0+ksAAUqLoAiG4Fow@mail.gmail.com>
X-Gm-Features: AclHuK_FL3b29uB5dEd_xpd33m05mMl6GeKtFJHsbppTeHvtgw495emqLodezEc
Message-ID: <CAL3q7H5LGc7CDZH7JU_Qe-LSUhfnfDjvF0+ksAAUqLoAiG4Fow@mail.gmail.com>
Subject: Re: [PATCH] btrfs: fix a race between reflink and compressed writes
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org, Breno Leitao <leitao@debian.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 5, 2026 at 1:08=E2=80=AFAM Qu Wenruo <wqu@suse.com> wrote:
>
> [BUG]
> There is a bug report with a reproduce that can lead to transaction

reproduce -> reproducer

> abort. The reproducer requires either large folios or page size larger
> than block size and compression:
>
>  BTRFS info (device dm-2): use zstd compression, level 3
>  ------------[ cut here ]------------
>  WARNING: fs/btrfs/extent_map.c:443 at btrfs_unpin_extent_cache+0x12a/0x1=
a0 [btrfs], CPU#0: kworker/u41:1/1073
>  CPU: 0 UID: 0 PID: 1073 Comm: kworker/u41:1 Tainted: G        W   E     =
  7.3.0-rc7-custom+ #111 PREEMPT(full)  181cfbec4e757bdd6c595e90a9174842790=
74a92
>  Workqueue: btrfs-endio-write btrfs_work_helper [btrfs]
>  RIP: 0010:btrfs_unpin_extent_cache+0x12a/0x1a0 [btrfs]
>  Call Trace:
>   <TASK>
>   btrfs_finish_one_ordered+0x8f9/0xce0 [btrfs 78b39de6ff5f8aabf4d24775128=
04f86456deeca]
>   btrfs_work_helper+0xc5/0x3a0 [btrfs 78b39de6ff5f8aabf4d2477512804f86456=
deeca]
>   process_scheduled_works+0x20b/0x480
>   worker_thread+0x1f7/0x2f0
>   kthread+0x101/0x130
>   ret_from_fork+0xd9/0x250
>   ret_from_fork_asm+0x11/0x20
>   </TASK>
>  ---[ end trace 0000000000000000 ]---
>  BTRFS warning (device dm-2): found extent map for inode 257 (root 5) wit=
h unexpected start offset 8192 when unpinning extent range [4096, 12288), g=
eneration 12
>  ------------[ cut here ]------------
>  WARNING: fs/btrfs/inode.c:3321 at btrfs_finish_one_ordered+0xc4b/0xce0 [=
btrfs], CPU#0: kworker/u41:1/1073
>  CPU: 0 UID: 0 PID: 1073 Comm: kworker/u41:1 Tainted: G        W   E     =
  7.3.0-rc7-custom+ #111 PREEMPT(full)  181cfbec4e757bdd6c595e90a9174842790=
74a92
>  Workqueue: btrfs-endio-write btrfs_work_helper [btrfs]
>  RIP: 0010:btrfs_finish_one_ordered+0xc4b/0xce0 [btrfs]
>  Call Trace:
>   <TASK>
>   btrfs_work_helper+0xc5/0x3a0 [btrfs 78b39de6ff5f8aabf4d2477512804f86456=
deeca]
>   process_scheduled_works+0x20b/0x480
>   worker_thread+0x1f7/0x2f0
>   kthread+0x101/0x130
>   ret_from_fork+0xd9/0x250
>   ret_from_fork_asm+0x11/0x20
>   </TASK>
>  ---[ end trace 0000000000000000 ]---
>  BTRFS error (device dm-2 state A): Transaction 12 aborted (-EUCLEAN)
>  BTRFS: error (device dm-2 state A) in btrfs_finish_one_ordered:3321: err=
no=3D-117 Filesystem corrupted
>
> [CAUSE]
>
> There is a race between compressed write and regular write inside the
> same folio, that can lead to incorrect PAGECACHE_TAG_DIRTY tag to be
> cleared too early.
>
> In this example, we have a large folio containing 8 pages (4K page size,
> 4K block size), with the following layout:
>
>   0        8K        16K        24K        32K
>       |//////////|          |///|
>
> Where [4K, 12K) is dirty, and [20K, 24K) is also dirty.
>
>         Writeback                 |        Compression worker
> ----------------------------------+------------------------------------
> writepage_delalloc()              |
> |- run_delalloc_compressed()      |
> |  |  Queueing [4K, 12K) for      |
> |  |  compression.                |
> |  \- btrfs_queue_work()          |
> |                                 | compress_file_range()
> |                                 | |- extent_range_clear_dirty_for_io()
> |                                 |    \- btrfs_folio_clamp_clear_dirty()
> |                                 |       Now range [4K, 12K) is no longe=
r
> |                                 |       dirty, but also without an OE.
> \- run_delalloc_cow()             |
>    |  For the [20K, 24K)          |
>    \- submit_one_sector()         |
>       |- btrfs_folio_clear_dirty()|
>       |  Since [20K, 24K) is the  |
>       |  last dirty block, the    |
>       |  folio is no longer dirty |
>       |                           |
>       |- btrfs_folio_set_writeback()
>          Since the folio is no    |
>          longer dirty, the        |
>          PAGECACHE_TAG_DIRTY tag  |
>          is also cleared.         |
>
> The above race will lead to a 32K folio that contains [4K, 12K) range
> that is still under compression (and should still be counted dirty), but
> without an OE.
>
> Then later in the reflink:
>
>         Reflink                   |        Compression worker
> ----------------------------------+------------------------------------
> btrfs_clone_files()               |
> |  Which is to replace [4K, 8K)   |
> |                                 |
> |- btrfs_wait_ordered_range()     |
> |  |- btrfs_fdatawrite_range()    |
> |  |  Nothing to do, since no     |
> |  |  DIRTY tag for the folio     |
> |  |                              |
> |  |- filemap_fdatawait_range()   |
> |  |  The [20K, 24K) finished,    |
> |  |  So no WRITEBACK tag         |
> |  |                              |
> |  \- lookup OE                   |
> |     No OE is created for range  |
> |     [4K, 12K)                   |
> |                                 |
> |                                 | submit_compressed_extents
> |                                 | \- submit_one_async_extent
> |                                 |    \- btrfs_alloc_ordered_extent()
> |                                 |       OE for [4K, 12K) created, but
> |                                 |       it's too late.
> \- btrfs_clone()                  |
>    Replace file extents for range |
>    [4K, 8K), which will conflict  |
>    with the new compressed range  |
>    [4K, 12K)                      |
>                                   | end_bbio_data_write([4k, 12K))
>                                   | \- btrfs_finish_ordered()
>                                   |
>                                   |
>                                   | finish_ordered_fn()
>                                   | \- btrfs_finish_one_ordered()
>                                   |    \- btrfs_unpin_extent_cache()
>                                   |       em start 8K !=3D 4K
>                                           return -EUCLEAN, transaction ab=
orted
>
> [FIX]
> Do not clear the folio dirty early during compress_file_range().
>
> The early clearing is done through extent_range_clear_dirty_for_io(), so

early -> premature

It's more clear that way IMO.

> remove the folio dirty clearing completely from it.
>
> And since what's left is only checking the folio write protection,
> rename the function to extent_range_check_write_protected() instead, and
> slightly clean it up, so it doesn't need to return an int.
>
> Finally since the range is still dirty now, all run_delalloc_cow()
> callers pass @pages_dirty =3D true, we can remove that parameter along ot=
her
> involved functions.
>
> Fixes: 1d2fbb7f1f9e ("btrfs: allow compression even if the range is not p=
age aligned")
> Reported-by: Breno Leitao <leitao@debian.org>
> Link: https://lore.kernel.org/linux-btrfs/ause7k_HjzUWT3D-@gmail.com/
> Signed-off-by: Qu Wenruo <wqu@suse.com>
> ---
>  fs/btrfs/extent_io.c |  5 ++---
>  fs/btrfs/extent_io.h |  3 +--
>  fs/btrfs/inode.c     | 42 ++++++++++++------------------------------
>  3 files changed, 15 insertions(+), 35 deletions(-)
>
> diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
> index a221b63bdb20..a143592c20d4 100644
> --- a/fs/btrfs/extent_io.c
> +++ b/fs/btrfs/extent_io.c
> @@ -2904,8 +2904,7 @@ static int extent_write_cache_pages(struct address_=
space *mapping,
>   * locked.
>   */
>  void extent_write_locked_range(struct inode *inode, const struct folio *=
locked_folio,
> -                              u64 start, u64 end, struct writeback_contr=
ol *wbc,
> -                              bool pages_dirty)
> +                              u64 start, u64 end, struct writeback_contr=
ol *wbc)
>  {
>         bool found_error =3D false;
>         int ret =3D 0;
> @@ -2948,7 +2947,7 @@ void extent_write_locked_range(struct inode *inode,=
 const struct folio *locked_f
>                 cur_len =3D cur_end + 1 - cur;
>
>                 ASSERT(folio_test_locked(folio));
> -               if (pages_dirty && folio !=3D locked_folio)
> +               if (folio !=3D locked_folio)
>                         ASSERT(folio_test_dirty(folio));
>
>                 /*
> diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
> index d8dd2ae9ff9a..c55b37cb24b7 100644
> --- a/fs/btrfs/extent_io.h
> +++ b/fs/btrfs/extent_io.h
> @@ -280,8 +280,7 @@ void btrfs_check_folio_write_protected(struct folio *=
folio);
>  static inline void btrfs_check_folio_write_protected(struct folio *folio=
) { }
>  #endif
>  void extent_write_locked_range(struct inode *inode, const struct folio *=
locked_folio,
> -                              u64 start, u64 end, struct writeback_contr=
ol *wbc,
> -                              bool pages_dirty);
> +                              u64 start, u64 end, struct writeback_contr=
ol *wbc);
>  int btrfs_writepages(struct address_space *mapping, struct writeback_con=
trol *wbc);
>  int btree_writepages(struct address_space *mapping, struct writeback_con=
trol *wbc);
>  void btrfs_btree_wait_writeback_range(struct btrfs_fs_info *fs_info, u64=
 start, u64 end);
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index b6ea1f713b7e..91186c0cd6af 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -120,8 +120,7 @@ static int btrfs_truncate(struct btrfs_inode *inode, =
bool skip_writeback);
>
>  static noinline int run_delalloc_cow(struct btrfs_inode *inode,
>                                      struct folio *locked_folio, u64 star=
t,
> -                                    u64 end, struct writeback_control *w=
bc,
> -                                    bool pages_dirty);
> +                                    u64 end, struct writeback_control *w=
bc);
>
>  static int data_reloc_print_warning_inode(u64 inum, u64 offset, u64 num_=
bytes,
>                                           u64 root, void *warn_ctx)
> @@ -773,33 +772,27 @@ static inline void inode_should_defrag(struct btrfs=
_inode *inode,
>                 btrfs_add_inode_defrag(inode, small_write);
>  }
>
> -static int extent_range_clear_dirty_for_io(struct btrfs_inode *inode, u6=
4 start, u64 end)
> +static void extent_range_check_write_protected(struct btrfs_inode *inode=
, u64 start, u64 end)
>  {
>         pgoff_t index =3D start >> PAGE_SHIFT;
>         const pgoff_t end_index =3D end >> PAGE_SHIFT;
>         struct folio *folio;
> -       int ret =3D 0;
> +
> +       if (!IS_ENABLED(CONFIG_BTRFS_DEBUG))
> +               return;
>
>         while (index <=3D end_index) {
>                 folio =3D filemap_get_folio(inode->vfs_inode.i_mapping, i=
ndex);
> +               /* Compression should have all involved folios still lock=
ed. */
>                 if (IS_ERR(folio)) {
> -                       if (!ret)
> -                               ret =3D PTR_ERR(folio);
> +                       ASSERT(0, "missing a folio inside the compression=
 range");

I really don't like having an ASSERT(0), specially when we can deal
with the issue, as it avoids having to reboot since ASSERT() triggers
a BUG().
How about DEBUG_WARN()? It logs a message and triggers a stack trace
(WARN()), so we can detect it through fstests for example.

Otherwise it looks good, so:

Reviewed-by: Filipe Manana <fdmanana@suse.com>

Thanks.

>                         index++;
>                         continue;
>                 }
> -               /*
> -                * We are about to compress the folio, so it must not be =
mmap
> -                * writeable or we could corrupt the data as we attempt t=
o
> -                * compress it.
> -                */
>                 btrfs_check_folio_write_protected(folio);
> -               btrfs_folio_clamp_clear_dirty(inode->root->fs_info, folio=
, start,
> -                                             end + 1 - start);
>                 index =3D folio_next_index(folio);
>                 folio_put(folio);
>         }
> -       return ret;
>  }
>
>  static struct folio *compressed_bio_last_folio(struct compressed_bio *cb=
)
> @@ -886,16 +879,7 @@ static void compress_file_range(struct btrfs_work *w=
ork)
>
>         inode_should_defrag(inode, start, end, end - start + 1, SZ_16K);
>
> -       ret =3D extent_range_clear_dirty_for_io(inode, start, end);
> -
> -       /*
> -        * All the folios should have been locked thus no failure.
> -        *
> -        * And even if some folios are missing, btrfs_compress_bio()
> -        * would handle them correctly, so here just do an ASSERT() check=
 for
> -        * early logic errors.
> -        */
> -       ASSERT(ret =3D=3D 0);
> +       extent_range_check_write_protected(inode, start, end);
>
>         /*
>          * We need to save i_size before now because it could change in b=
etween
> @@ -1011,8 +995,7 @@ static void submit_uncompressed_range(struct btrfs_i=
node *inode,
>         };
>
>         wbc_attach_fdatawrite_inode(&wbc, &inode->vfs_inode);
> -       ret =3D run_delalloc_cow(inode, locked_folio, start, end,
> -                              &wbc, false);
> +       ret =3D run_delalloc_cow(inode, locked_folio, start, end, &wbc);
>         wbc_detach_inode(&wbc);
>         if (ret < 0) {
>                 if (locked_folio)
> @@ -1657,8 +1640,7 @@ static bool run_delalloc_compressed(struct btrfs_in=
ode *inode,
>   */
>  static noinline int run_delalloc_cow(struct btrfs_inode *inode,
>                                      struct folio *locked_folio, u64 star=
t,
> -                                    u64 end, struct writeback_control *w=
bc,
> -                                    bool pages_dirty)
> +                                    u64 end, struct writeback_control *w=
bc)
>  {
>         u64 done_offset =3D end;
>         int ret;
> @@ -1669,7 +1651,7 @@ static noinline int run_delalloc_cow(struct btrfs_i=
node *inode,
>                 if (ret)
>                         return ret;
>                 extent_write_locked_range(&inode->vfs_inode, locked_folio=
,
> -                                         start, done_offset, wbc, pages_=
dirty);
> +                                         start, done_offset, wbc);
>                 start =3D done_offset + 1;
>         }
>
> @@ -2436,7 +2418,7 @@ int btrfs_run_delalloc_range(struct btrfs_inode *in=
ode, struct folio *locked_fol
>                 return 1;
>
>         if (zoned)
> -               return run_delalloc_cow(inode, locked_folio, start, end, =
wbc, true);
> +               return run_delalloc_cow(inode, locked_folio, start, end, =
wbc);
>         else
>                 return cow_file_range(inode, locked_folio, start, end, NU=
LL, 0);
>  }
> --
> 2.56.0
>
>
