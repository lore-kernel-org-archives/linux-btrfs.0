Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AF323E1CFB
	for <linux-btrfs@vger.kernel.org>; Tue, 19 May 2026 08:36:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779179798; cv=none; b=ddxQLcSewIp/Vq9SqEPY7CJzTow1hUen57mip5Mq2QcLZa31wkH8Rytg0b4w0Gjd516NS4K1QXDh00AQJfoH9MLAtDjh69D5kuLZgNJZo9TAiOY2u4tkrSEZbszO9UGx5axlL+c00PtEE8ZiYFmQ4oeF5dDqQBukmaa4RGpBBJA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779179798; c=relaxed/simple;
	bh=ZbLLZieL5zXEO8gr9YZdCmMuLPcU+aoPiCzDIaDyLw4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=nJPLpuDT8z+3r/5VyGkcFtx8ChnqTBCwaqzT7MIz1cex5B2GppRZ8bMZzUAHaZiI7z6WvB0cGxL6kdMtVb+kmYvJLSrUtLYHYyGFixcv9sNRNO0d8osOzCs0gxeDAdP+dPRCwrR3xo9DmNeBa8HvFXNrpSjJ8ucdeWXIPrg6Hcc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QJhNLuKj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QJhNLuKj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58264C2BCB3;
	Tue, 19 May 2026 08:36:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779179798;
	bh=ZbLLZieL5zXEO8gr9YZdCmMuLPcU+aoPiCzDIaDyLw4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=QJhNLuKjI1sPsVNP2h/NVnAbZzgiirP4LDUV3uzqjejUI+hwsw6c3FKX3JlowM2OO
	 4uZ0T7ZjiGeGFuyP2KkG915qd93K4rUBYO7WvBaA0UkwazoYOUqmwRcFOuFqhDoja5
	 OSxddpzKx4BmMSpXwijsWassCh89PlXNTC4SQ6pbD0fzM3ns14tFhlt6jhUxvF3woq
	 1LzygzDY9TodEapgfzJ1Kj8ukfpe73qNXz83QvGT3kgETkKRY7m4/EQuz+lS1SCZ7f
	 2ICymB5GsTDBl4MSvM+Dlg4sEZ1VjXQSOmcYaoGkWl7fhAi3cykzl2aD5xgaGvizie
	 5X2WQVYuFGOnw==
Message-ID: <8cde6b00-f80e-4f94-bce1-821126cf6c88@kernel.org>
Date: Tue, 19 May 2026 10:36:35 +0200
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 1/2] btrfs: zoned: always set max_active_zones for
 zoned devices
To: Johannes Thumshirn <johannes.thumshirn@wdc.com>,
 linux-btrfs@vger.kernel.org
Cc: Naohiro Aota <naohiro.aota@wdc.com>
References: <20260519071621.56490-1-johannes.thumshirn@wdc.com>
 <20260519071621.56490-2-johannes.thumshirn@wdc.com>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20260519071621.56490-2-johannes.thumshirn@wdc.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2026/05/19 9:16, Johannes Thumshirn wrote:
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
> 
> Also move the max_active_zone calculation and setting into a dedicated
> helper, to shrink btrfs_get_dev_zone_info().
> 
> Fixes: 04147d8394e8 ("btrfs: zoned: limit active zones to max_open_zones")
> Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>

Looks OK to me. One nit below.
Regardless:

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>

> +	if (unlikely(nactive > zone_info->max_active_zones)) {
> +		if (bdev_max_active_zones(bdev) == 0) {
> +			zone_info->max_active_zones = 0;
> +			goto validate;

We need a comment to explain this one. Also, I think it would be good to warn
about it, because that potentially would leave a number of partially written
zones that is higher than the max open zones limit (if the device has such
limit), whihc would be bad for performance.

Ideally, we should warn telling the user to run fsck or some other repair
command that gets the FS out of this unusual state.

>  		}
> -		atomic_set(&zone_info->active_zones_left,
> -			   max_active_zones - nactive);
> -		set_bit(BTRFS_FS_ACTIVE_ZONE_TRACKING, &fs_info->flags);
> +		btrfs_err(device->fs_info,
> +				"zoned: %u active zones on %s exceeds max_active_zones %u",
> +				nactive, rcu_dereference(device->name),
> +				zone_info->max_active_zones);
> +		ret = -EIO;
> +		goto out;
>  	}
> +	atomic_set(&zone_info->active_zones_left,
> +			zone_info->max_active_zones - nactive);
> +	set_bit(BTRFS_FS_ACTIVE_ZONE_TRACKING, &fs_info->flags);
>  
>  validate:
>  	/* Validate superblock log */


-- 
Damien Le Moal
Western Digital Research
