From: Felix Blanke <felixblanke@gmail.com>
Subject: Re: kernel 3.3.4 damages filesystem (?)
Date: Tue, 08 May 2012 20:41:47 +0200
Message-ID: <4FA968EB.6050306@gmail.com>
References: <C8TGUFbuCXB@helmut.hullen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Cc: Helmut Hullen <Hullen@t-online.de>, linux-btrfs@vger.kernel.org
To: helmut@hullen.de
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <C8TGUFbuCXB@helmut.hullen.de>
List-ID: <linux-btrfs.vger.kernel.org>

On 5/8/12 8:29 PM, Helmut Hullen wrote:
> Hallo, Felix,
>
> Du meintest am 08.05.12:
>
>>> As I've written many times: I want a system for my video collection
>>> which allows
>>>
>>>           adding a bigger disk
>>>           deleting/removing a smaller disk
>>>
>>> with simple commands.
>>>
>>> btrfs seems to be able to do that (and I have tested this job many
>>> times). But with my configuration "mkfs.btrfs -m raid1 -d raid0"
>>> I've (again) seen that all data vanishes when 1 disk fails.
>>>
>>> I'll try Hugo's proposal "mkfs.btrfs -m raid1 -d single".
>>> And I hope that it doesn't make all disks unreadable when 1 disk
>>> fails.
>
> [...]
>
>> @"-d single"
>
>> Is it really possible to remove a disk from btrfs (created with -d
>> single) without losing the data on that disk?
>
> When the system is configured with
>
>          mkfs.btrfs -m raid1 -d raid0
>
> then the above shown way is possible, it works (now) as expected.
> Ok - it needs some time.
>
> And I have yet told in this mailing list that I'll try the option 2-d
> single".
>
>> Is there a way to tell
>> balance to copy all the data from this disk to the other disks (ofc
>> if there is enough free space on them)?
>
> As I've written some hours ago: I run
>
>          btrfs fi balance ...
>
> after adding and after deleting a disk. Maybe it's not necessary.
> Especially it seems not to be necessary after adding a disk.

What are the steps you're doing?! If this is really possible then there 
must be some sort of command that tells btrfs "Hey, I wanne remove this 
disk from the fs, please copy all data to the other disks and then 
remove the disk". Is there such a command? Haven't heard of one, but 
that would be interesting.

Otherwise if you remove a disk from a raid0 (doesn't matter if you have 
2 or 5 or x disks in the fs, btrfs should stripe above all disks) your 
fs should be broken.

>
> Viele Gruesse!
> Helmut
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
