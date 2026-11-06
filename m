Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=202.12.124.159
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793993221;
	b=jx/IYD0RAitqZJoaPHgCY22umBZNn0ORNdaLQzPVtaNPUdffr5CJxCxkNwn/5HVl6gLZ
	 ZK/gQRlgYKTL3/Rv+KBIISShoxA1JAOGzuJMTOeYTNLhMWoch7hTWk7bU+q+18YQShxnJ
	 bWhFCgrz1HdeSbali2kIGT202puMOVyuF8yqtTwCJV34D5GUQUBDhJSJF36tqGmSBKJYh
	 21uUd4Q8jtLTNCzORn+EV/FDU0oY0D5Vhb4zgC6A2gxpg6eQSEXzDGj/KoN5xUevlgo43
	 tx4724tAYhPokHCR/wG7R0mw11rtgnKykWa2tESdYwpuIoV1oaUBmcVwlp2JwQvMPBA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793993221;
	h=DMARC-Filter:Received:Received:DKIM-Signature:DKIM-Signature:
	 X-DKIM2-Info:DKIM2-Signature:X-DKIM2-Info:Message-Instance:
	 X-ME-Sender:X-ME-Received:X-ME-Proxy-Cause:X-ME-Proxy:Feedback-ID:
	 Received:Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=9lkKIcx3ACvfnAKNR/J2BipYo2cy26YwHS91MRBaff8=;
	b=053BJqVMhtu25IVqdo8xdkNdJp9jUTwglxiSvA+m78sEJ/3XTajcq4arrAm6dMIyfSPU
	 GLcAvAqMzOg6xfpxXE1ON7zg9TuBweI6/cJAPs9gujkshUv2yUqncWGxPKoxxReNsVSeS
	 GGUuj6Mkg057kYLNgc6PyeIJoqVQ0Bir+Z15x1uX5z9DWYQBq9htafjNah9xNcAy5zDXH
	 YpkZag88pxQ4m17h9qChIoka9nLARa3e72GydHQL3Mhtqm/NKYFLYe14HadNMbY/3oIoL
	 D60MVfErhh7gCQGqpjpmtErgSCN4WMJ57Sdp5Wus3H8xKkrpRCCY1RcknhEHRa4qxJQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=bur.io;
	spf=pass smtp.mailfrom=bur.io;
	dkim=pass header.d=bur.io header.i=@bur.io header.a=rsa-sha256 header.s=fm1 header.b=juHZg+HO;
	dkim=pass header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=a5vi712c;
	arc=none smtp.remote-ip=202.12.124.159
Received: from fhigh-b8-smtp.messagingengine.com (fhigh-b8-smtp.messagingengine.com [202.12.124.159])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F05D606A326
	for <linux-btrfs@vger.kernel.org>; Fri,  6 Nov 2026 19:27:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5F05D606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bur.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=bur.io header.i=@bur.io header.a=rsa-sha256 header.s=fm1 header.b=juHZg+HO;
	dkim=pass (2048-bit key, unprotected) header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=a5vi712c
