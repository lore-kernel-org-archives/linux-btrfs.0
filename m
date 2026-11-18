Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.45
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794987671;
	b=WsGkKNjw53mDhSLRD79Y3m6f4lCb3pMBDDJWK6CXDhGdhuKlW297mN/ak4EEtry/dTrW
	 Dqqs6TWWkJ7ix2/YRUISwh70cc2zbggFMsu+qGzkbYKpz26cmN8KXdeX6K89y7amE0dro
	 voKjRuz30CCuLHwLtOLnRXyRBcB+tnUYDHYgfU8c4ald7a50ap3OhVfU28kHCX7syd0+K
	 SWA4aJVMnZAJI6Iq9K/xNGv9PXGlx7JP+64PuG+9XBzHJMET0yR1FlgT6vCTYDGTPUggO
	 j8rcuwvOCmVjwa6klzIbRNdxmKNsoJbDZlW/Ca9d6ha0pSN+b+fvO5/RLFNrnpVYyqA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794987671;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Message-ID:Date:MIME-Version:User-Agent:Subject:To:Cc:References:
	 Content-Language:From:Autocrypt:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=xR1vDgYDkIc3G+rfIAFZhwHG0Zn5bhNXvFJ1l5DfzhE=;
	b=KkEr7ELBc9+hxZtAq8UTnQC6rLVjPfSgi0sgx8/FoLvJUbl+EawLb6m/jNEaAi8Fx10r
	 /TI1yBdABY/pjLEdOGhDeJ5JfjvzLsIomCcSdTPQMKOUu1zOWySdnR7BbBVZ0XjRZJiGN
	 gWkMlS4woPAUhPoj4wEBQ9bcM1hrUaPhETVGhF5pCu7VczqzpQCT7hNqws1nqOzy93sSY
	 aQ1/g1Wo1jb6lGLXOttbx2bphtlj0mvyK6JpdnzcxFf2yDrYZFg6nqSwmmO6pZ+9a4tFe
	 zx3b+7d+DP7uUzqENfmHWN9+oCX8OyjdkIMvIxQILUc7w5MUWDoR6gQI/tRk/8NwoDw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b="g2/ttmnP";
	arc=none smtp.remote-ip=209.85.128.45
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B769C606A31C
	for <linux-btrfs@vger.kernel.org>; Wed, 18 Nov 2026 07:41:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B769C606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=g2/ttmnP
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-4bb666304fdso13378105e9.0
        for <linux-btrfs@vger.kernel.org>; Tue, 17 Nov 2026 23:41:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1794987669; x=1795592469; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=xR1vDgYDkIc3G+rfIAFZhwHG0Zn5bhNXvFJ1l5DfzhE=;
        b=g2/ttmnPnaTGWwss0a2Ld+VcCiRyRi4ClgNdJU8XtDt3QhqmHEL70c47QsgEqcPTMJ
         xo3J8afjU08K34n0kCm1xGBo1Ln/DDBKXpfMa1y9rmtAm8wzBlTyGFoko3OvUP2UAddT
         mK1fzNSq+ySLXL1ZkDWVeCTYzvSkO973gLhjfbgteMve1JrbCgHQtHpVs7Bce4JP8Iag
         S5+PZS63v9Hi5VICtbZjp2QgCEKRP6fm0Ofv2ExINWMlVX2/9zIlaDeIxwc95w3BIy2T
         gh69a1yxbETKebNNUsuNR37/N9pJc/PDyaIOKwcJDTJriCZFMIeg5ixetuM5OEWKwiuD
         hMKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794987669; x=1795592469;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=xR1vDgYDkIc3G+rfIAFZhwHG0Zn5bhNXvFJ1l5DfzhE=;
        b=ZRPo94NJ/GxhSLYimI0VJz1FylLIarITQiUyF1FiHVB4lh91xjYj40m6ftiWMuF007
         CsPg6nOxDIjLaB/tPH8JN7FHCbHh1V3a71u08CIK0Qipqw0ycmR3CU4Jqcm45iNYgi2U
         3LhLoHPasLmx2diiAMizuoX4Gj6JOUSJhyA2HBLKk/DGGhyJfhAWqxdG7/Qa90Xzj1Fc
         yuyOlvk3dJlnaG+vPc1uACvcare1fbypwApdgRegvN2rtu4mK4XnopFwaCD5Sz1EkruB
         U8tD5KB1oSQu8+ghLDh1ge9lfE5hxFkes6rRnHs1It8ZN+ckAQMbDuLvKl13rr8G9/2o
         3srw==
