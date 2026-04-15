Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A1A230DECB
	for <linux-btrfs@vger.kernel.org>; Wed, 15 Apr 2026 11:26:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776252400; cv=none; b=Muvmq9ygzYtkjf1RtSWI/DkR0krq8nX1BkDkXyYdKn2RbVIBorLTdtA0e/5G+wkTmbBLvKJyHKuw21j6pOfQaQd7O1Zr+hGTIcUKsRG+DKaORJsKBDv+emCyRfaokDgIF1RA0Ss8V0QitgRqRQgcPKIJgAKZktZw/2HleAERng4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776252400; c=relaxed/simple;
	bh=9EWuSm6FY7P+eCPndkm6do2xYilGG0mbVscXnWhvnAQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=W5Go7VyvtM97XXXWzSGaXnGsVFz3mj9tuIua7MYz76DfPms2gFp/W2gF8XEStInfgTSYGCLwg9Jy+OzVu+IQtqDZCKbRt/XYQy7rJFWxFWp2UObbj4evz7JlsUnH/+GUNTXhiLi2tNxUPDiEbYtOuB4rHDdZPM5+WesJdz8w8KY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KsH+NijR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KsH+NijR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FA41C2BCB6
	for <linux-btrfs@vger.kernel.org>; Wed, 15 Apr 2026 11:26:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776252400;
	bh=9EWuSm6FY7P+eCPndkm6do2xYilGG0mbVscXnWhvnAQ=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=KsH+NijR+BKGHd7K7TitQiiMHbCMr4N6wI/uEOOSogv7Mwko8m6ixWA+jA2dyc96B
	 BqC2iCkI3JJgBsUYv3fVv6OMQDNUtWtkjcM1+WSgyogNN+oTS4C6cD8i7x+qrd208r
	 b3EFsiGwbDbQqUA5zPQoxhvYtPXUMU5HY/swlVWZjLZhGAhUjnmdjH4G+2D87Yp8bv
	 NvIPC2VHIsjalHrULcrhbTh9Jgl8k3l7AEFjQBuEgVes3IS2LVYj3hNSti3UJaLQXf
	 HrYZgSxYWLPSh3QxkJmeRPeEaL6X3/f1ZuIdajN2QYj8Z2hz3BIW5RIP/gM4XtdUT6
	 6JRHQxBeeq9kA==
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-66e8cf72a93so7803806a12.0
        for <linux-btrfs@vger.kernel.org>; Wed, 15 Apr 2026 04:26:40 -0700 (PDT)
X-Gm-Message-State: AOJu0YwoyrnCF7pw/1HnRlnVmD9OzuEzSu3m1w8+We4bIG1qbzWpYkqB
	8IF4cXJNFY2kWxRifyIvX7uJ0k509ewuFRw4wDEgU9cZfkFT77MK3CoKtgWX9UGFg69ukrLZ0Uo
	xKKSx8dQ1rocjdmBHp6sBTvPssexgE8Q=
X-Received: by 2002:a17:907:894f:b0:b9b:207c:f7af with SMTP id
 a640c23a62f3a-b9d7267bf50mr1178914966b.42.1776252398761; Wed, 15 Apr 2026
 04:26:38 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <1c3a439e1e21c4ee32575b264ac0bc3935ea4f53.1775364843.git.wqu@suse.com>
In-Reply-To: <1c3a439e1e21c4ee32575b264ac0bc3935ea4f53.1775364843.git.wqu@suse.com>
From: Filipe Manana <fdmanana@kernel.org>
Date: Wed, 15 Apr 2026 12:25:59 +0100
X-Gmail-Original-Message-ID: <CAL3q7H45KF=ptRmAEE32J07oeewV3h-Zq8k_-LhO15PnReL+2Q@mail.gmail.com>
X-Gm-Features: AQROBzDCsAnmzYJc_tosPhazuRHvQDYFfp4LQ1IFPTapJ5wFaqZdM2i9BsIZFrM
Message-ID: <CAL3q7H45KF=ptRmAEE32J07oeewV3h-Zq8k_-LhO15PnReL+2Q@mail.gmail.com>
Subject: Re: [PATCH] btrfs: warn about extent buffer that can not be released
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org, AHN SEOK-YOUNG <iamsyahn@gmail.com>, 
	Teng Liu <27rabbitlt@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Apr 5, 2026 at 5:56=E2=80=AFAM Qu Wenruo <wqu@suse.com> wrote:
