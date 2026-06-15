Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69F34339705
	for <linux-btrfs@vger.kernel.org>; Mon, 15 Jun 2026 11:31:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781523092; cv=none; b=r+BsNlbkF19ZltuohZ9JB7ZdzftC6ykM94TgTZYS08EnNT7u9/agC7yZxXW7yb5CK4zUul065NqVhqPObAXJB1j9MbN76k0uDiQwYT5ITtmsdBud6J7HZSE0eGhQ489Ckx3s149xjlmS69lqvE/yfhOck3fITKJ9mi2f1bY2zrs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781523092; c=relaxed/simple;
	bh=NGyPAXX3VT+s1Qe6scE6o4/dHMDFybVHHVWxLIqboqQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=mgJcyKEkqMenNn49hDd7pLMy1sExOjEtuqG3Cz5vTZAJSmCZyHCD0QRhCj+8tXO6KCzWpPJ53zPB9oRTtrVdZylV7SsymaGhvdxGuGNnflg/yOBxpR/mPwQLnui76VLpDsgQVp07zvpybhT7zTsTSGG71eFRXnyc3IyuSJ9rmVk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RbK/oDy6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RbK/oDy6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 081591F000E9
	for <linux-btrfs@vger.kernel.org>; Mon, 15 Jun 2026 11:31:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781523091;
	bh=a5EzJAHXMPXaBy1OEcbvoPvr0GeiKnSdm3z1g5YS2iM=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=RbK/oDy6o1EcfR1HI8dswJPVX3ZOOrmVVaDs0/orQjyoeplD9Yr0rigwptfnMyvNE
	 E+5gz70GuEz0KIABjqZDPv4KQPVxfaKRPMCVD7ufuss5+Y4WkOE2KBCFINXsexIihr
	 tJM+0aHz93wReqL/kGawMPV6LBWn6G3Absv0AjDNcmLlq360EToRsTFp5uMeOt+H+G
	 vyOYdnCBKBDsvQjXqjSWHLK058MAzvoAS9jTSb6e2m1NoQSqKFb1BthT7RmEMlV5e+
	 R2wBcgRYHp0pbOLbG4lPnrmbi4QZ6IeiaozA8D3HAvWHYLt1V3x+sS7lreUpIih9+Z
	 cvMi73XPnW7Jg==
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-befee9e5ef7so375155766b.0
        for <linux-btrfs@vger.kernel.org>; Mon, 15 Jun 2026 04:31:30 -0700 (PDT)
X-Gm-Message-State: AOJu0Yw1m6uLgeio6PLQIGfzHNVb2hE08EGiPnT2gFvLbbqMZs42y4fu
	44WKAP+PUDhRojrsyU+2FqHr4J770qeSZC93XB7lyzdGf150V7hL3XrVAPfjlSyV1qePuUmRmM2
	pZvMKG34QRDU8G7+skOa7QgrnlbQg6LA=
X-Received: by 2002:a17:907:75c8:b0:bed:17a8:4c95 with SMTP id
 a640c23a62f3a-bfe2bea9caamr469832966b.45.1781523089602; Mon, 15 Jun 2026
 04:31:29 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <7c78c0a89b825e6bd3759e425a5e69ea338cf976.1781499135.git.wqu@suse.com>
In-Reply-To: <7c78c0a89b825e6bd3759e425a5e69ea338cf976.1781499135.git.wqu@suse.com>
From: Filipe Manana <fdmanana@kernel.org>
Date: Mon, 15 Jun 2026 12:30:51 +0100
X-Gmail-Original-Message-ID: <CAL3q7H6G2gGuhKQ_v3nP-cKm+5xoM8YPt_jkOupO4Kc3Q2eQvw@mail.gmail.com>
X-Gm-Features: AVVi8Ce9Mqaua3FRkrmbUar3e8v6RkCSz-lhWx6BINR0EdPM__wrImjAsQu6doU
Message-ID: <CAL3q7H6G2gGuhKQ_v3nP-cKm+5xoM8YPt_jkOupO4Kc3Q2eQvw@mail.gmail.com>
Subject: Re: [PATCH] btrfs: log swapfile activation/deactivation and warn
 about pinned block groups
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 15, 2026 at 5:52=E2=80=AFAM Qu Wenruo <wqu@suse.com> wrote:
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

For scrub we already log a warning when we skip a block group due to
pinned extents for a swapfile.

