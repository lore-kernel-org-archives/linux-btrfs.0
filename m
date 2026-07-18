Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9D634D8CE
	for <linux-btrfs@vger.kernel.org>; Sat, 18 Jul 2026 00:19:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784333954; cv=none; b=MzFpoD96IX6dUfFy801DvEgW8migQFGX3ehfI7gMXII0p/5ndiCPYOmIgu9V9veTphNx+6kETeo5FdzJ+G1zeKos55N1l6JUyyDg9fZvJPv6EplGp/glcVJkZG6LXN6baP3pwCwrRQuILVMUEeqeQRXy+fBw6e80DtyXR6rZ47c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784333954; c=relaxed/simple;
	bh=sBhNERL3RssECG85iAHTT6/WuF4s61buM5KU+Y4Bvww=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=t6llYYbwfKCp9Ds6r6FAMJ8AwoVxP2/vqVmOtnkmDWLNO6PCcI423A+7UpDJwArZqc4UUplzvpKhIDzlDcvb6b2swKB9WFYpWKyYKkBfGskRvJQwwRUkyUpj1BEWYgjkcpuDtws7AxV1xh4O9ypOECzVRn1ZpYxKh/JH5ouff6w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=Or+rFH6w; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="Or+rFH6w"
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-493d92b7db3so37595425e9.2
        for <linux-btrfs@vger.kernel.org>; Fri, 17 Jul 2026 17:19:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1784333951; x=1784938751; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=N1F2xFulk4Qo/wyGdNhZLKUtIQrA8HGMgAottRLuAUY=;
        b=Or+rFH6wSvWD5wauV+GulscYnlWb0GvBOm22LbGUtEUue9iSHs7ovH4vG9jjLMvvGg
         V8RsGODaTdhXGzTTiIwLqm7oLpG1etSwrtBZNb/RgNBoI9C9bT5Tnnller7teLUg0hjN
         zXbGcyCrfavH8sROYn2hdTpRQ0fC/aB4Vsz0XIlRFCTiiL7UOb8DqSbOVqfXzkC0EJ25
         vb7eJ5RfEe6+ivPFeell2WICZqGmfNOyqWZ0iXXciL9sBeB1JtTvHti1lA0pfPLaGEBl
         CFlVLYFZ8Edf6t2Nf8suXvkrYtcHLNg/S4IYtw8OvoU58f0vGwgIuosfVeeoB9r2xGlQ
         LpPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784333951; x=1784938751;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=N1F2xFulk4Qo/wyGdNhZLKUtIQrA8HGMgAottRLuAUY=;
        b=pthBq0u3BF4wJqE7BHWV5dgIPUCH6dT8rkgyKJ0w7Vw7hMANVDaNQ8fdixekR1GGhM
         Aai0FrLsKW3iLHFiQnR2ku17dJESPGVKH/z0lltCPCNKHb5V8CSRBMT7+ENjecR3j85Z
         0ApwTRM2sgR2Du5CosIegt13Z/+1sHVt9B/KbettT6BWlYYM0G21HZwBivqVm9xcQs9e
         WyqgsTNIa4bIPZKfJmOIW/avJIeu9pw4IEhjbz4R5oQHPMTHjiMnOy03V3vGYGOudqtP
         AIZ8oi6/sOOYAi4zuHJECvXDmeD7og2XJqrifU6qwfl3no8b7mH4zUoPfu3KWAWFYXGG
         OFNA==
X-Forwarded-Encrypted: i=1; AHgh+RqqxpQnZ+9uDoos4qCmQM0Ffsq1HBL8mmanirGSXmJR6q9cj7V3nRAo87y5LfiH5qmKQOTMqakkRmm4eg==@vger.kernel.org
X-Gm-Message-State: AOJu0Yz2ANgq70riIfxlJtddbhJo6xFpanOi1RDnqVdRngm5/v+RrNba
	tFlMr6u6GIfx/D+kEmfKbpW6NZpGxI+C7P5ZXkbbs6SYdjWhHL/SV4wLii0ZUfnGYmE=
