Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C6B62ECD3A
	for <linux-btrfs@vger.kernel.org>; Fri, 19 Jun 2026 11:55:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781870156; cv=none; b=NT35+NDmJvkl8opkASWRi/ur0AQ2+DsOaQfKp19SWfv00vOGCHDRzMmjWxalhsnGHCA9ZuQInyBQFHRAlHMtqMv2CRbbD7LtLXxtiYpX5TPATNzxdZnId5fMV7+qpxYoMmSvK/wHlQkGl4c4lZZb9qp7WGwk+17+F+r2MCAWsw8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781870156; c=relaxed/simple;
	bh=SmPwPcQs3CTC/DwuOV6CSCwdaXLIBLrR8VTm0/hqMTU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=VJHP1owPt7yoDHYdRyH0mvBT6FcqurWZu81CLHuNRvz2fE4pmuwYGosy5jqas7vi+AQxnkihSRuUGFdbUTQc/xuS0TX5SFgVH1ChRuony+XOjj05FE4IbKiTUtiT6EuWcJiAcKLJ2FjVhio4CGG4D+dqTt3BUtpZfJqntXvOlIc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZOYmnBqZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZOYmnBqZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E54B51F00A3F
	for <linux-btrfs@vger.kernel.org>; Fri, 19 Jun 2026 11:55:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781870154;
	bh=c4uxMd3XNgWtiza5uTTA4akMG/fOn+NrvTEo9BE0rPY=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=ZOYmnBqZ+1oOauNclh6e4W1nYouvVHq1qG/xBK4sFYYyUOAooE8ylRkNGEVokz9Tw
	 Qn90+usfgXHssAVXYMsa+qV4MPhONYI0zVjuaCng1ep/4WKz6Cjl9evUzakoLS1FlU
	 sx5NQuRnXUbggNl+cMVzNA2IY6B5efCjvg6pkMmD/LfRVnsfe0boLjzh3l0X+9LdIV
	 qAeUbm9Jhps5/E8K7QV7X4GFIiJQb05R9p1kNNpLGG/87DoW6KpIdqc+TyYRk17uWy
	 rFKzr4+jdiX7OTM7Uer2b1Fk9A8Hx5CNH2RwHqaK61ZrHyfdYfYmOla8LGAPwnjyyL
	 emBulskmpwuqA==
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-c07fd4dc2c8so188142866b.1
        for <linux-btrfs@vger.kernel.org>; Fri, 19 Jun 2026 04:55:54 -0700 (PDT)
X-Gm-Message-State: AOJu0YzOmMEmD6rbphft5uJeUr2RNkigVAGDv4ItZwod9dSzt1YSLFRz
	3Q7bXbWViOFnxiSB657lC85vdXmpQ6cTrodxn+Iy0XV/ae/5Ch9VvRb9E1/V5vfPQisLY2AmpR1
	Rt1LZ+6Tx+j1LZMkstn5F4Vpc5E9ihy4=
X-Received: by 2002:a17:906:f58d:b0:bec:40f8:b54a with SMTP id
 a640c23a62f3a-c097c9af1bamr165504766b.38.1781870153587; Fri, 19 Jun 2026
 04:55:53 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260619063203.448055-1-johannes.thumshirn@wdc.com>
In-Reply-To: <20260619063203.448055-1-johannes.thumshirn@wdc.com>
From: Filipe Manana <fdmanana@kernel.org>
Date: Fri, 19 Jun 2026 12:55:16 +0100
X-Gmail-Original-Message-ID: <CAL3q7H7r_3T2WUB46sm9M3v-0wu_KQ46baWKz_m9u9HoK=2zvg@mail.gmail.com>
X-Gm-Features: AVVi8Ccb6r844TtA6JwfGC1mg5ZvJL48fVBZtVo8_IGsKuyGodUhrxQW_hyQLpc
Message-ID: <CAL3q7H7r_3T2WUB46sm9M3v-0wu_KQ46baWKz_m9u9HoK=2zvg@mail.gmail.com>
Subject: Re: [PATCH v3] btrfs: zoned: don't force read-only on transient
 -EAGAIN from reloc merge
