Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-bl2nam02on0063.outbound.protection.outlook.com ([104.47.38.63]:61856
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S938131AbeBUPTt (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 21 Feb 2018 10:19:49 -0500
Subject: Re: Status of FST and mount times
To: Hans van Kranenburg <hans.van.kranenburg@mendix.com>,
        linux-btrfs@vger.kernel.org
References: <4d705301-c3a1-baaa-3eb8-f7b92f12f505@panasas.com>
 <27ee5e0b-4127-e890-1322-a31bd62e2412@suse.com>
 <0c3fb0bb-6fd1-67f6-1c74-3ee98ae15303@gmx.com>
 <0fa921f1-9a54-e410-1305-c88136f4823c@mendix.com>
 <5773ab23-8bee-1434-522b-231c154c4c6e@panasas.com>
 <c59b3618-0dc8-f07c-391f-45b9f42e3aaf@gmx.com>
 <db1e0ee1-c1ae-cc5c-842c-1caa714ef62b@panasas.com>
 <b5b93505-13ad-2e30-8daa-b624de5512bd@gmx.com>
 <5743750c-644d-9160-c0f3-599caf92dcb6@panasas.com>
 <ccc1f937-1cdd-afdd-d164-99c3ad648387@gmail.com>
 <4590b70e-2be7-b511-1428-685dcf2c26c6@gmx.com>
 <bcb18a10-3e87-66f7-63a4-b6f9906680ec@panasas.com>
 <93a21379-bb9b-7f44-a6b1-36b93ba0f926@mendix.com>
From: "Ellis H. Wilson III" <ellisw@panasas.com>
Message-ID: <baa3898d-d636-012b-3262-8984006ee146@panasas.com>
Date: Wed, 21 Feb 2018 10:19:44 -0500
MIME-Version: 1.0
In-Reply-To: <93a21379-bb9b-7f44-a6b1-36b93ba0f926@mendix.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 02/21/2018 10:03 AM, Hans van Kranenburg wrote:
> On 02/21/2018 03:49 PM, Ellis H. Wilson III wrote:
>> On 02/20/2018 08:49 PM, Qu Wenruo wrote:
>>> My suggestion is to use balance to reduce number of block groups, so we
>>> could do less search at mount time.
>>>
>>> It's more like reason 2.
>>>
>>> But it only works for case where there are a lot of fragments so a lot
>>> of chunks are not fully utilized.
>>> Unfortunately, that's not the case for OP, so my suggestion doesn't make
>>> sense here.
>>
>> I ran the balance all the same, and the number of chunks has not
>> changed.  Before 3454, and after 3454:
>>   $ sudo btrfs-debug-tree -t chunk /dev/sdb | grep CHUNK_ITEM | wc -l
>> 3454
>>
>> HOWEVER, the time to mount has gone up somewhat significantly, from
>> 11.537s to 16.553s, which was very unexpected.  Output from previously
>> run commands shows the extent tree metadata grew about 25% due to the
>> balance.  Everything else stayed roughly the same, and no additional
>> data was added to the system (nor snapshots taken, nor additional
>> volumes added, etc):
>>
>> Before balance:
>> $ sudo ./show_metadata_tree_sizes.py /mnt/btrfs/
>> ROOT_TREE           1.14MiB 0(    72) 1(     1)
>> EXTENT_TREE       644.27MiB 0( 41101) 1(   131) 2(     1)
>> CHUNK_TREE        384.00KiB 0(    23) 1(     1)
>> DEV_TREE          272.00KiB 0(    16) 1(     1)
>> FS_TREE            11.55GiB 0(754442) 1(  2179) 2(     5) 3(     2)
>> CSUM_TREE           3.50GiB 0(228593) 1(   791) 2(     2) 3(     1)
>> QUOTA_TREE            0.00B
>> UUID_TREE          16.00KiB 0(     1)
>> FREE_SPACE_TREE       0.00B
>> DATA_RELOC_TREE    16.00KiB 0(     1)
>>
>> After balance:
>> $ sudo ./show_metadata_tree_sizes.py /mnt/btrfs/
>> ROOT_TREE           1.16MiB 0(    73) 1(     1)
>> EXTENT_TREE       806.50MiB 0( 51419) 1(   196) 2(     1)
>> CHUNK_TREE        384.00KiB 0(    23) 1(     1)
>> DEV_TREE          272.00KiB 0(    16) 1(     1)
>> FS_TREE            11.55GiB 0(754442) 1(  2179) 2(     5) 3(     2)
>> CSUM_TREE           3.49GiB 0(227920) 1(   804) 2(     2) 3(     1)
>> QUOTA_TREE            0.00B
>> UUID_TREE          16.00KiB 0(     1)
>> FREE_SPACE_TREE       0.00B
>> DATA_RELOC_TREE    16.00KiB 0(     1)
> 
> Heu, interesting.
> 
> What's the output of `btrfs fi df /mountpoint` and `grep btrfs
> /proc/self/mounts` (does it contain 'ssd') and which kernel version is
> this? (I get a bit lost in the many messages and subthreads in this
> thread) I also can't find in the threads which command "the balance" means.

Short recap:
- I found long mount time for 1.65TB of home dir data at ~4s
- Doubling this data on the same btrfs fs to 3.3TB increased mount time 
to 11s
- Qu et. al. suggested balance might reduce chunks, which came in around 
3400, and the chunk walk on mount was the driving factor in terms of time
- I ran balance
- Mount time went up to 16s, and all else remains the same except the 
extent tree.

$ sudo btrfs fi df /mnt/btrfs
Data, single: total=3.32TiB, used=3.32TiB
System, DUP: total=8.00MiB, used=384.00KiB
Metadata, DUP: total=16.50GiB, used=15.82GiB
GlobalReserve, single: total=512.00MiB, used=0.00B

$ sudo grep btrfs /proc/self/mounts
/dev/sdb /mnt/btrfs btrfs rw,relatime,space_cache,subvolid=5,subvol=/ 0 0

  $ uname -a
Linux <snip> 4.5.5-300.fc24.x86_64 #1 SMP Thu May 19 13:05:32 UTC 2016 
x86_64 x86_64 x86_64 GNU/Linux

I plan to rerun this on a newer kernel, but haven't had time to spin up 
another machine with a modern kernel yet, and this machine is also being 
used for other things right now so I can't just upgrade it.

> And what does this tell you?
> 
> https://github.com/knorrie/python-btrfs/blob/develop/examples/show_free_space_fragmentation.py

$ sudo ./show_free_space_fragmentation.py /mnt/btrfs
No Free Space Tree (space_cache=v2) found!
Falling back to using the extent tree to determine free space extents.
vaddr 6529453391872 length 1073741824 used_pct 27 free space fragments 1 
score 0
Skipped because of usage > 90%: 3397 chunks

Best,

ellis