X-Gm-Gg: AfdE7ckheBZTl+wiNTrN7o3s41/+3T0IinRd7Im5mJw6ru2OY+zYkoZd9kqiah0mJT3
	rwGKrlLjzFJTTRRnYlR3vRfn2l7ZNrxt1x/ffYKSu7vvP9BDFcFx1+y/3MuPUqghvaCchMd8Syp
	s53mB/rE60pwS+xymuw4DmZdq6+lHLLI4cccH1r0by2VtMaa7Ct+d+uyf2cytkIUiIJB6FXY4br
	FUG5q4OKbXAZKAD6LB594nH1PmSdfJUXTmOlu7AnUU0vsPvaTuSJidPuIsA4QGr037A+eh+GtlW
	HJeGctWR9jMrW/W5cEcAMYO0zmoIybCrWBRok9MUE0/EW4mJwd/jJ0sMju9SqksUizd2tnhHCaa
	MRcDSeIJ0ZN/p/y1lpF0+2qJO0/mdwDLLQWWVCYV50MXU9mM8jh/MczCPfr1b7wNnLaasxfM=
X-Received: by 2002:a05:600c:154e:b0:495:49eb:1ccc with SMTP id 5b1f17b1804b1-4954a3eff56mr56000765e9.13.1784333950998;
        Fri, 17 Jul 2026 17:19:10 -0700 (PDT)
Received: from [172.16.0.229] ([159.196.52.54])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84c2ad8b082sm1914702b3a.9.2026.07.17.17.19.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 17 Jul 2026 17:19:09 -0700 (PDT)
Message-ID: <8b0bbede-a79b-47db-bddb-91c2fd9f40cc@suse.com>
Date: Sat, 18 Jul 2026 09:49:04 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/4] btrfs: handle ENOMEM from btrfs_insert_dir_item()
 without aborting
To: Jeff Layton <jlayton@kernel.org>, Boris Burkov <boris@bur.io>
Cc: Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>,
 linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com
