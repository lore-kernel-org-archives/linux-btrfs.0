Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CF2C407CCC
	for <linux-btrfs@vger.kernel.org>; Tue, 21 Jul 2026 23:34:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784676876; cv=none; b=bRwMloEVKYZWnZZDFNrs9ivxSngOFmy0+gq1q3J95FX32pMTU34W2zodzEmxR1R6OzXKiNaN7UUnG6znQviFVx19/OkSmJMZeSCm6E8bAC4RviHwa4SkyGgEr8BYnKNZHdhzYyEKZI5RwXz85yIGjdf0f9RdL8oOwCMBa/qe39Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784676876; c=relaxed/simple;
	bh=0ZRelDb0JvJEjITxRcK9mM7+WlUtB+vNaD7oyf3Imoo=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:References:
	 In-Reply-To:Content-Type; b=Bya05w6hHfvfvOUjr1QQV+vPF/ACqEntAx4kx0E7/GU0WLAferznhRxDaxE+bECnzgSAsSp2YM2uQS2oWkRHqgGmyZo1Pb8SEsuuAgxSveUFp+e3SPgQ37LFcC6zYgttquJeVVemwXnzgJxqNWgSvLVcCGtuFpALWi7duuf6mEY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=EoT9CPNC; arc=none smtp.client-ip=209.85.218.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="EoT9CPNC"
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-c15f360851aso1305279766b.2
        for <linux-btrfs@vger.kernel.org>; Tue, 21 Jul 2026 16:34:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1784676872; x=1785281672; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt
         :content-language:references:to:from:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=0HXicqltNfrIRqBShZxM+DStMm4siC/0hZd+sUPQqQs=;
        b=EoT9CPNCJdRiAMLR62fHh51Z+UZ/MXJ6m0hDl/3UyjU0MQpqAjN5gxfxtSFRWUhvhK
         TfecFPwuHNf4rmSHiyCjNF/HvETppjamedI/6M2siOEyv9v95APG592jGSh8IYBB33AZ
         PJFZ581py1RWEu6cqKd+jnDJ8a2AKwG4OunKNlFhSAeHPPC/4ldLYHdqCm4taj9ysXkA
         Y5XdHddsD6i1wXU7wyJxCaTkBz4yUnAIIhe8L6OKEAUlEgX9dG3JMKgHoIUQd+pgjyxj
         kP3u6+qBszO2WDihuaRnpnvGahplFj/yA+0eSsQyAZwm/4QrZBRTDc5R8BBWXC0hWnzB
         /uBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784676872; x=1785281672;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt
         :content-language:references:to:from:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=0HXicqltNfrIRqBShZxM+DStMm4siC/0hZd+sUPQqQs=;
        b=T7HeaH485HXsOw3qtuW6LnfunOxuMS2V6Nr59ehcVFtdA614lt7aTZfwh0MEGwETAh
         6v2jXx3U5Btn4recm+Yu1RbTB8JFgFalg56VKX/YsORUR2JAUCyBv7Aq7PUKkhUAbkhi
         kQ71bEsmzinw/sk712Z4ar52s1mI5OEOpZfNssPZ/WuXA/EQ7wT/99bG8BHik9YbJGGZ
         1VNr989+QYa61znFKwdOmKoxyrEePgyyC51ITCvoQyluTuSxEvC2Wdd2BxnOptqZZY9w
         96ssjqdpwToWBAUYZ6QyMZluWrJtiQG954v+w6VlmwHySOx3+OW2veuootUaQGhKb6OJ
         2Lpw==
X-Gm-Message-State: AOJu0Yx2v0ZyPwQJLZDfDqo8Q3/P2wR1Q+FUxNbJuJ0RyUHpG1wqQyXs
	6a9U1Pc8EVZ1TOHBYLYU7Nzy0hOYSXeKiXzfp7mA3G6nEqj+QBpA/PhDb0oNo27UOrJiAQ/E25r
	7ncQ6AL8=
X-Gm-Gg: AR+sD10cIdQp8cnpI6uKwKS+lUJBvNj1X10wgOkseyzDMCThDrJqPZ+5Zz4aN9KY3u6
	ALnZVnAWP/wrxrPB9xF4lpZVDdBrHHgdn6zHXctV1EHv/Wr1iV4dkYqMuscQJf6YATFtBqvR1B1
	fERUJRKcvgnZkXvgTnWUWBaGb6iR8yjbEByBAWbZ1qkbjy3u3LSYbacWw5n+cfrXO74zeeeYj2+
	0WCy3SzzExsL7iEhOYOafDnsmKNzCL79daH96Yknau6YRa783wcsvTtLKaf7j+mEss0hZoN5upA
	VXZwkZMWvZnB36J2+KOqfdlY5P023vyktuZYRbBevDgFjfnIUlpJptjJn6vA9FyELFi41QSFxAS
	Qu+w4OyJiyn/SG0UFU+bdDR71iY8iJnj2ckLfUMKWi6IhBj2eh0ofCB1c5yRNOblFGEaJNApZx5
	Krrx8haw==
X-Received: by 2002:a17:907:741:b0:bed:6e53:bb1a with SMTP id a640c23a62f3a-c16b47e9637mr842335266b.48.1784676871309;
        Tue, 21 Jul 2026 16:34:31 -0700 (PDT)
Received: from [172.16.0.229] ([159.196.52.54])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cbb8f1af5a0sm245095a12.28.2026.07.21.16.34.29
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Jul 2026 16:34:30 -0700 (PDT)
Message-ID: <3639648b-9f20-403c-8de6-873acea350f0@suse.com>
Date: Wed, 22 Jul 2026 09:04:26 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC] btrfs: implement a new compat RO feature,
 data_io_size
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
References: <f67b00bbe7b5fb4c59a45a6390c98add303a83c1.1782627906.git.wqu@suse.com>
Content-Language: en-US
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
In-Reply-To: <f67b00bbe7b5fb4c59a45a6390c98add303a83c1.1782627906.git.wqu@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

The idea of letting both sectorsize and data_io_size co-exist seems very 
cursed.

Firstly I tried to use LSP server to rename "sectorsize" and 
"sectorsize_bits", with minor manual fixes to macros, it results the 
following changes:

  42 files changed, 465 insertions(+), 464 deletions(-)

That should cover all sectorsize/sectorsize_bits usages.

Then I tried to re-introduce sectorsize for call sites that are not data 
IOs.

