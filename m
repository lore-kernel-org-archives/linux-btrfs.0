Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA31726AF4
	for <linux-btrfs@vger.kernel.org>; Sat,  5 Sep 2026 22:26:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788647171; cv=none; b=sgX6bO4uupJqyXkXZbSaEfU9d7FLbJKTsHenkSsHI8a/oV7SZT4CAL4mM4WSDB8ivHMwc1iZxfQW2SCh+eRUYHKv8lWJH6fiAL3wegEL3mglAe6ad76Ctzg4sMpwDT/BeAdsj1p7CWIb5Qgvb5IULm+TcHjRAUqGqo95LzL8yzM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788647171; c=relaxed/simple;
	bh=464yH0VbBIv0gXreIbL6VSnJtdGIQI+eXDyuspyqNvU=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=ulG75deAZMVLU9Pxn4mAWy1yle7So4YBkVhmqOYyV59l6W+n8sGJrdODl9pZGnYi9gNjn6JviMY36q2Fil2f2z2ZWS88Q5XbXg4hEBXH5BwljtvAAcdKCfpVEAaJfIX5HDc94T4y2zFHW//SjOe/8vCfPQKIzcx3VwN2OOXgNZs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=SfPgkX4q; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="SfPgkX4q"
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-499ac87c92bso25523075e9.1
        for <linux-btrfs@vger.kernel.org>; Sat, 05 Sep 2026 15:26:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1788647167; x=1789251967; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=5D9dMz2JHsNf2RuiWOyKtKQVm7MUkhFwTSlN0Njb5B8=;
        b=SfPgkX4q6rKRxp4kCSYYx8SZ0KXVekcZZRfNNp+crEdGeucAcrJaGyyF0BC+95DRaH
         P8px6En0uzKjCOdqVAxNmBu6ScR8OHB1lt459qFq7/ynsGs/h9WSOLZ1qL5hwgIyLBnV
         v+obRy+1cvTW5tCi43VHcjMcMD0BiQIEh9MJN6pwQoXyLopTUFN222yA0qI0ZxqqwiGI
         WViB0IfBh6u9w0tFdmhZbRosO5uEDugaNATaCAfYc6VuSc9aGxWgMEZH82GyCvIJ5kQH
         lP28sBH9PX86XvTSwG2mO/61zmAPkTrrKUq92vj077HVkrUiN4tRLdquftSy/8M8cQy+
         IG4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788647167; x=1789251967;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=5D9dMz2JHsNf2RuiWOyKtKQVm7MUkhFwTSlN0Njb5B8=;
        b=V9ql5R/QIkI2sJEoS6Jgd7VfLqP0zUo5/0fFmHaJkRcZ1SKX/B75GuhiPDFq3Y9fzq
         TO/h4SyCF8fydyo0Vw8Hm/Yvm6nQB4skHmfO/aNXtgNNs9Se3myu7ih7B48yTwpzJ0m4
         FW+3SN+xQ421VT+OPPh5GCxHxx5Jx6WZx6sroFVtsmpn7VCVfoapmWURt9J/844YtD6b
         1aRfsCPSzJYhU6Ei0wHrSHM45QpGRyEpglFiTMNK38XnYAsdJAA55ga7FiVw23sk+6qV
         fQdY/pPMiMVijYHK1k6zabyTJQX4Y2QpVuKKiQZuMRPFLjfFgbbLNBY3/XJ643N1PAUg
         Ta0Q==
X-Forwarded-Encrypted: i=1; AKwUvBwLqOa6f0UvEssZ4S7r77c3zRpLn0xiwMkUNYELPs1uee+UaHK8HtX1ebI0QpsfShWdxg3Cbf9jgnPn5g==@vger.kernel.org
X-Gm-Message-State: AFuF++lAWEy1dwaREGRQZy/VpEQ5S3Ssf27uP7iixInQjt+4AcCARU3f
	1pOMUQYh8P6opscgu2r8SMC3U8CEo5+npX0tjlgXplMMqdiur4KLt1k2IQTehEta0E8=
