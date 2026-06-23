Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF3AD3D565B
	for <linux-btrfs@vger.kernel.org>; Tue, 23 Jun 2026 12:14:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782216845; cv=none; b=VB0qnGoCXq5hD0Q9OfSG6jEZYZPJTxL0zrx2JqSS5zuTcdDlGFaZui0PPKkNrwq6pUTbfgop7Byqxewln1Dgj9MNfTXQBicvJldWIm5gUtLX3lrVkxykDGm210h4v0a/MqyyesKnuAkTkx3ELYTZpWrCuwguU2ALFf1i416etUs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782216845; c=relaxed/simple;
	bh=TcJgJ1JL/r17mhqdsh+wR2YXaW+7NTdXE00YIT7/dAQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Tg62OA6j9ZhfroDIrxX3cn2bUbIxmFDCp2/vR6VPrRVMdpFEn7lWQkDW6Xx4pOV367oVvJ/hoJpMJxbpz7iHES5ZajbyVXaGgyyrbvmjuqAce3JuO2Bmljpbc6r+BIQkXFSI/iyZzpUvnc1rXeEuYGq0NbLtB9f3jaRXjsAc40w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gqPP67oo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gqPP67oo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 985881F00A3D
	for <linux-btrfs@vger.kernel.org>; Tue, 23 Jun 2026 12:14:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782216843;
	bh=QVCfEUYkgoxZCiIov1bUcc9fcwXdsWxGJjw5UwuT9UI=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=gqPP67oos5EBcr93YTixJS3/7GQV6uOjFLvuFee19KHQvsit+j9zxWcJJWlda0LUU
	 qaKW6NcBOWIp/m7dxSS/zdKwXKzv/U9JysfvAETpkpicF2xffm9fIbagTnbhTNOi7o
	 aP5LmzThYW5PF8/A+t3ftTmptd4NDH9WdN+BuSpGtWhcCcGiXXmx6JIheOpzWj3nHd
	 JDIbSiJSJYqtaZlvGsG7fJqPjEybcJPxBZO5/uZT2F2BusCQ2j5nzEu0eBxFd1al72
	 vMJmrf7sqLiWFPeKfSis72cAh17IscVv3ls3+No8GbwrgPLj8VB+L58Lm7iXtykt9L
	 V3fxQr7ym/zUw==
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-c07d76ffd0fso561250966b.0
        for <linux-btrfs@vger.kernel.org>; Tue, 23 Jun 2026 05:14:03 -0700 (PDT)
X-Gm-Message-State: AOJu0YwaVpE2lTaFVR0cMHHfGNko7tXn/3axa4YNpnQQaH/U3KBapltm
	j5khESWVhs0ljGebd377U0kQP3OohGN4y2pVp0CsoI1BVNkM0ySzzMErgJBqOgZZiNVcubnQOPp
	p5RMrL0JwS3YCOpeTDW3bnCdhNdx8fpU=
X-Received: by 2002:a17:907:1992:b0:bea:5ce6:4267 with SMTP id
 a640c23a62f3a-c107f4b53a2mr127530566b.35.1782216842195; Tue, 23 Jun 2026
 05:14:02 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260623113851.616247-1-johannes.thumshirn@wdc.com>
In-Reply-To: <20260623113851.616247-1-johannes.thumshirn@wdc.com>
From: Filipe Manana <fdmanana@kernel.org>
Date: Tue, 23 Jun 2026 13:13:23 +0100
X-Gmail-Original-Message-ID: <CAL3q7H6moPHk7eAVaGs4BNkSYonmnyeV8c_aqr=qkj_ki5MufQ@mail.gmail.com>
X-Gm-Features: AVVi8CdiLbL88HgxQc49dyC2iQaZQwFun5AQm1X-gXN2YZPDT4pSWLZ93J37YHM
Message-ID: <CAL3q7H6moPHk7eAVaGs4BNkSYonmnyeV8c_aqr=qkj_ki5MufQ@mail.gmail.com>
Subject: Re: [PATCH v5] btrfs: zoned: don't force read-only on transient
 -EAGAIN from reloc merge
