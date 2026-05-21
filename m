Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 685B3356756
	for <linux-btrfs@vger.kernel.org>; Thu, 21 May 2026 22:14:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779401700; cv=none; b=Kz/M4zqhvIkqp8NZOeaai9Ownufpv4yGd8h08k6TkLWWrQaoStvvLo7fG3UmFyrzfH8ET/4iMMqthY5vRzY6ocFEZ/el98aL4WrXxX9PnsKaNbQk1ZUxEKTdAWf3c/8qfUW7Bo3ZyIcjVQb9kP1bDu9QaJ5qijcxxwxpbcyrxG0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779401700; c=relaxed/simple;
	bh=Vr+oduJ0XCc+hL/PmwrsLNg4Pnx8nW56YcGiqQ30eIM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=t+4fuU3h4fZ+QZZP0Qi5Dx6dRdV/cs465nfmkelxZRUdHHy+ToXgcnPtFERtzwZSa696u1e7qp908XisOA9JhUvvimii+B4h8UcGHMD/ecGV2neSEUXv/wNvKqOIByXs+ULlEv7n9pPtBKZy+X5MZpdVEhJkIoW28m2Cx0EFXqM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=gpDd32Ee; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="gpDd32Ee"
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-4891c0620bcso42674455e9.1
        for <linux-btrfs@vger.kernel.org>; Thu, 21 May 2026 15:14:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1779401698; x=1780006498; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=SWkc8wmyZt9nypiNJuKMnuiZtgkKQD6i8cPiN1wqmXQ=;
        b=gpDd32EelaPPuknKysaivYb6c+xA41//va0GLMyC/W9eeRXC3tiR0B88JHla8GPaDx
         ah2K0rmYM+2r2S+LiIYIitotZQGWtu4cgJlG15jSP9Tdr/d3s1qou22JcCzWP6C2SIU3
         0SAq4FfQ41m/cw0b9u8eBWlFpThzCkwUgAQOMbVH4QoND3oWhTVHRfrIiVpA8xPUdq+p
         vaKIeUmV24hqUKNacV3+/QeLydfp6HQbWhYX8t2acOro2Vyb5NBUvttX2HV09qr1osAF
         ZdO7mCya40dP1A6VBqKulluLMgC94JzthcawiCkXAnPnRHhp82d6nflucJo79CVJN8SA
         48+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779401698; x=1780006498;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SWkc8wmyZt9nypiNJuKMnuiZtgkKQD6i8cPiN1wqmXQ=;
        b=YlghFDjoP5Jq+BieCfSKrLkbpxwRS8F9OdKjuGfzaS6I5E7x70zdLE6T2oXR/djU6d
         YLToeKNxSUL3fyGNa53Ov3LBqOVB4EsLLstaD68SGzyGfsOYNKYCGaFdoZtLsbHZljqy
         waTVgSYdFpeM0Xm4kaAK8Ssbb9POB1vcE+5kFTePFssAkyFcuWQJzqL3qlaX+GVyAkog
         M6K5WuGI3KmRUZa6d+1GNQJSawfRLFHf4mqSAY6S3nf37SbPSzW09OjWAN/F52Ee5CSE
         X8CPHV/ZflcyrC7yaWCracY4CHHlXS1GHhsamDaa8zoG3s+N/ZuSCTE341jJld5Ivz2v
         MxfQ==
X-Forwarded-Encrypted: i=1; AFNElJ/UObRsIpNPYMwkUJo2iGm4J9OcrLqeD/MD9Pw7OIOXbuVncH6YeZtp9GZ3WZl7iYKjOR21ozgMDdyv3A==@vger.kernel.org
X-Gm-Message-State: AOJu0Yz/G60D5vubKSjzZKFt+vanNiZrkSP9WeXtGlHuqBPzX15E9SlJ
	Utih8Etg8/6RTZOVCsm5tFDWlWPU/ngCxIpv8rCLSWvEltfXS8kfv7JcYRki9hpTqww=
