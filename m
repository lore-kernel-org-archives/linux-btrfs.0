Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vb0-f51.google.com ([209.85.212.51]:46840 "EHLO
	mail-vb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750728Ab3KHF1E (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 8 Nov 2013 00:27:04 -0500
Received: by mail-vb0-f51.google.com with SMTP id w5so1094908vbf.10
        for <linux-btrfs@vger.kernel.org>; Thu, 07 Nov 2013 21:27:02 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAOMFOmWee0NX=ZmcdG2FpkKyu-XLC5druy-Cn5+6ZAZa34WdZg@mail.gmail.com>
References: <CAOMFOmUDd0jS=R+MAVwfwmNj7Bt9VUM46b8zYmC59BA65qhUfA@mail.gmail.com>
	<CAC4gV=7FgL=wixYf6w-yfuZNbz8QCt5t9T8_jStjpkKgTBc+Vw@mail.gmail.com>
	<CAOMFOmXj=-8g6hYs_qcj417OUmgLEGdms2kMzUdorCuxJ7292w@mail.gmail.com>
	<CAOMFOmWee0NX=ZmcdG2FpkKyu-XLC5druy-Cn5+6ZAZa34WdZg@mail.gmail.com>
Date: Fri, 8 Nov 2013 00:27:02 -0500
Message-ID: <CAC4gV=6yDhYHfWHOer_uVYZ8dgCQ5C=7JXkN3rpkXs=tH_jPZQ@mail.gmail.com>
Subject: Re: How to fix/remove "csum failed ino" error
From: Frank Holton <fholton@gmail.com>
To: Anatol Pomozov <anatol.pomozov@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Anatol,

That certainly does not look good, definitely more than just a bad
space cache. A this point I would strongly suggest that before you try
anything else on the file system that you make sure you have a backup
of everything up there. After you have backed up everything a scrub
may be able to fix some of the corruption or at least tell you which
files are corrupted (the names are printed to the kernel log.) Its
also possible that this will lock up the kernel again so be prepared
for that. Since you are not on raid1 yet it cannot fix those files, it
only reports the ones with checksum errors so you would need to delete
them manually.

as root
btrfs scrub start /mount_point

Another option you can try is to mount with the recovery option.

But before you go any further ensure you have good backups separate
from your BTRFS file system.

Hope some of that helps.



On Thu, Nov 7, 2013 at 11:55 PM, Anatol Pomozov
<anatol.pomozov@gmail.com> wrote:
> Hi
>
> I ran btrfsck hoping that it fix the filesystem so 'balance' would not
> crash anymore. But btrfsck itself crashed :(
>
> # btrfsck --repair /dev/sda3
>
>            :(
> enabling repair mode
> Checking filesystem on /dev/sda3
> UUID: 25e6a6fa-fe1f-4be5-a638-eeac948f8c21
> checking extents
> checking fs roots
> root 5 inode 522858 errors 1000
> root 5 inode 1437358 errors 1000
> root 5 inode 1437359 errors 1000
> root 5 inode 1437360 errors 1000
> root 5 inode 1437361 errors 1000
> root 5 inode 1437362 errors 1000
> root 5 inode 1437363 errors 1000
> root 5 inode 1437368 errors 1000
> root 5 inode 1437369 errors 1000
> root 5 inode 1437370 errors 1000
> root 5 inode 1437371 errors 1000
> root 5 inode 1437372 errors 1000
> root 5 inode 1437373 errors 1000
> root 5 inode 1437374 errors 1000
> root 5 inode 1437375 errors 1000
> root 5 inode 1437376 errors 1000
> root 5 inode 1437377 errors 1000
> root 5 inode 1437378 errors 1000
> root 5 inode 1437379 errors 1000
> root 5 inode 1437380 errors 1000
> root 5 inode 1437381 errors 1000
> root 5 inode 1437382 errors 1000
> root 5 inode 1437383 errors 1000
> root 5 inode 1437384 errors 1000
> root 5 inode 1437385 errors 1000
> root 5 inode 1437386 errors 1000
> root 5 inode 1437387 errors 1000
> root 5 inode 1437388 errors 1000
> root 5 inode 1437389 errors 1000
> root 5 inode 1437390 errors 1000
> root 5 inode 1437391 errors 1000
> root 5 inode 1437392 errors 1000
> root 5 inode 1437393 errors 1000
> root 5 inode 1437394 errors 1000
> root 5 inode 1437395 errors 1000
> root 5 inode 1437396 errors 1000
> root 5 inode 1437397 errors 1000
> root 5 inode 1437398 errors 1000
> root 5 inode 1437399 errors 1000
> root 5 inode 1437400 errors 1000
> root 5 inode 5073119 errors 400
> Unable to find block group for 0
> btrfsck: extent-tree.c:284: find_search_start: Assertion `!(1)' failed.
> [1]    583 abort (core dumped)  btrfsck --repair /dev/sda3
>
> On Thu, Nov 7, 2013 at 8:07 PM, Anatol Pomozov <anatol.pomozov@gmail.com> wrote:
>> Hi, Frank
>>
>> Thanks for your answer.
>>
>> On Thu, Nov 7, 2013 at 8:41 AM, Frank Holton <fholton@gmail.com> wrote:
>>> Hey Anatol,
>>>
>>> I just checked and on my filesystem inode number 362 corresponds to
>>> part of the free space cache. You can check this yourself by running
>>> (as root)
>>>
>>> btrfs-debug-tree /dev/sdb | grep "(362 " -A 3 -B 1
>>>
>>> where /dev/sdb is one of the devices from your filesystem.
>>>
>>> It printed the following for me, note the location key (362
>>> INODE_ITEM) under the FREE_SPACE key. Yours might be different but if
>>> you see FREE_SPACE that points to the free space cache.
>>>
>>> item 100 key (362 INODE_ITEM 0) itemoff 21857 itemsize 160
>>>                 inode generation 2004 transid 2004 size 262144 block
>>> group 0 mode 100600 links 1
>>>         item 101 key (362 EXTENT_DATA 0) itemoff 21804 itemsize 53
>>>                 extent data disk byte 41903296512 nr 262144
>>>                 extent data offset 0 nr 262144 ram 262144
>>>                 extent compression 0
>>> --
>>>         item 148 key (FREE_SPACE UNTYPED 113845993472) itemoff 23807 itemsize 41
>>>                 location key (362 INODE_ITEM 0)
>>>                 cache generation 2004 entries 2 bitmaps 0
>>
>>
>> Indeed my case similar to yours
>>
>> # btrfs-debug-tree /dev/sda3 | grep "(309 " -A 3 -B 1
>>
>> item 1 key (309 INODE_ITEM 0) itemoff 3675 itemsize 160
>>     inode generation 190480 transid 190647 size 0 block group 0 mode
>> 100600 links 1
>> item 51 key (FREE_SPACE UNTYPED 56937676800) itemoff 1863 itemsize 41
>>     location key (309 INODE_ITEM 0)
>>
>> So I mounted my filesystem with 'clear_cache' flag:
>>
>> # mount -o clear_cache /dev/sda3 mydata/
>>
>> mount says:
>> /dev/sdc1 on /root/mydata type btrfs (rw,relatime,space_cache,clear_cache)
>>
>> dmesg also mentions the cache:
>>
>> [  634.991845] device fsid 25e6a6fa-fe1f-4be5-a638-eeac948f8c21 devid
>> 9 transid 190479 /dev/sda3
>> [  634.993431] btrfs: force clearing of disk cache
>> [  634.993435] btrfs: disk space caching is enabled
>> [  635.046803] btrfs: bdev /dev/sda3 errs: wr 0, rd 0, flush 0,
>> corrupt 58481, gen 0
>>
>>
>> The I started raid1 rebalance but the error still presents:
>>
>> [ 1571.787664] BTRFS info (device sda3): csum failed ino 309 off
>> 4993024 csum 1283121890 private 3720296651
>> [ 1571.791027] BTRFS info (device sda3): csum failed ino 309 off
>> 5242880 csum 857237386 private 2562492866
>> [ 1571.793998] BTRFS info (device sda3): csum failed ino 309 off
>> 5767168 csum 645194099 private 3149624654
>> [ 1571.794389] BTRFS info (device sda3): csum failed ino 309 off
>> 4993024 csum 1283121890 private 3720296651
>>
>>
>> So my problem still exists. How to fix the block with wrong csum?
