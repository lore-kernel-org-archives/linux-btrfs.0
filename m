Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22EA223507B
	for <linux-btrfs@vger.kernel.org>; Tue, 28 Apr 2026 05:13:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777353219; cv=none; b=WbfCaHWYQ74o3h1eRygz5Vdz4bVZOReE62WmMrMuE6RxVNUJVKKvSlRSisYiBNBlIS461vxUhgCwUxptRLkDLw18s8ZRXpG9aapoZws8WjMV4ebDetIabA1sWXNziDpmtylY+7Im9IX1Bzi2RZ0Gjmp5/CljlmeAy33KifP8tMg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777353219; c=relaxed/simple;
	bh=t18favkcArfo5RMbdWpDKm0MOqhxyjTWfH8Cw0Cr/qQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=ESB6G5MsDckRlK26MabYbqgQ9sTFeJlAnNFS/ofNMJzH6+0LfTi4MEEN1tt0Fg7sNHXLyOs3R2UN6OWPMH3IMyMvguIaQP71Uw8RoOsbJ9SK8h25eApXSxDzmtP9YBmpsodEzTjmpWQCT1AIrIb2dxOHuC352uizue8ZWiFY5PI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=XaK+DI84; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="XaK+DI84"
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-4893940bb5eso57838115e9.3
        for <linux-btrfs@vger.kernel.org>; Mon, 27 Apr 2026 22:13:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1777353216; x=1777958016; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=Jot7WehTtE1Ey6ybYKYk8mR1OVdGB6hViA8vy6VPCvQ=;
        b=XaK+DI84hITMl9VzlAEsJ8cYhH5cFioVsuRrd+3k1VJc9PGjW+V2bj0G2zmQ+TtS0F
         BjMhQNgW09Em7Z6xftckXeMehNGOW58AlMfro8YcHUhwyhKFY4Wj4ONNELCLpuqQMTwd
         8zR+3PDPPy8fFM/8ynJEUoUt41atx9HAG/5vmyPH7q/6IBMbM96zpjUWqyVIO+MEAxSv
         4q+R5qtdz/wMnxRx9RDMzpSIs7QgMRRng9OME/9nFNiKZll2cp8/6HPxJVy/gZtKYqIV
         8MlO6nAROBiSeqhAWzw5p1elroTLoJsLyFjwMd2JEcGsOcaCIh3e8Zpb9mYBxWW6tzPc
         TjEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777353216; x=1777958016;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Jot7WehTtE1Ey6ybYKYk8mR1OVdGB6hViA8vy6VPCvQ=;
        b=sVcvIN7iXOpFW2yYpLa6t7+Ngt7FYipr7G0WWkR9WAAWrZc707dinu9vFDTLmlkPpf
         yMYT/b2I6a63S+2m5FTXajKdAgy56HlZUL0GEbEC0fPxvqY9GDtD/wXVfpRKUxV82lsC
         O1bOmy7P7SKyHLM5MF21HKTrflFwqblsZoTQq9CHkND62t0X6ai6bOFn80kmD877m62B
         S4e9noOkJiRJq5fVbDV3UxafHlPZCjxUD81kMqHXD6daUOSoVocOXrUswYM4d3OQixMg
         YHkJXeIdsm1wBUYPZQ/cXft4dsXnTIRSKDrEgpieDdHn45MUhz/q7B2u3Yh+lrWkGO3l
         tnNQ==
X-Forwarded-Encrypted: i=1; AFNElJ/5XWuY+wfG5b54Q3LNWI0koW2CmWug8QK4wnqz3ce79N7H8OkU3BtlAJglMEQpoTlVlQjdo9kwkvpJkA==@vger.kernel.org
X-Gm-Message-State: AOJu0YzDqc4ePdupps/7cKAbCA1NR8FMLFJujmMb5JDXIGtg5XCtvIYc
	Wmglo+lEat2H+TlF8X7ZIrYEsmwirhuLK475Faf7Z8/Y/cMarGiEw6drVogC0svfpMb2o6upR6x
	ExUjW2DU=
