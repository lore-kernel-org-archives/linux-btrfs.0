Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 230BC3F411F
	for <linux-btrfs@vger.kernel.org>; Tue,  7 Jul 2026 22:43:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783464221; cv=none; b=P2X6Bs1u9XjXSipqDN2b8Hn0+g5GglDd4q22L6T6xJaLDUGmHn8TYf2NAgD+3zk3J2RJuKiCXLoOl6q2rywaBcAVB5qfd3But+MHCIgkoS4YVBNR2gDcwB7nZk1dg5HSx9Bh3iwuFiMVA/clnkeAxeDglG6CxuVDTNl6z9+dUV8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783464221; c=relaxed/simple;
	bh=tw7fOM5v7hDAt5UvcEF0ts9YM6d76XdWGwBRwAoJ4Ls=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=R1Oc2yi5dkbb+NhZL2TT10q+2SbzRv3wPLNDZ+d2DTAIRp1O9NFTHOdMyQ058vbg/deeS8gmOyRZa4Uc/3fiP8f/ib1zh8O3AwRQGQf9oiKRkVkl93YSVu6dnPsw8pCi82opyLd3ctlRk+VyPTukGP2WAhedtWOlI3L127KM9TU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=Feq8DaJx; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="Feq8DaJx"
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-493c486f012so40055e9.3
        for <linux-btrfs@vger.kernel.org>; Tue, 07 Jul 2026 15:43:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1783464216; x=1784069016; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=mN/5tef0+W2z/JXOgBIXk9vX5hoHSFlWZu3K4T6c9RA=;
        b=Feq8DaJxj/XQK/VoA/JfCXhUwoHPu930fR/tB/v+hUEwDUij6pmPFIxN5GfbRnZuBA
         Ex6YukMG80txmHfBh6D9iNCRpB8xdEIpvWg2FCvPFucQ8hXbm1JbpOOBNxZLIwMCeRc6
         YyVKBjpMYX8/K8GuGbhG2A8m1OlabZenPQ1Vv40rYbF+s8A6j+xclBZ9jZWEVqbZpKGY
         pNmfRh4zDiRH6qiNJUEPfgzrZ5CGvdYXt1dusbHNuAv9nmWBZ6yjeHf7/YiLxcJ7Uq9t
         uj0+pZfCeVRXu1xodNHEHRDLuN9CIC+/4Ib6gws+FyGIKAwnSaTcjUICoN+qu/i40HOi
         9Bmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783464216; x=1784069016;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=mN/5tef0+W2z/JXOgBIXk9vX5hoHSFlWZu3K4T6c9RA=;
        b=WEAdMI2dbwyFWpncTsiRILAtYceUTcbu2UFGJayTTPhpZfE1UeY2AR7xRJiFpGZN6C
         az41TnWSXDTgvIACuWW5O8MnqFArwaLnJV4jcubwvdovkVUEfTZq/xfncnwzP8eTc6pf
         UK2IAPIKcHLK3HCKEPHxISm8lY0aj5/+qC/5TF2+m3o77IqyM4OqIevR5rPU9V1UGqqN
         Q49ToXotMPMoPXTLYhWHlttJGBDv76BRu08djGsgOo0/jaAYBdFWQhNkZQp77coq9wk5
         fPpcjk/QUbDyVRpPFKaeTUUrgg2vVtDL6WHlX6SUMSVCQ0Yj7D8B20PcFYp7wFGS50bP
         O+xw==
X-Forwarded-Encrypted: i=1; AHgh+RphDFv7/VMnZzVIHQF4umvGZ0nemQEkd6PS4OjG4SfyuTc+aSEv1f8Rw5DosSqRFtOFwLQb0jfA8xjbbg==@vger.kernel.org
X-Gm-Message-State: AOJu0YzIkTes8R1IUDQbTl1ftm3G9CStY54XpFcdzgCxZsAhKJcPcjX9
	J9tKgiYzboeRK0z9DGPoRyeu8T8zEXIus1UHZ4hQhY84g8qxmBgLdfZuYfcJ0419k+8=
X-Gm-Gg: AfdE7clbLTsZXfFzYAaTVlNrEZ+H2vEh+f0ucwC+LvEjG7Jzvj8t7hKxKh9Ucy3WrD0
	2xwBvWRy2cuKasCzCw3eUKIjAMB+wPgD1DirFB0Nel6m5rnjiKO5SqmjYsiNQSnV2HpbhOdhO5D
	Avliicgus5HnRUT/QPDohbQ6tKTLOHLIUezstk8A5/VVJauCFbMJcskAPHW879I3fvGnWAmjTNp
	zgZ2tC7GjK9jEObM085sgeoApw5IEYmtuvfO27tnAxw8q5lXLybE2dAvZJdfnpVzyz6f/l/T5Bb
	Y+GF/TbUyiKCA766LBb4B4hUwUyhWyiGp/UzNCb2reGFjmOKkFU0eScU4ZMdaqNDyqXb8X4aCCl
	Lc956UlwLfX4iljaV5RofDxiTyOHPhVKk1/uf/BmtPR+A6UQyosDMo1JY7+HvVdrd3RHFyvIM8P
	E7hZC/1w==
