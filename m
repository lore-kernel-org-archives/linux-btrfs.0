Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp-out-no.shaw.ca ([64.59.134.9]:49832 "EHLO
        smtp-out-no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751144AbeETUoC (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 20 May 2018 16:44:02 -0400
Subject: Re: off-by-one uncompressed invalid ram_bytes corruptions
To: Qu Wenruo <quwenruo.btrfs@gmx.com>, linux-btrfs@vger.kernel.org
References: <b262fdfc-16b2-21d0-4d7b-745ef106b555@shaw.ca>
 <2dab827b-2c68-ea5c-6730-485037727c36@gmx.com>
 <0b8e2626-fb00-1e82-4f22-c400cea57533@shaw.ca>
 <5093c14b-5d6d-0827-0c04-bf2fd73af0bd@gmx.com>
From: Steve Leung <sjleung@shaw.ca>
Message-ID: <e0854da8-0d3e-946a-5709-7a329175bad3@shaw.ca>
Date: Sun, 20 May 2018 14:43:59 -0600
MIME-Version: 1.0
In-Reply-To: <5093c14b-5d6d-0827-0c04-bf2fd73af0bd@gmx.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 05/19/2018 07:02 PM, Qu Wenruo wrote:
> 
> 
> On 2018年05月20日 07:40, Steve Leung wrote:
>> On 05/17/2018 11:49 PM, Qu Wenruo wrote:
>>> On 2018年05月18日 13:23, Steve Leung wrote:
>>>> Hi list,
>>>>
>>>> I've got 3-device raid1 btrfs filesystem that's throwing up some
>>>> "corrupt leaf" errors in dmesg.  This is a uniquified list I've
>>>> observed lately:

>>>>     BTRFS critical (device sda1): corrupt leaf: root=1
>>>> block=4970196795392
>>>> slot=307 ino=206231 file_offset=0, invalid ram_bytes for uncompressed
>>>> inline extent, have 3468 expect 3469
>>>
>>> Would you please use "btrfs-debug-tree -b 4970196795392 /dev/sda1" to
>>> dump the leaf?
>>
>> Attached btrfs-debug-tree dumps for all of the blocks that I saw
>> messages for.
>>
>>> It's caught by tree-checker code which is ensuring all tree blocks are
>>> correct before btrfs can take use of them.
>>>
>>> That inline extent size check is tested, so I'm wondering if this
>>> indicates any real corruption.
>>> That btrfs-debug-tree output will definitely help.
>>>
>>> BTW, if I didn't miss anything, there should not be any inlined extent
>>> in root tree.
>>>
>>>>     BTRFS critical (device sda1): corrupt leaf: root=1
>>>> block=4970552426496
>>>> slot=91 ino=209736 file_offset=0, invalid ram_bytes for uncompressed
>>>> inline extent, have 3496 expect 3497
>>>
>>> Same dump will definitely help.
>>>
>>>>     BTRFS critical (device sda1): corrupt leaf: root=1
>>>> block=4970712399872
>>>> slot=221 ino=205230 file_offset=0, invalid ram_bytes for uncompressed
>>>> inline extent, have 1790 expect 1791
>>>>     BTRFS critical (device sda1): corrupt leaf: root=1
>>>> block=4970803920896
>>>> slot=368 ino=205732 file_offset=0, invalid ram_bytes for uncompressed
>>>> inline extent, have 2475 expect 2476
>>>>     BTRFS critical (device sda1): corrupt leaf: root=1
>>>> block=4970987945984
>>>> slot=236 ino=208896 file_offset=0, invalid ram_bytes for uncompressed
>>>> inline extent, have 490 expect 491
>>>>
>>>> All of them seem to be 1 short of the expected value.
>>>>
>>>> Some files do seem to be inaccessible on the filesystem, and btrfs
>>>> inspect-internal on any of those inode numbers fails with:
>>>>
>>>>    ERROR: ino paths ioctl: Input/output error
>>>>
>>>> and another message for that inode appears.
>>>>
>>>> 'btrfs check' (output attached) seems to notice these corruptions (among
>>>> a few others, some of which seem to be related to a problematic attempt
>>>> to build Android I posted about some months ago).
>>>>
>>>> Other information:
>>>>
>>>> Arch Linux x86-64, kernel 4.16.6, btrfs-progs 4.16.  The filesystem has
>>>> about 25 snapshots at the moment, only a handful of compressed files,
>>>> and nothing fancy like qgroups enabled.
>>>>
>>>> btrfs fi show:
>>>>
>>>>    Label: none  uuid: 9d4db9e3-b9c3-4f6d-8cb4-60ff55e96d82
>>>>            Total devices 4 FS bytes used 2.48TiB
>>>>            devid    1 size 1.36TiB used 1.13TiB path /dev/sdd1
>>>>            devid    2 size 464.73GiB used 230.00GiB path /dev/sdc1
>>>>            devid    3 size 1.36TiB used 1.13TiB path /dev/sdb1
>>>>            devid    4 size 3.49TiB used 2.49TiB path /dev/sda1
>>>>
>>>> btrfs fi df:
>>>>
>>>>    Data, RAID1: total=2.49TiB, used=2.48TiB
>>>>    System, RAID1: total=32.00MiB, used=416.00KiB
>>>>    Metadata, RAID1: total=7.00GiB, used=5.29GiB
>>>>    GlobalReserve, single: total=512.00MiB, used=0.00B
>>>>
>>>> dmesg output attached as well.
>>>>
>>>> Thanks in advance for any assistance!  I have backups of all the
>>>> important stuff here but it would be nice to fix the corruptions in
>>>> place.
>>>
>>> And btrfs check doesn't report the same problem as the default original
>>> mode doesn't have such check.
>>>
>>> Please also post the result of "btrfs check --mode=lowmem /dev/sda1"
>>
>> Also, attached.  It seems to notice the same off-by-one problems, though
>> there also seem to be a couple of examples of being off by more than one.
> 
> Unfortunately, it doesn't detect, as there is no off-by-one error at all.
> 
> The problem is, kernel is reporting error on completely fine leaf.
> 
> Further more, even in the same leaf, there are more inlined extents, and
> they are all valid.
> 
> So the kernel reports the error out of nowhere.
> 
> More problems happens for extent_size where a lot of them is offset by one.
> 
> Moreover, the root owner is not printed correctly, thus I'm wondering if
> the memory is corrupted.
> 
> Please try memtest+ to verify all your memory is correct, and if so,
> please try the attached patch and to see if it provides extra info.

Memtest ran for about 12 hours last night, and didn't find any errors.

New messages from patched kernel:

  BTRFS critical (device sdd1): corrupt leaf: root=1 block=4970196795392 
slot=307 ino=206231 file_offset=0, invalid ram_bytes for uncompressed 
inline extent, have 3468 expect 3469 (21 + 3448)
  BTRFS critical (device sdd1): corrupt leaf: root=1 block=4970552426496 
slot=91 ino=209736 file_offset=0, invalid ram_bytes for uncompressed 
inline extent, have 3496 expect 3497 (21 + 3476)
  BTRFS critical (device sdd1): corrupt leaf: root=1 block=4970712399872 
slot=221 ino=205230 file_offset=0, invalid ram_bytes for uncompressed 
inline extent, have 1790 expect 1791 (21 + 1770)
  BTRFS critical (device sdd1): corrupt leaf: root=1 block=4970803920896 
slot=368 ino=205732 file_offset=0, invalid ram_bytes for uncompressed 
inline extent, have 2475 expect 2476 (21 + 2455)
  BTRFS critical (device sdd1): corrupt leaf: root=1 block=4970987945984 
slot=236 ino=208896 file_offset=0, invalid ram_bytes for uncompressed 
inline extent, have 490 expect 491 (21 + 470)

Steve
