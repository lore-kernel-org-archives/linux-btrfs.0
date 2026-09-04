Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 311F73955FE
	for <linux-btrfs@vger.kernel.org>; Fri,  4 Sep 2026 21:44:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788558247; cv=none; b=Oi+FlzvLyl4XvIGX4+Zf128qn1QUZsFNd+jLxgW+0u0dk9U/377RU0sFW82nfFubWrJzy4H8lbmG0YOKdpLH6fKkYfd6pMH6pcY0H4pvSABDxVK8bF76UxdZ5i12fFSwhdr2Mg+HiHt0NeS19X1gF8LtmmBo9DaagsN0CXbPNYM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788558247; c=relaxed/simple;
	bh=BoM4bXhEZD4VG9x8j1arDMYCS6QodvhkEH18V/Aika4=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=iaQ95WcLJfT93A0T5ZeK5vtRFTRZdTtikM4FSsn6oBKSdboc1X8mG8u/zjMpwga2180cJnD5YykDJV9pcMBD22fAMiIgDlFzCtZc4WUaYKJ2cAqpjZB1CLBon6fvp8IAX3x7nh2ODCVM+1PfbDgzjL5sKgzd/nCEestVnsxCCZ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=ZKT8fsuI; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="ZKT8fsuI"
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-49b0d8bc2aaso18136045e9.0
        for <linux-btrfs@vger.kernel.org>; Fri, 04 Sep 2026 14:44:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1788558243; x=1789163043; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=mqi2e4IXCQY73YXcqWcY7TLHn2FuSXiHj43c82vW7Bw=;
        b=ZKT8fsuIIoS+5P1/wpqWIuv9KYUdZHR93iyoeODckUQfc60vUC64Zk6bQkDUggaXzc
         a4amZdXQSTcUvuzAI+uldaSBtrj41VWEYWESgDkA/v65Fq+dLL+BfV9pfA+ti23bUs/1
         bIRLUyAa9Uj+Bk3Svqzci+JC8isGnp8zBfIQ+6zkN74dADRDmNpiTKCfMfjOq9dG68JD
         CMRaB7m4ElkgEvj9nOrfkarCqg+8/5smwNU66HjIfsIXrXTIS6OuNIju35JLmeUNeEXY
         FcNNHR6Xu4bIqg3NmADoyP8iOVcDKQXs4pjMwHOymscGSYJ3zZtdGQw5hoJDbX/Io4we
         Q2dA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788558243; x=1789163043;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=mqi2e4IXCQY73YXcqWcY7TLHn2FuSXiHj43c82vW7Bw=;
        b=qR90TDLXqwVBr20XzmKv7JzquPgzIC0N3zBO7v7sUFxKZdefyG03YPnmvq/o6oo3em
         Oj0OR18rczQpV/EVo1F5Whyea0SIf3cdxEy3mgx8QTVtN9n0GJPHVyRgdPSyOLB16P0D
         VOguDSyCShZXlf1qDhCgZtdLNAXboV9NVOBtqANMP1I8iIzA3WIabeIpUNK80CGQwKTY
         msunG89Js+dUiyyV/K5H+wI2Yzk39elBDdrxSbu9ZTwhwmVEZjj2G+Kt42EoRoZ1EDJw
         uWA+TypVIgW99b6ZRhDxGkl5NAnETtgENcl2anwIA3qnyXalW+7p953HfbvAvGP3MWsO
         HcVw==
X-Forwarded-Encrypted: i=1; AKwUvBxToCF177Tum+Sxy03gB+kOFE0dpDU5x8Q4i5NYCM/fGg/q0mVC0UMW1hbBjRKRZcVFOY2rD084JzUZVw==@vger.kernel.org
X-Gm-Message-State: AFuF++mFKPixXGaxkfyk5Ah0MCjkknydI/uWQhB9HNWZ/Hb5h4ve38bZ
	j4Kfzqlxc09QvFFq5NJqDWtZpiMEIcO5M2boeCWvzs5g483yJW1bZCg72d10jswA7vW1+MomOcJ
	AsrL3/kkmJA==
X-Gm-Gg: AYBFou0O66SNZYHKwliehfKzrA/qiKhdku/EH7OWoRN4DQwF4Am2+eCHg1jJ4tS39+g
	GHZeISwLLELBwvT8tQLM61EKag3oybaYNFUunEbFYo+cWTjrsv13bhbsyOA2HoWkwO/0UeZDsEN
	AKWO41hr+9dI5I03lbLZCBLWlwAJyIK0UWmsrgLXOXDErbZqfueHEbtoisYkCAzM5lpYhZ1T/E+
	mTmG/+wGU9c9fqJ87f41Vt74FprASRWInwpzGb0MgQD0o3CcODSGYfvZ/sphm6y30qD8CyRfOvl
	gouwUu6ZtY3WbJDbPk+BTKLQIyArlQb2Iz/TDLkzXminUaTr6/6IwuVx9Cyx2j+O2AQ4ijw85Vd
	NxYanuz5BW2/Tc2UCLyeu0ZNAwCTf3KrQvU5FYDdm4Jmc70kreOPoCxkE78KRm2P5GeUDg+9lRO
	kPcxPiMnd+SVJe9CQS+FAaxX6vX0q/0RjtVHtnaZ1VxUOh2AW6aKMq