Received: from phl-compute-10.internal (phl-compute-10.internal [10.202.2.50])
	by mailfhigh.stl.internal (Postfix) with ESMTP id 9BCEF7A0115
	for <linux-btrfs@vger.kernel.org>; Fri,  6 Nov 2026 14:26:59 -0500 (EST)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-10.internal (MEProxy); Fri, 06 Nov 2026 14:26:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc:cc
	:content-type:content-type:date:date:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to; s=fm1; t=1793993219; x=1794079619; bh=9lkKIcx3AC
	vfnAKNR/J2BipYo2cy26YwHS91MRBaff8=; b=juHZg+HOkMgcG31QEW8zvLb8QR
	xpxJh9Hwt0xV2TP0KKqXAf8f4QlXaeTvJs3XB568douU0XTUL4VNennuGWt+UsZA
	ImshEXNS3DRqCbWD4EYRsfdZDOAj6JcMU8fQyukW7nEkw6CFDu76icrO0ygX0xa/
	i6Pg4bUYMuyTAsc/maf8ODrR0oQ2bQK3BIj+Gy2G5HLAqvCSEPlS5vwJGEGybWgG
	52iRWXywoqvLnXCNJVUVZosmcCJsEFXhnUENT4YJgTuMvFdhBD2KduEzvU9D22t4
	dEa6LoGwtYZQJkTVEW8E0rneUFYpn3zBni8i4AZvxPABpWxrdY8g6futovxA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=
	1793993219; x=1794079619; bh=9lkKIcx3ACvfnAKNR/J2BipYo2cy26YwHS9
	1MRBaff8=; b=a5vi712cHgtdWLOf4mjEMYwwfxJxVpIK7fnRVTTyKYig2XFDZ6R
	BKeKvidcVfRsdoLLxAvV8holHq2NgBvLW1KUH67MEK5mIp0KEe49GAbS2ORLM5fX
	8PsESquKNrzcBlBxz/jcqty4vU3ghH6fIO2zWqHvBuWXfUHEIrOgj84ugsCOpJEp
	uSINT/e6ScPrVE0Rh3rNCqLlunFEc4Elr1RicedVFjHtwSVxSiMBGhQ+eEWKJrgt
	Ew9v1oyQITZGi9ptKXNbrSf+7zb6CyIo9wY/qM4YENPZTCv8Hjqvj294dvOVxOIQ
	XEu+cEbMsbnpYUYgykirA4EWYtXEBrBzgrw==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=sign d=bur.io a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1793993219; d=bur.io;
	mf=PGJvcmlzQGJ1ci5pbz4=;
	rt=PGxpbnV4LWJ0cmZzQHZnZXIua2VybmVsLm9yZz4=;
	s=fm1:rsa-sha256:QdK9oJEIe6nrI3pr1doei6SS6eUd2Ep1CyfqtLsqdG0CxB0
	JhWrzt1VJaTuuV11tWWZbG6iQMQN/aWFevKZ3JuesdQ3fLkpj12wIWFi7VNRMEtY
	fkv5daAfJKKbXQaROTnfYBrePUK1OT+ILPjyc3GirDYkQnHbEmJtZDusFCUqwMtK
	/sMr9niAlUtnO36SaDM3bPtA5pkOcS0WQDy+GWrTHIt4SFk1e9eIglsvLuws/9PQ
	9gzBmxrDnwVYp5eNcaFHll8VYQC0JTId3xaATIY+sxMHIzRZLOW1D2nGlie2898P
	dEAA8P7UTRdfTrSWhIqB99ylERG/tPAZe6jmsFg==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=mi-m=1; hc=12;
	hn=cc,content-disposition,content-type,date,feedback-id,from,
	in-reply-to,message-id,mime-version,references,subject,to;
Message-Instance: m=1; h=sha256:9zFkETByrX7ibn94WT9qZ1C+X1p3llCHegYZOkkj3Mo=:EVcokZaxPh25KbNh+1/26MH8eoN9OXfenX2VVlgL7LI=;
X-ME-Sender: <xms:AyruavrqTIx_1oUlLwRAmpbjyoe-9un8qJOUdf26LO_XYtCEHEPU3A>
    <xme:AyruahGgJvRyohVlBUl9yrzJ-8nkrAVNrysnwX4ZtlT_0f6uaYnX768FgLA1tb_uO
    Wx_O2LyW6TTWUDI2pv0z4E2iJL1OQL4L3QNsKBhWzhr7t9ogm6g9hY>
X-ME-Received: <xmr:Ayruapl1ayqJkyOMOClDKstW56RyKcNvyTPKWjlbgdEVOqJmlK1YwyqS>
X-ME-Proxy-Cause: dmFkZTFNxfXhMPKFpOz22Ce9JUYucSnZbdiuXhT5wgxQPyTy6pF1Bq75MVfHzyMqIKpcNd
    5fYUw/Qm72zioqJ/wDF2QboS11Osh/Jqs8mtrril+DENWuUxXMim4Zo0eVo8enuRNJMneM
    bs569ODJEJi9FSPnOEzoGLx93NtXS3JvsFEz1ueRU8ek3mp3GXbCqK+FZ0/fy+52ogyINr
    6DOP0kYtXg3LVsYVolpMCSxK4hC6jWBVt2+pdFeHShwS/YB9dukXmkGX+Ycsp2ydjYHH/+
    weTQhs7t7uIu7Aq5kVeHdqzvD3F+z5PTIuSnBOlC+dv6Rzx8EOc10HfwuO+uKhC+0H7+RW
    eECRM3prpkbM5kD8LtTbUVq3vQB0dHKUNtQLiIj14hVvF3in1AlhCY/yKSxbFoOxyF2T6Y
    y6FAvP2VblIvKOK8HTcFbTh3mAw7SVUF22DgHxSQXMCd8UsktTxiB1rVX6YiN3zxk8A+yx
    fD4NAbAvRGbKV0OCr3TuVYX3bzHAxyy5aShD+/MaIu/znVBsCdK5F5mFamnlZhHgXHLZlP
    AeEpNTSIR//PWEkx3MJnc1Sb3NQF3nKTiiRW5abWNhnF4rycP24Lt6Hr/3IWduCp9EEqpz
    BiD/rZrK5459kOVeahgdtoyE9TtWevSUer5uKQYwL4zUQGr4kyfme0BOCDgw
