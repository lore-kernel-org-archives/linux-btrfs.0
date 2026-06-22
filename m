Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5664819CCF7
	for <linux-btrfs@vger.kernel.org>; Mon, 22 Jun 2026 11:30:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782127826; cv=none; b=JBrSJtZ/RTSPdZ2+QkDD6tHe8vaqKGS9A81R6EYFCkqSiBHuHFzHctXvIJBdPUjXBPZwDuR6T5epbFRhfppweU0sGUPWHNTWHgcgJ1MnRLN2VCUInHkxYFKSET3wajot4wHfpxUHW7iRzaIPKBzIGejtYu0vnnkm+QQqjkkLVYI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782127826; c=relaxed/simple;
	bh=AZ4VOth3FZis0PgRpS4rvmHUuGrmFJDJKIcS0ozE/cU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=K1IOI49BFuAsz5HtdtSGwQOJ7ViM7j03n6HkB1TuNNRbesmnTO4Ln/tndnvI+SMba7ZI8lxiiLWl9v5sRdYXe1Un1i/BF/sJGFDl99zOwQuEsL6S5omiIJtHfzEM/MagUCL7ZGPnocVg+ZSOApxGcEHAY+Q8Sn3rwC1x+1kRov8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZMt2eoTY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZMt2eoTY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1853E1F00A3E
	for <linux-btrfs@vger.kernel.org>; Mon, 22 Jun 2026 11:30:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782127825;
	bh=nZds2CZ4lZNgnZtZODDGA75XEVPC5KjX94+lJi5lVKg=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=ZMt2eoTY7IPDaacYKzqXSQNayu+kZH+BVjq4PO+MqZTQh9Shlgzn0cNToptScRpAX
	 spg+QzcU/Bu41JHIBo8DP3oRAMYTFLyY0rrftE/8OdDqqVnq1kEAwq8T30EjjA95bR
	 1Co4wGhU34IeiRVK4LzLWks+LkzTkkRSOajOky8rvWkkqOiyFfuOSMzSrMQYdKZpTZ
	 IWtOUc2t59s+iT7zA1nb8v7XeEiVPPPijNpKYblmpX7AjgxrhykSWTGYeIJBz+Vo0d
	 XZT55QzfQhHyjR9WZeSB6KquyiCYKiHQUgJHinWEWTCYAmHYyL56XECg1O1+RnyVUj
	 fBCDYfXm484Uw==
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-c0d6c75c58cso275500566b.1
        for <linux-btrfs@vger.kernel.org>; Mon, 22 Jun 2026 04:30:25 -0700 (PDT)
X-Gm-Message-State: AOJu0YyfzX1XGAgkJU8HQtC36DqghUtM22S9Xv5CLT0IVBXUWVJ1LpUc
	/mUfqkcdldZGR5pvMqwz253MjqjARX3xLAEUIp/vW9fDcz1ax+HdLc333QUCsmEak5lr7YprBAp
	JYHu4NoRN/jdWuGX3nXNrxNypv9pWHL4=
X-Received: by 2002:a17:907:7292:b0:bd7:f75a:817c with SMTP id
 a640c23a62f3a-c0c644a1c6amr435238966b.17.1782127823735; Mon, 22 Jun 2026
 04:30:23 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260622082720.561049-1-johannes.thumshirn@wdc.com>
In-Reply-To: <20260622082720.561049-1-johannes.thumshirn@wdc.com>
From: Filipe Manana <fdmanana@kernel.org>
Date: Mon, 22 Jun 2026 12:29:46 +0100
X-Gmail-Original-Message-ID: <CAL3q7H5yeNXoSBDB4g4pjMKku2k6-Vctk0uEVTd_MK=Wb1s5iA@mail.gmail.com>
X-Gm-Features: AVVi8Cd6rxUt5gfPw2Z4T5FU9_wuv25iCJsGU7JyBbng5lc8dynwo8cWQ23wC3Y
Message-ID: <CAL3q7H5yeNXoSBDB4g4pjMKku2k6-Vctk0uEVTd_MK=Wb1s5iA@mail.gmail.com>
Subject: Re: [PATCH v4] btrfs: zoned: don't force read-only on transient
 -EAGAIN from reloc merge