X-Gm-Gg: AYBFou1zhBsQ31c70Q2AJfrraS/Hfy044F+7b0Y8mi4viH63MGfPb1TC/63I/8425qr
	D6cSf38cmDCHyvJaEtGTm2P9uq20bBaHJVWl3c1p1X5zIi8jsPl7ZPDrV6f46BaH3rSSKStcSaa
	X4zmEb9CBURLziaFXuPlqM1VQyIZgWe/rwi3Ys3AOeDtFcN8f+wUmAPZ4yiyZN9lfZ3rtU10aO3
	y2oi9Jdx6zy4Ev21wUL9a5ZZWfURbNR/zvGZxj45HJ+2dKtuMk8zfiMgGGe2cKkEA2GzMYe5E99
	fRUhKhJZi/AY+J7RVnXYA7EcHKdBNIHgJvXgamWP8LOP3QYS23fGQIaC6LyFdp94rCm9N7dQkcu
	prEkuF6giMfOZNkYDLlLc8GG9iowynqRjXUSbPz1y7Lo0mESIz/O5KK2rFUX8GRllL3baVCIvsM
	1iF4ubcQdF2EEf8A/akz/1BAHjbPbIrqkbkveTwPliv3Wf/7UNHIb3
X-Received: by 2002:a05:600c:3b02:b0:49b:9202:6f80 with SMTP id 5b1f17b1804b1-49cf8220edemr156311035e9.6.1788647166815;
        Sat, 05 Sep 2026 15:26:06 -0700 (PDT)
Received: from [172.16.0.229] ([159.196.52.54])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-14324356931sm23457164c88.4.2026.09.05.15.26.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 05 Sep 2026 15:26:05 -0700 (PDT)
Message-ID: <b943b1be-7913-4b58-8ab0-9f200176699b@suse.com>
Date: Sun, 6 Sep 2026 07:55:59 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/2] btrfs: introduce a new experimental feature,
 RAID56_VSL
To: kreijack@inwind.it, linux-btrfs@vger.kernel.org
References: <cover.1788417288.git.wqu@suse.com>
 <0a2ece5b-0382-4b14-b9e1-1281068b43f3@libero.it>
 <d1f06c6a-ae4e-4881-a199-f17b588def71@suse.com>
 <8480e48a-48c2-4ab2-b65a-96216419bff7@inwind.it>
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
In-Reply-To: <8480e48a-48c2-4ab2-b65a-96216419bff7@inwind.it>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/9/5 23:21, Goffredo Baroncelli 写道:
> On 04/09/2026 23.43, Qu Wenruo wrote:
>>
>>
>> 在 2026/9/5 05:45, Goffredo Baroncelli 写道:
>>> On 03/09/2026 08.49, Qu Wenruo wrote:
>>>> The new feature stands for RAID56 Variable Stripe Length, however the
>>>> VSL part is not implemented yet, thus the whole feature is still hidden
>>>> behind experimental, and there are definitely works left to properly
>>>> split the 1st patch.
>>>>
>>>> But for now, this series can pass most fstests cases.
>>>> The failing ones are all related to mixed block groups, which can 
>>>> not be
>>>> created nor mounted with this new feature.
>>>>
>>>> The roadmap for the full RAID56 VSL implementation is split into two
>>>> parts:
>>>>
>>>> - Introduce a new datasize member
>>>>    This series.
>>>>
>>>>    An fs with data_size 8K and sectorsize 4K will act like a fs with
>>>>    sectorsize 8K.
>>>>    Meaning the minimal write size is 8K for data.
>>>>
>>>>    However the checksum is still calculated based sectorsize, meanwhile
>>>>    we can still recover each corrupted 4K sector inside a 8K data 
>>>> block.
>>>>
>>>>    The idea and implementation is not that complex, we're just reusing
>>>>    the existing bs > ps support to handle it (on 4K page sized 
>>>> systems).
>>>>
>>>>    But the challenge is the details where some part of the code still
>>>>    requires sectorsize (checksum related), meanwhile every other 
>>>> location
>>>>    goes datasize for data.
>>>>
>>>> - Introduce a new RAID56_VSL chunk type
>>>>    It will have the following requirements:
>>>>
>>>>    * Can have up to (datasize / sectorsize) data stripes
>>>>
>>>>    * The number of data stripes are always power of 2
>>>>      This is only for every RAID56_VSL chunk, users can still have
>>>>      whatever number of devices in the fs.
>>>>
>>>>    * The full stripe length is always datasize
>>>>
>>>>    This allows every data write to be full stripe aligned.
>>>>    And for read repair/scrub, we can still locate and recover a single
>>>>    sector inside a RAID56 stripe.
>>>>
>>>>    This is less flex than the traditional RAID56, which has no limit on
>>>>    the number of data stripes, but has the write-hole problem.
>>>
>>>
>>>
>>>>    And will require users to determine the maximum device numbers at 
>>>> mkfs
>>>>    time, without any way to change to another datasize.
>>>
>>> If I understood correctly, the above sentences should be read as:
>>>
>>>      And will require users to determine the datasize at mkfs
>>>      time, without any way to change to another datasize. And 
>>> implicitly the
>>>      *minimum* number of disks which will be >= than datasize / 
>>> sectorsize + nr_parity
>>>      where nr_parity is 1 for raid5 and 2 for raid6...
>>
>> Nope, one can always go as low as 1 data stripe no matter the datasize.
>>
>> So it's maximum, and you're wrong.
> 
> Before you wrote:
>>>>    * The number of data stripes are always power of 2
>>>>      This is only for every RAID56_VSL chunk, users can still have
>>>>      whatever number of devices in the fs.
> 
> So I understood that the number of the devices is a limit of the chunk. 
> I.e. I can have
> a datasize of 64k (=16 devices), but the filesystem can also have (e.g.) 
> 20 devices.
> 
> Each time a datasize is allocated, the most empty 16+nr_parity disks are 
> picked.
> 
> Instead from
> 
>>>>    And will require users to determine the maximum device numbers at 
>>>> mkfs
>>>>    time, without any way to change to another datasize.
> 
> 
> it seems that the limit is per filesystem. This get me confused.
> 
> I want only to understand your design.
> 
>> Nope, one can always go as low as 1 data stripe no matter the datasize.
> 
> Does this mean that when the user sets  datasize = 64k (16 disks), BTRFS 
> allows
>   to create chunk of 16+nr_parity disks, 8+nr_parity, 4+nr_parity, 
> 2+nr_parity, 1+nr_parity ?

