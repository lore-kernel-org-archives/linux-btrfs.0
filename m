Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D4CA470E91
	for <linux-btrfs@vger.kernel.org>; Thu, 23 Jul 2026 06:59:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784789977; cv=none; b=U1Q2FjuWE0ORLCtsKWjjmyfR/tnegZuazwlhFSfSQrARCQ0h9DL0POGlC/GvR1Li7CWXmjW6WZlHFzHNhxZH0LWOlRdNZFxzkY5RxdTX++aUio7ZOiU5bnl7j2m+J0a5ZKa8yIY73sQ9hjV/+hKYIspSMt0y6gGm4zj3mmtp8i0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784789977; c=relaxed/simple;
	bh=baAvwbcsFghvd5HVpQGRXMbrsRHkj4CSobgk39KkoYA=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=kfvcvYQ86841qwcFgAimthMTts42qUKqmrKakoM4H86MqDDUPAedUwc/31tdSto9t95RbFp/AX4bLpYHdBTXyB/wJGC0hc4l5J5mdOnp34Iq+Ne4DVGMAG8/kltk1cUKWIKGpaObP3KwUltre0yA1NnHUHCb3A6Yp100rQVobZ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=Sfvgtqad; arc=none smtp.client-ip=209.85.218.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="Sfvgtqad"
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-c197eaaab00so58931166b.0
        for <linux-btrfs@vger.kernel.org>; Wed, 22 Jul 2026 23:59:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1784789974; x=1785394774; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=FVp9mBc1fFdFYfFXuYkDZvF3OCEpttNjQA0OBfeXzaU=;
        b=SfvgtqadlsPOQzLsWco14nOGrOMGc2egsmj4+kNLSdGAKwP56qO2MhcwCEpPbK2dHq
         M6jaiBwQoMIb1iyGr60DyHkGLhDXiuVag4SrMHRRJ/BM7b/ExFkmyfc2pUAhWVkiBNvo
         eszgvJZowc0PC32bgzXLb5heGSA+J47h5IyKCOpDCq3CdrLNjhBzWJz7kfdii7fIC7VA
         rG4wXHAAqrCecJFMuGccG2jLLIBlzF2nwyuq63/8zBLPoxvPtd9PG1HSU9yObY+LDkUE
         1ZoQWYPxyllesjecP6CJDho6fZ/lwkIkTY/Uuzaj83ahjaQxN2hPGoASWtF7MtXW+CO4
         egEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784789974; x=1785394774;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=FVp9mBc1fFdFYfFXuYkDZvF3OCEpttNjQA0OBfeXzaU=;
        b=nFNod3vDzSzSOJdIYfX52dm6e2VboT3hBBfDvyaX2ysvg5KMHgmyN/msR44cE5gL9Z
         aU+biWx2v+N7OBh0/EZUkykNY/RXxiha77MrXdoqOauXXgtWHAA3XjfA+1ePVwVF3Ga3
         KrzLlacPL6iwAKRofT8AxqmC27Le4CXocvOaeBgQ0QTKdgdxvkzuP/KOvwKU+exw2pLO
         fQsbr69cnk7vx82XFwuVcNsePxJvjW9sU4O1lmsdghMWBT4239qsByZamhurSHoRXbx5
         ubXSUEmdRNo/ny93avwAFP9rgNYv39tdBEzQG/in7FAAIaKju4H5nrQCrwsRhyi1DWNp
         Y6UA==
X-Forwarded-Encrypted: i=1; AHgh+RpSDGCRVjl2oPruSOup93xSs8jTrtmqaJxMTipy825h3QS8eAJ/EMWqEI508p5GlyW6/84ZSE6uf4ALAA==@vger.kernel.org
X-Gm-Message-State: AOJu0Ywr8eJwLpGT9c62tISg7cH6Jh9ghW+wmwY1z3vlbJ2CQ8OX5Fsr
	koehAPscj+kRVVoY9EIVYRHpRnXxyJP23DRsdoPQxLxPDVcd4Q0zEUEeOyNAxRQmRo/X9Vsbjaf
	4uMI/UhT6Dg==
X-Gm-Gg: AR+sD113X8/Ox1E6ZDQ+RxIxgEEtMW8HA35HAeiDqswNiMFojNWaZYa+QUIvVIUVgyz
	/EFSCTQkJilAitRURBVO2tc6Y1wfegUn4F+/KAB8yPDnAK1zZ2Qx3DGykWN2gclAZsypiRr2YwH
	1zXjqW/QTMcYVhTqmf8wZVXjFJKen1PdzbyHIgHPMNWjHYF4i2wYSS8NJ2C8gcdBo3b8XmIWowu
	Th8TVph0lA9xxm3RIM2vN49VpzVwnqfIsu7lV7EWTcYwy+kL5E3oWsMhaeFVg2ErVZm6/9agK1n
	iGGXswoKP4z74Z1BS52JFeDNpD9uRl5WCRfDoVj1935coelmrg7FbZVDSHc6Lrv+XPrUbiKmT6D
	twf4Oa/IMJNt1oTpcCmX4bQMoGDl+xoxJFA5aBa18/TOXb+YuXGcf/xITwaewlnAoIjuNa04=
