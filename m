Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0494428CF5F
	for <linux-btrfs@vger.kernel.org>; Wed, 22 Jul 2026 09:25:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784712318; cv=none; b=BCLbzpOTh+nIxMEAV/76UPeRIlufO6wBNt+fyUBIJpJU/y12FkPfHlaI3gWanpsv1RV8ihKLnpQertKY59Qc0yARDF+tsx5pLyWKt7Mcpogn9kjsdhU7ofSeNEkzc/WhxDYCQtiwULDrprNDTu60dyh2I+GtSHPB5EusgZP7uxw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784712318; c=relaxed/simple;
	bh=w+kh/cRRJQcD2CexzJE/NsgP6MBV4QvKIreQYplfT1I=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=n7ssbr5ZSKIpZP2nM1tg8/78EFAbM2o7SBzlD2hh6HH2nq5vlOVKC0Q/MjTvh9zXRKQ4NhQQM1ijUJqUJDINVuk98/8Uu/HuWgJC4R277Eql+Z05Bni3hAmo4CouCdYRCaOKog9iWN5H3Al6RgHZTws1TLKSqCQTmArwesY30Dg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=IkHv0Naw; arc=none smtp.client-ip=209.85.218.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="IkHv0Naw"
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-c1601d552a8so1299805566b.2
        for <linux-btrfs@vger.kernel.org>; Wed, 22 Jul 2026 02:25:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1784712314; x=1785317114; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=IxGy9jUkSPos1lzmBXsp2yTEvbHdEsG8KYX6ta8Ughg=;
        b=IkHv0NawOqltUrgtmFHqVQtkkOqvn+y9kq3BqX7/L1EvpcSKU3YMdjUbc/4T/tAA5J
         nOvI19429HPv4yddMbPeuJrCCuszGVevmdOdwY8kdthkUmB8ow/o8qwU92ES+1jh8gTw
         5GPVOl6fjXUj0oOAWsMLRe7l++4BDzKFwW7K35u5hZeBb4qL6wamBpUgRT8t1zXalX0O
         TdZKClLSLYoYVlPppnvK2L0V3tFJ4Xtz1gNF4olYpKT9anx1vkCAdjnduTu/0W71cd8p
         iGbdbfs4pp1gZT7tW3wc/TBtNqGqG6EaBE6hWyn4a8QuP5VURNKUepP3JU2q52RH+maD
         pysA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784712314; x=1785317114;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=IxGy9jUkSPos1lzmBXsp2yTEvbHdEsG8KYX6ta8Ughg=;
        b=c8IHgazok+RLcP6s+fHZnG7fD6xsqbKwVe6ubJrIy075pS3dttFf2rCwL3dkH8KXdY
         GYUfvW7ChBg9u4U6Qj4zSKZqhs9Vuqfr22IxexWDXzupO28+MI7hacPEJWaaiaEj8u1O
         Hn+WVPAnLOEKzZ3bBUfXZYb5DK8i5sSQ8fIlSu4f0iOT8H1fPjn7pfwK6tHRbkRKbDHL
         /1/vDiFivpBlBFpSS6SpbcbXO1ESTVa1TkXKF4xJ30UIZSPUuyiFUtUqIFqWwsuQOEP8
         9ZK4dEX2IGFqs5X2qUCsvNEtJopUH6HRifzVY6L14H2RaaVtoKd/rcSjtvqA98Gy1Woz
         sVvA==
X-Forwarded-Encrypted: i=1; AHgh+Rp4R/31zANjJF6H4oLfsLEQ32XoP0kwKkWWVZiN8CZX2yTy1lPqZ6WOmeWtF7TVpf/Vg7Z66i1X58YH2w==@vger.kernel.org
X-Gm-Message-State: AOJu0YwfKidbLt6zkYqiMJU9TXIANC/C7TgUjm+IY2QA96ZRvqyMPPAG
	YwbCcmh+uxKIM0acZVP0TqP6/gDDENo2dJNAtgbY2DLryGEna2y6VWpQ5hfO3d0084Q=
X-Gm-Gg: AR+sD135nTAIPTR/tvzag3kW2SdtZuSjlVy25nfP4pGblWcrwwvEBuMZ0JC/PGNVy25
	L3pnM118X93QMILMwyxpMghdWQeUCmN1zEikazYP99YiJQcywMrGwpfAedGToczn/4C414EpMtP
	I6o2LvH7aMxFMzZIbiks//IkwpWz/niko/R5S8iazCtB6307FXl9H/yLX+d91+3uzHlL/ufGafK
	Yw8lO6MCR1ELQOlsk+TcYKDqplbUxvf9w97RcvDocdBmF1mCYJPsGwSiGQUh7beOu85QbsBQ1d+
	DUxh8+Hr2Iwk9vjZuFeqXgop0//T/DYIIXLjM81hfNLmP3GdmCveL57DyKCkS3YZiudjmbygHAO
	widWbZGKhHgIO3t2HqO1eyM7ufxUYX0SuS8w5nBALYHePbLQZNf5TpsgoP0OOJhnvY6lMn2s=
X-Received: by 2002:a17:907:d22:b0:c1c:254c:16c1 with SMTP id a640c23a62f3a-c1c254c27bcmr213237666b.0.1784712313795;
        Wed, 22 Jul 2026 02:25:13 -0700 (PDT)
Received: from [172.16.0.229] ([159.196.52.54])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-38ea5986b9fsm553733a91.4.2026.07.22.02.25.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Jul 2026 02:25:12 -0700 (PDT)
Message-ID: <5b91fb7e-479d-4e6f-8d34-40eaf1d675d2@suse.com>
Date: Wed, 22 Jul 2026 18:55:03 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC] btrfs: implement a new compat RO feature,
 data_io_size
To: Sun YangKai <sunyangkai@fygo.io>, linux-btrfs@vger.kernel.org
References: <f67b00bbe7b5fb4c59a45a6390c98add303a83c1.1782627906.git.wqu@suse.com>
 <647fd7cc-f948-4260-b26e-122a61ca7a16@fygo.io>
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
In-Reply-To: <647fd7cc-f948-4260-b26e-122a61ca7a16@fygo.io>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/7/22 18:52, Sun YangKai 写道:
> On 2026/6/28 14:27, Qu Wenruo wrote:
>> To address the btrfs RAID56 write-hole problem, there is one idea to
>> solve it:
>>
>>    Make sure all data writes are full stripe aligned
>>
>> However based on that idea, we can have two different directions to
>> implement:
>>
>> - Keep the sector size untouched, introduce a newer io size for data
>>     E.g. sector size is still 4K, but data io size is 16K, and RAID56
>>     full stripe size is also set to 16K.
> 
> Sorry, I cannot follow you here about "RAID56 full stripe size is also
> set to 16K".