X-Forwarded-Encrypted: i=1; AL+hErEBAR4czeQ71EN5Cf3enuXAUvd91SHArowV9wGE0wbGXg0b8ctoghE4rUBzi6KT1577R+sVmGKIeJ6scA==@vger.kernel.org
X-Gm-Message-State: APuU4Z+OR6ljG2lfhV7dsSc+8Ku89zDYnbll6rwzOl2UpJCNsRFBkANn
	HvaCNSFcGEIOHnVdhmGGICSqQXagy4gSSshjcP7hvwBtRI2VJ0BLpcAOCW89ecUdWNE=
X-Gm-Gg: AYBFou393RqKSxNn07BJ1JtnwMA/oOx5cav4TeFxm5lEm8jcbw+kRI3zv8fZay1kNl9
	896w7ckKbBl8u0eEdRYgwA5AQNK+2ZYHip5VkSBihR5ersI2MBkeLwTFOxk7spbnro6EwdfFRoj
	stMqnBlVYiOc++13raWRXfIkuFjCpd6V0FpApchtB5l2hnpb2q89Ux4WczyvaddNLu+/LaWZ0VR
	nX55yIUjKKkDldfY+zzcs2R3MgQs/9ynYXnpzaQYiu7kcH27Xgc7EwfOtoOPKG9n93150InhW9i
	80ZmnphtZU1jrzYUTILaPbnSjWmvR3NL9Gzhlf8UL31RX0lGJj9hbpCUrEeYybvaYhOKEIrshJI
	PIJun+MU2y6GprQKmnXL3SdvSFZm4wYYVlbT5P6MHFEz/4wxvOkxMih6+rTO7SqbNJtnkOxLv7u
	ZXS5gM1NpKkFv8h+LPFK1Kx52F9btj9J16pAjwyhq7GDFqOwJiS9tcwRXzssuHYmDbPKiIRyYob
	le/aLRbH2t6TM0VVPGo4Ffc7JMhaEyWkckaVGAyGv1yd+ZsApVnP6R/sPJ0cfjrdK7/A5/U9K26
	bPlW2qRPLV4vSDhijk/uYQhEAURHy7b7JA6wf777
X-Received: by 2002:a05:600d:102:b0:4bb:7f4a:63eb with SMTP id 5b1f17b1804b1-4bb7f4a656emr5136735e9.9.1794987668871;
        Tue, 17 Nov 2026 23:41:08 -0800 (PST)
Received: from [10.86.129.2] ([149.22.87.44])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-382a78d0e69sm4984705eec.23.2026.11.17.23.41.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 Nov 2026 23:41:07 -0800 (PST)
Message-ID: <5739cbcc-bb71-4e9f-95c3-bd2e18d44e53@suse.com>
Date: Wed, 18 Nov 2026 18:10:59 +1030
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
Subject: Re: [PATCH 4/4] btrfs-progs: check: detect and repair exhausted zoned
 active zones
To: Johannes Thumshirn <johannes.thumshirn@wdc.com>,
 linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>, Naohiro Aota <naohiro.aota@wdc.com>,
 Damien Le Moal <dlemoal@kernel.org>, Mark Korenberg <socketpair@gmail.com>,
 Dongjiang Zhu <zhudongjiang@fygo.io>
References: <20261117084948.3848762-1-johannes.thumshirn@wdc.com>
 <20261117084948.3848762-5-johannes.thumshirn@wdc.com>