X-Gm-Gg: Acq92OFZQ2XhqO/05mS7Q1b19sC4dApSYZ7orrlmggcZQVkl5vGm+/5f0ix73HHSmt9
	6EnvisavNxunz0za/KaeGuHs+STbFXocsNZpaqxRaMTbXcelSOFQdEuZyvzC4+gpnZtlFigbTCK
	8+2d8hFae0qqxOZhnyshHIZVgQ6c/PiEDHdeioTQ7UpvIQaAJf24qqTHOnk1O0a4bgLV0+5HYgu
	imHxd8WNWpBoadHnYFGPpmVk8Pir/zBOnXKVouZDF/Jfi/6meLEPGPoA1MgmBbXiktTrMP8Mq6k
	fA8lcUQpJddbarmH6m3Z0WYO5GnS/aMHJm1P5ORE1i88ZnZ8DEq6ZN+fkgbOSMdC3Sq2JvhRStT
	TreiwpSyOenZgEvW198Etdrr61Sl2+mm5Aq271AFgDZVEDVRc+rFZW0wCqNrVT7+yyPUI5a2Wx2
	GZ1K61Hr32lIBlF+q6uUe9alC8oAhtVGR7fOPNgsTVSwIPKSI0NTdfmEHuMddJyLyCyvRvDlAzc
	bks1gzoEBA0PWeP5ciaSdD07L108vdrnu4DU3yXmSdUaTRxFX/YNWDMXA==
X-Received: by 2002:a05:600c:8599:b0:47e:e2eb:bc22 with SMTP id 5b1f17b1804b1-490424ac8e2mr5081245e9.5.1779401697867;
        Thu, 21 May 2026 15:14:57 -0700 (PDT)
Received: from ?IPV6:2403:580d:fda1:0:2bb5:f164:6e6a:38d8? (2403-580d-fda1-0-2bb5-f164-6e6a-38d8.ip6.aussiebb.net. [2403:580d:fda1:0:2bb5:f164:6e6a:38d8])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2beb140a985sm2181695ad.81.2026.05.21.15.14.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 May 2026 15:14:56 -0700 (PDT)
Message-ID: <89630748-76b3-4c63-94cd-b7d398ee73bb@suse.com>
Date: Fri, 22 May 2026 07:44:51 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] btrfs: protect sb_write_pointer() with invalidate lock
To: KangNing Liao <lkangn.kernel@gmail.com>, linux-btrfs@vger.kernel.org
Cc: clm@fb.com, dsterba@suse.com, eadavis@qq.com, linux-kernel@vger.kernel.org
References: <20260521122945.524890-1-lkangn.kernel@gmail.com>
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
In-Reply-To: <20260521122945.524890-1-lkangn.kernel@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/5/21 21:59, KangNing Liao 写道:
> sb_write_pointer() reads the super block from the block device page cache
> using read_cache_page_gfp(). This has the same race with BLKBSZSET as the
> one fixed by commit 3f29d661e568 ("btrfs: sync read disk super and set
> block size").
> 
> Take the mapping invalidate lock around read_cache_page_gfp() to
> serialize the read against block size changes.
> 
> Signed-off-by: KangNing Liao <lkangn.kernel@gmail.com>

Reviewed-by: Qu Wenruo <wqu@suse.com>

Thanks,
Qu

> ---
>   fs/btrfs/zoned.c | 2 ++
>   1 file changed, 2 insertions(+)
> 
> diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
> index 16dd87aa06f2..5f75cf0e14b9 100644
> --- a/fs/btrfs/zoned.c
> +++ b/fs/btrfs/zoned.c
> @@ -131,8 +131,10 @@ static int sb_write_pointer(struct block_device *bdev, struct blk_zone *zones,
>   			u64 bytenr = ALIGN_DOWN(zone_end, BTRFS_SUPER_INFO_SIZE) -
>   						BTRFS_SUPER_INFO_SIZE;
>   
> +			filemap_invalidate_lock(mapping);
>   			page[i] = read_cache_page_gfp(mapping,
>   					bytenr >> PAGE_SHIFT, GFP_NOFS);
> +			filemap_invalidate_unlock(mapping);
>   			if (IS_ERR(page[i])) {
>   				if (i == 1)
>   					btrfs_release_disk_super(super[0]);

