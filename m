Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08CA735B644
	for <linux-btrfs@vger.kernel.org>; Sun, 10 May 2026 08:11:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778400691; cv=none; b=dcYbjOenZRSYf3JRZsc9P5L8HBtQ30nC8F0/pVfamaHFA3B/QHIzCU33bPoGO0RpVMgWmRyF+lO1Rl5VeCRCUV+UiVbbwnFS8olthT3/roJmdsAme5/Tvc7qstlYRsLHuVgRIuoEbD0NgkM1yAYZAcxprxyhfnyMhOtllNWM+0c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778400691; c=relaxed/simple;
	bh=hXf6XDZAvoesKn8bYhqwz57c/Bi02fWC6eQtghtL8tQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=pGS05GJfxxGNAE8T4D6oYILgBMNAHyEz4fZQu+av9RCMJyeyf0Sqav3AsyP4XIYSyHuWQPMUb7mAltvNRghukO/RoXkrUG1kpVkvPAvWv7CNgy/4Pcfh9DfL163sD5tyih0W/6Xi/ZJsn5B1R+4s7rHS53YodzLEZkL57MaGTNU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=VqNyvXgc; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="VqNyvXgc"
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-48d146705b4so40697625e9.3
        for <linux-btrfs@vger.kernel.org>; Sun, 10 May 2026 01:11:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1778400688; x=1779005488; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=jdBd2K+XyYK4gg5k9EdnlmYFAARykABmdoS/J/fFYKA=;
        b=VqNyvXgcydJIvZpJf0OYghkcAnzOS6MQKQBjXP2PsCg3R09A2NXdpCUpd1mAROsa+a
         /2P7fldxwj7L9sKzyR2gZrLJSnf4hcH9P7XnueD0BN9NuPRN4FktKHDZhsuG3UuTL+c7
         Tg8S4a3EE1xMvqSGdAuN83YuOw7B1+OX+6lINQit6qjarRojlfqpcpc+6ugs3lfl7ceE
         8V3IudHaJrSEWowrxgMbnqDcAAwzJGSdHXTuDq7KAmSS7QtYl6D6iDssglmzusGLLLZb
         HuBrvhUSj48GpcPlXSh/SZG023DzhNb09AF0ShyfWSASPrK7YVqG8K6jV/+xeT2qjdEb
         RDnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778400688; x=1779005488;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jdBd2K+XyYK4gg5k9EdnlmYFAARykABmdoS/J/fFYKA=;
        b=hwgqPN8V8rVOMw88k4BsHCHIcxoA2iZ0n4tC5j9Pp9h2LzOZLEjkjkwxtaV9TRc9Tv
         GH0IWEAtob5aSq4Y0Y+QGNOnPeyzTACyqnHWF8po0I4h+rppaZbmPpeZbeVCGurL7U7z
         8gSeU4Ca6Bp7IIsiLVIci0oR9tOgIhnkELLIwCdOjqkG6/IF1j9VTM6iStahbwi5dK6f
         kWfYJ66ejd2Nbssv5FdYIPXstyE03nsk50xjL6mnF39smkO782AZR5JS2m00HxXJvXzt
         tB+qLEb7Ib9Y3c/81hyk0lXbBpxZKAwqYo7DdavlofPqDT6Um8CZsYw3kfVFQlc0f30/
         rhOQ==
X-Gm-Message-State: AOJu0YzkJkXQN7wFipHSkSyWdqWSjysTptqS1xSA/u6spGZ9CF0ChfSu
	bFGcmYQNI/pKN6zt48G+9C8Cm/JFQx8z0y6n2dK2pMS/5bk0KaB/bNf1pRxS3mNPgvA=
