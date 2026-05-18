Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CCAA317163
	for <linux-btrfs@vger.kernel.org>; Mon, 18 May 2026 10:09:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779098998; cv=none; b=QhLCa+SnjbhQ074hdsovynLnwL52BnuP2gRaOpN/pU87EvvygT98HhwM+NzN20Eto6JGhWgQ8i8wS/J7snPalUxxyKoEIO3fUXMvBE6jzPNkzf/IXRK2lSt2ovZ9f3KIkwaDahw8sJF6AMF4zgCx5ORoTiH5OF7lIR00pVVzD/A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779098998; c=relaxed/simple;
	bh=/7ObXRqK7dZ5xexDofqO5jDj5gRQp3dfdgiimdDMh7I=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=UsOek0WTPECwSsQ+jmbJw4Ug9RJLl/t2pL9h7gITCtkrbAByaeoOh+HDQWoSsQVL8P44jWtdqxAwhRUKm/uBgVc+QzeJhYcIZKDNyrgSR3e7i4wEzND13ss52tx20Ek0vLHITv6jhOKtEZZpp6zOMSfPmt6FQPA+bQBBpGTnqNo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eHBjEMqj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eHBjEMqj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05BEEC2BCF5;
	Mon, 18 May 2026 10:09:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779098997;
	bh=/7ObXRqK7dZ5xexDofqO5jDj5gRQp3dfdgiimdDMh7I=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=eHBjEMqjnmBGPt1EK2r2ptcscGIbsiy8VE19CZ2KfJKbEUXG3XoHPSKm9f+SgC2L1
	 76lme31D2cQTNkXtT7F0am3kQcWYOK2yA9r6D9KvZvM3SnvHwpRwaOhqxSqxnOHyKb
	 NbWaK5EhXCYbub4YVsYomuIWyJsRfPuIyp+5dh53xwPYvQOVi+j3hwtZorKTvwHHk4
	 hwsSnhroC5EXB2/f/1/13raOZ4M7vMccreTsEYbAKLtLrI1heSoUXCCuY5gUr1wnFR
	 J1QqtqkK784QShw3Hxhjsd4i72RmIPXZ1krQ5+7f2zsa4NhHH8iHaM4+tPs0SC3hBn
	 JRmqeTAcRp+Hw==
Message-ID: <bd7d1f30-a6f3-4497-b584-8b81db6599e1@kernel.org>
Date: Mon, 18 May 2026 12:09:54 +0200
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] btrfs: zoned: always set max_active_zones for zoned
 devices
To: Johannes Thumshirn <johannes.thumshirn@wdc.com>,
 linux-btrfs@vger.kernel.org
Cc: Naohiro Aota <naohiro.aota@wdc.com>
References: <20260518095503.132430-1-johannes.thumshirn@wdc.com>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20260518095503.132430-1-johannes.thumshirn@wdc.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2026/05/18 11:55, Johannes Thumshirn wrote:
> When a block device does not report a maximum number of open or active
> zones, btrfs currently assigns BTRFS_DEFAULT_MAX_ACTIVE_ZONES (128) to the
> internal limit, if the device has more than BTRFS_DEFAULT_MAX_ACTIVE_ZONES
> zones.
> 
> But if the device has less than BTRFS_DEFAULT_MAX_ACTIVE_ZONES the
> internal max_active_zones limit will stay at 0.
> 
> If a device doesn't report a number of max open or active zones and it has
> less than BTRFS_DEFAULT_MAX_ACTIVE_ZONES, set the internal limit to the
> number of zones on the device divided by 4.

I would rephrase this like this:

But if the device has less than BTRFS_DEFAULT_MAX_ACTIVE_ZONES the
internal max_active_zones limit will stay at 0, even if the device has zone
resource limits. Furthermore, if the device has a total number of zones that is
less than BTRFS_DEFAULT_MAX_ACTIVE_ZONE, max_active_zones should be set to at
most the the number of zones.

Fix both issues by changing max_active_zones to the total number of zones of the
device divided by 4 when the device does not report any zone resource limit,
i.e. when max_active_zones is zero.

> Fixes: 04147d8394e8 ("btrfs: zoned: limit active zones to max_open_zones")
> Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
> ---
>  fs/btrfs/zoned.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
> index 0b80b498fb85..bdd6fac93c93 100644
> --- a/fs/btrfs/zoned.c
> +++ b/fs/btrfs/zoned.c
> @@ -426,8 +426,10 @@ int btrfs_get_dev_zone_info(struct btrfs_device *device, bool populate_cache)
>  
>  	max_active_zones = min_not_zero(bdev_max_active_zones(bdev),
>  					bdev_max_open_zones(bdev));
> -	if (!max_active_zones && zone_info->nr_zones > BTRFS_DEFAULT_MAX_ACTIVE_ZONES)
> -		max_active_zones = BTRFS_DEFAULT_MAX_ACTIVE_ZONES;
> +	if (!max_active_zones)
> +		max_active_zones = min(zone_info->nr_zones / 4,
> +				       BTRFS_DEFAULT_MAX_ACTIVE_ZONES);

zone_info->nr_zones / 4 could endup being smaller than BTRFS_MIN_ACTIVE_ZONES.
So we should check that as well:

	if (!max_active_zones) {
		max_active_zones = min(zone_info->nr_zones / 4,
				       BTRFS_DEFAULT_MAX_ACTIVE_ZONES);
		max_active_zones = max(BTRFS_MIN_ACTIVE_ZONES,
				       max_active_zones);
	}

and that means that before doing this, we really should check that we have
zone_info->nr_zones > BTRFS_MIN_ACTIVE_ZONES somewhere.

> +
>  	if (max_active_zones && max_active_zones < BTRFS_MIN_ACTIVE_ZONES) {
>  		btrfs_err(fs_info,
>  "zoned: %s: max active zones %u is too small, need at least %u active zones",


-- 
Damien Le Moal
Western Digital Research
