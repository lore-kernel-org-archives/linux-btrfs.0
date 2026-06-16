Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEE5737703B
	for <linux-btrfs@vger.kernel.org>; Tue, 16 Jun 2026 10:19:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781605150; cv=none; b=A6P0j3SRZV6t4rdNQLU7IsMXZd1cv7CeO34NELQ4/o2EU/ttTOqqHuuUvNa0xfzwi0Ijcui022M10+xWfTvXQ1M8yKXCZBy1HuNxgruwr2Rq+JdyTwXWd0kJsquaNNvtc12oW3xn3E9VfStlMYaKDiO2H2YRTp9Jh1qNHau2ex0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781605150; c=relaxed/simple;
	bh=QefN4+DUU43uV9wTutmeanIV7QePA4Tl3Y9JSuHJ940=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=nv0fgIl5W4yuYO8vrl2hobecngSrghNuEosisGKoSugQxivXXCw1EHrpF5p6iKH+E69ACIe4R87qle4RqZ3pzQoamOOXHT3d8kRWCTmU4ZHWFZJ+l7+x/jXQNqCCsO0xgcHcoiCiydnu+DznpB/6zOPV+8WTc3HzcPRV9M0qyYc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iqGWSRvF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iqGWSRvF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC98D1F00A3A
	for <linux-btrfs@vger.kernel.org>; Tue, 16 Jun 2026 10:19:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781605149;
	bh=K1bApvLiTA2Itmn9H4tY4vCGJvsRy9MVRBEMOdWdq04=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=iqGWSRvFAGoCScqYvETVPVStxNrzjONU7mT0vGGjhGqpATSZfYA8qrwAm7hiHkYM1
	 wGR8KA4o81jNAJey4e1JOYdNoLBr4igtSfbk7BSkARAktqOT+Vq0Xls3khiy1HZG0u
	 W9VsN5frpLvIu8PcDRRiubRumsK1p8XgTxu9408dsSvd53mbDJsEy69XDGAkdwY8pc
	 UlXHjD60FtbrfcBLzibtZmqc7E0gI8RkcLQ6+af5rECa7iIPkyeMbRtkpJm/sLwO/0
	 0+Q+iusIcYEeNuWBzs9GCZ4kpm31F7C7f3WmF9RvvP8ui09tQ7xREN29AxOsZFcqo/
	 wl2ZGVcavasVQ==
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-bec4639953dso723345966b.1
        for <linux-btrfs@vger.kernel.org>; Tue, 16 Jun 2026 03:19:09 -0700 (PDT)
X-Gm-Message-State: AOJu0Yy1SQMBiXD8NB5kiGACmt3QKkMJG1i890D3nFV4G11iU0HWC3/v
	Kololy/0xiXgIegB35mxeKJtmFB6HEVB0kwTxwpN/yfxBrxE8AIyYpyfsVj/tPK+2p6jpX/5mq9
	ucXlcUOgj0E8pwk0zjxt0Y2ePnZL0YSA=
X-Received: by 2002:a17:907:7615:b0:bd5:40d9:c6c9 with SMTP id
 a640c23a62f3a-c041381222fmr138608166b.0.1781605148205; Tue, 16 Jun 2026
 03:19:08 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <19331955f516f43fd8da4bae49c7aaaea07e2379.1781567582.git.wqu@suse.com>
In-Reply-To: <19331955f516f43fd8da4bae49c7aaaea07e2379.1781567582.git.wqu@suse.com>
From: Filipe Manana <fdmanana@kernel.org>
Date: Tue, 16 Jun 2026 11:18:31 +0100
X-Gmail-Original-Message-ID: <CAL3q7H4oXR_V4jMmVH=46au-=PLuk-2OVJqkmhaAZZDRORQaJw@mail.gmail.com>
X-Gm-Features: AVVi8CeMDY4u8v7Tz-bosj11dC6GjWuusPshyFkRHhXkYgUVwpSnl58pbI-vZz0
Message-ID: <CAL3q7H4oXR_V4jMmVH=46au-=PLuk-2OVJqkmhaAZZDRORQaJw@mail.gmail.com>
Subject: Re: [PATCH v2] btrfs: log swapfile activation/deactivation and warn
 about pinned block groups
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 16, 2026 at 12:55=E2=80=AFAM Qu Wenruo <wqu@suse.com> wrote:
>
> A swap file on btrfs will pin down block groups that cover the swap file
> extent.
>
> Pinned down block groups will be skipped for scrub and relocation.
>
> These degradation on critical btrfs maintenance operations is never
> properly educated to end users, and have already caused problems
> including:
>
> - Scrub finished too quick
>   Because the enabled swap file has pinned down most of the block
>   groups. Thus any file extents in those block groups, even not utilized
>   by the swap file, will be skipped from scrub.
>
> - Unbalanced data and metadata usage, meanwhile relocation won't help
>   The same reason, pinned down block groups will not be considered as
>   relocation target, thus data extents that are not utilized by the swap
>   file can still be skipped from relocation.
>
> Although we already have kernel messages for both scrub and balance, the
> balance one is still info level.
>
> To better communicate those potential long term problems, add the
> following output into dmesg:
>
> - Change the message level to warn for __btrfs_balance()
>
> - Total pinned down block group number and size during swapfile activatio=
n
> - Total released block group number and size during swapfile deactivation
>   The above messages have info level.
>
> - The fact that pinned down block groups will not be scrubbed nor
>   balanced
>   The above message has warning level.
>
> The example output would look like the following, for enabling a 1.2G
> swapfile, which pinned down 2G block groups:
>
>  BTRFS info (device dm-3): swapfile activated on root 5 ino 257, pinned d=
own 2147483648 bytes from 2 block group(s)
>  BTRFS warning (device dm-3): block groups with swapfile extents will not=
 be scrubbed or balanced