>
> When we unmount the fs or during mount failures, btrfs will call
> invalidate_inode_pages() to release all btree inode folios.
>
> However that function can return -EBUSY if any folios can not be
> invalidated.
> This can be caused by:
>
> - Some extent buffers are still held by btrfs
>   This is a logic error, as we should release all tree root nodes
>   during unmount and mount failure handling.
>
> - Some extent buffers are under readahead and haven't yet finished
>   This is much rarer but valid cases.
>   In that case we should wait for those extent buffers.
>
> Introduce a new helper invalidate_btree_folios() which will:
>
> - Call invalidate_inode_pages2() and catch its return value
>   If it returned 0 as expected, that's great and we can call it a day.
>
> - Otherwise go through each extent buffer in buffer_tree
>   For eb that still has EXTENT_BUFFER_READING flag, wait for them to
>   finish first.
>
>   Then check if the refs of the eb is greater than 1, if so it means
>   it's still held by someone, give it a warning.
>
> Link: https://bugzilla.kernel.org/show_bug.cgi?id=3D221270
> Reported-by: AHN SEOK-YOUNG <iamsyahn@gmail.com>
> Cc: Teng Liu <27rabbitlt@gmail.com>
> Signed-off-by: Qu Wenruo <wqu@suse.com>
> ---
> This new debug feature has exposed some problems, e.g. generic/648,
> after an injected failure for device barrier, transaction is aborted but
> we have a lot of dirty tree blocks unreleased and triggered the new
> warning.
>
> We still need to fix these corner cases.
>
> Meanwhile if Ahn or Teng can give this patch a try for the existing
> use-after-free problem, it would be appreciated a lot.
> ---
>  fs/btrfs/disk-io.c   | 52 ++++++++++++++++++++++++++++++++++++++++++--
>  fs/btrfs/extent_io.c |  6 -----
>  fs/btrfs/extent_io.h |  6 +++++
>  3 files changed, 56 insertions(+), 8 deletions(-)
>
> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> index b8ac3275d8f8..d450bfc6d89b 100644
> --- a/fs/btrfs/disk-io.c
> +++ b/fs/btrfs/disk-io.c
> @@ -3276,6 +3276,54 @@ static bool fs_is_full_ro(const struct btrfs_fs_in=
fo *fs_info)
>         return false;
>  }
>
> +static void invalidate_btree_folios(struct btrfs_fs_info *fs_info)
> +{
> +       XA_STATE(xas, &fs_info->buffer_tree, 0);
> +       unsigned int checked =3D 0;
> +       void *tmp;
> +       int ret;
> +
> +       ret =3D invalidate_inode_pages2(fs_info->btree_inode->i_mapping);
> +       if (likely(ret =3D=3D 0))
> +               return;
> +
> +       /*
> +        * Some btree pages can not be invalidated, this happens when som=
e
> +        * tree blocks are still held (either by some pointer or readahea=
d).
> +        */
> +       xas_lock_irq(&xas);
> +       xas_for_each(&xas, tmp, ULONG_MAX) {
> +               struct extent_buffer *eb =3D tmp;

Why use the tmp variable? We can pass 'eb' to xas_for_each().

> +
> +               /* Wait for any readahead first. */
> +               if (test_bit(EXTENT_BUFFER_READING, &eb->bflags)) {
> +                       xas_pause(&xas);
> +                       xas_unlock_irq(&xas);
> +                       wait_on_bit_io(&eb->bflags, EXTENT_BUFFER_READING=
,
> +                                      TASK_UNINTERRUPTIBLE);
> +                       xas_lock_irq(&xas);
> +               }
> +
> +               spin_lock(&eb->refs_lock);
> +               if (refcount_read(&eb->refs) > 1 || extent_buffer_under_i=
o(eb)) {
> +                       btrfs_warn(fs_info,
> +                       "unbale to release extent buffer %llu owner %llu =
flags 0x%lx",

unbale -> unable

> +                                  eb->start, btrfs_header_owner(eb), eb-=
>bflags);
> +                       if (IS_ENABLED(CONFIG_BTRFS_DEBUG))
> +                               WARN_ON_ONCE(true);

Pointless if, just do DEBUG_WARN();

Thanks.

> +               }
> +               spin_unlock(&eb->refs_lock);
> +               if (++checked % XA_CHECK_SCHED)
> +                       continue;
> +               xas_pause(&xas);
> +               xas_unlock_irq(&xas);
> +               cond_resched();
> +               xas_lock_irq(&xas);
> +       }
> +       xas_unlock_irq(&xas);
> +       invalidate_inode_pages2(fs_info->btree_inode->i_mapping);
> +}
> +
>  int __cold open_ctree(struct super_block *sb, struct btrfs_fs_devices *f=
s_devices)
>  {
>         u32 sectorsize;
> @@ -3706,7 +3754,7 @@ int __cold open_ctree(struct super_block *sb, struc=
t btrfs_fs_devices *fs_device
>         if (fs_info->data_reloc_root)
>                 btrfs_drop_and_free_fs_root(fs_info, fs_info->data_reloc_=
root);
>         free_root_pointers(fs_info, true);
> -       invalidate_inode_pages2(fs_info->btree_inode->i_mapping);
> +       invalidate_btree_folios(fs_info);
>
>  fail_sb_buffer:
>         btrfs_stop_all_workers(fs_info);
> @@ -4445,7 +4493,7 @@ void __cold close_ctree(struct btrfs_fs_info *fs_in=
fo)
>          * We must make sure there is not any read request to
>          * submit after we stop all workers.
>          */
> -       invalidate_inode_pages2(fs_info->btree_inode->i_mapping);
> +       invalidate_btree_folios(fs_info);
>         btrfs_stop_all_workers(fs_info);
>
>         /*
> diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
> index 1ba8a7d3587b..a8887285deda 100644
> --- a/fs/btrfs/extent_io.c
> +++ b/fs/btrfs/extent_io.c
> @@ -2877,12 +2877,6 @@ bool try_release_extent_mapping(struct folio *foli=
o, gfp_t mask)
>         return try_release_extent_state(io_tree, folio);
>  }
>
> -static int extent_buffer_under_io(const struct extent_buffer *eb)
> -{
> -       return (test_bit(EXTENT_BUFFER_WRITEBACK, &eb->bflags) ||
> -               test_bit(EXTENT_BUFFER_DIRTY, &eb->bflags));
> -}
> -
>  static bool folio_range_has_eb(struct folio *folio)
>  {
>         struct btrfs_folio_state *bfs;
> diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
> index fd209233317f..b284aee1bfb0 100644
> --- a/fs/btrfs/extent_io.h
> +++ b/fs/btrfs/extent_io.h
> @@ -326,6 +326,12 @@ static inline bool extent_buffer_uptodate(const stru=
ct extent_buffer *eb)
>         return test_bit(EXTENT_BUFFER_UPTODATE, &eb->bflags);
>  }
>
> +static inline bool extent_buffer_under_io(const struct extent_buffer *eb=
)
> +{
> +       return (test_bit(EXTENT_BUFFER_WRITEBACK, &eb->bflags) ||
> +               test_bit(EXTENT_BUFFER_DIRTY, &eb->bflags));
> +}
> +
>  int memcmp_extent_buffer(const struct extent_buffer *eb, const void *ptr=
v,
>                          unsigned long start, unsigned long len);
>  void read_extent_buffer(const struct extent_buffer *eb, void *dst,
> --
> 2.53.0
>
>
