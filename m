Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DDC036197D
	for <linux-btrfs@vger.kernel.org>; Sat,  8 Aug 2026 23:23:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786231406; cv=none; b=JydlTfPK83Bu1Vq0j5MGH+LY01YjQLhEFTNfP3KoH9KcyzbLUEHENUJQSWV2U1MzW56hI5v7si3Bv0xq4mU2dGO0sz09wIkC3QWXeyiBZi3gwW72pDedC8b9qL/YJkowkd+Ap5tqKGXKKsHtd/F7HFHO+9LB+4vRVCe3g7CyBDM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786231406; c=relaxed/simple;
	bh=NMPbRwpf+WHPd19IIgiaFfGiBszknPrmwy7Yh2HRZaw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=p7qpH90DNM3KQtmrMGcgGB1EitzNew/ONqIaezDJYqi9nViltZEo1NIi9aSY01dX+1bp1NpqI8v66H+Lg9b+p6FDVjPmeHG1iE6XU/hdic75bD7T710x89mPNW9O4/gdWLpS2WcfrrG4WCSdS9/VJ9/RXLnPIdPrOSjb6j1ri1E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=HnbvXi7q; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="HnbvXi7q"
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-4953e04ef16so6779915e9.2
        for <linux-btrfs@vger.kernel.org>; Sat, 08 Aug 2026 16:23:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1786231403; x=1786836203; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=xb8KI5NZ+qy6mkgQgB6uESfrOP1xrh7xuZ+bhAbmfg0=;
        b=HnbvXi7qkHDJ/eR6Q0QJwHQAqTDINVSYY/ICsAbF1GFnORSkQbLohBY1WV9/Ak2bbk
         XVxjx92aaBn8p9lhmxlTZ58vQy0zBhZCUNRB7I2l/wTlc4/4Q3A0rVUfZWDWSADw5c+m
         M/5Ye/saaIXYOl29kgJNv0VOgKh27kRy+XlnTEPT/6HZjoB/TJZIfAjjCzS8rytpQsDX
         vozp2Ae4U4Bq5EAZ7xi+ZItERYVvbTfBLxiAQ7N3lX/5Xi1ZHv328RAlh5tmZpCKagqh
         yVkMjl0ShdwaAuF5MzMeqX5UVOw9ViZDMEz9Ub88QGYywRuu1WfFXqyk4kfz+DGyRljm
         e5yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786231403; x=1786836203;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=xb8KI5NZ+qy6mkgQgB6uESfrOP1xrh7xuZ+bhAbmfg0=;
        b=DAK9vNZIhLxvQdwHVOSULjTGuEl2aXaRGQ0++prcp7YX2eu2z1GccRCpVKJ+oJAdx/
         GkVjlmtfkyDgDC+5/dAX6LMRxeYhB5KLN3IccLp/K4C2rRUSHMQxLC7fSvA5U9yoIIAX
         VXOYm1XS09dOohWPRNXeUD7TxHr2PpMuCO2MbeGmgnfDEglmip6/BSzFzpEuHCr8rysq
         ID18Q9HjwBYATjOrwUyzfkT4hbLTUkmP4jk6vnFw6d8e0KnOzMVsaI+6LZS8rK18q0Yf
         8QsQKtyj9Csf/hw1W3vT65opzV8G8wwcy7iL5U+UmKYLd1tt/RpSbkLLo4ANoexMvfQd
         dlRg==
X-Gm-Message-State: AOJu0Yw9i6qD+k/es5u1hEstUo7/qd8fOj8RUw2d+EXmCr0joTNANu6W
	OFZD46b2ZuC1UgcDHxvHySUJD108MsqtGjypHn/cFiHiVS0TLeyThGPkP5ShSt89oEs=
X-Gm-Gg: AR+sD11DOePXFwiQwYwGKIJqGitj+r/2kbqkLmYVw/IJ9bGj8VhY3Y/7mIxauop1MK4
	CC6gev0Mcmk9ixfoMnHTmwhGCMYs5DbM8yH5tGpI2gRYV4hFxi9eWaDiLYkfCDCHaTVCj7PI39w
	ObUHT814UOhA6H27Vlfuno6tKVVEjttX/UTdj4mE6PPwtNbqHN28KriBWh1D4varSGaDQ2N1czu
	O4l+USG0drHCeIT7Iokf0sdAa0PMAJUmB7Xv/ogMlusbGg+Z9Ig0qR3tFldt7GqxY1016Vgpvoj
	Ge+DXM7iqfsNL9oSX81EJZp8gGt+0aY3NSV4oA/JebxVH41MWOZn4OzJFkScd8daHFo50tQ8n7v
	ks+WHfCM4/CCv34Gt7fkKo/TLDLl6cTcA+7tfDKifljQj+SB1tbkizIoF2qouuJe/xRmDUKQWIw
	TMzHqSs0d63IVqi8hzjzo7uVMuJh77G5effI4eEokReTGK9dCe5cKmN5vrweincKYi
X-Received: by 2002:a05:600c:a47:b0:499:484a:7644 with SMTP id 5b1f17b1804b1-49959e2eb00mr246842285e9.9.1786231403321;
        Sat, 08 Aug 2026 16:23:23 -0700 (PDT)
Received: from [172.16.0.229] ([159.196.52.54])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-14101b95b20sm19777515c88.15.2026.08.08.16.23.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 08 Aug 2026 16:23:22 -0700 (PDT)
Message-ID: <6ca0f838-70c1-4c18-bb1d-3e52b59eddb4@suse.com>
Date: Sun, 9 Aug 2026 08:53:17 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] btrfs: clean up target device if block group marking
 fails
To: Guanghui Yang <3497809730@qq.com>, Chris Mason <clm@fb.com>,
 David Sterba <dsterba@suse.com>
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
References: <tencent_853134544C3CE88A219EEB21346E2510D308@qq.com>
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
In-Reply-To: <tencent_853134544C3CE88A219EEB21346E2510D308@qq.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/8/8 16:08, Guanghui Yang 写道:
> btrfs_dev_replace_start() adds the replacement target to the device
> list before marking block groups to copy. If marking fails, returning
> directly leaves the target linked and keeps the device accounting
> incremented.
> 
> Jump to the existing cleanup path so the target device is removed and
> released on failure.
> 
> The issue was found by a failure-path metadata residual analyzer and
> verified with targeted failure injection on v6.14.
> 
> Assisted-by: Codex:gpt-5
> Signed-off-by: Guanghui Yang <3497809730@qq.com>

Reviewed-by: Qu Wenruo <wqu@suse.com>

Pushed into for-next branch.

> ---
>   fs/btrfs/dev-replace.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/btrfs/dev-replace.c b/fs/btrfs/dev-replace.c
> index 318ddb790..bf0b78790 100644
> --- a/fs/btrfs/dev-replace.c
> +++ b/fs/btrfs/dev-replace.c
> @@ -626,7 +626,7 @@ static int btrfs_dev_replace_start(struct btrfs_fs_info *fs_info,
>   
>   	ret = mark_block_group_to_copy(fs_info, src_device);
>   	if (ret)
> -		return ret;
> +		goto leave;
>   
>   	down_write(&dev_replace->rwsem);
>   	dev_replace->replace_task = current;

