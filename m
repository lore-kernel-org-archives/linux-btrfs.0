Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794917030;
	b=GE3QaDKAvfrIoDqlBklFkeYNz7KEZAdWf/yXeOQMe8E6PkZCud9COe/Q+LmI4f1c8PQt
	 wLvjLBqXxtsIpICA4kMzEfYg/Veq9wQWK+k80rb4tfsdUgN9uoCHM2sRrKukU/zZ1YzBC
	 DxD9VQMZNeB65BP45Cecu+7zBb1SxsucUkc206vO4WJrh2CK5t6/xAHFYB+suTUWaDoSe
	 VdNMphwjlrFIi/zHYa9pM1aAokAlmCQjnrJdkjdKv+UGsLIE0/JUfNdM9KQIykNrKcyI7
	 baHlEB2uLy0C0VYutAtDPXnlPnzVD1Rl8/UK4KsL8VtDM/lYU9ycpT28N+B1scjGrNw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794917030;
	h=Received:DKIM-Signature:Message-ID:Date:MIME-Version:User-Agent:
	 Subject:To:Cc:References:Content-Language:From:Organization:
	 In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=mdbBWR1lFJ4T3AkQT6Xt9dH9cPm8FCVRpys9uxiY46w=;
	b=Aer5hvQtGN9ODxZNmr9R+Jrf3k0hexEGRjHHo3a2Ip67I1bYjsBFDt+APB1M1LdRqC2F
	 2K3ZnBqHzSU/Dh5nNGBBDAdrEWFDejzcrdzbTuqvd/aIi7DvSmnBkXyxi6z3aMLwT7ali
	 gL65uCSTvlDhBkfu4EclylMF0xLbB9iLrNSFw5/s+D2Dc/TdLUKiFHZmEvQb5HfPAwH9+
	 +pd/rIBgnss//L5EoSQ7yszvkXEl6N6Hhoipn/5q2jt38jpkHc765NvPPKPw9D9Y/8aha
	 SfOwSQIMUTN0d6WVem1EmXfm4zAJGwi4CsmOIFpEMNOupH4Do3BwLBls1Jw20gcqKhg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=G2aRtCP9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73D0F606A31C
	for <linux-btrfs@vger.kernel.org>; Tue, 17 Nov 2026 12:03:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=G2aRtCP9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 464331F000C4;
	Tue, 17 Nov 2026 12:03:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794917030;
	bh=mdbBWR1lFJ4T3AkQT6Xt9dH9cPm8FCVRpys9uxiY46w=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=G2aRtCP9ulfpEiUY7hgDXyNDoizFCGKhXGXoSRxcL6KYEcha+hrZbOGYMFq5EcLww
	 7d2MdXlmZce8R/1GJqvBKjfkw8raO2DCy3pybbsiZLyPhWsTHeNmESBHhbsJ2yxZlV
	 3/H3U9yIUKI1Tv3mrHva3X1amtpKS6sp6j8wteAiOsLK6HAF7BhuX7Eylq5m5ijiwE
	 uDS6UMbn/RFlLUMlB/+9mdSTOVVje36KZudj0nBRm/aK5eWoC2BL5FPddkFAMbmkGP
	 EjFdC9VXFajS50x2USB0k9p/VVuSsRxpE71yzaNTfDgEgs5L2T5zxO04ABexDJ2iUD
	 wxBY6zYDeuTQQ==
Message-ID: <99260fd7-796c-464b-8a9d-d13622945156@kernel.org>
Date: Tue, 17 Nov 2026 04:03:48 -0800
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/4] btrfs-progs: zoned: add btrfs_get_max_active_zones()
To: Johannes Thumshirn <johannes.thumshirn@wdc.com>,
 linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>, Naohiro Aota <naohiro.aota@wdc.com>,
 Qu Wenruo <wqu@suse.com>, Mark Korenberg <socketpair@gmail.com>,
 Dongjiang Zhu <zhudongjiang@fygo.io>
