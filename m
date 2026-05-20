Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A12D313293
	for <linux-btrfs@vger.kernel.org>; Wed, 20 May 2026 23:46:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779320810; cv=none; b=NedUf2BOs70ZMMtDr0/umwaREt/AScMMNMfYP+daihdI/D2sHPQlRHyjwR+Wxq5OyzJvEXajFRbCQvhmBQJWX4f3TGQ+8ow6ym2bM3lMKovjIZeE4TPHwQqM9RfXcR6YHxeV5QC3UIqNDd5jHogYw5GPIjh1FfvAMXi2WiLY3Y4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779320810; c=relaxed/simple;
	bh=ZhCl2C5Wrn3IGyW32VptJnYyFGUADc5mhRU6Q0j52s0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=OI3e7VbiEJscOWysQHqFaaCQA6bKXKKma53EX5mJ/sDlAhs9ggFbGSXfG/46HGqtiI1ko6ZieF5eHRZ1qDCq1s8Z36Q38giqUMOojYftgG9n9nh0c+IL0zBhyAMDQl5LubkAVGvdzKz5er9riM/13+4YjZhwDfbBiHgP8SYSaLs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=aRADAanh; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="aRADAanh"
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-4893940bb5eso30415125e9.3
        for <linux-btrfs@vger.kernel.org>; Wed, 20 May 2026 16:46:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1779320801; x=1779925601; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=WlGgHmkBC/kImGwZ2c8Hg4pZSU+NIAaMM311Vn7P4rI=;
        b=aRADAanhfIxbWnVyLaRNSChJg7e99frR8RcfAogNrAGh39Pr84IDUKoB2XAR7YBWqD
         2X3McnXPTqjJZoeI/RpoZSqX0QXFuA3gRkv/XHdcrffCR6kv2wddmPnX+auuJKcZPl+E
         SzV55BW0q/hqRNEoVovheAUAdgZSvwlNHrCTkuYsaE1m96GJv3L5Z/kjqKIxUODZth+M
         D5C/BqHVSpljguB0oxRql8tT9qtluDoGOecQUIkxuKNXFGvre1/D/MWf4GWjwHu6S6Tv
         4bXHS5WXM/obk2Cj0RXryBb8GSuMWyYD2nhOtn8yAzkjAlEib48/SeyCcUxSdujT17L/
         EWTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779320801; x=1779925601;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WlGgHmkBC/kImGwZ2c8Hg4pZSU+NIAaMM311Vn7P4rI=;
        b=IV6CGvzFXai0q7fPOc37xxROce2jOeJnzoQ1DiBFtras1zjJpFmXwTTpQNSPOkLXU6
         VyoLFyhSn4tDJiSNz6JcifbimmKl6V1UXSqunfr36fayQisgC0p4q6z29gmifHHODve8
         +V8X9feXLRXFl0TLhnJBVQfe4g3b9ldk8JHxk+meNJKhiJLe88mXxo+7mLj99pairT2f
         AFijfA/ReYeTTIRLzesHP2hV5Xt2Aknno3S7V9CouYtvhd0QHVs1OTu7vB4toH2+mVnT
         iJ9zetgFMcyALZYC8UKMy+3b+rJSraP/QeqIXMcjyvtaZ6YrFpEqaGfbXw93nIuo8Dp0
         tiew==
X-Gm-Message-State: AOJu0YwTGn6spX0FAwngDEPymaYYjEWzctubP2UU/CNt3YxBKkP/hyhJ
	CqkeXzKTetxVUcPzMhQmDJTGypJmiBDEy9p8BisW1DFVEK8w7QFQBcyoI6PxCFkoIG8=
X-Gm-Gg: Acq92OFwBpjne8JXG4RE4U0K85xqP84X4KxeaIni0MPhxg2BUtYT8GEhs6cW5z/1Mtp
	tlsVACtHNL8We6eN/QYg3iSaOfHeqZtAbjnH4hrzD1zaAygctYqCh2+VW0pHnK/OKIENs8cnb0h
	Q7V1mvxBNjB9/fsBw0nVjNI/AQTVbkK3NTbvAXCXgJhUxu1FDoU+6V9UJQ0Pl9BKgHoSBMnI84t
	QaXsz0x9IsKEfXJ8rt0YMMnmatyhPW6W3XjTIxeNq11S7JCQODycfJZKN5qo0a5zDjY7EZVqySs
	Y0HTiuGQwbuT3xqT8T5/6+LtuRr+DVRBo180Fxz/bccUer8K73mcM4GJniErycv0CxRaKqCWcxa
	Z3TwXhWel4RkvJ2CJmYwnRjk8aRRHxjS4UlK9ceZX8gl5hNXDtw4ARPPNduPV25wVzmamHoCt+J
	DgPGu9iev8xGmLrBSgwUaYG6tYMrJzYTDr0S0Z8ZzrCkvWtn0QEz1M/OXmBPUzq3nMmSW9+hTpg
	yLeHzwqtikqIsZ3QkLAQvbUwGsP2lt7pCJf9AR0amlk3bc=
X-Received: by 2002:a05:600c:1f86:b0:48a:5821:5ff2 with SMTP id 5b1f17b1804b1-4903603174cmr4784085e9.8.1779320800912;
        Wed, 20 May 2026 16:46:40 -0700 (PDT)
