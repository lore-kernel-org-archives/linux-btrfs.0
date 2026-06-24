Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 050482609EE
	for <linux-btrfs@vger.kernel.org>; Wed, 24 Jun 2026 04:33:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782275641; cv=none; b=Ie3k+WMlz8fo3VkY5l7YZ7TxhoseFfDb6DGyc/XlUs8DM/j5jbmVA1UE1ZvALCfz47GzDe7bcClhofQmpzTe8v3T3hA1aC0BI6wQ1RhgFSco8G1GSnRqjDrX6EzPTRO2BgvCrQemy8MqyDfn7NLE62W+LPl7rWt3CSsgnSurLn8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782275641; c=relaxed/simple;
	bh=vyM1w6SZuMouTZEauah3S4wSU6UwhKQ1ddurf0gUbI0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=pF1vQOR8iaRhNnUAmn6kazy4M0oftDarqbxJ15Cfs+kjfhYwf1g5hv/LxnsAPZzqsHw77d4Iz/qJIBDOPTnWAg2Y+5fmdntPLaVZvRyn6o3lVfGQP0mV9VcP4rC7bXIvFO+RuRNZf2x94qy4B1CgIVcDzJx5ynJR+7sxiP0XhFI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=WPCavf8y; arc=none smtp.client-ip=209.85.218.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="WPCavf8y"
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-bec423a5265so80272466b.1
        for <linux-btrfs@vger.kernel.org>; Tue, 23 Jun 2026 21:33:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1782275638; x=1782880438; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=FA5Cmrllgoed5eQLIDsMtEIJd/YAb1IwbQVWqydCdFs=;
        b=WPCavf8yPMWww9jQIIIprPyVaALwrZiinT73iZQ8YjNtSFTLYNvd31P5MqqRDbnEhq
         AA0NQe3OgkFVaVpPB94CidUPkpn3gB35dHq3cmNiJtd9uIRPArI+ak8py7TFX4XHi45y
         bBzPd2geUxYkT+LmssXOPGqCj2XGCO0vwyb3c9l6deDMIlPBiFjO7S65HPUUere/VlYJ
         9E3gni7kV2Mz6c0WCMj2rDQjVRq85Wp6AedmZSNpytet1AkefYdWXci7Ah2ldpmU2Sn2
         JE5+IkA5giEYRslZZxalt9Fs/YnF2EVlbbW8uKZ7L2nqPGJDJUP/frPELv88bNHdjn3z
         Uwkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782275638; x=1782880438;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FA5Cmrllgoed5eQLIDsMtEIJd/YAb1IwbQVWqydCdFs=;
        b=b0K1jQcwmFBReyUJkBIafJptnhSR8XvJH3hmmZpP/cARI5RcGyhDmv14p2EKGxIluN
         REOkCelyqE/rjX83Kpceg1mGueWG9KPUWbLGH518Kk2JX0mqsR24p3YxRHqOVB8nwEdO
         dbV8JOT6qcR9oRvfMySz+qZIyUXEuXA9UG9oaGQDyqzuOGdX52JI3PnrvYWf195VEY4O
         L/rkUA2bS1HSk3oQ8XbT1WsBbRUIG5izd5okOZmnr4y/SlpbLJKxk105xt2b99y5S2+w
         3TeN/iN9Z30ZKYEpNJfcVUYgraygLavb3OLH5usro4yabIgebz5vrcfCR1quPBCeVIrQ
         +J8w==
X-Gm-Message-State: AOJu0YyFFsDNUBpt6mtqchATGJLs9oBs0M/qpDuGpTJFGIBnLSchdyOs
	p3M+iyHQpRnOoWmeTzzS8IHunhfntnBh1Wrid26Mmw8Ao43NEcjKA7xnA9l7s27eU8BoWMzcBFF
	4HsiZel4=
X-Gm-Gg: AfdE7cmp9EOVBxnaCHxpxHofjhdRzFIrBplnPJjrjrwWQYBIjITlWhclzVhkUZe7R9l
	pKjVXW30W1Jsh1yAm2M6wyIB4FaBNAvNnTpSdOX+amjURl74hKmWBybaa50RTwTTfEbSGQbTgWQ
	afUun8pLI43BVozHiuo6JspWuMlBvIzzgJ/IWHLNGWr8FIxOtWcuXTy8DfArwvVOdHqh97mgHTL
	U3YABO5a5b5R8FuEAnygLlsfngPCzsIXh0CrOj74iBqGI07BvccE4Xirn56K5QBSJR2JzDxNw8e
	3c56jRPCpDkDICX2u2kA4CxaqutbPR74q1ps6f732FNvuJOBj/j2ey0wFeF13JE4dCWLBy7EwZ6
	Wcw9mLocYl8OEyZqKBi7sxGGh2pmhDsKc2p5IXWVN99zPiPpQGYPbmDAJAEyPlhdWLqv/RSsq9o
	5zzla2Ishs3adndDjuR6EcaGnT6gDIeG4X0XfGV4Oz
