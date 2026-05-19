Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F351223393F
	for <linux-btrfs@vger.kernel.org>; Tue, 19 May 2026 15:59:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779206363; cv=none; b=t4c9aml2YPDhkMCoLwEN/WSsg4ZqjH9lAlUQfnOomlunTUolHcEGmr4YIXoZJFV1SehLIzmhkqVAlBkIu68RyvtPkA/SHpcQRRHfnNo+cf7teWayA6ZUm06gMC/3IgQZMd2rl1NsxWSh9YZaoE6YI7yqCrx2PWeoLZaSmSb9h00=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779206363; c=relaxed/simple;
	bh=DP66zkpI1jPOREvr7SEHT764GKzT/BeWOtbgH9GUibo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Ixc09/w5IAePCOckxXXzhKx+FM7fYBk/hAZmM2yXjr/XqLQ+qJ6qijTPJC+YgjL/NK5hk9dESiMMauNin5sJLNPZ1C7/BYVGVwG7tThO5MJMhjOtQUdYr9JyDGZwdR2MA5MP55I9zsoACqWJgNazecv88jgMwM5yeacqJJA2kCQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VyrrU0bj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VyrrU0bj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99BEAC2BCB3
	for <linux-btrfs@vger.kernel.org>; Tue, 19 May 2026 15:59:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779206362;
	bh=DP66zkpI1jPOREvr7SEHT764GKzT/BeWOtbgH9GUibo=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=VyrrU0bjm1a4tyJT1ZfWJqu2RpR2XLG+ovWa1MdShSS3iLQXIOvOAQdq9idJ6Uyny
	 ATKB1i4Y3pHDy4MsNbfLNInY4S1OPmywoyXZpH6/z6j212bga0bJQsFoIQsM2s2n7J
	 8bMTTqp8jlT9YMP1CBZmb/Vxk0WzDraSr7swGrGiAW38HOA0dk0gdmfuoJaH9xkSAX
	 emDk2seoP5F8cqy+q/bYuqx598qeuGQmZ3ZKs7z2CeD5f9cpKYPRQdJXd+wSL3UBNd
	 ok9xzFomuz7oQ3BdUBPl5ZUA7uwgSoFDwt908d4hx3sFkhw7m9spdhzLbSmoCbvtyk
	 gPTZHlsOW/N+A==
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-bd21ffaca79so773530066b.0
        for <linux-btrfs@vger.kernel.org>; Tue, 19 May 2026 08:59:22 -0700 (PDT)
X-Gm-Message-State: AOJu0YxDXiU5rMYVPvoQknRiWBjgqm3ep8weQejSbqPOkyJrmbmBmq4P
	SlnGqX4KtwhgFysNHJuoXOVhIG+ybedmyh7IEWBMMqpYXUEIMf0cS0mKv8MhvCqtPGl4+BEAy/Q
	0I0++2O9PdFY10F3VFNauphZ4cODG71o=
X-Received: by 2002:a17:907:d091:b0:bc6:bb4b:1726 with SMTP id
 a640c23a62f3a-bd51553a62cmr1037254166b.22.1779206361179; Tue, 19 May 2026
 08:59:21 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260519071621.56490-1-johannes.thumshirn@wdc.com> <20260519071621.56490-2-johannes.thumshirn@wdc.com>
In-Reply-To: <20260519071621.56490-2-johannes.thumshirn@wdc.com>
From: Filipe Manana <fdmanana@kernel.org>
Date: Tue, 19 May 2026 16:58:43 +0100
X-Gmail-Original-Message-ID: <CAL3q7H6QyDXCJ722QzumyN8uuRTo8kNLmUXVXaG-ok01+U9KAQ@mail.gmail.com>
X-Gm-Features: AVHnY4Je0-PaFlZToCRHKysK-sRW_lnNL4OBTnQMXnRTmYRb13Cm1aYVbVYQnuI
Message-ID: <CAL3q7H6QyDXCJ722QzumyN8uuRTo8kNLmUXVXaG-ok01+U9KAQ@mail.gmail.com>
Subject: Re: [PATCH v3 1/2] btrfs: zoned: always set max_active_zones for
 zoned devices
To: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Cc: linux-btrfs@vger.kernel.org, Naohiro Aota <naohiro.aota@wdc.com>, 
	Damien Le Moal <dlemoal@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, May 19, 2026 at 8:21=E2=80=AFAM Johannes Thumshirn
