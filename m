Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79DF43E4C99
	for <linux-btrfs@vger.kernel.org>; Thu, 23 Apr 2026 10:20:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776939651; cv=none; b=ntmcMVNvbkt+3oky8D1FPASCsBUsgRAj8nDmESDcx3lDzU5nkEWhjdMlHuMaf6Z84XAW1n6Or6L80bhdgkxosb8y0c+bJyjbUwhAAoBw0GQQRi7LL85PuHNK+EVM0pEumZxQByGk3UvWAWtiHFwhNCU9lsnywWdBDS+n1SFq6I4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776939651; c=relaxed/simple;
	bh=7JMOc2+Jo9HnKnu5FAsODsxV8IMjHW7/otQzJnZ9Tjo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=XUlk26OExzLC6fL5EsI7hqWAP74qus4jRAakhDKkqpB+r4VJm/0A6P2/aAgkaVasvaxrL1pa6EMqwK/6hhZP8z7BUoydko+6ayhfwp3fTpkbJG+GuM7h8yJq8RJxZi6scdA6XVSFHuC10hDELy+C2xvIJK1op/GZL01xlEjbC5Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=ggVQ/nIf; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="ggVQ/nIf"
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-488b3f8fa2bso66020435e9.1
        for <linux-btrfs@vger.kernel.org>; Thu, 23 Apr 2026 03:20:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1776939649; x=1777544449; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=ahtdlInT/2riRMoSeV/4BKG9DNp15ktBWKUKTE7tdBQ=;
        b=ggVQ/nIfMOLJkx84C9a+OIE0/Y1zU0tvOdgKKZWjqAzEV4G/bDRdv/qCMHtMUnggFm
         9svTbJmrcV2/uR9yITbQVCXTTGxA5rMKk5JWs0Z/9mLKGjzUvS1JzLa9E6gw4KbW9/Va
         x78MoIaRU02CiJB5YvQZmfarq5kc2JhScxOE14yO9K5nDZVI0FFolvfZTk4M3NRnNwyj
         074Tvlzw7nVpZ68EUK/TgQtPaUzizEdv7aMVeOQN8wIyNSUU1aNMOw67ZnU5J2YwXb1S
         dRf5BM692o2z611lMTotl5POD1o6B8KnNuCmabktlIke9SC47O8LXO4+3b61tVYA4+VV
         ub5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776939649; x=1777544449;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ahtdlInT/2riRMoSeV/4BKG9DNp15ktBWKUKTE7tdBQ=;
        b=oODxrNfCRZaxEEoDk5L77xp38K9E0t5LeQs/wvzprm70q68AeU5G3sc8VRj02Jq07R
         SUdkWLEQxqcLeNwkXNSNTRyzc3gAuONCLqLWDzk1tvEUfktAZGyIXR1ZK6WxMwjiDAHl
         +Ac57NT0sBK3HWTvohj953Eye5g/t/CFCY2u3KgDi7Zbe2napVo0VR9jL/nXqXwgg4g6
         TZqEMyJPaJ+y+55MCJiaUnzsfK7RTZRJDAfO85PcEETAm8W+nXSL3CsuCG8ZclzRu5t2
         V309n4lbZfN4XCJqHXwnaTQamiDfcAyQXfva6+2DVHvyt0dXdVy7ZrnXyc1d7yjuAtnG
         MqwQ==
X-Gm-Message-State: AOJu0YyYD+PrfGaEeGdXLdMb70i/h0dn/vbCcqG35PB8SNb3l7HJNzOB
	aQPlkIhKZyaURr9HfO+ktxKDnDDTgxLOTDKXEEJ64NrB3PpapcpMJygJtL311oU4uEnvoXI2JOP
	pDlFLuPA=
X-Gm-Gg: AeBDieuVoPmygNEBl1LdmzHB5aXVRhancsAN3Ijj8yY/40e/OmCof/Rl0BLYwLT0rw1
	liAyMrPMh1CREOLFzND9Tw9sz8RFfjVpmZ+NYTHJI6vm0cTX+VjzHNZxr/MGdbEUvMCerJupcPI
	MIJGhAoVpVPWpYeJCdzQK716FjR55D3jHaa4tlnZGxxbZNQIarQKpIRLZ9ne5GZWfDnoyyz998b
	slRyJsn10aJ7JtJpkC1g3CXKQPF2q5I3RgxDIu/Pzp+P6/zp45sGXs793DAsfwevwhxA2YtzMLC
	7m3xHuHu++HFm2SbkAG0Tm9OgbCTIjWnE6oIlZJtIwcRw5mHEVBiIaf1hK+LL28boN43fo/tdzk
	uX57ztzIVFJpY2M8O/mA+lPgyZ/eQD9lDG67lzepkcSp+e6k8jfVwr7suZ3ZSorVxOiR5T7fipp
	7ARWQecNGSCnwdRbLnEu9+Bksuc0H1C/jUBEo/HTLP41DexlOfI9fJAazQh8VXfg==
