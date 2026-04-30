Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4C071FA272
	for <linux-btrfs@vger.kernel.org>; Thu, 30 Apr 2026 12:49:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777553354; cv=none; b=BW3Fkpp5SavynbaQqMcRS/IRkYELav72IzypUKL7trAikzBSdS5IMCAnjncGoCvV9T5JSd18+Jt3y79e24753NqP9Bw5UmYzgjNZ2If/WfzH2JAjd0Tmi4ErW/0AHSjJ9p/0gmNuvRFd7JWzdnSjxm8to0bYVPm9FX1xgqX4QmQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777553354; c=relaxed/simple;
	bh=ezBS1mCjeJaFESwFI9N1bZ6+lDN4dOwZWHmM+jY+QLs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=VwE5n3gspMWdH6aescLkeuDTgKaPsvdbM7KhgleX/mAa4sXPRW+BRHm0BXXJco2irzg7Cjp3YvwJLLHg3Yt6/XAoWtBVunnQOS0ojRGmbAlsnvlhhoXeDTN7dc0QeZwdMFY6+pi9ojEeGb1t02S4wcrK95f0b0YvU8iD8sWFkJw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dbV0ZmA3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dbV0ZmA3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52E19C2BCC7
	for <linux-btrfs@vger.kernel.org>; Thu, 30 Apr 2026 12:49:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777553354;
	bh=ezBS1mCjeJaFESwFI9N1bZ6+lDN4dOwZWHmM+jY+QLs=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=dbV0ZmA3v0f0hyruclG0f2M7M5NqisgvjzkRu7BRIIdyAy8gLPPOzUMY8x9qGGUIT
	 QXixKa5eTp5esdDYJZzuRmIANTT0HxEvjoyAO4Luladt9HEBbfExBoz+l5cP0l9CHO
	 jtHV0MXhkayC+rOqoPpJAfBU98sOw14h3oR3x0u/yRfH7smrMzfv1NH9uuZYTbTMnP
	 8DKIdt9ticcBPt9eJSBm543Gq6aT7gw/IZRBMa3Xt6jah0Ksred+Ml56HktJUyHpYZ
	 EgOFsRrdS+sDSU5Fil2uCDU6dGUPKFxN30O/2kGYlAMZ41Bc4Y5XSnoUGZF61XVSZ+
	 /IxD5wQI29EwA==
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-baa8c78ac7fso113665166b.0
        for <linux-btrfs@vger.kernel.org>; Thu, 30 Apr 2026 05:49:14 -0700 (PDT)
X-Gm-Message-State: AOJu0YykJyHW1RrJXlIG+vedUntcIyMj8Rl1/+5AQ/RhgmXSvzZVJk/T
	chKtzQ+Pt+zDjIhj8YLP3oXAvLlZiTAIMV6YgE9bYC2HUN7u+o70U7ncK12nWlMpKQb/adrLdyU
	UIpBV2y+wFbCkBJcyI62HArR2r3CvWLs=
X-Received: by 2002:a17:906:2082:b0:bad:f89f:7794 with SMTP id
 a640c23a62f3a-bbac6bbd74bmr140602666b.24.1777553352854; Thu, 30 Apr 2026
 05:49:12 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1777510825.git.wqu@suse.com> <ecc473cee5a79c8c8b1006febbfeb24963c46714.1777510825.git.wqu@suse.com>