Just as what it reads.

Not using the fixed 64K stripe size, but per-chunk full stripe size.

> 
> Currently I think we have a 64KiB chunk on each disk, and for n disks
> RAID5, we have (n-1) * 64KiB as data's full stripe size and one more
> 64KiB for parity if I understand it correctly. Then how can we limit the
> full stripe size to 16K with n devices?
> 
> 16K/(n-1) bytes on each disk is insane. Or we just limit device count
> for RAID5 to a specific number like 3 disks so we can have 2 device for
> data, 1 for parity and can get a 8KiB chunk on each disk?
> 
>>     This allows us to reuse the existing sector size based
>>     read-repair/scrub.
>>
>>     And this patch is the PoC of this idea.
>>
>>     The problems are also obvious, we need to not only introduce a
>>     dedicated compat RO flag, but also convert almost all sectorsize users
>>     to use the new data_io_size, except data checksum and read-repair
>>     related code.
>>
>> - Use larger block size, introduce a newer sub-block RAID56 repair
>>     E.g. sector size is 16K, and RAID56 full stripe size is also set to
>>     16K.
>>
>>     This allows us to reuse the existing experimental bs > ps support.
>>
>>     The problems are that we need a completely new RAID56 sub-block
>>     rebuild handling.
>>     And the new rebuild can be very slow. Since we do not know exact which
>>     sub-block is corrupted, we have to exhaust all combinations just for a
>>     single block.
>>
>>     And the current btrfs_map_block() also need to support sub-block
>>     splitting, which is completely new, and will also affect checksum
>>     handling.
>>
>> So far it looks like the new data io size is the easier solution, thus
>> here is the RFC patch.
>>
>> But in reality, this RFC patch is already super huge, almost touching
>> all call sites using fs_info->sectorsize, and there are still a lot of
>> left-over and causing all kinds of warnings.
>>
>> For now I'm wondering if it would be better just to replace sectorsize
>> with data_io_size, and introduce a dedicated member for checksum/scrub.
>>
>> Signed-off-by: Qu Wenruo <wqu@suse.com>
>> ---
>> Reason for RFC:
>> This patch is still very unstable, there are still a lot of sites not
>> properly converted to use the new fs_info->data_io_size.
>>
>> This is only for proof-of-concept purpose.
>> ---
>>    fs/btrfs/accessors.h            |  2 +
>>    fs/btrfs/direct-io.c            |  6 +--
>>    fs/btrfs/disk-io.c              | 23 ++++++++++-
>>    fs/btrfs/file.c                 | 68 ++++++++++++++++-----------------
>>    fs/btrfs/fs.h                   |  9 ++++-
>>    fs/btrfs/inode.c                | 60 ++++++++++++++---------------
>>    fs/btrfs/lzo.c                  |  2 +-
>>    fs/btrfs/sysfs.c                |  2 +
>>    fs/btrfs/tests/btrfs-tests.c    |  1 +
>>    include/uapi/linux/btrfs.h      |  7 ++++
>>    include/uapi/linux/btrfs_tree.h |  3 +-
>>    11 files changed, 112 insertions(+), 71 deletions(-)
>>
>> diff --git a/fs/btrfs/accessors.h b/fs/btrfs/accessors.h
>> index 8938357fcb40..7a5206db2224 100644
>> --- a/fs/btrfs/accessors.h
>> +++ b/fs/btrfs/accessors.h
>> @@ -889,6 +889,8 @@ BTRFS_SETGET_STACK_FUNCS(super_remap_root_generation, struct btrfs_super_block,
>>    			 remap_root_generation, 64);
>>    BTRFS_SETGET_STACK_FUNCS(super_remap_root_level, struct btrfs_super_block,
>>    			 remap_root_level, 8);
>> +BTRFS_SETGET_STACK_FUNCS(super_data_io_size, struct btrfs_super_block,
>> +			 data_io_size, 32);
>>    
>>    /* struct btrfs_file_extent_item */
>>    BTRFS_SETGET_STACK_FUNCS(stack_file_extent_type, struct btrfs_file_extent_item,
>> diff --git a/fs/btrfs/direct-io.c b/fs/btrfs/direct-io.c
>> index 3e227292b0ac..df1b2f2725ca 100644
>> --- a/fs/btrfs/direct-io.c
>> +++ b/fs/btrfs/direct-io.c
>> @@ -186,7 +186,7 @@ static struct extent_map *btrfs_new_extent_direct(struct btrfs_inode *inode,
>>    
>>    	alloc_hint = btrfs_get_extent_allocation_hint(inode, start, len);
>>    again:
>> -	ret = btrfs_reserve_extent(root, len, len, fs_info->sectorsize,
>> +	ret = btrfs_reserve_extent(root, len, len, fs_info->data_io_size,
>>    				   0, alloc_hint, &ins, true, true);
>>    	if (ret == -EAGAIN) {
>>    		ASSERT(btrfs_is_zoned(fs_info));
>> @@ -395,7 +395,7 @@ static int btrfs_dio_iomap_begin(struct inode *inode, loff_t start,
>>    	 * to allocate a contiguous array for the checksums.
>>    	 */
>>    	if (!write)
>> -		len = min_t(u64, len, fs_info->sectorsize * BIO_MAX_VECS);
>> +		len = min_t(u64, len, fs_info->data_io_size * BIO_MAX_VECS);
>>    
>>    	lockstart = start;
>>    	lockend = start + len - 1;
>> @@ -829,7 +829,7 @@ static struct iomap_dio *btrfs_dio_write(struct kiocb *iocb, struct iov_iter *it
>>    static ssize_t check_direct_IO(struct btrfs_fs_info *fs_info,
>>    			       const struct iov_iter *iter, loff_t offset)
>>    {
>> -	const u32 blocksize_mask = fs_info->sectorsize - 1;
>> +	const u32 blocksize_mask = fs_info->data_io_size - 1;
>>    
>>    	if (offset & blocksize_mask)
>>    		return -EINVAL;
>> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
>> index e4ffcd49d7af..29797b767df7 100644
>> --- a/fs/btrfs/disk-io.c
>> +++ b/fs/btrfs/disk-io.c
>> @@ -2508,6 +2508,23 @@ int btrfs_validate_super(const struct btrfs_fs_info *fs_info,
>>    		ret = -EINVAL;
>>    	}
>>    
>> +	if (btrfs_fs_compat_ro(fs_info, DATA_IO_SIZE)) {
>> +		const u32 data_io_size = btrfs_super_data_io_size(sb);
>> +
>> +		/*
>> +		 * If data io size is set, make sure it is not smaller than
>> +		 * sectorsize.
>> +		 * And for now we only support data io size up to MAX_BLOCKSIZE.
>> +		 */
>> +		if (unlikely(!is_power_of_2(data_io_size) ||
>> +			     data_io_size < sectorsize ||
>> +			     data_io_size > BTRFS_MAX_BLOCKSIZE)) {
>> +			btrfs_err(fs_info,
>> +	"invalid data io size, has %u expect power of 2 number in range [%u, %u]",
>> +				  data_io_size, sectorsize, BTRFS_MAX_BLOCKSIZE);
>> +			ret = -EINVAL;
>> +		}
>> +	}
>>    	if (btrfs_fs_incompat(fs_info, REMAP_TREE)) {
>>    		/*
>>    		 * Reduce test matrix for remap tree by requiring block-group-tree
>> @@ -3472,8 +3489,12 @@ int __cold open_ctree(struct super_block *sb, struct btrfs_fs_devices *fs_device
>>    	fs_info->nodesize = nodesize;
>>    	fs_info->nodesize_bits = ilog2(nodesize);
>>    	fs_info->sectorsize = sectorsize;
>> +	if (btrfs_fs_compat_ro(fs_info, DATA_IO_SIZE))
>> +		fs_info->data_io_size = btrfs_super_data_io_size(disk_super);
>> +	else
>> +		fs_info->data_io_size = sectorsize;
>>    	fs_info->sectorsize_bits = ilog2(sectorsize);
>> -	fs_info->block_min_order = ilog2(round_up(sectorsize, PAGE_SIZE) >> PAGE_SHIFT);
>> +	fs_info->block_min_order = ilog2(round_up(fs_info->data_io_size, PAGE_SIZE) >> PAGE_SHIFT);
>>    	fs_info->block_max_order = calc_block_max_order(fs_info->sectorsize_bits);
>>    	fs_info->csums_per_leaf = BTRFS_MAX_ITEM_SIZE(fs_info) / fs_info->csum_size;
>>    	fs_info->fs_devices->fs_info = fs_info;
>> diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
>> index df8f6f565070..8397d96a5992 100644
>> --- a/fs/btrfs/file.c
>> +++ b/fs/btrfs/file.c
>> @@ -45,8 +45,8 @@
>>    static void btrfs_drop_folio(struct btrfs_fs_info *fs_info, struct folio *folio,
>>    			     u64 pos, u64 copied)
>>    {
>> -	u64 block_start = round_down(pos, fs_info->sectorsize);
>> -	u64 block_len = round_up(pos + copied, fs_info->sectorsize) - block_start;
>> +	u64 block_start = round_down(pos, fs_info->data_io_size);
>> +	u64 block_len = round_up(pos + copied, fs_info->data_io_size) - block_start;
>>    
>>    	ASSERT(block_len <= U32_MAX);
>>    	folio_unlock(folio);
>> @@ -78,8 +78,8 @@ int btrfs_dirty_folio(struct btrfs_inode *inode, struct folio *folio, loff_t pos
>>    	if (noreserve)
>>    		extra_bits |= EXTENT_NORESERVE;
>>    
>> -	start_pos = round_down(pos, fs_info->sectorsize);
>> -	num_bytes = round_up(end_pos - start_pos, fs_info->sectorsize);
>> +	start_pos = round_down(pos, fs_info->data_io_size);
>> +	num_bytes = round_up(end_pos - start_pos, fs_info->data_io_size);
>>    	ASSERT(num_bytes <= U32_MAX);
>>    	ASSERT(folio_pos(folio) <= pos && folio_next_pos(folio) >= end_pos);
>>    
>> @@ -395,7 +395,7 @@ int btrfs_drop_extents(struct btrfs_trans_handle *trans,
>>    			    extent_type == BTRFS_FILE_EXTENT_INLINE) {
>>    				args->bytes_found += extent_end - key.offset;
>>    				extent_end = ALIGN(extent_end,
>> -						   fs_info->sectorsize);
>> +						   fs_info->data_io_size);
>>    			} else if (update_refs && disk_bytenr > 0) {
>>    				struct btrfs_ref ref = {
>>    					.action = BTRFS_DROP_DELAYED_REF,
>> @@ -788,7 +788,7 @@ static int prepare_uptodate_folio(struct inode *inode, struct folio *folio, u64
>>    {
>>    	u64 clamp_start = max_t(u64, pos, folio_pos(folio));
>>    	u64 clamp_end = min_t(u64, pos + len, folio_next_pos(folio));
>> -	const u32 blocksize = inode_to_fs_info(inode)->sectorsize;
>> +	const u32 blocksize = inode_to_fs_info(inode)->data_io_size;
>>    	int ret = 0;
>>    
>>    	if (folio_test_uptodate(folio))
>> @@ -893,8 +893,8 @@ lock_and_cleanup_extent_if_need(struct btrfs_inode *inode, struct folio *folio,
>>    	u64 last_pos;
>>    	int ret = 0;
>>    
>> -	start_pos = round_down(pos, fs_info->sectorsize);
>> -	last_pos = round_up(pos + write_bytes, fs_info->sectorsize) - 1;
>> +	start_pos = round_down(pos, fs_info->data_io_size);
>> +	last_pos = round_up(pos + write_bytes, fs_info->data_io_size) - 1;
>>    
>>    	if (start_pos < inode->vfs_inode.i_size) {
>>    		struct btrfs_ordered_extent *ordered;
>> @@ -978,9 +978,9 @@ int btrfs_check_nocow_lock(struct btrfs_inode *inode, loff_t pos,
>>    	if (!btrfs_drew_try_write_lock(&root->snapshot_lock))
>>    		return -EAGAIN;
>>    
>> -	lockstart = round_down(pos, fs_info->sectorsize);
>> +	lockstart = round_down(pos, fs_info->data_io_size);
>>    	lockend = round_up(pos + *write_bytes,
>> -			   fs_info->sectorsize) - 1;
>> +			   fs_info->data_io_size) - 1;
>>    
>>    	if (nowait) {
>>    		if (!btrfs_try_lock_ordered_range(inode, lockstart, lockend,
>> @@ -1067,7 +1067,7 @@ int btrfs_write_check(struct kiocb *iocb, size_t count)
>>    	oldsize = i_size_read(inode);
>>    	if (pos > oldsize) {
>>    		/* Expand hole size to cover write data, preventing empty gap */
>> -		loff_t end_pos = round_up(pos + count, fs_info->sectorsize);
>> +		loff_t end_pos = round_up(pos + count, fs_info->data_io_size);
>>    
>>    		ret = btrfs_cont_expand(BTRFS_I(inode), oldsize, end_pos);
>>    		if (ret)
>> @@ -1090,7 +1090,7 @@ static void release_space(struct btrfs_inode *inode, struct extent_changeset *da
>>    		const struct btrfs_fs_info *fs_info = inode->root->fs_info;
>>    
>>    		btrfs_delalloc_release_space(inode, data_reserved,
>> -					     round_down(start, fs_info->sectorsize),
>> +					     round_down(start, fs_info->data_io_size),
>>    					     len, true);
>>    	}
>>    }
>> @@ -1107,7 +1107,7 @@ static ssize_t reserve_space(struct btrfs_inode *inode,
>>    			     bool *only_release_metadata)
>>    {
>>    	const struct btrfs_fs_info *fs_info = inode->root->fs_info;
>> -	const unsigned int block_offset = (start & (fs_info->sectorsize - 1));
>> +	const unsigned int block_offset = (start & (fs_info->data_io_size - 1));
>>    	size_t reserve_bytes;
>>    	int ret;
>>    
>> @@ -1132,7 +1132,7 @@ static ssize_t reserve_space(struct btrfs_inode *inode,
>>    		*only_release_metadata = true;
>>    	}
>>    
>> -	reserve_bytes = round_up(*len + block_offset, fs_info->sectorsize);
>> +	reserve_bytes = round_up(*len + block_offset, fs_info->data_io_size);
>>    	WARN_ON(reserve_bytes == 0);
>>    	ret = btrfs_delalloc_reserve_metadata(inode, reserve_bytes,
>>    					      reserve_bytes, nowait);
>> @@ -1192,7 +1192,7 @@ static int copy_one_range(struct btrfs_inode *inode, struct iov_iter *iter,
>>    	struct extent_state *cached_state = NULL;
>>    	size_t write_bytes = calc_write_bytes(inode, iter, start);
>>    	size_t copied;
>> -	const u64 reserved_start = round_down(start, fs_info->sectorsize);
>> +	const u64 reserved_start = round_down(start, fs_info->data_io_size);
>>    	u64 reserved_len;
>>    	struct folio *folio = NULL;
>>    	int extents_locked;
>> @@ -1301,7 +1301,7 @@ static int copy_one_range(struct btrfs_inode *inode, struct iov_iter *iter,
>>    		}
>>    
>>    		/* Release the reserved space beyond the last block. */
>> -		last_block = round_up(start + copied, fs_info->sectorsize);
>> +		last_block = round_up(start + copied, fs_info->data_io_size);
>>    
>>    		shrink_reserved_space(inode, *data_reserved, reserved_start,
>>    				      reserved_len, last_block - reserved_start,
>> @@ -1938,7 +1938,7 @@ static vm_fault_t btrfs_page_mkwrite(struct vm_fault *vmf)
>>    	}
>>    
>>    	if (folio_contains(folio, (size - 1) >> PAGE_SHIFT)) {
>> -		reserved_space = round_up(size - page_start, fs_info->sectorsize);
>> +		reserved_space = round_up(size - page_start, fs_info->data_io_size);
>>    		if (reserved_space < fsize) {
>>    			const u64 to_free = fsize - reserved_space;
>>    
>> @@ -2182,8 +2182,8 @@ static int find_first_non_hole(struct btrfs_inode *inode, u64 *start, u64 *len)
>>    	int ret = 0;
>>    
>>    	em = btrfs_get_extent(inode, NULL,
>> -			      round_down(*start, fs_info->sectorsize),
>> -			      round_up(*len, fs_info->sectorsize));
>> +			      round_down(*start, fs_info->data_io_size),
>> +			      round_up(*len, fs_info->data_io_size));
>>    	if (IS_ERR(em))
>>    		return PTR_ERR(em);
>>    
>> @@ -2396,7 +2396,7 @@ int btrfs_replace_file_extents(struct btrfs_inode *inode,
>>    	struct btrfs_root *root = inode->root;
>>    	struct btrfs_fs_info *fs_info = root->fs_info;
>>    	const u64 min_size = btrfs_calc_insert_metadata_size(fs_info, 1);
>> -	u64 ino_size = round_up(inode->vfs_inode.i_size, fs_info->sectorsize);
>> +	u64 ino_size = round_up(inode->vfs_inode.i_size, fs_info->data_io_size);
>>    	struct btrfs_trans_handle *trans = NULL;
>>    	struct btrfs_block_rsv rsv;
>>    	unsigned int rsv_count;
>> @@ -2667,7 +2667,7 @@ static int btrfs_punch_hole(struct file *file, loff_t offset, loff_t len)
>>    	if (ret)
>>    		goto out_only_mutex;
>>    
>> -	ino_size = round_up(inode->i_size, fs_info->sectorsize);
>> +	ino_size = round_up(inode->i_size, fs_info->data_io_size);
>>    	ret = find_first_non_hole(BTRFS_I(inode), &offset, &len);
>>    	if (ret < 0)
>>    		goto out_only_mutex;
>> @@ -2681,15 +2681,15 @@ static int btrfs_punch_hole(struct file *file, loff_t offset, loff_t len)
>>    	if (ret)
>>    		goto out_only_mutex;
>>    
>> -	lockstart = round_up(offset, fs_info->sectorsize);
>> -	lockend = round_down(offset + len, fs_info->sectorsize) - 1;
>> +	lockstart = round_up(offset, fs_info->data_io_size);
>> +	lockend = round_down(offset + len, fs_info->data_io_size) - 1;
>>    	same_block = (BTRFS_BYTES_TO_BLKS(fs_info, offset))
>>    		== (BTRFS_BYTES_TO_BLKS(fs_info, offset + len - 1));
>>    	/*
>>    	 * Only do this if we are in the same block and we aren't doing the
>>    	 * entire block.
>>    	 */
>> -	if (same_block && len < fs_info->sectorsize) {
>> +	if (same_block && len < fs_info->data_io_size) {
>>    		if (offset < ino_size) {
>>    			truncated_block = true;
>>    			ret = btrfs_truncate_block(BTRFS_I(inode), offset + len - 1,
>> @@ -2858,8 +2858,8 @@ static int btrfs_fallocate_update_isize(struct inode *inode,
>>    	if (mode & FALLOC_FL_KEEP_SIZE || end <= i_size_read(inode))
>>    		return 0;
>>    
>> -	range_start = round_down(i_size_read(inode), root->fs_info->sectorsize);
>> -	range_end = round_up(end, root->fs_info->sectorsize);
>> +	range_start = round_down(i_size_read(inode), root->fs_info->data_io_size);
>> +	range_end = round_up(end, root->fs_info->data_io_size);
>>    
>>    	ret = btrfs_inode_set_file_extent_range(BTRFS_I(inode), range_start,
>>    						range_end - range_start);
>> @@ -2889,7 +2889,7 @@ static int btrfs_zero_range_check_range_boundary(struct btrfs_inode *inode,
>>    						 u64 offset)
>>    {
>>    	struct extent_map *em;
>> -	const u32 sectorsize = inode->root->fs_info->sectorsize;
>> +	const u32 sectorsize = inode->root->fs_info->data_io_size;
>>    	int ret;
>>    
>>    	offset = round_down(offset, sectorsize);
>> @@ -2916,7 +2916,7 @@ static int btrfs_zero_range(struct inode *inode,
>>    	struct btrfs_fs_info *fs_info = BTRFS_I(inode)->root->fs_info;
>>    	struct extent_map *em;
>>    	struct extent_changeset *data_reserved = NULL;
>> -	const u32 sectorsize = fs_info->sectorsize;
>> +	const u32 sectorsize = fs_info->data_io_size;
>>    	int ret;
>>    	u64 alloc_hint = 0;
>>    	const u64 orig_start = offset;
>> @@ -3065,7 +3065,7 @@ static int btrfs_zero_range(struct inode *inode,
>>    		}
>>    		ret = btrfs_prealloc_file_range(inode, mode, alloc_start,
>>    						alloc_end - alloc_start,
>> -						fs_info->sectorsize,
>> +						fs_info->data_io_size,
>>    						offset + len, &alloc_hint);
>>    		btrfs_unlock_extent(&BTRFS_I(inode)->io_tree, lockstart, lockend,
>>    				    &cached_state);
>> @@ -3105,7 +3105,7 @@ static long btrfs_fallocate(struct file *file, int mode,
>>    	u64 data_space_reserved = 0;
>>    	u64 qgroup_reserved = 0;
>>    	struct extent_map *em;
>> -	int blocksize = BTRFS_I(inode)->root->fs_info->sectorsize;
>> +	int blocksize = BTRFS_I(inode)->root->fs_info->data_io_size;
>>    	int ret;
>>    
>>    	if (btrfs_is_shutdown(inode_to_fs_info(inode)))
>> @@ -3414,7 +3414,7 @@ bool btrfs_find_delalloc_in_range(struct btrfs_inode *inode, u64 start, u64 end,
>>    				  struct extent_state **cached_state,
>>    				  u64 *delalloc_start_ret, u64 *delalloc_end_ret)
>>    {
>> -	u64 cur_offset = round_down(start, inode->root->fs_info->sectorsize);
>> +	u64 cur_offset = round_down(start, inode->root->fs_info->data_io_size);
>>    	u64 prev_delalloc_end = 0;
>>    	bool search_io_tree = true;
>>    	bool ret = false;
>> @@ -3602,10 +3602,10 @@ static loff_t find_desired_extent(struct file *file, loff_t offset, int whence)
>>    	 */
>>    	start = max_t(loff_t, 0, offset);
>>    
>> -	lockstart = round_down(start, fs_info->sectorsize);
>> -	lockend = round_up(i_size, fs_info->sectorsize);
>> +	lockstart = round_down(start, fs_info->data_io_size);
>> +	lockend = round_up(i_size, fs_info->data_io_size);
>>    	if (lockend <= lockstart)
>> -		lockend = lockstart + fs_info->sectorsize;
>> +		lockend = lockstart + fs_info->data_io_size;
>>    	lockend--;
>>    
>>    	path = btrfs_alloc_path();
>> diff --git a/fs/btrfs/fs.h b/fs/btrfs/fs.h
>> index ab5ed7b4f639..cee4c772cfd9 100644
>> --- a/fs/btrfs/fs.h
>> +++ b/fs/btrfs/fs.h
>> @@ -299,7 +299,7 @@ enum {
>>    #define BTRFS_FEATURE_COMPAT_SAFE_SET		0ULL
>>    #define BTRFS_FEATURE_COMPAT_SAFE_CLEAR		0ULL
>>    
>> -#define BTRFS_FEATURE_COMPAT_RO_SUPP			\
>> +#define BTRFS_FEATURE_COMPAT_RO_SUPP_STABLE		\
>>    	(BTRFS_FEATURE_COMPAT_RO_FREE_SPACE_TREE |	\
>>    	 BTRFS_FEATURE_COMPAT_RO_FREE_SPACE_TREE_VALID | \
>>    	 BTRFS_FEATURE_COMPAT_RO_VERITY |		\
>> @@ -335,11 +335,17 @@ enum {
>>    	 BTRFS_FEATURE_INCOMPAT_EXTENT_TREE_V2 | \
>>    	 BTRFS_FEATURE_INCOMPAT_REMAP_TREE)
>>    
>> +#define BTRFS_FEATURE_COMPAT_RO_SUPP		\
>> +	(BTRFS_FEATURE_COMPAT_RO_SUPP_STABLE |	\
>> +	 BTRFS_FEATURE_COMPAT_RO_DATA_IO_SIZE)
>>    #else
>>    
>>    #define BTRFS_FEATURE_INCOMPAT_SUPP		\
>>    	(BTRFS_FEATURE_INCOMPAT_SUPP_STABLE)
>>    
>> +#define BTRFS_FEATURE_COMPAT_RO_SUPP		\
>> +	(BTRFS_FEATURE_COMPAT_RO_SUPP_STABLE)
>> +
>>    #endif
>>    
>>    #define BTRFS_FEATURE_INCOMPAT_SAFE_SET			\
>> @@ -892,6 +898,7 @@ struct btrfs_fs_info {
>>    	u32 csum_size;
>>    	u32 csums_per_leaf;
>>    	u32 csum_type;
>> +	u32 data_io_size;
>>    
>>    	/*
>>    	 * Maximum size of an extent. BTRFS_MAX_EXTENT_SIZE on regular
>> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
>> index b696dd329fd7..de0364ce950b 100644
>> --- a/fs/btrfs/inode.c
>> +++ b/fs/btrfs/inode.c
>> @@ -190,7 +190,7 @@ static int data_reloc_print_warning_inode(u64 inum, u64 offset, u64 num_bytes,
>>    		btrfs_warn(fs_info,
>>    "checksum error at logical %llu mirror %u root %llu inode %llu offset %llu length %u links %u (path: %s)",
>>    			   warn->logical, warn->mirror_num, root, inum, offset,
>> -			   fs_info->sectorsize, nlink,
>> +			   fs_info->data_io_size, nlink,
>>    			   (char *)(unsigned long)ipath->fspath->val[i]);
>>    	}
>>    
>> @@ -1397,7 +1397,7 @@ static noinline int cow_file_range(struct btrfs_inode *inode,
>>    	if (btrfs_is_data_reloc_root(root))
>>    		min_alloc_size = num_bytes;
>>    	else
>> -		min_alloc_size = fs_info->sectorsize;
>> +		min_alloc_size = fs_info->data_io_size;
>>    
>>    	while (num_bytes > 0) {
>>    		ret = cow_one_range(inode, locked_folio, &ins, &cached, start,
>> @@ -2783,7 +2783,7 @@ int btrfs_set_extent_delalloc(struct btrfs_inode *inode, u64 start, u64 end,
>>    			      unsigned int extra_bits,
>>    			      struct extent_state **cached_state)
>>    {
>> -	const u32 blocksize = inode->root->fs_info->sectorsize;
>> +	const u32 blocksize = inode->root->fs_info->data_io_size;
>>    
>>    	/* Basic alignment check. */
>>    	ASSERT(IS_ALIGNED(start, blocksize), "start=%llu blocksize=%u",
>> @@ -2820,7 +2820,7 @@ int btrfs_set_extent_delalloc(struct btrfs_inode *inode, u64 start, u64 end,
>>    int btrfs_reset_extent_delalloc(struct btrfs_inode *inode, u64 start, u64 end,
>>    				unsigned int extra_bits, struct extent_state **cached_state)
>>    {
>> -	const u32 blocksize = inode->root->fs_info->sectorsize;
>> +	const u32 blocksize = inode->root->fs_info->data_io_size;
>>    
>>    	/* The @extra_bits can only be EXTENT_NORESERVE for now. */
>>    	ASSERT(!(extra_bits & ~EXTENT_NORESERVE), "extra_bits=0x%x", extra_bits);
>> @@ -2874,7 +2874,7 @@ static int insert_reserved_file_extent(struct btrfs_trans_handle *trans,
>>    	u64 num_bytes = btrfs_stack_file_extent_num_bytes(stack_fi);
>>    	u64 ram_bytes = btrfs_stack_file_extent_ram_bytes(stack_fi);
>>    	struct btrfs_drop_extents_args drop_args = { 0 };
>> -	const u32 sectorsize = root->fs_info->sectorsize;
>> +	const u32 sectorsize = root->fs_info->data_io_size;
>>    	int ret;
>>    
>>    	path = btrfs_alloc_path();
>> @@ -4040,7 +4040,7 @@ static int btrfs_read_locked_inode(struct btrfs_inode *inode, struct btrfs_path
>>    	if (ret)
>>    		goto out;
>>    	btrfs_inode_set_file_extent_range(inode, 0,
>> -			  round_up(i_size_read(vfs_inode), fs_info->sectorsize));
>> +			  round_up(i_size_read(vfs_inode), fs_info->data_io_size));
>>    
>>    	if (!maybe_acls)
>>    		cache_no_acl(vfs_inode);
>> @@ -4879,7 +4879,7 @@ int btrfs_truncate_block(struct btrfs_inode *inode, u64 offset, u64 start, u64 e
>>    	struct extent_state *cached_state = NULL;
>>    	struct extent_changeset *data_reserved = NULL;
>>    	bool only_release_metadata = false;
>> -	u32 blocksize = fs_info->sectorsize;
>> +	u32 blocksize = fs_info->data_io_size;
>>    	pgoff_t index = (offset >> PAGE_SHIFT);
>>    	struct folio *folio;
>>    	gfp_t mask = btrfs_alloc_write_mask(mapping);
>> @@ -5117,8 +5117,8 @@ int btrfs_cont_expand(struct btrfs_inode *inode, loff_t oldsize, loff_t size)
>>    	struct extent_io_tree *io_tree = &inode->io_tree;
>>    	struct extent_map *em = NULL;
>>    	struct extent_state *cached_state = NULL;
>> -	u64 hole_start = ALIGN(oldsize, fs_info->sectorsize);
>> -	u64 block_end = ALIGN(size, fs_info->sectorsize);
>> +	u64 hole_start = ALIGN(oldsize, fs_info->data_io_size);
>> +	u64 block_end = ALIGN(size, fs_info->data_io_size);
>>    	u64 last_byte;
>>    	u64 cur_offset;
>>    	u64 hole_size;
>> @@ -5147,7 +5147,7 @@ int btrfs_cont_expand(struct btrfs_inode *inode, loff_t oldsize, loff_t size)
>>    			break;
>>    		}
>>    		last_byte = min(btrfs_extent_map_end(em), block_end);
>> -		last_byte = ALIGN(last_byte, fs_info->sectorsize);
>> +		last_byte = ALIGN(last_byte, fs_info->data_io_size);
>>    		hole_size = last_byte - cur_offset;
>>    
>>    		if (!(em->flags & EXTENT_FLAG_PREALLOC)) {
>> @@ -5253,7 +5253,7 @@ static int btrfs_setsize(struct inode *inode, struct iattr *attr)
>>    
>>    		if (btrfs_is_zoned(fs_info)) {
>>    			ret = btrfs_wait_ordered_range(BTRFS_I(inode),
>> -					ALIGN(newsize, fs_info->sectorsize),
>> +					ALIGN(newsize, fs_info->data_io_size),
>>    					(u64)-1);
>>    			if (ret)
>>    				return ret;
>> @@ -7323,7 +7323,7 @@ noinline int can_nocow_extent(struct btrfs_inode *inode, u64 offset, u64 *len,
>>    		u64 range_end;
>>    
>>    		range_end = round_up(offset + nocow_args.file_extent.num_bytes,
>> -				     root->fs_info->sectorsize) - 1;
>> +				     root->fs_info->data_io_size) - 1;
>>    		ret = btrfs_test_range_bit_exists(io_tree, offset, range_end,
>>    						  EXTENT_DELALLOC);
>>    		if (ret)
>> @@ -7653,8 +7653,8 @@ static int btrfs_truncate(struct btrfs_inode *inode, bool skip_writeback)
>>    	int ret;
>>    	struct btrfs_trans_handle *trans;
>>    	const u64 min_size = btrfs_calc_metadata_size(fs_info, 1);
>> -	const u64 lock_start = round_down(inode->vfs_inode.i_size, fs_info->sectorsize);
>> -	const u64 i_size_up = round_up(inode->vfs_inode.i_size, fs_info->sectorsize);
>> +	const u64 lock_start = round_down(inode->vfs_inode.i_size, fs_info->data_io_size);
>> +	const u64 i_size_up = round_up(inode->vfs_inode.i_size, fs_info->data_io_size);
>>    
>>    	/* Our inode is locked and the i_size can't be changed concurrently. */
>>    	btrfs_assert_inode_locked(inode);
>> @@ -8038,7 +8038,7 @@ static int btrfs_getattr(struct mnt_idmap *idmap,
>>    	u64 delalloc_bytes;
>>    	u64 inode_bytes;
>>    	struct inode *inode = d_inode(path->dentry);
>> -	u32 blocksize = btrfs_sb(inode->i_sb)->sectorsize;
>> +	u32 blocksize = btrfs_sb(inode->i_sb)->data_io_size;
>>    	u32 bi_flags = BTRFS_I(inode)->flags;
>>    	u32 bi_ro_flags = BTRFS_I(inode)->ro_flags;
>>    
>> @@ -9124,8 +9124,8 @@ static int __btrfs_prealloc_file_range(struct inode *inode, int mode,
>>    			 * to truncate disk_i_size to the start of the gap,
>>    			 * making the persisted size smaller than i_size.
>>    			 */
>> -			range_start = round_down(inode->i_size, fs_info->sectorsize);
>> -			range_end = round_up(i_size, fs_info->sectorsize);
>> +			range_start = round_down(inode->i_size, fs_info->data_io_size);
>> +			range_end = round_up(i_size, fs_info->data_io_size);
>>    			ret = btrfs_inode_set_file_extent_range(BTRFS_I(inode),
>>    					range_start, range_end - range_start);
>>    			if (ret) {
>> @@ -9272,10 +9272,10 @@ int btrfs_encoded_io_compression_from_extent(struct btrfs_fs_info *fs_info,
>>    		 * The LZO format depends on the sector size. 64K is the maximum
>>    		 * sector size that we support.
>>    		 */
>> -		if (fs_info->sectorsize < SZ_4K || fs_info->sectorsize > SZ_64K)
>> +		if (fs_info->data_io_size < SZ_4K || fs_info->data_io_size > SZ_64K)
>>    			return -EINVAL;
>>    		return BTRFS_ENCODED_IO_COMPRESSION_LZO_4K +
>> -		       (fs_info->sectorsize_bits - 12);
>> +		       (ilog2(fs_info->data_io_size) - 12);
>>    	case BTRFS_COMPRESS_ZSTD:
>>    		return BTRFS_ENCODED_IO_COMPRESSION_ZSTD;
>>    	default:
>> @@ -9563,7 +9563,7 @@ ssize_t btrfs_encoded_read(struct kiocb *iocb, struct iov_iter *iter,
>>    		btrfs_inode_unlock(inode, BTRFS_ILOCK_SHARED);
>>    		return 0;
>>    	}
>> -	start = ALIGN_DOWN(iocb->ki_pos, fs_info->sectorsize);
>> +	start = ALIGN_DOWN(iocb->ki_pos, fs_info->data_io_size);
>>    	/*
>>    	 * We don't know how long the extent containing iocb->ki_pos is, but if
>>    	 * it's compressed we know that it won't be longer than this.
>> @@ -9676,7 +9676,7 @@ ssize_t btrfs_encoded_read(struct kiocb *iocb, struct iov_iter *iter,
>>    		count = start + *disk_io_size - iocb->ki_pos;
>>    		encoded->len = count;
>>    		encoded->unencoded_len = count;
>> -		*disk_io_size = ALIGN(*disk_io_size, fs_info->sectorsize);
>> +		*disk_io_size = ALIGN(*disk_io_size, fs_info->data_io_size);
>>    	}
>>    	btrfs_free_extent_map(em);
>>    	em = NULL;
>> @@ -9720,7 +9720,7 @@ ssize_t btrfs_do_encoded_write(struct kiocb *iocb, struct iov_iter *from,
>>    	int compression;
>>    	size_t orig_count;
>>    	const u32 min_folio_size = btrfs_min_folio_size(fs_info);
>> -	const u32 blocksize = fs_info->sectorsize;
>> +	const u32 blocksize = fs_info->data_io_size;
>>    	u64 start, end;
>>    	u64 num_bytes, ram_bytes, disk_num_bytes;
>>    	struct btrfs_key ins;
>> @@ -9743,7 +9743,7 @@ ssize_t btrfs_do_encoded_write(struct kiocb *iocb, struct iov_iter *from,
>>    		/* The sector size must match for LZO. */
>>    		if (encoded->compression -
>>    		    BTRFS_ENCODED_IO_COMPRESSION_LZO_4K + 12 !=
>> -		    fs_info->sectorsize_bits)
>> +		    ilog2(blocksize))
>>    			return -EINVAL;
>>    		compression = BTRFS_COMPRESS_LZO;
>>    		break;
>> @@ -9785,7 +9785,7 @@ ssize_t btrfs_do_encoded_write(struct kiocb *iocb, struct iov_iter *from,
>>    
>>    	/* The extent must start on a sector boundary. */
>>    	start = iocb->ki_pos;
>> -	if (!IS_ALIGNED(start, fs_info->sectorsize))
>> +	if (!IS_ALIGNED(start, fs_info->data_io_size))
>>    		return -EINVAL;
>>    
>>    	/*
>> @@ -9794,15 +9794,15 @@ ssize_t btrfs_do_encoded_write(struct kiocb *iocb, struct iov_iter *from,
>>    	 * up the extent size and set i_size to the unaligned end.
>>    	 */
>>    	if (start + encoded->len < inode->vfs_inode.i_size &&
>> -	    !IS_ALIGNED(start + encoded->len, fs_info->sectorsize))
>> +	    !IS_ALIGNED(start + encoded->len, fs_info->data_io_size))
>>    		return -EINVAL;
>>    
>>    	/* Finally, the offset in the unencoded data must be sector-aligned. */
>> -	if (!IS_ALIGNED(encoded->unencoded_offset, fs_info->sectorsize))
>> +	if (!IS_ALIGNED(encoded->unencoded_offset, fs_info->data_io_size))
>>    		return -EINVAL;
>>    
>> -	num_bytes = ALIGN(encoded->len, fs_info->sectorsize);
>> -	ram_bytes = ALIGN(encoded->unencoded_len, fs_info->sectorsize);
>> +	num_bytes = ALIGN(encoded->len, fs_info->data_io_size);
>> +	ram_bytes = ALIGN(encoded->unencoded_len, fs_info->data_io_size);
>>    	end = start + num_bytes - 1;
>>    
>>    	/*
>> @@ -9810,7 +9810,7 @@ ssize_t btrfs_do_encoded_write(struct kiocb *iocb, struct iov_iter *from,
>>    	 * sector-aligned. For convenience, we extend it with zeroes if it
>>    	 * isn't.
>>    	 */
>> -	disk_num_bytes = ALIGN(orig_count, fs_info->sectorsize);
>> +	disk_num_bytes = ALIGN(orig_count, fs_info->data_io_size);
>>    
>>    	cb = btrfs_alloc_compressed_write(inode, start, num_bytes);
>>    	for (int i = 0; i * min_folio_size < disk_num_bytes; i++) {
>> @@ -10222,7 +10222,7 @@ static int btrfs_swap_activate(struct swap_info_struct *sis, struct file *file,
>>    	atomic_inc(&root->nr_swapfiles);
>>    	spin_unlock(&root->root_item_lock);
>>    
>> -	isize = ALIGN_DOWN(inode->i_size, fs_info->sectorsize);
>> +	isize = ALIGN_DOWN(inode->i_size, fs_info->data_io_size);
>>    
>>    	btrfs_lock_extent(io_tree, 0, isize - 1, &cached_state);
>>    	while (prev_extent_end < isize) {
>> diff --git a/fs/btrfs/lzo.c b/fs/btrfs/lzo.c
>> index 1531adb117d1..0235530fd0f8 100644
>> --- a/fs/btrfs/lzo.c
>> +++ b/fs/btrfs/lzo.c
>> @@ -414,7 +414,7 @@ int lzo_decompress_bio(struct list_head *ws, struct compressed_bio *cb)
>>    {
>>    	struct workspace *workspace = list_entry(ws, struct workspace, list);
>>    	struct btrfs_fs_info *fs_info = cb->bbio.inode->root->fs_info;
>> -	const u32 sectorsize = fs_info->sectorsize;
>> +	const u32 sectorsize = fs_info->data_io_size;
>>    	const u32 compressed_len = bio_get_size(&cb->bbio.bio);
>>    	struct folio_iter fi;
>>    	char *kaddr;
>> diff --git a/fs/btrfs/sysfs.c b/fs/btrfs/sysfs.c
>> index 0d14570c8bc2..8ca7b7e304e3 100644
>> --- a/fs/btrfs/sysfs.c
>> +++ b/fs/btrfs/sysfs.c
>> @@ -301,6 +301,7 @@ BTRFS_FEAT_ATTR_INCOMPAT(extent_tree_v2, EXTENT_TREE_V2);
>>    BTRFS_FEAT_ATTR_INCOMPAT(raid_stripe_tree, RAID_STRIPE_TREE);
>>    /* Remove once support for remap tree is feature complete. */
>>    BTRFS_FEAT_ATTR_INCOMPAT(remap_tree, REMAP_TREE);
>> +BTRFS_FEAT_ATTR_COMPAT_RO(data_io_size, DATA_IO_SIZE);
>>    #endif
>>    #ifdef CONFIG_FS_VERITY
>>    BTRFS_FEAT_ATTR_COMPAT_RO(verity, VERITY);
>> @@ -334,6 +335,7 @@ static struct attribute *btrfs_supported_feature_attrs[] = {
>>    	BTRFS_FEAT_ATTR_PTR(extent_tree_v2),
>>    	BTRFS_FEAT_ATTR_PTR(raid_stripe_tree),
>>    	BTRFS_FEAT_ATTR_PTR(remap_tree),
>> +	BTRFS_FEAT_ATTR_PTR(data_io_size),
>>    #endif
>>    #ifdef CONFIG_FS_VERITY
>>    	BTRFS_FEAT_ATTR_PTR(verity),
>> diff --git a/fs/btrfs/tests/btrfs-tests.c b/fs/btrfs/tests/btrfs-tests.c
>> index 6287d940323d..e3e7bbee7cd7 100644
>> --- a/fs/btrfs/tests/btrfs-tests.c
>> +++ b/fs/btrfs/tests/btrfs-tests.c
>> @@ -140,6 +140,7 @@ struct btrfs_fs_info *btrfs_alloc_dummy_fs_info(u32 nodesize, u32 sectorsize)
>>    	fs_info->nodesize = nodesize;
>>    	fs_info->sectorsize = sectorsize;
>>    	fs_info->sectorsize_bits = ilog2(sectorsize);
>> +	fs_info->data_io_size = sectorsize;
>>    
>>    	/* CRC32C csum size. */
>>    	fs_info->csum_size = 4;
>> diff --git a/include/uapi/linux/btrfs.h b/include/uapi/linux/btrfs.h
>> index 0a13baf3d8d1..858a37811586 100644
>> --- a/include/uapi/linux/btrfs.h
>> +++ b/include/uapi/linux/btrfs.h
>> @@ -314,6 +314,13 @@ struct btrfs_ioctl_fs_info_args {
>>     */
>>    #define BTRFS_FEATURE_COMPAT_RO_BLOCK_GROUP_TREE	(1ULL << 3)
>>    
>> +/*
>> + * Force all IOs (including buffered, direct, compressed) to be aligned
>> + * to btrfs_super_block::data_io_size other than sectorsize.
>> + * Meanwhile still data checksum to be calculated based on sectorsize.
>> + */
>> +#define BTRFS_FEATURE_COMPAT_RO_DATA_IO_SIZE		(1ULL << 4)
>> +
>>    #define BTRFS_FEATURE_INCOMPAT_MIXED_BACKREF	(1ULL << 0)
>>    #define BTRFS_FEATURE_INCOMPAT_DEFAULT_SUBVOL	(1ULL << 1)
>>    #define BTRFS_FEATURE_INCOMPAT_MIXED_GROUPS	(1ULL << 2)
>> diff --git a/include/uapi/linux/btrfs_tree.h b/include/uapi/linux/btrfs_tree.h
>> index cc3b9f7dccaf..3b979ba5a3fc 100644
>> --- a/include/uapi/linux/btrfs_tree.h
>> +++ b/include/uapi/linux/btrfs_tree.h
>> @@ -724,9 +724,10 @@ struct btrfs_super_block {
>>    	__le64 remap_root;
>>    	__le64 remap_root_generation;
>>    	__u8 remap_root_level;
>> +	__u32 data_io_size;
>>    
>>    	/* Future expansion */
>> -	__u8 reserved[199];
>> +	__u8 reserved[195];
>>    	__u8 sys_chunk_array[BTRFS_SYSTEM_CHUNK_ARRAY_SIZE];
>>    	struct btrfs_root_backup super_roots[BTRFS_NUM_BACKUP_ROOTS];

