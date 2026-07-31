Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DA1C3546CC
	for <linux-btrfs@vger.kernel.org>; Fri, 31 Jul 2026 09:27:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785490036; cv=none; b=uBRgdmvr2vQ7uJFTGAG7m2PxdVrqwC9zgxgjDL+Ch3jOCd0IrsdOvJU/kAdflgNLVXnxViN2iUB0LE8WGncQ3PeeWIzWmDh915W4hdq4KPfw+DxloFuxQ3HuuTCKTFW9iVHuqOnE37xuIelOWZ+Gn4eVJXj1gBfd/A7TO3V3NdE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785490036; c=relaxed/simple;
	bh=7jCd9bI5x9lXklx2RIKEtj6TB50OgSiJ4NN5VCaRkRs=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=r0BRNUz+ALXGpHuiMxczfZplY3PiY+C6iTEM7kcYXXQXZX7amh4Qxt36kET8lq8j+WxkUK4WCPWVqJZUnSLJpzY0CJPvbB5b0aMHvVN3XDaK1m+BEcyPSpF08gA9HyXHmfQmavnqanUxkiQM9gnL58wUubyjjdUmdxQWKz9ZhcU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=ZjpG55Ng; arc=none smtp.client-ip=209.85.218.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="ZjpG55Ng"
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-c15f020a223so107910666b.1
        for <linux-btrfs@vger.kernel.org>; Fri, 31 Jul 2026 02:27:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1785490033; x=1786094833; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=yBVktPGPYkBjv4t8CU4CqhV8rpl6NhoCVgm0FIrfCnE=;
        b=ZjpG55NgQ/qLVIMwoG54InCHA9jNyashzslut8IgK0fNddlAJOUS/rE2b+ElnfcTSr
         3qO7DFStJXdpzM5Or7SCFkCT6xwnAugmzuswkUAJnpEiYQSVDgYKMa/umPdmBvVejvXM
         7CQiewuws+ImiuhDidAIAyoO8GeN64u1XM14/Jhsk19v4FBLc2C+VSigure8k/Ab6lU1
         1ltMMSjLctDzIpKliKFCtVaeIovWLuXZ8O1BK7n5An5qJHennUdS+5KLlRxQSDJ96uTV
         SFEuC+tsIzqZwbTOLXTkoN6uJdb6jdGA4rDkFRY26Oei02Mh/h7UvfZUMjxoeec0gq7O
         vNsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785490033; x=1786094833;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=yBVktPGPYkBjv4t8CU4CqhV8rpl6NhoCVgm0FIrfCnE=;
        b=i4MpgV3/kPUuQKt8viTA0LUPT7skNJglw7pqc+nylWYi6ABEJ9SE6CgbHDEA2WaL1/
         TmnWoy3zu/NpZGwtmFI6MN9uvEkpkvhNUBfbQwbJwESS76QLdgavaQaFp/vsQHm0ikku
         QZIeebbqZGlOrXfKzDHNiiUvuaBp9tKq9rMYVVqKFkXVdVOigTqH2MAiR3NPUmAdn6bl
         elc6EvNq7/0uohWMU4mI6XvxDMBtJvZsuZMl3vn91d44Vc1hBZTwLJsz9z0Znwf06MPC
         VCXHVBKKgpeh7acLJyvoRSRgvyy2Tuckt5T4bnewRaqHArWeizCSX8b7jvcFAYQAI3H5
         tFwg==
X-Forwarded-Encrypted: i=1; AHgh+RqRJHMUj19AvdwhuteSEmrq2RrgH+8H+zb4eUzjGPjaxqcXQSZTMktBJT6w5zotFQ6cOc+bjcMTp4wvXQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YztHZ8NxAbxSAISlzhF1Ao4LIrycksE7t3JriKvViPLU0y9hNjM
	/8XDxLOwx/pvKSQout6nRW3jIoOr2p+zK1XvpT37Uo7I86J5cHsPA1a/ET5GMOwBlaDtWxJ2/Ex
	6Aj940BA=
X-Gm-Gg: AR+sD11TILUDGvWZBsvW8SP5N5/NsZD2gpHE06uklAjHqNsIGZE7oYz8sZ8X5Ix7dk6
	yBrZIGmlVJZBSm6rH2S+44G7i4jLiHl/auewAjKf1JvSYwbfkuefx548JEA26s462Gzo7pVBAuL
	7nYyfWSNrcllH4z9VrZl/hH0YBLS+x4xX+f87B0ZBf+Cho4UpXgZyKGNbcEB3i4YU4MDfnaMOnP
	VJng25aahPsjHJcXrAFwE66HILOzjeTCcGpQCFbNxY2chHO1hxCeOCHUuUlJ5bREgC2ZoRoDvut
	f7XixqO66wjgIjidTGoADTikdUvRxysfEmBsk8xsUMThNzSxsTWeav4c7h617Tm4Hbnky1P907p
	rCsfjX4p6q63j6zTg80ZhfNyu2xGbgQVS5YKf6RZJiNqmOtEwme6ALmkp80N2NzjvaRHpV4g0Q9
	g+RljaDvtRT7BRHi98USftQPxX0P6FVfPmu26weyiKWhTrrbTyGRGoNZ7uJfvz+jqr
