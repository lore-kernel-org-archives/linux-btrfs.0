Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C27A299A87
	for <linux-btrfs@vger.kernel.org>; Wed, 15 Jul 2026 06:10:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784095840; cv=none; b=dcYfeqCu4Eu9fbkzgnEY3HQXlHFX6dnjtKQv49tMauE3C5Vp7mG16TPgNeFtPbd3KfnWCdgNgD3mZP1ERhIdQKkMpx3XsfIEMPk/noJcO4C8MdwWEAWCnr+cG3FIWkc7couaL56NzQssLBlQewp0pq1Bep9KMp3jOGg+LI0X35U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784095840; c=relaxed/simple;
	bh=AwBshfhjWMh0a60SE7yzyE+loeFv6NmMhBpMAGIfZf8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ASTkMNVt1ix0C9jlz8OXaPgRME3SM9X0ZQluZaafNI5srkziIKwlb9WXf1/CIxNMtDHpjXgIgzNYFE7pXpPjk6YDEjYHFsVbWjA+rYz9XXefnlV3PiJ2cSIwyvCowLxoY0Ge91pyYoX+eDPExBBcxrMqkmlMvjcgQyR3plkA0uo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=LaG6Hcam; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="LaG6Hcam"
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-4953e04ef16so991825e9.2
        for <linux-btrfs@vger.kernel.org>; Tue, 14 Jul 2026 23:10:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1784095837; x=1784700637; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=iko8GtHh45xxfsjdGnxCyt7bFJcvzA70CefNmYdAZFQ=;
        b=LaG6Hcam7SpYLeyfpMRa5TupqKN6n/Au8lP8t4HR+2ra7blTPoKxCyrTMF3rOKWyoh
         tzku4QnphsC2o+XNRi3gAjKgmLCcijrDR25pVrGaCT6aX1MfHi9wn0aS9wXHIbHTF++H
         BdW/v9N1g2/FzClzD2duORncjQMOae0oqciT2D2j3czPbRYru4usl7gJEcZ4DCmrnXPg
         48T/2aG77TQqkE109vQMYVSe5OnorXRn4Oza+/3u6nXJdLNK4Msyw6gswzXUDNZ0NmmR
         OW3Fk1PIxb+87TOf6gZoP4J1eHeME5KC9z8WeUJVjyrRWj/6ToOgxc/qS3qUonxNL8+v
         UjYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784095837; x=1784700637;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=iko8GtHh45xxfsjdGnxCyt7bFJcvzA70CefNmYdAZFQ=;
        b=l4uWorM5R5Akkn2KEyPosvLFvnGhwl0xwxsQg8JNY8saqTDNFvFLQ16QFgGp3dm95R
         6vrBGZKtkWE+kk4BWjgCk/yGq32ySn5NqCZdkMn63sNzzWwxqjgBb5Iz0oELCUhgyPHr
         crvJQSFNqxvIxh10B4MOj5ZBKZPxuJ477QJ7cJN2UMxrGcyKLyDjQb83PJ8wnoHm66pF
         BLbOPBjUiYWxq1LH6ggcLqueFDZvO02bOAzVEUf9tvs2f2OYLash5EQTb/JmuhNjdcxy
         Y4llomJ9ea91sEBxCX42TiN1CYJQQs6eHElrHs8Nlw46v2eiw+jVsKdi2qEEhUGvBG47
         S1fQ==
X-Forwarded-Encrypted: i=1; AHgh+RqK2S9cwX4KnYYGwZYSgqkoXZPYmp/HyFvNw8oUNka6uHNT9hbxAFbl4PTrAInJlnMJrA64/HxMakKCcA==@vger.kernel.org
X-Gm-Message-State: AOJu0Yz5rv8U1cbELYxEg/jhiNAVbOl6cKLU3/ptbLiyWDtjWi/uH8E0
	whif5ol8lkrdPcJjmHmRLYRhHSe3Cak8ppFn+7AX5hND4Dp64YOH717bV7nUEgJw1t0=
