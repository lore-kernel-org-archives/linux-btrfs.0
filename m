Received: from mail-wm2-f13.google.com (mail-wm2-f13.google.com [74.125.225.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D8AE4AEBE4
	for <linux-btrfs@vger.kernel.org>; Thu,  1 Oct 2026 09:08:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.141
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790845699; cv=none; b=H6VtshH+MTbSe4XHQNGRksYWLcAl9LfcSyFk0YDY/51xVEmWrL6lsE1I4hCshQn4yM4iEm9oML4NX/NBaW2D0WmEZBd8gDm65yQ+Ndnz+oJVN7UzPK4dWM9xlTfBUAR9oIJJUjjV1NBCVbxkutdRo16HpyaQxgvZDmh2LpIPwA8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790845699; c=relaxed/simple;
	bh=+gr9N+0n/YMstjEMHs2cI+npcg1r6rkzSzW3+NtgSBQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=PRCji3Udwr0TRnMIg7p6X25QkxYxkJ7vBh9FPKruxzypCS9zc9IrJY1NULolTWnfV9UJiCXRE3+MMz0MFC6W4CP2sjxbVbYgMUML2OkAne8rFRtf/djeTER6xOMR3ClBhxO2h3+DTLMhPQ1AeUnyqItVf6BUBq1Z6h8Rm/YftgA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=R3VVPMvr; arc=none smtp.client-ip=74.125.225.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="R3VVPMvr"
Received: by mail-wm2-f13.google.com with SMTP id 5b1f17b1804b1-49b912d37b6so34934785e9.0
        for <linux-btrfs@vger.kernel.org>; Thu, 01 Oct 2026 02:08:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1790845696; x=1791450496; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=+9cAl0KGK4cnEFgVrPJsbfBt66rTqpNttjVHTgDQgEI=;
        b=R3VVPMvrd3RUggFC7JsKeB8b4Y3gZIcdezLiG/Toj6jQuk5zZg3Mjyp8GubMaGokd1
         AI52SZYjOlVAHI5GUW9Z3BCpQKmx9udnb0OOvxpbmd0LRVTLC2PQwmgBCVZHC/aG4zq6
         LS5DV8sgnfeA8Z06sh1Zf0B+zP4Iqc+SiChXJlBtjAlVlr9YVDQi+eBOLZReQ8j4zKNu
         /FIIyXP1RXT0copnBRS8LpTBwNSbOV4zkrpVsljXLevWJLZDdlhGD95tF/p5c2Pt9e43
         E7TOnTsmn8k+30rekUXhR+xC3vYUOMOILoW7NhefVpiN1Uxi1yu7+uFQ19ziFvuSgSee
         FH0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790845696; x=1791450496;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=+9cAl0KGK4cnEFgVrPJsbfBt66rTqpNttjVHTgDQgEI=;
        b=yZ6ZdK3qadh65TYJ/J5/S3opyLZw89eGyjrlRZwFV6jIphAGIzRI82aRaVpRNDpnS0
         yQ/NzFNfbaaegx7a/E/bh3a3Z7c1XzD7WA1lm2eVUbus0f/PvveRZr8mv7zFD6yuqE9x
         5NqSvy8IAaqdqf6OpJyoeAIK8Y07LHCR0HRA4Arrq2OuMfgMbchSsa4lUzpVLJOUoH0p
         42YtEk02R7Ojg9a80br3NfymT3BmCCKKFgHJngQ6F86x0Sq311I+lg1bvomd7XJIssx0
         tILjHPIUmzOAkF5wyW/2Q2iG+Q8tUy5RxReDCVbIszxT5P2KEp4lrRyQZo8a0hFylHlU
         dhfA==
X-Forwarded-Encrypted: i=1; AKwUvBzRRjGAuyPCuaCI7S6cjTWttMxy/gth4UwyR1PbDEO7OvE401etUn96zjlCgeSo6z1stIyY+chb3+0YzQ==@vger.kernel.org
X-Gm-Message-State: AFuF++lKoqc6DXWonDJ93oVEHXAKTEJu5Q/+Py2FEe/ajOmk7wPJdM7/
	1gaE8Ot2HZFtlCRdofyHDG+PvlvfYCVeGKM5JFWiwW5ENee3/vsSzTWawEVddTl+krg=
X-Gm-Gg: AYBFou2Arv9L4GVk+iDLT4K+NDGk21URAXCIbkIeJmw1q925yjtkOtQvZp7M3wxsLhW
	dfR7/eWzhcL8mVCqr1g7XbeWHjOEbBJ9dmQbGYWTurzxvuKS9EReNoFx5l4FoB6U+6ACrcBuy/s
	88wmbQJMhNR82xxADFnqBjZWSdUys3gwSLoiY7Hn6Y+5vStsL/sO9IlFEf9q7hXZZ42FKkWH08C
	hEbc4N4lt0NpstJMLKvOmqtELFHwZnJTESo0Xdh9gPyBiJhvhAW4yla2zmKZlucsoQrrOQdlkjv
	ubDdozbNKJFxHo1SOnyYUXyoU6Cw6oNGRfwTB0MlE9gyLxYUMaPD6fk6nlfG3ZsrONLeLcgf7Q5
	8K3jwwzra+tgyQFulRsGIrmDm4HUV5ExY/IWslSzgbfK/PZch+OV3C2iF/A/BOCSvTRO+heZEvg
	vtURAm8CQFEzyxZtXtMg1T0sIXDrcqwCguwnZJT3iNwF1CLiB7+Uu9O29p7XBTzw==
X-Received: by 2002:a05:600c:628b:b0:49f:fe7e:dc61 with SMTP id 5b1f17b1804b1-4a01ab4e424mr65524745e9.0.1790845695604;
        Thu, 01 Oct 2026 02:08:15 -0700 (PDT)
Received: from [10.86.128.19] ([149.22.87.44])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a4f43720f6sm3419232a91.3.2026.10.01.02.08.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 01 Oct 2026 02:08:14 -0700 (PDT)
Message-ID: <95cca09f-70ca-444a-b8c9-a1f6af81fac4@suse.com>
Date: Thu, 1 Oct 2026 18:38:11 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/3] btrfs: remove unused arguments and code in
 block-rsv.c
To: fdmanana@kernel.org, linux-btrfs@vger.kernel.org
References: <cover.1790783086.git.fdmanana@suse.com>
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
In-Reply-To: <cover.1790783086.git.fdmanana@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/10/1 01:17, fdmanana@kernel.org 写道:
> From: Filipe Manana <fdmanana@suse.com>
> 
> Remove unnecessary code and arguments from a few functions in block-rsv.c.

Reviewed-by: Qu Wenruo <wqu@suse.com>

Thanks,
Qu

> 
> Filipe Manana (3):
>    btrfs: remove fs_info argument from btrfs_block_rsv_add()
>    btrfs: remove fs_info argument from btrfs_block_rsv_refill()
>    btrfs: remove pointless qgroup assignment in block_rsv_release_bytes()
> 
>   fs/btrfs/block-group.c   |  5 ++---
>   fs/btrfs/block-rsv.c     | 12 +++---------
>   fs/btrfs/block-rsv.h     |  6 ++----
>   fs/btrfs/delayed-inode.c |  3 +--
>   fs/btrfs/inode.c         |  4 ++--
>   fs/btrfs/props.c         |  3 +--
>   fs/btrfs/relocation.c    | 13 +++++--------
>   fs/btrfs/root-tree.c     |  3 +--
>   fs/btrfs/transaction.c   |  3 +--
>   9 files changed, 18 insertions(+), 34 deletions(-)
> 