To: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Cc: linux-btrfs@vger.kernel.org, Filipe Manana <fdmanana@suse.com>, 
	Damien Le Moal <dlemoal@kernel.org>, Damien Le Moal <damien.lemoal@wdc.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jun 19, 2026 at 7:32=E2=80=AFAM Johannes Thumshirn
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
> Changes to v2:
> - Drop the reloc trees on -EAGAIN otherwise create_reloc_roots() will
>   fail with -EEXIST
>
>  fs/btrfs/block-group.c | 11 ++++++++-
>  fs/btrfs/relocation.c  | 52 ++++++++++++++++++++++++++++++++++++++----
>  2 files changed, 58 insertions(+), 5 deletions(-)
>
> diff --git a/fs/btrfs/block-group.c b/fs/btrfs/block-group.c
> index ab76a5173272..5fc0c20d8e51 100644
> --- a/fs/btrfs/block-group.c
> +++ b/fs/btrfs/block-group.c
> @@ -2047,6 +2047,13 @@ static int btrfs_reclaim_block_group(struct btrfs_=
block_group *bg, int *reclaime
>
>         trace_btrfs_reclaim_block_group(bg);
>         ret =3D btrfs_relocate_chunk(fs_info, bg->start, false);
> +       if (ret =3D=3D -EAGAIN) {
> +               ASSERT(btrfs_is_zoned(fs_info));

So we are assuming that up the call chain -EGAIN can only come when
starting a transaction, from the call to
btrfs_delayed_refs_rsv_refill().
This leaves me a bit itchy, because btrfs_relocate_chunk() has a deep
and wide call chain, so we could be catching -EAGAIN from somewhere
else.

I think it would be better to:

if (ret =3D=3D -EAGAIN && btrfs_is_zoned(fs_info)) {
   ....
}


> +               btrfs_dec_block_group_ro(bg);
> +               btrfs_debug(fs_info, "deferring reclaim of chunk %llu",
> +                           bg->start);
> +               return ret;
> +       }
>         if (ret) {
>                 btrfs_dec_block_group_ro(bg);
>                 btrfs_err(fs_info, "error relocating chunk %llu",
> @@ -2113,7 +2120,9 @@ void btrfs_reclaim_block_groups(struct btrfs_fs_inf=
o *fs_info, unsigned int limi
>                 spin_unlock(&fs_info->unused_bgs_lock);
>                 ret =3D btrfs_reclaim_block_group(bg, &reclaimed);
>
> -               if (ret && !READ_ONCE(space_info->periodic_reclaim))
> +               if (ret =3D=3D -EAGAIN)

Same here.

> +                       btrfs_link_bg_list(bg, &retry_list);
> +               else if (ret && !READ_ONCE(space_info->periodic_reclaim))
>                         btrfs_link_bg_list(bg, &retry_list);
>                 btrfs_put_block_group(bg);
>
> diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
> index e1dd9939f4f1..8cac49fa6f6f 100644
> --- a/fs/btrfs/relocation.c
> +++ b/fs/btrfs/relocation.c
> @@ -1532,6 +1532,36 @@ static void clear_reloc_root(struct btrfs_root *ro=
ot)
>         clear_bit(BTRFS_ROOT_DEAD_RELOC_TREE, &root->state);
>  }
>
> +/* Drop the reloc trees of a relocation that is being deferred and retri=
ed */

Please always end sentences with punctuation, it's our preffered style.

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
> @@ -1871,8 +1901,9 @@ int prepare_to_merge(struct reloc_control *rc, int =
err)
>         return err;
>  }
>
> +
>  static noinline_for_stack

Unintentional new line here.

> -void merge_reloc_roots(struct reloc_control *rc)
> +int merge_reloc_roots(struct reloc_control *rc)
>  {
>         struct btrfs_fs_info *fs_info =3D rc->extent_root->fs_info;
>         struct btrfs_root *root;
> @@ -1970,7 +2001,15 @@ void merge_reloc_roots(struct reloc_control *rc)
>                 goto again;
>         }
>  out:
> -       if (ret) {
> +       if (ret =3D=3D -EAGAIN) {

ret =3D=3D -EAGAIN && btrfs_is_zoned(fs_info)

> +               abort_reloc_roots(rc, &reloc_roots);
> +
> +               /* new reloc root may be added */

Capitalize the first word and end with punctuation.

Otherwise it looks fine, thanks.


> +               mutex_lock(&fs_info->reloc_mutex);
> +               list_splice_init(&rc->reloc_roots, &reloc_roots);
> +               mutex_unlock(&fs_info->reloc_mutex);
> +               abort_reloc_roots(rc, &reloc_roots);
> +       } else if (ret) {
>                 btrfs_handle_fs_error(fs_info, ret, NULL);
>                 free_reloc_roots(&reloc_roots);
>
> @@ -1996,6 +2035,7 @@ void merge_reloc_roots(struct reloc_control *rc)
>          *
>          * The remaining nodes will be cleaned up by put_reloc_control().
>          */
> +       return ret;
>  }
>
>  static void free_block_list(struct rb_root *blocks)
> @@ -3725,7 +3765,9 @@ static noinline_for_stack int relocate_block_group(=
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
> @@ -5694,7 +5736,9 @@ int btrfs_recover_relocation(struct btrfs_fs_info *=
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
