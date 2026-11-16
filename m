Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794830775;
	b=Kt4vmoWSuS6AaN4wbohwbvVaZ3Xx/s3BxLya74tJdsr07PxkbC9FanWQHpW2QGtINEZ5
	 a3h2MHpOJfQXBXqTVb6UGfeNwU1jixl990i7YS0Op6Q7w4lQ4m5t+z1nudwh3mMFWr2sM
	 l+moBdL9T4x2KDV12sPjYPg04n58c9JJ40Xfm47rXKkoJ3iNmMo0XtRGSD6rpY5NvtXsw
	 4xJbf0Z4pf2il/6HjNbyabFevO7ejJnr/1vHUKpp5ISNvQ71VSGQ6FMBLC3SlPmDC8z63
	 G7VJtN/HOTrVG+mh/MMhUEh3Wjhr6O2gKSr/5KQFHK+wfn1ym0bmhk/9PzzJKIYGCbg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794830775;
	h=Received:DKIM-Signature:Received:X-Gm-Message-State:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:
	 X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:Subject:To:Cc:
	 Content-Type:Content-Transfer-Encoding;
	bh=RYoGx2dTr6nfQNu8Ad2KiTOfYrxz9sf0m3wxcXohjTY=;
	b=0A/qR81tYQDxEB7L64EzvVEdSDBtj4mA+D4SA7ep6nZ7BG/g2OTKtRGh/CDFpgDo+OHo
	 ITazhahaDTbBZTzEzxaBJFJan68MmxfI5QiwzjQm27O66P8Q25ZIdnPRYoqyskEK8R/SF
	 ck68nW3rKTVk6ERjv6VZf84d4yTuLHZkPymSHMVYWpVranAtjdxRWMgKt28wnAXMAj2KZ
	 MftbJorziLdfauSNtAHIL15A4cKa0vot4OTXQ1QqW1HgKZ2gI1Vw0D3Pa1NfM5ftpAxD1
	 FHwGo3ck1i2+ZMunDaVqIAnCo/iNYmV6Y+u9Vdq7LwA+QHnWLE2DsXj41ETUU5w5cig==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=fPMk7asS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25E94606A329
	for <linux-btrfs@vger.kernel.org>; Mon, 16 Nov 2026 12:06:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=fPMk7asS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B40721F000C4
	for <linux-btrfs@vger.kernel.org>; Mon, 16 Nov 2026 12:06:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794830774;
	bh=RYoGx2dTr6nfQNu8Ad2KiTOfYrxz9sf0m3wxcXohjTY=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=fPMk7asS584CCH5hfEiVV+SnuqcA6mA1dfzfcGnRSIs0FhAYHrHj6t7vQnaf4lFHP
	 VmRtyCyH7Bm/E7W66UZXFLefnevH4EEaxUju70wwVsflyD62dyt3nlpdcA6C19g5TV
	 EkfZ3la0nIk3sjDATSDvYofzQDyqpzfMJdkPfEj6x6yw69KSjhNidLv2tuyouzpTAi
	 QOlveI6Q/FqHh3j6IF6EZnxI2ZOxx3vi7Iw+HHJe2G8xlYSRuPAksNrxAFXFTQxcZH
	 LUVDgPU0lDGWRo24oF11hPWVv1BxST3Qi8bheHGEDHuOOWDLh0+OPVKKENecLQdBr9
	 6o8esPDmThadQ==
Received: by mail-ua1-f52.google.com with SMTP id a1e0cc1a2514c-97ccbba8e86so656359241.3
        for <linux-btrfs@vger.kernel.org>; Mon, 16 Nov 2026 04:06:14 -0800 (PST)
X-Gm-Message-State: APuU4Z/J7mkq6+6FvAnDJaJWv2lJ1yEaF4Q7BjDtlun2+UX1PqhC8WZl
	flvWMrrip/mKn9HhZoj2G/PMVv9N5XUaapDiwKG9WUQIHL/1HwUV65kqWuU5Z9p5Id5KVA9z8//
	R1aArD7UWSaQsePG9yX6nXDSHT+rASYA=
X-Received: by 2002:a05:6102:504e:b0:7a7:19aa:f0d4 with SMTP id
 ada2fe7eead31-7d64d9eb4cfmr2624203137.33.1794830773868; Mon, 16 Nov 2026
 04:06:13 -0800 (PST)
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <07cff240bcc00f2c18128d339ca6f1544871cdd1.1794611345.git.boris@bur.io>
In-Reply-To: <07cff240bcc00f2c18128d339ca6f1544871cdd1.1794611345.git.boris@bur.io>
From: Filipe Manana <fdmanana@kernel.org>
Date: Mon, 16 Nov 2026 12:05:37 +0000
X-Gmail-Original-Message-ID: <CAL3q7H6+NOB7pTqE+ucaDtOvjGxpu=aQ3zJ-H4_+GSdNEbeU3A@mail.gmail.com>
X-Gm-Features: Aa3M54rkmuyG2Hath1WIDaOXTf-AyW3H5Zf0frlOP0CFqlJtk9NdOH-HIX1PP9I
Message-ID: <CAL3q7H6+NOB7pTqE+ucaDtOvjGxpu=aQ3zJ-H4_+GSdNEbeU3A@mail.gmail.com>
Subject: Re: [PATCH] btrfs: fix double release of data space on failed direct
 IO COW write