Yes.
> 
>>>
>>> So it is more a minim number of disks requirements than a maximum 
>>> device count.
>>>
>>>
>>> Some consideration about the possible wasting of space where the 
>>> extent is less than
>>> the datasize.
>>
>> Impossible, the minimal extent size will be data size.
>>
>> It looks like you didn't even understand that such fs works exactly 
>> like it has a larger block size.
>>
> 
> If I have a file of (e.g.) 48K, and the datasize is (e.g.) 64k, I wasted 
> 16K. This is what I
> told .

That's exactly when you write 3K and the sectorsize is 4K.

This is the common sense for all block filesystems.

> 
> 
>>>
>>> I did some simulation on my filesystem about the disk usage. The most 
>>> interesting
>>> part is that (at least on my filesystem), about 70% the files has a 
>>> size < 4k, and thus
>>> it is inlined.
>>> The other ones with size >64k consume 90% of space, but those quite 
>>> often are way bigger than 64k
>>> so the wasting of space are less than I initially thought.
>>>
>>> However most of the files are the files of my root filesystem 
>>> (without my home), which are "near immutable".
>>> In fact these are not update in place but mostly rewritten from 
>>> scratch by my package manager.
>>>
>>> We need to understand what happens to the files to my home (i.e. 
>>> files which are likely to be rewrote in place).
>>>
>>> As mitigation we could add a RAID1C2/RAID1C1 for extent smaller than 
>>> a specific threshold (i.e. where the space consumed
>>> by RAID1cX arrangement is smaller than a RAID56_VSL).
>>>
>>> About the arrangement of the sector in the chunk, I would suggest the 
>>> following one:
>>
>> There is no change in the data layout in the RAID56_VSL, and I do not 
>> think there should be any change.
>>
>>>
>>>
>>> Current RAID5 layout (for simplicity I left the parity on D3):
>>>
>>>
>>> D  D  D
>>> 1  2  3
>>>
>>> 1  5  P
>>> 2  6  P
>>> 3  7  P
>>> 4  8  P
>>> 9  13 P
>>> 10 14 P
>>> [...]
>>>
>>> RAID56_VSL layout (2 extents with length of 6 sectors and 8 sectors,
>>> parity still in D3)
>>>
>>> D  D  D
>>> 1  2  3
>>>
>>> 1  2  P    |
>>> 3  4  P    |  1st extent
>>> 5  6  P    |
>>>
>>> 7  8  P    |
>>> 9  10 P    |  2nd extent
>>> 11 12 P    |
>>> 13 14 P    |
>>>
>>>
>>> My proposal layout (2 extents with length of 6 sectors and 8 sectors,
>>> parity still in D3)
>>>
>>> D  D  D
>>> 1  2  3
>>>
>>> 1  4  P   |
>>> 2  5  P   |  First extent
>>> 3  6  P   |
>>>
>>> 7  11 P   |
>>> 8  12 P   |  2nd extent
>>> 9  13 P   |
>>> 10 14 P   |
>>>
>>>
>>> Because an extent consumes the entire rows, we can spread the sector
>>> vertically and when we fill a column, we will move to the next one.
>>>
>>>
>>>
>>>
>>>
>>>
>>>>    But the second part is pretty easy to implement.
>>>>
>>>> As the digest shows, the biggest problem is the first patch, which is
>>>> touching over 200 sectorsize users, and is definitely the source of all
>>>> bugs I hit and fixed so far.
>>>>
>>>> If anyone has a better way to address the rename, I'm all ears.
>>>>
>>>> Qu Wenruo (2):
>>>>    btrfs: split sectorsize into datasize and sectorsize
>>>>    btrfs: implement a new incompat feature, raid56_vsl
>>>>
>>>>   fs/btrfs/accessors.h                   |   2 +
>>>>   fs/btrfs/bio.c                         |  16 +++-
>>>>   fs/btrfs/block-group.c                 |   2 +-
>>>>   fs/btrfs/btrfs_inode.h                 |  10 +++
>>>>   fs/btrfs/compression.c                 |  12 +--
>>>>   fs/btrfs/defrag.c                      |  14 +--
>>>>   fs/btrfs/delalloc-space.c              |  22 ++---
>>>>   fs/btrfs/direct-io.c                   |   6 +-
>>>>   fs/btrfs/disk-io.c                     |  43 +++++++---
>>>>   fs/btrfs/extent-io-tree.c              |   2 +-
>>>>   fs/btrfs/extent-tree.c                 |   4 +-
>>>>   fs/btrfs/extent_io.c                   |  62 +++++++-------
>>>>   fs/btrfs/extent_map.c                  |   2 +-
>>>>   fs/btrfs/fiemap.c                      |   2 +-
>>>>   fs/btrfs/file-item.c                   |  22 +++--
>>>>   fs/btrfs/file.c                        |  72 ++++++++--------
>>>>   fs/btrfs/fs.h                          |  27 ++++--
>>>>   fs/btrfs/inode-item.c                  |   6 +-
>>>>   fs/btrfs/inode.c                       | 113 ++++++++++++ 
>>>> +------------
>>>>   fs/btrfs/ioctl.c                       |  12 +--
>>>>   fs/btrfs/lzo.c                         |  14 +--
>>>>   fs/btrfs/reflink.c                     |  16 ++--
>>>>   fs/btrfs/relocation.c                  |  16 ++--
>>>>   fs/btrfs/send.c                        |   4 +-
>>>>   fs/btrfs/subpage.c                     |  96 +++++++++++++++------
>>>>   fs/btrfs/subpage.h                     |   2 +-
>>>>   fs/btrfs/super.c                       |   8 +-
>>>>   fs/btrfs/sysfs.c                       |   8 +-
>>>>   fs/btrfs/tests/btrfs-tests.c           |   6 +-
>>>>   fs/btrfs/tests/free-space-tree-tests.c |   2 +-
>>>>   fs/btrfs/tree-checker.c                |   2 +-
>>>>   fs/btrfs/tree-log.c                    |   6 +-
>>>>   fs/btrfs/volumes.c                     |   2 +-
>>>>   fs/btrfs/zlib.c                        |   6 +-
>>>>   fs/btrfs/zoned.c                       |   4 +-
>>>>   fs/btrfs/zstd.c                        |   8 +-
>>>>   include/uapi/linux/btrfs.h             |  22 +++++
>>>>   include/uapi/linux/btrfs_tree.h        |   3 +-
>>>>   38 files changed, 403 insertions(+), 273 deletions(-)
>>>>
>>>
>>>
>>
> 
> 

