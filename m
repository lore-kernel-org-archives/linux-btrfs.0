Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794862586;
	b=JPezInYtGZxle581/NzYkJIxLRW3aIrzZBJivuDJnXGr9xg5VoAt7LgYGUmXqjageRoQ
	 7X6dPiaPn8fF6uA59WHzUaiwM+vo5HFP2lezrKdq27edGx0kZViUPJ3KSlfvdi+Bf6wE1
	 GOJMuo+KyVSCOMs3z3Z8TJ6TkrSQDnpqrO3r5CjYVa954D10M2TDn73gdqzpEZRouOeQ8
	 oQBv0AQXosTGJ6H+PcMvsjFkLbaPdM6Rx+StZc5sAAenP3vgX20XCqAKzoNSyR0OXFJFK
	 1I+meWPy6w1KIi3cAxmiMkqva6vACoWwPPkLXBq8nCPyyIWPASipNlz41TxiFcNyJPw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794862586;
	h=Received:DKIM-Signature:Received:X-Gm-Message-State:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:
	 X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:Subject:To:Cc:
	 Content-Type:Content-Transfer-Encoding;
	bh=D73DjqogkESMjU6bHHqSAyDwHwVVP+XQYvOpfbkrps0=;
	b=gGYU5YiFlK0rJfRdPMECxzEWFdTjEae5yqYq35eUsO6528eH6+uPkM7p0xheBS0OhNmt
	 tSJ885ZSA5ZgEJw2XTr2Y1DNwbX/shqNEhIQrb8GYH9/s1L//xbmtRWt+oM/b3DccRCl6
	 eGQ6od133m9HJdq02jrPva+9O++4XARWvquf11IcXvIQniAVA7oGjsAtEIPfrRJQXDLgK
	 jBZiOao0FU2/Qti9oBY+wkpMhgMxCHgvxmVy5OBGnq8E3+Rxprt5Wjs+g1hpnI00Ddx3p
	 V7B0NBbHjh+oIqDQHeJeAyT0nKB0GnoT0+7jaGQkjSmR9/VY54yUmLSO0e0I1TpBAjg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hiJ3JIm7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E202D606A323
	for <linux-btrfs@vger.kernel.org>; Mon, 16 Nov 2026 20:56:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hiJ3JIm7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EDE71F000C4
	for <linux-btrfs@vger.kernel.org>; Mon, 16 Nov 2026 20:56:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794862585;
	bh=D73DjqogkESMjU6bHHqSAyDwHwVVP+XQYvOpfbkrps0=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=hiJ3JIm7sFb4HP2CgdS5nGgOBJb8KY/ML4rfsiik7Fl3cnkrWAj2nVQJx3EUeRXsW
	 FIVa1cxpxisd9gm2Z0x2WDImnLIThm8ut+mYkWSNJmPP6qbH4aa54DP6glbWX4c2x2
	 GJBSO5ZGE7+pGQTLz5rdJm5fqrd8I3spjTVvRRqSZb5As9ckgVxxgw+U+J6fGplsDr
	 o6m5gxsSES9MRj5inlkqrKbWQbQx0UwvMH1xO25V68VSIkk61Nf1Ax7cBb79e2FkmY
	 +HiSuXrEJ78SRZPbnwTSMHuqfI7wQfIjyqkXCF4nXcJACNdLab0Uj+ya79rbZRJlSZ
	 Tcwb9O5TXVKZg==
Received: by mail-vs1-f46.google.com with SMTP id ada2fe7eead31-7cc0e865dd1so1202966137.1
        for <linux-btrfs@vger.kernel.org>; Mon, 16 Nov 2026 12:56:25 -0800 (PST)
X-Gm-Message-State: APuU4Z8X+meQYxhy2Cwx9953E2YIvdD6Xzm0FoUR8oQ3P6fcqgzPe2z2
	W8z/j+KQGU4dRl1CDUjHf3e6G2pqW7KK8BsDl5q4b/38wf/tJ9/+1xFAzzK59CGDdnq7XzJKd3Y
	nYw6CSjl13k+YhB2PQsaoYjlzOqNZn+U=