>
> - Unbalanced data and metadata usage, meanwhile relocation won't help
>   The same reason, pinned down block groups will not be considered as
>   relocation target, thus data extents that are not utilized by the swap
>   file can still be skipped from relocation.

For relocation we don't log such a warning message, we just return
-ETXTBSY in btrfs_relocate_block_group().
It would be better to log a message here too.

>
> To better communicate those potential long term problems, add the
> following output into dmesg:
>
> - Total pinned down block group size during swapfile activation
> - Total released block group size during swapfile deactivation
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
own 2147483648 bytes of block groups
>  BTRFS warning (device dm-3): any extent in pinned block groups will not =
be able to be scrubbed nor balanced
>  Adding 1257468k swap on /mnt/btrfs/foobar.  Priority:-1 extents:1 across=
:1257468k
>  BTRFS info (device dm-3): swapfile deactivated on root 5 ino 257, releas=
ed 2147483648 bytes of block groups
>
> Signed-off-by: Qu Wenruo <wqu@suse.com>
> ---
>  fs/btrfs/inode.c | 23 +++++++++++++++++++++--
>  1 file changed, 21 insertions(+), 2 deletions(-)
>
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index 16f097f58acc..288dc323d1c2 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -10011,6 +10011,7 @@ static void btrfs_free_swapfile_pins(struct inode=
 *inode)
>         struct btrfs_fs_info *fs_info =3D BTRFS_I(inode)->root->fs_info;
>         struct btrfs_swapfile_pin *sp;
>         struct rb_node *node, *next;
> +       u64 bg_released =3D 0;
>
>         spin_lock(&fs_info->swapfile_pins_lock);
>         node =3D rb_first(&fs_info->swapfile_pins);
> @@ -10020,15 +10021,22 @@ static void btrfs_free_swapfile_pins(struct ino=
de *inode)
>                 if (sp->inode =3D=3D inode) {
>                         rb_erase(&sp->node, &fs_info->swapfile_pins);
>                         if (sp->is_block_group) {
> -                               btrfs_dec_block_group_swap_extents(sp->pt=
r,
> +                               struct btrfs_block_group *bg =3D sp->ptr;
> +
> +                               bg_released +=3D bg->length;
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
> +       "swapfile deactivated on root %llu ino %llu, released %llu bytes =
of block groups",

of -> from

It could be useful to also log the number of block groups (just add a
counter and print it).

> +                  btrfs_root_id(BTRFS_I(inode)->root),
> +                  btrfs_ino(BTRFS_I(inode)), bg_released);
>  }
>
>  struct btrfs_swap_info {
> @@ -10108,6 +10116,7 @@ static int btrfs_swap_activate(struct swap_info_s=
truct *sis, struct file *file,
>         int ret =3D 0;
>         u64 isize;
>         u64 prev_extent_end =3D 0;
> +       u64 pinned_bg_size =3D 0;
>
>         /*
>          * Acquire the inode's mmap lock to prevent races with memory map=
ped
> @@ -10357,6 +10366,8 @@ static int btrfs_swap_activate(struct swap_info_s=
truct *sis, struct file *file,
>                                 ret =3D 0;
>                         else
>                                 goto out;
> +               } else {
> +                       pinned_bg_size +=3D bg->length;
>                 }
>
>                 if (bsi.block_len &&
> @@ -10404,6 +10415,14 @@ static int btrfs_swap_activate(struct swap_info_=
struct *sis, struct file *file,
>         if (ret)
>                 return ret;
>
> +       btrfs_info(fs_info,
> +"swapfile activated on root %llu ino %llu, pinned down %llu bytes of blo=
ck groups",

of -> from

Also a counter for the number of block groups would be informative.

> +                  btrfs_root_id(BTRFS_I(inode)->root),
> +                  btrfs_ino(BTRFS_I(inode)),
> +                  pinned_bg_size);
> +       btrfs_warn(fs_info,
> +"any extent in pinned block groups will not be able to be scrubbed nor b=
alanced");

The phrasing is a bit misleading - it gives the idea that only the
extents of a swap file cannot be scrubbed/balanced, i,.e. that other
extents in the same block group can be scrubbed/balanced.
We should make it clear that an entire block group cannot be
scrubbed/balanced because it has extents used by a swapfiles.

Something like:

"block groups with swapfile extents will not be scrubbed or balanced"

Otherwise it looks fine to me, thanks.


> +
>         if (device)
>                 sis->bdev =3D device->bdev;
>         *span =3D bsi.highest_ppage - bsi.lowest_ppage + 1;
> --
> 2.54.0
>
>