It will result at least the following changes:

  8 files changed, 147 insertions(+), 117 deletions(-)

Which is much smaller, but still pretty huge, and there are still a lot 
of missing call sites, as the resulted code can still lead to bad 
behaviors, like missing csum under reflink and can still trigger other 
ASSERT()s.


I do not think handling all 400+ callsites is really a good idea, 
although the data_io_size seems to be more compatible, it's too invasive 
for the code base.

I'll try the other path by introducing sub-block stripe size only for 
RAID56.

Thanks,
Qu

在 2026/6/28 15:57, Qu Wenruo 写道:
> To address the btrfs RAID56 write-hole problem, there is one idea to
> solve it:
> 
>   Make sure all data writes are full stripe aligned
> 
> However based on that idea, we can have two different directions to
> implement:
> 
> - Keep the sector size untouched, introduce a newer io size for data
>    E.g. sector size is still 4K, but data io size is 16K, and RAID56
>    full stripe size is also set to 16K.
> 
>    This allows us to reuse the existing sector size based
>    read-repair/scrub.
> 
>    And this patch is the PoC of this idea.
> 
>    The problems are also obvious, we need to not only introduce a
>    dedicated compat RO flag, but also convert almost all sectorsize users
>    to use the new data_io_size, except data checksum and read-repair
>    related code.
> 
> - Use larger block size, introduce a newer sub-block RAID56 repair
>    E.g. sector size is 16K, and RAID56 full stripe size is also set to
>    16K.
> 
>    This allows us to reuse the existing experimental bs > ps support.
> 
>    The problems are that we need a completely new RAID56 sub-block
>    rebuild handling.
>    And the new rebuild can be very slow. Since we do not know exact which
>    sub-block is corrupted, we have to exhaust all combinations just for a
>    single block.
> 
>    And the current btrfs_map_block() also need to support sub-block
>    splitting, which is completely new, and will also affect checksum
>    handling.
> 
> So far it looks like the new data io size is the easier solution, thus
> here is the RFC patch.
> 
> But in reality, this RFC patch is already super huge, almost touching
> all call sites using fs_info->sectorsize, and there are still a lot of
> left-over and causing all kinds of warnings.
> 
> For now I'm wondering if it would be better just to replace sectorsize
> with data_io_size, and introduce a dedicated member for checksum/scrub.
> 
> Signed-off-by: Qu Wenruo <wqu@suse.com>
> ---
> Reason for RFC:
> This patch is still very unstable, there are still a lot of sites not
> properly converted to use the new fs_info->data_io_size.
> 
> This is only for proof-of-concept purpose.
> ---
>   fs/btrfs/accessors.h            |  2 +
>   fs/btrfs/direct-io.c            |  6 +--
>   fs/btrfs/disk-io.c              | 23 ++++++++++-
>   fs/btrfs/file.c                 | 68 ++++++++++++++++-----------------
>   fs/btrfs/fs.h                   |  9 ++++-
>   fs/btrfs/inode.c                | 60 ++++++++++++++---------------
>   fs/btrfs/lzo.c                  |  2 +-
>   fs/btrfs/sysfs.c                |  2 +
>   fs/btrfs/tests/btrfs-tests.c    |  1 +
>   include/uapi/linux/btrfs.h      |  7 ++++
>   include/uapi/linux/btrfs_tree.h |  3 +-
>   11 files changed, 112 insertions(+), 71 deletions(-)
> 
> diff --git a/fs/btrfs/accessors.h b/fs/btrfs/accessors.h
> index 8938357fcb40..7a5206db2224 100644
> --- a/fs/btrfs/accessors.h
> +++ b/fs/btrfs/accessors.h
> @@ -889,6 +889,8 @@ BTRFS_SETGET_STACK_FUNCS(super_remap_root_generation, struct btrfs_super_block,
>   			 remap_root_generation, 64);
>   BTRFS_SETGET_STACK_FUNCS(super_remap_root_level, struct btrfs_super_block,
>   			 remap_root_level, 8);
> +BTRFS_SETGET_STACK_FUNCS(super_data_io_size, struct btrfs_super_block,
> +			 data_io_size, 32);
>   
>   /* struct btrfs_file_extent_item */
>   BTRFS_SETGET_STACK_FUNCS(stack_file_extent_type, struct btrfs_file_extent_item,
> diff --git a/fs/btrfs/direct-io.c b/fs/btrfs/direct-io.c
> index 3e227292b0ac..df1b2f2725ca 100644
> --- a/fs/btrfs/direct-io.c
> +++ b/fs/btrfs/direct-io.c
> @@ -186,7 +186,7 @@ static struct extent_map *btrfs_new_extent_direct(struct btrfs_inode *inode,
>   
>   	alloc_hint = btrfs_get_extent_allocation_hint(inode, start, len);
>   again:
> -	ret = btrfs_reserve_extent(root, len, len, fs_info->sectorsize,
> +	ret = btrfs_reserve_extent(root, len, len, fs_info->data_io_size,
>   				   0, alloc_hint, &ins, true, true);
>   	if (ret == -EAGAIN) {
>   		ASSERT(btrfs_is_zoned(fs_info));
> @@ -395,7 +395,7 @@ static int btrfs_dio_iomap_begin(struct inode *inode, loff_t start,
>   	 * to allocate a contiguous array for the checksums.
>   	 */
>   	if (!write)
> -		len = min_t(u64, len, fs_info->sectorsize * BIO_MAX_VECS);
> +		len = min_t(u64, len, fs_info->data_io_size * BIO_MAX_VECS);
>   
>   	lockstart = start;
>   	lockend = start + len - 1;
> @@ -829,7 +829,7 @@ static struct iomap_dio *btrfs_dio_write(struct kiocb *iocb, struct iov_iter *it
>   static ssize_t check_direct_IO(struct btrfs_fs_info *fs_info,
>   			       const struct iov_iter *iter, loff_t offset)
>   {
> -	const u32 blocksize_mask = fs_info->sectorsize - 1;
> +	const u32 blocksize_mask = fs_info->data_io_size - 1;
>   
>   	if (offset & blocksize_mask)
>   		return -EINVAL;
> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> index e4ffcd49d7af..29797b767df7 100644
> --- a/fs/btrfs/disk-io.c
> +++ b/fs/btrfs/disk-io.c
> @@ -2508,6 +2508,23 @@ int btrfs_validate_super(const struct btrfs_fs_info *fs_info,
>   		ret = -EINVAL;
>   	}
>   
> +	if (btrfs_fs_compat_ro(fs_info, DATA_IO_SIZE)) {
> +		const u32 data_io_size = btrfs_super_data_io_size(sb);
> +
> +		/*
> +		 * If data io size is set, make sure it is not smaller than
> +		 * sectorsize.
> +		 * And for now we only support data io size up to MAX_BLOCKSIZE.
> +		 */
> +		if (unlikely(!is_power_of_2(data_io_size) ||
> +			     data_io_size < sectorsize ||
> +			     data_io_size > BTRFS_MAX_BLOCKSIZE)) {
> +			btrfs_err(fs_info,
> +	"invalid data io size, has %u expect power of 2 number in range [%u, %u]",
> +				  data_io_size, sectorsize, BTRFS_MAX_BLOCKSIZE);
> +			ret = -EINVAL;
> +		}
> +	}
>   	if (btrfs_fs_incompat(fs_info, REMAP_TREE)) {
>   		/*
>   		 * Reduce test matrix for remap tree by requiring block-group-tree
> @@ -3472,8 +3489,12 @@ int __cold open_ctree(struct super_block *sb, struct btrfs_fs_devices *fs_device
>   	fs_info->nodesize = nodesize;
>   	fs_info->nodesize_bits = ilog2(nodesize);
>   	fs_info->sectorsize = sectorsize;
> +	if (btrfs_fs_compat_ro(fs_info, DATA_IO_SIZE))
> +		fs_info->data_io_size = btrfs_super_data_io_size(disk_super);
> +	else
> +		fs_info->data_io_size = sectorsize;
>   	fs_info->sectorsize_bits = ilog2(sectorsize);
> -	fs_info->block_min_order = ilog2(round_up(sectorsize, PAGE_SIZE) >> PAGE_SHIFT);
> +	fs_info->block_min_order = ilog2(round_up(fs_info->data_io_size, PAGE_SIZE) >> PAGE_SHIFT);
>   	fs_info->block_max_order = calc_block_max_order(fs_info->sectorsize_bits);
>   	fs_info->csums_per_leaf = BTRFS_MAX_ITEM_SIZE(fs_info) / fs_info->csum_size;
>   	fs_info->fs_devices->fs_info = fs_info;
> diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
> index df8f6f565070..8397d96a5992 100644
> --- a/fs/btrfs/file.c
> +++ b/fs/btrfs/file.c
> @@ -45,8 +45,8 @@
>   static void btrfs_drop_folio(struct btrfs_fs_info *fs_info, struct folio *folio,
>   			     u64 pos, u64 copied)
>   {
> -	u64 block_start = round_down(pos, fs_info->sectorsize);
> -	u64 block_len = round_up(pos + copied, fs_info->sectorsize) - block_start;
> +	u64 block_start = round_down(pos, fs_info->data_io_size);
> +	u64 block_len = round_up(pos + copied, fs_info->data_io_size) - block_start;
>   
>   	ASSERT(block_len <= U32_MAX);
>   	folio_unlock(folio);
> @@ -78,8 +78,8 @@ int btrfs_dirty_folio(struct btrfs_inode *inode, struct folio *folio, loff_t pos
>   	if (noreserve)
>   		extra_bits |= EXTENT_NORESERVE;
>   
> -	start_pos = round_down(pos, fs_info->sectorsize);
> -	num_bytes = round_up(end_pos - start_pos, fs_info->sectorsize);
> +	start_pos = round_down(pos, fs_info->data_io_size);
> +	num_bytes = round_up(end_pos - start_pos, fs_info->data_io_size);
>   	ASSERT(num_bytes <= U32_MAX);
>   	ASSERT(folio_pos(folio) <= pos && folio_next_pos(folio) >= end_pos);
>   
> @@ -395,7 +395,7 @@ int btrfs_drop_extents(struct btrfs_trans_handle *trans,
>   			    extent_type == BTRFS_FILE_EXTENT_INLINE) {
>   				args->bytes_found += extent_end - key.offset;
>   				extent_end = ALIGN(extent_end,
> -						   fs_info->sectorsize);
> +						   fs_info->data_io_size);
>   			} else if (update_refs && disk_bytenr > 0) {
>   				struct btrfs_ref ref = {
>   					.action = BTRFS_DROP_DELAYED_REF,
> @@ -788,7 +788,7 @@ static int prepare_uptodate_folio(struct inode *inode, struct folio *folio, u64
>   {
>   	u64 clamp_start = max_t(u64, pos, folio_pos(folio));
>   	u64 clamp_end = min_t(u64, pos + len, folio_next_pos(folio));
> -	const u32 blocksize = inode_to_fs_info(inode)->sectorsize;
> +	const u32 blocksize = inode_to_fs_info(inode)->data_io_size;
>   	int ret = 0;
>   
>   	if (folio_test_uptodate(folio))
> @@ -893,8 +893,8 @@ lock_and_cleanup_extent_if_need(struct btrfs_inode *inode, struct folio *folio,
>   	u64 last_pos;
>   	int ret = 0;
>   
> -	start_pos = round_down(pos, fs_info->sectorsize);
> -	last_pos = round_up(pos + write_bytes, fs_info->sectorsize) - 1;
> +	start_pos = round_down(pos, fs_info->data_io_size);
> +	last_pos = round_up(pos + write_bytes, fs_info->data_io_size) - 1;
>   
>   	if (start_pos < inode->vfs_inode.i_size) {
>   		struct btrfs_ordered_extent *ordered;
> @@ -978,9 +978,9 @@ int btrfs_check_nocow_lock(struct btrfs_inode *inode, loff_t pos,
>   	if (!btrfs_drew_try_write_lock(&root->snapshot_lock))
>   		return -EAGAIN;
>   
> -	lockstart = round_down(pos, fs_info->sectorsize);
> +	lockstart = round_down(pos, fs_info->data_io_size);
>   	lockend = round_up(pos + *write_bytes,
> -			   fs_info->sectorsize) - 1;
> +			   fs_info->data_io_size) - 1;
>   
>   	if (nowait) {
>   		if (!btrfs_try_lock_ordered_range(inode, lockstart, lockend,
> @@ -1067,7 +1067,7 @@ int btrfs_write_check(struct kiocb *iocb, size_t count)
>   	oldsize = i_size_read(inode);
>   	if (pos > oldsize) {
>   		/* Expand hole size to cover write data, preventing empty gap */
> -		loff_t end_pos = round_up(pos + count, fs_info->sectorsize);
> +		loff_t end_pos = round_up(pos + count, fs_info->data_io_size);
>   
>   		ret = btrfs_cont_expand(BTRFS_I(inode), oldsize, end_pos);
>   		if (ret)
> @@ -1090,7 +1090,7 @@ static void release_space(struct btrfs_inode *inode, struct extent_changeset *da
>   		const struct btrfs_fs_info *fs_info = inode->root->fs_info;
>   
>   		btrfs_delalloc_release_space(inode, data_reserved,
> -					     round_down(start, fs_info->sectorsize),
> +					     round_down(start, fs_info->data_io_size),
>   					     len, true);
>   	}
>   }
> @@ -1107,7 +1107,7 @@ static ssize_t reserve_space(struct btrfs_inode *inode,
>   			     bool *only_release_metadata)
>   {
>   	const struct btrfs_fs_info *fs_info = inode->root->fs_info;
> -	const unsigned int block_offset = (start & (fs_info->sectorsize - 1));
> +	const unsigned int block_offset = (start & (fs_info->data_io_size - 1));
>   	size_t reserve_bytes;
>   	int ret;
>   
> @@ -1132,7 +1132,7 @@ static ssize_t reserve_space(struct btrfs_inode *inode,
>   		*only_release_metadata = true;
>   	}
>   
> -	reserve_bytes = round_up(*len + block_offset, fs_info->sectorsize);
> +	reserve_bytes = round_up(*len + block_offset, fs_info->data_io_size);
>   	WARN_ON(reserve_bytes == 0);
>   	ret = btrfs_delalloc_reserve_metadata(inode, reserve_bytes,
>   					      reserve_bytes, nowait);
> @@ -1192,7 +1192,7 @@ static int copy_one_range(struct btrfs_inode *inode, struct iov_iter *iter,
>   	struct extent_state *cached_state = NULL;
>   	size_t write_bytes = calc_write_bytes(inode, iter, start);
>   	size_t copied;
> -	const u64 reserved_start = round_down(start, fs_info->sectorsize);
> +	const u64 reserved_start = round_down(start, fs_info->data_io_size);
>   	u64 reserved_len;
>   	struct folio *folio = NULL;
>   	int extents_locked;
> @@ -1301,7 +1301,7 @@ static int copy_one_range(struct btrfs_inode *inode, struct iov_iter *iter,
>   		}
>   
>   		/* Release the reserved space beyond the last block. */
> -		last_block = round_up(start + copied, fs_info->sectorsize);
> +		last_block = round_up(start + copied, fs_info->data_io_size);
>   
>   		shrink_reserved_space(inode, *data_reserved, reserved_start,
>   				      reserved_len, last_block - reserved_start,
> @@ -1938,7 +1938,7 @@ static vm_fault_t btrfs_page_mkwrite(struct vm_fault *vmf)
>   	}
>   
>   	if (folio_contains(folio, (size - 1) >> PAGE_SHIFT)) {
> -		reserved_space = round_up(size - page_start, fs_info->sectorsize);
> +		reserved_space = round_up(size - page_start, fs_info->data_io_size);
>   		if (reserved_space < fsize) {
>   			const u64 to_free = fsize - reserved_space;
>   
> @@ -2182,8 +2182,8 @@ static int find_first_non_hole(struct btrfs_inode *inode, u64 *start, u64 *len)
>   	int ret = 0;
>   
>   	em = btrfs_get_extent(inode, NULL,
> -			      round_down(*start, fs_info->sectorsize),
> -			      round_up(*len, fs_info->sectorsize));
> +			      round_down(*start, fs_info->data_io_size),
> +			      round_up(*len, fs_info->data_io_size));
>   	if (IS_ERR(em))
>   		return PTR_ERR(em);
>   
> @@ -2396,7 +2396,7 @@ int btrfs_replace_file_extents(struct btrfs_inode *inode,
>   	struct btrfs_root *root = inode->root;
>   	struct btrfs_fs_info *fs_info = root->fs_info;
>   	const u64 min_size = btrfs_calc_insert_metadata_size(fs_info, 1);
> -	u64 ino_size = round_up(inode->vfs_inode.i_size, fs_info->sectorsize);
> +	u64 ino_size = round_up(inode->vfs_inode.i_size, fs_info->data_io_size);
>   	struct btrfs_trans_handle *trans = NULL;
>   	struct btrfs_block_rsv rsv;
>   	unsigned int rsv_count;
> @@ -2667,7 +2667,7 @@ static int btrfs_punch_hole(struct file *file, loff_t offset, loff_t len)
>   	if (ret)
>   		goto out_only_mutex;
>   
> -	ino_size = round_up(inode->i_size, fs_info->sectorsize);
> +	ino_size = round_up(inode->i_size, fs_info->data_io_size);
>   	ret = find_first_non_hole(BTRFS_I(inode), &offset, &len);
>   	if (ret < 0)
>   		goto out_only_mutex;
> @@ -2681,15 +2681,15 @@ static int btrfs_punch_hole(struct file *file, loff_t offset, loff_t len)
>   	if (ret)
>   		goto out_only_mutex;
>   
> -	lockstart = round_up(offset, fs_info->sectorsize);
> -	lockend = round_down(offset + len, fs_info->sectorsize) - 1;
> +	lockstart = round_up(offset, fs_info->data_io_size);
> +	lockend = round_down(offset + len, fs_info->data_io_size) - 1;
>   	same_block = (BTRFS_BYTES_TO_BLKS(fs_info, offset))
>   		== (BTRFS_BYTES_TO_BLKS(fs_info, offset + len - 1));
>   	/*
>   	 * Only do this if we are in the same block and we aren't doing the
>   	 * entire block.
>   	 */
> -	if (same_block && len < fs_info->sectorsize) {
> +	if (same_block && len < fs_info->data_io_size) {
>   		if (offset < ino_size) {
>   			truncated_block = true;
>   			ret = btrfs_truncate_block(BTRFS_I(inode), offset + len - 1,
> @@ -2858,8 +2858,8 @@ static int btrfs_fallocate_update_isize(struct inode *inode,
>   	if (mode & FALLOC_FL_KEEP_SIZE || end <= i_size_read(inode))
>   		return 0;
>   
> -	range_start = round_down(i_size_read(inode), root->fs_info->sectorsize);
> -	range_end = round_up(end, root->fs_info->sectorsize);
> +	range_start = round_down(i_size_read(inode), root->fs_info->data_io_size);
> +	range_end = round_up(end, root->fs_info->data_io_size);
>   
>   	ret = btrfs_inode_set_file_extent_range(BTRFS_I(inode), range_start,
>   						range_end - range_start);
> @@ -2889,7 +2889,7 @@ static int btrfs_zero_range_check_range_boundary(struct btrfs_inode *inode,
>   						 u64 offset)
>   {
>   	struct extent_map *em;
> -	const u32 sectorsize = inode->root->fs_info->sectorsize;
> +	const u32 sectorsize = inode->root->fs_info->data_io_size;
>   	int ret;
>   
>   	offset = round_down(offset, sectorsize);
> @@ -2916,7 +2916,7 @@ static int btrfs_zero_range(struct inode *inode,
>   	struct btrfs_fs_info *fs_info = BTRFS_I(inode)->root->fs_info;
>   	struct extent_map *em;
>   	struct extent_changeset *data_reserved = NULL;
> -	const u32 sectorsize = fs_info->sectorsize;
> +	const u32 sectorsize = fs_info->data_io_size;
>   	int ret;
>   	u64 alloc_hint = 0;
>   	const u64 orig_start = offset;
> @@ -3065,7 +3065,7 @@ static int btrfs_zero_range(struct inode *inode,
>   		}
>   		ret = btrfs_prealloc_file_range(inode, mode, alloc_start,
>   						alloc_end - alloc_start,
> -						fs_info->sectorsize,
> +						fs_info->data_io_size,
>   						offset + len, &alloc_hint);
>   		btrfs_unlock_extent(&BTRFS_I(inode)->io_tree, lockstart, lockend,
>   				    &cached_state);
> @@ -3105,7 +3105,7 @@ static long btrfs_fallocate(struct file *file, int mode,
>   	u64 data_space_reserved = 0;
>   	u64 qgroup_reserved = 0;
>   	struct extent_map *em;
> -	int blocksize = BTRFS_I(inode)->root->fs_info->sectorsize;
> +	int blocksize = BTRFS_I(inode)->root->fs_info->data_io_size;
>   	int ret;
>   
>   	if (btrfs_is_shutdown(inode_to_fs_info(inode)))
> @@ -3414,7 +3414,7 @@ bool btrfs_find_delalloc_in_range(struct btrfs_inode *inode, u64 start, u64 end,
>   				  struct extent_state **cached_state,
>   				  u64 *delalloc_start_ret, u64 *delalloc_end_ret)
>   {
> -	u64 cur_offset = round_down(start, inode->root->fs_info->sectorsize);
> +	u64 cur_offset = round_down(start, inode->root->fs_info->data_io_size);
>   	u64 prev_delalloc_end = 0;
>   	bool search_io_tree = true;
>   	bool ret = false;
> @@ -3602,10 +3602,10 @@ static loff_t find_desired_extent(struct file *file, loff_t offset, int whence)
>   	 */
>   	start = max_t(loff_t, 0, offset);
>   
> -	lockstart = round_down(start, fs_info->sectorsize);
> -	lockend = round_up(i_size, fs_info->sectorsize);
> +	lockstart = round_down(start, fs_info->data_io_size);
> +	lockend = round_up(i_size, fs_info->data_io_size);
>   	if (lockend <= lockstart)
> -		lockend = lockstart + fs_info->sectorsize;
> +		lockend = lockstart + fs_info->data_io_size;
>   	lockend--;
>   
>   	path = btrfs_alloc_path();
> diff --git a/fs/btrfs/fs.h b/fs/btrfs/fs.h
> index ab5ed7b4f639..cee4c772cfd9 100644
> --- a/fs/btrfs/fs.h
> +++ b/fs/btrfs/fs.h
> @@ -299,7 +299,7 @@ enum {
>   #define BTRFS_FEATURE_COMPAT_SAFE_SET		0ULL
>   #define BTRFS_FEATURE_COMPAT_SAFE_CLEAR		0ULL
>   
> -#define BTRFS_FEATURE_COMPAT_RO_SUPP			\
> +#define BTRFS_FEATURE_COMPAT_RO_SUPP_STABLE		\
>   	(BTRFS_FEATURE_COMPAT_RO_FREE_SPACE_TREE |	\
>   	 BTRFS_FEATURE_COMPAT_RO_FREE_SPACE_TREE_VALID | \
>   	 BTRFS_FEATURE_COMPAT_RO_VERITY |		\
> @@ -335,11 +335,17 @@ enum {
>   	 BTRFS_FEATURE_INCOMPAT_EXTENT_TREE_V2 | \
>   	 BTRFS_FEATURE_INCOMPAT_REMAP_TREE)
>   
> +#define BTRFS_FEATURE_COMPAT_RO_SUPP		\
> +	(BTRFS_FEATURE_COMPAT_RO_SUPP_STABLE |	\
> +	 BTRFS_FEATURE_COMPAT_RO_DATA_IO_SIZE)
>   #else
>   
>   #define BTRFS_FEATURE_INCOMPAT_SUPP		\
>   	(BTRFS_FEATURE_INCOMPAT_SUPP_STABLE)
>   
> +#define BTRFS_FEATURE_COMPAT_RO_SUPP		\
> +	(BTRFS_FEATURE_COMPAT_RO_SUPP_STABLE)
> +
>   #endif
>   
>   #define BTRFS_FEATURE_INCOMPAT_SAFE_SET			\
> @@ -892,6 +898,7 @@ struct btrfs_fs_info {
>   	u32 csum_size;
>   	u32 csums_per_leaf;
>   	u32 csum_type;
> +	u32 data_io_size;
>   
>   	/*
>   	 * Maximum size of an extent. BTRFS_MAX_EXTENT_SIZE on regular
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index b696dd329fd7..de0364ce950b 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -190,7 +190,7 @@ static int data_reloc_print_warning_inode(u64 inum, u64 offset, u64 num_bytes,
>   		btrfs_warn(fs_info,
>   "checksum error at logical %llu mirror %u root %llu inode %llu offset %llu length %u links %u (path: %s)",
>   			   warn->logical, warn->mirror_num, root, inum, offset,
> -			   fs_info->sectorsize, nlink,
> +			   fs_info->data_io_size, nlink,
>   			   (char *)(unsigned long)ipath->fspath->val[i]);
>   	}
>   
> @@ -1397,7 +1397,7 @@ static noinline int cow_file_range(struct btrfs_inode *inode,
>   	if (btrfs_is_data_reloc_root(root))
>   		min_alloc_size = num_bytes;
>   	else
> -		min_alloc_size = fs_info->sectorsize;
> +		min_alloc_size = fs_info->data_io_size;
>   
>   	while (num_bytes > 0) {
>   		ret = cow_one_range(inode, locked_folio, &ins, &cached, start,
> @@ -2783,7 +2783,7 @@ int btrfs_set_extent_delalloc(struct btrfs_inode *inode, u64 start, u64 end,
>   			      unsigned int extra_bits,
>   			      struct extent_state **cached_state)
>   {
> -	const u32 blocksize = inode->root->fs_info->sectorsize;
> +	const u32 blocksize = inode->root->fs_info->data_io_size;
>   
>   	/* Basic alignment check. */
>   	ASSERT(IS_ALIGNED(start, blocksize), "start=%llu blocksize=%u",
> @@ -2820,7 +2820,7 @@ int btrfs_set_extent_delalloc(struct btrfs_inode *inode, u64 start, u64 end,
>   int btrfs_reset_extent_delalloc(struct btrfs_inode *inode, u64 start, u64 end,
>   				unsigned int extra_bits, struct extent_state **cached_state)
>   {
> -	const u32 blocksize = inode->root->fs_info->sectorsize;
> +	const u32 blocksize = inode->root->fs_info->data_io_size;
>   
>   	/* The @extra_bits can only be EXTENT_NORESERVE for now. */
>   	ASSERT(!(extra_bits & ~EXTENT_NORESERVE), "extra_bits=0x%x", extra_bits);
> @@ -2874,7 +2874,7 @@ static int insert_reserved_file_extent(struct btrfs_trans_handle *trans,
>   	u64 num_bytes = btrfs_stack_file_extent_num_bytes(stack_fi);
>   	u64 ram_bytes = btrfs_stack_file_extent_ram_bytes(stack_fi);
>   	struct btrfs_drop_extents_args drop_args = { 0 };
> -	const u32 sectorsize = root->fs_info->sectorsize;
> +	const u32 sectorsize = root->fs_info->data_io_size;
>   	int ret;
>   
>   	path = btrfs_alloc_path();
> @@ -4040,7 +4040,7 @@ static int btrfs_read_locked_inode(struct btrfs_inode *inode, struct btrfs_path
>   	if (ret)
>   		goto out;
>   	btrfs_inode_set_file_extent_range(inode, 0,
> -			  round_up(i_size_read(vfs_inode), fs_info->sectorsize));
> +			  round_up(i_size_read(vfs_inode), fs_info->data_io_size));
>   
>   	if (!maybe_acls)
>   		cache_no_acl(vfs_inode);
> @@ -4879,7 +4879,7 @@ int btrfs_truncate_block(struct btrfs_inode *inode, u64 offset, u64 start, u64 e
>   	struct extent_state *cached_state = NULL;
>   	struct extent_changeset *data_reserved = NULL;
>   	bool only_release_metadata = false;
> -	u32 blocksize = fs_info->sectorsize;
> +	u32 blocksize = fs_info->data_io_size;
>   	pgoff_t index = (offset >> PAGE_SHIFT);
>   	struct folio *folio;
>   	gfp_t mask = btrfs_alloc_write_mask(mapping);
> @@ -5117,8 +5117,8 @@ int btrfs_cont_expand(struct btrfs_inode *inode, loff_t oldsize, loff_t size)
>   	struct extent_io_tree *io_tree = &inode->io_tree;
>   	struct extent_map *em = NULL;
>   	struct extent_state *cached_state = NULL;
> -	u64 hole_start = ALIGN(oldsize, fs_info->sectorsize);
> -	u64 block_end = ALIGN(size, fs_info->sectorsize);
> +	u64 hole_start = ALIGN(oldsize, fs_info->data_io_size);
> +	u64 block_end = ALIGN(size, fs_info->data_io_size);
>   	u64 last_byte;
>   	u64 cur_offset;
>   	u64 hole_size;
> @@ -5147,7 +5147,7 @@ int btrfs_cont_expand(struct btrfs_inode *inode, loff_t oldsize, loff_t size)
>   			break;
>   		}
>   		last_byte = min(btrfs_extent_map_end(em), block_end);
> -		last_byte = ALIGN(last_byte, fs_info->sectorsize);
> +		last_byte = ALIGN(last_byte, fs_info->data_io_size);
>   		hole_size = last_byte - cur_offset;
>   
>   		if (!(em->flags & EXTENT_FLAG_PREALLOC)) {
> @@ -5253,7 +5253,7 @@ static int btrfs_setsize(struct inode *inode, struct iattr *attr)
>   
>   		if (btrfs_is_zoned(fs_info)) {
>   			ret = btrfs_wait_ordered_range(BTRFS_I(inode),
> -					ALIGN(newsize, fs_info->sectorsize),
> +					ALIGN(newsize, fs_info->data_io_size),
>   					(u64)-1);
>   			if (ret)
>   				return ret;
> @@ -7323,7 +7323,7 @@ noinline int can_nocow_extent(struct btrfs_inode *inode, u64 offset, u64 *len,
>   		u64 range_end;
>   
>   		range_end = round_up(offset + nocow_args.file_extent.num_bytes,
> -				     root->fs_info->sectorsize) - 1;
> +				     root->fs_info->data_io_size) - 1;
>   		ret = btrfs_test_range_bit_exists(io_tree, offset, range_end,
>   						  EXTENT_DELALLOC);
>   		if (ret)
> @@ -7653,8 +7653,8 @@ static int btrfs_truncate(struct btrfs_inode *inode, bool skip_writeback)
>   	int ret;
>   	struct btrfs_trans_handle *trans;
>   	const u64 min_size = btrfs_calc_metadata_size(fs_info, 1);
> -	const u64 lock_start = round_down(inode->vfs_inode.i_size, fs_info->sectorsize);
> -	const u64 i_size_up = round_up(inode->vfs_inode.i_size, fs_info->sectorsize);
> +	const u64 lock_start = round_down(inode->vfs_inode.i_size, fs_info->data_io_size);
> +	const u64 i_size_up = round_up(inode->vfs_inode.i_size, fs_info->data_io_size);
>   
>   	/* Our inode is locked and the i_size can't be changed concurrently. */
>   	btrfs_assert_inode_locked(inode);
> @@ -8038,7 +8038,7 @@ static int btrfs_getattr(struct mnt_idmap *idmap,
>   	u64 delalloc_bytes;
>   	u64 inode_bytes;
>   	struct inode *inode = d_inode(path->dentry);
> -	u32 blocksize = btrfs_sb(inode->i_sb)->sectorsize;
> +	u32 blocksize = btrfs_sb(inode->i_sb)->data_io_size;
>   	u32 bi_flags = BTRFS_I(inode)->flags;
>   	u32 bi_ro_flags = BTRFS_I(inode)->ro_flags;
>   
> @@ -9124,8 +9124,8 @@ static int __btrfs_prealloc_file_range(struct inode *inode, int mode,
>   			 * to truncate disk_i_size to the start of the gap,
>   			 * making the persisted size smaller than i_size.
>   			 */
> -			range_start = round_down(inode->i_size, fs_info->sectorsize);
> -			range_end = round_up(i_size, fs_info->sectorsize);
> +			range_start = round_down(inode->i_size, fs_info->data_io_size);
> +			range_end = round_up(i_size, fs_info->data_io_size);
>   			ret = btrfs_inode_set_file_extent_range(BTRFS_I(inode),
>   					range_start, range_end - range_start);
>   			if (ret) {
> @@ -9272,10 +9272,10 @@ int btrfs_encoded_io_compression_from_extent(struct btrfs_fs_info *fs_info,
>   		 * The LZO format depends on the sector size. 64K is the maximum
>   		 * sector size that we support.
>   		 */
> -		if (fs_info->sectorsize < SZ_4K || fs_info->sectorsize > SZ_64K)
> +		if (fs_info->data_io_size < SZ_4K || fs_info->data_io_size > SZ_64K)
>   			return -EINVAL;
>   		return BTRFS_ENCODED_IO_COMPRESSION_LZO_4K +
> -		       (fs_info->sectorsize_bits - 12);
> +		       (ilog2(fs_info->data_io_size) - 12);
>   	case BTRFS_COMPRESS_ZSTD:
>   		return BTRFS_ENCODED_IO_COMPRESSION_ZSTD;
>   	default:
> @@ -9563,7 +9563,7 @@ ssize_t btrfs_encoded_read(struct kiocb *iocb, struct iov_iter *iter,
>   		btrfs_inode_unlock(inode, BTRFS_ILOCK_SHARED);
>   		return 0;
>   	}
> -	start = ALIGN_DOWN(iocb->ki_pos, fs_info->sectorsize);
> +	start = ALIGN_DOWN(iocb->ki_pos, fs_info->data_io_size);
>   	/*
>   	 * We don't know how long the extent containing iocb->ki_pos is, but if
>   	 * it's compressed we know that it won't be longer than this.
> @@ -9676,7 +9676,7 @@ ssize_t btrfs_encoded_read(struct kiocb *iocb, struct iov_iter *iter,
>   		count = start + *disk_io_size - iocb->ki_pos;
>   		encoded->len = count;
>   		encoded->unencoded_len = count;
> -		*disk_io_size = ALIGN(*disk_io_size, fs_info->sectorsize);
> +		*disk_io_size = ALIGN(*disk_io_size, fs_info->data_io_size);
>   	}
>   	btrfs_free_extent_map(em);
>   	em = NULL;
> @@ -9720,7 +9720,7 @@ ssize_t btrfs_do_encoded_write(struct kiocb *iocb, struct iov_iter *from,
>   	int compression;
>   	size_t orig_count;
>   	const u32 min_folio_size = btrfs_min_folio_size(fs_info);
> -	const u32 blocksize = fs_info->sectorsize;
> +	const u32 blocksize = fs_info->data_io_size;
>   	u64 start, end;
>   	u64 num_bytes, ram_bytes, disk_num_bytes;
>   	struct btrfs_key ins;
> @@ -9743,7 +9743,7 @@ ssize_t btrfs_do_encoded_write(struct kiocb *iocb, struct iov_iter *from,
>   		/* The sector size must match for LZO. */
>   		if (encoded->compression -
>   		    BTRFS_ENCODED_IO_COMPRESSION_LZO_4K + 12 !=
> -		    fs_info->sectorsize_bits)
> +		    ilog2(blocksize))
>   			return -EINVAL;
>   		compression = BTRFS_COMPRESS_LZO;
>   		break;
> @@ -9785,7 +9785,7 @@ ssize_t btrfs_do_encoded_write(struct kiocb *iocb, struct iov_iter *from,
>   
>   	/* The extent must start on a sector boundary. */
>   	start = iocb->ki_pos;
> -	if (!IS_ALIGNED(start, fs_info->sectorsize))
> +	if (!IS_ALIGNED(start, fs_info->data_io_size))
>   		return -EINVAL;
>   
>   	/*
> @@ -9794,15 +9794,15 @@ ssize_t btrfs_do_encoded_write(struct kiocb *iocb, struct iov_iter *from,
>   	 * up the extent size and set i_size to the unaligned end.
>   	 */
>   	if (start + encoded->len < inode->vfs_inode.i_size &&
> -	    !IS_ALIGNED(start + encoded->len, fs_info->sectorsize))
> +	    !IS_ALIGNED(start + encoded->len, fs_info->data_io_size))
>   		return -EINVAL;
>   
>   	/* Finally, the offset in the unencoded data must be sector-aligned. */
> -	if (!IS_ALIGNED(encoded->unencoded_offset, fs_info->sectorsize))
> +	if (!IS_ALIGNED(encoded->unencoded_offset, fs_info->data_io_size))
>   		return -EINVAL;
>   
> -	num_bytes = ALIGN(encoded->len, fs_info->sectorsize);
> -	ram_bytes = ALIGN(encoded->unencoded_len, fs_info->sectorsize);
> +	num_bytes = ALIGN(encoded->len, fs_info->data_io_size);
> +	ram_bytes = ALIGN(encoded->unencoded_len, fs_info->data_io_size);
>   	end = start + num_bytes - 1;
>   
>   	/*
> @@ -9810,7 +9810,7 @@ ssize_t btrfs_do_encoded_write(struct kiocb *iocb, struct iov_iter *from,
>   	 * sector-aligned. For convenience, we extend it with zeroes if it
>   	 * isn't.
>   	 */
> -	disk_num_bytes = ALIGN(orig_count, fs_info->sectorsize);
> +	disk_num_bytes = ALIGN(orig_count, fs_info->data_io_size);
>   
>   	cb = btrfs_alloc_compressed_write(inode, start, num_bytes);
>   	for (int i = 0; i * min_folio_size < disk_num_bytes; i++) {
> @@ -10222,7 +10222,7 @@ static int btrfs_swap_activate(struct swap_info_struct *sis, struct file *file,
>   	atomic_inc(&root->nr_swapfiles);
>   	spin_unlock(&root->root_item_lock);
>   
> -	isize = ALIGN_DOWN(inode->i_size, fs_info->sectorsize);
> +	isize = ALIGN_DOWN(inode->i_size, fs_info->data_io_size);
>   
>   	btrfs_lock_extent(io_tree, 0, isize - 1, &cached_state);
>   	while (prev_extent_end < isize) {
> diff --git a/fs/btrfs/lzo.c b/fs/btrfs/lzo.c
> index 1531adb117d1..0235530fd0f8 100644
> --- a/fs/btrfs/lzo.c
> +++ b/fs/btrfs/lzo.c
> @@ -414,7 +414,7 @@ int lzo_decompress_bio(struct list_head *ws, struct compressed_bio *cb)
>   {
>   	struct workspace *workspace = list_entry(ws, struct workspace, list);
>   	struct btrfs_fs_info *fs_info = cb->bbio.inode->root->fs_info;
> -	const u32 sectorsize = fs_info->sectorsize;
> +	const u32 sectorsize = fs_info->data_io_size;
>   	const u32 compressed_len = bio_get_size(&cb->bbio.bio);
>   	struct folio_iter fi;
>   	char *kaddr;
> diff --git a/fs/btrfs/sysfs.c b/fs/btrfs/sysfs.c
> index 0d14570c8bc2..8ca7b7e304e3 100644
> --- a/fs/btrfs/sysfs.c
> +++ b/fs/btrfs/sysfs.c
> @@ -301,6 +301,7 @@ BTRFS_FEAT_ATTR_INCOMPAT(extent_tree_v2, EXTENT_TREE_V2);
>   BTRFS_FEAT_ATTR_INCOMPAT(raid_stripe_tree, RAID_STRIPE_TREE);
>   /* Remove once support for remap tree is feature complete. */
>   BTRFS_FEAT_ATTR_INCOMPAT(remap_tree, REMAP_TREE);
> +BTRFS_FEAT_ATTR_COMPAT_RO(data_io_size, DATA_IO_SIZE);
>   #endif
>   #ifdef CONFIG_FS_VERITY
>   BTRFS_FEAT_ATTR_COMPAT_RO(verity, VERITY);
> @@ -334,6 +335,7 @@ static struct attribute *btrfs_supported_feature_attrs[] = {
>   	BTRFS_FEAT_ATTR_PTR(extent_tree_v2),
>   	BTRFS_FEAT_ATTR_PTR(raid_stripe_tree),
>   	BTRFS_FEAT_ATTR_PTR(remap_tree),
> +	BTRFS_FEAT_ATTR_PTR(data_io_size),
>   #endif
>   #ifdef CONFIG_FS_VERITY
>   	BTRFS_FEAT_ATTR_PTR(verity),
> diff --git a/fs/btrfs/tests/btrfs-tests.c b/fs/btrfs/tests/btrfs-tests.c
> index 6287d940323d..e3e7bbee7cd7 100644
> --- a/fs/btrfs/tests/btrfs-tests.c
> +++ b/fs/btrfs/tests/btrfs-tests.c
> @@ -140,6 +140,7 @@ struct btrfs_fs_info *btrfs_alloc_dummy_fs_info(u32 nodesize, u32 sectorsize)
>   	fs_info->nodesize = nodesize;
>   	fs_info->sectorsize = sectorsize;
>   	fs_info->sectorsize_bits = ilog2(sectorsize);
> +	fs_info->data_io_size = sectorsize;
>   
>   	/* CRC32C csum size. */
>   	fs_info->csum_size = 4;
> diff --git a/include/uapi/linux/btrfs.h b/include/uapi/linux/btrfs.h
> index 0a13baf3d8d1..858a37811586 100644
> --- a/include/uapi/linux/btrfs.h
> +++ b/include/uapi/linux/btrfs.h
> @@ -314,6 +314,13 @@ struct btrfs_ioctl_fs_info_args {
>    */
>   #define BTRFS_FEATURE_COMPAT_RO_BLOCK_GROUP_TREE	(1ULL << 3)
>   
> +/*
> + * Force all IOs (including buffered, direct, compressed) to be aligned
> + * to btrfs_super_block::data_io_size other than sectorsize.
> + * Meanwhile still data checksum to be calculated based on sectorsize.
> + */
> +#define BTRFS_FEATURE_COMPAT_RO_DATA_IO_SIZE		(1ULL << 4)
> +
>   #define BTRFS_FEATURE_INCOMPAT_MIXED_BACKREF	(1ULL << 0)
>   #define BTRFS_FEATURE_INCOMPAT_DEFAULT_SUBVOL	(1ULL << 1)
>   #define BTRFS_FEATURE_INCOMPAT_MIXED_GROUPS	(1ULL << 2)
> diff --git a/include/uapi/linux/btrfs_tree.h b/include/uapi/linux/btrfs_tree.h
> index cc3b9f7dccaf..3b979ba5a3fc 100644
> --- a/include/uapi/linux/btrfs_tree.h
> +++ b/include/uapi/linux/btrfs_tree.h
> @@ -724,9 +724,10 @@ struct btrfs_super_block {
>   	__le64 remap_root;
>   	__le64 remap_root_generation;
>   	__u8 remap_root_level;
> +	__u32 data_io_size;
>   
>   	/* Future expansion */
> -	__u8 reserved[199];
> +	__u8 reserved[195];
>   	__u8 sys_chunk_array[BTRFS_SYSTEM_CHUNK_ARRAY_SIZE];
>   	struct btrfs_root_backup super_roots[BTRFS_NUM_BACKUP_ROOTS];
>   

