Received: from mail-ej2-f12.google.com (mail-ej2-f12.google.com [74.125.228.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A80F37416F
	for <linux-btrfs@vger.kernel.org>; Tue, 15 Sep 2026 22:16:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.228.140
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789510588; cv=none; b=pkRtvSnep/KsfeuX3hfGeV0ddG2FVncVq6p9a/2R/GYCaHGo8kZwYK6pBHHfqazS7zYitRZV1E4UvaqKdDAWpPQtbUraoRDcUsJPEBN3AeGK5GHrMQW8Hy5947dCoNkiNtu4i3djcnVMuOnizR84HkfS/9b14/yPQg+ZNXQHD94=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789510588; c=relaxed/simple;
	bh=BscXMGV65r6C0wAvido3gq8cHiLKzPO2AoHVF6iNN/U=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=QiNQS+TUWbMcDVCwBp2rrCQr0hGRG90aD8RWbIO1RRHiyRVPdG4iFucYIlt7A0zFNi299gN+K/6z2I1x9aViZlM6GWH5AxqTqorcF0vRITq+Ytl6to1pFoN9u/R9NUxxo5KrC5Ryqzfjzq8dNKMK9Yxo5DoZJ9eh/tXc/ol2pX0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=cRnmxZfI; arc=none smtp.client-ip=74.125.228.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="cRnmxZfI"
Received: by mail-ej2-f12.google.com with SMTP id a640c23a62f3a-c29703cb470so51194966b.0
        for <linux-btrfs@vger.kernel.org>; Tue, 15 Sep 2026 15:16:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1789510584; x=1790115384; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=B9iru7KgswTEjr/v16lnpjqFs9qEkV6VbmccCC179Ho=;
        b=cRnmxZfI8S1fMpUk2vN/Gjl6ie3f33e/3rwOwNsnQdUEM4IsV0u8kODS5JFKq0adXX
         kCT5dnJhT8Vb4saTjwMoM6/POIHLVV+eX3i2bkiD7mGxpwenTdhUiAVRThEFoaWh1YLR
         Jnm8tGmC0JIQM2nWaxDzDIS+Xta2/D7byhlBxYCgnhZwjz4f9Lz2QGp30mEPNMUGgjnP
         MiGL0v8lO08f8bvzu/kmdvAWvjTi3XbdOuCyF+on+cgelfWAN6gDo7m2wi1TL0+XCAnX
         s5s6gzZN8jztekLOEfzkXG3XBKzieor5v6tzZTOvrSYfq9NQfAEFrKtsHheDHREOd+oY
         ypCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789510584; x=1790115384;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=B9iru7KgswTEjr/v16lnpjqFs9qEkV6VbmccCC179Ho=;
        b=tVGTHl7VZHLKL0+vNP/0K5Xiyk9E7BvWhDo5GfvIDlUu/ta/XPPpu6vWJJfxUzhV3k
         HzsiMtnHhvGqihkQWrY90VxPFn348mXsTyrcbOeXMSPwkkEcvUAQ/KaXrGi+fwPLH6k5
         XqUro/amJTo8mE5sICCy5nEv1ITjs1g1zKaDJII1KZLWV4JNfOi0O5VTtt8unWvU8WGk
         2qX3WBVdY/CCo9ujNH1AwPC3NMVfKOTcYadX22o9GX7c86IkIoQjoEoSgpghrrrbmMv8
         HFOkhLkHiCjAbj2xO8uFt2IGwJXAPJdAsvUkAgtVeH+NotlGjknUmGOf6Z5AeJqSgplO
         8ZyA==
X-Forwarded-Encrypted: i=1; AKwUvBx21JsMERZ2psdITnKPJsx8JaXyt93zRdLhPFA/6ub06b8Pbg0E+Hfqyl3mnuUUJC4xS5YCE74S7ydJUA==@vger.kernel.org
X-Gm-Message-State: AFuF++kUHYX9sXLQ2ofXPJoNm3+6EcXBSu1+yh6bNfrvy9tIDvPTQmh/
	3Hv5E6JGsjIC6SM/0X1zJBT4AGNUZm4NVNHWULxxQiKmj27x/DFSBlzzclMoZJulM6GlABScNp6
	aFYpmnQ41qw==
X-Gm-Gg: AYBFou2Zh0lrknikJHbO1K8tLP2vZknbyjhHgaZnrpynDPA5hMiajwMSg2RCfZxDEWn
	h/N2a1ThD8L/wev1xrNVwco27UQOwq7mX1GnaIurfEtD4iAAtn5KTjTshAykTG9R7JNs7caMbnu
	9vam53c/cSBfFb5tEFCgUVQgCeXiv9zHAybwDm9gUs3Lx5edzUVwMOYO2JzXO7BdWh3rvDhYLdV
	8Ul4d25P6XOICRWEXmXPf46885+g9marqvCTD15ZHwtX25p1cSV8LZnAfWJ8084nWGLGw9vpyng
	r4LjyvfWf6REiq7Rz80gQHVHjHG3AWHbGCV52EwfYv5R+Dn+xkj0UtEFZ8yZCwEprR7xNl5sSGH
	0IhOhCuaxTFZ3O/ZYlOaQIxN5ZteiU2AqVkePBJ15WBbIMoaAzIJdBHbb6TIW+tLaGMdxP/OS2Z
	vI5+LgGs3JzHQGpaQsECiP9tf+gc8QautaElhliG8ZPh3IXbwsDhUDOlM9yvV585I=
X-Received: by 2002:a17:907:9491:b0:c25:504a:1e25 with SMTP id a640c23a62f3a-c29e5275ee3mr7132966b.13.1789510584048;
        Tue, 15 Sep 2026 15:16:24 -0700 (PDT)
Received: from [172.16.0.229] ([159.196.52.54])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2dd89e94383sm1809675ad.18.2026.09.15.15.16.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 15 Sep 2026 15:16:22 -0700 (PDT)
Message-ID: <17a03645-fce6-48ff-b95c-5fff0466b9d3@suse.com>
Date: Wed, 16 Sep 2026 07:46:17 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] btrfs: clear free space tree state on rebuild failure
To: Guanghui Yang <3497809730@qq.com>, linux-btrfs@vger.kernel.org
Cc: dsterba@suse.com, mason@kernel.org, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org
References: <tencent_F71ECF81628C274CC89FDB3304420C2D1506@qq.com>
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
In-Reply-To: <tencent_F71ECF81628C274CC89FDB3304420C2D1506@qq.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/9/16 00:18, Guanghui Yang 写道:
> btrfs_rebuild_free_space_tree() sets
> BTRFS_FS_CREATING_FREE_SPACE_TREE and
> BTRFS_FS_FREE_SPACE_TREE_UNTRUSTED before rebuilding the free space
> tree. Several error paths return without clearing these flags.
> 
> This leaves the flags set on the live filesystem and affects delayed
> reference processing and free-space caching.

What kind of effect?

> Clear both flags on all
> free space tree rebuild failure paths.
> 
> Fixes: 1d6a4fc85717 ("btrfs: make clear_cache mount option to rebuild FST without disabling it")
> Cc: stable@vger.kernel.org # 6.4+
> Assisted-by: Codex:gpt-5
> Tested: make -j$(nproc) fs/btrfs/free-space-tree.o

That's not helpful, you should run the full fstests instead.

> Signed-off-by: Guanghui Yang <3497809730@qq.com>
> ---
>   fs/btrfs/free-space-tree.c | 15 +++++++++++----
>   1 file changed, 11 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/btrfs/free-space-tree.c b/fs/btrfs/free-space-tree.c
> index 1b3d82ae3de8..1410da2766a9 100644
> --- a/fs/btrfs/free-space-tree.c
> +++ b/fs/btrfs/free-space-tree.c
> @@ -1353,7 +1353,7 @@ int btrfs_rebuild_free_space_tree(struct btrfs_fs_info *fs_info)
>   	if (unlikely(ret)) {
>   		btrfs_abort_transaction(trans, ret);
>   		btrfs_end_transaction(trans);
> -		return ret;
> +		goto out_clear;
>   	}
>   
>   	node = rb_first_cached(&fs_info->block_group_cache_tree);
> @@ -1371,14 +1371,16 @@ int btrfs_rebuild_free_space_tree(struct btrfs_fs_info *fs_info)
>   		if (unlikely(ret)) {
>   			btrfs_abort_transaction(trans, ret);
>   			btrfs_end_transaction(trans);
> -			return ret;
> +			goto out_clear;
>   		}
>   next:
>   		if (btrfs_should_end_transaction(trans)) {
>   			btrfs_end_transaction(trans);
>   			trans = btrfs_start_transaction(free_space_root, 1);
> -			if (IS_ERR(trans))
> -				return PTR_ERR(trans);
> +			if (IS_ERR(trans)) {
> +				ret = PTR_ERR(trans);
> +				goto out_clear;
> +			}
>   		}
>   		node = rb_next(node);
>   	}
> @@ -1390,6 +1392,11 @@ int btrfs_rebuild_free_space_tree(struct btrfs_fs_info *fs_info)
>   	ret = btrfs_commit_transaction(trans);
>   	clear_bit(BTRFS_FS_FREE_SPACE_TREE_UNTRUSTED, &fs_info->flags);
>   	return ret;
> +
> +out_clear:
> +	clear_bit(BTRFS_FS_CREATING_FREE_SPACE_TREE, &fs_info->flags);
> +	clear_bit(BTRFS_FS_FREE_SPACE_TREE_UNTRUSTED, &fs_info->flags);

The free space tree is not properly rebuilt, thus we can not trust it 
anymore.

Why you want to clear the UNTRUSTED flag?

> +	return ret;
>   }
>   
>   static int __add_block_group_free_space(struct btrfs_trans_handle *trans,
> 
> base-commit: 587858367581b9c55c3690f4e63382ad622719d4