References: <20261117084948.3848762-1-johannes.thumshirn@wdc.com>
 <20261117084948.3848762-4-johannes.thumshirn@wdc.com>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20261117084948.3848762-4-johannes.thumshirn@wdc.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/17/26 00:49, Johannes Thumshirn wrote:
> Return the active zone limit the kernel uses for a device, the same as
> btrfs_get_max_active_zones() there: the smaller non-zero of
> max_active_zones and max_open_zones, a default otherwise, at least
> BTRFS_MIN_ACTIVE_ZONES.
> 
> Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
> ---
>  kernel-shared/zoned.c | 23 +++++++++++++++++++++++
>  kernel-shared/zoned.h |  1 +
>  2 files changed, 24 insertions(+)
> 
> diff --git a/kernel-shared/zoned.c b/kernel-shared/zoned.c
> index 48313ccc..89ba544a 100644
> --- a/kernel-shared/zoned.c
> +++ b/kernel-shared/zoned.c
> @@ -67,6 +67,7 @@ static u64 emulated_zone_size = DEFAULT_EMULATED_ZONE_SIZE;
>   * - 1 zone for relocation
>   */
>  #define BTRFS_MIN_ACTIVE_ZONES		(BTRFS_SUPER_MIRROR_MAX + 5)
> +#define BTRFS_DEFAULT_MAX_ACTIVE_ZONES	128
>  
>  static int btrfs_get_dev_zone_info(struct btrfs_device *device);
>  
> @@ -155,6 +156,28 @@ static unsigned int max_active_zone_count(const char *file)
>  	return strtoul((const char *)buf, NULL, 10);
>  }
>  
> +/*
> + * Same limit as btrfs_get_max_active_zones() in the kernel. Unlike the kernel
> + * this returns it instead of setting zone_info->max_active_zones, which stays
> + * the device's max_active_zones in progs.
> + */
> +unsigned int btrfs_get_max_active_zones(struct btrfs_device *device)
> +{
> +	unsigned int max_active_zones = max_active_zone_count(device->name);
> +	unsigned int max_open_zones = 0;
> +	char buf[32];
> +
> +	if (device_get_queue_param(device->name, "max_open_zones", buf, sizeof(buf)) > 0)
> +		max_open_zones = strtoul(buf, NULL, 10);
> +	if (!max_active_zones || (max_open_zones && max_open_zones < max_active_zones))
> +		max_active_zones = max_open_zones;
> +	if (max_active_zones == 0)
> +		max_active_zones = min_t(u32, device->zone_info->nr_zones / 4,
> +					 BTRFS_DEFAULT_MAX_ACTIVE_ZONES);
> +
> +	return max_t(unsigned int, max_active_zones, BTRFS_MIN_ACTIVE_ZONES);

I am confused here. If we endup with max_active_zones being lower than
BTRFS_MIN_ACTIVE_ZONES, because the max open zone limit is lower or the drive
indeed has a lower limit than 128, it seems to be very wrong to return the
larger BTRFS_MIN_ACTIVE_ZONES...

So shouldn't this be:

	if (max_active_zones)
		return max_active_zones;
	return BTRFS_MIN_ACTIVE_ZONES;
	

> +}
> +
>  #ifdef BTRFS_ZONED
>  /*
>   * Emulate blkdev_report_zones() for a non-zoned device. It slices up the block
> diff --git a/kernel-shared/zoned.h b/kernel-shared/zoned.h
> index 363ef4a7..e323baf1 100644
> --- a/kernel-shared/zoned.h
> +++ b/kernel-shared/zoned.h
> @@ -99,6 +99,7 @@ static inline void btrfs_free_zoned_device_info(struct btrfs_zoned_device_info *
>  }
>  
>  int btrfs_get_dev_zone_info_all_devices(struct btrfs_fs_info *fs_info);
> +unsigned int btrfs_get_max_active_zones(struct btrfs_device *device);
>  int btrfs_check_zoned_mode(struct btrfs_fs_info *fs_info);
>  
>  #ifdef BTRFS_ZONED


-- 
Damien Le Moal
Western Digital Research