X-Received: by 2002:a17:907:97d3:b0:c1f:5868:7124 with SMTP id a640c23a62f3a-c1fd1e10ed6mr69554466b.5.1785490032533;
        Fri, 31 Jul 2026 02:27:12 -0700 (PDT)
Received: from [172.16.0.229] ([159.196.52.54])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3153dd4e666sm6199074eec.4.2026.07.31.02.27.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 31 Jul 2026 02:27:11 -0700 (PDT)
Message-ID: <1acd6527-a33a-4daf-9b2e-9c583f5556c0@suse.com>
Date: Fri, 31 Jul 2026 18:57:06 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] btrfs: skip hole detection during full fsync for files
 without holes
To: fdmanana@kernel.org, linux-btrfs@vger.kernel.org
References: <2673cd12fadb5269b39417694d82e02b90a482f7.1785429154.git.fdmanana@suse.com>
 <8a62eeb9c24994929aa697d2125a197e82bb7c02.1785488972.git.fdmanana@suse.com>
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
In-Reply-To: <8a62eeb9c24994929aa697d2125a197e82bb7c02.1785488972.git.fdmanana@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/7/31 18:49, fdmanana@kernel.org 写道:
> From: Filipe Manana <fdmanana@suse.com>
> 
> If we the no-holes feature is enabled (a default since btrfs-progs 5.15),
> when doing a full fsync we always iterate of all leaves in the subvolume
> root that contain file extent items in order to detect holes between them.
> 
> This can take a lot of time for files with a large number of extents.
> But if we know there are no prealloc extents and the amount of space
> (uncompressed space) is greater than or equals to the i_size of the
> inode, then we cannot have holes and therefore avoid searching for
> them. So skip the search if those conditions are met.
> 
> The following test script was used:
> 
>    $ cat test.sh
>    #!/bin/bash
> 
>    MNT=/mnt/nullb0
>    DEV=/dev/nullb0
> 
>    umount $MNT &> /dev/null
>    mkfs.btrfs -f $DEV
>    mount $DEV $MNT
> 
>    # 256M gives 64K extents of 4K each.
>    FILE_SIZE=$((256 * 1024 * 1024))
>    touch $MNT/foobar
> 
>    for ((i = 0; i < $FILE_SIZE; i += 8192)); do
>        xfs_io -c "pwrite -S 0xab $i 4K" $MNT/foobar > /dev/null
>    done
> 
>    xfs_io -c "fsync" $MNT/foobar
> 
>    for ((i = 4096; i < $FILE_SIZE; i += 8192)); do
>       xfs_io -c "pwrite -S 0xab $i 4K" $MNT/foobar > /dev/null
>    done
> 
>    # unmount and mount, clear caches and ensure the next fsync is a
>    # full sync.
>    umount $MNT
>    mount $DEV $MNT
> 
>    # Do some change to the file in order to fsync.
>    xfs_io -c "pwrite -S 0xcd 0 4K" $MNT/foobar > /dev/null
> 
>    T0=$(date +%s%N)
>    xfs_io -c "fsync" $MNT/foobar
>    T1=$(date +%s%N)
> 
>    echo
>    echo "Took $(( (T1 - T0) / 1000 ))us"
> 
>    umount $MNT
> 
> Before this change:
> 
>    Took 28721us
> 
> After this change:
> 
>    Took 5453us
> 
> That's about 5.3x times faster.
> 
> Signed-off-by: Filipe Manana <fdmanana@suse.com>

Reviewed-by: Qu Wenruo <wqu@suse.com>

Thanks,
Qu

> ---
> 
> V2: Support the case where i_size is not sector size aligned and so
>      i_size <= nbytes.
> 
>   fs/btrfs/tree-log.c | 9 +++++++++
>   1 file changed, 9 insertions(+)
> 
> diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
> index 47046dd14997..88b6258f2e3f 100644
> --- a/fs/btrfs/tree-log.c
> +++ b/fs/btrfs/tree-log.c
> @@ -5591,6 +5591,15 @@ static int btrfs_log_holes(struct btrfs_trans_handle *trans,
>   	if (!btrfs_fs_incompat(fs_info, NO_HOLES) || i_size == 0)
>   		return 0;
>   
> +	/*
> +	 * If there are no prealloc extents (which can be located past i_size),
> +	 * and disk space used is greater than or equals to i_size, then there
> +	 * are no holes.
> +	 */
> +	if (!(inode->flags & BTRFS_INODE_PREALLOC) &&
> +	    i_size <= inode_get_bytes(&inode->vfs_inode))
> +		return 0;
> +
>   	key.objectid = ino;
>   	key.type = BTRFS_EXTENT_DATA_KEY;
>   	key.offset = 0;

