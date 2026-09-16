Received: from mail-ej2-f24.google.com (mail-ej2-f24.google.com [74.125.228.152])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0812D45D19F
	for <linux-btrfs@vger.kernel.org>; Wed, 16 Sep 2026 21:29:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.228.152
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789594152; cv=none; b=tlXUBvQTwo8I8kuXrfPNYyEuNRCvdeMNIy5seocoHUgYaZgFrlarRjlih2fdtO+49ReXLhs5J9LvOPF4lUZK2RLsFbfXk2nkvFkjtKYDnbH/VX+X4hiUqk89kPix/6O2/voY1lDzs6KMJWBSrzA38nKsIdJvw05h4RmtK+jn85s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789594152; c=relaxed/simple;
	bh=Mj9woeestn0O3KWTX2ZwKaNb92XAg80vSnFqbDhxcm8=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=Q8azNTTzCEIDl0H+DiDl75bkNDZ0C0tyOBUYjTsfhjiqq+iU0bnZ3hqLEyrZBDliYLN/pHQfBGlza5JHXA4y1UaaEXIIq17/yMqvTqJuZgsQN6ZGm2QZtKdRhlut0Iqs3NarW46mMA1x3CMau9MWAM6R0afJgHErq74NzHLwCDs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=IyXQl5sI; arc=none smtp.client-ip=74.125.228.152
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="IyXQl5sI"
Received: by mail-ej2-f24.google.com with SMTP id a640c23a62f3a-c29d33431c8so27066866b.2
        for <linux-btrfs@vger.kernel.org>; Wed, 16 Sep 2026 14:29:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1789594142; x=1790198942; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=w0mB3xP2zPdw9+HXRD+IjSIB37+mCBHuSA1a3YCjqWI=;
        b=IyXQl5sIdS4QduohWOLCgGQXaKnP03uMacE7yu7iiFSBFJ7FnGtxHBnP7/+57sKqc9
         HAKyIRuScbbvz3Cq0FoZ46q3kQXjrd5FA9nxjbZF3hhUvtrzIHGo3mNxaJ59W+41Mh8n
         LO0UUXv9DQZ2DgbiVnkAk+310HeV4QuvLbgDDdWVPH4qz1+5UakrJD7x0XLv9eYw9pKJ
         xdyiJ/NAGFJ60H5pm4Kv9bTST4LSt2L5D3b//KeqBJ4UBWG7a+XNm5ZelKibbbOShX/b
         BoVdYO4X3gdulAC7IVHUQ8N07oqG+z9q3uJiIN2riQiR4rCruYxVgtAQKZDhwQ9RDu0N
         72XQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789594142; x=1790198942;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=w0mB3xP2zPdw9+HXRD+IjSIB37+mCBHuSA1a3YCjqWI=;
        b=CUlqf1UNcWupC8bfjegz1fiH299yYSpmz7kjmBJzlZzAG7TP5Az++GY19pIlnDPwgU
         aCntNWfnfmLKuLlDUqN1BW8CrtP3UJ2BVjvNuUDsmhdo5JuS0DlQnEXsNHRtV6K5KasP
         UQe+J06zL42mheXUzMj77xugu4Yczq/tvJLR4Scf1sdXuK63uKWO7SFQx2T/uTp3sauV
         LriTHCgbcsSpxc3zzYSoZfaE7EmvKE8vk6ICUWjjSDDC/t8YNsqziu+p27ZK1cPQz8aS
         9tlbx4scHWwCieawShukuUXo9YM8vOmMekq6bihGVw70YsdhBZVdQ7Mov/FwLA3W39NS
         AcSA==
X-Forwarded-Encrypted: i=1; AKwUvBw0ni/hg2DIB1nlVvnz09hX+pEAltzNtXn4twucUMYJjV7g9rLnCPBNyzhgkbSycsYM4BJ2r65HkykmZg==@vger.kernel.org
X-Gm-Message-State: AFuF++muJdKtFbqkLdVbFpqEzWNa+7jB8PJCU4HBFSVWeZMehSRgxP6n
	7AAgqTLqYDjAc7iW44G+0+mwFhe6Z3LfzWmvzHLhAe34IX9qaP0DX7iKN0l5cE1LIt4RN3NFA1H
	JFhIgu6sO1A==
X-Gm-Gg: AYBFou0Kd/I/wGeF1WTcFZKAfKKDHJOcIdQz96SqMbFCThefqakSrdDi6lsgJbbYbb7
	7ow+aXSn31wODYH1kpvs7g1viti6eIYKKmGDy6b3hYmCSYBZNfv69Y9xN1j/5iAmSubYztk7JtZ
	wKfp9n7peHHbw5bSFgO/lTv4xqsL1Nl59tjaslJ0CoGRiH9uzDWYXvDZMB0UxuBAeXQpS8z+ELB
	ij62Khw52lFmTzu8XJAGjQSb2HroIYtyDThYQWKlB0AapudmYmxM987R9HzVcLCxoxydwWiSpJs
	jJAnqz4RaEbdNaK164gAscMYdU0mnkivVho4AgOLzA5K2XYxFFDeUIFLTCqV+04ELnty+1PJEtH
	lS3lMxS3JHwRUhvYQYgwoqtH670Db1GXDlfWx8QZEcmR7QnZsgsI9hl/EfEt5HpjrLjy2MTYrNk
	ISMIz0ZsP/txvX8d4dZ65Y3UO/POUypuHezrb45o9xRKKhAKhzU2Jks4PxSUW41/dYtIOqiYzkV
	Q==
