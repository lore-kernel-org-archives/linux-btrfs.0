Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC5D026FA5A
	for <linux-btrfs@vger.kernel.org>; Mon, 18 May 2026 14:55:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779116147; cv=none; b=hKD28mhuoQAcigfRVG1i7J1/tWybLxHVHbisE+dff8clmePwvkV6DamGCDAWRfjsXfh9QhX5HBUuLCPUDzYzIpqJucK0p6fz4w/Dghjw3fUsU/YNymlgx4yUnX9ojCK8bVu4lu4D76g3IFUa5nHd6U5j4pB+j6EYOysHDiDEBiU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779116147; c=relaxed/simple;
	bh=Rp2c/jO3fy94X2q+Pn+ILY6Bw/8eA/nJRabz8wbOThU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=FyFGcnAFymNOi7q/4lCCjrKjfyrZtE0hlf5WnZFPtXHm5WpIjGstX60S32/HqKOuTwJNpyduz1+s6jQhX309UZBa7Rv508wiIb6wDIMcpOgjcopRL0IhZhoFdFaZOxbqphRVS1RV23R8gWvrqa0+MoX97vpIpUO/tHg/2d76VO8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZF0yGD69; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZF0yGD69"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEF21C2BCB7;
	Mon, 18 May 2026 14:55:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779116147;
	bh=Rp2c/jO3fy94X2q+Pn+ILY6Bw/8eA/nJRabz8wbOThU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=ZF0yGD69lbBimNxsVRVHwmve9Ew9dXAYm/CJ4TKsQAtn9TMnVeg+eH2Dc2qz4pXN4
	 fwc3OjDgAa8MtWJlAZG3BR8kY3gh1W7KeF0tbn3WThrJq2hG1ib1d9Zp9x4myUMksb
	 VC4H5XOLBCwU94CdNPtefYvHzwg47jBn8I8bIepmBes2hPPmKVVPipcXdc8QwCcb86
	 mGy3KHPu/xNZ3tAEYauuPTjX912bRRaT/hr0135sdrtzzVY2fH7AJKTBkadglmNAUy
	 ABR3ZAEmhwK9rI8KgJlHBQ3lSl97vBqXa07K7ROVizD7hRAJbelrOCsfAJxOaU5Z0j
	 AzZHtkk6xibDg==
Message-ID: <a3926a25-e29f-4cfd-bc7d-483b3e575d4c@kernel.org>
Date: Mon, 18 May 2026 16:55:44 +0200
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] btrfs: zoned: always set max_active_zones for zoned
 devices
To: Johannes Thumshirn <johannes.thumshirn@wdc.com>,
 linux-btrfs@vger.kernel.org
Cc: Naohiro Aota <naohiro.aota@wdc.com>
References: <20260518135824.202728-1-johannes.thumshirn@wdc.com>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20260518135824.202728-1-johannes.thumshirn@wdc.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2026/05/18 15:58, Johannes Thumshirn wrote:
> When a block device does not report a maximum number of open or active
> zones, btrfs currently assigns BTRFS_DEFAULT_MAX_ACTIVE_ZONES (128) to the
> internal limit, if the device has more than BTRFS_DEFAULT_MAX_ACTIVE_ZONES
> zones.
> 
> But if the device has less than BTRFS_DEFAULT_MAX_ACTIVE_ZONES the
> internal max_active_zones limit will stay at 0, even if the device has
> zone resource limits. Furthermore, if the device has a total number of
> zones that is less than BTRFS_DEFAULT_MAX_ACTIVE_ZONE, max_active_zones
> should be set to at most the the number of zones.

s/the the number of zones./the total number of zones of the device.

> 
> Also move the max_active_zone calculation and setting into a dedicated
> helper, to shrink btrfs_get_dev_zone_info().
> 
> Fixes: 04147d8394e8 ("btrfs: zoned: limit active zones to max_open_zones")
> Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>

[...]

> @@ -517,22 +527,21 @@ int btrfs_get_dev_zone_info(struct btrfs_device *device, bool populate_cache)
>  		goto out;
>  	}
>  
> -	if (max_active_zones) {
> -		if (unlikely(nactive > max_active_zones)) {
> +	if (zone_info->max_active_zones) {

Why this if ? max_active_zones now cannot ever be zero.

> +		if (unlikely(nactive > zone_info->max_active_zones)) {
>  			if (bdev_max_active_zones(bdev) == 0) {
> -				max_active_zones = 0;
>  				zone_info->max_active_zones = 0;
>  				goto validate;
>  			}
>  			btrfs_err(device->fs_info,
>  			"zoned: %u active zones on %s exceeds max_active_zones %u",
>  					 nactive, rcu_dereference(device->name),
> -					 max_active_zones);
> +					 zone_info->max_active_zones);
>  			ret = -EIO;
>  			goto out;
>  		}
>  		atomic_set(&zone_info->active_zones_left,
> -			   max_active_zones - nactive);
> +			   zone_info->max_active_zones - nactive);
>  		set_bit(BTRFS_FS_ACTIVE_ZONE_TRACKING, &fs_info->flags);
>  	}
>  


-- 
Damien Le Moal
Western Digital Research
