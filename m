Received: from mail-ej2-f12.google.com (mail-ej2-f12.google.com [74.125.228.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 563873446CE
	for <linux-btrfs@vger.kernel.org>; Fri, 25 Sep 2026 09:36:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.228.140
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790329016; cv=none; b=JCbdb3wkHryXSyirKtqe+T6wEOjzdkU/gu7kH10vm2WJMt+eBJ4Q5G1HZ5MW7UK5eLe3HcUQAkZbH9dciX6d8ABGs7TPKxPuvnZkTsHKcC9SVMxOP6eiNeIk0/Hb7jc5qnsLpR3lUW8ktsurk1SEpXGtHJC39XwnJ30Pu6ZlnWA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790329016; c=relaxed/simple;
	bh=XvoVZdQi6AxZjBnPpKPcJBpZjpweGFY9hvlMUHRTCc4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=X9TXjfZ+a7XBRFpNTvgOYPchDvthyK0vimyuhnXIyGEl/6t5T4hB7yskL/LEeS79KyIb4Rfjro4u6l+99lPX+t2EuWMr06vqemadKY9DlrdeKpfPprRCZK3QbS9qkUQOoz/g/WFKW8QxG1mjlvnD/5psKZurYkpwoD2Q2wXGbGQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=VhHgeql7; arc=none smtp.client-ip=74.125.228.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="VhHgeql7"
Received: by mail-ej2-f12.google.com with SMTP id a640c23a62f3a-c254f9f7dbeso79165366b.0
        for <linux-btrfs@vger.kernel.org>; Fri, 25 Sep 2026 02:36:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1790329012; x=1790933812; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=OpoKE/9K/lMPmvSbP0GEZC7SHU/ezB7i+IdMTJYgOTA=;
        b=VhHgeql7urgOKF1tdQyj8t8O9SKnw9Oa3nO8GGv9TEqDYIMYwPFxoNXEFpsWZ2hS/+
         sbbLXH1KZQOhOkQucSe700AYxheGKtBTm/1h2iU/VxlWI47hz3ygDWU0uLDDaL7P0FzI
         n5JQLkjVY6PGNa5Dk9wQVRpIPP3TSxWNhhayjXQyMfpidaSLXFkj58GiUT9WVv+GMaqZ
         aHxRYAxCqfsiMD31MwYLI681FHOS69fi02SHkoCV24UBUzhZwLVD2bAOR7qk6PiAxuij
         mmfzSkS/8umpAwhMXRiVyCD44WzAxXNN73gY8UMcjJRKyjPVqZ7YNhoMA2Soh5JYJfRJ
         f42A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790329012; x=1790933812;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=OpoKE/9K/lMPmvSbP0GEZC7SHU/ezB7i+IdMTJYgOTA=;
        b=UuKDLIYPtBjabAXdgwtlpp3Q5k8wGhJDYvsBXwFIDCqxEUN3htgZN0F9JcxL0FbT/Q
         piVfVa4bAGs0lad7geroDs0a7ukdPjV6GP0F9t0nSgnoi+7gXbkLRU/cOhNmmT1FymJ4
         iFUt5rRL85RVMxJacXp4Iu/8XblwV51p99U9zbGH+IiNxCbzng/a3RH67zIoNolgXtWC
         m7oUWcJr1P8JvMnMi72/7vQkHrmu4gaGBuJHNHHrjCaEMeUvfZum/ipZ/29igTx0Tcm2
         o9lmhpHFF9iK0RGv7oZFzTzSRUcouYQa45jeYCjWGx+j5SBB8WsF57cPuPrDD6BYGSoK
         ydJA==
X-Gm-Message-State: AFuF++kcfM27CVZkskVVzcKMXlwnUocWUVpx3WCAjNgAH+Ku68gqIqVP
	8LGIQN7zV608qHcSJhvIV5D6RR6f+/LyofqVxaygyh4UB5JFCqQrRbbBx3b93wDW3bpKa/0ouKk
	iui7L1+lrdg==
X-Gm-Gg: AYBFou1CZzt0peMVXZrkS5Q/b3EAzphJTGIPdOURMlXhnJnNwWhihkuZPQ7ZSKdG6WU
	UXY+mJQoQ/P4d2J1P+GnRW7j1PXBhzDEiortiGk8vepGcGOAiu/0/gwk2AcS8Vp6o0+7K5Un/cT
	Ay+nosspAHD3JoXYTxnxQ8ZEo5M33vdKkzeNNr3/nR84wUJkMvbhxW7icVQuwvqx5U+8dzCMAy6
	WA45waldrxmv4Bj/ccM+aIjsoqdahEPIl/4c/y9wu+4IexKL3qdzKAIqsXSk0Eh6w816n+/RDyf
	Ew4BLb1prM0dXa/gEQDKTrxfaCy5h2Yurbt5T1tQ41gGq6DBud8tkZIFkwa2R7sNkJmzsJ6qbDK
	UBoKkqaZFjcNBQ1sM0RIZPchl6zwgLxGKRkjyj0n19izLSnYMfIeibm4Kcj6tuhmDE1zZ5CetnB
	Uw9PgKS6Yx9fsSkz50vy305PaQWpEROsXkpC4/tv3kdqdjOT1YNk/eBRXMnNlNiQ8=
X-Received: by 2002:a17:907:72d0:b0:c25:1a5:62a4 with SMTP id a640c23a62f3a-c2ac24743bemr443776866b.17.1790329012226;
        Fri, 25 Sep 2026 02:36:52 -0700 (PDT)
Received: from [172.16.0.229] ([159.196.52.54])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-87fea1940ecsm781053b3a.13.2026.09.25.02.36.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 25 Sep 2026 02:36:51 -0700 (PDT)
Message-ID: <d7f7b009-5d0a-4a45-830c-36c280f49fac@suse.com>
Date: Fri, 25 Sep 2026 19:06:47 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 1/6] btrfs: add delayed ordered extent support
To: =?UTF-8?Q?Miquel_Sabat=C3=A9_Sol=C3=A0?= <mssola@mssola.com>
Cc: linux-btrfs@vger.kernel.org
References: <cover.1790327143.git.wqu@suse.com>
 <6ebe74a6226526dc9c1d3d00e99468d010f16119.1790327143.git.wqu@suse.com>
 <6ab63fad.d0a3cccc.111ed5.df78SMTPIN_ADDED_BROKEN@mx.google.com>
Content-Language: en-US
From: Qu Wenruo <wqu@suse.com>
Autocrypt: addr=wqu@suse.com; keydata=
 xsBNBFnVga8BCACyhFP3ExcTIuB73jDIBA/vSoYcTyysFQzPvez64TUSCv1SgXEByR7fju3o
 8RfaWuHCnkkea5luuTZMqfgTXrun2dqNVYDNOV6RIVrc4YuG20yhC1epnV55fJCThqij0MRL
 1NxPKXIlEdHvN0Kov3CtWA+R1iNN0RCeVun7rmOrrjBK573aWC5sgP7YsBOLK79H3tmUtz6b
 9Imuj0ZyEsa76Xg9PX9Hn2myKj1hfWGS+5og9Va4hrwQC8ipjXik6NKR5GDV+hOZkktU81G5
 gkQtGB9jOAYRs86QG/b7PtIlbd3+pppT0gaS+wvwMs8cuNG+Pu6KO1oC4jgdseFLu7NpABEB
 AAHNGFF1IFdlbnJ1byA8d3F1QHN1c2UuY29tPsLAlAQTAQgAPgIbAwULCQgHAgYVCAkKCwIE
 FgIDAQIeAQIXgBYhBC3fcuWlpVuonapC4cI9kfOhJf6oBQJqqw0NBQkUl/JeAAoJEMI9kfOh
 Jf6o/xYH/3AaWnGSq58XnY/T3/YYjr6g+TUZxa7MPyiYTELNpNlvmNlbtbAL0nW0LNvkeiqf
 SmYA+xkwY4RbxnZYQK0H5iv2w1eqa9qqFZb4bIBRmTapu26GEEkpad0W0ZhoSPMO8bV2Bwkf
 YdtPZQLaeUKvHZqNqBKnmtRLQj2Cgy3kuXX3bEGvWjzUOxPUSCj/S++JWBewMdMBPT62vZM0
 3156gfn5mHA94s2p+NFJoWkERY+JPTMu9NISkpD7yuGhXN88qd/aqD0RrlhxvKsrQogdPwn9
 vP18FGG3CRlHtOvOLVoY5NKSOWTDc+o+8t2XEETFTGbKYTcqeTzi4SxhvBLtTinOwE0EWdWB
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
In-Reply-To: <6ab63fad.d0a3cccc.111ed5.df78SMTPIN_ADDED_BROKEN@mx.google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/9/25 19:02, Miquel Sabaté Solà 写道:
> Qu Wenruo @ 2026-09-25 18:37 +0930:
> 
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
>> - Child OEs will not be added to the per-inode OE rb-tree nor
>>    per-root list
>>    Only the parent OE is added to the per-inode rb-tree and per-root
>>    list.
>>    So anything waiting for ordered extents should only work on the parent
>>    one.
>>
>>    There is a special corner case for btrfs_wait_ordered_extents(), as
>>    delayed parent OEs have 0 disk_bytenr and disk_num_bytes, they will
>>    be considered out of the [0, U64_MAX] range.
>>    Thus we have to always wait for any delayed OEs of a root, no matter
>>    if a block group range is given or not.
>>
>> - When the parent OE finishes, all child OEs will also be finished
>>    And reserved space is all handled by the child OEs.
>>
>> - Any range not covered by a child OE will be manually cleaned up
>>    When adding a child OE to the parent one, the range in
>>    child_cleanup_bitmap will be cleared.
>>
>>    If a range is already cleaned up but without a child OE (happens when
>>    OE allocation failed), whoever cleans up the range should clear the bits
>>    in the child_cleanup_bitmap.
>>
>>    And when the parent OE finishes, any range in child_cleanup_bitmap
>>    will be properly cleaned up.
>>
>> The above features allow us to use the existing ordered extent interfaces
>> to allocate new real OEs, and wait for them properly.
>>
>> Signed-off-by: Qu Wenruo <wqu@suse.com>
>> ---
>>   fs/btrfs/inode.c        |  86 ++++++++++++++++++-
>>   fs/btrfs/ordered-data.c | 185 ++++++++++++++++++++++++++++++----------
>>   fs/btrfs/ordered-data.h |  20 +++++
>>   3 files changed, 243 insertions(+), 48 deletions(-)
>>
>> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
>> index 2a32072849cb..e9ed3e31fa88 100644
>> --- a/fs/btrfs/inode.c
>> +++ b/fs/btrfs/inode.c
>> @@ -3204,6 +3204,81 @@ static int insert_ordered_extent_file_extent(struct btrfs_trans_handle *trans,
>>   					   update_inode_bytes, oe->qgroup_rsv);
>>   }
>>
>> +static int finish_delayed_ordered(struct btrfs_ordered_extent *oe)
>> +{
>> +	struct btrfs_inode *inode = oe->inode;
>> +	struct btrfs_fs_info *fs_info = inode->root->fs_info;
>> +	struct btrfs_ordered_extent *child;
>> +	struct btrfs_ordered_extent *tmp;
>> +	struct extent_state *cached = NULL;
>> +	const u32 nr_bits = oe->num_bytes >> fs_info->sectorsize_bits;
>> +	bool io_error = test_bit(BTRFS_ORDERED_IOERR, &oe->flags);
> 
> I believe this one can be made "const", right?

This is a very minor one, I can do it during merge.