X-Gm-Gg: Acq92OFR+b/Csx6z0kwMeTEXvXHuXqoowYhe1N+cWD4RaI6f/NJTdAHq863N5ymV/Vv
	MjnucmX86rTk9Rs3sMohaQFKsaRcCLZbqhStuGgRk0W7yEi7N4HW7z8lfVfTdRazQ4+gijiC/6C
	RmXOxJB3jspZI43xe6oy2kVmbOAAVSeUysOzxF07ypIelBY9RHTV+wuoxpIpkCHzYSj5vlTYr3T
	Xaj5c40D/15SpchYGW0rQAHAgMPVVz6YulVVipYibAh/Af73T/Hv2nKo6vEEwoWHj5j7SFv8yZ3
	ONWRNPlKxCuTn4kzQAhqQB5GW39vAiExSdoWDZnpceiJMYVe85TMvCO8ko9LJdAKzuNFvQy0MzE
	WGrnqiE7T1AJSV0Z4S4ubkdNtctdGrYE2i+yLbVqZK607qY4M21HC+3fa3D3btT33S5mHfrcxX7
	v9HwLftYpWQ+4wLs0dXFWmiFzPAj9qZ2/mw8bQOaWgRv08IDTI6YZ44sWvzjm7oPrrTAbO3Nvgz
	qHr+5pwuiYoFBo6n6pd8FWXx+NYYxtfodgA4KQDVKyiYOVHmhKiFXvSfg==
X-Received: by 2002:a05:600c:c11c:b0:488:9e54:94c0 with SMTP id 5b1f17b1804b1-48e51f2a79bmr227980005e9.8.1778400688126;
        Sun, 10 May 2026 01:11:28 -0700 (PDT)
Received: from ?IPV6:2403:580d:fda1:0:2bb5:f164:6e6a:38d8? (2403-580d-fda1-0-2bb5-f164-6e6a-38d8.ip6.aussiebb.net. [2403:580d:fda1:0:2bb5:f164:6e6a:38d8])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-839679c7ba9sm17008466b3a.35.2026.05.10.01.11.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 10 May 2026 01:11:25 -0700 (PDT)
Message-ID: <3d7dd749-396c-4ce9-a82a-d465bcd821be@suse.com>
Date: Sun, 10 May 2026 17:41:18 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] btrfs: free-space-tree: reject mismatched extent and
 bitmap items
To: Zhang Cen <rollkingzzc@gmail.com>, Chris Mason <clm@fb.com>,
 David Sterba <dsterba@suse.com>
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
 zerocling0077@gmail.com, 2045gemini@gmail.com