X-Gm-Gg: AeBDiesRQmwAGdWli3hcQYkSWQ1o+5cUzxito6B/Yz/J2Bf7bIpfHSNyPuoy0p3itN4
	nM+H2ngmkJ1ebXhEhJGU3udqFDioTu4DeyOWi7OSurpcm4hyCVuMGfIARfA4f3MmR2EQ4AsknE+
	yS37QTgs0ZeciVuh7hXGLwm/XXhpx0QU/qUFdlYBekLM/cg2yg9VveHZV4IE9nHPfaPsAtEaJ3k
	aEw7wL2N2EKuRQa6XYTiKzNogFoer45exB3v1sEQi8cotE6ztFNGAw4ox1VYLuFkJB9Q/BHUIP7
	Oq7ZI9gSjLtRBAOw+5fJgLjOY21HTEbQbMwP8zdsWdAxe+qS8QLyr8gpH37T6AEnEqQ7bhyxQkJ
	CHQ9rguSp8nFmRJz7qOMTeZg/1RXtg/Hl9NIGvsN2Cr7CmhPqWvQM+Kh4Vk94A4QKSC/1aTzeeU
	fR1LD52zGuEM4/11/d/UdYTturnQPcIZdZHo7Pi1HoIkns8jV8EmI2OSNswMvWAibbURAzVtfW
X-Received: by 2002:a05:600c:8b2f:b0:48a:58ae:993b with SMTP id 5b1f17b1804b1-48a77b178b3mr23445215e9.16.1777353216524;
        Mon, 27 Apr 2026 22:13:36 -0700 (PDT)
Received: from ?IPV6:2403:580d:fda1::299? (2403-580d-fda1--299.ip6.aussiebb.net. [2403:580d:fda1::299])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c7fc35d0eadsm1008072a12.27.2026.04.27.22.13.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Apr 2026 22:13:35 -0700 (PDT)
Message-ID: <0f6f3f32-f0b3-4c61-89c2-6f931592f122@suse.com>
Date: Tue, 28 Apr 2026 14:43:29 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Strange behavior with scrub, quotas, and snapshots
To: brainchild@mailbox.org, linux-btrfs <linux-btrfs@vger.kernel.org>
References: <20260428012128.Horde.f5fqQoIpJ3QCuz9LBZNU3Qz@nextcloud.brainspace.site>
 <20260428023344.Horde.ACdhtTWNQo0yzpeKOd7keUl@nextcloud.brainspace.site>
 <2bf2013f-ecc3-424a-b6b3-deec4f3b74e6@suse.com>
 <KAR6ET.BWL8BEMZPLSV@mailbox.org>
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
In-Reply-To: <KAR6ET.BWL8BEMZPLSV@mailbox.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/4/28 13:33, brainchild@mailbox.org 写道:
> I am simply reporting on my observations.
> 
> Deleting all instances of the file corresponding to the identified 
> inode, across all subvolumes, has resolved the problem with nbytes, but 
> fix-device-size reported no action, and the super mismatch remains.
> 
> In case you have any further thoughts on finding a resolution, I am 
> eager for any suggestions. I would like the volume to be fully healthy.

In this case, your fs has no problem and can be used as usual.
That super block bytes mismatch can be ignored.

I'll enhance the rescue command to handle the case you reported.

Thanks,
Qu

> 
> On Tue, Apr 28 2026 at 12:43:51 PM +09:30:00, Qu Wenruo <wqu@suse.com> 
> wrote:
>>
>>
>> 在 2026/4/28 12:03, brainchild 写道:
>>> With swap disabled, the scrub operation seems to reach completion, 
>>> with no errors found.
>>>   However, the check operation still discovers the same errors.
>>
>> Scrub is not a fsck, from man page of btrfs-scrub:
>>
>> Note:
>>         Scrub is not a filesystem checker (fsck, btrfs-check(8)). It 
>> can only detect filesystem damage using the checksum validation, and 
>> it can only repair filesystem damage by copying from other known good 
>> replicas.
>>
>>         btrfs-check(8) performs more exhaustive checking and can 
>> sometimes be used, with expert guidance, to rebuild certain corrupted 
>> filesystem structures in the absence of any good replica.
>>
>>
>>>   The output of `rescue fix-device-size' is "No device size related 
>>> problem found".
>>>   After, check still reports the same errors, including the super 
>>> mismatch.
>>
>> If you do not want to manually fix the nbytes mismatch, go "btrfs 
>> check --repair", which may also help to fix the super block size 
>> mismatch.
> 
> 
> 