>  Adding 1257468k swap on /mnt/btrfs/foobar.  Priority:-1 extents:1 across=
:1257468k
>  BTRFS info (device dm-3): swapfile deactivated on root 5 ino 257, releas=
ed 2147483648 bytes from 2 block group(s)
>
> Signed-off-by: Qu Wenruo <wqu@suse.com>

Reviewed-by: Filipe Manana <fdmanana@suse.com>

Looks good, thanks.

> ---
> Changelog:
> v2:
> - Add the total number of block groups pinned down
> - Slightly reword the messages
> - Unify -ETXTBSY messages to warn level
> ---
>  fs/btrfs/inode.c   | 28 ++++++++++++++++++++++++++--
>  fs/btrfs/volumes.c |  2 +-
>  2 files changed, 27 insertions(+), 3 deletions(-)
>
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index 16f097f58acc..ebd1387fcc76 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -10011,6 +10011,8 @@ static void btrfs_free_swapfile_pins(struct inode=
 *inode)
>         struct btrfs_fs_info *fs_info =3D BTRFS_I(inode)->root->fs_info;
>         struct btrfs_swapfile_pin *sp;
>         struct rb_node *node, *next;
> +       u64 bg_bytes_released =3D 0;
> +       u32 bg_nr_released =3D 0;
>
>         spin_lock(&fs_info->swapfile_pins_lock);
>         node =3D rb_first(&fs_info->swapfile_pins);
> @@ -10020,15 +10022,24 @@ static void btrfs_free_swapfile_pins(struct ino=
de *inode)
>                 if (sp->inode =3D=3D inode) {
>                         rb_erase(&sp->node, &fs_info->swapfile_pins);
>                         if (sp->is_block_group) {
> -                               btrfs_dec_block_group_swap_extents(sp->pt=
r,
> +                               struct btrfs_block_group *bg =3D sp->ptr;
> +
> +                               bg_bytes_released +=3D bg->length;
> +                               bg_nr_released++;
> +                               btrfs_dec_block_group_swap_extents(bg,
>                                                            sp->bg_extent_=
count);
> -                               btrfs_put_block_group(sp->ptr);
> +                               btrfs_put_block_group(bg);
>                         }
>                         kfree(sp);
>                 }
>                 node =3D next;
>         }
>         spin_unlock(&fs_info->swapfile_pins_lock);
> +       btrfs_info(fs_info,
> +"swapfile deactivated on root %llu ino %llu, released %llu bytes from %u=
 block group(s)",
> +                  btrfs_root_id(BTRFS_I(inode)->root),
> +                  btrfs_ino(BTRFS_I(inode)), bg_bytes_released,
> +                  bg_nr_released);
>  }
>
>  struct btrfs_swap_info {
> @@ -10106,8 +10117,10 @@ static int btrfs_swap_activate(struct swap_info_=
struct *sis, struct file *file,
>         struct btrfs_backref_share_check_ctx *backref_ctx =3D NULL;
>         struct btrfs_path *path =3D NULL;
>         int ret =3D 0;
> +       u32 pinned_bg_nr =3D 0;
>         u64 isize;
>         u64 prev_extent_end =3D 0;
> +       u64 pinned_bg_size =3D 0;
>
>         /*
>          * Acquire the inode's mmap lock to prevent races with memory map=
ped
> @@ -10357,6 +10370,9 @@ static int btrfs_swap_activate(struct swap_info_s=
truct *sis, struct file *file,
>                                 ret =3D 0;
>                         else
>                                 goto out;
> +               } else {
> +                       pinned_bg_size +=3D bg->length;
> +                       pinned_bg_nr++;
>                 }
>
>                 if (bsi.block_len &&
> @@ -10404,6 +10420,14 @@ static int btrfs_swap_activate(struct swap_info_=
struct *sis, struct file *file,
>         if (ret)
>                 return ret;
>
> +       btrfs_info(fs_info,
> +"swapfile activated on root %llu ino %llu, pinned down %llu bytes from %=
u block group(s)",
> +                  btrfs_root_id(BTRFS_I(inode)->root),
> +                  btrfs_ino(BTRFS_I(inode)),
> +                  pinned_bg_size, pinned_bg_nr);
> +       btrfs_warn(fs_info,
> +"block groups with swapfile extents will not be scrubbed or balanced");
> +
>         if (device)
>                 sis->bdev =3D device->bdev;
>         *span =3D bsi.highest_ppage - bsi.lowest_ppage + 1;
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index 6eab4cc73ce4..2d132c827913 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -4588,7 +4588,7 @@ static int __btrfs_balance(struct btrfs_fs_info *fs=
_info)
>                 if (ret =3D=3D -ENOSPC) {
>                         enospc_errors++;
>                 } else if (ret =3D=3D -ETXTBSY) {
> -                       btrfs_info(fs_info,
> +                       btrfs_warn(fs_info,
>            "skipping relocation of block group %llu due to active swapfil=
e",
>                                    found_key.offset);
>                         ret =3D 0;
> --
> 2.54.0
>
>
