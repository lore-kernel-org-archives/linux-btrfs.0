Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93F4978F2B
	for <linux-btrfs@vger.kernel.org>; Wed,  1 Apr 2026 13:09:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775048979; cv=none; b=h/NKs1XN5qAbh+88VHHq9cGKIaBkmlAYmb4eS4FfpMgv9XDerukDfSE8l9o9oPReOo1n2vL7ySaROLIZ4Wd8svYbSAgxZLjT60PNyQl2NpqmRdxKr7XOeyHd3R9SFts0k+MfN4YjrKzdQoUF44JKE10SYt67ReK3lZ6bAa54UgE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775048979; c=relaxed/simple;
	bh=yARAWMhAZZGTSFlJbH1b0F4av7OjscDFp8GvYYsVTQI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=q27MQh865VHvNHXq8Y+r1Cj8pB9NHgoNfH3o6Gh6+w0US7DU6FkWDGj+5K11SHHCssI44tSaXL3A/sbap/v9UAhiv1yzrti6uL6xFRNDrr7tTBETIHbj0ff9HGzqwIuLZzpBgBZbNIL9TF3/rwK9IP/hQAqXXSxvgIao5u4N4yI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FImgd/4V; arc=none smtp.client-ip=209.85.216.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FImgd/4V"
Received: by mail-pj1-f53.google.com with SMTP id 98e67ed59e1d1-35d95017a68so2434614a91.3
        for <linux-btrfs@vger.kernel.org>; Wed, 01 Apr 2026 06:09:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775048977; x=1775653777; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=OD6SjFC/+DJkYNkIkqHoaqhkKORPQTE9oU/Ps8wb43c=;
        b=FImgd/4Vo8y8v6GRtcsoItnxmX2Y8LNG020rdI73GdyHsqeR7yKlgxbFPSSSr0qFsM
         zZyjiPy5fv1uCj2g75Bbo1lEV2U8/4bHtJOVMRInDYyqqmBsg15X20j/LplcIac4mveR
         3K9iAJ/ASZtnfgKDLJhONrEVDDnhGbmUMZ+pfi3Dde6xjIIwQBexs65L+mSVVZqQY8Lj
         KL0Z94FhTlQ2RC5jhrwWbG5z9DyFUFkgmnT9e0p1NncxTVVmUwNSWIojYq95EvnZ2CM+
         jrdQiEb5EVGTYCsxlwPfzLbbQXC3N+oJHhO4BXcjnGO3gVNNft7PssB6oHv+ADeqxCMX
         Ps/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775048977; x=1775653777;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=OD6SjFC/+DJkYNkIkqHoaqhkKORPQTE9oU/Ps8wb43c=;
        b=SW1Ss9cQWOx8/g2jPqXXUZRSdIHWTOTJWqTNRRwNf+r1Yu6P0aKRBO3asWL5yVNKTQ
         Zo6BuSzuTvX4fIV2Zxk7kW2FjDlTixsSfeS+8/n+pUrMM8zDFCidya7nyTrqMJ3m88Rc
         Fhi7pfmU7T6tK0U7IYc8tv2v8Ieyqehj243mz+PlhnTPVOzJEnvcmqycANrTkVdbjErm
         mrF+3/Yt7EUe6KFIyAn7C+nIhS8ORD18QgcxW9chm+kPiAr8qj1DqE3+95OVMsMGpdFV
         SsHp6EkPtwRdCUd0I/Ga7aQoZaVyfNDsKjIG2UP7VHGgOV3zjVmWavhRe3H/mtq8onbe
         uIwg==
X-Forwarded-Encrypted: i=1; AJvYcCXkI9bHvx2MKoChRuS92PTty2FllZpNUEFhK2Jp/psTKKdD6avAUTV/MsdarYqy/IdwhJec+M9PTcFcbw==@vger.kernel.org
X-Gm-Message-State: AOJu0YyCEuFNnuXd9C0ZtRDa/Exk/prBdbMJaEllbpIJ7nZSPYGsO4+2
	6upb8d7Qy8Z7z7gh0vp1VDUA1Vogaj1Zy00o/I1ivD+5M5lr4mKXZRuQ+4dXUvvj
