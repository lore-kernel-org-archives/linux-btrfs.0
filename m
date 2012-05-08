From: Hullen@t-online.de (Helmut Hullen)
Subject: Re: kernel 3.3.4 damages filesystem (?)
Date: 08 May 2012 20:29:00 +0200
Message-ID: <C8TGUFbuCXB@helmut.hullen.de>
References: <4FA956D0.30307@gmail.com>
Reply-To: helmut@hullen.de
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4FA956D0.30307@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Hallo, Felix,

Du meintest am 08.05.12:

>> As I've written many times: I want a system for my video collection
>> which allows
>>
>>          adding a bigger disk
>>          deleting/removing a smaller disk
>>
>> with simple commands.
>>
>> btrfs seems to be able to do that (and I have tested this job many
>> times). But with my configuration "mkfs.btrfs -m raid1 -d raid0"
>> I've (again) seen that all data vanishes when 1 disk fails.
>>
>> I'll try Hugo's proposal "mkfs.btrfs -m raid1 -d single".
>> And I hope that it doesn't make all disks unreadable when 1 disk
>> fails.

[...]

> @"-d single"

> Is it really possible to remove a disk from btrfs (created with -d
> single) without losing the data on that disk?

When the system is configured with

        mkfs.btrfs -m raid1 -d raid0

then the above shown way is possible, it works (now) as expected.
Ok - it needs some time.

And I have yet told in this mailing list that I'll try the option 2-d  
single".

> Is there a way to tell
> balance to copy all the data from this disk to the other disks (ofc
> if there is enough free space on them)?

As I've written some hours ago: I run

        btrfs fi balance ...

after adding and after deleting a disk. Maybe it's not necessary.  
Especially it seems not to be necessary after adding a disk.

Viele Gruesse!
Helmut
