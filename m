Received: from libero.it (smtp-16.italiaonline.it [213.209.10.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E775332EDE
	for <linux-btrfs@vger.kernel.org>; Sat,  5 Sep 2026 13:54:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.209.10.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788616469; cv=none; b=qx8xY9ewmbvS+zIwRkI8gPrcDj4xazNfCx4aTbECilg5Gx6pF56jIeVsYzjH9TEGOu7bxD0U24zGypwIdWbVKIeRs63ULYMsoqz5Occotw7rbyjPI4HtWeRT4JcVyDddCwUEIU3VjCvF1uwDNJwcUINsMJAgzgJe2d4o0mZ2E04=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788616469; c=relaxed/simple;
	bh=lyrrjhKf43UZZu1P8Qd1T4tuDRK59MXFtD7FCSubdno=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=SDDH7nl/kLmnGxxRg8cx80z1WBDJwko8oG47esjRASEgixqC6Fn3k3udgoozkpJstacoj2AdJAAdyc4RK4NsurIlJ3rK54TclRJk2YTI0N41hxqJFQYrCbKbm7VUP3NzbOpHExp6MdegLqACv5nGqX676iUtfpsiJvf4aZpKAAE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=inwind.it; spf=pass smtp.mailfrom=inwind.it; dkim=pass (2048-bit key) header.d=inwind.it header.i=@inwind.it header.b=JlcxEvIL; arc=none smtp.client-ip=213.209.10.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=inwind.it
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=inwind.it
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=inwind.it header.i=@inwind.it header.b="JlcxEvIL"
Received: from [192.168.1.27] ([84.220.171.3])
	by smtp-16.iol.local with ESMTPSA
	id 2qo5xdYhxs82S2qo5xEzUi; Sat, 05 Sep 2026 15:51:46 +0200
x-libjamoibt: 1601
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=inwind.it; s=s2014;
	t=1788616306; bh=D8YdKko288XPhbNvfB148HJ4POxl5pLztBzN0Vv/6lM=;
	h=From;
	b=JlcxEvIL0qM8kM3nJw6txbDbDCLCScc2CcHMvyLN2U/tm7GQJYncAqeJRZqn07JhD
	 54RvQDyWajZSMgff0YvqbngDCwAViSNgwZMXdDPzKM65G3/SwEdB5axxKNZXZZFy5x
	 /m+UuGVEqULu8tyvb0oGobv1mmT0FOTf577FrdArkiih4kcFMBX/3NT/pVnyCFHfYU
	 gYJQhb1t+EnToiIGHh5nbzVJUCvcVmrmYgym86zlQVZENxMAY0NcWK014kf37X5Kbm
	 S/nLfo02QIwIpipocPoExZ3uY3YYR2wRuNBdxRZqqYwi9SdyG0yI+GrZpNRbBynlKk
	 gpxyK9cisaMyg==
X-CNFS-Analysis: v=2.4 cv=IOwyzAvG c=1 sm=1 tr=0 ts=6a9c1e72 cx=a_exe
 a=hciw9o01/L1eIHAASTHaSw==:117 a=hciw9o01/L1eIHAASTHaSw==:17
 a=IkcTkHD0fZMA:10 a=kKpmWObzMUWfh18YnpQA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
Message-ID: <8480e48a-48c2-4ab2-b65a-96216419bff7@inwind.it>
Date: Sat, 5 Sep 2026 15:51:45 +0200
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: kreijack@inwind.it
Subject: Re: [PATCH 0/2] btrfs: introduce a new experimental feature,
 RAID56_VSL
To: Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
References: <cover.1788417288.git.wqu@suse.com>
 <0a2ece5b-0382-4b14-b9e1-1281068b43f3@libero.it>
 <d1f06c6a-ae4e-4881-a199-f17b588def71@suse.com>
Content-Language: en-US
From: Goffredo Baroncelli <kreijack@inwind.it>
In-Reply-To: <d1f06c6a-ae4e-4881-a199-f17b588def71@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CMAE-Envelope: MS4xfA68Jeg7s+dQGnL0SijjmKIW5gv2zrXtn6EDsfa6BM2VWt3oWRcI6NRLMr/QjvQKFfNfpUiNRDrEeYamPuegpnP5v7c/ZVN74RHuM190RZ8R6o1luVrr
 qisC87A9qUskC+np1MscKeXa+bnJxGMx1Uuq4BtrIvnFkGtH6wld+9VGear4tNzZ6jDIX8K+cc+yUEQBg9ex4b7PkjhxJ3qM2QundvFrbaocrJHFEWuJtpJe

On 04/09/2026 23.43, Qu Wenruo wrote:
> 
> 
> 在 2026/9/5 05:45, Goffredo Baroncelli 写道:
>> On 03/09/2026 08.49, Qu Wenruo wrote:
>>> The new feature stands for RAID56 Variable Stripe Length, however the
>>> VSL part is not implemented yet, thus the whole feature is still hidden
>>> behind experimental, and there are definitely works left to properly
>>> split the 1st patch.
>>>
>>> But for now, this series can pass most fstests cases.
>>> The failing ones are all related to mixed block groups, which can not be
>>> created nor mounted with this new feature.
>>>
>>> The roadmap for the full RAID56 VSL implementation is split into two
>>> parts:
>>>
>>> - Introduce a new datasize member
>>>    This series.
>>>
>>>    An fs with data_size 8K and sectorsize 4K will act like a fs with
>>>    sectorsize 8K.
>>>    Meaning the minimal write size is 8K for data.
>>>
>>>    However the checksum is still calculated based sectorsize, meanwhile
>>>    we can still recover each corrupted 4K sector inside a 8K data block.
>>>
>>>    The idea and implementation is not that complex, we're just reusing
>>>    the existing bs > ps support to handle it (on 4K page sized systems).
>>>
>>>    But the challenge is the details where some part of the code still
>>>    requires sectorsize (checksum related), meanwhile every other location
>>>    goes datasize for data.
>>>
>>> - Introduce a new RAID56_VSL chunk type
>>>    It will have the following requirements:
>>>
>>>    * Can have up to (datasize / sectorsize) data stripes
>>>
>>>    * The number of data stripes are always power of 2
>>>      This is only for every RAID56_VSL chunk, users can still have
>>>      whatever number of devices in the fs.
>>>
>>>    * The full stripe length is always datasize
>>>
>>>    This allows every data write to be full stripe aligned.
>>>    And for read repair/scrub, we can still locate and recover a single
>>>    sector inside a RAID56 stripe.
>>>
>>>    This is less flex than the traditional RAID56, which has no limit on
>>>    the number of data stripes, but has the write-hole problem.
>>
>>
>>
>>>    And will require users to determine the maximum device numbers at mkfs
>>>    time, without any way to change to another datasize.
>>
>> If I understood correctly, the above sentences should be read as:
>>
>>      And will require users to determine the datasize at mkfs
>>      time, without any way to change to another datasize. And implicitly the
>>      *minimum* number of disks which will be >= than datasize / sectorsize + nr_parity
>>      where nr_parity is 1 for raid5 and 2 for raid6...
> 
> Nope, one can always go as low as 1 data stripe no matter the datasize.
> 
> So it's maximum, and you're wrong.

Before you wrote:
>>>    * The number of data stripes are always power of 2
>>>      This is only for every RAID56_VSL chunk, users can still have
>>>      whatever number of devices in the fs.

So I understood that the number of the devices is a limit of the chunk. I.e. I can have
a datasize of 64k (=16 devices), but the filesystem can also have (e.g.) 20 devices.

Each time a datasize is allocated, the most empty 16+nr_parity disks are picked.

Instead from

>>>    And will require users to determine the maximum device numbers at mkfs
>>>    time, without any way to change to another datasize.


it seems that the limit is per filesystem. This get me confused.

I want only to understand your design.

> Nope, one can always go as low as 1 data stripe no matter the datasize.

Does this mean that when the user sets  datasize = 64k (16 disks), BTRFS allows
  to create chunk of 16+nr_parity disks, 8+nr_parity, 4+nr_parity, 2+nr_parity, 1+nr_parity ?

>>
>> So it is more a minim number of disks requirements than a maximum device count.
>>
>>
>> Some consideration about the possible wasting of space where the extent is less than
>> the datasize.
> 
> Impossible, the minimal extent size will be data size.
> 
> It looks like you didn't even understand that such fs works exactly like it has a larger block size.
> 

If I have a file of (e.g.) 48K, and the datasize is (e.g.) 64k, I wasted 16K. This is what I
told .


>>
>> I did some simulation on my filesystem about the disk usage. The most interesting
>> part is that (at least on my filesystem), about 70% the files has a size < 4k, and thus
>> it is inlined.
>> The other ones with size >64k consume 90% of space, but those quite often are way bigger than 64k
>> so the wasting of space are less than I initially thought.
>>
>> However most of the files are the files of my root filesystem (without my home), which are "near immutable".
>> In fact these are not update in place but mostly rewritten from scratch by my package manager.
>>
>> We need to understand what happens to the files to my home (i.e. files which are likely to be rewrote in place).
>>
>> As mitigation we could add a RAID1C2/RAID1C1 for extent smaller than a specific threshold (i.e. where the space consumed
>> by RAID1cX arrangement is smaller than a RAID56_VSL).
>>
>> About the arrangement of the sector in the chunk, I would suggest the following one:
> 
> There is no change in the data layout in the RAID56_VSL, and I do not think there should be any change.
> 
>>
>>
>> Current RAID5 layout (for simplicity I left the parity on D3):
>>
>>
>> D  D  D
>> 1  2  3
>>
>> 1  5  P
>> 2  6  P
>> 3  7  P
>> 4  8  P
>> 9  13 P
>> 10 14 P
>> [...]
>>
>> RAID56_VSL layout (2 extents with length of 6 sectors and 8 sectors,
>> parity still in D3)
>>
>> D  D  D
>> 1  2  3
>>
>> 1  2  P    |
>> 3  4  P    |  1st extent
>> 5  6  P    |
>>
>> 7  8  P    |
>> 9  10 P    |  2nd extent
>> 11 12 P    |
>> 13 14 P    |
>>
>>
>> My proposal layout (2 extents with length of 6 sectors and 8 sectors,
>> parity still in D3)
>>
>> D  D  D
>> 1  2  3
>>
>> 1  4  P   |
>> 2  5  P   |  First extent
>> 3  6  P   |
>>
>> 7  11 P   |
>> 8  12 P   |  2nd extent
>> 9  13 P   |
>> 10 14 P   |
>>
>>
>> Because an extent consumes the entire rows, we can spread the sector
>> vertically and when we fill a column, we will move to the next one.
>>
>>
>>
>>
>>
>>
>>>    But the second part is pretty easy to implement.
>>>
>>> As the digest shows, the biggest problem is the first patch, which is
>>> touching over 200 sectorsize users, and is definitely the source of all
>>> bugs I hit and fixed so far.
>>>
>>> If anyone has a better way to address the rename, I'm all ears.
>>>
>>> Qu Wenruo (2):
>>>    btrfs: split sectorsize into datasize and sectorsize
>>>    btrfs: implement a new incompat feature, raid56_vsl
>>>
>>>   fs/btrfs/accessors.h                   |   2 +
>>>   fs/btrfs/bio.c                         |  16 +++-
>>>   fs/btrfs/block-group.c                 |   2 +-
>>>   fs/btrfs/btrfs_inode.h                 |  10 +++
>>>   fs/btrfs/compression.c                 |  12 +--
>>>   fs/btrfs/defrag.c                      |  14 +--
>>>   fs/btrfs/delalloc-space.c              |  22 ++---
>>>   fs/btrfs/direct-io.c                   |   6 +-
>>>   fs/btrfs/disk-io.c                     |  43 +++++++---
>>>   fs/btrfs/extent-io-tree.c              |   2 +-
>>>   fs/btrfs/extent-tree.c                 |   4 +-
>>>   fs/btrfs/extent_io.c                   |  62 +++++++-------
>>>   fs/btrfs/extent_map.c                  |   2 +-
>>>   fs/btrfs/fiemap.c                      |   2 +-
>>>   fs/btrfs/file-item.c                   |  22 +++--
>>>   fs/btrfs/file.c                        |  72 ++++++++--------
>>>   fs/btrfs/fs.h                          |  27 ++++--
>>>   fs/btrfs/inode-item.c                  |   6 +-
>>>   fs/btrfs/inode.c                       | 113 +++++++++++++------------
>>>   fs/btrfs/ioctl.c                       |  12 +--
>>>   fs/btrfs/lzo.c                         |  14 +--
>>>   fs/btrfs/reflink.c                     |  16 ++--
>>>   fs/btrfs/relocation.c                  |  16 ++--
>>>   fs/btrfs/send.c                        |   4 +-
>>>   fs/btrfs/subpage.c                     |  96 +++++++++++++++------
>>>   fs/btrfs/subpage.h                     |   2 +-
>>>   fs/btrfs/super.c                       |   8 +-
>>>   fs/btrfs/sysfs.c                       |   8 +-
>>>   fs/btrfs/tests/btrfs-tests.c           |   6 +-
>>>   fs/btrfs/tests/free-space-tree-tests.c |   2 +-
>>>   fs/btrfs/tree-checker.c                |   2 +-
>>>   fs/btrfs/tree-log.c                    |   6 +-
>>>   fs/btrfs/volumes.c                     |   2 +-
>>>   fs/btrfs/zlib.c                        |   6 +-
>>>   fs/btrfs/zoned.c                       |   4 +-
>>>   fs/btrfs/zstd.c                        |   8 +-
>>>   include/uapi/linux/btrfs.h             |  22 +++++
>>>   include/uapi/linux/btrfs_tree.h        |   3 +-
>>>   38 files changed, 403 insertions(+), 273 deletions(-)
>>>
>>
>>
> 


-- 
gpg @keyserver.linux.it: Goffredo Baroncelli <kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