X-Received: by 2002:a05:600c:620e:b0:49c:fc6c:be19 with SMTP id 5b1f17b1804b1-49cff2078b8mr46230755e9.31.1788558243183;
        Fri, 04 Sep 2026 14:44:03 -0700 (PDT)
Received: from [172.16.0.229] ([159.196.52.54])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-86278118b7dsm615503b3a.28.2026.09.04.14.43.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 04 Sep 2026 14:44:02 -0700 (PDT)
Message-ID: <d1f06c6a-ae4e-4881-a199-f17b588def71@suse.com>
Date: Sat, 5 Sep 2026 07:13:55 +0930
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
In-Reply-To: <0a2ece5b-0382-4b14-b9e1-1281068b43f3@libero.it>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/9/5 05:45, Goffredo Baroncelli 写道:
> On 03/09/2026 08.49, Qu Wenruo wrote:
>> The new feature stands for RAID56 Variable Stripe Length, however the
>> VSL part is not implemented yet, thus the whole feature is still hidden
>> behind experimental, and there are definitely works left to properly
>> split the 1st patch.
>>
>> But for now, this series can pass most fstests cases.
>> The failing ones are all related to mixed block groups, which can not be
>> created nor mounted with this new feature.
>>
>> The roadmap for the full RAID56 VSL implementation is split into two
>> parts:
>>
>> - Introduce a new datasize member
>>    This series.
>>
>>    An fs with data_size 8K and sectorsize 4K will act like a fs with
>>    sectorsize 8K.
>>    Meaning the minimal write size is 8K for data.
>>
>>    However the checksum is still calculated based sectorsize, meanwhile
>>    we can still recover each corrupted 4K sector inside a 8K data block.
>>
>>    The idea and implementation is not that complex, we're just reusing
>>    the existing bs > ps support to handle it (on 4K page sized systems).
>>
>>    But the challenge is the details where some part of the code still
>>    requires sectorsize (checksum related), meanwhile every other location
>>    goes datasize for data.
>>
>> - Introduce a new RAID56_VSL chunk type
>>    It will have the following requirements:
>>
>>    * Can have up to (datasize / sectorsize) data stripes
>>
>>    * The number of data stripes are always power of 2
>>      This is only for every RAID56_VSL chunk, users can still have
>>      whatever number of devices in the fs.
>>
>>    * The full stripe length is always datasize
>>
>>    This allows every data write to be full stripe aligned.
>>    And for read repair/scrub, we can still locate and recover a single
>>    sector inside a RAID56 stripe.
>>
>>    This is less flex than the traditional RAID56, which has no limit on
>>    the number of data stripes, but has the write-hole problem.
> 
> 
> 
>>    And will require users to determine the maximum device numbers at mkfs
>>    time, without any way to change to another datasize.
> 
> If I understood correctly, the above sentences should be read as:
> 
>      And will require users to determine the datasize at mkfs
>      time, without any way to change to another datasize. And implicitly 
> the
>      *minimum* number of disks which will be >= than datasize / 
> sectorsize + nr_parity
>      where nr_parity is 1 for raid5 and 2 for raid6...

Nope, one can always go as low as 1 data stripe no matter the datasize.

So it's maximum, and you're wrong.

> 
> So it is more a minim number of disks requirements than a maximum device 
> count.
> 
> 
> Some consideration about the possible wasting of space where the extent 
> is less than
> the datasize.

Impossible, the minimal extent size will be data size.

It looks like you didn't even understand that such fs works exactly like 
it has a larger block size.

> 
> I did some simulation on my filesystem about the disk usage. The most 
> interesting
> part is that (at least on my filesystem), about 70% the files has a size 
> < 4k, and thus
> it is inlined.
> The other ones with size >64k consume 90% of space, but those quite 
> often are way bigger than 64k
> so the wasting of space are less than I initially thought.
> 
> However most of the files are the files of my root filesystem (without 
> my home), which are "near immutable".
> In fact these are not update in place but mostly rewritten from scratch 
> by my package manager.
> 
> We need to understand what happens to the files to my home (i.e. files 
> which are likely to be rewrote in place).
> 
> As mitigation we could add a RAID1C2/RAID1C1 for extent smaller than a 
> specific threshold (i.e. where the space consumed
> by RAID1cX arrangement is smaller than a RAID56_VSL).
> 
> About the arrangement of the sector in the chunk, I would suggest the 
> following one:

