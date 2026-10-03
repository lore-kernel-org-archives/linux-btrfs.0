Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9E5E9463
	for <linux-btrfs@vger.kernel.org>; Sat,  3 Oct 2026 00:18:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790986735; cv=none; b=S0ZlI2DCiWe/5iincrjGh1TIjMKG27fpmeTGmZln3O4/GWchKmfoMZeO+Hp239I73CfR5/qOA7ohD3Ht3sR8XOtstEwQTf4KCu9TVJlRAmkqeSFRFX2ad2ioF+Pno1TWJQB4KbASIIgiB1iTk34FlhF8pjkfLgg6h7c/KKQBuvE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790986735; c=relaxed/simple;
	bh=h7eVczktD8YOvM6mK3qFm/QymqolalPJUNIcM5J8Bmw=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=AfP7FuPgFf0LD7OZKp8GiImOs9Zot3R+Id1jlgphl+2oJjhdcnkrILbncFUrdi2pX+q7Qi8XBojVvU1eDzNnWP+Lg8alYGUXz50trLKSxo9f2VAYN4wOh8hpBazw/yLcF8XdEYrdOPdkXKR0lBDjwZhlO0TC55qOOXRD3svAahY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=Vo7Sl5gZ; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="Vo7Sl5gZ"
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-4a140e7405dso2888875e9.3
        for <linux-btrfs@vger.kernel.org>; Fri, 02 Oct 2026 17:18:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1790986732; x=1791591532; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=UlnDw98nBaklWUuhXACv4gI0qjlOT2DBUCKtr6D602o=;
        b=Vo7Sl5gZ4fVo6hfiiokE2bTthxVVctk0BYA9AtjOK0uYtqZr7XYMhmYJYjXfbWGhYi
         a/SlAZvVsBIIkxmYfKJ0BRzG7nugBlsO3IRrqgOw2aevsQI5Mltv4HO1r/9CprC95rrF
         huirkQrgkiL/HDPWFjpCrD83XaN9drBaZ8kkCGtSsBZG6xeiJwpuJwuRIzxiL4PN44Tw
         f+WXOs1jFXFZA9hSNUhvoUQ8zM1e8BkSlSih8oR2ah5UxWrYSVvlugVeQblYzj3535G5
         hiYYCG49wl9j698J1hTLuEynRWX3DC2NceuetfB2Y2QbWposaKZANmAyJTp6oDR97Gjv
         Q3Qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790986732; x=1791591532;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=UlnDw98nBaklWUuhXACv4gI0qjlOT2DBUCKtr6D602o=;
        b=XM/XzA02Dzp5WPmqaasVgJ9gNiv6jSHClnIGiKMUmLP/hRZduiHByFIa7Kaia3La+J
         W/WcEt+dAyE4OlMtMaodmOumIaS8Dzcz2uEBJGJcSFdqAR/HBMZ/pPmBzRKWIckdKIIC
         uWc6bUsjYPkqMxmH/EG7dIKbSdqXb1LDQg1GbgEeHaswWgjBTO7SnQ0XYvFYxsudhT+H
         hJ7srHltGBFl8KeT5JGEYYlisHWdzT6aAOWHhQzw/SBvRgqdgvfUu03tm7kC9POU0lAV
         atQEl2f42nwAqrFBCzTuYxiizUEdt/w90/ksg6q930aO5rry/N5A4XPj6cqcgA+5zFpq
         i/7g==
X-Forwarded-Encrypted: i=1; AKwUvBy08+1vfZHaptTq1gqV0139gvx2Zax1f25O2cGVmK/WDeIADQoYzAmiRu5DdxRQg/jpiEfuVBLhFYlSaQ==@vger.kernel.org
X-Gm-Message-State: AFuF++k66FememQcL1GsszQt0IuMr5Be4sXwJFK23CvYBVbxBjzFmlet
	8Micf2I4gWr8nKG2VLYtgnDWApTZ7IKLDZAq6OtbJRCrWykjd8X+/gBuMXPISVuJOB/T7lZOPY5
	vxcwhs3oPXQ==