In-Reply-To: <ecc473cee5a79c8c8b1006febbfeb24963c46714.1777510825.git.wqu@suse.com>
From: Filipe Manana <fdmanana@kernel.org>
Date: Thu, 30 Apr 2026 13:48:36 +0100
X-Gmail-Original-Message-ID: <CAL3q7H60GiqmvVge1WxpG1GXONjE5xXiHuWOSO9Ae=7ATfb-VQ@mail.gmail.com>
X-Gm-Features: AVHnY4IxK6UAba1ognP4z7Ug2J2XwYzRe-waNMrRRjbW3Zg2AFPdIb7gnjQyllo
Message-ID: <CAL3q7H60GiqmvVge1WxpG1GXONjE5xXiHuWOSO9Ae=7ATfb-VQ@mail.gmail.com>
Subject: Re: [PATCH v4 2/2] btrfs: warn about extent buffer that can not be released
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org, AHN SEOK-YOUNG <iamsyahn@gmail.com>, 
	Teng Liu <27rabbitlt@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Apr 30, 2026 at 2:08=E2=80=AFAM Qu Wenruo <wqu@suse.com> wrote:
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
>   These are much rarer but valid cases.
>   In that case we should wait for those extent buffers.
>
> Introduce a new helper invalidate_and_check_btree_folios() which will:
>
> - Call invalidate_inode_pages2() and catch its return value
>   If it returned 0 as expected, that's great and we can call it a day.
>
> - Otherwise go through each extent buffer in buffer_tree
>   Increase the ref by one first for the eb we're checking.
>   This is to ensure the eb won't be freed after the readahead is
>   finished.
>
>   For ebs that still have EXTENT_BUFFER_READING flag, wait for them to
>   finish first.
>
>   After waiting for the readahead, check the refs of the eb and if it's
>   still dirty.
>
>   If the eb ref count is greater than 2 (one for the buffer tree, one
>   held by us), it means we are still holding the extent buffer somewhere
>   else, which is a code bug.
>
>   If the eb is still dirty, it means a bug in transaction handling, e.g.
>   the bug fixed by patch "btrfs: only release the dirty pages io tree
>   after successful writes".
>
>   For either case, show a warning message about the eb, including its
>   bytenr, owner, refs and flags.
>   And if it's a debug build, also trigger WARN_ON_ONCE() so that fstests
>   can properly catch such situation.
>
> Link: https://bugzilla.kernel.org/show_bug.cgi?id=3D221270
> Reported-by: AHN SEOK-YOUNG <iamsyahn@gmail.com>
> Cc: Teng Liu <27rabbitlt@gmail.com>
> Tested-by: Teng Liu <27rabbitlt@gmail.com>
> Signed-off-by: Qu Wenruo <wqu@suse.com>
> ---
>  fs/btrfs/disk-io.c   | 54 ++++++++++++++++++++++++++++++++++++++++++--
>  fs/btrfs/extent_io.c |  6 -----
>  fs/btrfs/extent_io.h |  6 +++++
>  3 files changed, 58 insertions(+), 8 deletions(-)
>
> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> index f28cef8217de..97299394515b 100644
> --- a/fs/btrfs/disk-io.c
> +++ b/fs/btrfs/disk-io.c
> @@ -3272,6 +3272,56 @@ static bool fs_is_full_ro(const struct btrfs_fs_in=
fo *fs_info)
>         return false;
>  }
>
> +/*
> + * Try to wait for any metadata readahead, and invalidate all btree foli=
os.
> + *
> + * If the invalidation failed, report any dirty/held extent buffers.
> + */
> +static void invalidate_and_check_btree_folios(struct btrfs_fs_info *fs_i=
nfo)
> +{
> +       unsigned long index =3D 0;
> +       struct extent_buffer *eb;
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

"by some pointer" - this is really confusing. We want to say some
other task is holding a ref or perhaps we have a refcount leak
somewhere.

> +        */
> +       rcu_read_lock();
> +       xa_for_each(&fs_info->buffer_tree, index, eb) {
> +               /* Increase the ref so that the eb won't disappear. */
> +               if (!refcount_inc_not_zero(&eb->refs))
> +                       continue;
> +               rcu_read_unlock();
> +
> +               /* Wait for any readahead first. */
> +               if (test_bit(EXTENT_BUFFER_READING, &eb->bflags))
> +                       wait_on_bit_io(&eb->bflags, EXTENT_BUFFER_READING=
,
> +                                      TASK_UNINTERRUPTIBLE);
> +               /*
> +                * The refs threshold is 2, one held by us at the beginni=
ng
> +                * of the loop, one for the ownership in the buffer tree.
> +                */
> +               if (unlikely(refcount_read(&eb->refs) > 2 ||
> +                            extent_buffer_under_io(eb))) {
> +                       WARN_ON_ONCE(IS_ENABLED(CONFIG_BTRFS_DEBUG));
> +                       btrfs_warn(fs_info,
> +                       "unable to release extent buffer %llu owner %llu =
gen %llu refs %u flags 0x%lx",
> +                                  eb->start, btrfs_header_owner(eb),
> +                                  btrfs_header_generation(eb),
> +                                  refcount_read(&eb->refs), eb->bflags);
> +               }
> +               free_extent_buffer(eb);
> +               rcu_read_lock();
> +       }
> +       rcu_read_unlock();
> +       invalidate_inode_pages2(fs_info->btree_inode->i_mapping);

Can we report/WARN_ON if invalidate_inode_pages2() returns an error again?

Otherwise:

Reviewed-by: Filipe Manana <fdmanana@suse.com>

Thanks.

> +}
> +
>  int __cold open_ctree(struct super_block *sb, struct btrfs_fs_devices *f=
s_devices)
>  {
>         u32 sectorsize;
> @@ -3709,7 +3759,7 @@ int __cold open_ctree(struct super_block *sb, struc=
t btrfs_fs_devices *fs_device
>         if (fs_info->data_reloc_root)
>                 btrfs_drop_and_free_fs_root(fs_info, fs_info->data_reloc_=
root);
>         free_root_pointers(fs_info, true);
> -       invalidate_inode_pages2(fs_info->btree_inode->i_mapping);
> +       invalidate_and_check_btree_folios(fs_info);
>
>  fail_sb_buffer:
>         btrfs_stop_all_workers(fs_info);
> @@ -4438,7 +4488,7 @@ void __cold close_ctree(struct btrfs_fs_info *fs_in=
fo)
>          * We must make sure there is not any read request to
>          * submit after we stop all workers.
>          */
> -       invalidate_inode_pages2(fs_info->btree_inode->i_mapping);
> +       invalidate_and_check_btree_folios(fs_info);
>         btrfs_stop_all_workers(fs_info);
>
>         /*
> diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
> index 8800faa8b4be..9c9dffda2b07 100644
> --- a/fs/btrfs/extent_io.c
> +++ b/fs/btrfs/extent_io.c
> @@ -2882,12 +2882,6 @@ bool try_release_extent_mapping(struct folio *foli=
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
> index b310a5145cf6..7b4152387d88 100644
> --- a/fs/btrfs/extent_io.h
> +++ b/fs/btrfs/extent_io.h
> @@ -327,6 +327,12 @@ static inline bool extent_buffer_uptodate(const stru=
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
> 2.54.0
>
>