Content-Language: en-US
From: Qu Wenruo <wqu@suse.com>
Autocrypt: addr=wqu@suse.com; keydata=
 xsBNBFnVga8BCACyhFP3ExcTIuB73jDIBA/vSoYcTyysFQzPvez64TUSCv1SgXEByR7fju3o
 8RfaWuHCnkkea5luuTZMqfgTXrun2dqNVYDNOV6RIVrc4YuG20yhC1epnV55fJCThqij0MRL
 1NxPKXIlEdHvN0Kov3CtWA+R1iNN0RCeVun7rmOrrjBK573aWC5sgP7YsBOLK79H3tmUtz6b
 9Imuj0ZyEsa76Xg9PX9Hn2myKj1hfWGS+5og9Va4hrwQC8ipjXik6NKR5GDV+hOZkktU81G5
 gkQtGB9jOAYRs86QG/b7PtIlbd3+pppT0gaS+wvwMs8cuNG+Pu6KO1oC4jgdseFLu7NpABEB
 AAHNGFF1IFdlbnJ1byA8d3F1QHN1c2UuY29tPsLAlAQTAQgAPgIbAwULCQgHAgYVCAkKCwIE
 FgIDAQIeAQIXgBYhBC3fcuWlpVuonapC4cI9kfOhJf6oBQJq3ujyBQkUpLw5AAoJEMI9kfOh
 Jf6o8OIH/0mqW+TQM4m2x3hCsnK+oB4yJH1qnGvIhFF/Lhs48wI02sGh6/4aA0hkCDfd9LHQ
 +ci4FUepZ9y4VS01+oIExbg/8ytzGYTzLtb44jK2GBOBVSJkMiha6jp22XFt7WUkT/tvbreu
 WWdGsaJIRQaZChy7xsMI8lqQ2WdmluZJ4LT0wD3l/l6QU1ZseMGySebdY9sVOQEOJNV7Qj92
 /KOAFNmeZshV/qDI8Iw1RTs6TvLqCcqmlZLCmJkYSVhT1RonWRren8xIRcFEgMe004IDnt7V
 qdQhk/nhTS9x9MBAhMRl0TTE1VKDLvVALsud3iZLrmmtYvwPApzGJk052f0m28vOwE0EWdWB
 rwEIAKpT62HgSzL9zwGe+WIUCMB+nOEjXAfvoUPUwk+YCEDcOdfkkM5FyBoJs8TCEuPXGXBO
 Cl5P5B8OYYnkHkGWutAVlUTV8KESOIm/KJIA7jJA+Ss9VhMjtePfgWexw+P8itFRSRrrwyUf
 E+0WcAevblUi45LjWWZgpg3A80tHP0iToOZ5MbdYk7YFBE29cDSleskfV80ZKxFv6koQocq0
 vXzTfHvXNDELAuH7Ms/WJcdUzmPyBf3Oq6mKBBH8J6XZc9LjjNZwNbyvsHSrV5bgmu/THX2n
 g/3be+iqf6OggCiy3I1NSMJ5KtR0q2H2Nx2Vqb1fYPOID8McMV9Ll6rh8S8AEQEAAcLAfAQY
 AQgAJgIbDBYhBC3fcuWlpVuonapC4cI9kfOhJf6oBQJq3ukKBQkUzDspAAoJEMI9kfOhJf6o
 SNsH/1ysUWOKmzY0rGS3ZdS61QgqMGhSWD/EJ4UiPw+xO4l4+GtX0fOAqxqsmBKqje3vyhBa
 Z5o/1Y+gNiN+E6RBcSz4b1TAd78sQ2bvT5DWOvBjeeVxHdiuQMIn4S8xk5ZpySBw5ifjoiuL
 0M33UVtJOzM8yfAeL+d/Rp4leJw72SutjkLyZTG/gJIp4pJGD/kFHn24OLL0IxEcO0gOekNZ
 os5e1R6jAJ2ILk7+MDnvU8wXHcCiVzuDhJLI1tih1uUIE50muHQJWbYuVBbdJeu8WlIDDssx
 UOCxLylNG3gDXV5MhLubPTOpp9OiFc/XC37nvkgEcrlmlOFBv4/NJCbECpo=