X-Received: by 2002:a17:906:c114:b0:c29:52dd:317c with SMTP id a640c23a62f3a-c29e52ff5aamr299112366b.30.1789594142158;
        Wed, 16 Sep 2026 14:29:02 -0700 (PDT)
Received: from [172.16.0.229] ([159.196.52.54])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39e36096735sm1363661a91.12.2026.09.16.14.28.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 16 Sep 2026 14:29:01 -0700 (PDT)
Message-ID: <8e49c1f8-de40-4c58-b99f-965306b4bc26@suse.com>
Date: Thu, 17 Sep 2026 06:58:57 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] btrfs: add missing unlikely to a couple error checks
 during sys chunk array validation
To: fdmanana@kernel.org, linux-btrfs@vger.kernel.org
References: <0748c218c84df0cb8a9231b5e108e12ad28e9b6a.1789575353.git.fdmanana@suse.com>
Content-Language: en-US
From: Qu Wenruo <wqu@suse.com>
Autocrypt: addr=wqu@suse.com; keydata=
 xsBNBFnVga8BCACyhFP3ExcTIuB73jDIBA/vSoYcTyysFQzPvez64TUSCv1SgXEByR7fju3o
 8RfaWuHCnkkea5luuTZMqfgTXrun2dqNVYDNOV6RIVrc4YuG20yhC1epnV55fJCThqij0MRL
 1NxPKXIlEdHvN0Kov3CtWA+R1iNN0RCeVun7rmOrrjBK573aWC5sgP7YsBOLK79H3tmUtz6b
 9Imuj0ZyEsa76Xg9PX9Hn2myKj1hfWGS+5og9Va4hrwQC8ipjXik6NKR5GDV+hOZkktU81G5
 gkQtGB9jOAYRs86QG/b7PtIlbd3+pppT0gaS+wvwMs8cuNG+Pu6KO1oC4jgdseFLu7NpABEB
 AAHNGFF1IFdlbnJ1byA8d3F1QHN1c2UuY29tPsLAlAQTAQgAPgIbAwULCQgHAgYVCAkKCwIE
 FgIDAQIeAQIXgBYhBC3fcuWlpVuonapC4cI9kfOhJf6oBQJnEXVgBQkQ/lqxAAoJEMI9kfOh
 Jf6o+jIH/2KhFmyOw4XWAYbnnijuYqb/obGae8HhcJO2KIGcxbsinK+KQFTSZnkFxnbsQ+VY
 fvtWBHGt8WfHcNmfjdejmy9si2jyy8smQV2jiB60a8iqQXGmsrkuR+AM2V360oEbMF3gVvim
 2VSX2IiW9KERuhifjseNV1HLk0SHw5NnXiWh1THTqtvFFY+CwnLN2GqiMaSLF6gATW05/sEd
 V17MdI1z4+WSk7D57FlLjp50F3ow2WJtXwG8yG8d6S40dytZpH9iFuk12Sbg7lrtQxPPOIEU
 rpmZLfCNJJoZj603613w/M8EiZw6MohzikTWcFc55RLYJPBWQ+9puZtx1DopW2jOwE0EWdWB
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
In-Reply-To: <0748c218c84df0cb8a9231b5e108e12ad28e9b6a.1789575353.git.fdmanana@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/9/17 01:46, fdmanana@kernel.org 写道:
> From: Filipe Manana <fdmanana@suse.com>
> 
> It's unexpected to find errors during sys chunk array validation and all
> checks use the unlikely tag except for two of them, so add it.
> 
> Signed-off-by: Filipe Manana <fdmanana@suse.com>

Reviewed-by: Qu Wenruo <wqu@suse.com>

Thanks,
Qu

> ---
>   fs/btrfs/disk-io.c      | 2 +-
>   fs/btrfs/tree-checker.c | 6 +++---
>   2 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> index 94a7e9059a7b..21b72c90bd90 100644
> --- a/fs/btrfs/disk-io.c
> +++ b/fs/btrfs/disk-io.c
> @@ -2387,7 +2387,7 @@ static int validate_sys_chunk_array(const struct btrfs_fs_info *fs_info,
>   		}
>   		ret = btrfs_check_chunk_valid(fs_info, NULL, chunk, key.offset,
>   					      sectorsize);
> -		if (ret < 0)
> +		if (unlikely(ret < 0))
>   			return ret;
>   		cur += btrfs_chunk_item_size(num_stripes);
>   	}
> diff --git a/fs/btrfs/tree-checker.c b/fs/btrfs/tree-checker.c
> index 0f4f1b347c9e..9cd79d97b9b5 100644
> --- a/fs/btrfs/tree-checker.c
> +++ b/fs/btrfs/tree-checker.c
> @@ -1121,9 +1121,9 @@ int btrfs_check_chunk_valid(const struct btrfs_fs_info *fs_info,
>   		return -EUCLEAN;
>   	}
>   
> -	if (!remapped &&
> -	    !valid_stripe_count(type & BTRFS_BLOCK_GROUP_PROFILE_MASK,
> -				num_stripes, sub_stripes)) {
> +	if (unlikely(!remapped &&
> +		     !valid_stripe_count(type & BTRFS_BLOCK_GROUP_PROFILE_MASK,
> +					 num_stripes, sub_stripes))) {
>   		chunk_err(fs_info, leaf, chunk, logical,
>   			"invalid num_stripes:sub_stripes %u:%u for profile %llu",
>   			num_stripes, sub_stripes,

