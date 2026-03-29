Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19E4F279DB6
	for <linux-btrfs@vger.kernel.org>; Sun, 29 Mar 2026 22:06:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774821986; cv=none; b=lNedpiVjATuwG+OJpNCMNEKtixCIc4ne7KumqlTjktD/RhoH79GjoqKu6ZM018Dee8J5dUrlsfWgMdW4OhkMNdoZa5sVgeIjGypQt0njjIt9bbpJq2gQEBnGawQYOkNtfsXnpRadgW5kY67kUYSGUGTCfzOvV+Sg50qD6Bsogus=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774821986; c=relaxed/simple;
	bh=xbAs3+vxI3j8IhtGlNJTl+q+sJxpxAGcGgsqqVHSRyY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ibQ0qcuH+ykWZTI1qF5fMhlbkcKOEL2839vcbvd3PVQswzU2pfYSVqzC6JfjmF4RgVIZgXDzWxbnSb90kgAYlwBVWfAnPi3JaC19VpVH/xHuYozYbMNtrfua0YC84X5Q42kDrNg604yklpLJ/aL6e+VVz3VS0VCDn0Mo/3OGl1k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=Ry/5hCem; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="Ry/5hCem"
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-486fc4725f0so37028495e9.1
        for <linux-btrfs@vger.kernel.org>; Sun, 29 Mar 2026 15:06:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1774821983; x=1775426783; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=wGw24ECR2pHfvLNxPa17W2ZXRMCDSYIzeBPVTX7Kjdw=;
        b=Ry/5hCemsPXtXKIZYqyh4L+7PpSvb8ADzWy4OvTyw39tLDgLHqN67ZBdnT9JpI46wv
         t4mYUt+YzEuC1brf0lTNfTZATlyQV8AG8eBMGwbH4zvLlWnlIgywbu7XAqNv9Rtsge6h
         AQkXz9o6WOgfj5Qb36qjn3MW6ysMYC7FtmlBMgmPXGlx84iYj404KyRtqfRgt9+UR9dw
         a6bkrVVSXAa1H3DZvZP90xBD+hrHns//sS4nryRtQAbQqC1DF1uPoAdyvM1B1DZubHYN
         okOIgXioRYpo7Bw2W8MKjg86NQpxeMUUSIADJVSSo++W4Fku6MZ9DnPR3uqdt+nZjYEf
         3SyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774821983; x=1775426783;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wGw24ECR2pHfvLNxPa17W2ZXRMCDSYIzeBPVTX7Kjdw=;
        b=ABTYHf+FIcC/RnCjkMGvE/DIbphfxlCqerx8AlJsvqdTJJUkwWcvMruqlXueFQKKFX
         y4NOhJrkzuRC0hKt7MrT78gn1DR0UCPeGgi61mI0McRy5dx1IqiwB5WC6lKkT4RMuQaQ
         h+IVVmHUZf2rbTAY6JSMkcgTdkrNx9vZUcxG3omUbYuO37PW+j+HiEFmgcpvV/ZZOkpp
         9gBuCjNU43dCcYKosRVJ03zeUlsWaIbF43qzB8JBeZpaJpebC0b4CACPDwVUBEshXMSQ
         dOT7ltsCkyiF/prbumn1M6m25KIivC1OeWGBLgHbq0dZRy8trG22A4bg3FzTCU7vHbbI
         9N/A==
X-Forwarded-Encrypted: i=1; AJvYcCWF7ewGJQE8YAaAsqt3xbTeORLvN3EOk9Q9RFjwkr90IqTt6BtVjDrEFTPWNLG43IH3IvL+hnAuS6EZ2A==@vger.kernel.org
X-Gm-Message-State: AOJu0YyuB4weWK1vyMYqFi7gp+S7i1deD/Z5XJlnI509k4vD6thI7Iac
	AHLO16kaheuaaSPknShEkpxeP5hdL0Jf5guXyzYbXyANQ6qGVFZUZDp5UPBnMZBHPoU=
X-Gm-Gg: ATEYQzxdQEwKsCGO0aU5IZQTlnYsRB2kyRbYMbwbTUv+bhWuiSBeeNt6EbFnetHh0XU
	BjDxLEZqLlZ128BPLcp0x9SrprM/6Rlg83eEOry6vTFYD8QppLZjMP2Doq3JCzGzKIAbgcHLIFT
	/zVy0/bYPsK8kRKSFZtNyFVR5KesCfF8VU+N7odfg/4E80h5EZRAFzmwUoHxwgDtz1IPs223gaf
	UDR3GE8sC7x5qWd3DIh5T35or6r5VFxXLUTMxYTrJARKg0HcSB1CZBZlaiguEx41j/SD8zDI7Ar
	dLrUBohgSHl139jcjDgMhb7ysBrZIra/MQmE2LDlrLEGX0pOhy55ntf2MnR+vkQ77mkvgCPgKzS
	+BSJRKwvaeqpuQXEPEn2ExyO24ANVWQRL1WDOYAW2LAxILMoeXm9Ef5uz5Kn0O3pyflfJnqNB6t
	KUuq+mAe9iRp44KLmqRLfg0fQXb1l2g3TvmIyxthpMkXOXQolggC4=
