Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.virtall.com ([46.4.129.203]:47302 "EHLO mail.virtall.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754214AbeBOEUC (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 14 Feb 2018 23:20:02 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Date: Thu, 15 Feb 2018 13:19:58 +0900
From: Tomasz Chmielewski <tch@virtall.com>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: fatal database corruption with btrfs "out of space" with ~50 GB
 left
In-Reply-To: <72c2c665-97f1-3356-6d65-66ba162736de@gmx.com>
References: <de1fdabb35ffe14eb92433ef444494e7@virtall.com>
 <72c2c665-97f1-3356-6d65-66ba162736de@gmx.com>
Message-ID: <f77a1a28c2cbf08efd24577088a29de0@virtall.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2018-02-15 10:47, Qu Wenruo wrote:
> On 2018年02月14日 22:19, Tomasz Chmielewski wrote:
>> Just FYI, how dangerous running btrfs can be - we had a fatal,
>> unrecoverable MySQL corruption when btrfs decided to do one of these 
>> "I
>> have ~50 GB left, so let's do out of space (and corrupt some files at
>> the same time, ha ha!)".
> 
> I'm recently looking into unexpected corruption problem of btrfs.
> 
> Would you please provide some extra info about how the corruption 
> happened?
> 
> 1) Is there any power reset?
>    Btrfs should be bullet proof, but in fact it's not, so I'm here to
>    get some clue.

No power reset.


> 2) Are MySQL files set with nodatacow?
>    If so, data corruption is more or less expected, but should be
>    handled by checkpoint of MySQL.

Yes, MySQL files were using "nodatacow".

I've seen many cases of "filesystem full" with ext4, but none lead to 
database corruption (i.e. the database would always recover after 
releasing some space)

On the other hand, I've seen a handful of "out of space" with gigabytes 
of free space with btrfs, which lead to some light, heavy or 
unrecoverable MySQL or mongo corruption.


Can it be because of of how "predictable" out of space situations are 
with btrfs and other filesystems?

- in short, ext4 will report out of space when there is 0 bytes left 
(perhaps slightly faster for non-root users) - the application trying to 
write data will see "out of space" at some point, and it can stay like 
this for hours (i.e. until some data is removed manually)

- on the other hand, btrfs can report out of space when there is still 
10, 50 or 100 GB left, meaning, any capacity planning is close to 
impossible; also, the application trying to write data can be seeing the 
fs as transitioning between "out of space" and "data written 
successfully" many times per minute/second?


> 3) Is the filesystem metadata corrupted? (AKA, btrfs check report 
> error)
>    If so, that should be the problem I'm looking into.

I don't think so, there are no scary things in dmesg. However, I didn't 
unmount the filesystem to run btrfs check.


> 4) Metadata/data ratio?
>    "btrfs fi usage" could have quite good result about it.
>    And "btrfs fi df" also helps.

Here it is - however, that's after removing some 80 GB data, so most 
likely doesn't reflect when the failure happened.

# btrfs fi usage /var/lib/lxd
Overall:
     Device size:                 846.25GiB
     Device allocated:            840.05GiB
     Device unallocated:            6.20GiB
     Device missing:                  0.00B
     Used:                        498.26GiB
     Free (estimated):            167.96GiB      (min: 167.96GiB)
     Data ratio:                       2.00
     Metadata ratio:                   2.00
     Global reserve:              512.00MiB      (used: 0.00B)

Data,RAID1: Size:411.00GiB, Used:246.14GiB
    /dev/sda3     411.00GiB
    /dev/sdb3     411.00GiB

Metadata,RAID1: Size:9.00GiB, Used:2.99GiB
    /dev/sda3       9.00GiB
    /dev/sdb3       9.00GiB

System,RAID1: Size:32.00MiB, Used:80.00KiB
    /dev/sda3      32.00MiB
    /dev/sdb3      32.00MiB

Unallocated:
    /dev/sda3       3.10GiB
    /dev/sdb3       3.10GiB



# btrfs fi df /var/lib/lxd
Data, RAID1: total=411.00GiB, used=246.15GiB
System, RAID1: total=32.00MiB, used=80.00KiB
Metadata, RAID1: total=9.00GiB, used=2.99GiB
GlobalReserve, single: total=512.00MiB, used=0.00B



# btrfs fi show /var/lib/lxd
Label: 'btrfs'  uuid: f5f30428-ec5b-4497-82de-6e20065e6f61
         Total devices 2 FS bytes used 249.15GiB
         devid    1 size 423.13GiB used 420.03GiB path /dev/sda3
         devid    2 size 423.13GiB used 420.03GiB path /dev/sdb3



Tomasz Chmielewski
https://lxadm.com
