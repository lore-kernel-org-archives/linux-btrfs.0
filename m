Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793901786;
	b=nRV4chW+nMA0daDCzNpEYE2egu8MBeLYyFvaDesotPJTryGr37ylTTig/qJ9otYl8vyD
	 ZV9bSpg/q4nOrFiNYdwv1/1OfAss0y9BU3w4D8oehB1NZ6NPdWh3FZ+Rixuc0/jGiLz15
	 Uc4o+UdtEwxGUn+9H5olHZ82eObAv1vmAx1VKAcQq+3TMChRWKqbIAr4yblwHdCaQwFKt
	 AVj4rXiosHtjFWd1aGfOfMUiS/JUf4A3pfd0FkVTQzfcI3pXBvK4wiW0zLG8E5adTlmrZ
	 +nNFkWH+WyrcJpDxrncS3qF/zO5nIJRcmo2mFXge8TePgG7a+VdyOTSaJd9JobQr0SQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793901786;
	h=Received:DKIM-Signature:Received:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:
	 Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=GwPyrlnKq19yfZdgGX9E8p1iXEWilgeEUNe3oswQZM0=;
	b=0N6BiAissCF1E8+Ey2pADoyMPVZKDe4SFznCXY625Z5pAeuGrP2WX8kB+DzqrF/W0Mlq
	 6yKOezYOLOe4GGOlNSwtfYWLzgszsghkzeRfkL+yjTnob470ttnCWmeqRCaSo1t8NvNdk
	 I11CztqnszHm0/czqY04PLYr7OOFWC6UTpOcrcNBdu2XhgObSPzrNLSwNzzFyZ8O+acTT
	 GkZCKvtmS90oIKAsVnQplBlcRe9ckqIM0EgXuJftonVtBHInGx+4NZH3SXxObAVc4EMk2
	 5kMWz/G3ZTRBU2S45oOhe1wFcjaTuRcKebFQ3V+DbQNLIQ7Buv797psAcRjDJQ06KXg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OfH1qlY8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEF19606A326
	for <linux-btrfs@vger.kernel.org>; Thu,  5 Nov 2026 18:03:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OfH1qlY8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 977A11F0093A
	for <linux-btrfs@vger.kernel.org>; Thu,  5 Nov 2026 18:03:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793901784;
	bh=GwPyrlnKq19yfZdgGX9E8p1iXEWilgeEUNe3oswQZM0=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=OfH1qlY8/KFyZe7mgeo2KMOouXCzNGpJBnbtOg6zuQ48dV0Eys8hcfILTMUD2q2Fz
	 TSgKQesJ1DACDI9t9POfID7qsAvZoCwg9mfRZf5uSIogrOxF/CuN4/+br2yk26HowO
	 avZf+9NBhAoQPd4wtLebvMV4R7AAER6GNnE2jI4oUILuFhhv8frZL9MThghkOcaEYh
	 S3fnSuoZGoJdxPoFnEbPKy7WxRieOl8wQQ+AilqkezquW3cs06zAuNnuEqihKRdpeX
	 HeIxr255i5KkDUkjdszEc6dww/zAC1NJfWrPO2CyquEAaNRX4md9+VwzY+UUvQ8Kiy
	 JbUHt0PTJ9LNQ==
Received: by mail-vs1-f48.google.com with SMTP id ada2fe7eead31-7ce78f9d6baso679225137.0
        for <linux-btrfs@vger.kernel.org>; Thu, 05 Nov 2026 10:03:04 -0800 (PST)
X-Forwarded-Encrypted: i=1; AKwUvByN9LBeGXnO4l3OazEhUMe8tleEhm75t1ZC4Mr+16uAD5zgaestf7/I7tyb1kVukeHb1oa+7/EKXioKSg==@vger.kernel.org
X-Gm-Message-State: APuU4Z8ad48dR/TJh4txZAkcB2tdz4a8LYrtdhWLgaj5udy/jvhWdW8/
	hBDPGlWVstdbV6y7PMJBpH7JL2i9mIRNqCi1fyPDCTBjhjU1RAu7hkIrInsyIhjfQtsAr2FGKEg
	FgLjqHsCyPu7uW7AT+Ci+RMfwcGmoUpo=
X-Received: by 2002:a05:6102:570b:b0:7c2:e5bb:d20c with SMTP id
 ada2fe7eead31-7d286b5b47fmr2069338137.34.1793901783690; Thu, 05 Nov 2026
 10:03:03 -0800 (PST)
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <CAL3q7H6w1sY5R_+Ajg-uHYx_=KjeUwyt5Aw=Zj+qViLXKcB+_A@mail.gmail.com>
 <20261105104453.2151-1-shishunbo@cmss.chinamobile.com>
