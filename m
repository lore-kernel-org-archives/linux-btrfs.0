Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:40103 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750760AbaLMKYv (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 13 Dec 2014 05:24:51 -0500
Message-ID: <548C133B.3020905@cn.fujitsu.com>
Date: Sat, 13 Dec 2014 18:21:47 +0800
From: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
MIME-Version: 1.0
To: Duncan <1i5t5.duncan@cox.net>, <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH v2 1/3] Btrfs: get more accurate output in df command.
References: <36be817396956bffe981a69ea0b8796c44153fa5.1418203063.git.yangds.fnst@cn.fujitsu.com>	<548B2D34.9060509@inwind.it> <pan$15017$735d4dc1$40043b93$f0365d23@cox.net>
In-Reply-To: <pan$15017$735d4dc1$40043b93$f0365d23@cox.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 12/13/2014 08:50 AM, Duncan wrote:
> Goffredo Baroncelli posted on Fri, 12 Dec 2014 19:00:20 +0100 as
> excerpted:
>
>> $ sudo ./btrfs fi df /mnt/btrfs1/
>> Data, RAID1: total=1.00GiB, used=512.00KiB
>> Data, single: total=8.00MiB, used=0.00B
>> System, RAID1: total=8.00MiB, used=16.00KiB
>> System, single: total=4.00MiB, used=0.00B
>> Metadata, RAID1: total=1.00GiB, used=112.00KiB
>> Metadata, single: total=8.00MiB, used=0.00B
>> GlobalReserve, single: total=16.00MiB, used=0.00B
>>
>> In this case the filesystem is empty (it was a new filesystem !).
>> However a 1G metadata chunk was already allocated. This is the reasons
>> why the free space is only 4Gb.
> Trivial(?) correction.
>
> Metadata chunks are quarter-gig, not 1 gig.  So that's 4 quarter-gig
> metadata chunks allocated, not a (one/single) 1-gig metadata chunk.

Sorry but from my reading of the code, I have to say that in this case 
it is 1G.

Maybe I should be wrong, I would say, yes, the chunk_size for btrfs which is
smaller than 50G is 256M by default. But in mkfs, we alloc 1G for the first
metadata chunk.
>
>> On my system the ratio metadata/data is 234MB/8.82GB = ~3%, so ignoring
>> the metadata chunk from the free space may not be a big problem.
> Presumably your use-case is primarily reasonably large files; too large
> for their data to be tucked directly into metadata instead of allocating
> an extent from a data chunk.
>
> That's not always going to be the case.  And given the multi-device
> default allocation of raid1 metadata, single data, files small enough to
> fit into metadata have a default size effect double their actual size!
> (Tho it can be noted that given btrfs' 4 KiB standard block size, without
> metadata packing there'd still be an outsized effect for files smaller
> than half that, 2 KiB or under, but there it'd be in data chunks, not
> metadata.)
>

