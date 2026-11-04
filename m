Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793814143;
	b=Q7PZ2mAGtnq8xa4yQuGPL57PNzda6RuK1NaJsBjxzq4X+PzC010jTmtlRMErON/FU8pY
	 Udn1DRH5IsB1oxgKUyrGEJKIUYWpIQNUp8qZg+5wxGFjNMm7vyFKAIgx7WqYvl68Mdnt9
	 cTCkEI8njShBI5SOAuSwpaZwH3bhVr3AToGC725KmwCoKO5UAm/ZGJOqqDT/9kwfTJ457
	 VuqwJeZsgdBTkTB3MM95HmHfinBnFf814SxZIBTFOfezhypctl0+JNu85IavtJ5GExl8H
	 S1Rs8QqXM3pbG0C/co1wie7sUtGGvJo+8O823FriKcqRQzlbz/YObSjSP1LlWmEMnHQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793814143;
	h=Received:DKIM-Signature:Received:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:
	 Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=9k9BBVrz1GanrbqteD0MkFQTf5wuZ/oAZS4lzUDswSU=;
	b=a1ebRfpZZGnY2psnfrSQCwEzQENuA0XYwtI5qpO+K7v3MBYyjYmxvZ03iF0DTvfBWLXc
	 OUfRmiQfXRDFu7DxKPArnLebEm65wSDqDl2IOfvepBz7fNHbhXEV4wmMFhMqVWgIQIbBS
	 /T/s7x+7gNw5I6lIjHAfEzpAa0fgFutBRLbz/bysPtnW06JSuWjvQCr0ycZqiXQ+xEOuW
	 Znw/b7bEBzi1gipsYYZQbIe7cnXtpjOZ47aFPa1PFDfoOv48rVD70TnM0Fr3Vjb3A90je
	 gFtJijPgoclahvjzUen9oicdfubIeAjiiHAbj2hDt+QZoOvyN3PpWFv4zhvmlwlySqA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Yo+CwqdK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74BB9606A328
	for <linux-btrfs@vger.kernel.org>; Wed,  4 Nov 2026 17:42:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Yo+CwqdK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38DA81F0093A
	for <linux-btrfs@vger.kernel.org>; Wed,  4 Nov 2026 17:42:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793814143;
	bh=9k9BBVrz1GanrbqteD0MkFQTf5wuZ/oAZS4lzUDswSU=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=Yo+CwqdKhlGAbjz22M5BdKnfNj6pmNVHw6069gZpaEatPUJmuhn+m3ZDny46uUdW2
	 kgiKTqQOiHNZKNzYcVtYf85oGceTc6W9TGYjcQDjNoftx452VkL6hFL3/lsSSUuiZ7
	 invSQLJWL5xkCkDeoJgj6jcq5xWFdu9z1opBnpQ3d8HWtDent5rCnnHbg5Y/yUoL9h
	 gLpilkcmPHdIFBosggpVgcTv1wCBxEZpCIUQJzYw2K6MBTxnR7Tb57OhyMiLQ+dC8w
	 2FCMaz4wQ4afyDLwRCCIutdHRc9gxUSoDKsXtpmd4nfdFcN+3M9ndnQZ8pZrelXhft
	 O4dXmyCarTUNg==
Received: by mail-ua1-f42.google.com with SMTP id a1e0cc1a2514c-998318396ecso251066241.0
        for <linux-btrfs@vger.kernel.org>; Wed, 04 Nov 2026 09:42:23 -0800 (PST)
X-Forwarded-Encrypted: i=1; AKwUvByLui+Oox/Xsnb+xb/VTxyLrQBSEqboBjLE9XPsyDOwMfCB536fwEO8wvZbD+k2DHsDzhQXLLkfuBgIww==@vger.kernel.org
X-Gm-Message-State: APuU4Z9p5Moq4pN00Omrtvjc40kjOx51BPeiwjVNm6WHwBdDmhyOJHTE
	oR5YBMaAAeVAGJ4KXUzLYRgUCFT+iYLgwPxVVMPmVXb9NvF75aFEM+hVLm5O34AAtN5gqTK7wMs
	vROKxuQngsGuAFXnXpxS1Fz4x8FlCJrc=