X-Received: by 2002:a05:600c:2d82:b0:487:467:49e9 with SMTP id 5b1f17b1804b1-48722b92fcfmr132017345e9.7.1774821983298;
        Sun, 29 Mar 2026 15:06:23 -0700 (PDT)
Received: from ?IPV6:2403:580d:fda1::299? (2403-580d-fda1--299.ip6.aussiebb.net. [2403:580d:fda1::299])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b242765d49sm68719125ad.54.2026.03.29.15.06.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 29 Mar 2026 15:06:22 -0700 (PDT)
Message-ID: <4a129696-0352-427f-9e0e-7962e789df57@suse.com>
Date: Mon, 30 Mar 2026 08:36:15 +1030
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] btrfs: wait for in-flight readahead BIOs on open_ctree()
 error
To: Teng Liu <27rabbitlt@gmail.com>, linux-btrfs@vger.kernel.org
Cc: dsterba@suse.com, clm@fb.com, linux-kernel@vger.kernel.org
References: <20260329063417.642647-1-27rabbitlt@gmail.com>
 <11c944aa-7745-4720-9f40-af99bf7bb727@suse.com> <aclYf4R2XxlUkxAQ@rabbitArch>
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
In-Reply-To: <aclYf4R2XxlUkxAQ@rabbitArch>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/3/30 03:53, Teng Liu 写道:
> Thanks for your review!
> On 2026-03-29 17:33, Qu Wenruo wrote:
>>
>>
>> This doesn't make any sense to me.
> It confuses me as well when I try to reproduce the bug. The reported
> claimed that btrfs_bio_counter_sub triggered a use-after-free but this
> function lives under `dev-reaplce.c` which should have nothing to do
> with the setting from the name.
> 
> However when I checked the function call chain:
> 
> open_ctree()
>    → btrfs_read_sys_array()          # OK — sys_chunk_array in superblock is intact
>    → load_super_root(chunk_root)     # OK — reads root node, passes validation
>    → btrfs_read_chunk_tree()
>        → btrfs_for_each_slot()
>            → readahead_tree_node_children(node)
>                → for each child pointer in the internal node:
>                    btrfs_readahead_node_child()
>                      → btrfs_readahead_tree_block()
>                        → read_extent_buffer_pages_nowait()
>                          → btrfs_submit_bbio()
>                            → btrfs_submit_chunk()
>                              → btrfs_bio_counter_inc_blocked()  ← bio_counter++
>                              → btrfs_map_block()
>                              → submit_bio()                     ← sent to USB drive

Even you wait for all bios, it can still cause problems.

As the bio counter is only for btrfs bio layer, we still have 
btrfs_bio::end_io called after btrfs_bio_counter_dec().

And if the full fs_info has been freed, then at end_bbio_meta_read(), we 
can still have problems as btrfs_validate_extent_buffer() will access eb 
(bbio->private) and fs_info (eb->fs_info), which triggers use after free.

So using that bio counter is not going to solve all problems, but only 
reducing the race window thus masking the problem.

> 
> After submit_bio() sends BIO to USB drive, we continue on
> read_one_dev():
> 
> open_ctree()
>    → btrfs_read_sys_array()          # OK — sys_chunk_array in superblock is intact
>    → load_super_root(chunk_root)     # OK — reads root node, passes validation
>    → btrfs_read_chunk_tree()
>        → btrfs_for_each_slot()
>            → readahead_tree_node_children(node)
>              → bio_coutner++ and submit_bio() send BIO to USB drive
>            → read_one_dev()
> 
> This read_one_dev will return an error since the leaf block is actually
> corrupted. Then open_ctree will get into error path and try to free
> fs_info.
> 
> After USB device finished BIO, it will try to decreament the counter but
> the fs_info is already freed.
> 
> Any suggestions on this?

The following ideas come up to me, but neither seems as simple as your 
current one:

1) Introduce a dedicated counter for metadata readahead/reads
    This seems to be the simplest one among all.
    But the only usage is only the error handling, thus may not be
    worthy.

2) Disable metadata readahead during open_ctree()
    Which will delay the mount, especially for large extent tree without
    bgt feature.

3) Use buffer_tree xarray to iterate through all ebs
    Since this is only for error handling of open_ctree(), we're fine to
    do the full xarray iteration, and wait for any eb that has
    EXTENT_BUFFER_READING flag.

    The problem is, we do not have a dedicated tag like
    PAGECACHE_TAG_(TOWRITE|DIRTY) to easily catch all dirty/writeback
    ebs.
    So the only option is to go through each eb and check their flags.

    I think this is the one with minimal impact, but may cause much
    longer runtime during this error handling path.

My personal preference is option 3).

> 
> 
>>
>> The wait and counter are all for dev-reaplce, not matching your description
>> of the generic metadata readahead.
>>
>> If you want to wait for all existing metadata reads, I didn't find a good
>> helper, thus you will need to go through all extent buffers and wait for
>> EXTENT_BUFFER_READING flags.
>>
>>
> 
> 