In-Reply-To: <20261117084948.3848762-5-johannes.thumshirn@wdc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/11/17 19:19, Johannes Thumshirn 写道:
> Kernels before "btrfs: zoned: don't release active zone reservations
> for conventional zones" can leave all active zones to data. The first
> transaction commit after mount then can't activate a metadata
> block-group and aborts with -EAGAIN.
> 
> Report when the active zones in use exceed the kernel's limit minus its
> metadata reservation. With --repair, finish the fullest single profile
> data zones until it fits again, plus one zone for the relocation
> block-group.
> 
> Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
> ---
>   check/main.c | 187 +++++++++++++++++++++++++++++++++++++++++++++++++++
>   1 file changed, 187 insertions(+)
> 
> diff --git a/check/main.c b/check/main.c
> index 717d576f..f065555f 100644
> --- a/check/main.c
> +++ b/check/main.c
> @@ -9203,6 +9203,188 @@ static int check_zoned_active_zones(void)
>   
>   	return ret;
>   }
> +
> +static bool zone_is_active(const struct blk_zone *zone)
> +{
> +	if (zone->type == BLK_ZONE_TYPE_CONVENTIONAL)
> +		return false;
> +
> +	switch (zone->cond) {
> +	case BLK_ZONE_COND_IMP_OPEN:
> +	case BLK_ZONE_COND_EXP_OPEN:
> +	case BLK_ZONE_COND_CLOSED:
> +	case BLK_ZONE_COND_ACTIVE:
> +		return true;
> +	default:
> +		return false;
> +	}
> +}
> +
> +struct finish_candidate {
> +	u32 zno;
> +	u64 left;
> +};
> +
> +static int cmp_finish_candidate(const void *a, const void *b)
> +{
> +	const struct finish_candidate *ca = a, *cb = b;
> +
> +	return ca->left < cb->left ? -1 : ca->left > cb->left;
> +}
> +
> +/*
> + * The kernel keeps active zones in reserve for a metadata, a tree-log and a
> + * system block-group, and only activates metadata block-groups when writing
> + * them. If more zones are active on disk than the kernel's limit minus that
> + * reservation, the first transaction commit after mount can't activate a
> + * metadata block-group and aborts with -EAGAIN. Older kernels could leave
> + * filesystems in that state.
> + *
> + * Mirror the kernel's limit and reservation, see btrfs_get_max_active_zones()
> + * and btrfs_check_active_zone_reservation(), and finish the zones of the
> + * fullest single profile data block-groups until it fits again. Leave one
> + * zone more, for the data relocation block-group activated on mount.
> + *
> + * Return 0 if fine or repaired, 1 if a problem was found, <0 on error.
> + */
> +static int check_dev_active_reservation(struct btrfs_device *dev, int reserved)
> +{
> +	struct btrfs_root *dev_root = gfs_info->dev_root;
> +	struct btrfs_zoned_device_info *zinfo = dev->zone_info;
> +	struct finish_candidate *cand;
> +	BTRFS_PATH_AUTO_RELEASE(path);
> +	struct btrfs_key key;
> +	int max_active, nactive = 0, ncand = 0;
> +	int shift = ilog2(zinfo->zone_size);
> +	int left, need;
> +	int ret;
> +
> +	max_active = btrfs_get_max_active_zones(dev);
> +	for (int i = 0; i < zinfo->nr_zones; i++)
> +		nactive += zone_is_active(&zinfo->zones[i]);
> +	/* The kernel disables active zone tracking in this case. */
> +	if (nactive > max_active && !zinfo->max_active_zones)
> +		return 0;
> +
> +	cand = calloc(zinfo->nr_zones, sizeof(*cand));
> +	if (!cand)
> +		return -ENOMEM;
> +
> +	key.objectid = dev->devid;
> +	key.type = BTRFS_DEV_EXTENT_KEY;
> +	key.offset = 0;
> +	ret = btrfs_search_slot(NULL, dev_root, &key, &path, 0, 0);
> +	if (ret < 0)
> +		goto out;
> +
> +	while (1) {
> +		struct btrfs_block_group *bg;
> +		struct btrfs_dev_extent *devext;
> +		u64 pstart, plen, chunk;
> +
> +		if (path.slots[0] >= btrfs_header_nritems(path.nodes[0])) {
> +			ret = btrfs_next_leaf(dev_root, &path);
> +			if (ret < 0)
> +				goto out;
> +			if (ret > 0)
> +				break;
> +		}
> +
> +		btrfs_item_key_to_cpu(path.nodes[0], &key, path.slots[0]);
> +		if (key.objectid != dev->devid || key.type != BTRFS_DEV_EXTENT_KEY)
> +			break;
> +
> +		devext = btrfs_item_ptr(path.nodes[0], path.slots[0],
> +					struct btrfs_dev_extent);
> +		pstart = key.offset;
> +		plen = btrfs_dev_extent_length(path.nodes[0], devext);
> +		chunk = btrfs_dev_extent_chunk_offset(path.nodes[0], devext);
> +		bg = btrfs_lookup_block_group(gfs_info, chunk);
> +		path.slots[0]++;
> +		if (!bg)
> +			continue;
> +
> +		for (u64 zno = pstart >> shift;
> +		     zno <= (pstart + plen - 1) >> shift && zno < zinfo->nr_zones;
> +		     zno++) {
> +			struct blk_zone *zone = &zinfo->zones[zno];
> +
> +			if (!zone_is_active(zone))
> +				continue;
> +			if (bg->flags & (BTRFS_BLOCK_GROUP_METADATA |
> +					 BTRFS_BLOCK_GROUP_SYSTEM)) {
> +				reserved--;
> +			} else if (!(bg->flags & BTRFS_BLOCK_GROUP_PROFILE_MASK)) {
> +				cand[ncand].zno = zno;
> +				cand[ncand].left = (zone->start + zone->capacity -
> +						    zone->wp) << SECTOR_SHIFT;
> +				ncand++;
> +			}
> +		}
> +	}
> +
> +	ret = 0;
> +	reserved = max(reserved, 0);
> +	left = max_active - nactive;
> +	if (left >= reserved)
> +		goto out;
> +	need = reserved + 1 - left;
> +
> +	ret = 1;
> +	error(
> +"zoned: devid %llu has %d of %d active zones in use and %d reserved for metadata, the first commit after mount can fail",
> +	      dev->devid, nactive, max_active, reserved);
> +	if (!opt_check_repair)
> +		goto out;
> +
> +	if (ncand < need) {
> +		error("zoned: only %d data zones on devid %llu can be finished, need %d",
> +		      ncand, dev->devid, need);
> +		goto out;
> +	}
> +
> +	qsort(cand, ncand, sizeof(*cand), cmp_finish_candidate);
> +	for (int i = 0; i < need; i++) {
> +		struct blk_zone *zone = &zinfo->zones[cand[i].zno];
> +
> +		ret = btrfs_finish_dev_zone(dev->fd, zone);

Shoudln't zinfo->active_zones or active_zones_left also to be updated 
here or by the btrfs_finish_dev_zone() itself?

> +		if (ret) {
> +			errno = -ret;
> +			error("zoned: failed to finish zone %u on devid %llu: %m",
> +			      cand[i].zno, dev->devid);
> +			goto out;
> +		}
> +		printf("Finished zone %u on devid %llu, %llu bytes left unused\n",
> +		       cand[i].zno, dev->devid, cand[i].left);
> +	}
> +out:
> +	free(cand);
> +	return ret;
> +}
> +
> +static int check_zoned_active_reservation(void)
> +{
> +	struct btrfs_device *dev;
> +	int reserved;
> +	int ret = 0;
> +
> +	reserved = (gfs_info->avail_metadata_alloc_bits & BTRFS_BLOCK_GROUP_DUP) ? 4 : 2;
> +	reserved += (gfs_info->avail_system_alloc_bits & BTRFS_BLOCK_GROUP_DUP) ? 2 : 1;
> +
> +	list_for_each_entry(dev, &gfs_info->fs_devices->devices, dev_list) {
> +		int err;
> +
> +		if (!dev->zone_info || dev->zone_info->model != ZONED_HOST_MANAGED)
> +			continue;
> +
> +		err = check_dev_active_reservation(dev, reserved);
> +		if (err < 0)
> +			return err;
> +		ret |= err;
> +	}
> +
> +	return ret;
> +}
>   #endif
>   
>   /*
> @@ -9219,6 +9401,7 @@ static int check_zoned_active_zones(void)
>   static int check_zoned(void)
>   {
>   	int ret = 0;
> +	int err __maybe_unused;
>   
>   	if (!btrfs_is_zoned(gfs_info))
>   		return 0;
> @@ -9227,6 +9410,10 @@ static int check_zoned(void)
>   	ret = check_zoned_active_zones();
>   	if (ret < 0)
>   		return ret;
> +	err = check_zoned_active_reservation();
> +	if (err < 0)
> +		return err;
> +	ret |= err;
>   #endif
>   	return ret;
>   }

