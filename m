Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1901A3630AD
	for <linux-btrfs@vger.kernel.org>; Tue, 11 Aug 2026 05:26:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786426005; cv=none; b=hlq6XMU0GZTiymXFC+RRRewvEYfgVrpPXZCX5Tlqf9DzKbujrDCdoFyLRYwAHrBLxyf1QasXC1slMXAWe+wDsAxGS3ZRfZVcof8tGQKeVQvjvBzX2jpsHKD8/OqMZt0dnOhZu07MsbFf/cJVXMK1MBFwFX6243N2zArYry6tXCI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786426005; c=relaxed/simple;
	bh=zwzYeJdNAHKmQoAkUDfDeX8vnWaAlCEqC+grZ4epPRA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=nvuOM0Eyu1patKxvbQXpAsc/0fhLVGK8vwZ35aMQ4RHegWd7o06t6oDmCmc1ZU7fFAyfdS+1zFK94vIgEjOcn9v5hLsbbDtPRIxWQyvyloS28kbnoedZUrpqnjXp71xx6hoQ3qGWJwMJO12a1djmO51lSDw1Oa8GAL5ZlpB0KN0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=Yosalpi7; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="Yosalpi7"
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-490cf322ed0so18676665e9.1
        for <linux-btrfs@vger.kernel.org>; Mon, 10 Aug 2026 22:26:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1786426002; x=1787030802; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=lH8cRz+tE3REjPyJovT/lsbG4KfwF3xXHNXQAPHS5QU=;
        b=Yosalpi7qlam7E6An3MzIp8l+TYc+cimP15sv6DsQlbtS/L0TaZYouIVZ7RayJjSuR
         rYiMTiDbDiXMSGSxC4iS3xHvFIyjTyUDDXI9ivg3R5vpj8K9LwNdniAT8wW88d6MhYjj
         zThDCCJu2bHWZsARNG/ttq2KN2cYOO8K4dH8tGkSqSu2b8nIw3QvbZBX/+OHl46kwJug
         0jWntOLq3ULUmtr8OR1SVqhTwZrtxeBYzAt/YclqkfaPa/FPSROJvb9KDKp39ecbGQXh
         6TKHj4a0ZPZ+fDsgoJ0O3whHM/EBSkxVgDEIQsTBUgb3oiN4skyAzXnxSZ7rycyqY1yF
         CCrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786426002; x=1787030802;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=lH8cRz+tE3REjPyJovT/lsbG4KfwF3xXHNXQAPHS5QU=;
        b=FobHvNJYknUS5gD9+kaHqlz7M4i2CTGs2kFVmfqWbr/T03jMPFMi8OtVSa6XyZdKgs
         NVaELfwYuG/wSyEc5ede8IkhAGa6lgmgSsPFeqpTg+Ny4NtV/uFbttOjnDBcqGg1Peib
         V2EViRdUVlgWg9iBUBiv2Hj/cnmpUZO1aI8mElh6YyCbGxndxVfQsplU7bhTIgyzx1mq
         3iant1e62tJGuK0D+RKoyg87O54/Qc+vGfcCIpDKKh+K+W1zwKfXMEjpuIiHyXo4c/xs
         NORFiBfglE5maT/s4+N0ywen8Ir2SXh+L0EM3NwbSmBRg4ucfOTOdDRLq5u5bWMZ/haU
         7VUw==
X-Forwarded-Encrypted: i=1; AHgh+RqjR6wlBYp9AGIN166yXqiEMc8lNUxnoGvnS5vA1T13J7BS746r0pIwWOJEfAdpn0LkG0RuqUiJT5y8AA==@vger.kernel.org
X-Gm-Message-State: AOJu0Yx+B1sHywF46KoYyNF4dkqTg/dCyI/fe0R9jgD00sgI4MSr2Wee
	y/iPe1Rl1mJ9UmpW96u7nFPXad/zd0lD2tIndkCNqv0U+XSiJq/sB+6XBr8ykUru7m0=