X-Received: by 2002:a17:907:7a8b:b0:c16:12ff:dc8b with SMTP id a640c23a62f3a-c1c50c8cd13mr82622266b.54.1784789973503;
        Wed, 22 Jul 2026 23:59:33 -0700 (PDT)
Received: from [172.16.0.229] ([159.196.52.54])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2cf8edea703sm27910045ad.0.2026.07.22.23.59.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Jul 2026 23:59:31 -0700 (PDT)
Message-ID: <f49478be-70fc-4cd6-a640-fb008c21c092@suse.com>
Date: Thu, 23 Jul 2026 16:29:25 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v2] btrfs: disable direct reads to avoid dirty folios
 without fs knowing
To: Christian Borntraeger <borntraeger@linux.ibm.com>,
 linux-btrfs@vger.kernel.org
References: <c6dfdac9fc51c94183e51a861eec269185239660.1784787211.git.wqu@suse.com>
 <9b1d42c4-2c3f-410e-aceb-92400b8bc24f@linux.ibm.com>
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
In-Reply-To: <9b1d42c4-2c3f-410e-aceb-92400b8bc24f@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/7/23 16:18, Christian Borntraeger 写道:
> Am 23.07.26 um 08:13 schrieb Qu Wenruo:
>> There is a bug report that a reproducer which doing the following
>> workloads in two threads:
>>
>> - Direct read into memory mapped from page cache
>> - Sync the above range
>>
>> This can lead to dirty folios without fs knowing, this can be a huge
>> problem for btrfs, as even on the very basic bs == ps cases without
>> large folios, such reproducer can screw up the ordered extent accounting
>> already:
>>
>>   ------------[ cut here ]------------
>>   WARNING: fs/btrfs/ordered-data.c:390 at 
>> can_finish_ordered_extent.isra.0+0x56/0x1f0 [btrfs], CPU#1: kworker/ 
>> u42:0/68
>>   CPU: 1 UID: 0 PID: 68 Comm: kworker/u42:0 Tainted: G            
>> E       7.2.0-rc4-custom+ #415 PREEMPT(full)  
>> 74dbeafab12c410178747d5bec9fb200ae56949f
>>   Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS unknown 
>> 02/02/2022
>>   Workqueue: btrfs-endio simple_end_io_work [btrfs]
>>   RIP: 0010:can_finish_ordered_extent.isra.0+0x56/0x1f0 [btrfs]
>>   Call Trace:
>>    <TASK>
>>    btrfs_finish_ordered_extent+0x39/0xd0 [btrfs 
>> 7d1ffd99bb9696179883f257e5fd838e2d1a0ca3]
>>    end_bbio_data_write+0x1ff/0x280 [btrfs 
>> 7d1ffd99bb9696179883f257e5fd838e2d1a0ca3]
>>    btrfs_bio_end_io+0x76/0xf0 [btrfs 
>> 7d1ffd99bb9696179883f257e5fd838e2d1a0ca3]
>>    process_one_work+0x198/0x380
>>    worker_thread+0x1c8/0x330
>>    kthread+0xee/0x120
>>    ret_from_fork+0x28f/0x310
>>    ret_from_fork_asm+0x11/0x20
>>    </TASK>
>>   ---[ end trace 0000000000000000 ]---
>>   BTRFS critical (device dm-3): bad ordered extent accounting, root=5 
>> ino=257 OE offset=3465216 OE len=2826240 to_dec=319488 left=135168
>>
>> Unfortunately we have removed cow fixup mechanism, which is to work
>> around such dirty folios by re-dirtying them and reserve space for them,
>> across several kernel releases, meaning we can not easily revert a
>> single commit to bring it back.
>> And without doubt, that old cow fixup mechanism is not support larger
>> folios.
>>
>> As a hot fix, disable btrfs direct reads for non-experimental builds for
>> now, so this can buy some time before we find out a proper way to address
>> this.
>>
>> Reported-by: Christian Borntraeger <borntraeger@linux.ibm.com>
>> Link: https://lore.kernel.org/linux-btrfs/f12f70e5-d84d-4a9f- 
>> ac94-693be4c863ac@linux.ibm.com/
>> Signed-off-by: Qu Wenruo <wqu@suse.com>
> 
> 
> Wow that is a big hammer. Doesnt that break typical usecases (like 
> databases on a file,
> qemu/kvm aio+direct image files etc)?

It falls back to buffered read, which has a good side effect that if the 
reader is also modifying the buffer, it will not cause a csum mismatch 
warning.

Although it causes huge performance drop.

> 
> Even worse, this does not fix the other GUP use cases that still exist? 
> So its only
> a partial fix. Have you considered to add my RFC patch on top to close 
> another
> problem that I can reproduce easily.

Because that doesn't fix the problem at all.
It's just masking a corner error.

With or without your RFC, on x86_64 with large folios disable 
intentionally, it still triggers the OE accounting problem mentioned in 
the commit message.

I believe if you switch an older kernel, or disable large folios 
manually (reverting commit 9bce95edb1b4d2802de9273b5170bfcff3090d24), 
then you should hit the same warning on s390x, and also fail the 
reproducer (error out, not hang though).


Again, dirty folios without fs knowing is the root cause, your RFC is 
only avoiding one symptom, all the other problems are still not 
addressed, and those problems are not any less serious than the hang.

Thanks,
Qu