In-Reply-To: <20261105104453.2151-1-shishunbo@cmss.chinamobile.com>
From: Filipe Manana <fdmanana@kernel.org>
Date: Thu, 5 Nov 2026 18:02:25 +0000
X-Gmail-Original-Message-ID: <CAL3q7H7sKbmDocpBjBT3GkqaZwGYCR-A4iyW0TAcNj=sgsDTgg@mail.gmail.com>
X-Gm-Features: AclHuK8sRFV15saRcot9eG0yBZPruX7Vv5MUiW8IZyaLB5vrU7JdT_lIOUX-OJs
Message-ID: <CAL3q7H7sKbmDocpBjBT3GkqaZwGYCR-A4iyW0TAcNj=sgsDTgg@mail.gmail.com>
Subject: Re: [PATCH v2] btrfs: fix delayed_refs_rsv leak when realloc shrinks
 an extent
To: Shunbo Shi <shishunbo@cmss.chinamobile.com>
Cc: dsterba@suse.com, mason@kernel.org, linux-btrfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, 
	syzbot+7ec60f4482abeecb0fd8@syzkaller.appspotmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 5, 2026 at 10:45=E2=80=AFAM Shunbo Shi
<shishunbo@cmss.chinamobile.com> wrote:
>
> When a data extent is freed and reallocated (with a different size)
> before its delayed refs are processed,
> btrfs_alloc_reserved_file_extent() reuses the existing delayed ref
> head and update_existing_head_ref() updates existing->num_bytes to
> the new size, but neither adjusts the space used for checksums nor
> releases excess space from the delayed refs block reserve.
>
> The csum space for deleting the checksums was reserved for the
> original size in add_delayed_ref_head():
>
>         pending_csums +=3D head_ref->num_bytes;
>         trans->delayed_ref_csum_deletions +=3D csum_leaves(num_bytes);
>
> but when total_ref_mod later turns non-negative,
> update_existing_head_ref() releases the reservation based on the
> new num_bytes:
>
>         pending_csums -=3D existing->num_bytes;
>         btrfs_delayed_refs_rsv_release(fs_info, 0, csum_leaves);
>
> For a smaller new size the difference between the old and the new
> size is never released, so delayed_refs_rsv.size (and .reserved)
> stay above zero forever.  At unmount this triggers
>
>         WARNING: fs_info->delayed_refs_rsv.reserved > 0
>         at btrfs_release_global_block_rsv
>
> and at runtime the leaked reservation keeps inflating
> space_info->bytes_may_use, which can lead to premature ENOSPC.
>
> For a larger new size the release subtracts more than what was
> reserved for the head: if the rsv does not hold reservations of
> other delayed refs, delayed_refs_rsv.size underflows and leaks
> reserved bytes; otherwise the rsv prematurely releases reservations
> belonging to other delayed refs.
>
> Fix this by adjusting the csum accounting to the new size at the
> time existing->num_bytes is updated, while the head is still in the
> reservation state (total_ref_mod < 0): release the difference in
> csum leaves for a smaller size, and grow the rsv size by the
> difference for a larger size.  The grow direction must take effect
> immediately (btrfs_delayed_refs_rsv_add()) rather than via
> trans->delayed_ref_csum_deletions, because the total_ref_mod
> transition below may release the new size in the same call, while
> the trans counter is only folded into the rsv afterwards by
> btrfs_update_delayed_refs_rsv().
>
> Fixes: ba2c4d4e3bda ("btrfs: introduce delayed_refs_rsv")
> Reported-by: syzbot+7ec60f4482abeecb0fd8@syzkaller.appspotmail.com
> Link: https://lore.kernel.org/linux-btrfs/6ae88b9e.64e51036.15cf6a.0027.G=
AE@google.com/
> Signed-off-by: Shunbo Shi <shishunbo@cmss.chinamobile.com>
> ---
>  fs/btrfs/delayed-ref.c | 61 ++++++++++++++++++++++++++++++++++++++++++
>  fs/btrfs/delayed-ref.h |  4 ++-
>  2 files changed, 64 insertions(+), 1 deletion(-)
>
> diff --git a/fs/btrfs/delayed-ref.c b/fs/btrfs/delayed-ref.c
> index 8bc1929237f7..45e269670068 100644
> --- a/fs/btrfs/delayed-ref.c
> +++ b/fs/btrfs/delayed-ref.c
> @@ -63,6 +63,31 @@ bool btrfs_check_space_for_delayed_refs(struct btrfs_f=
s_info *fs_info)
>   * Drops the delayed ref head's count from the delayed refs rsv and free=
 any
>   * excess reservation we had.
>   */
> +/*
> + * Grow the delayed refs rsv size for csum items to be deleted.
> + *
> + * Unlike trans->delayed_ref_csum_deletions, which is folded into the
> + * delayed refs rsv by  at a later point,
> + * this adjusts the size immediately.  It is needed when a ref head's
> + * num_bytes is updated to a larger size and the head's reservation is
> + * released in the same call to update_existing_head_ref(): the release
> + * path subtracts from the rsv right away, so the size must cover the
> + * new csum leaves before that happens, otherwise the rsv would
> + * over-release reservations of other delayed refs.
> + */
> +void btrfs_delayed_refs_rsv_add(struct btrfs_fs_info *fs_info, int nr_cs=
ums)
> +{
> +       struct btrfs_block_rsv *block_rsv =3D &fs_info->delayed_refs_rsv;
> +       u64 num_bytes;
> +
> +       num_bytes =3D btrfs_calc_delayed_ref_csum_bytes(fs_info, nr_csums=
);
> +
> +       spin_lock(&block_rsv->lock);
> +       block_rsv->size +=3D num_bytes;
> +       block_rsv->full =3D (block_rsv->reserved >=3D block_rsv->size);
> +       spin_unlock(&block_rsv->lock);
> +}