<johannes.thumshirn@wdc.com> wrote:
>
> When a block device does not report a maximum number of open or active
> zones, btrfs currently assigns BTRFS_DEFAULT_MAX_ACTIVE_ZONES (128) to th=
e
> internal limit, if the device has more than BTRFS_DEFAULT_MAX_ACTIVE_ZONE=
S
> zones.
>
> But if the device has less than BTRFS_DEFAULT_MAX_ACTIVE_ZONES the
> internal max_active_zones limit will stay at 0, even if the device has
> zone resource limits. Furthermore, if the device has a total number of
> zones that is less than BTRFS_DEFAULT_MAX_ACTIVE_ZONE, max_active_zones
> should be set to at most the the number of zones.
>
> Also move the max_active_zone calculation and setting into a dedicated
> helper, to shrink btrfs_get_dev_zone_info().
>
> Fixes: 04147d8394e8 ("btrfs: zoned: limit active zones to max_open_zones"=
)
> Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
> ---
>  fs/btrfs/zoned.c | 65 +++++++++++++++++++++++++++---------------------
>  1 file changed, 36 insertions(+), 29 deletions(-)
>
> diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
> index 0b80b498fb85..b1d0e2414178 100644
> --- a/fs/btrfs/zoned.c
> +++ b/fs/btrfs/zoned.c
> @@ -354,12 +354,32 @@ int btrfs_get_dev_zone_info_all_devices(struct btrf=
s_fs_info *fs_info)
>         return ret;
>  }
>
> +static int btrfs_get_max_active_zones(struct btrfs_device *device,
> +                                      struct btrfs_zoned_device_info *zo=
ne_info)
> +{
> +       struct block_device *bdev =3D device->bdev;
> +       int max_active_zones;
> +
> +       if (zone_info->nr_zones < BTRFS_MIN_ACTIVE_ZONES) {
> +               btrfs_err(device->fs_info, "Not enough zones to mount fil=
esystem.");

Please uncapitalize the first word and remove punctuation.

See the style preferences we have in the documentation:

https://btrfs.readthedocs.io/en/latest/dev/Development-notes.html#error-mes=
sages-verbosity

Also, most messages logged for zoned filesystems have the "zoned: "
prefix. But that can be fixed later.

> +               return -EINVAL;
> +       }
> +
> +       max_active_zones =3D min_not_zero(bdev_max_active_zones(bdev),
> +                                       bdev_max_open_zones(bdev));
> +       if (!max_active_zones)
> +               max_active_zones =3D min(zone_info->nr_zones / 4,
> +                                      BTRFS_DEFAULT_MAX_ACTIVE_ZONES);
> +
> +       zone_info->max_active_zones =3D max(max_active_zones, BTRFS_MIN_A=
CTIVE_ZONES);
> +       return 0;
> +}
> +
>  int btrfs_get_dev_zone_info(struct btrfs_device *device, bool populate_c=
ache)
>  {
>         struct btrfs_fs_info *fs_info =3D device->fs_info;
>         struct btrfs_zoned_device_info *zone_info =3D NULL;
>         struct block_device *bdev =3D device->bdev;
> -       unsigned int max_active_zones;
>         unsigned int nactive;
>         sector_t nr_sectors;
>         sector_t sector =3D 0;
> @@ -424,19 +444,9 @@ int btrfs_get_dev_zone_info(struct btrfs_device *dev=
ice, bool populate_cache)
>         if (!IS_ALIGNED(nr_sectors, zone_sectors))
>                 zone_info->nr_zones++;
>
> -       max_active_zones =3D min_not_zero(bdev_max_active_zones(bdev),
> -                                       bdev_max_open_zones(bdev));
> -       if (!max_active_zones && zone_info->nr_zones > BTRFS_DEFAULT_MAX_=
ACTIVE_ZONES)
> -               max_active_zones =3D BTRFS_DEFAULT_MAX_ACTIVE_ZONES;
> -       if (max_active_zones && max_active_zones < BTRFS_MIN_ACTIVE_ZONES=
) {
> -               btrfs_err(fs_info,
> -"zoned: %s: max active zones %u is too small, need at least %u active zo=
nes",
> -                                rcu_dereference(device->name), max_activ=
e_zones,
> -                                BTRFS_MIN_ACTIVE_ZONES);
> -               ret =3D -EINVAL;
> +       ret =3D btrfs_get_max_active_zones(device, zone_info);
> +       if (ret)
>                 goto out;
> -       }
> -       zone_info->max_active_zones =3D max_active_zones;
>
>         zone_info->seq_zones =3D bitmap_zalloc(zone_info->nr_zones, GFP_K=
ERNEL);
>         if (!zone_info->seq_zones) {
> @@ -517,24 +527,21 @@ int btrfs_get_dev_zone_info(struct btrfs_device *de=
vice, bool populate_cache)
>                 goto out;
>         }
>
> -       if (max_active_zones) {
> -               if (unlikely(nactive > max_active_zones)) {
> -                       if (bdev_max_active_zones(bdev) =3D=3D 0) {
> -                               max_active_zones =3D 0;
> -                               zone_info->max_active_zones =3D 0;
> -                               goto validate;
> -                       }
> -                       btrfs_err(device->fs_info,
> -                       "zoned: %u active zones on %s exceeds max_active_=
zones %u",
> -                                        nactive, rcu_dereference(device-=
>name),
> -                                        max_active_zones);
> -                       ret =3D -EIO;
> -                       goto out;
> +       if (unlikely(nactive > zone_info->max_active_zones)) {
> +               if (bdev_max_active_zones(bdev) =3D=3D 0) {
> +                       zone_info->max_active_zones =3D 0;
> +                       goto validate;
>                 }
> -               atomic_set(&zone_info->active_zones_left,
> -                          max_active_zones - nactive);
> -               set_bit(BTRFS_FS_ACTIVE_ZONE_TRACKING, &fs_info->flags);
> +               btrfs_err(device->fs_info,
> +                               "zoned: %u active zones on %s exceeds max=
_active_zones %u",
> +                               nactive, rcu_dereference(device->name),
> +                               zone_info->max_active_zones);
> +               ret =3D -EIO;
> +               goto out;
>         }
> +       atomic_set(&zone_info->active_zones_left,
> +                       zone_info->max_active_zones - nactive);
> +       set_bit(BTRFS_FS_ACTIVE_ZONE_TRACKING, &fs_info->flags);
>
>  validate:
>         /* Validate superblock log */
> --
> 2.54.0
>
>
