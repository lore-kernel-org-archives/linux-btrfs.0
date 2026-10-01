Received: from mail-ej2-f41.google.com (mail-ej2-f41.google.com [74.125.228.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78CCB3EB819
	for <linux-btrfs@vger.kernel.org>; Thu,  1 Oct 2026 09:05:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.228.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790845525; cv=none; b=PZtD9W59qqClSgreI+GTHvkDMAbW7gCUhrMcA3U2GTS9ZgNYaZn2t4oQvIA4lHa/cnIw0dVZqB2NqUFXB0oZJnpjCssEVFkXBvfPET6JD37ziFD8BLjm2aZmJe5lIqbpPbTkBwjIckzdaAQD7IwLaUPMDTmbWuqi5gAbxyV6I6U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790845525; c=relaxed/simple;
	bh=fNTh46ner8LWLwW7E2vqLpKQujKaZ/KjqpqK4mdy6J4=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=XVyeFpXSyPlP3Y8ZzJNBO4m7C/k5niul7MHJhyHvkTrsVCvAFoF+Bgb98/7Xvf7DYcLRh0HOChuYI9DHFPbvUaeEQhfartCGBLyH2yW+axKkUUiky2rp6qtnh8Y59pARguF9FJaUGq0R3oFEiT3++DaY8WHR9lMGMPqKkUHkE78=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=V9UUHaUN; arc=none smtp.client-ip=74.125.228.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="V9UUHaUN"
Received: by mail-ej2-f41.google.com with SMTP id a640c23a62f3a-c2e0f2c945eso266506366b.3
        for <linux-btrfs@vger.kernel.org>; Thu, 01 Oct 2026 02:05:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1790845523; x=1791450323; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=xSuZoWtSZH3B1ewIN5Hf3UN7n5JDVlDW00+TCHIr1Ug=;
        b=V9UUHaUNQzphLfZrPQzHm5j7RFAsm4L3He1UWdu8zO794lZ9LtA5BlVaPcFEVXWknn
         7FKHHo5Y6iW9Cr7ymwYTh13DEzIzbQGL6XAwY0ThYi8qNA3jU8GF69XwdvUBbmBttbzb
         8teAedyYK7R8S2cb4xFH8qQKiBFn/OV5IvaiEx887P01sb7jExsqpTmWk0C5p/7aEVjP
         HF19IK0xkiCtzvBvHGbRrx4pNX8MwK8AlvkRMvNUxnx5yNLMnqDvcDjvAfeRGGxXl3Zk
         1tM54UjoP5a89hp3ltm9VGoh+zDr3nfCtE6dDwSxi7EIdVwTdFuW18CywahOMH/RlRfb
         GAGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790845523; x=1791450323;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=xSuZoWtSZH3B1ewIN5Hf3UN7n5JDVlDW00+TCHIr1Ug=;
        b=gQN/NPI0NRxP7FNpT2IK8uImCku2k+1JTTmK3z40vHdORySN3EUCUrN3j9nXREQFSR
         3T4kfgsmkCBM4LeeBj9xjh3/iPLEHwxrSgZvmOjmIGLMM41fAJaoPZOQ+Zr0Ozbd0b1M
         RSPy/ICkUo5UqzEgKXGYgMX2kompu3FNduYPAOl4C6zjC15kIRa5QCG2THJcS3bZ+N8H
         xRF2qbfE+7hSdt7PYhpL5MeFBTHZsh/OQuumlPUNFN/rgypgOiVFDKq+wSI73L7Qzy7g
         uwa8YxLuTlBwJgYzMXtKRSEVPj/SOz/xQHXfvBnmBDQAmX07HBxvK0gwuzaJ3nZRexdY
         27VA==
X-Forwarded-Encrypted: i=1; AKwUvBy962/bl6NI+vSpK05d3C49RWMCUlEYrPqRn0dv3ufd/idqva2qogAKXm82scBqOxr+NDTg58LXfv53Eg==@vger.kernel.org
X-Gm-Message-State: AFuF++mRUOjkNIEf2hiXObC2s9Nn/tIb/cgY62uGTkBtk7S4gMz/oq7Z
	jus6DaqxjDb1Zh/l8EGOOoFz/RJ3XlLIXuDT2M+A2I6oixh0HB0JtfnaioZC9aXkFBw=
X-Gm-Gg: AYBFou1jMo9ZTcA2C1srVLflydQceW+b3lnz6on9FGc/CQGVDgrbuWu7M5m0T0YCaSJ
	aLdf6L5Nz3l9YEbCdKH9+eS+qnXXAbdmysfbfydCpw/bLJNxCEXpdinkhvt5myFwINC6n2/hUNn
	0GkYz2GwH/BIfEUvsyGLSCTqozwzM1l/bVpIU31XqoOd23X7xqvFDKiP3NSZYXO3hTWSlK/w0yF
	R7/1RwkMMq+hirkh821DMFtKPMmhJQN3xVc2gJKrCKlc5fUrMhNQKSrVdvyy9P1dRtXNqGJ3mDD
	Dte3kgdDWj1gSuX4scV8exW907P2XpBt1BITcd29hqvGpu/tThyDny9Q42hWVOPmxzYVPq0fnLF
	RvJECXfIwiD6Cd1sCW/6tkCdijpBt3v3lcnM11Q5TBUP4AfT2Ydyto5zV7iyckqDd2Xb6k+Yfx/
	srd2wepm5O6HCreE8aVbzZvuOyRBR7qoiG1hSzAaVpNxSR/96ogJALZrquLf9QiA==
X-Received: by 2002:a17:907:e00e:20b0:c2e:2720:8f74 with SMTP id a640c23a62f3a-c2e27209337mr216791266b.28.1790845519849;
        Thu, 01 Oct 2026 02:05:19 -0700 (PDT)
Received: from [10.86.128.19] ([149.22.87.44])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-88815996973sm784457b3a.6.2026.10.01.02.05.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 01 Oct 2026 02:05:18 -0700 (PDT)
Message-ID: <7f63da46-e755-458c-b846-e5d555eb5169@suse.com>
Date: Thu, 1 Oct 2026 18:35:15 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] btrfs: remove unnecessary forward struct declarations in
 volumes.h
To: fdmanana@kernel.org, linux-btrfs@vger.kernel.org
References: <0be3914031faf9bf34dd86daf884e42f7352d848.1790785074.git.fdmanana@suse.com>
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
In-Reply-To: <0be3914031faf9bf34dd86daf884e42f7352d848.1790785074.git.fdmanana@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/10/1 01:48, fdmanana@kernel.org 写道:
> From: Filipe Manana <fdmanana@suse.com>
> 
> There is no need to forward declare the structures as their definitions
> are brought in by the include of the linux/blkdev.h and fs.h files.
> 
> Signed-off-by: Filipe Manana <fdmanana@suse.com>

Reviewed-by: Qu Wenruo <wqu@suse.com>

Thanks,
Qu

> ---
>   fs/btrfs/volumes.h | 3 ---
>   1 file changed, 3 deletions(-)
> 
> diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
> index 337d7007d9e2..6eddda239221 100644
> --- a/fs/btrfs/volumes.h
> +++ b/fs/btrfs/volumes.h
> @@ -24,9 +24,6 @@
>   #include "extent-io-tree.h"
>   #include "fs.h"
>   
> -struct block_device;
> -struct bdev_handle;
> -struct btrfs_fs_info;
>   struct btrfs_block_group;
>   struct btrfs_trans_handle;
>   struct btrfs_transaction;