First thing:

You are adding a new function, and its comment, between an existing
function and its comment.
This is messy. Also the limit for comments is 80 characters per line,
and this comment uses significantly less - the lines can be widened
for better readability.

Second:

Why export the function? Since it's only used in this file, it should be st=
atic.

Third:

Why exactly do we need it?
We should update trans->delayed_ref_csum_deletions and then let the
call to btrfs_update_delayed_refs_rsv() done up the callchain (at
add_delayed_ref()) do the updates to the global delayed refs reserve.
It's not clear to me why we can't simply do that.


> +
>  void btrfs_delayed_refs_rsv_release(struct btrfs_fs_info *fs_info, int n=
r_refs, int nr_csums)
>  {
>         struct btrfs_block_rsv *block_rsv =3D &fs_info->delayed_refs_rsv;
> @@ -694,6 +719,42 @@ static noinline void update_existing_head_ref(struct=
 btrfs_trans_handle *trans,
>                 existing->must_insert_reserved =3D update->must_insert_re=
served;
>                 existing->owning_root =3D update->owning_root;
>
> +               /*
> +                * The extent may have been reallocated with a different
> +                * size before its delayed refs were processed.  The csum
> +                * reservation was made for the old size (see
> +                * add_delayed_ref_head()), so adjust the accounting to t=
he
> +                * new size here; otherwise the release done when
> +                * total_ref_mod turns non-negative below is based on the
> +                * new size while only the old size was reserved: for a
> +                * smaller size the difference is leaked, for a larger si=
ze
> +                * the rsv over-releases reservations of other delayed re=
fs.
> +                *
> +                * Both adjustments must take effect immediately: the
> +                * total_ref_mod transition below may release new_leaves =
in
> +                * this same call, while trans->delayed_ref_csum_deletion=
s
> +                * is only folded into the rsv by
> +                * btrfs_update_delayed_refs_rsv() after we return.
> +                */
> +               if (existing->is_data && existing->total_ref_mod < 0 &&
> +                   existing->num_bytes !=3D update->num_bytes) {
> +                       u64 old_leaves =3D btrfs_csum_bytes_to_leaves(fs_=
info,
> +                                                          existing->num_=
bytes);
> +                       u64 new_leaves =3D btrfs_csum_bytes_to_leaves(fs_=
info,
> +                                                           update->num_b=
ytes);
> +
> +                       if (new_leaves < old_leaves) {
> +                               btrfs_delayed_refs_rsv_release(fs_info, 0=
,
> +                                              (int)(old_leaves - new_lea=
ves));
> +                       } else if (new_leaves > old_leaves) {
> +                               btrfs_delayed_refs_rsv_add(fs_info,
> +                                              (int)(new_leaves - old_lea=
ves));
> +                       }

For if statements, we only use { } when there's more than one
statement in a branch. Since in both cases it's a single statement,
please remove the  { }.

> +
> +                       delayed_refs->pending_csums +=3D update->num_byte=
s;
> +                       delayed_refs->pending_csums -=3D existing->num_by=
tes;
> +               }
> +
>                 /*
>                  * update the num_bytes so we make sure the accounting
>                  * is done correctly
> diff --git a/fs/btrfs/delayed-ref.h b/fs/btrfs/delayed-ref.h
> index 5ce940532144..f8434347b80b 100644
> --- a/fs/btrfs/delayed-ref.h
> +++ b/fs/btrfs/delayed-ref.h
> @@ -408,7 +408,9 @@ struct btrfs_delayed_ref_node *btrfs_select_delayed_r=
ef(struct btrfs_delayed_ref
>
>  int btrfs_check_delayed_seq(struct btrfs_fs_info *fs_info, u64 seq);
>
> -void btrfs_delayed_refs_rsv_release(struct btrfs_fs_info *fs_info, int n=
r_refs, int nr_csums);
> +void btrfs_delayed_refs_rsv_release(struct btrfs_fs_info *fs_info, int n=
r_refs,
> +                                    int nr_csums);

We don't mix formatting changes without functional changes.
Leave it as it was. It's a 94 characters line, and that's fine for
today's standards.

Finally, sashiko is still complaining about the same issues as in v1:

https://sashiko.dev/#/patchset/20261105104453.2151-1-shishunbo%40cmss.china=
mobile.com

Thanks.

> +void btrfs_delayed_refs_rsv_add(struct btrfs_fs_info *fs_info, int nr_cs=
ums);
>  void btrfs_update_delayed_refs_rsv(struct btrfs_trans_handle *trans);
>  void btrfs_inc_delayed_refs_rsv_bg_inserts(struct btrfs_fs_info *fs_info=
);
>  void btrfs_dec_delayed_refs_rsv_bg_inserts(struct btrfs_fs_info *fs_info=
);
> --
> 2.53.0
>
>
>
