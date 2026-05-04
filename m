Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB4003DE43C
	for <linux-btrfs@vger.kernel.org>; Mon,  4 May 2026 14:29:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777904943; cv=none; b=OEnMjkD1N4Dau1N9MydwC7qoh5fxAAFaGRoyRgvmKQbvJ62oZioQF5K/ZOETc+4FgV7mwhSlRtoxnULxXdO7PNxTvR8xp/0BdNBzeCBF4Va7Nj2hWNVkT1iQCVnheacruztJ/mdWPQPPC6XEcH9bi3YoLJRJzotSDS9lRVjdPfI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777904943; c=relaxed/simple;
	bh=izoKqoW/xzCwOLhWuzg5n1INwp4gkKwC27UaBFm2s/s=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:Cc:From:
	 In-Reply-To:Content-Type; b=BpmZQmwgEvHMtXGDj3vG18I4FN9/ZIRcqUSYbGeCnFLOlZ/uEJ69WjPC5t6SqmE/A5OR04Vzh3xD+Ot9l0e+uXQ6CVj6kF0TbVprEn4DfLhzayRvhfRQmsnW56HMNmzF+HqY2FvJ064VTg10gbvB20le5A7vLcWl/tu60zlSrn8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Wy+0Cma+; arc=none smtp.client-ip=209.85.216.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Wy+0Cma+"
Received: by mail-pj1-f52.google.com with SMTP id 98e67ed59e1d1-3650a628473so2354938a91.3
        for <linux-btrfs@vger.kernel.org>; Mon, 04 May 2026 07:29:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777904941; x=1778509741; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:cc:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=WLRUK5IgLxdU28fQt7i9GW56DtMcZW106jz4Q3IqsAY=;
        b=Wy+0Cma+YmWNkDunSKv5eIBZXaKzKMqX3biiVermpBk9rbJhWz9IXp/WVKq1lc3hCE
         aFWjkliRCfxbWc+tsrGELAkxrxC1mFKhNnHEzYsYO1dIqcFPP6HFlMphM227ua5vYCpG
         J7ewZgOEpvwEhW7WNbX5zVWnN6yMGoYQN1MbHoLlAfYRfR0b5X0PJqPgscmPbRBf+snW
         BvHDkTL2gcFVkflJOxhoM9oJEMmb5IvVYjOt/2mT5Srrz3OoIatWHsSPKkjsaFq+/QeS
         jfkDoedrZRaynJyahRDAGK5uQehPY2J2Ixr8fXBanQsboak6EIe9V9MoroYVdHTT3F0E
         yV8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777904941; x=1778509741;
        h=content-transfer-encoding:in-reply-to:from:cc:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=WLRUK5IgLxdU28fQt7i9GW56DtMcZW106jz4Q3IqsAY=;
        b=Wj/laRtV7H2WN8aIFLhPCNQ/WV/bNRA5jRhELRV1cHZnM/mn/y8GUbGal6wrjBfAv3
         pCSbFk/xsmeBmTydbeN5jRRpC9at7z7xrBE6YbuVxIEj4QHyCRVUWeByK4ujuzqmz5N5
         XU8P/Ak1pTL3EoddKxmye8uvzAluyWaeweeGrx0b2ytOzGWOOHGGmjTBsUQ4R4FzPeaG
         Mt/0UkQsaNGfJNJBnVzLKZB6h1ak4zMUVmbD6NbvGjsr0DDPnWQfLtKilhs3tKktKPIs
         q+EaIc+eCLtzDm5TNRv95VqgTB7WJCbGx+DZI7hhD/KSjy9UIde01wDn6BGSVfpraEf5
         qGIg==
X-Gm-Message-State: AOJu0Yz18dI14CdTT/y9Lv2Gluv4Zt/pfyE+etstF3PR8VPNuLe/ruXz
	iDarViqmZWoAXsLlFQA/sxez2vkfV7AEZyfaRBc6HDsKrYW8QVvmrUzQ0i7OLA==