X-Gm-Gg: ATEYQzxqe+rl5xrNgP30DJvg0O6+/b0tPNgwdDT2q4b1K4lJrJCun/1YvxZEq7U341+
	vfMiVuiwtwFZFjaDmupBeoJ+dCmqhu2ccGc8iz2kfnMnP0mZJz2PB/PIe9sZ9Q78rp57tQSLxct
	ula1AsWz3FBgfklLsTUqWD4F0jbqAthBHPX3HvtMQOcUqMzK4df2jMehzuqo+/7N+VhM1+Z8I8M
	6+1wU4fJmSj/kT/jbs3HsouBCktDEoVb1f+c3g4mwpyZhPQ+Dp3EHwNKntWLAT5CCxvnEdnwuwZ
	QjSA9+jsEBrwFgnwtTghWzgCGDO3dSVJrohDVEXxu+2OdfTKAy1BqMG5lB1Qs9rv59vPraHDx2p
	AYsiKWNlX+KIznn4QNsGmcwgxuIeWq/wdaolXS9LTILtHjfNs79YMNNxexYKzaaC+9VlFkdnP9e
	zAbM6TQBrqJ3t7bjINUCq6BsJO1Aa7kkrFCx+Cgg==
X-Received: by 2002:a17:90b:2fd0:b0:33b:b078:d6d3 with SMTP id 98e67ed59e1d1-35dc6f9ab8dmr3194053a91.23.1775048976757;
        Wed, 01 Apr 2026 06:09:36 -0700 (PDT)
Received: from [192.168.50.90] ([116.87.14.48])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b2700cf9a7sm12669665ad.8.2026.04.01.06.09.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 01 Apr 2026 06:09:35 -0700 (PDT)
Message-ID: <0483b97d-f733-4eb9-be9a-2d0bd9ea43b8@gmail.com>
Date: Wed, 1 Apr 2026 21:09:32 +0800
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] btrfs: do not reject a valid running dev-replace
To: Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
Cc: =?UTF-8?Q?Jaron_Vi=C3=ABtor?= <jaron@vietors.com>
References: <03c15f51597e61c4d669db55f5c627b3a3af9b20.1774998167.git.wqu@suse.com>
Content-Language: en-US
From: Anand Jain <anajain.sg@gmail.com>
In-Reply-To: <03c15f51597e61c4d669db55f5c627b3a3af9b20.1774998167.git.wqu@suse.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit


looks good

Reviewed-by: Anand Jain <asj@kernel.org>


On 1/4/26 07:02, Qu Wenruo wrote:
> [BUG]
> There is a bug report that a btrfs with running dev-replace got rejected
> with the following messages:
> 
>  BTRFS error (device sdk1): devid 0 path /dev/sdk1 is registered but not found in chunk tree
>  BTRFS error (device sdk1): remove the above devices or use 'btrfs device scan --forget <dev>' to unregister them before mount
>  BTRFS error (device sdk1): open_ctree failed: -117
> 
> [CAUSE]
> The tree and super block dumps show the fs is completely sane, except
> one thing, there is no dev item for devid 0 in chunk tree.
> 
> However this is not a bug, as we do not insert dev item for devid 0 in
> the first place.
> Since the devid 0 is only there temporarily we do not really need to
> insert a dev item for it and then later remove it again.
> 
> It is the commit 34308187395f ("btrfs: add extra device item checks at
> mount") adding a overly strict check that triggers a false alert and
> rejected the valid filesystem.
> 
> [FIX]
> Add a special handling for devid 0, and doesn't require devid 0 to
> have a device item in chunk tree.
> 
> Reported-by: Jaron Viëtor <jaron@vietors.com>
> Link: https://lore.kernel.org/linux-btrfs/CAF1bhLVYLZvD=j2XyuxXDKD-NWNJAwDnpVN+UYeQW-HbzNRn1A@mail.gmail.com/
> Fixes: 34308187395f ("btrfs: add extra device item checks at mount")
> Signed-off-by: Qu Wenruo <wqu@suse.com>
> ---
>  fs/btrfs/volumes.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index 33fa73668534..d8f2722311c8 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -8667,7 +8667,12 @@ bool btrfs_verify_dev_items(const struct btrfs_fs_info *fs_info)
>  
>  	mutex_lock(&uuid_mutex);
>  	list_for_each_entry(dev, &fs_info->fs_devices->devices, dev_list) {
> -		if (!test_bit(BTRFS_DEV_STATE_ITEM_FOUND, &dev->dev_state)) {
> +		/*
> +		 * Replace target dev item (devid 0) is not inserted into chunk tree.
> +		 * So skip the DEV_STATE_ITEM check.
> +		 */
> +		if (dev->devid != BTRFS_DEV_REPLACE_DEVID &&
> +		    !test_bit(BTRFS_DEV_STATE_ITEM_FOUND, &dev->dev_state)) {
>  			btrfs_err(fs_info,
>  			"devid %llu path %s is registered but not found in chunk tree",
>  				  dev->devid, btrfs_dev_name(dev));

