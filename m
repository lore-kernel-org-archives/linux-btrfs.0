Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3754A34D384
	for <linux-btrfs@vger.kernel.org>; Tue, 19 May 2026 08:37:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779179868; cv=none; b=M8hzzevPIZ/lriuLBxPRQMQaXyJAionC3629owcpPtTxOy2CE/KT5lv+lrCCPceYp0cJ+aA5TXKAEupHGZXJKJvvgNN1kb4PEPV7zwIjEHHcddsrMSTefrAmIqM0jTZcia9ZBKv4Z7mXfXYUQbuHykgnI3IfxSVPlTXRAsZyiXQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779179868; c=relaxed/simple;
	bh=LyHxaHKPPtAnRLOz6LjavkvRNL7baWuIvvU5I3o9rlY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fXWP5tryCl7ztLNTEZaahxmo6kg99Mx1oUf4bMxEmIU6tBlw+bHHXcu8aYW2d5ZEt5v+gdIgSprcAaWdGy2yBjqy0o3vI8D8PA3KhrPOLtIW4Yq8qJYA1csM6q6ilKRirQyheIHepYFdkOzXYeshemeywgzjA0q7pOTSAw4ymk8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sV2lD37Q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sV2lD37Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41F7FC2BCC9;
	Tue, 19 May 2026 08:37:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779179867;
	bh=LyHxaHKPPtAnRLOz6LjavkvRNL7baWuIvvU5I3o9rlY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=sV2lD37QNOWG/QUcVNzHsi+ik42Q0LeMZNWpkkjy8XLdBeYqmWwhArZC0z3WvuVL6
	 EqqMTAwcXn2UPioGz1bOaRnmzRHtT1QLrsvCJK5Huo7ARJszFT9aC8b1Zl0ZAax9wT
	 wYgbfpDweHD34PjtnXkIE65rsfw7hhCssNtgEoG/IkyDRIcvuENO5Ggt1cdmzFzgfR
	 qw5CIHnbAKK5WTfOZsdiTB8CV2jTy/TCofPpoOCYN4wJIyXFKqrWTVxOElDkKTPawI
	 LND6shQvIs0HHqSNKL3Ky/2OJlyurdYB5k5Pro5Q7G1KmQChwiEmGF2o3ks+9dGEsJ
	 uyL34Q0lsREiA==
Message-ID: <47dd7766-66ff-43e5-8894-f46bffff469f@kernel.org>
Date: Tue, 19 May 2026 10:37:45 +0200
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 2/2] btrfs: zoned: reflow max_active vs active checking
To: Johannes Thumshirn <johannes.thumshirn@wdc.com>,
 linux-btrfs@vger.kernel.org
Cc: Naohiro Aota <naohiro.aota@wdc.com>
References: <20260519071621.56490-1-johannes.thumshirn@wdc.com>
 <20260519071621.56490-3-johannes.thumshirn@wdc.com>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20260519071621.56490-3-johannes.thumshirn@wdc.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2026/05/19 9:16, Johannes Thumshirn wrote:
> Reflow the checking of max_active_zones vs number of active zones, this
> simplifies the code and gets rid of a goto.
> 
> Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
> ---
>  fs/btrfs/zoned.c | 32 +++++++++++++++++++-------------
>  1 file changed, 19 insertions(+), 13 deletions(-)
> 
> diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
> index b1d0e2414178..9653681a6954 100644
> --- a/fs/btrfs/zoned.c
> +++ b/fs/btrfs/zoned.c
> @@ -528,22 +528,28 @@ int btrfs_get_dev_zone_info(struct btrfs_device *device, bool populate_cache)
>  	}
>  
>  	if (unlikely(nactive > zone_info->max_active_zones)) {
> -		if (bdev_max_active_zones(bdev) == 0) {
> -			zone_info->max_active_zones = 0;
> -			goto validate;
> +		if (bdev_max_active_zones(bdev) > 0) {
> +			btrfs_err(device->fs_info,
> +					"zoned: %u active zones on %s exceeds max_active_zones %u",
> +					nactive, rcu_dereference(device->name),
> +					zone_info->max_active_zones);
> +			ret = -EIO;
> +			goto out;
>  		}
> -		btrfs_err(device->fs_info,
> -				"zoned: %u active zones on %s exceeds max_active_zones %u",
> -				nactive, rcu_dereference(device->name),
> -				zone_info->max_active_zones);
> -		ret = -EIO;
> -		goto out;
> +
> +		/*
> +		 * This is for backwards compatibility with old filesystems that
> +		 * have a lot of active zones because the device doesn't report
> +		 * a maximum number of zones and we previously didn't care for
> +		 * the limit,
> +		 */
> +		zone_info->max_active_zones = 0;

Ah. OK. So you did this here... I really think that this should be in the
previous patch.

> +	} else {
> +		atomic_set(&zone_info->active_zones_left,
> +				zone_info->max_active_zones - nactive);
> +		set_bit(BTRFS_FS_ACTIVE_ZONE_TRACKING, &fs_info->flags);
>  	}
> -	atomic_set(&zone_info->active_zones_left,
> -			zone_info->max_active_zones - nactive);
> -	set_bit(BTRFS_FS_ACTIVE_ZONE_TRACKING, &fs_info->flags);
>  
> -validate:
>  	/* Validate superblock log */
>  	nr_zones = BTRFS_NR_SB_LOG_ZONES;
>  	for (i = 0; i < BTRFS_SUPER_MIRROR_MAX; i++) {


-- 
Damien Le Moal
Western Digital Research