X-Gm-Gg: AR+sD13PM+6hKjVG2Z2eeOuSFnTNVQH4tQKSXuYZnby01fThCV5BalQ6b8dUo+v8/QL
	+aU5JeKfaGOXmJA0L+G3h0IC05HpXqmI56CZCJHYFa9x3d5ofAndEFCJaS2ZFzhZzzcnwA5meOr
	IsXVbzBZb2gU3yYAYroUMu8kizjU3X0aQ+YWnSTAlYzLvvX4JxKi66dT3kqRgPUh/pw1JTx53jO
	N3sz1JOcV8Ttj2N4/LxI07eA6fOGamD8GDf7C/XbVXygAepaRAaJEwBa9wj+2YPV94PF5/+y3uC
	rl34832OtPQ2hW32hbkCEDWxL+rLWHRVLVzQskr0THwu5xZfRjg0HeISKmJlcAyzc3Pc5k3mIiF
	nk44o/GHbU+ooue60aJQOXKjbMnPNXtO9TzoAG7exWJeRMZrBXBQyIXUXfL6NDb8ddqmtMxkcBC
	FfIf3i8cHJ9FpMU4zN08NeVOhgKmt/JhhWy8jh6rqWA4ZiHoYs8iWFrA==
X-Received: by 2002:a05:600c:4f52:b0:498:2b1f:e0c6 with SMTP id 5b1f17b1804b1-4997847121fmr10536665e9.18.1786426002288;
        Mon, 10 Aug 2026 22:26:42 -0700 (PDT)
Received: from [172.16.0.229] ([159.196.52.54])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-31c64926d53sm758419eec.23.2026.08.10.22.26.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 10 Aug 2026 22:26:41 -0700 (PDT)
Message-ID: <2f553156-4db4-462c-a196-edbe13a13799@suse.com>
Date: Tue, 11 Aug 2026 14:56:31 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] btrfs: send: propagate errors from is_inode_existent()
To: Avi Weiss <thnkslprpt@gmail.com>, David Sterba <dsterba@suse.com>
Cc: Chris Mason <clm@fb.com>, Filipe Manana <fdmanana@suse.com>,
 linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260810094701.1349706-1-thnkslprpt@gmail.com>
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
In-Reply-To: <20260810094701.1349706-1-thnkslprpt@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/8/10 19:17, Avi Weiss 写道:
> The direct-return refactor in commit b3047a42f55d ("btrfs: send:
> directly return from will_overwrite_ref() and simplify it") changed
> will_overwrite_ref() to return directly instead of going through the
> common out label.
> 
> That resulted in a negative return value from is_inode_existent()
> to start being converted to 0, making lookup errors unable to be
> distinguished from the inode not existing.
> 
> process_recorded_refs() expects negative errors from
> will_overwrite_ref() and aborts processing when it receives one.
> 
> Return the value from is_inode_existent() to restore the previous error
> propagation behavior as it was before the refactor.
> 
> Fixes: b3047a42f55d ("btrfs: send: directly return from will_overwrite_ref() and simplify it")
> Signed-off-by: Avi Weiss <thnkslprpt@gmail.com>
> ---
>   fs/btrfs/send.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
> index 3ae480c7474b..a888202397ed 100644
> --- a/fs/btrfs/send.c
> +++ b/fs/btrfs/send.c
> @@ -2066,7 +2066,7 @@ static int will_overwrite_ref(struct send_ctx *sctx, u64 dir, u64 dir_gen,
>   
>   	ret = is_inode_existent(sctx, dir, dir_gen, NULL, &parent_root_dir_gen);
>   	if (ret <= 0)
> -		return 0;
> +		return ret;

This behavior seems consistent with the later lookup_dir_item_inode(), 
where if we got ENOENT we just return 0.

Are you sure if we want to return -ENOENT in this case?
>   
>   	/*
>   	 * If we have a parent root we need to verify that the parent dir was
> 
> base-commit: af5534fe2fbc006e83d75d6283dfc5ec75d5d780

