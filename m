Received: from sg-3-44.ptr.tlmpb.com (sg-3-44.ptr.tlmpb.com [101.45.255.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4BD440801E
	for <linux-btrfs@vger.kernel.org>; Wed, 14 Oct 2026 03:46:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=101.45.255.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791949582; cv=none; b=MXXw9afgw8uNlbBNVJ7Wl9svqc9OpvyRUFdK0ykHJIxgv7Nn+58iZ8A4DHyoJ+bwXhwtktg6YQukGKueCVj1xvX8QLF2uOS88eAtrojz1BsEERi9L7WrMxOEhh/ex3rDXcnnBZC4h0aySb0vr9mcJKBW10ER+2HRuKkLtknwLaI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791949582; c=relaxed/simple;
	bh=tLkT2E8EPoo8JfJMFjd2LtTrZ0UxhflFI8B/MKivVHc=;
	h=To:From:Message-Id:In-Reply-To:References:Cc:Date:Mime-Version:
	 Subject:Content-Type; b=WLrZRjLLS5BOExOUrum4q4oFNiOFtQlYAnDGQs8YQ2CNMfxaKMte8rG4vcWpUYO0lHrTsLEMMw0QwV3BF+RJdO8Uj0WG3CYu9YqlXMRSi+mA2IuLXc0i/S9JUEVlVeAPNsXeXS1xfR8qGGoLLODT3YTKdVZSfKvcXlVDwSqG8MY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io; spf=pass smtp.mailfrom=fygo.io; dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b=B6q7U63p; arc=none smtp.client-ip=101.45.255.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fygo.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b="B6q7U63p"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fygo-io.20200929.dkim.larksuite.com; t=1791949524;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=e+eiPHFuSumVegKSas3bqC3NOsEusUhX5e4gr63CLfA=;
 b=B6q7U63p37+FzMc1sg6Q39Kng2wI2VPs1pYvs8+LFZyDm2bnFu8L0PAMr1tFD2AXeLO7pc
 ZWduflx2/quvXPl57fn6VTaV/0Cl1OgznOo+5gp6Jxhh+bmZbO2lejboPA7y8qw+L7OSvd
 1x3hLhICkJrDrYe1PNq5xWN1bLdHbuMTWiAix+q79uvB04IYST5bRjmUtJDl/msgNklSXk
 rX/Y6erqSpE1Z7XrBfZ3uo3nzpVVw/eKrz1miz7eeAZeADQWbSvzx4Z9NHWzfv68zxtbUt
 zMz8RBLTEbhR9hcpJ1Rh9q8bHG6nJYGwfbKHX4QVH23VuJ1zyYm91cX7uUaHow==
To: "Johannes Thumshirn" <johannes.thumshirn@wdc.com>, 
	<linux-btrfs@vger.kernel.org>
From: "Dongjiang Zhu" <zhudongjiang@fygo.io>
Message-Id: <614d2012-675c-4463-9131-25524c56eed0@fygo.io>
In-Reply-To: <20261013072941.424029-3-johannes.thumshirn@wdc.com>
User-Agent: Mozilla Thunderbird
X-Original-From: Dongjiang Zhu <zhudongjiang@fygo.io>
Received: from [192.168.8.64] ([183.34.167.161]) by smtp.larksuite.com with ESMTPS; Wed, 14 Oct 2026 03:45:23 +0000
References: <20261013072941.424029-1-johannes.thumshirn@wdc.com> <20261013072941.424029-3-johannes.thumshirn@wdc.com>
X-Lms-Return-Path: <lba+26acefad3+412650+vger.kernel.org+zhudongjiang@fygo.io>
Cc: "Damien Le Moal" <dlemoal@kernel.org>, 
	"Naohiro Aota" <naohiro.aota@wdc.com>, "Qu Wenruo" <wqu@suse.com>, 
	"David Sterba" <dsterba@suse.com>
Date: Wed, 14 Oct 2026 11:45:16 +0800
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH v2 02/12] btrfs: zoned: don't activate conventional zones of mixed block groups
Content-Type: text/plain; charset=UTF-8

=E5=9C=A8 2026/10/13 15:29, Johannes Thumshirn =E5=86=99=E9=81=93:
> A block group can be backed by both conventional and sequential zones,
> e.g. a DUP chunk straddling the conventional/sequential boundary of a
> device or a RAID1 chunk with one stripe on a conventional zone of one
> device and the other one on a sequential zone of another device.
>=20
> On a device with an active zone limit, btrfs_load_zone_info() never
> marks a conventional zone as active, as there is no zone condition to
> derive it from. If the sequential zone of such a block group is active,
> the DUP and RAID1 loaders see an activeness mismatch between the stripes
> and call btrfs_zone_activate(). That takes an active zone from the
> device's budget for the conventional zone as well, although conventional
> zones never consume an active zone resource. The same also happens at
> runtime activation of a zone, not only in the mount path.
>=20
> Let the conventional zones of a mixed block group inherit the activeness
> of the first present sequential zone.
>=20
> Fixes: 265f7237dd25 ("btrfs: zoned: allow DUP on meta-data block groups")
> Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
> ---
>  fs/btrfs/zoned.c | 50 ++++++++++++++++++++++++++++++++++++------------
>  1 file changed, 38 insertions(+), 12 deletions(-)
>=20
> diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
> index 51699136405d..3af234dea6f5 100644
> --- a/fs/btrfs/zoned.c
> +++ b/fs/btrfs/zoned.c
> @@ -1959,6 +1959,23 @@ int btrfs_load_block_group_zone_info(struct btrfs_=
block_group *cache, bool new)
>  	if (num_sequential > 0)
>  		set_bit(BLOCK_GROUP_FLAG_SEQUENTIAL_ZONE, &cache->runtime_flags);
> =20
> +	if (num_conventional > 0 && num_sequential > 0) {
> +		int ref;
> +
> +		for (ref =3D 0; ref < map->num_stripes; ref++) {
> +			if (zone_info[ref].alloc_offset !=3D WP_CONVENTIONAL &&
> +			    zone_info[ref].alloc_offset !=3D WP_MISSING_DEV)
> +				break;
> +		}
> +
> +		if (ref < map->num_stripes) {
> +			for (i =3D 0; i < map->num_stripes; i++) {
> +				if (zone_info[i].alloc_offset =3D=3D WP_CONVENTIONAL)
> +					assign_bit(i, active, test_bit(ref, active));
> +			}
> +		}
> +	}
> +
>  	if (num_conventional > 0) {
>  		ret =3D calculate_alloc_pointer(cache, &last_alloc, new);
>  		if (ret) {
> @@ -2450,6 +2467,9 @@ bool btrfs_zone_activate(struct btrfs_block_group *=
block_group)
>  		if (!device->bdev)
>  			continue;
> =20
> +		if (!btrfs_dev_is_sequential(device, physical))
> +			continue;
> +
>  		if (zinfo->max_active_zones =3D=3D 0)
>  			continue;
> =20
> @@ -2516,6 +2536,7 @@ static int call_zone_finish(struct btrfs_block_grou=
p *block_group,
>  	struct btrfs_device *device =3D stripe->dev;
>  	const u64 physical =3D stripe->physical;
>  	struct btrfs_zoned_device_info *zinfo =3D device->zone_info;
> +	unsigned int nofs_flags;
>  	int ret;
> =20
>  	if (!device->bdev)
> @@ -2524,18 +2545,17 @@ static int call_zone_finish(struct btrfs_block_gr=
oup *block_group,
>  	if (zinfo->max_active_zones =3D=3D 0)
>  		return 0;
> =20
> -	if (btrfs_dev_is_sequential(device, physical)) {
> -		unsigned int nofs_flags;
> +	if (!btrfs_dev_is_sequential(device, physical))
> +		return 0;
> =20
> -		nofs_flags =3D memalloc_nofs_save();
> -		ret =3D blkdev_zone_mgmt(device->bdev, REQ_OP_ZONE_FINISH,
> -				       physical >> SECTOR_SHIFT,
> -				       zinfo->zone_size >> SECTOR_SHIFT);
> -		memalloc_nofs_restore(nofs_flags);
> +	nofs_flags =3D memalloc_nofs_save();
> +	ret =3D blkdev_zone_mgmt(device->bdev, REQ_OP_ZONE_FINISH,
> +			       physical >> SECTOR_SHIFT,
> +			       zinfo->zone_size >> SECTOR_SHIFT);
> +	memalloc_nofs_restore(nofs_flags);
> =20
> -		if (ret)
> -			return ret;
> -	}
> +	if (ret)
> +		return ret;
> =20
>  	if (!(block_group->flags & BTRFS_BLOCK_GROUP_DATA)) {
>  		struct btrfs_fs_info *fs_info =3D block_group->fs_info;
> @@ -3098,8 +3118,14 @@ void btrfs_check_active_zone_reservation(struct bt=
rfs_fs_info *fs_info)
>  		      (BTRFS_BLOCK_GROUP_METADATA | BTRFS_BLOCK_GROUP_SYSTEM)))
>  			continue;
> =20
> -		for (int i =3D 0; i < map->num_stripes; i++)
> -			map->stripes[i].dev->zone_info->reserved_active_zones--;
> +		for (int i =3D 0; i < map->num_stripes; i++) {
> +			struct btrfs_device *dev =3D map->stripes[i].dev;
> +			struct btrfs_zoned_device_info *zone_info =3D dev->zone_info;
> +			u64 physical =3D map->stripes[i].physical;
> +
> +			if (btrfs_dev_is_sequential(dev, physical))
> +				zone_info->reserved_active_zones--;
> +		}
>  	}
>  	spin_unlock(&fs_info->zone_active_bgs_lock);
>  }

Hi Johannes,

For reference, here is patch 1 of my v2:
https://lore.kernel.org/linux-btrfs/c51aaf7f4621dedc36c275bfa9ba1ec884de09c=
4.1787717573.git.zhudongjiang@fygo.io/

Initially, I thought your approach addressed Naohiro's allocation
concern nicely: keeping conventional DATA block groups on the active
list preserves the preference for allocating from active block groups.

However, there seems to be one remaining issue. A fully conventional
DATA block group does not consume active-zone tokens, but remains on
zone_active_bgs. btrfs_zone_finish_one_bg() can therefore select it
and return 1 without freeing any active-zone token.

can_allocate_chunk_zoned() treats that return value as permission to
allocate another chunk. The new chunk can then fail activation, and
the extent allocation can ultimately return ENOSPC.

I reproduced this with your v2 series as follows:

1. Fill the sequential zones until DATA allocation spills into a
   conventional zone.

2. Free some sequential block groups, keeping the conventional DATA
   block group in place.

3. Allocate new sequential DATA block groups until the active-zone
   budget available to DATA is exhausted again, leaving each with
   a larger unused tail than the conventional DATA block group.

4. Issue an encoded write that cannot fit in the remaining tails and
   needs another active block group. btrfs_zone_finish_one_bg()
   selects the conventional DATA block group and returns 1 without
   releasing a token.

5. A new DATA chunk is allocated, but its activation fails, and the
   write returns ENOSPC.

Thanks,
Dongjiang
