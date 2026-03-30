Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 242A3382291
	for <linux-btrfs@vger.kernel.org>; Mon, 30 Mar 2026 21:48:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774907326; cv=none; b=UX1tV1hxtf1q/KUVi7Ggpwlx1nS4yreKKqjAQq6jZO43FdkVxV51ttjE+kqELJIU3T+xS0tt+1Y+HxHPfPGnmnjd0LnjtDETmhnrH4KvH9+WMLjAOmixc40vD7u7h7Vq13s33ZJHl0k8uvDNbZMs8KBUmbmL4gGdcGrzj1SaoY8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774907326; c=relaxed/simple;
	bh=PMpUArrW9JKW5mfz5e9h93OYrMwdYeLV+vmmqkvyqHk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hlEzWal9bHSvM/XmBS69Gzs/RDutKbp64zX40pW8GmkJT0Rrrd3WIYGhZpx6QT+Q5v16qRxl9xQ1i+mUr+D5YL7sg/oeewwlX4Q35lRRnLewcMIYXlf8SbM1vHZMUBaG138b7yR/Ri+QC++e2oMKelTsE/P7pn3MjcFhFS4ebVE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=Ei3jilqq; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="Ei3jilqq"
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-4853c1ca73aso50594175e9.2
        for <linux-btrfs@vger.kernel.org>; Mon, 30 Mar 2026 14:48:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1774907323; x=1775512123; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=qJdCwo4v2unlKk0cRfoVOJ3i62p6h6fL/fO1puM34+I=;
        b=Ei3jilqqQpyf2FWLYWtcLPIxizgxlNyyll2+VLOxHhmOfe5/p2pS0XsxEEa9si5PjM
         8GMqsYDTWKRylgL8faC0oYoRztAQ2nPNPpcF7UZoH1gd//ZTwH/N8KJatwvdo5n9uCcH
         xwzAAb69pEIQW8Exy6avERjh7Jjd+bO2fb77ML0JdQ2U7/4+LZmTX544WSkFfWHsr0UV
         a3FWc4qfrBgi3spJSbEPPOLC0XbrB3VB2eVKYx5dYD1/dGL3yorVoeBNGmag8VppJZsU
         2ZauQqR+tpy/jwY1pCYdP4Z0Z3zarvBqtyB8FxItnv+uLWJ9H/YE3DdakWYOppq2NDkM
         jH6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774907323; x=1775512123;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qJdCwo4v2unlKk0cRfoVOJ3i62p6h6fL/fO1puM34+I=;
        b=su0/Bvy8JsFeXRVprSbrl86kP1wT7SMf8oCjGWpYcG32PyrpHIxnUfK0N6DV7MzV+O
         tFMk7Ukt9vMpBV3OezXLD9qxqEde2ze2Bjrq/DT8S+6HmcrHHZdPdZtKs4aD/o1z09VQ
         6DGE6zxTVshHwx/2O14SrGf+m2HGASh94H9gdciq8GkGBOK6A1m/myROF9y54a4tDNpp
         2ynGe6Xx7uuBpaUUfm5X5dN/3Qg77U039E4ntx4NiVmr3drKHtell9BWyJVHtRAQDW8f
         ba7UnWP1djmcZDBzNrAw3w+cYb0twDFUBhIcMD8qNEYqJyt8kjj4/lbf1ON1Rv6NE2Cl
         kKcQ==
X-Gm-Message-State: AOJu0YwJETJL7+S1zYx6qylSDPABUwqnpkxnx2g5GbcPvhHDZ6M25TF+
	SEmF7MwJCzNlzyvM2ubWlaZUHgSjfhG91UQLDh6rkde6YdCfrTY1xvVfvDY3wU/zhbQ=
X-Gm-Gg: ATEYQzxp21PADelkjqARZZzjABNIaUko9P6er0VhnfLFWaItQGUlKy1GWC0YWmz2GYx
	E2YwZGuzt/QJDuRz2YfQpTTqNVTKOUzVX36xFBc9Dw60PP9kgs8MstuLEdcEQjfTE8Z8Ygyt0JB
	xWawXHT7EpASuE8mcm/EpE/PmtIpdK5OXqur8rllH5GQokWEYORnMp11unAIUZGyCdFEeg0ClZT
	Me74ncUG4zwd8hFqvenLLnnkH2c55gqQ6sQ+/pG2k0t7D4uXUqNiVAAEooDa29nLZuZvctoJEhT
	CUcTspzpB6UDS5PRzwU+fr6NhsEWKU9Pj5s+L/MJgLZ12RE82G8WlD3Nh2rV5sOawdOJflzCtLl
	x/hMhgVcVot9xmGRHxEDk50XLkytFRh7edKb/HGrkAnAeKyfzLQafYoRVMEihGGOu6l9oOBoYNe
	jnGFj5RzFZmajfKIEUGIn+D0If8vPZHRTWXYtNM1V4AhuBNONwGN0=