X-Received: by 2002:a05:600c:4453:b0:493:e52f:6ee1 with SMTP id 5b1f17b1804b1-493e5647f96mr8155405e9.0.1783464216443;
        Tue, 07 Jul 2026 15:43:36 -0700 (PDT)
Received: from [172.16.0.229] ([159.196.52.54])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ccc9d602fdsm18140735ad.81.2026.07.07.15.43.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Jul 2026 15:43:35 -0700 (PDT)
Message-ID: <12ca4ad2-0b35-41ef-8527-7a047549986d@suse.com>
Date: Wed, 8 Jul 2026 08:13:30 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 6/7] btrfs-progs: check: update inline extent length
 checking
To: Daniel Vacek <neelx@suse.com>, David Sterba <dsterba@suse.com>
Cc: linux-fscrypt@vger.kernel.org, linux-btrfs@vger.kernel.org,
 linux-kernel@vger.kernel.org, Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
References: <20260707142736.2330146-1-neelx@suse.com>
 <20260707142736.2330146-7-neelx@suse.com>
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
In-Reply-To: <20260707142736.2330146-7-neelx@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/7/7 23:57, Daniel Vacek 写道:
> From: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
> 
> As part of the encryption changes, encrypted inline file extents record
> their actual data length in ram_bytes, like compressed inline file
> extents, while the item's length records the actual size. As such,
> encrypted inline extents must be treated like compressed ones for
> inode length consistency checking.
> 
> Signed-off-by: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
> Signed-off-by: Daniel Vacek <neelx@suse.com>
> ---
>   check/main.c | 31 +++++++++++++++++--------------
>   1 file changed, 17 insertions(+), 14 deletions(-)
> 
> diff --git a/check/main.c b/check/main.c
> index 9447b01e..cadcfef0 100644
> --- a/check/main.c
> +++ b/check/main.c
> @@ -1720,9 +1720,7 @@ static int process_file_extent(struct btrfs_root *root,
>   	u64 disk_bytenr = 0;
>   	u64 extent_offset = 0;
>   	u64 mask = gfs_info->sectorsize - 1;
> -	u32 max_inline_size = min_t(u32, mask,
> -				BTRFS_MAX_INLINE_DATA_SIZE(gfs_info));
> -	u8 compression;
> +	u8 compression, encryption;
>   	int extent_type;
>   	int ret;
>   
> @@ -1747,25 +1745,30 @@ static int process_file_extent(struct btrfs_root *root,
>   	fi = btrfs_item_ptr(eb, slot, struct btrfs_file_extent_item);
>   	extent_type = btrfs_file_extent_type(eb, fi);
>   	compression = btrfs_file_extent_compression(eb, fi);
> +	encryption  = btrfs_file_extent_encryption(eb, fi);
>   
>   	if (extent_type == BTRFS_FILE_EXTENT_INLINE) {
> -		num_bytes = btrfs_file_extent_ram_bytes(eb, fi);
> -		if (num_bytes == 0)
> +		u32 max_inline_size = min_t(u32, mask,
> +					BTRFS_MAX_INLINE_DATA_SIZE(gfs_info));
> +		u64 num_disk_bytes = btrfs_file_extent_inline_item_len(eb, slot);
> +		u64 num_decoded_bytes = btrfs_file_extent_ram_bytes(eb, fi);
> +		if (num_decoded_bytes == 0)
>   			rec->errors |= I_ERR_BAD_FILE_EXTENT;
> -		if (compression) {
> -			if (btrfs_file_extent_inline_item_len(eb, slot) >
> -			    max_inline_size ||
> -			    num_bytes > gfs_info->sectorsize)
> +		if (compression || encryption) {
> +			if (encryption)
> +				max_inline_size = min_t(u32, gfs_info->sectorsize,
> +					BTRFS_MAX_INLINE_DATA_SIZE(gfs_info));

The change looks good to me now.

However I'm just curious, is it possible to limit the encrypted data 
size to sectorsize-1?

Or it is some fscrypt limit internal requiring a power-of-2 size or just 
lack of interface?

Anyway I won't object this new change.

Thanks,
Qu

> +			if (num_disk_bytes > max_inline_size ||
> +			    num_decoded_bytes > gfs_info->sectorsize)
>   				rec->errors |= I_ERR_FILE_EXTENT_TOO_LARGE;
>   		} else {
> -			if (num_bytes > max_inline_size)
> +			if (num_decoded_bytes > max_inline_size)
>   				rec->errors |= I_ERR_FILE_EXTENT_TOO_LARGE;
> -			if (btrfs_file_extent_inline_item_len(eb, slot) !=
> -			    num_bytes)
> +			if (num_disk_bytes != num_decoded_bytes)
>   				rec->errors |= I_ERR_INLINE_RAM_BYTES_WRONG;
>   		}
> -		rec->found_size += num_bytes;
> -		num_bytes = (num_bytes + mask) & ~mask;
> +		rec->found_size += num_decoded_bytes;
> +		num_bytes = (num_decoded_bytes + mask) & ~mask;
>   	} else if (extent_type == BTRFS_FILE_EXTENT_REG ||
>   		   extent_type == BTRFS_FILE_EXTENT_PREALLOC) {
>   		num_bytes = btrfs_file_extent_num_bytes(eb, fi);