X-Received: by 2002:a05:6102:5811:b0:7c5:4da3:aefd with SMTP id
 ada2fe7eead31-7d072c25cf0mr6579776137.15.1793814142403; Wed, 04 Nov 2026
 09:42:22 -0800 (PST)
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261104082834.25047-1-shishunbo@cmss.chinamobile.com>
In-Reply-To: <20261104082834.25047-1-shishunbo@cmss.chinamobile.com>
From: Filipe Manana <fdmanana@kernel.org>
Date: Wed, 4 Nov 2026 17:41:45 +0000
X-Gmail-Original-Message-ID: <CAL3q7H6w1sY5R_+Ajg-uHYx_=KjeUwyt5Aw=Zj+qViLXKcB+_A@mail.gmail.com>
X-Gm-Features: AclHuK8HDQ0pZyMDKLC_Xe3zpQz0Mb69DnVe1-Rt08Do8KQuc6OGMoDXeGFl-5U
Message-ID: <CAL3q7H6w1sY5R_+Ajg-uHYx_=KjeUwyt5Aw=Zj+qViLXKcB+_A@mail.gmail.com>
Subject: Re: [PATCH] btrfs: fix delayed_refs_rsv leak when realloc shrinks an extent
To: Shunbo Shi <shishunbo@cmss.chinamobile.com>
Cc: dsterba@suse.com, mason@kernel.org, jbacik@fb.com, 
	linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzbot+7ec60f4482abeecb0fd8@syzkaller.appspotmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 4, 2026 at 8:28=E2=80=AFAM Shunbo Shi
<shishunbo@cmss.chinamobile.com> wrote:
>
> When a data extent is freed and reallocated (with a smaller size)
> before its delayed refs are processed, update_existing_head_ref()
> updates existing->num_bytes to the new size while the extent is
> still in the " csum reservation\ state (total_ref_mod < 0).

This last part of the sentence is unintelligible... an opening quote
without an ending quote, a backslash for no reason, and everything
after the opening quote doesn't make any sense.

Something like:

... updates existing->num_bytes but does neither adjusts the space
used for checksums nor releases excess space from the delayed refs
block reserve.


>
> The csum space for deleting the checksums was reserved for the
> original size in add_delayed_ref_head():
>
>  pending_csums +=3D head_ref->num_bytes;
>  trans->delayed_ref_csum_deletions +=3D csum_leaves(num_bytes);
>
> but when total_ref_mod later turns non-negative,
> update_existing_head_ref() releases the reservation based on the
> new, smaller num_bytes:
>
>  pending_csums -=3D existing->num_bytes;
>  btrfs_delayed_refs_rsv_release(fs_info, 0, csum_leaves);
>
> The difference between the old and the new size is never released,
> so delayed_refs_rsv.size (and .reserved) stay above zero forever.
> At unmount this triggers
>
>  WARNING: fs_info->delayed_refs_rsv.reserved > 0
>  at btrfs_release_global_block_rsv
>
> and at runtime the leaked reservation keeps inflating
> space_info->bytes_may_use, which can lead to premature ENOSPC.
>
> Fix this by adjusting the csum accounting to the new size at the
> time existing->num_bytes is updated: if the head is still in the
> reservation state, release the difference in csum leaves (or add
> it, if the extent grew) and update pending_csums accordingly, so
> that the release in the total_ref_mod transition stays symmetric
> with the reservation.
>
> Fixes: ba2c4d4e3bda ("btrfs: introduce delayed_refs_rsv")
> Reported-by: syzbot+7ec60f4482abeecb0fd8@syzkaller.appspotmail.com
> Link: https://lore.kernel.org/linux-btrfs/6ae88b9e.64e51036.15cf6a.0027.G=
AE@google.com/
> Signed-off-by: Shunbo Shi <shishunbo@cmss.chinamobile.com>
> ---
>  fs/btrfs/delayed-ref.c | 28 ++++++++++++++++++++++++++++
>  1 file changed, 28 insertions(+)
>
> diff --git a/fs/btrfs/delayed-ref.c b/fs/btrfs/delayed-ref.c
> index 8bc1929237f7..a3e32f08dacc 100644
> --- a/fs/btrfs/delayed-ref.c
> +++ b/fs/btrfs/delayed-ref.c
> @@ -694,6 +694,34 @@ static noinline void update_existing_head_ref(struct=
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
> +                * total_ref_mod turns non-negative below releases less t=
han
> +                * what was reserved and delayed_refs_rsv leaks the
> +                * difference.
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
> +                       if (new_leaves < old_leaves)
> +                               btrfs_delayed_refs_rsv_release(fs_info, 0=
,
> +                                               old_leaves - new_leaves);
> +                       else if (new_leaves > old_leaves)
> +                               trans->delayed_ref_csum_deletions +=3D
> +                                       new_leaves - old_leaves;

We can't update delayed_ref_csums_deletions blindly without looking
into existing->total_ref_mod.
This else branch should be:

else if (new_leaves > old_leaves && existing->total_ref_mod < 0)

And I probably missed something more.
Sashiko is complaining about that I think and more:

https://sashiko.dev/#/patchset/20261104082834.25047-1-shishunbo%40cmss.chin=
amobile.com

Thanks.



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
> --
> 2.53.0
>
>
>
>