X-Gm-Gg: AfdE7climOAlJSVfEhJ11v9hxhlHNqE93h5QxOPXR/IJXNfyMV5M6gwDALVoWs94Fkf
	Ifa3qEpiAe2Td1d6yDmh+he8TNPayP04ZCmcdpy0JQQJ1U7msGtjgiLJwKPqr83hB6EuHDWokYj
	/5Sy3RLAChuAFsTlHGuABqe8QQ520tsNgKVc/x6BaFfiPM5fN4CnwnhAV5B/tucEKs0iYW42KEw
	Vim6R2vDfqURmioL01ngYd0UZBSDxTnBiG1R1sVRciYV2mHkeL40lpA9QdR/UF1KUHIlJpULgQA
	l9GUrfI7idSU2Dy9OwcqG21hBlfX+9E14mf44Sr7hgpjdObFQ6xA7tP45/3ALW4zBfBqOf/yPSl
	5CO19813GLjJnp49eHRzUtPsiYpciVV2D1axW0NeavnDWXw4Wnh04NK5o7juR0iCY+80BlHGgXX
	n2XuZYuw==
X-Received: by 2002:a05:600c:297:b0:493:f138:890a with SMTP id 5b1f17b1804b1-493f88286f1mr117898755e9.29.1784095837213;
        Tue, 14 Jul 2026 23:10:37 -0700 (PDT)
Received: from [172.16.0.229] ([159.196.52.54])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-313f3ea883asm14054060eec.29.2026.07.14.23.10.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Jul 2026 23:10:36 -0700 (PDT)
Message-ID: <5eaba968-b8b9-4705-9027-9169942e105f@suse.com>
Date: Wed, 15 Jul 2026 15:40:30 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [BUG] two raid consistency bugs
To: Zhang Boyang <zhangboyang.id@gmail.com>,
 Qu Wenruo <quwenruo.btrfs@gmx.com>, linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>, Filipe Manana <fdmanana@kernel.org>
References: <20260714161044.7330-1-zhangboyang.id@gmail.com>
 <67cff567-1070-4908-a253-a8907d237734@gmx.com>
 <4289be1b-285c-4641-a7b6-6b8e66f458c6@gmail.com>
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
In-Reply-To: <4289be1b-285c-4641-a7b6-6b8e66f458c6@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/7/15 15:16, Zhang Boyang 写道:
> Hi,
> 
> On 2026/7/15 05:40, Qu Wenruo wrote:
>>> At first power failure during transaction N, metadata trees of
>>> generation N are written to disk A, but super is not committed. Nothing
>>> is written to disk B.
>>>
>>> At second power failure during a different transaction N,
>>
>> If it's a different transaction, why it will still have the same 
>> transid N?
>>
> 
> Because the power failure occurred just before writing superblock 
> (transid N). The superblock on disk still has transid N-1.
> 
> After reboot, looking at superblock which transid is N-1, btrfs has no 
> idea of transid N existed previously, so it uses transid N for new 
> transcation.

Then there should be no problem at least at the next mount after the 
power loss.

> 
>>> nothing is
>>> written to disk A, but metadata trees and super is committed to disk B.
>>>
>>> This creates a ambiguous generation N in two disks. Currently btrfs
>>> can't detect this, and can lead to severe damages.

At the next mount, btrfs should detect device B has the latest super 
block, and use that as the super block to mount.

Since metadata are all written to device B, even disk A may have some 
stale tree blocks with transid N, stale tree blocks still need to meet 
other conditions like root owner, level, first key checks.

I won't say that's impossible, and won't say we shouldn't do anything to 
address it, but this is a variant of the split brain problems mentioned 
in the past.

I strongly recommend to find out that thread and check if any of the 
ideas are explored before and if they have their limits.

> 
> By the way, I came up another solution:
> 
> If generation mismatch between devices (or log-tree mismatch) is 
> detected at mount time, set a dirty flag in superblock on device which 
> is behind.
> 
> If dirty flag is set for a device, disable read load balancing for that 
> device. So (meta)data only read from latest device(s).

What if some metadata only arrives at that stale device, but not 
completely reached the good device?

That kills the only chance to get the good metadata mirror.

And this won't solve the split brain situation either.

> 
> If dirty flag is detected, ask user to run a scrub. The dirty flag is 
> cleared after a successful scrub.
> 
> 
> Zhang Boyang