X-Gm-Gg: AeBDiev3x9WKxGyNmrzDEOfhHgkMlrWQn75FXtctsBAmoFBxICUpCSNx2IgK6koNsUD
	Uslvfzo3xP0SDTf/KQYCSzLy6ThvgeBh+1Ow07x5sD57KV82yH0/mhPDR4w8/g+4dCUBCE4zZya
	eDPsXjpj2fq8mdV40RWK33vAAcDnTtYdSYY2J4S8YThJUtdcO83PPyP79X5TASetIaveHPsI7Ch
	81hiqHZH/6KPbFM0oA4+i78DEQzEhR5aqTy1JsDL753Cqjy9opPuo+H+9Is/GNCtVeAc2ULYRFA
	vBWSu177MHsX72k1lG5TJucawAam1ggRL/rc15E8x2QpN3ykyq0Cl890BuZWAP5d2d8EwnOv2t2
	yg37Z8tSgt8p+5myyFo8XieIIovwZKYP0+WkrkW18NXWQVhJA6Qq8rmX3duWq/n9RdWjSYGIOSs
	hfUQyh0ZX9opYKX6dX0VftMNFfmjwnxCIzGpp2U1RPppLMWhlM
X-Received: by 2002:a17:90b:2686:b0:359:1130:1047 with SMTP id 98e67ed59e1d1-3650ce8c051mr9834489a91.17.1777904940727;
        Mon, 04 May 2026 07:29:00 -0700 (PDT)
Received: from [192.168.50.90] ([116.87.14.48])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-365437b50b0sm6149529a91.0.2026.05.04.07.28.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 May 2026 07:29:00 -0700 (PDT)
Message-ID: <d1a3223f-489a-4769-ab0e-7620dedc3274@gmail.com>
Date: Mon, 4 May 2026 22:28:58 +0800
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 2/2] btrfs: derive f_fsid from on-disk fsuuid and dev_t
To: linux-btrfs@vger.kernel.org, dsterba@suse.com
References: <cover.1777281686.git.asj@kernel.org>
 <1420378f88b69562c4c77fe72bc7286408d995d2.1777281686.git.asj@kernel.org>
Content-Language: en-US
Cc: Anand Jain <asj@kernel.org>
From: Anand Jain <anajain.sg@gmail.com>
In-Reply-To: <1420378f88b69562c4c77fe72bc7286408d995d2.1777281686.git.asj@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 27/4/26 18:18, Anand Jain wrote:
> f_fsid depends on fs_devices->fsid and subvol root id.
> 
> For cloned devices either same as the source or dynamical generated
> at mount won't suite because tools like fanotify and ima depends on it.
> 
> Switch to a stable derivation using the persistent on-disk fsuuid +
> root id + devt of the block device for the single device filesystem
> when temp_fsid is active.
> This is consistent as long as the device remains unchanged/replace
> (excludes btrfs device replace secnario for now).
> 

David,

The changelog was inaccurate per Sashiko. I missed updating it to
reflect the final implementation.
I have corrected it below to match the current code changes.
I hope below change log can be used during merge.

-----------
btrfs: derive f_fsid from on-disk fsid and dev_t

The f_fsid was originally derived from fs_devices->fsid and the
subvolume root ID. However, when temp_fsid is active, fs_devices->fsid
is randomized, making the standard derivation inconsistent.

Since metadata_uuid is optional, it is not a reliable alternative.
This patch instead retrieves the on-disk UUID from
fs_info->super_copy->fsid.

To prevent f_fsid collisions between original and cloned filesystems,
this implementation hashes the dev_t for single-device btrfs
filesystems to ensure uniqueness. This is limited to single-device
filesystems as cloned mounts are currently only supported for that
configuration. Note that f_fsid will change if the device is replaced.
Additionally, since the kernel cannot distinguish between the
original and the cloned filesystem, this new f_fsid derivation
is applied to both.
---------------


Thanks
Anand