X-Received: by 2002:a05:600d:106:b0:488:a2a1:62cb with SMTP id 5b1f17b1804b1-488fb8b5753mr242485295e9.13.1776939648774;
        Thu, 23 Apr 2026 03:20:48 -0700 (PDT)
Received: from ?IPV6:2403:580d:fda1::299? (2403-580d-fda1--299.ip6.aussiebb.net. [2403:580d:fda1::299])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82f8ebbcfd7sm25214330b3a.32.2026.04.23.03.20.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Apr 2026 03:20:47 -0700 (PDT)
Message-ID: <5a405a46-d210-453e-ae72-7730172cfe71@suse.com>
Date: Thu, 23 Apr 2026 19:50:43 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] btrfs: don't force DIO writes to be serialized
To: Mark Harmstone <mark@harmstone.com>, dsterba@suse.cz
Cc: linux-btrfs@vger.kernel.org, josef@toxicpanda.com, boris@bur.io
References: <20260422140339.417238-1-mark@harmstone.com>
 <20260422205728.GI12792@twin.jikos.cz>
 <850c7c2d-ed97-424f-8ede-4491bacb02ac@harmstone.com>
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
In-Reply-To: <850c7c2d-ed97-424f-8ede-4491bacb02ac@harmstone.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/4/23 19:34, Mark Harmstone 写道:
> On 22/04/2026 9.57 pm, David Sterba wrote:
>> On Wed, Apr 22, 2026 at 03:03:35PM +0100, Mark Harmstone wrote:
>>> Before btrfs switched to the new mount API in 2023, we were setting
>>> SB_NOSEC in btrfs_mount_root(). This flag tells the VFS that the
>>> filesystem may have files which don't have security xattrs, enabling it
>>> to do some optimizations.
>>>
>>> Unfortunately this was missed in the transition, meaning that IS_NOSEC
>>> will always return false for a btrfs inode. This means that
>>> btrfs_direct_write() calls will always get the inode lock exclusively,
>>> meaning that DIO writes to the same file will be serialized.
>>>
>>> On my machine, this one-line change results in a ~59% improvement in DIO
>>> throughput:
>>
>> That's quite an improvement. What's the actual fio script you've used?
>> Also the DIO depends on the block group profile wrt the buffered
>> fallback so that would be good to know too.
> 
> It is. There's a big dropoff in DIO write performance in 6.8 that we 
> never recovered from.

There is the bounded page solution from iomap already, which will no 
longer fallback to buffered IO but to use extra page copy to make sure 
the final bio won't change its content halfway.

IIRC it's one extra flag and remove the btrfs' specific fallback checks, 
but I haven't yet verified the behavior/code.

Thanks,
Qu


> I'm going to look into some sort of automated 
> performance so this kind of thing can't happen casually.
> 
> This was on a VM with 8 cores and 8GB of RAM, with a real NVMe exposed 
> through PCI passthrough. The figures for XFS and ext4 in comparison are 
> both about ~3GB/s.
> 
> # cat go
> #!/bin/bash
> mkfs.btrfs -f /dev/nvme0n1
> mount /dev/nvme0n1 /mnt/test
> mkdir /mnt/test/nocow
> chattr +C /mnt/test/nocow
> fio /root/test.fio
> 
> # cat /root/test.fio
> [global]
> rw=randwrite
> ioengine=io_uring
> iodepth=64
> size=1g
> direct=1
> startdelay=20
> force_async=4
> ramp_time=5
> runtime=60
> group_reporting=1
> numjobs=32
> time_based
> disk_util=0
> clat_percentiles=0
> disable_lat=1
> disable_clat=1
> disable_slat=1
> filename=/mnt/test/nocow/fiofile
> [test]
> name=test
> bs=4k
> stonewall
> 
> 