X-ME-Proxy: <xmx:AyruaskLP5tzbm_H-XIx7Y1gMqR02p8T2FW_WhXt91_nVGQjmTC9ng>
    <xmx:AyruaisWHFTobHeRK6HKh7C557pQ07fWSiCHs68lgkA8qHSTWnQ6Qg>
    <xmx:AyruanmTFdAvjMCvUmONM27cTVckn4h9xoWnPUGDZhwMOe2wKSbagA>
    <xmx:AyrualuKDUt27us_Tt9j_Uu5w1IxrL4cYWCA_Kn5BeZ2qfPa1tzXKQ>
    <xmx:Ayruajfl-ixXyNBJECsn0fdkNNTo6zJ5Wx3tmsNuvFVQrHxHKPeE2LjQ>
Feedback-ID: i083147f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 6 Nov 2026 14:26:58 -0500 (EST)
Date: Fri, 6 Nov 2026 11:27:13 -0800
From: Boris Burkov <boris@bur.io>
To: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Cc: linux-btrfs@vger.kernel.org, Naohiro Aota <naohiro.aota@wdc.com>
Subject: Re: [PATCH v6 02/25] btrfs: zoned: don't activate conventional zones
 of mixed block groups
Message-ID: <20261106192713.GB401465@zen.localdomain>
References: <20261028182111.160492-1-johannes.thumshirn@wdc.com>
 <20261028182111.160492-3-johannes.thumshirn@wdc.com>
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261028182111.160492-3-johannes.thumshirn@wdc.com>

On Wed, Oct 28, 2026 at 07:20:48PM +0100, Johannes Thumshirn wrote:
> Conventional zones never consume an active zone resource, but they are
> accounted as such: btrfs_zone_activate(), call_zone_finish() and
> btrfs_check_active_zone_reservation() take and return active zones and
> reservations for every stripe, and the DUP/RAID1 loaders activate a mixed

In this context does "mixed" mean a raid profile where some stripes are
on a sequential device and some are on a conventional device? I was sort
of confused for a while wondering about the old meaning of mixed of
METADATA & DATA and didn't really see how it applied here.

I feel like some differentiating nomenclature here would be helful.
zone-mixed perhaps?

> block group on an activeness mismatch between a conventional and an
> active sequential stripe.
> 
> Skip conventional stripes in all of these, and let the conventional zones
> of a mixed block group be active if any of its sequential zones is.

This sentence is also really confusing to me. It sounds like it all says:
1. DUP/raid1 loaders activate all the stripes
2. skip activating conventional stripes
3. let conventional zones be active if any sequential zone is

2 and 3 feel contradictory? Sorry if I am being dense..

I tried to double check my assumptions in the code but I think being a
bit more clear on the exact invariants would make this easier to
understand.

Is it something like:
we mark the active bit for conventional stripes if any sequential stripe
exists, but skip the actual activation operations?