> Signed-off-by: Anand Jain <asj@kernel.org>
> ---
>  fs/btrfs/super.c | 41 +++++++++++++++++++++++++++++++++--------
>  1 file changed, 33 insertions(+), 8 deletions(-)
> 
> diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
> index a63ad6bd89f6..00eff951917c 100644
> --- a/fs/btrfs/super.c
> +++ b/fs/btrfs/super.c
> @@ -1732,12 +1732,13 @@ static int btrfs_statfs(struct dentry *dentry, struct kstatfs *buf)
>  	u64 total_free_data = 0;
>  	u64 total_free_meta = 0;
>  	u32 bits = fs_info->sectorsize_bits;
> -	__be32 *fsid = (__be32 *)fs_info->fs_devices->fsid;
> +	__be32 *fsid;
>  	unsigned factor = 1;
>  	struct btrfs_block_rsv *block_rsv = &fs_info->global_block_rsv;
>  	int ret;
>  	u64 thresh = 0;
>  	int mixed = 0;
> +	__kernel_fsid_t f_fsid;
>  
>  	list_for_each_entry(found, &fs_info->space_info, list) {
>  		if (found->flags & BTRFS_BLOCK_GROUP_DATA) {
> @@ -1818,14 +1819,38 @@ static int btrfs_statfs(struct dentry *dentry, struct kstatfs *buf)
>  	buf->f_bsize = fs_info->sectorsize;
>  	buf->f_namelen = BTRFS_NAME_LEN;
>  
> -	/* We treat it as constant endianness (it doesn't matter _which_)
> -	   because we want the fsid to come out the same whether mounted
> -	   on a big-endian or little-endian host */
> -	buf->f_fsid.val[0] = be32_to_cpu(fsid[0]) ^ be32_to_cpu(fsid[2]);
> -	buf->f_fsid.val[1] = be32_to_cpu(fsid[1]) ^ be32_to_cpu(fsid[3]);
> +	/*
> +	 * fs_devices->fsid is dynamically generated when temp_fsid is active
> +	 * to support cloned filesystems. Use the original on-disk fsid instead,
> +	 * as it remains consistent across mount cycles.
> +	 */
> +	if (fs_info->fs_devices->temp_fsid)
> +		fsid = (__be32 *)fs_info->super_copy->fsid;
> +	else
> +		fsid = (__be32 *)fs_info->fs_devices->fsid;
> +
> +	/*
> +	 * We treat it as constant endianness (it doesn't matter _which_)
> +	 * because we want the fsid to come out the same whether mounted
> +	 * on a big-endian or little-endian host.
> +	 */
> +	f_fsid.val[0] = be32_to_cpu(fsid[0]) ^ be32_to_cpu(fsid[2]);
> +	f_fsid.val[1] = be32_to_cpu(fsid[1]) ^ be32_to_cpu(fsid[3]);
> +
>  	/* Mask in the root object ID too, to disambiguate subvols */
> -	buf->f_fsid.val[0] ^= btrfs_root_id(BTRFS_I(d_inode(dentry))->root) >> 32;
> -	buf->f_fsid.val[1] ^= btrfs_root_id(BTRFS_I(d_inode(dentry))->root);
> +	f_fsid.val[0] ^= btrfs_root_id(BTRFS_I(d_inode(dentry))->root) >> 32;
> +	f_fsid.val[1] ^= btrfs_root_id(BTRFS_I(d_inode(dentry))->root);
> +
> +	/* Hash dev_t to avoid f_fsid collision with cloned filesystems. */
> +	if (fs_info->fs_devices->total_devices == 1) {
> +		__kernel_fsid_t dev_fsid = \
> +	u64_to_fsid(huge_encode_dev(fs_info->fs_devices->latest_dev->bdev->bd_dev));
> +
> +		f_fsid.val[0] ^= dev_fsid.val[1];
> +		f_fsid.val[1] ^= dev_fsid.val[0];
> +	}
> +
> +	memcpy(&buf->f_fsid, &f_fsid, sizeof(f_fsid));
>  
>  	return 0;
>  }