References: <20260717-btrfs-enomem-v1-0-cdc9c0e265d0@kernel.org>
 <20260717-btrfs-enomem-v1-3-cdc9c0e265d0@kernel.org>
 <20260717201805.GB142812@zen.localdomain>
 <c0672fee4d99be98cc85f7f22f31667121ae4100.camel@kernel.org>
 <20260717230455.GA251596@zen.localdomain>
 <223c999d96a6a69f5824f145cabe3bec891c5956.camel@kernel.org>
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
In-Reply-To: <223c999d96a6a69f5824f145cabe3bec891c5956.camel@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/7/18 09:25, Jeff Layton 写道:
> On Fri, 2026-07-17 at 16:04 -0700, Boris Burkov wrote:
>> On Fri, Jul 17, 2026 at 06:40:42PM -0400, Jeff Layton wrote:
>>> On Fri, 2026-07-17 at 13:18 -0700, Boris Burkov wrote:
>>>> On Fri, Jul 17, 2026 at 12:52:38PM -0400, Jeff Layton wrote:
>>>>> Now that btrfs_insert_dir_item() returns -ENOMEM before modifying the
>>>>> btree (thanks to delayed dir index pre-allocation), callers can handle
>>>>> ENOMEM gracefully instead of aborting the transaction.
>>>>>
>>>>> In btrfs_add_link(), add -ENOMEM to the set of recoverable errors
>>>>> alongside -EEXIST and -EOVERFLOW. The fail_dir_item cleanup path
>>>>> unwinds the inode_ref/root_ref and returns the error to userspace.
>>>>>
>>>>> In btrfs_create_new_inode(), when btrfs_add_link() fails with -ENOMEM,
>>>>> convert the newly-created inode into an orphan instead of aborting.
>>>>> This is done by clearing nlink and adding an orphan item, which ensures
>>>>> btrfs_evict_inode() will delete the INODE_ITEM and INODE_REF, and
>>>>> crash-recovery will clean it up via orphan processing. If
>>>>> btrfs_orphan_add() itself fails, we fall back to aborting.
>>>>>
>>>>> This turns a filesystem-killing transaction abort into a graceful
>>>>> -ENOMEM return to userspace for create(), mkdir(), mknod(), symlink(),
>>>>> and link() operations under memory pressure.
>>>>>
>>>>> Assisted-by: LLM
>>>>> Signed-off-by: Jeff Layton <jlayton@kernel.org>
>>>>> ---
>>>>>   fs/btrfs/inode.c | 17 +++++++++++++++--
>>>>>   1 file changed, 15 insertions(+), 2 deletions(-)
>>>>>
>>>>> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
>>>>> index b7b4e6177135..4d9947ae08f7 100644
>>>>> --- a/fs/btrfs/inode.c
>>>>> +++ b/fs/btrfs/inode.c
>>>>> @@ -6676,7 +6676,20 @@ int btrfs_create_new_inode(struct btrfs_trans_handle *trans,
>>>>>   	} else {
>>>>>   		ret = btrfs_add_link(trans, BTRFS_I(dir), BTRFS_I(inode), name,
>>>>>   				     false, BTRFS_I(inode)->dir_index);
>>>>> -		if (unlikely(ret)) {
>>>>> +		if (ret == -ENOMEM) {
>>>>> +			/*
>>>>> +			 * The ENOMEM came before the DIR_ITEM was inserted,
>>>>> +			 * so the btree has our INODE_ITEM + INODE_REF but no
>>>>> +			 * directory entry. Convert this into an orphan so
>>>>> +			 * eviction (or crash-recovery) cleans up the inode.
>>>>> +			 */
>>>>> +			clear_nlink(inode);
>>>>> +			ret = btrfs_orphan_add(trans, BTRFS_I(inode));
>>>>> +			if (unlikely(ret))
>>>>> +				btrfs_abort_transaction(trans, ret);
>>>>
>>>> I feel like the crux of this series to me is whether you have practical
>>>> conditions where the allocation of the delayed_node is failing, but the
>>>> allocations involved in btrfs_orphan_add() succeed. It allocates a
>>>> btrfs_path and has to walk the btree which might have to read the node
>>>> at every level which might need to allocate 16k extent buffers and
>>>> extent buffer objects and xarray storage for each one. For size
>>>> reference, on my build (maybe debug..?) a delayed_node is 552 bytes,
>>>> while a btrfs_path is 112 and an extent_buffer is 432. So they are
>>>> pretty similar in size (not to mention the 16k of node file backed
>>>> memory we are sort of likely to have to allocate if we are under
>>>> reclaim)
>>>>
>>>> Were you able to reproduce this issue and help in practice or is this a
>>>> theoretical / structural improvement?
>>>>
>>>
>>> I didn't really try to reproduce this in earnest. We only see it in our
>>> fleet under heavy memory pressure, and even then at such low frequency,
>>> I doubt our chances of hitting this on anything other than a huge set
>>> of machines.
>>>
>>> So, theoretical / structural, but we have record of filesystem aborts
>>> where the stack indicates that this would have prevented it. Userland
>>> would have gotten an -ENOMEM back but the fs wouldn't have aborted.
>>>
>>
>> My concern is not that we don't hit ENOMEM in btrfs_add_link(), since
>> like you said we can observe that in abort logs. I am worried that even
>> if we try to handle it gracefully, we will just ENOMEM in
>> btrfs_orphan_add() and abort anyway. That is why I was wanting to see
>> some more concrete evidence this actually helps to make it worth the
>> complexity.
>>
> 
> In the case where we handle this gracefully, we won't hit that because
> it will have returned -ENOMEM before that point. But, you do have a
> good point that we could allocate these objects successfully, and then
> hit an error in btrfs_orphan_add() anyway.
> 
> One thought: It looks like the main allocation in that codepath is
> btrfs_alloc_path()? We could consider preallocating that too -- maybe
> stash it in a new pointer in btrfs_trans_handle?

For btrfs_alloc_path(), you can just use on-stack memory for that.

That's the practice we utilize for btrfs-progs, and it's still 
acceptable for kernel, since that structure is only 112 bytes.

We should not switch all btrfs_path to on-stack ones, but for critical 
ones that memory allocation can lead to trans abort, I'd say it's 
definitely worth the extra on-stack memory usage.

Thanks,
Qu