X-Received: by 2002:a05:6102:54a8:b0:7ce:8505:9848 with SMTP id
 ada2fe7eead31-7d64d8abe12mr4279430137.31.1794862584795; Mon, 16 Nov 2026
 12:56:24 -0800 (PST)
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261113144215.3277479-1-johannes.thumshirn@wdc.com>
In-Reply-To: <20261113144215.3277479-1-johannes.thumshirn@wdc.com>
From: Filipe Manana <fdmanana@kernel.org>
Date: Mon, 16 Nov 2026 20:55:48 +0000
X-Gmail-Original-Message-ID: <CAL3q7H61fhyVuomNYmgPzomOeoWCP2K6k-KCcrv47+MxHbRHZg@mail.gmail.com>
X-Gm-Features: Aa3M54oCDsB6fKPI2bjcbC_vNkIPCiQ9KuXxiSBOVzh2ILTiztWygouTuLS4DKc
Message-ID: <CAL3q7H61fhyVuomNYmgPzomOeoWCP2K6k-KCcrv47+MxHbRHZg@mail.gmail.com>
Subject: Re: [PATCH v4] btrfs: zoned: don't release active zone reservations
 for conventional zones
To: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Cc: linux-btrfs@vger.kernel.org, Naohiro Aota <naohiro.aota@wdc.com>, 
	Damien Le Moal <dlemoal@kernel.org>, David Sterba <dsterba@suse.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 13, 2026 at 8:33=E2=80=AFPM Johannes Thumshirn
<johannes.thumshirn@wdc.com> wrote:
>
> On mount, btrfs_check_active_zone_reservation() releases a reserved
> active zone for each stripe of an active metadata or system block-group.
> Stripes on conventional zones usually hold no active zone on the device,
> so they use up the reservation. Once metadata moves to a sequential
> block-group, its activation fails and the transaction commit aborts
> with -EAGAIN.
>
> Only release reservations for stripes holding an active zone, matching
> what finishing the zone gives back.
>
> Fixes: a7e1ac7bdc5a ("btrfs: zoned: reserve zones for an active metadata/=
system block group")
> Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>

Reviewed-by: Filipe Manana <fdmanana@suse.com>

Looks good, thanks.

> ---
>
> It's not the bug that was reported, but a problem anyways and I have
> submitted a fstest for it to prove it, so I think it is still worthwhile
> to merge.
>
>  fs/btrfs/zoned.c | 11 +++++++++--
>  1 file changed, 9 insertions(+), 2 deletions(-)
>
> diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
> index 3192b86669b9..81489fa4a42d 100644
> --- a/fs/btrfs/zoned.c
> +++ b/fs/btrfs/zoned.c
> @@ -3115,8 +3115,15 @@ void btrfs_check_active_zone_reservation(struct bt=
rfs_fs_info *fs_info)
>                       (BTRFS_BLOCK_GROUP_METADATA | BTRFS_BLOCK_GROUP_SYS=
TEM)))
>                         continue;
>
> -               for (int i =3D 0; i < map->num_stripes; i++)
> -                       map->stripes[i].dev->zone_info->reserved_active_z=
ones--;
> +               for (int i =3D 0; i < map->num_stripes; i++) {
> +                       struct btrfs_zoned_device_info *zinfo =3D map->st=
ripes[i].dev->zone_info;
> +                       u64 physical =3D map->stripes[i].physical;
> +
> +                       if (!test_bit(physical >> zinfo->zone_size_shift,=
 zinfo->active_zones))
> +                               continue;
> +
> +                       zinfo->reserved_active_zones--;
> +               }
>         }
>         spin_unlock(&fs_info->zone_active_bgs_lock);
>  }
> --
> 2.56.0
>
>
