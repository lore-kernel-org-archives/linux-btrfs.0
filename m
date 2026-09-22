Received: from mail-ed2-f12.google.com (mail-ed2-f12.google.com [74.125.228.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0C253B993A
	for <linux-btrfs@vger.kernel.org>; Tue, 22 Sep 2026 21:42:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.228.76
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790113333; cv=none; b=iPPTTRb2cWEhtgUmkqhpk4Po+txSRb51zDu3Kr4dbSe5hd3CZ4+pJvmbc3Omu1Qv9oRmAVy5QZfDnhiRwyvmu2ITlnEnzOg5/mV9aCMHirF4fIg+Vc+14T+gsZCFyLSct7OMaTFbeBKTCHsQbpkgJmd0jpCKEN9o/TM+npPwFOY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790113333; c=relaxed/simple;
	bh=E4e/0l6ww3kaqKTSUA7eMk1T3v0WgyST+Z0B+V4MaAw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=R9w/ALK8JQqhKGbMlPMXfoUD5hT+F8AuJ2zJ9h2giOkihzP9EWxMWmi8UpQKLmvThZQ5XOiY+6DF5xo6ylpkFIznPFrlts2ynv1qF1aarjZF10TtNIV+CXeZOkAK3UzT7i5r6Ufv3Rb796Pn/EV6fOBHb3XJR/PN2JTeQnyHX8Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=DWtKK7gC; arc=none smtp.client-ip=74.125.228.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="DWtKK7gC"
Received: by mail-ed2-f12.google.com with SMTP id 4fb4d7f45d1cf-6a996c8adf3so509775a12.1
        for <linux-btrfs@vger.kernel.org>; Tue, 22 Sep 2026 14:42:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1790113325; x=1790718125; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Ncw718y1rpwyDj9plZkPSHG1SUsu7gw1A4yYRsaqCUk=;
        b=DWtKK7gCV8jJ7+DFzJJac2QUB6jGIViPvKJ9bRlKINoEe1CIFT3OtfOCcHkqOHgL93
         lqKlO1J8ME8V3zcJEHcVyZ1owIi2yTm3e7FAnruHktUwl4uIzc+5r4bD/rF4DYvOxGEp
         7IuqTHk3FN8xwmPCGK+QGSo//h8EbCaY/jDDevdY0ZQZQl3GJbAgh1eKqI5OyL5T2Kkn
         G9fvEx21X/uKUIcdwNtsfzFtANxhnBm/mTRP0r5atbsb7YZnJGH0K0uOLe0aYmtcrwVa
         exfB3hjzpIqU++9NOAh80n8x6ZGamg7gWQLzjyRbzE57vTs2A2eGs/D9suDMj9ShzbeT
         w77Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790113325; x=1790718125;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Ncw718y1rpwyDj9plZkPSHG1SUsu7gw1A4yYRsaqCUk=;
        b=dZU1Xpmb3MdflJbWKSuqszEu/YuqVpEbJSovP4SJyaDK3IroKVhG0p3MxOAO2tMPkl
         C7wwmfo1jOyfzM+ncxArvIofa497vVmJ1oecYu7d4JoPlDwyZEIz/Tyqy5dmoA491rBb
         UiKDSRcwxhVu5tP0+wsACw0b9wLYstdpkfVeRmVuz6i8JGHGNZwGYI9mWNUi9LDrZ5U/
         QWBDVOdPqAr584V10a+HR0f+ktIyTZeOK6vrmhqhL0TeLt8X1yIR4afsjBv8Q4zfwwUg
         e6+kpO2DUMFMuvyVLuJuMdjGs7o3F9kTgpy7v1pyFZOUHLflPasTkcmp4i6OlaoRvo2k
         0Dtg==
X-Forwarded-Encrypted: i=1; AKwUvBxDWPOnm9GhqjrMiNbGACN8Ob/YC+jZctc9xbxAm2qBaFHbBJgZYrv86pakXEQ6PEZCEdcXr4HpxX7rTw==@vger.kernel.org
X-Gm-Message-State: AFuF++kYM0/5z5VB69to6pg9EEa/Jf77Y/fZBWpWYfyU5lnCzYAE6CSO
	6JWjovDV/LLQnFJmd75bIA9VVoAoE2VWEwhI8O2NaREZi99x3Gvxq4kZjx3y0JBQ+/4=
X-Gm-Gg: AYBFou1Q4uPb3wYlMkS/j0rnfefN71uHSdqZhiBnxchBv/wGsKKMYj8w6dq/ZJd9v8H
	Bwo1nRJnw0q0vvdeSVW1alOurxl9cYzRlkg5L2/PFbmfyGDP6SkHSqeHgSCZWVsXdin4xaIzORn
	OhvKGhED5SkXnXs5K98mvGqwvDKREp7x2JfSWdoW5qXGyqqbU851hqoTeZgLOw/DgyKRTbtX35j
	wNTfloigDUKgxzwQPCiOJcH4YLbZZE/S0x5EHp9m5zN2lG9pORxEbrcG2YXPQ4rawvAygTQHB5R
	bsdZlFSvBlO/rHg0KRubdXAps6V8W1BqFmmhO73AZkHnyRXkmjEND3ttwcriq9Dppk91Bak38mb
	VqHLR5u8b4RSAmWd1DTvJwP6tQD0qC/HQdLECsO9+FSdn5d+n8WP6Jm29WTopFrw4V15VbhE/kL
	TWIW6MOzsDf2qbHp4FwYDcrjP1ZLkXXSDy6qvJQyLYsQxuSWSp0EP/+fTnxqHZ6t4=
X-Received: by 2002:a05:6402:320d:b0:6aa:ad13:40bc with SMTP id 4fb4d7f45d1cf-6aab3bb8b64mr556974a12.37.1790113325320;
        Tue, 22 Sep 2026 14:42:05 -0700 (PDT)
Received: from [172.16.0.229] ([159.196.52.54])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-87d1cfc09fasm323504b3a.9.2026.09.22.14.42.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Sep 2026 14:42:04 -0700 (PDT)
Message-ID: <4dc8189d-62f2-4aee-a732-ee9bca3f0328@suse.com>
Date: Wed, 23 Sep 2026 07:11:59 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1] btrfs: add LOGICAL_INO_V2 flag for avoiding the tree
 modification log
To: Joanne Koong <joannelkoong@gmail.com>, dsterba@suse.com
Cc: boris@bur.io, loemra.dev@gmail.com, fdmanana@suse.com,
 linux-btrfs@vger.kernel.org
References: <20260922201258.874070-1-joannelkoong@gmail.com>
Content-Language: en-US
From: Qu Wenruo <wqu@suse.com>
Autocrypt: addr=wqu@suse.com; keydata=
 xsBNBFnVga8BCACyhFP3ExcTIuB73jDIBA/vSoYcTyysFQzPvez64TUSCv1SgXEByR7fju3o
 8RfaWuHCnkkea5luuTZMqfgTXrun2dqNVYDNOV6RIVrc4YuG20yhC1epnV55fJCThqij0MRL
 1NxPKXIlEdHvN0Kov3CtWA+R1iNN0RCeVun7rmOrrjBK573aWC5sgP7YsBOLK79H3tmUtz6b
 9Imuj0ZyEsa76Xg9PX9Hn2myKj1hfWGS+5og9Va4hrwQC8ipjXik6NKR5GDV+hOZkktU81G5
 gkQtGB9jOAYRs86QG/b7PtIlbd3+pppT0gaS+wvwMs8cuNG+Pu6KO1oC4jgdseFLu7NpABEB
 AAHNGFF1IFdlbnJ1byA8d3F1QHN1c2UuY29tPsLAlAQTAQgAPgIbAwULCQgHAgYVCAkKCwIE
 FgIDAQIeAQIXgBYhBC3fcuWlpVuonapC4cI9kfOhJf6oBQJqqw0NBQkUl/JeAAoJEMI9kfOh
 Jf6o/xYH/3AaWnGSq58XnY/T3/YYjr6g+TUZxa7MPyiYTELNpNlvmNlbtbAL0nW0LNvkeiqf
 SmYA+xkwY4RbxnZYQK0H5iv2w1eqa9qqFZb4bIBRmTapu26GEEkpad0W0ZhoSPMO8bV2Bwkf
 YdtPZQLaeUKvHZqNqBKnmtRLQj2Cgy3kuXX3bEGvWjzUOxPUSCj/S++JWBewMdMBPT62vZM0
 3156gfn5mHA94s2p+NFJoWkERY+JPTMu9NISkpD7yuGhXN88qd/aqD0RrlhxvKsrQogdPwn9
 vP18FGG3CRlHtOvOLVoY5NKSOWTDc+o+8t2XEETFTGbKYTcqeTzi4SxhvBLtTinOwE0EWdWB
 rwEIAKpT62HgSzL9zwGe+WIUCMB+nOEjXAfvoUPUwk+YCEDcOdfkkM5FyBoJs8TCEuPXGXBO
 Cl5P5B8OYYnkHkGWutAVlUTV8KESOIm/KJIA7jJA+Ss9VhMjtePfgWexw+P8itFRSRrrwyUf
 E+0WcAevblUi45LjWWZgpg3A80tHP0iToOZ5MbdYk7YFBE29cDSleskfV80ZKxFv6koQocq0
 vXzTfHvXNDELAuH7Ms/WJcdUzmPyBf3Oq6mKBBH8J6XZc9LjjNZwNbyvsHSrV5bgmu/THX2n
 g/3be+iqf6OggCiy3I1NSMJ5KtR0q2H2Nx2Vqb1fYPOID8McMV9Ll6rh8S8AEQEAAcLAfAQY
 AQgAJgIbDBYhBC3fcuWlpVuonapC4cI9kfOhJf6oBQJnEXWBBQkQ/lrSAAoJEMI9kfOhJf6o
 cakH+QHwDszsoYvmrNq36MFGgvAHRjdlrHRBa4A1V1kzd4kOUokongcrOOgHY9yfglcvZqlJ
 qfa4l+1oxs1BvCi29psteQTtw+memmcGruKi+YHD7793zNCMtAtYidDmQ2pWaLfqSaryjlzR
 /3tBWMyvIeWZKURnZbBzWRREB7iWxEbZ014B3gICqZPDRwwitHpH8Om3eZr7ygZck6bBa4MU
 o1XgbZcspyCGqu1xF/bMAY2iCDcq6ULKQceuKkbeQ8qxvt9hVxJC2W3lHq8dlK1pkHPDg9wO
 JoAXek8MF37R8gpLoGWl41FIUb3hFiu3zhDDvslYM4BmzI18QgQTQnotJH8=
In-Reply-To: <20260922201258.874070-1-joannelkoong@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/9/23 05:42, Joanne Koong 写道:
> At Meta, we use the LOGICAL_INO_V2 ioctl to estimate sharing-aware space
> usage. We sample the logical address space and resolve each sample back
> to the inodes which reference it. The measurement is statistical, so
> with enough samples it gives good bounds on real usage.
> 
> Currently in the LOGICAL_INO_V2 ioctl path, iterate_extent_inodes()
> (which can walk backrefs either against the current trees or against the
> commit roots) acquires a tree modification log sequence number when
> walking the current trees, since those trees are being modified while
> the walk is in progress. The log is then enabled filesystem wide for as
> long as any such walk is running, and is only disabled again once the
> last walk has finished.
> 
> While it is enabled the cost impacts the whole filesystem, not only the
> caller. Modifications of interior nodes of the extent tree and of
> subvolume trees have to be recorded, serialized on a single filesystem
> wide lock. Delayed refs with a sequence number at or above the oldest
> active one can not be run (the run path bails out with -EAGAIN in
> btrfs_run_delayed_refs_for_head()), and metadata refs above it can not
> be merged, so they accumulate and that work is deferred to transaction
> commit.
> 
> Currently, userspace has no way to ask for anything cheaper. Whenever a
> transaction is running, the walk uses the tree modification log, even if
> the caller would tolerate results that could be up to one commit interval
> stale.
> 
> Give userspace this option by adding BTRFS_LOGICAL_INO_ARGS_COMMIT_ROOT,
> which makes the backref walk use the commit roots and therefore never
> enables the tree modification log. Behavior is unchanged unless the flag
> gets explicitly passed by userspace. iterate_extent_inodes() already
> takes a search_commit_root argument for this, which scrub, send and the
> data relocation warning path all pass as true. The flag simply plumbs it
> through to userspace.
> 
> Assisted-by: LLM
> Signed-off-by: Joanne Koong <joannelkoong@gmail.com>

The idea looks good to me.

Reviewed-by: Qu Wenruo <wqu@suse.com>

Thanks,
Qu

> ---
>   fs/btrfs/backref.c         |  6 ++++--
>   fs/btrfs/backref.h         |  3 ++-
>   fs/btrfs/ioctl.c           |  9 +++++++--
>   include/uapi/linux/btrfs.h | 10 ++++++++++
>   4 files changed, 23 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/btrfs/backref.c b/fs/btrfs/backref.c
> index 1be632c742bd..364ec3ad7d8a 100644
> --- a/fs/btrfs/backref.c
> +++ b/fs/btrfs/backref.c
> @@ -2549,7 +2549,8 @@ static int build_ino_list(u64 inum, u64 offset, u64 num_bytes, u64 root, void *c
>   }
>   
>   int iterate_inodes_from_logical(u64 logical, struct btrfs_fs_info *fs_info,
> -				void *ctx, bool ignore_offset)
> +				void *ctx, bool ignore_offset,
> +				bool search_commit_root)
>   {
>   	struct btrfs_backref_walk_ctx walk_ctx = { 0 };
>   	int ret;
> @@ -2575,7 +2576,8 @@ int iterate_inodes_from_logical(u64 logical, struct btrfs_fs_info *fs_info,
>   		walk_ctx.extent_item_pos = logical - found_key.objectid;
>   	walk_ctx.fs_info = fs_info;
>   
> -	return iterate_extent_inodes(&walk_ctx, false, build_ino_list, ctx);
> +	return iterate_extent_inodes(&walk_ctx, search_commit_root,
> +				     build_ino_list, ctx);
>   }
>   
>   static int inode_to_path(u64 inum, u32 name_len, unsigned long name_off,
> diff --git a/fs/btrfs/backref.h b/fs/btrfs/backref.h
> index 179791de6b19..f8dc8a3723cf 100644
> --- a/fs/btrfs/backref.h
> +++ b/fs/btrfs/backref.h
> @@ -226,7 +226,8 @@ int iterate_extent_inodes(struct btrfs_backref_walk_ctx *ctx,
>   			  iterate_extent_inodes_t *iterate, void *user_ctx);
>   
>   int iterate_inodes_from_logical(u64 logical, struct btrfs_fs_info *fs_info,
> -				void *ctx, bool ignore_offset);
> +				void *ctx, bool ignore_offset,
> +				bool search_commit_root);
>   
>   int paths_from_inode(u64 inum, struct inode_fs_paths *ipath);
>   
> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> index 52aab510aea0..63257f8fb897 100644
> --- a/fs/btrfs/ioctl.c
> +++ b/fs/btrfs/ioctl.c
> @@ -3286,6 +3286,7 @@ static long btrfs_ioctl_logical_to_ino(struct btrfs_fs_info *fs_info,
>   	struct btrfs_ioctl_logical_ino_args AUTO_KFREE(loi);
>   	struct btrfs_data_container AUTO_KVFREE(inodes);
>   	bool ignore_offset;
> +	bool search_commit_root;
>   
>   	if (!capable(CAP_SYS_ADMIN))
>   		return -EPERM;
> @@ -3296,6 +3297,7 @@ static long btrfs_ioctl_logical_to_ino(struct btrfs_fs_info *fs_info,
>   
>   	if (version == 1) {
>   		ignore_offset = false;
> +		search_commit_root = false;
>   		size = min_t(u32, loi->size, SZ_64K);
>   	} else {
>   		/* All reserved bits must be 0 for now */
> @@ -3303,10 +3305,12 @@ static long btrfs_ioctl_logical_to_ino(struct btrfs_fs_info *fs_info,
>   			return -EINVAL;
>   
>   		/* Only accept flags we have defined so far */
> -		if (loi->flags & ~(BTRFS_LOGICAL_INO_ARGS_IGNORE_OFFSET))
> +		if (loi->flags & ~(BTRFS_LOGICAL_INO_ARGS_IGNORE_OFFSET |
> +				   BTRFS_LOGICAL_INO_ARGS_COMMIT_ROOT))
>   			return -EINVAL;
>   
>   		ignore_offset = loi->flags & BTRFS_LOGICAL_INO_ARGS_IGNORE_OFFSET;
> +		search_commit_root = loi->flags & BTRFS_LOGICAL_INO_ARGS_COMMIT_ROOT;
>   		size = min_t(u32, loi->size, SZ_16M);
>   	}
>   
> @@ -3314,7 +3318,8 @@ static long btrfs_ioctl_logical_to_ino(struct btrfs_fs_info *fs_info,
>   	if (IS_ERR(inodes))
>   		return PTR_ERR(inodes);
>   
> -	ret = iterate_inodes_from_logical(loi->logical, fs_info, inodes, ignore_offset);
> +	ret = iterate_inodes_from_logical(loi->logical, fs_info, inodes,
> +					  ignore_offset, search_commit_root);
>   	if (ret == -EINVAL)
>   		return -ENOENT;
>   	if (ret < 0)
> diff --git a/include/uapi/linux/btrfs.h b/include/uapi/linux/btrfs.h
> index 0a13baf3d8d1..b6f196bfa600 100644
> --- a/include/uapi/linux/btrfs.h
> +++ b/include/uapi/linux/btrfs.h
> @@ -732,6 +732,16 @@ struct btrfs_ioctl_logical_ino_args {
>    */
>   #define BTRFS_LOGICAL_INO_ARGS_IGNORE_OFFSET	(1ULL << 0)
>   
> +/*
> + * Resolve backrefs against the commit roots instead of the current trees.
> + *
> + * Resolving against the current trees is more expensive for the filesystem as
> + * a whole, not only for the caller. Callers that do not need to observe the
> + * currently running transaction should set this. The result can be up to one
> + * commit interval stale.
> + */
> +#define BTRFS_LOGICAL_INO_ARGS_COMMIT_ROOT	(1ULL << 1)
> +
>   enum btrfs_dev_stat_values {
>   	/* disk I/O failure stats */
>   	BTRFS_DEV_STAT_WRITE_ERRS, /* EIO or EREMOTEIO from lower layers */