Received: from ?IPV6:2403:580d:fda1:0:2bb5:f164:6e6a:38d8? (2403-580d-fda1-0-2bb5-f164-6e6a-38d8.ip6.aussiebb.net. [2403:580d:fda1:0:2bb5:f164:6e6a:38d8])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c82bb062695sm20350942a12.4.2026.05.20.16.46.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 20 May 2026 16:46:39 -0700 (PDT)
Message-ID: <a56287a3-f836-4bc6-9e04-b3939b00aa4c@suse.com>
Date: Thu, 21 May 2026 09:16:36 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/6] btrfs: add delayed ordered extent support
To: Boris Burkov <boris@bur.io>
Cc: linux-btrfs@vger.kernel.org
References: <cover.1778902677.git.wqu@suse.com>
 <82ca7628a7a96eb8cde8c1a53f7db544fa2f6ef5.1778902677.git.wqu@suse.com>
 <20260520220020.GB1479855@zen.localdomain>
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
In-Reply-To: <20260520220020.GB1479855@zen.localdomain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/5/21 07:30, Boris Burkov 写道:
> On Sat, May 16, 2026 at 01:15:15PM +0930, Qu Wenruo wrote:
>> A delayed ordered extent has the following features:
>>
>> - A new BTRFS_ORDERED_DELAYED flag
>>    And this new flag must be set along with the BTRFS_ORDERED_REGULAR flag.
>>
>> - No allocation of any on-disk space
>>    As a delayed ordered extent doesn't take any on-disk space yet, it
>>    won't release any reserved data/meta space either.
>>
>> - Zero or more real OEs can be added to the parent
>>    If a real OE is allocated, it must be inside the parent OE.
>>    And such real OE will go through the regular data/meta space
>>    reservation path.
>>
>> - Children OEs will not be added to the per-inode OE rb-tree nor
>>    per-root list
>>    Only the parent OE is added to the per-inode rb-tree and per-root
>>    list.
>>    So anything waiting for ordered extents should only work on the parent
>>    one.
>>
>>    There is a special corner case to btrfs_wait_ordered_extents(), as
>>    delayed parent OEs have 0 disk_bytenr and disk_num_bytes, they will
>>    be considered out of the [0, U64_MAX] range.
>>    Thus we have to always wait for any delayed OEs of a root, no matter
>>    if a block group range is given or not.
>>
>> - When the parent OE finishes, all children OEs will also be finished
>>    And reserved space handling is all handled by the children OEs.
>>
>> - Any range not covered by child OE will be manually cleaned up
>>
>> Above features allow us to use the existing ordered extent interfaces
>> to allocate new real OEs, and wait for them properly.
> 
> I am getting comfortable with the idea of the nested OEs, and thanks for
> seriously investigating the question of splitting. Sorry if I
> underestimated the difficulty while asking about it before.
> 
> Reading this all again gave me another idea that may possibly help with
> making things as clear and simple as possible.
> 
> I'll blab a bit to set the idea up :)
> 
> So a classic OE represents a range of a file that is under IO (just
> about 1:1 with bio submitted, finished on bio done)

To be a little strict, the classic OE is not 1:1 with bio submitted.

The truth is, we can have super large OE, up to 128MIB. But our bio can 
only be as large as 1MiB for the worst cases.
Thus we will have a lot of smaller bios submitted for the same OE.

> 
> This new delayed OE lacks the submitted IO (or even space alloc), but
> is composed of "real" OEs which are not in the rb-tree. This means the
> old finish_one_ordered code can just run on the children and the only
> weird part is that deleting the rb_node is a no-op. But the outer one
> looks enough like an OE that everyone who looks for an OE finds one and
> can treat the delayed one transparently by trying to force it written
> or wait for it.

Exactly.

> 
> What if instead of having both of these be kinds of OEs, we just split
> up the concepts? One is a range of a file which can have one or more OEs
> in it and lives in the rb-tree. The other is the classic OE and
> represents the I/O, finishing it places the extents, csums, delayed
> refs, etc.. Another way of framing this idea is why not have all IOs use
> a parent OE with a single child covering the whole range?

I have a similar idea for the long run, to migrate the non-compressed 
writes into the layer OEs (or split OEs), so that we can handle the 
truncation cases better, without allocating a larger than needed data 
extent.

However going all in on layered OEs will need quite some extra work in 
simplifying the structure, a lot of members in the parent OE is no 
longer required and should be simplified for layered OE solution.


> That way you
> always have a parent/child and don't have as much code that has to treat
> them transparently. When you look up in the rbtree you always expect a
> parent.
> 
> This is of course a wider change (all ordered extent users suddenly care)
> so it affects more code. However by not hiding the problem on a flag on
> the OE, the OE functions don't have to be a mess of "if parent X else Y"
> style logic. If the users of OEs use a narrow interface anyway
> (presumably mostly just starting, waiting, cancelling), they don't care
> too much which exact object they do that to.

If we're fine with the current layered OE solution, I'm totally fine 
going that path, migrating all writes to layered OE, and simplify the 
structure.

Thanks,
Qu

> 
> Thanks,
> Boris
> 