There is no change in the data layout in the RAID56_VSL, and I do not 
think there should be any change.

> 
> 
> Current RAID5 layout (for simplicity I left the parity on D3):
> 
> 
> D  D  D
> 1  2  3
> 
> 1  5  P
> 2  6  P
> 3  7  P
> 4  8  P
> 9  13 P
> 10 14 P
> [...]
> 
> RAID56_VSL layout (2 extents with length of 6 sectors and 8 sectors,
> parity still in D3)
> 
> D  D  D
> 1  2  3
> 
> 1  2  P    |
> 3  4  P    |  1st extent
> 5  6  P    |
> 
> 7  8  P    |
> 9  10 P    |  2nd extent
> 11 12 P    |
> 13 14 P    |
> 
> 
> My proposal layout (2 extents with length of 6 sectors and 8 sectors,
> parity still in D3)
> 
> D  D  D
> 1  2  3
> 
> 1  4  P   |
> 2  5  P   |  First extent
> 3  6  P   |
> 
> 7  11 P   |
> 8  12 P   |  2nd extent
> 9  13 P   |
> 10 14 P   |
> 
> 
> Because an extent consumes the entire rows, we can spread the sector
> vertically and when we fill a column, we will move to the next one.
> 
> 
> 
> 
> 
> 
>>    But the second part is pretty easy to implement.
>>
>> As the digest shows, the biggest problem is the first patch, which is
>> touching over 200 sectorsize users, and is definitely the source of all
>> bugs I hit and fixed so far.
>>
>> If anyone has a better way to address the rename, I'm all ears.
>>
>> Qu Wenruo (2):
>>    btrfs: split sectorsize into datasize and sectorsize
>>    btrfs: implement a new incompat feature, raid56_vsl
>>
>>   fs/btrfs/accessors.h                   |   2 +
>>   fs/btrfs/bio.c                         |  16 +++-
>>   fs/btrfs/block-group.c                 |   2 +-
>>   fs/btrfs/btrfs_inode.h                 |  10 +++
>>   fs/btrfs/compression.c                 |  12 +--
>>   fs/btrfs/defrag.c                      |  14 +--
>>   fs/btrfs/delalloc-space.c              |  22 ++---
>>   fs/btrfs/direct-io.c                   |   6 +-
>>   fs/btrfs/disk-io.c                     |  43 +++++++---
>>   fs/btrfs/extent-io-tree.c              |   2 +-
>>   fs/btrfs/extent-tree.c                 |   4 +-
>>   fs/btrfs/extent_io.c                   |  62 +++++++-------
>>   fs/btrfs/extent_map.c                  |   2 +-
>>   fs/btrfs/fiemap.c                      |   2 +-
>>   fs/btrfs/file-item.c                   |  22 +++--
>>   fs/btrfs/file.c                        |  72 ++++++++--------
>>   fs/btrfs/fs.h                          |  27 ++++--
>>   fs/btrfs/inode-item.c                  |   6 +-
>>   fs/btrfs/inode.c                       | 113 +++++++++++++------------
>>   fs/btrfs/ioctl.c                       |  12 +--
>>   fs/btrfs/lzo.c                         |  14 +--
>>   fs/btrfs/reflink.c                     |  16 ++--
>>   fs/btrfs/relocation.c                  |  16 ++--
>>   fs/btrfs/send.c                        |   4 +-
>>   fs/btrfs/subpage.c                     |  96 +++++++++++++++------
>>   fs/btrfs/subpage.h                     |   2 +-
>>   fs/btrfs/super.c                       |   8 +-
>>   fs/btrfs/sysfs.c                       |   8 +-
>>   fs/btrfs/tests/btrfs-tests.c           |   6 +-
>>   fs/btrfs/tests/free-space-tree-tests.c |   2 +-
>>   fs/btrfs/tree-checker.c                |   2 +-
>>   fs/btrfs/tree-log.c                    |   6 +-
>>   fs/btrfs/volumes.c                     |   2 +-
>>   fs/btrfs/zlib.c                        |   6 +-
>>   fs/btrfs/zoned.c                       |   4 +-
>>   fs/btrfs/zstd.c                        |   8 +-
>>   include/uapi/linux/btrfs.h             |  22 +++++
>>   include/uapi/linux/btrfs_tree.h        |   3 +-
>>   38 files changed, 403 insertions(+), 273 deletions(-)
>>
> 
> 

