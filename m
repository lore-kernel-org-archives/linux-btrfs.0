Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795726666;
	b=ZPZW3Zc0C0aynZ1Pdy0fVgMUr8e7XskuN5HXQlwqR0qjJzk2scB+DBwiDqe/pHrAFHgA
	 kMsDNnfC84j+7fovGBS8f91861XLM8thtLb/bnx8O75hYymU1GX5dgPe4LIhu1VC4Z4zK
	 OGMfj25rD/iVbGdBcCo64BbeFt/ltnfERp/guWm0nrqC570R+p0FzcPSSOy7dpXOn8XlH
	 IOd82hJCOTkIaaoqwXbtdIh3yIyTEK6uI+CZqFzj5oslDOOmRwUtRzwfDjTY2Th9VG4tB
	 iEzyu1HATLbG4TtIj5DLfnPqZ+PbERJGnDixzJ77nsBUwQS5e1ho3cdFPMUL2u5WTmg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795726666;
	h=Received:DKIM-Signature:Message-ID:Date:MIME-Version:User-Agent:
	 Subject:To:Cc:References:Content-Language:From:Organization:
	 In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=sQVnHhUBY2ZBHU09cV/ad4kzpuqgQ8nZFOAeg4gmnso=;
	b=TftGbiRalTmR/FI0qm3wWdEd58tgF0cRGEoypQ2lqccFAoqOtwTodzCtISE8xC4BeUGO
	 gv/m9nRVHUMMtZBW4FnrsHQWwBNOOA5tNkS6G6f+0I5y3pM8znmPizNXyQK8K6KFR4SBh
	 oME4QSjVDwPLskunG/na/HUSdzJH2TQ004SZPiN5zOI/bAbhy+JLNOFaY4yWNwXSlKMZp
	 UyuyqR3eDmmmEQY6prK8Ooj6PEqPh8JZhZNed/ofCaNtHPGDxsXpNP+KR7TM807pJCSMh
	 IH2X/bG9X2M6anQuvMzxX6yoFlzOHY+48s0Ng0FLVJW8ENWoXflMJci7I3EIGND4XdQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nvdutCql;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5567F606A31E
	for <linux-btrfs@vger.kernel.org>; Thu, 26 Nov 2026 20:57:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nvdutCql
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E2E71F00896;
	Thu, 26 Nov 2026 20:57:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795726665;
	bh=sQVnHhUBY2ZBHU09cV/ad4kzpuqgQ8nZFOAeg4gmnso=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=nvdutCqlUamUXTNWsN0t/rJoE3FSJe86H87m+s//cRoT+b+tv9K9cVKXF7M2zxJdR
	 UyYS79RZtDIkHG9ucsQgKcy7zrSWcbPO46m+rExRaGSDshnuVtuI3CNgevBPNZLS9B
	 ZkaksVyrit81DGxeJj8Dl1P6dFPl1kP1x641eDIuuJjIoS0doOZvqGHWQGHZQ3tlGR
	 jRvFAIVoUboFuORjY4idsyt8VPf+X6XededcP70jvKETJZqM/SJMkH1NdejgN3AjXP
	 9rebFq+mB4YH/VWsLfimGQ52MA9JhMzR7S4+Fhxe9mWcLxKqqUjU5LDfIs4cMIJTqZ
	 NcSjqAtNNEE0Q==
Message-ID: <c0d16f78-3bb3-4ddf-9509-c79a46127dc2@kernel.org>
Date: Fri, 27 Nov 2026 05:57:43 +0900
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
Subject: Re: [PATCH v2 4/4] btrfs-progs: check: detect and repair exhausted
 zoned active zones
To: Johannes Thumshirn <johannes.thumshirn@wdc.com>,
 linux-btrfs@vger.kernel.org
Cc: Qu Wenruo <wqu@suse.com>, Naohiro Aota <naohiro.aota@wdc.com>,
 David Sterba <dsterba@suse.com>, Dongjiang Zhu <zhudongjiang@fygo.io>,
 Mark Korenberg <socketpair@gmail.com>
References: <20261126094815.479691-1-johannes.thumshirn@wdc.com>
 <20261126094815.479691-5-johannes.thumshirn@wdc.com>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20261126094815.479691-5-johannes.thumshirn@wdc.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/26/26 18:48, Johannes Thumshirn wrote:
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
>  check/main.c | 190 +++++++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 190 insertions(+)
> 
> diff --git a/check/main.c b/check/main.c
> index 717d576f..fe209f22 100644
> --- a/check/main.c
> +++ b/check/main.c
> @@ -9203,6 +9203,191 @@ static int check_zoned_active_zones(void)
>  
>  	return ret;
>  }
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

If zinfo->max_active_zones is 0, why even bother counting active zones>
Shouldn't you just return immediately?

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
> +		if (ret) {
> +			errno = -ret;
> +			error("zoned: failed to finish zone %u on devid %llu: %m",
> +			      cand[i].zno, dev->devid);
> +			goto out;
> +		}
> +		clear_bit(cand[i].zno, zinfo->active_zones);
> +		if (zinfo->max_active_zones)
> +			atomic_inc(&zinfo->active_zones_left);
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
>  #endif
>  
>  /*
> @@ -9219,6 +9404,7 @@ static int check_zoned_active_zones(void)
>  static int check_zoned(void)
>  {
>  	int ret = 0;
> +	int err __maybe_unused;
>  
>  	if (!btrfs_is_zoned(gfs_info))
>  		return 0;
> @@ -9227,6 +9413,10 @@ static int check_zoned(void)
>  	ret = check_zoned_active_zones();
>  	if (ret < 0)
>  		return ret;
> +	err = check_zoned_active_reservation();
> +	if (err < 0)
> +		return err;
> +	ret |= err;
>  #endif
>  	return ret;
>  }


-- 
Damien Le Moal
Western Digital Research