To: Boris Burkov <boris@bur.io>
Cc: linux-btrfs@vger.kernel.org, kernel-team@fb.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 13, 2026 at 11:09=E2=80=AFPM Boris Burkov <boris@bur.io> wrote:
>
> btrfs_dio_iomap_begin() reserves data space for the whole range
> (data_alloc_len) before locking it. For a COW write,
> btrfs_new_extent_direct() then converts len of that reservation into a
> reserved extent: btrfs_reserve_extent() -> btrfs_add_reserved_bytes()
> moves it from bytes_may_use to bytes_reserved. If
> btrfs_create_dio_extent() fails after that (ENOMEM allocating the extent
> map or the ordered extent), btrfs_new_extent_direct() frees the reserved
> extent, which only drops bytes_reserved, and the error propagates to the
> err label of btrfs_dio_iomap_begin(), which releases all of
> data_alloc_len from bytes_may_use. The len the extent consumed is
> released twice.
>
> The success path knows the extent consumed len and releases only
> data_alloc_len - len. Make the error path do the same: record in
> dio_data how much btrfs_reserve_extent() consumed and release only the
> rest from bytes_may_use. The qgroup reservation is still freed for the
> whole range: alloc_ordered_extent() either had not released it yet, or
> released it and freed it on its own error path, and
> btrfs_qgroup_free_data() frees only what is still reserved.
>
> On an otherwise idle filesystem the second release underflows
> bytes_may_use at once and btrfs_space_info_update_bytes_may_use() warns
> and clamps it to zero. With other reservations outstanding nothing
> underflows; the extra release takes len out of another reservation and
> the deficit surfaces only when that one is released.
>
> Reproduced with fail_function injecting -ENOMEM into
> btrfs_alloc_ordered_extent() for one O_DIRECT 1M write to a new file on
> a fresh filesystem, where data bytes_may_use is 0 before the write:
>
>   WARNING: fs/btrfs/space-info.h:282 at btrfs_free_reserved_data_space_no=
quota+0x218/0x290 [btrfs]
>   Call Trace:
>    btrfs_free_reserved_data_space+0x47/0x70 [btrfs]
>    btrfs_dio_iomap_next+0x7f7/0xd80 [btrfs]
>    iomap_iter+0x57/0x3f0
>    __iomap_dio_rw+0x24b/0x930
>    btrfs_direct_write+0x258/0x530 [btrfs]
>
> The error path this patch changes was rewritten in v5.19 by
> commit f5585f4f0ef5 ("btrfs: fix deadlock between concurrent dio writes w=
hen low on free data space")
> so this patch can apply to stable kernels later than that.
>
> I was inspired to notice this by:
> Link: https://lore.kernel.org/linux-btrfs/20261113170926.1468850-1-vlad.w=
ing@gmail.com/T/#u
>
> Fixes: 18513091af94 ("btrfs: update btrfs_space_info's bytes_may_use time=
ly")
> CC: stable@vger.kernel.org # 6.1+
> Signed-off-by: Boris Burkov <boris@bur.io>

Reviewed-by: Filipe Manana <fdmanana@suse.com>

Looks good, thanks.

> ---
>  fs/btrfs/direct-io.c | 13 ++++++++++---
>  1 file changed, 10 insertions(+), 3 deletions(-)
>
> diff --git a/fs/btrfs/direct-io.c b/fs/btrfs/direct-io.c
> index 45197d1e0d82..be850dfe22c1 100644
> --- a/fs/btrfs/direct-io.c
> +++ b/fs/btrfs/direct-io.c
> @@ -12,11 +12,13 @@
>  #include "volumes.h"
>  #include "bio.h"
>  #include "ordered-data.h"
> +#include "qgroup.h"
>
>  struct btrfs_dio_data {
>         loff_t old_isize;
>         struct extent_changeset *data_reserved;
>         struct btrfs_ordered_extent *ordered;
> +       u64 data_space_consumed;
>         bool data_space_reserved;
>         bool nocow_done;
>         bool updated_isize;
> @@ -195,6 +197,7 @@ static struct extent_map *btrfs_new_extent_direct(str=
uct btrfs_inode *inode,
>         }
>         if (ret)
>                 return ERR_PTR(ret);
> +       dio_data->data_space_consumed =3D ins.offset;
>
>         file_extent.disk_bytenr =3D ins.objectid;
>         file_extent.disk_num_bytes =3D ins.offset;
> @@ -610,9 +613,13 @@ static int btrfs_dio_iomap_begin(struct inode *inode=
, loff_t start,
>                                EXTENT_LOCKED | EXTENT_DIO_LOCKED, &cached=
_state);
>  err:
>         if (dio_data->data_space_reserved) {
> -               btrfs_free_reserved_data_space(BTRFS_I(inode),
> -                                              dio_data->data_reserved,
> -                                              start, data_alloc_len);
> +               const u64 consumed =3D dio_data->data_space_consumed;
> +
> +               if (consumed < data_alloc_len)
> +                       btrfs_free_reserved_data_space_noquota(BTRFS_I(in=
ode),
> +                                               data_alloc_len - consumed=
);
> +               btrfs_qgroup_free_data(BTRFS_I(inode), dio_data->data_res=
erved,
> +                                      start, data_alloc_len, NULL);
>                 extent_changeset_free(dio_data->data_reserved);
>         }
>
> --
> 2.56.0
>
>
