Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795726441;
	b=rTgczOzWV+wbGl3dnLrB6RUlvptMMFqUU6OqNKwIvNpEpT7tamY5PU/fd0IWDSL4K02X
	 hpHmAbdr78NhsX+6SEvtCSlcAUhvfWIXuEc3F2IPSQgoK4E8keOIBUrUOmSZCARlNwZzu
	 RCTph7vbP7RhFwNxKyyKjV22ZWYOZIfFG78l6Sn8xTqm9dHePV2L+ZWfI1R277mnr6eux
	 tKm2vS8ufPK086hdHQwTM8FjU/+rRvxK2HSshFj+qK+I6txvPLt926IOcKZRrCVJRchM3
	 7TEP2Vu6PKVJmdWJ0Q/aH/EF0+qhQ2r/POE28vI5bQDko4IGZr0DfzAofI6abWcAesw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795726441;
	h=Received:DKIM-Signature:Message-ID:Date:MIME-Version:User-Agent:
	 Subject:To:Cc:References:Content-Language:From:Organization:
	 In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=PjLSOubJqcXrC+m0cNZe+hR0JFQOSUcsUeCBdaqIOYw=;
	b=RENoKn9UNgeQZFAjn2OqmcPgeuhn9wpQgZT3Oj9PeOZAf0fmyylPQxR1HJFvWA3Te2Y2
	 +aAUuE++XPCT4F9agWOPAAHFGwblAa0mbF0TjxdOSFu79/XOzICRZ/tHh01h0OnG0UIiZ
	 qJx5WYrrrcOsaU6Uwj5VViVP3lS3s+pY3lYQTDxafrmlXZ/17xqnxZ+dm9KcBiw08f8JO
	 e/k8HX1Rc9wDgFKKVBh/i099J9G4qZuFQZhureJldKNMKmOlfZckX1Ylgqac43UXZ6DyO
	 OStbQrfuS29UVFASsKse8wTPEZBWMjlQgLcnhnYv10/gT9tTTSe94OcQXXkXnHkxkBA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ngDBIDiT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FA1E606A31C
	for <linux-btrfs@vger.kernel.org>; Thu, 26 Nov 2026 20:54:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ngDBIDiT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C59301F00898;
	Thu, 26 Nov 2026 20:53:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795726440;
	bh=PjLSOubJqcXrC+m0cNZe+hR0JFQOSUcsUeCBdaqIOYw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=ngDBIDiTvjj6xnk55sZV/zttVWeYFdwr50QkaDvM1W7z4l4DXSSvDGEmsQKNuWMzN
	 cJrQvKzpPhHMUEVTwx6UizivIOG1BRHyil+3txr8OBHkX9P5mpeb/qVD0S8+oLqDRY
	 6I8tgr/sN72cRIXfvRuLWthytMqf1j8m1SKD1uaZfD2iT2kNfpVT+UG+vLLo58GnhJ
	 zBQztz/urVdS/hHkXG8sVSjMycdebchOIAKAn6gBG7LSkJIVdeMw8YnLnmA2eWjMRs
	 FPpUyl/TGiZLL1oSZ7LpXv5upGadsE21heXL0n6XILyGyYKJDDpPp4IBx4iRmQlDhs
	 y3dNzrZlptUEA==
Message-ID: <4dab478c-3d04-4056-86b5-70ffafab2105@kernel.org>
Date: Fri, 27 Nov 2026 05:53:58 +0900
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
Subject: Re: [PATCH v2 3/4] btrfs-progs: zoned: add
 btrfs_get_max_active_zones()
To: Johannes Thumshirn <johannes.thumshirn@wdc.com>,
 linux-btrfs@vger.kernel.org
Cc: Qu Wenruo <wqu@suse.com>, Naohiro Aota <naohiro.aota@wdc.com>,
 David Sterba <dsterba@suse.com>, Dongjiang Zhu <zhudongjiang@fygo.io>,
 Mark Korenberg <socketpair@gmail.com>
References: <20261126094815.479691-1-johannes.thumshirn@wdc.com>
 <20261126094815.479691-4-johannes.thumshirn@wdc.com>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20261126094815.479691-4-johannes.thumshirn@wdc.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/26/26 18:48, Johannes Thumshirn wrote:
> Return the active zone limit the kernel uses for a device, the same as
> btrfs_get_max_active_zones() there: the smaller non-zero of
> max_active_zones and max_open_zones, a default otherwise, at least
> BTRFS_MIN_ACTIVE_ZONES.
> 
> Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>

One nit below, but otherwise looks good.

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>

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

Nit: the above if uses "!max_active_zones", so to be style consistent, maybe do
the same here?

> +		max_active_zones = min_t(u32, device->zone_info->nr_zones / 4,
> +					 BTRFS_DEFAULT_MAX_ACTIVE_ZONES);
> +	if (max_active_zones)
> +		return max_active_zones;
> +
> +	return BTRFS_MIN_ACTIVE_ZONES;
> +}
-- 
Damien Le Moal
Western Digital Research
