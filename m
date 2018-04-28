Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from glass.birch.relay.mailchannels.net ([23.83.209.70]:23946 "EHLO
        glass.birch.relay.mailchannels.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752688AbeD1Hai (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 28 Apr 2018 03:30:38 -0400
Subject: Re: NVMe SSD + compression - benchmarking
To: Qu Wenruo <quwenruo.btrfs@gmx.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <5be6d7f3-c905-dc7b-56e0-4c4be60ea952@swiftspirit.co.za>
 <e80e34ff-3d1c-99da-e622-4576c2dc8329@gmx.com>
From: Brendan Hide <brendan@swiftspirit.co.za>
Message-ID: <6adcb5da-16af-5453-383b-f289e9857506@swiftspirit.co.za>
Date: Sat, 28 Apr 2018 09:30:30 +0200
MIME-Version: 1.0
In-Reply-To: <e80e34ff-3d1c-99da-e622-4576c2dc8329@gmx.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On 04/28/2018 04:05 AM, Qu Wenruo wrote:
> 
> 
> On 2018年04月28日 01:41, Brendan Hide wrote:
>> Hey, all
>>
>> I'm following up on the queries I had last week since I have installed
>> the NVMe SSD into the PCI-e adapter. I'm having difficulty knowing
>> whether or not I'm doing these benchmarks correctly.
>>
>> As a first test, I put together a 4.7GB .tar containing mostly
>> duplicated copies of the kernel source code (rather compressible).
>> Writing this to the SSD I was seeing repeatable numbers - but noted that
>> the new (supposedly faster) zstd compression is noticeably slower than
>> all other methods. Perhaps this is partly due to lack of
>> multi-threading? No matter, I did also notice a supposedly impossible
>> stat when there is no compression, in that it seems to be faster than
>> the PCI-E 2.0 bus theoretically can deliver:
> 
> I'd say the test method is more like real world usage other than benchmark.
> Moreover, the kernel source copying is not that good for compression, as
> mostly of the files are smaller than 128K, which means they can't take
> much advantage of multi thread split based on 128K.
> 
> And kernel source is consistent of multiple small files, and btrfs is
> really slow for metadata heavy workload.
> 
> I'd recommend to start with simpler workload, then go step by step
> towards more complex workload.
> 
> Large file sequence write with large block size would be a nice start
> point, as it could take all advantage of multithread compression.

Thanks, Qu

I did also test the folder tree where I realised it is intense / far 
from a regular use-case. It gives far slower results with zlib being the 
slowest. The source's average file size is near 13KiB. However, in this 
test where I gave some results below, the .tar is a large (4.7GB) 
singular file - I'm not unpacking it at all.

Average results from source tree:
compression type / write speed / read speed
no / 0.29 GBps / 0.20 GBps
lzo / 0.21 GBps / 0.17 GBps
zstd / 0.13 GBps / 0.14 GBps
zlib / 0.06 GBps / 0.10 GBps

Average results from .tar:
compression type / write speed / read speed
no / 1.42 GBps / 2.79 GBps
lzo / 1.17 GBps / 2.04 GBps
zstd / 0.75 GBps / 1.97 GBps
zlib / 1.24 GBps / 2.07 GBps

> Another advice here is, if you really want a super fast storage, and
> there is plenty memory, brd module will be your best friend.
> And for modern mainstream hardware, brd could provide performance over
> 1GiB/s:
> $ sudo modprobe brd rd_nr=1 rd_size=2097152
> $ LANG=C dd if=/dev/zero  bs=1M of=/dev/ram0  count=2048
> 2048+0 records in
> 2048+0 records out
> 2147483648 bytes (2.1 GB, 2.0 GiB) copied, 1.45593 s, 1.5 GB/s

My real worry is that I'm currently reading at 2.79GB/s (see result 
above and below) without compression when my hardware *should* limit it 
to 2.0GB/s. This tells me either `sync` is not working or my benchmark 
method is flawed.

> Thanks,
> Qu
> 
>>
>> compression type / write speed / read speed (in GBps)
>> zlib / 1.24 / 2.07
>> lzo / 1.17 / 2.04
>> zstd / 0.75 / 1.97
>> no / 1.42 / 2.79
>>
>> The SSD is PCI-E 3.0 4-lane capable and is connected to a PCI-E 2.0
>> 16-lane slot. lspci -vv confirms it is using 4 lanes. This means it's
>> peak throughput *should* be 2.0 GBps - but above you can see the average
>> read benchmark is 2.79GBps. :-/
>>
>> The crude timing script I've put together does the following:
>> - Format the SSD anew with btrfs and no custom settings
>> - wait 180 seconds for possible hardware TRIM to settle (possibly
>> overkill since the SSD is new)
>> - Mount the fs using all defaults except for compression, which could be
>> of zlib, lzo, zstd, or no
>> - sync
>> - Drop all caches
>> - Time the following
>>   - Copy the file to the test fs (source is a ramdisk)
>>   - sync
>> - Drop all caches
>> - Time the following
>>   - Copy back from the test fs to ramdisk
>>   - sync
>> - unmount
>>
>> I can see how, with compression, it *can* be faster than 2 GBps (though
>> it isn't). But I cannot see how having no compression could possibly be
>> faster than 2 GBps. :-/
>>
>> -- 
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