X-Received: by 2002:a17:907:3f1d:b0:bfe:ed35:e856 with SMTP id a640c23a62f3a-c119fc297e6mr67263366b.50.1782275638281;
        Tue, 23 Jun 2026 21:33:58 -0700 (PDT)
Received: from ?IPV6:2403:580d:fda1::299? (2403-580d-fda1--299.ip6.aussiebb.net. [2403:580d:fda1::299])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-845a41474cfsm792939b3a.61.2026.06.23.21.33.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 23 Jun 2026 21:33:57 -0700 (PDT)
Message-ID: <84936aad-7351-4d75-b68a-d13bf472453f@suse.com>
Date: Wed, 24 Jun 2026 14:03:52 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] btrfs: print-tree: print header owner as signed
To: Boris Burkov <boris@bur.io>
Cc: linux-btrfs@vger.kernel.org
References: <cover.1782168847.git.wqu@suse.com>
 <20260622225540.9ZqL0Mh2J9h-lFv7N3RWN2wumRXixcik8a0xiNBBO-c@z>
 <20260624042621.GC2011094@zen.localdomain>
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
In-Reply-To: <20260624042621.GC2011094@zen.localdomain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/6/24 13:56, Boris Burkov 写道:
> On Tue, Jun 23, 2026 at 08:25:40AM +0930, Qu Wenruo wrote:
>> When dumpping a tree block, btrfs_header::owner is printed as
>> unsigned, which can result in numbers that are hard to read, e.g:
>>
>>   BTRFS info (device loop0): leaf 8908800 gen 16 total ptrs 28 free space 1676 owner 18446744073709551607
>>
>> For the above output, 18446744073709551607 is (s64)-9, the root id of data
>> reloc tree.
>>
>> Despite those pre-defined root ids that are already negative, existing
>> subvolume trees will not have any negative values, as subvolume trees can
>> only utilize the lower 48 bits, so there will be no output change for
>> existing subvolumes, thus no extra confusion.
>>
> 
> What do you think about a macro or function wrapping a switch statement
> that also prints the string name of known trees?

That is possible, but I'm not sure if we need to go this complex for 
kernel modules.

A signed s64 output would be enough for most developers/advanced users 
to debug.
For end users, I do not know if things like 2 or EXTENT_TREE make any 
difference.

> What about some identifying
> info like a volume path for subvol trees? That one might be a stretch.

That's is too dangerous, it will need extra tree search and backref lookup.
Meanwhile for a tree dump inside a kernel, it's already an emergency, 
normally we do not have the extra headroom for such complex workload 
just to make the subvolume id a little easier to read.

Thanks,
Qu

> 
> Anyway, this is already a definite improvement, thanks.
> Reviewed-by: Boris Burkov <boris@bur.io>
> 
>> Signed-off-by: Qu Wenruo <wqu@suse.com>
>> ---
>>   fs/btrfs/print-tree.c | 8 ++++----
>>   1 file changed, 4 insertions(+), 4 deletions(-)
>>
>> diff --git a/fs/btrfs/print-tree.c b/fs/btrfs/print-tree.c
>> index 87e60a2d4bd8..53e726119ca7 100644
>> --- a/fs/btrfs/print-tree.c
>> +++ b/fs/btrfs/print-tree.c
>> @@ -449,9 +449,9 @@ void btrfs_print_leaf(const struct extent_buffer *l)
>>   	nr = btrfs_header_nritems(l);
>>   
>>   	btrfs_info(fs_info,
>> -		   "leaf %llu gen %llu total ptrs %d free space %d owner %llu",
>> +		   "leaf %llu gen %llu total ptrs %d free space %d owner %lld",
>>   		   btrfs_header_bytenr(l), btrfs_header_generation(l), nr,
>> -		   btrfs_leaf_free_space(l), btrfs_header_owner(l));
>> +		   btrfs_leaf_free_space(l), (s64)btrfs_header_owner(l));
>>   	print_eb_refs_lock(l);
>>   	for (i = 0 ; i < nr ; i++) {
>>   		char key_buf[KEY_TYPE_BUF_SIZE];
>> @@ -600,10 +600,10 @@ void btrfs_print_tree(const struct extent_buffer *c, bool follow)
>>   		return;
>>   	}
>>   	btrfs_info(fs_info,
>> -		   "node %llu level %d gen %llu total ptrs %d free spc %u owner %llu",
>> +		   "node %llu level %d gen %llu total ptrs %d free spc %u owner %lld",
>>   		   btrfs_header_bytenr(c), level, btrfs_header_generation(c),
>>   		   nr, (u32)BTRFS_NODEPTRS_PER_BLOCK(fs_info) - nr,
>> -		   btrfs_header_owner(c));
>> +		   (s64)btrfs_header_owner(c));
>>   	print_eb_refs_lock(c);
>>   	for (i = 0; i < nr; i++) {
>>   		btrfs_node_key_to_cpu(c, &key, i);
>> -- 
>> 2.54.0
>>