> 
> A fully conventional data block group stays on zone_active_bgs but frees
> no active zone when finished, so btrfs_zone_finish_one_bg() must not pick
> it, otherwise the caller allocates a chunk that can't be activated.
> 
> Fixes: 265f7237dd25 ("btrfs: zoned: allow DUP on meta-data block groups")
> Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
> ---
>  fs/btrfs/tests/zoned-tests.c |  16 +++++
>  fs/btrfs/zoned.c             | 125 ++++++++++++++++++++---------------
>  2 files changed, 86 insertions(+), 55 deletions(-)
> 
> diff --git a/fs/btrfs/tests/zoned-tests.c b/fs/btrfs/tests/zoned-tests.c
> index 2bc3b14baa41..e11d6d01f505 100644
> --- a/fs/btrfs/tests/zoned-tests.c
> +++ b/fs/btrfs/tests/zoned-tests.c
> @@ -44,6 +44,7 @@ static int test_load_zone_info(struct btrfs_fs_info *fs_info,
>  	struct btrfs_chunk_map *map __free(btrfs_free_chunk_map) = NULL;
>  	struct zone_info AUTO_KFREE(zone_info);
>  	unsigned long AUTO_KFREE(active);
> +	unsigned int nr_active, nr_missing = 0;
>  	int ret;
>  
>  	bg = btrfs_alloc_dummy_block_group(fs_info, test->bg_length);
> @@ -80,7 +81,10 @@ static int test_load_zone_info(struct btrfs_fs_info *fs_info,
>  		zone_info[i].capacity = ZONE_SIZE;
>  		if (zone_info[i].alloc_offset && zone_info[i].alloc_offset < ZONE_SIZE)
>  			__set_bit(i, active);
> +		if (zone_info[i].alloc_offset == WP_MISSING_DEV)
> +			nr_missing++;
>  	}
> +	nr_active = bitmap_weight(active, test->num_stripes);
>  	if (test->degraded)
>  		btrfs_set_opt(fs_info->mount_opt, DEGRADED);
>  	else
> @@ -101,6 +105,18 @@ static int test_load_zone_info(struct btrfs_fs_info *fs_info,
>  		return -EINVAL;
>  	}
>  
> +	if ((ret || nr_active + nr_missing != test->num_stripes) &&
> +	    test_bit(BLOCK_GROUP_FLAG_ZONE_IS_ACTIVE, &bg->runtime_flags)) {
> +		test_err("block group marked active before all stripes were checked");
> +		return -EINVAL;
> +	}
> +
> +	if (!ret && nr_active && nr_active + nr_missing == test->num_stripes &&
> +	    !test_bit(BLOCK_GROUP_FLAG_ZONE_IS_ACTIVE, &bg->runtime_flags)) {
> +		test_err("block group with all present stripes active not marked active");
> +		return -EINVAL;
> +	}
> +
>  	return 0;
>  }
>  
> diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
> index b003f0bc778b..c3bbe22c8850 100644
> --- a/fs/btrfs/zoned.c
> +++ b/fs/btrfs/zoned.c
> @@ -1428,8 +1428,7 @@ static int btrfs_load_zone_info(struct btrfs_fs_info *fs_info, int zone_idx,
>  }
>  
>  static int btrfs_load_block_group_single(struct btrfs_block_group *bg,
> -					 struct zone_info *info,
> -					 unsigned long *active)
> +					 struct zone_info *info)
>  {
>  	if (unlikely(info->alloc_offset == WP_MISSING_DEV)) {
>  		btrfs_err(bg->fs_info,
> @@ -1440,15 +1439,12 @@ static int btrfs_load_block_group_single(struct btrfs_block_group *bg,
>  
>  	bg->alloc_offset = info->alloc_offset;
>  	bg->zone_capacity = info->capacity;
> -	if (test_bit(0, active))
> -		set_bit(BLOCK_GROUP_FLAG_ZONE_IS_ACTIVE, &bg->runtime_flags);
>  	return 0;
>  }
>  
>  static int btrfs_load_block_group_dup(struct btrfs_block_group *bg,
>  				      struct btrfs_chunk_map *map,
>  				      struct zone_info *zone_info,
> -				      unsigned long *active,
>  				      u64 last_alloc)
>  {
>  	struct btrfs_fs_info *fs_info = bg->fs_info;
> @@ -1499,13 +1495,6 @@ static int btrfs_load_block_group_dup(struct btrfs_block_group *bg,
>  		return -EIO;
>  	}
>  
> -	if (test_bit(0, active) != test_bit(1, active)) {
> -		if (unlikely(!btrfs_zone_activate(bg)))
> -			return -EIO;
> -	} else if (test_bit(0, active)) {
> -		set_bit(BLOCK_GROUP_FLAG_ZONE_IS_ACTIVE, &bg->runtime_flags);
> -	}
> -
>  	bg->alloc_offset = zone_info[0].alloc_offset;
>  	return 0;
>  }
> @@ -1513,7 +1502,6 @@ static int btrfs_load_block_group_dup(struct btrfs_block_group *bg,
>  static int btrfs_load_block_group_raid1(struct btrfs_block_group *bg,
>  					struct btrfs_chunk_map *map,
>  					struct zone_info *zone_info,
> -					unsigned long *active,
>  					u64 last_alloc)
>  {
>  	struct btrfs_fs_info *fs_info = bg->fs_info;
> @@ -1557,15 +1545,6 @@ static int btrfs_load_block_group_raid1(struct btrfs_block_group *bg,
>  				  btrfs_bg_type_to_raid_name(map->type));
>  			return -EIO;
>  		}
> -		if (test_bit(0, active) != test_bit(i, active)) {
> -			if (unlikely(!btrfs_test_opt(fs_info, DEGRADED) &&
> -				     !btrfs_zone_activate(bg))) {
> -				return -EIO;
> -			}
> -		} else {
> -			if (test_bit(0, active))
> -				set_bit(BLOCK_GROUP_FLAG_ZONE_IS_ACTIVE, &bg->runtime_flags);
> -		}
>  	}
>  
>  	if (zone_info[0].alloc_offset != WP_MISSING_DEV)
> @@ -1579,7 +1558,6 @@ static int btrfs_load_block_group_raid1(struct btrfs_block_group *bg,
>  static int btrfs_load_block_group_raid0(struct btrfs_block_group *bg,
>  					struct btrfs_chunk_map *map,
>  					struct zone_info *zone_info,
> -					unsigned long *active,
>  					u64 last_alloc)
>  {
>  	struct btrfs_fs_info *fs_info = bg->fs_info;
> @@ -1671,13 +1649,6 @@ static int btrfs_load_block_group_raid0(struct btrfs_block_group *bg,
>  		if (!IS_ALIGNED(zone_info[i].alloc_offset, stripe_len))
>  			has_partial = true;
>  
> -		if (test_bit(0, active) != test_bit(i, active)) {
> -			if (unlikely(!btrfs_zone_activate(bg)))
> -				return -EIO;
> -		} else {
> -			if (test_bit(0, active))
> -				set_bit(BLOCK_GROUP_FLAG_ZONE_IS_ACTIVE, &bg->runtime_flags);
> -		}
>  		bg->zone_capacity += zone_info[i].capacity;
>  		bg->alloc_offset += zone_info[i].alloc_offset;
>  	}
> @@ -1701,7 +1672,6 @@ static int btrfs_load_block_group_raid0(struct btrfs_block_group *bg,
>  static int btrfs_load_block_group_raid10(struct btrfs_block_group *bg,
>  					 struct btrfs_chunk_map *map,
>  					 struct zone_info *zone_info,
> -					 unsigned long *active,
>  					 u64 last_alloc)
>  {
>  	struct btrfs_fs_info *fs_info = bg->fs_info;
> @@ -1823,13 +1793,6 @@ static int btrfs_load_block_group_raid10(struct btrfs_block_group *bg,
>  		    zone_info[i].alloc_offset == WP_CONVENTIONAL)
>  			zone_info[i].alloc_offset = raid0_allocs[idx];
>  
> -		if (test_bit(0, active) != test_bit(i, active)) {
> -			if (unlikely(!btrfs_zone_activate(bg)))
> -				return -EIO;
> -		} else if (test_bit(0, active)) {
> -			set_bit(BLOCK_GROUP_FLAG_ZONE_IS_ACTIVE, &bg->runtime_flags);
> -		}
> -
>  		if ((i % map->sub_stripes) == 0) {
>  			bg->zone_capacity += zone_info[i].capacity;
>  			bg->alloc_offset += zone_info[i].alloc_offset;
> @@ -1860,27 +1823,35 @@ int btrfs_load_block_group_by_raid_type(struct btrfs_block_group *bg,
>  					unsigned long *active, u64 last_alloc)
>  {
>  	struct btrfs_fs_info *fs_info = bg->fs_info;
> +	const unsigned int nr_active = bitmap_weight(active, map->num_stripes);
> +	unsigned int nr_missing = 0;
>  	u64 profile;
>  	int ret;
>  
> +	/* Missing stripes are never active, ignore them when activating. */
> +	for (int i = 0; i < map->num_stripes; i++) {
> +		if (zone_info[i].alloc_offset == WP_MISSING_DEV)
> +			nr_missing++;
> +	}
> +
>  	profile = map->type & BTRFS_BLOCK_GROUP_PROFILE_MASK;
>  	switch (profile) {
>  	case 0: /* single */
> -		ret = btrfs_load_block_group_single(bg, &zone_info[0], active);
> +		ret = btrfs_load_block_group_single(bg, &zone_info[0]);
>  		break;
>  	case BTRFS_BLOCK_GROUP_DUP:
> -		ret = btrfs_load_block_group_dup(bg, map, zone_info, active, last_alloc);
> +		ret = btrfs_load_block_group_dup(bg, map, zone_info, last_alloc);
>  		break;
>  	case BTRFS_BLOCK_GROUP_RAID1:
>  	case BTRFS_BLOCK_GROUP_RAID1C3:
>  	case BTRFS_BLOCK_GROUP_RAID1C4:
> -		ret = btrfs_load_block_group_raid1(bg, map, zone_info, active, last_alloc);
> +		ret = btrfs_load_block_group_raid1(bg, map, zone_info, last_alloc);
>  		break;
>  	case BTRFS_BLOCK_GROUP_RAID0:
> -		ret = btrfs_load_block_group_raid0(bg, map, zone_info, active, last_alloc);
> +		ret = btrfs_load_block_group_raid0(bg, map, zone_info, last_alloc);
>  		break;
>  	case BTRFS_BLOCK_GROUP_RAID10:
> -		ret = btrfs_load_block_group_raid10(bg, map, zone_info, active, last_alloc);
> +		ret = btrfs_load_block_group_raid10(bg, map, zone_info, last_alloc);
>  		break;
>  	case BTRFS_BLOCK_GROUP_RAID5:
>  	case BTRFS_BLOCK_GROUP_RAID6:
> @@ -1890,6 +1861,16 @@ int btrfs_load_block_group_by_raid_type(struct btrfs_block_group *bg,
>  		return -EINVAL;
>  	}
>  
> +	if (!ret && nr_active) {
> +		if (nr_active + nr_missing == map->num_stripes) {
> +			set_bit(BLOCK_GROUP_FLAG_ZONE_IS_ACTIVE, &bg->runtime_flags);
> +		} else if (bg->alloc_offset < bg->zone_capacity) {
> +			bg->meta_write_pointer = bg->start;
> +			if (!btrfs_zone_activate(bg))
> +				ret = -EIO;
> +		}
> +	}
> +
>  	if (ret == -EIO && profile != 0 && profile != BTRFS_BLOCK_GROUP_RAID0 &&
>  	    profile != BTRFS_BLOCK_GROUP_RAID10) {
>  		/*
> @@ -1965,6 +1946,23 @@ int btrfs_load_block_group_zone_info(struct btrfs_block_group *cache, bool new)
>  	if (num_sequential > 0)
>  		set_bit(BLOCK_GROUP_FLAG_SEQUENTIAL_ZONE, &cache->runtime_flags);
>  
> +	if (num_conventional > 0 && num_sequential > 0) {
> +		bool any_active = false;
> +
> +		for (i = 0; i < map->num_stripes; i++) {
> +			if (zone_info[i].alloc_offset != WP_CONVENTIONAL &&
> +			    test_bit(i, active)) {
> +				any_active = true;
> +				break;
> +			}
> +		}
> +
> +		for (i = 0; i < map->num_stripes; i++) {
> +			if (zone_info[i].alloc_offset == WP_CONVENTIONAL)
> +				assign_bit(i, active, any_active);
> +		}

This is the code that says activate the conventional stripes for a mixed
block group? 3. from my comment above?

> +	}
> +
>  	if (num_conventional > 0) {
>  		ret = calculate_alloc_pointer(cache, &last_alloc, new);
>  		if (ret) {
> @@ -2008,6 +2006,13 @@ int btrfs_load_block_group_zone_info(struct btrfs_block_group *cache, bool new)
>  		ret = -EIO;
>  	}
>  
> +	if (!ret && num_conventional && num_sequential &&
> +	    cache->alloc_offset > 0 && cache->alloc_offset < cache->zone_capacity) {
> +		cache->meta_write_pointer = cache->start;
> +		if (!btrfs_zone_activate(cache))
> +			ret = -EIO;
> +	}
> +
>  	if (!ret) {
>  		cache->meta_write_pointer = cache->alloc_offset + cache->start;
>  		if (test_bit(BLOCK_GROUP_FLAG_ZONE_IS_ACTIVE, &cache->runtime_flags)) {
> @@ -2457,6 +2462,9 @@ bool btrfs_zone_activate(struct btrfs_block_group *block_group)
>  		if (!device->bdev)
>  			continue;
>  
> +		if (!btrfs_dev_is_sequential(device, physical))
> +			continue;
> +

And then this says skip activating the sequential device stripes? 2.
from my comment?

>  		if (zinfo->max_active_zones == 0)
>  			continue;
>  
> @@ -2533,6 +2541,7 @@ static int call_zone_finish(struct btrfs_block_group *block_group,
>  	const u64 physical = stripe->physical;
>  	struct btrfs_zoned_device_info *zinfo = device->zone_info;
>  	bool cleared;
> +	unsigned int nofs_flags;
>  	int ret;
>  
>  	if (!device->bdev)
> @@ -2541,18 +2550,17 @@ static int call_zone_finish(struct btrfs_block_group *block_group,
>  	if (zinfo->max_active_zones == 0)
>  		return 0;
>  
> -	if (btrfs_dev_is_sequential(device, physical)) {
> -		unsigned int nofs_flags;
> +	if (!btrfs_dev_is_sequential(device, physical))
> +		return 0;
>  
> -		nofs_flags = memalloc_nofs_save();
> -		ret = blkdev_zone_mgmt(device->bdev, REQ_OP_ZONE_FINISH,
> -				       physical >> SECTOR_SHIFT,
> -				       zinfo->zone_size >> SECTOR_SHIFT);
> -		memalloc_nofs_restore(nofs_flags);
> +	nofs_flags = memalloc_nofs_save();
> +	ret = blkdev_zone_mgmt(device->bdev, REQ_OP_ZONE_FINISH,
> +			       physical >> SECTOR_SHIFT,
> +			       zinfo->zone_size >> SECTOR_SHIFT);
> +	memalloc_nofs_restore(nofs_flags);
>  
> -		if (ret)
> -			return ret;
> -	}
> +	if (ret)
> +		return ret;
>  
>  	spin_lock(&fs_info->zone_active_bgs_lock);
>  	cleared = btrfs_dev_clear_active_zone(device, physical);
> @@ -2991,6 +2999,7 @@ int btrfs_zone_finish_one_bg(struct btrfs_fs_info *fs_info)
>  		spin_lock(&block_group->lock);
>  		if (block_group->reserved || block_group->alloc_offset == 0 ||
>  		    !(block_group->flags & BTRFS_BLOCK_GROUP_DATA) ||
> +		    !test_bit(BLOCK_GROUP_FLAG_SEQUENTIAL_ZONE, &block_group->runtime_flags) ||
>  		    test_bit(BLOCK_GROUP_FLAG_ZONED_DATA_RELOC, &block_group->runtime_flags)) {
>  			spin_unlock(&block_group->lock);
>  			continue;
> @@ -3113,8 +3122,14 @@ void btrfs_check_active_zone_reservation(struct btrfs_fs_info *fs_info)
>  		      (BTRFS_BLOCK_GROUP_METADATA | BTRFS_BLOCK_GROUP_SYSTEM)))
>  			continue;
>  
> -		for (int i = 0; i < map->num_stripes; i++)
> -			map->stripes[i].dev->zone_info->reserved_active_zones--;
> +		for (int i = 0; i < map->num_stripes; i++) {
> +			struct btrfs_device *dev = map->stripes[i].dev;
> +			struct btrfs_zoned_device_info *zone_info = dev->zone_info;
> +			u64 physical = map->stripes[i].physical;
> +
> +			if (btrfs_dev_is_sequential(dev, physical))
> +				zone_info->reserved_active_zones--;
> +		}
>  	}
>  	spin_unlock(&fs_info->zone_active_bgs_lock);
>  }
> -- 
> 2.56.0
> 