To: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Cc: linux-btrfs@vger.kernel.org, Damien Le Moal <dlemoal@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 23, 2026 at 12:39=E2=80=AFPM Johannes Thumshirn
<johannes.thumshirn@wdc.com> wrote:
>
> On a zoned FS, btrfs_delayed_refs_rsv_refill() returns -EAGAIN whenever
> the over-committed metadata plus the zone_unusable bytes exceeds the
> usable size in a metadata block-group to avoid heavy over-commit of
> metadata and early ENOSPC in one transaction.
>
> If this happens while doing reclaim, the transaction is getting
> aborted.
>
> Treat -EAGAIN as a soft, retryable condition in case of block-group
> reclaim.
>
> Reported-by: Damien Le Moal <dlemoal@kernel.org>
> Fixes: 7bcb04de982f ("btrfs: zoned: cap delayed refs metadata reservation=
 to avoid overcommit")
> Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>

Reviewed-by: Filipe Manana <fdmanana@suse.com>

Thanks.

> ---
> Changes to v4:
> - Gate EAGAIN checks behind btrfs_is_zoned()
> - Fix comment style
>
>  fs/btrfs/block-group.c |  9 +++++++-
>  fs/btrfs/relocation.c  | 51 ++++++++++++++++++++++++++++++++++++++----
>  2 files changed, 55 insertions(+), 5 deletions(-)
>
> diff --git a/fs/btrfs/block-group.c b/fs/btrfs/block-group.c
> index ab76a5173272..9e937407d12a 100644
> --- a/fs/btrfs/block-group.c
> +++ b/fs/btrfs/block-group.c
> @@ -2047,6 +2047,12 @@ static int btrfs_reclaim_block_group(struct btrfs_=
block_group *bg, int *reclaime
>
>         trace_btrfs_reclaim_block_group(bg);
>         ret =3D btrfs_relocate_chunk(fs_info, bg->start, false);
> +       if (btrfs_is_zoned(fs_info) && ret =3D=3D -EAGAIN) {
> +               btrfs_dec_block_group_ro(bg);
> +               btrfs_debug(fs_info, "deferring reclaim of chunk %llu",
> +                           bg->start);
> +               return ret;
> +       }
>         if (ret) {
>                 btrfs_dec_block_group_ro(bg);
>                 btrfs_err(fs_info, "error relocating chunk %llu",
> @@ -2113,7 +2119,8 @@ void btrfs_reclaim_block_groups(struct btrfs_fs_inf=
o *fs_info, unsigned int limi
>                 spin_unlock(&fs_info->unused_bgs_lock);
>                 ret =3D btrfs_reclaim_block_group(bg, &reclaimed);
>
> -               if (ret && !READ_ONCE(space_info->periodic_reclaim))
> +               if ((btrfs_is_zoned(fs_info) && ret =3D=3D -EAGAIN) ||
> +                   (ret && !READ_ONCE(space_info->periodic_reclaim)))
>                         btrfs_link_bg_list(bg, &retry_list);
>                 btrfs_put_block_group(bg);
>
> diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
> index 1819d49d19c3..df69b401ca8e 100644
> --- a/fs/btrfs/relocation.c
> +++ b/fs/btrfs/relocation.c
> @@ -1530,6 +1530,36 @@ static void clear_reloc_root(struct btrfs_root *ro=
ot)
>         clear_bit(BTRFS_ROOT_DEAD_RELOC_TREE, &root->state);
>  }
>
> +/* Drop the reloc trees of a relocation that is being deferred and retri=
ed. */
> +static void abort_reloc_roots(struct reloc_control *rc, struct list_head=
 *list)
> +{
> +       struct btrfs_fs_info *fs_info =3D rc->extent_root->fs_info;
> +       struct btrfs_root *reloc_root, *tmp;
> +
> +       list_for_each_entry_safe(reloc_root, tmp, list, root_list) {
> +               struct btrfs_root *root;
> +
> +               root =3D btrfs_get_fs_root(fs_info, reloc_root->root_key.=
offset,
> +                                        false);
> +               if (!IS_ERR(root)) {
> +                       if (root->reloc_root =3D=3D reloc_root) {
> +                               clear_reloc_root(root);
> +                               btrfs_put_root(reloc_root);
> +                       }
> +                       btrfs_put_root(root);
> +               }
> +
> +               btrfs_set_root_refs(&reloc_root->root_item, 0);
> +               memset(&reloc_root->root_item.drop_progress, 0,
> +                      sizeof(struct btrfs_disk_key));
> +               btrfs_set_root_drop_level(&reloc_root->root_item, 0);
> +
> +               list_del_init(&reloc_root->root_list);
> +               list_add_tail(&reloc_root->reloc_dirty_list,
> +                               &rc->dirty_subvol_roots);
> +       }
> +}
> +
>  static int clean_dirty_subvols(struct reloc_control *rc)
>  {
>         struct btrfs_root *root;
> @@ -1870,7 +1900,7 @@ int prepare_to_merge(struct reloc_control *rc, int =
err)
>  }
>
>  static noinline_for_stack
> -void merge_reloc_roots(struct reloc_control *rc)
> +int merge_reloc_roots(struct reloc_control *rc)
>  {
>         struct btrfs_fs_info *fs_info =3D rc->extent_root->fs_info;
>         struct btrfs_root *root;
> @@ -1968,7 +1998,15 @@ void merge_reloc_roots(struct reloc_control *rc)
>                 goto again;
>         }
>  out:
> -       if (ret) {
> +       if (btrfs_is_zoned(fs_info) && ret =3D=3D -EAGAIN) {
> +               abort_reloc_roots(rc, &reloc_roots);
> +
> +               /* New reloc root may be added. */
> +               mutex_lock(&fs_info->reloc_mutex);
> +               list_splice_init(&rc->reloc_roots, &reloc_roots);
> +               mutex_unlock(&fs_info->reloc_mutex);
> +               abort_reloc_roots(rc, &reloc_roots);
> +       } else if (ret) {
>                 btrfs_handle_fs_error(fs_info, ret, NULL);
>                 free_reloc_roots(&reloc_roots);
>
> @@ -1994,6 +2032,7 @@ void merge_reloc_roots(struct reloc_control *rc)
>          *
>          * The remaining nodes will be cleaned up by put_reloc_control().
>          */
> +       return ret;
>  }
>
>  static void free_block_list(struct rb_root *blocks)
> @@ -3723,7 +3762,9 @@ static noinline_for_stack int relocate_block_group(=
struct reloc_control *rc)
>          */
>         err =3D prepare_to_merge(rc, err);
>
> -       merge_reloc_roots(rc);
> +       ret =3D merge_reloc_roots(rc);
> +       if (ret && !err)
> +               err =3D ret;
>
>         rc->merge_reloc_tree =3D false;
>         unset_reloc_control(rc);
> @@ -5692,7 +5733,9 @@ int btrfs_recover_relocation(struct btrfs_fs_info *=
fs_info)
>         if (ret)
>                 goto out_unset;
>
> -       merge_reloc_roots(rc);
> +       ret =3D merge_reloc_roots(rc);
> +       if (ret)
> +               goto out_unset;
>
>         unset_reloc_control(rc);
>
> --
> 2.54.0
>
>