X-Received: by 2002:a05:600c:1d1e:b0:487:467:4276 with SMTP id 5b1f17b1804b1-48727f0e6b8mr237690115e9.30.1774907323213;
        Mon, 30 Mar 2026 14:48:43 -0700 (PDT)
Received: from ?IPV6:2403:580d:fda1::299? (2403-580d-fda1--299.ip6.aussiebb.net. [2403:580d:fda1::299])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c76916da892sm6998489a12.14.2026.03.30.14.48.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 30 Mar 2026 14:48:42 -0700 (PDT)
Message-ID: <6564fe96-ead0-45d4-9655-cd14f13bdc9a@suse.com>
Date: Tue, 31 Mar 2026 08:18:37 +1030
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] btrfs: wait for in-flight readahead BIOs on open_ctree()
 error
To: Teng Liu <27rabbitlt@gmail.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.com, clm@fb.com,
 linux-kernel@vger.kernel.org
References: <20260329063417.642647-1-27rabbitlt@gmail.com>
 <11c944aa-7745-4720-9f40-af99bf7bb727@suse.com> <aclYf4R2XxlUkxAQ@rabbitArch>
 <4a129696-0352-427f-9e0e-7962e789df57@suse.com>
 <840361b6-9b27-4419-b8ab-891ab254fac9@suse.com> <acq5Y9VuDI9htA-I@rabbitArch>
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
In-Reply-To: <acq5Y9VuDI9htA-I@rabbitArch>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/3/31 04:30, Teng Liu 写道:
> On 2026-03-30 08:51, Qu Wenruo wrote:
>>
>>
>> 在 2026/3/30 08:36, Qu Wenruo 写道:
>>>
>>>
>>> Even you wait for all bios, it can still cause problems.
>>>
>>> As the bio counter is only for btrfs bio layer, we still have
>>> btrfs_bio::end_io called after btrfs_bio_counter_dec().
>>>
>>> And if the full fs_info has been freed, then at end_bbio_meta_read(), we
>>> can still have problems as btrfs_validate_extent_buffer() will access eb
>>> (bbio->private) and fs_info (eb->fs_info), which triggers use after
>>> free.
>>>
>>> So using that bio counter is not going to solve all problems, but only
>>> reducing the race window thus masking the problem.
>>>
>>>
>>> The following ideas come up to me, but neither seems as simple as your
>>> current one:
>>>
>>> 1) Introduce a dedicated counter for metadata readahead/reads
>>>      This seems to be the simplest one among all.
>>>      But the only usage is only the error handling, thus may not be
>>>      worthy.
>>>
>>> 2) Disable metadata readahead during open_ctree()
>>>      Which will delay the mount, especially for large extent tree without
>>>      bgt feature.
>>>
>>> 3) Use buffer_tree xarray to iterate through all ebs
>>>      Since this is only for error handling of open_ctree(), we're fine to
>>>      do the full xarray iteration, and wait for any eb that has
>>>      EXTENT_BUFFER_READING flag.
>>>
>>>      The problem is, we do not have a dedicated tag like
>>>      PAGECACHE_TAG_(TOWRITE|DIRTY) to easily catch all dirty/writeback
>>>      ebs.
>>>      So the only option is to go through each eb and check their flags.
>>>
>>>      I think this is the one with minimal impact, but may cause much
>>>      longer runtime during this error handling path.
>>>
>>> My personal preference is option 3).
>>
>> Or the 4th one, which is only an idea and I haven't yet verified:
>>
>> 4) Handle error from invalidate_inode_pages2()
>>     Currently we just call invalidate_inode_pages2() on btree inode and
>>     expect it to return 0.
>>
>>     But if there is still an eb reading pending, it will make that
>>     function to return -EBUSY, as try_release_extent_buffer() will
>>     find a eb whose refs is not 0, and refuse the release that eb which
>>     belongs to a folio.
>>
>>     That should be a good indicator of any pending metadata reads.
>>
>>     So if that invalidate_inode_pages2() returned -EBUSY, we should wait
>>     retry until it returns 0.
>>
>>
> 
> Thanks! Yes, it makes sense, simply waiting on the bio counter doesnt
> fix the problem here.
> 
> Among the options, I prefer option 3. Although it may be slower, but it
> only happens in mount failure path so extra cost seems acceptable.

The problem is not limited to mount failure, but also affects 
close_ctree() too.

As it shares the same root problem, we have nothing to trace nor wait 
for any pending metadata read.

> 
> I am quite new to btrfs codebase so I dont know whether
> `invalidate_inode_pages2()` would be a reliable solution so maybe I
> should start with option 3?

Sure. Although iterating through xarray may not be that simple either, 
as you may still need to look into all kinds of extra locks/rcu lock 
etc, and if you apply that to the callsite of close_ctree(), it may be a 
much bigger problem, as we have a lot of more ebs compared to mount time.

You can even mix option 3 and 4, e.g. only after 
invalidate_inode_pages2() failed with -EBUSY then switch to xarray 
iteration.

This should greatly reduce the number of ebs that are still inside the 
xarray, thus makes the iteration much faster.
