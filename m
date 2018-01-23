Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pf0-f171.google.com ([209.85.192.171]:36670 "EHLO
        mail-pf0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751547AbeAWSNq (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 23 Jan 2018 13:13:46 -0500
Received: by mail-pf0-f171.google.com with SMTP id 23so947326pfp.3
        for <linux-btrfs@vger.kernel.org>; Tue, 23 Jan 2018 10:13:46 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAEY8F1pstmMVaypLo31vkvOWZZw0L_-d4U4=3LpoQCcJHyZ91Q@mail.gmail.com>
References: <CAEY8F1qw-6Xa+ESJH0X3zhJcQ1UaoJO4wkPjdDt63JEYHBuAoQ@mail.gmail.com>
 <20180122212250.GY3807@carfax.org.uk> <CAEY8F1pstmMVaypLo31vkvOWZZw0L_-d4U4=3LpoQCcJHyZ91Q@mail.gmail.com>
From: Claes Fransson <claes.v.fransson@gmail.com>
Date: Tue, 23 Jan 2018 19:13:44 +0100
Message-ID: <CAEY8F1qBNg=_PszmbEMMTG83zzmpU4Qc=rQhHOjjVCCcOw3X6g@mail.gmail.com>
Subject: Re: bad key ordering - repairable?
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

2018-01-23 14:06 GMT+01:00 Claes Fransson <claes.v.fransson@gmail.com>:
> 2018-01-22 22:22 GMT+01:00 Hugo Mills <hugo@carfax.org.uk>:
>> On Mon, Jan 22, 2018 at 10:06:58PM +0100, Claes Fransson wrote:
>>> Hi!
>>>
>>> I really like the features of BTRFS, especially deduplication,
>>> snapshotting and checksumming. However, when using it on my laptop the
>>> last couple of years, it has became corrupted a lot of times.
>>> Sometimes I have managed to fix the problems (at least so much that I
>>> can continue to use the filesystem) with check --repair, but several
>>> times I had to recreate the file system and reinstall the operating
>>> system.
>>>
>>> I am guessing the corruptions might be the results of unclean
>>> shutdowns, mostly after system hangs, but also because of running out
>>> of battery sometimes?
>>> Furthermore, the power-led has recently started blinking (also when
>>> the power-cable is plugged in), I guess because of an old and bad
>>> battery. Maybe the current corruption also can have something to do
>>> with this? However I almost always run with power cable plugged in in
>>> last year, only on battery a few seconds a few times when moving the
>>> laptop.
>>>
>>> Currently, I can only mount the filesystem readonly, it goes readonly
>>> automatically if I try to mount it normally.
>>>
>>> When booting an OpenSUSE Tumbleweed-20180119 live-iso:
>>> localhost:~ # uname -r
>>> 4.14.13-1-default
>>> localhost:~ # btrfs --version
>>> btrfs-progs v4.14.1
>>>
>>> localhost:~ # btrfs check -p /dev/sda12
>>> Checking filesystem on /dev/sda12
>>
>> [fixing up bad paste]
>>
>>> UUID: d2819d5a-fd69-484b-bf34-f2b5692cbe1f
>>> bad key ordering 159 160 bad block 690436964352
>>> ERROR: errors found in extent allocation tree or chunk allocation
>>> checking free space cache [.]
>>> checking fs roots [o]
>>> checking csums
>>> bad key ordering 159 160
>>> Error looking up extent record -1
>>
>> [snip]
>>
>>> localhost:~ # btrfs inspect-internal dump-tree -b 690436964352
>>> /dev/sda12
>>> btrfs-progs v4.14.1
>>>     leaf 690436964352 items 170 free space 1811 generation 196864 owner 2
>>>     leaf 690436964352 flags 0x1(WRITTEN) backref revision 1
>>>     fs uuid d2819d5a-fd69-484b-bf34-f2b5692cbe1f
>>>     chunk uuid 52f81fe6-893b-4432-9336-895057ee81e1
>>> .
>>> .
>>> .
>>>         item 157 key (22732500992 EXTENT_ITEM 16384) itemoff 6538 itemsize 53
>>>                 refs 1 gen 821 flags DATA
>>>                 extent data backref root 287 objectid 51665 offset 0 count 1
>>>         item 158 key (22732517376 EXTENT_ITEM 16384) itemoff 6485 itemsize 53
>>>                 refs 1 gen 821 flags DATA
>>>                 extent data backref root 287 objectid 51666 offset 0 count 1
>>>         item 159 key (22732533760 EXTENT_ITEM 16384) itemoff 6485 itemsize 0
>>> print-tree.c:428: print_extent_item: BUG_ON `item_size != sizeof(*ei0)` triggered, value 1
>>> btrfs(+0x365c6)[0x55bdfaada5c6]
>>> btrfs(print_extent_item+0x424)[0x55bdfaadb284]
>>> btrfs(btrfs_print_leaf+0x94e)[0x55bdfaadbc1e]
>>> btrfs(btrfs_print_tree+0x295)[0x55bdfaadcf05]
>>> btrfs(cmd_inspect_dump_tree+0x734)[0x55bdfab1b024]
>>> btrfs(main+0x7d)[0x55bdfaac7d4d]
>>> /lib64/libc.so.6(__libc_start_main+0xea)[0x7ff42100ff4a]
>>> btrfs(_start+0x2a)[0x55bdfaac7e5a]
>>> Aborted (core dumped)
>>
>>    Wow, I've never seen it do that before. It's the next thing I'd
>> have asked for, so it's good you've preempted it.
>>
>>    The main thing is that bad key ordering is almost always due to RAM
>> corruption. That's either bad RAM, or dodgy power regulation -- the
>> latter could be the PSU, or capacitors on the motherboard. (In this
>> case, it might also be something funny with the battery).
>>
>>    I would definitely recommend a long run of memtest86. At least 8
>> hours, preferably 24. If you get errors repeatedly in the sme place,
>> it's the RAM. If they appear randomly, it's probably the power
>> regulation.
>>
> Thanks for the suggestion, I will try to do this in the next days.
>

I haven't noticed before that there is actually RAM-modules from
different vendors in the laptop. One 8GB by Samsung, and one 4GB by
Kingston! Maybe that is a source for the corruptions.
I also found that there indeed was a new firmware version for my
SSD-disk, so I have now updated it's firmware to the newest version.
Unfortunately I couldn't find any information of what possible issues
it was supposed to fix. The laptop has already the latest BIOS version
provided by ASUS for the model.
I have not yet run the memtest86.

Claes

>> [snip]
>>
>>>
>>> The filesystem had become pretty full, I had planned to increase the
>>> Btrfs-partition size before it became corrupt.
>>>
>>> Active kernel when the filesystem went read only: OpenSUSE Linux
>>> 4.14.14-1.geef6178-default, from the
>>> http://download.opensuse.org/repositories/Kernel:/stable/standard/stable
>>> repository.
>>>
>>> Fstab mount options: noatime,autodefrag (I have been using the option
>>> nossd with older kernels one period in the past on the filesystem).
>>>
>>> If it matters, I have been running duperemove many times on the
>>> filesystem since creation.
>>>
>>> To test the RAM, I have been running mprime Blend-test for 24 hours
>>> after the corruption without any error or warning.
>>
>>    Of all of the bad key order errors I've seen (dozens), I think
>> there were a whole two which turned out not to be obviously related to
>> corrupt RAM. I still say that it's most likely the hardware.
>
> Okay, thank you for sharing your experience with me.
>
>>
>>> Is there a way I can try to repair this filesystem without the need to
>>> recreate it and reinstall the operating system? A reinstall including
>>> all currently installed packages, and restoring all current system
>>> settings, would probably take some time for me to do.
>>> If it is currently not repairable, it would be nice if this kind of
>>> corruption could be repaired in the future, even if losing a few
>>> files. Or if the corruptions could be avoided in the first place.
>>
>>    Given that the current tools crash, the answer's a definite
>> no. However, if you can get a developer interested, they may be able
>> to write a fix for it, given an image of the FS (using btrfs-image).
>>
> Okay, will try to produce and upload an image within the next week.
>
>
>> [snip]
>>> I have never noticed any corruptions on the NTFS and Ext4 file systems
>>> on the laptop, only on the Btrfs file systems.
>>
>>    You've never _noticed_ them. :)
>>
>>    Hugo.
>>
>> --
>> Hugo Mills             | ... one ping(1) to rule them all, and in the
>> hugo@... carfax.org.uk | darkness bind(2) them.
>> http://carfax.org.uk/  |
>> PGP: E2AB1DE4          |                                                Illiad
>
> Thank you for your answers.
>
> Claes