References: <20260510074943.2644334-1-rollkingzzc@gmail.com>
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
In-Reply-To: <20260510074943.2644334-1-rollkingzzc@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/5/10 17:19, Zhang Cen 写道:
> btrfs_load_free_space_tree() picks bitmap or extent mode from the
> FREE_SPACE_INFO flags and then lets load_free_space_bitmaps() or
> load_free_space_extents() walk the following records until the next info
> item. Those walkers only verify the record type and range with ASSERT(),
> so production builds can decode an EXTENT item as bitmap data or accept
> a BITMAP item as a whole free extent.
> 
> Add a shared runtime check for each post-info key and call it from both
> loaders before decoding the current record. Reject keys whose type does
> not match the mode selected by FREE_SPACE_INFO and keys whose range falls
> outside the block group with -EUCLEAN, instead of reaching
> btrfs_free_space_test_bit() or btrfs_add_new_free_space() with an
> unexpected record.
> 
> Sanitizer validation reported a fatal fault in extent_buffer_test_bit()
> (fs/btrfs/extent_io.c:4313) through btrfs_free_space_test_bit()
> (fs/btrfs/free-space-tree.c:518), reached from load_free_space_bitmaps()
> (fs/btrfs/free-space-tree.c:1603) after an extent item was decoded as
> bitmap data.
> 
> Sanitizer validation reported:
> Oops: general protection fault, probably for non-canonical address 0xdffffc0000000001: 0000 [#1] SMP KASAN NOPTI
> Call trace:
>    assert_eb_folio_uptodate() (fs/btrfs/extent_io.c:4134)
>    extent_buffer_test_bit() (?:?)
>    btrfs_free_space_test_bit() (fs/btrfs/free-space-tree.c:518)
>    srso_alias_return_thunk() (arch/x86/include/asm/nospec-branch.h:375)
>    __entry_text_end() (?:?)
>    __asan_memcpy() (mm/kasan/shadow.c:103)
>    read_extent_buffer() (?:?)
>    load_free_space_bitmaps() (fs/btrfs/free-space-tree.c:1548)
>    btrfs_get_32() (fs/btrfs/free-space-tree.c:?)
>    btrfs_set_16() (fs/btrfs/free-space-tree.c:?)
>    kmem_cache_alloc_noprof() (?:?)
>    btrfs_load_free_space_tree() (fs/btrfs/free-space-tree.c:1685)
>    load_free_space_tree_for_test() (?:?)
>    rcu_disable_urgency_upon_qs() (kernel/rcu/tree.c:721)
>    vprintk_emit() (?:?)
>    __up_write() (kernel/locking/rwsem.c:1401)
>    clone_commit_root_for_test() (?:?)
>    test_extent_as_bitmap_mode_mismatch() (?:?)
>    kmem_cache_free() (?:?)
>    btrfs_free_path() (fs/btrfs/free-space-tree.c:1449)
>    __add_block_group_free_space() (fs/btrfs/free-space-tree.c:20)
>    run_test() (?:?)
>    do_raw_spin_unlock() (?:?)
>    btrfs_test_free_space_tree() (fs/btrfs/tests/free-space-tree-tests.c:547)
>    btrfs_test_qgroups() (fs/btrfs/tests/qgroup-tests.c:462)
>    btrfs_run_sanity_tests() (fs/btrfs/free-space-tree.c:?)
>    init_btrfs_fs() (fs/btrfs/super.c:2690)
>    do_one_initcall() (init/main.c:1382)
>    __kasan_kmalloc() (?:?)
>    rcu_is_watching() (?:?)
>    do_initcalls() (init/main.c:1457)
>    kernel_init_freeable() (init/main.c:1674)
>    kernel_init() (init/main.c:1584)
>    ret_from_fork() (?:?)
>    __switch_to() (?:?)
>    ret_from_fork_asm() (?:?)
> 
> Signed-off-by: Zhang Cen <rollkingzzc@gmail.com>
> 
> ---
> diff --git a/fs/btrfs/free-space-tree.c b/fs/btrfs/free-space-tree.c
> index 472b3060e5ac..e7fed8041eb1 100644
> --- a/fs/btrfs/free-space-tree.c
> +++ b/fs/btrfs/free-space-tree.c
> @@ -1545,6 +1545,30 @@ int btrfs_remove_block_group_free_space(struct btrfs_trans_handle *trans,
>   	return 0;
>   }
>   
> +static int validate_free_space_key(struct btrfs_block_group *block_group,
> +				   const struct btrfs_key *key,
> +				   u8 expected_type)
> +{
> +	const u64 end = btrfs_block_group_end(block_group);
> +
> +	if (key->type != expected_type) {
> +		btrfs_err(block_group->fs_info,
> +			  "block group %llu has unexpected free space key type %u, expected %u",
> +			  block_group->start, key->type, expected_type);
> +		return -EUCLEAN;
> +	}
> +
> +	if (key->objectid >= end || key->offset > end - key->objectid) {

The later half "key->offset > end - key->objectid" is unsafe and very 
hard to read.

"end - key->objectid" can underflow.

Change it to "key->objectid + key->offset > end" will be easier to read.

Furthermore, "key->offset" should never be zero, thus in that case
a single "key->objectid + key->offset > end" will be more than enough.

For the key->offset != 0 part, it can be validated inside tree-checker.


> +		btrfs_err(block_group->fs_info,
> +			  "block group %llu has invalid free space key (%llu %u %llu)",
> +			  block_group->start, key->objectid, key->type,
> +			  key->offset);
> +		return -EUCLEAN;
> +	}
> +
> +	return 0;
> +}
> +
>   static int load_free_space_bitmaps(struct btrfs_caching_control *caching_ctl,
>   				   struct btrfs_path *path,
>   				   u32 expected_extent_count)
> @@ -1576,8 +1600,10 @@ static int load_free_space_bitmaps(struct btrfs_caching_control *caching_ctl,
>   		if (key.type == BTRFS_FREE_SPACE_INFO_KEY)
>   			break;
>   
> -		ASSERT(key.type == BTRFS_FREE_SPACE_BITMAP_KEY);
> -		ASSERT(key.objectid < end && key.objectid + key.offset <= end);
> +		ret = validate_free_space_key(block_group, &key,
> +					      BTRFS_FREE_SPACE_BITMAP_KEY);
> +		if (ret)

Please use unlikely() for every validate_free_space_key() failure.
