From: Hullen@t-online.de (Helmut Hullen)
Subject: Re: kernel 3.3.4 damages filesystem (?)
Date: 08 May 2012 21:34:00 +0200
Message-ID: <C8TGck3eCXB@helmut.hullen.de>
References: <4FA968EB.6050306@gmail.com>
Reply-To: helmut@hullen.de
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4FA968EB.6050306@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Hallo, Felix,

Du meintest am 08.05.12:

>>>>           adding a bigger disk
>>>>           deleting/removing a smaller disk
>>>>
>>>> with simple commands.

[...]

>>> Is it really possible to remove a disk from btrfs (created with -d
>>> single) without losing the data on that disk?
>>
>> When the system is configured with
>>
>>          mkfs.btrfs -m raid1 -d raid0
>>
>> then the above shown way is possible, it works (now) as expected.
>> Ok - it needs some time.

[...]

> What are the steps you're doing?! If this is really possible then
> there must be some sort of command that tells btrfs "Hey, I wanne
> remove this disk from the fs, please copy all data to the other disks
> and then remove the disk". Is there such a command? Haven't heard of
> one, but that would be interesting.

        btrfs device add /dev/$newdisk ...
        (btrfs fi balance ...)
        btrfs device delete /dev/$olddisk ...
        (btrfs fi balance ...)

I've told these simple steps many times in this mailing list.

Since some kernel versions (at least since kernel 3.2.x) it seems to  
work without problems; "btrfs-progs"-packet from 2011-10-30.


> Otherwise if you remove a disk from a raid0 (doesn't matter if you
> have 2 or 5 or x disks in the fs, btrfs should stripe above all
> disks) your fs should be broken.


Not with btrfs ... there it works even with

  mkfs.btrfs -m raid1 -d raid0 ...

Viele Gruesse!
Helmut