X-Gm-Gg: AYBFou10KMw8sQ8O4eqQ4u++10oUTopn5it7XUPxbP51m1eHIthR2Gpcv12JYCBn3r4
	WJF4irpg97Kjf1H2JP+Q8Eoh89yPg/NcgvbZv93Vh3as3hdh8o2kBKddnfVz4vADY6ahAzzUle6
	qhGtvfKGZvpUEGW5XoSgsOhRd7/CgbWab4FTxo+R8Ym4qurOkXgTymdlqe/GN3qyA4Co0GBZ0QH
	trGXfFY5ihtjE35qmV1az9V94ngk5IjyG+loaHELFEknsjSM/bBQvyFHZjsIVLBnSCdJKU4TCoW
	wB+0EClDbjQFCiUtMf2wEgUQO7A0PlB6+bUzInM6O4zuRO2HJfw5dFD9GC9OS0ychws5cvq/Gvh
	K43VHYHXxXKpCeDZOyEhkr4AGCf0L7+Eyd7n0iO1M/gk2X7twfa490R8NxkUe4ThHvP1bWITlc6
	b/XIlSSA+Uzex6ELFmpmDwUo0xQmGmid7+aDUut4hVhPA/JJKqviM2OFbDTBqrboA=
X-Received: by 2002:a05:600c:3155:b0:4a0:168f:d962 with SMTP id 5b1f17b1804b1-4a1680b9cf4mr11050305e9.3.1790986731807;
        Fri, 02 Oct 2026 17:18:51 -0700 (PDT)
Received: from [172.16.0.229] ([159.196.52.54])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2e49f6f650fsm12770925ad.58.2026.10.02.17.18.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 02 Oct 2026 17:18:49 -0700 (PDT)
Message-ID: <8b310b99-6d74-40a8-8164-a83731902f4c@suse.com>
Date: Sat, 3 Oct 2026 09:48:46 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/6] btrfs: qgroup: fix swapped blocks existence check
 when tracing after COW
To: fdmanana@kernel.org, linux-btrfs@vger.kernel.org
References: <cover.1790967259.git.fdmanana@suse.com>
 <13d832272a848474d479cd21f6d3f3f6eff54bc6.1790967259.git.fdmanana@suse.com>
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
In-Reply-To: <13d832272a848474d479cd21f6d3f3f6eff54bc6.1790967259.git.fdmanana@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/10/3 04:25, fdmanana@kernel.org 写道:
> From: Filipe Manana <fdmanana@suse.com>
> 
> In btrfs_qgroup_trace_subtree_after_cow(), after we erase the swapped
> block, iterate over all possible tree levels to check if we sill have
> other swapped blocks. However the check is wrong, it considers that there
> are other swapped blocks if any rbtree for any level is empty, instead of
> not empty. As a consequence we set blocks->swapped to true basically every
> time since we always find an empty rbtree at least at level 7, since in
> practice it's nearly impossible to find such a huge btree. This makes
> every future call to btrfs_qgroup_trace_subtree_after_cow() do an
> unnecessary rbtree search instead of returning immediately.
> 
> Fix this by updating the condition to set swapped to true if we find an
> rbtree that is not empty.
> 
> Fixes: f616f5cd9da7 ("btrfs: qgroup: Use delayed subtree rescan for balance")
> Signed-off-by: Filipe Manana <fdmanana@suse.com>
> ---
>   fs/btrfs/qgroup.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
> index 46de0a5e80d5..798f21608de5 100644
> --- a/fs/btrfs/qgroup.c
> +++ b/fs/btrfs/qgroup.c
> @@ -4913,7 +4913,7 @@ int btrfs_qgroup_trace_subtree_after_cow(struct btrfs_trans_handle *trans,
>   	/* Found one, remove it from @blocks first and update blocks->swapped */
>   	rb_erase(&block->node, &blocks->blocks[level]);
>   	for (i = 0; i < BTRFS_MAX_LEVEL; i++) {
> -		if (RB_EMPTY_ROOT(&blocks->blocks[i])) {
> +		if (!RB_EMPTY_ROOT(&blocks->blocks[i])) {
>   			swapped = true;

You may also want to update the comment of 
btrfs_qgroup_swapped_blocks(), which is also showing the opposite meaning.

Otherwise looks good to me.

Thanks,
Qu>   			break;
>   		}