To: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Cc: linux-btrfs@vger.kernel.org, Damien Le Moal <dlemoal@kernel.org>, 
	Filipe Manana <fdmanana@suse.com>, Damien Le Moal <damien.lemoal@wdc.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 22, 2026 at 9:27=E2=80=AFAM Johannes Thumshirn
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
> Reported-by: Damien Le Moal <damien.lemoal@wdc.com>
> Fixes: 7bcb04de982f ("btrfs: zoned: cap delayed refs metadata reservation=
 to avoid overcommit")
> Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
> ---
> Changes to v3:
> - Don't ASSERT() for zoned in case of EAGAIN in
>   btrfs_reclaim_block_group but check for zoned
>
>  fs/btrfs/block-group.c | 10 +++++++-
>  fs/btrfs/relocation.c  | 52 ++++++++++++++++++++++++++++++++++++++----
>  2 files changed, 57 insertions(+), 5 deletions(-)
>
> diff --git a/fs/btrfs/block-group.c b/fs/btrfs/block-group.c
> index ab76a5173272..1327fd526b06 100644
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
> @@ -2113,7 +2119,9 @@ void btrfs_reclaim_block_groups(struct btrfs_fs_inf=
o *fs_info, unsigned int limi
>                 spin_unlock(&fs_info->unused_bgs_lock);
>                 ret =3D btrfs_reclaim_block_group(bg, &reclaimed);
>
> -               if (ret && !READ_ONCE(space_info->periodic_reclaim))
> +               if (ret =3D=3D -EAGAIN)
> +                       btrfs_link_bg_list(bg, &retry_list);
> +               else if (ret && !READ_ONCE(space_info->periodic_reclaim))
>                         btrfs_link_bg_list(bg, &retry_list);
>                 btrfs_put_block_group(bg);
>
> diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
> index 1819d49d19c3..73d9948b5382 100644
> --- a/fs/btrfs/relocation.c
> +++ b/fs/btrfs/relocation.c
> @@ -1530,6 +1530,36 @@ static void clear_reloc_root(struct btrfs_root *ro=
ot)
>         clear_bit(BTRFS_ROOT_DEAD_RELOC_TREE, &root->state);
>  }
>
> +/* Drop the reloc trees of a relocation that is being deferred and retri=
ed */

Same comment as in v3: always add punctuation to sentences, this is
our preferred style.

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
> @@ -1869,8 +1899,9 @@ int prepare_to_merge(struct reloc_control *rc, int =
err)
>         return err;
>  }
>
> +

Same comment as in v3: stray, accidental, new line.

>  static noinline_for_stack
> -void merge_reloc_roots(struct reloc_control *rc)
> +int merge_reloc_roots(struct reloc_control *rc)
>  {
>         struct btrfs_fs_info *fs_info =3D rc->extent_root->fs_info;
>         struct btrfs_root *root;
> @@ -1968,7 +1999,15 @@ void merge_reloc_roots(struct reloc_control *rc)
>                 goto again;
>         }
>  out:
> -       if (ret) {
> +       if (ret =3D=3D -EAGAIN) {

As pointed in v3, missing an:    && (btrfs_is_zoned(fs_info)

> +               abort_reloc_roots(rc, &reloc_roots);
> +
> +               /* new reloc root may be added */

Same comment as in v3: always capitalize the first word and add
punctuation to sentences, this is our preferred style.

Otherwise it looks fine, thanks.

> +               mutex_lock(&fs_info->reloc_mutex);
> +               list_splice_init(&rc->reloc_roots, &reloc_roots);
> +               mutex_unlock(&fs_info->reloc_mutex);
> +               abort_reloc_roots(rc, &reloc_roots);
> +       } else if (ret) {
>                 btrfs_handle_fs_error(fs_info, ret, NULL);
>                 free_reloc_roots(&reloc_roots);
>
> @@ -1994,6 +2033,7 @@ void merge_reloc_roots(struct reloc_control *rc)
>          *
>          * The remaining nodes will be cleaned up by put_reloc_control().
>          */
> +       return ret;
>  }
>
>  static void free_block_list(struct rb_root *blocks)
> @@ -3723,7 +3763,9 @@ static noinline_for_stack int relocate_block_group(=
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
> @@ -5692,7 +5734,9 @@ int btrfs_recover_relocation(struct btrfs_fs_info *=
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
