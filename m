Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ip-88.staren.nu ([77.110.19.88]:38816 "EHLO iapetus.neab.net"
        rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1751736AbdHCWvS (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 3 Aug 2017 18:51:18 -0400
Date: Fri, 4 Aug 2017 00:51:12 +0200 (CEST)
From: pwm <pwm@iapetus.neab.net>
To: Goffredo Baroncelli <kreijack@inwind.it>
cc: Marat Khalili <mkh@rqc.ru>, "Austin S. Hemmelgarn" <ahferroin7@gmail.com>,
        linux-btrfs@vger.kernel.org, Hugo Mills <hugo@carfax.org.uk>
Subject: Re: Massive loss of disk space
In-Reply-To: <ed61fc9b-6d12-f9d1-6e5a-b11b357d377c@inwind.it>
Message-ID: <alpine.DEB.2.02.1708040038310.31126@iapetus.neab.net>
References: <alpine.DEB.2.02.1708011253230.31126@iapetus.neab.net> <20170801122039.GX7140@carfax.org.uk> <alpine.DEB.2.02.1708011520490.31126@iapetus.neab.net> <b30d1b78-7cbd-9bf5-3507-b028b9b8191f@gmail.com> <7f2b5c3a-2f5c-e857-d2dc-3ea16b58ecaf@gmail.com>
 <798a9077-bcbd-076c-a458-3403010ce8ac@libero.it> <e8abbe21-8cde-1650-8012-9b20a3fcfeec@rqc.ru> <ed61fc9b-6d12-f9d1-6e5a-b11b357d377c@inwind.it>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

In 30 seconds I should be able to fill about 200MB * 30 = 6GB.

Requiring the parity to not grow larger than there is a 6GB additional 
space is possible to live with on a 10TB disk.

It seems that for SnapRAID to have any chance to work correctly with 
parity on a BTRFS partition, it would need a min-free configuration 
paramter to make sure there is always enough free space for one parity 
file update.

But as it is right now, requiring that the disc isn't filled past 50% 
because fallocate() wants enough free space for 100% of the original file 
data to be rewritten obviously is not a working solution.

Right now, it sounds like I should change all parity disks to a different 
file system to avoid the CoW issue. There doesn't seem to be any way to 
turn off CoW for an already existing file, and the parity data is already 
way past 50% so I can't make a copy.

/Per W

On Thu, 3 Aug 2017, Goffredo Baroncelli wrote:

> On 2017-08-03 13:44, Marat Khalili wrote:
>> On 02/08/17 20:52, Goffredo Baroncelli wrote:
>>> consider the following scenario:
>>>
>>> a) create a 2GB file
>>> b) fallocate -o 1GB -l 2GB
>>> c) write from 1GB to 3GB
>>>
>>> after b), the expectation is that c) always succeed [1]: i.e. there is enough space on the filesystem. Due to the COW nature of BTRFS, you cannot rely on the already allocated space because there could be a small time window where both the old and the new data exists on the disk.
>> Just curious. With current implementation, in the following case:
>> a) create a 2GB file1 && create a 2GB file2
>> b) fallocate -o 1GB -l 2GB file1 && fallocate -o 1GB -l 2GB file2
>
> A this step you are trying to allocate 3GB+3GB = 6GB, so you exhausted the filesystem space.
>
>> c) write from 1GB to 3GB file1 && write from 1GB to 3GB file2
>> will (c) always succeed? I.e. does fallocate really allocate 2GB per file, or does it only allocate additional 1GB and check free space for another 1GB? If it's only the latter, it is useless.
> The file is physically extended
>
> ghigo@venice:/tmp$ fallocate -l 1000 foo.txt
> ghigo@venice:/tmp$ ls -l foo.txt
> -rw-r--r-- 1 ghigo ghigo 1000 Aug  3 18:00 foo.txt
> ghigo@venice:/tmp$ fallocate -o 500 -l 1000 foo.txt
> ghigo@venice:/tmp$ ls -l foo.txt
> -rw-r--r-- 1 ghigo ghigo 1500 Aug  3 18:00 foo.txt
> ghigo@venice:/tmp$
>
>>
>> --
>>
>> With Best Regards,
>> Marat Khalili
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>
>
> -- 
> gpg @keyserver.linux.it: Goffredo Baroncelli <kreijackATinwind.it>
> Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
