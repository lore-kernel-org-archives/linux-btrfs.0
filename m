Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wr0-f179.google.com ([209.85.128.179]:36827 "EHLO
        mail-wr0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752876AbdBMUuO (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 13 Feb 2017 15:50:14 -0500
Received: by mail-wr0-f179.google.com with SMTP id k90so158486176wrc.3
        for <linux-btrfs@vger.kernel.org>; Mon, 13 Feb 2017 12:50:13 -0800 (PST)
Subject: Re: Root volume (ID 5) in deleting state
To: Hans van Kranenburg <hans.van.kranenburg@mendix.com>,
        linux-btrfs@vger.kernel.org
References: <ed8d7383-c75c-584e-4722-c889c6f19a46@gmail.com>
 <a103e413-d922-9c79-0075-1ce00a3cd7de@mendix.com>
From: =?UTF-8?B?TWFydGluIE1seW7DocWZ?= <nextsux@gmail.com>
Message-ID: <af9179d8-cf9e-7eef-3150-477bf3a55ff8@gmail.com>
Date: Mon, 13 Feb 2017 21:50:10 +0100
MIME-Version: 1.0
In-Reply-To: <a103e413-d922-9c79-0075-1ce00a3cd7de@mendix.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 13.2.2017 21:03, Hans van Kranenburg wrote:
> On 02/13/2017 12:26 PM, Martin Mlynář wrote:
>> I've currently run into strange problem with BTRFS. I'm using it as my
>> daily driver as root FS. Nothing complicated, just few subvolumes and
>> incremental backups using btrbk.
>>
>> Now I've noticed that my btrfs root volume (absolute top, ID 5) is in
>> "deleting" state. As I've done some testing and googling it seems that
>> this should not be possible.
>>
>> [...]
>>
>> # btrfs sub list -ad /mnt/btrfs_root/
>> ID 5 gen 257505 top level 0 path <FS_TREE>/DELETED
> I have heard rumours that this is actually a bug in the output of sub
> list itself.
>
> What's the version of your btrfs-progs? (output of `btrfs version`)
Sorry, I've lost this part:

$ btrfs version
btrfs-progs v4.9

>
>> # mount | grep btr
>> /dev/mapper/vg0-btrfsroot on / type btrfs
>> (rw,noatime,nodatasum,nodatacow,ssd,discard,space_cache,subvolid=1339,subvol=/rootfs)
>>
>> /dev/mapper/vg0-btrfsroot on /mnt/btrfs_root type btrfs
>> (rw,noatime,nodatasum,nodatacow,ssd,discard,space_cache,subvolid=5,subvol=/)
> The rumour was that it had something to do with using space_cache=v2,
> which this example does not confirm.
It looks you're right!

On a different machine:

# btrfs sub list / | grep -v lxc
ID 327 gen 1959587 top level 5 path mnt/reaver
ID 498 gen 593655 top level 5 path var/lib/machines

# btrfs sub list / -d | wc -l
0

# btrfs version
btrfs-progs v4.8.2

# uname -a
Linux nxserver 4.8.6-1-ARCH #1 SMP PREEMPT Mon Oct 31 18:51:30 CET 2016 
x86_64 GNU/Linux

# mount | grep btrfs
/dev/vda1 on / type btrfs 
(rw,relatime,nodatasum,nodatacow,space_cache,subvolid=5,subvol=/)

Then I've upgraded this machine and:

# btrfs sub list / | grep -v lxc
ID 327 gen 1959587 top level 5 path mnt/reaver
ID 498 gen 593655 top level 5 path var/lib/machines

# btrfs sub list / -d | wc -l
1

# btrfs sub list / -d
ID 5 gen 2186037 top level 0 path DELETED    <======

1

# btrfs version
btrfs-progs v4.9

# uname -a
Linux nxserver 4.9.8-1-ARCH #1 SMP PREEMPT Mon Feb 6 12:59:40 CET 2017 
x86_64 GNU/Linux

# mount | grep btrfs
/dev/vda1 on / type btrfs 
(rw,relatime,nodatasum,nodatacow,space_cache,subvolid=5,subvol=/)


>
>> # uname -a
>> Linux interceptor 4.9.6-1-ARCH #1 SMP PREEMPT Thu Jan 26 09:22:26 CET
>> 2017 x86_64 GNU/Linux
>>
>> # btrfs fi show  /
>> Label: none  uuid: 859dec5c-850c-4660-ad99-bc87456aa309
>>      Total devices 1 FS bytes used 132.89GiB
>>      devid    1 size 200.00GiB used 200.00GiB path /dev/mapper/vg0-btrfsroot
> As a side note, all of your disk space is allocated (200GiB of 200GiB).
>
> Even while there's still 70GiB of free space scattered around inside,
> this might lead to out-of-space issues, depending on how badly
> fragmented that free space is.
I have not noticed this at all!

# btrfs fi show /
Label: none  uuid: 859dec5c-850c-4660-ad99-bc87456aa309
     Total devices 1 FS bytes used 134.23GiB
     devid    1 size 200.00GiB used 200.00GiB path /dev/mapper/vg0-btrfsroot

# btrfs fi df /
Data, single: total=195.96GiB, used=131.58GiB
System, single: total=3.00MiB, used=48.00KiB
Metadata, single: total=4.03GiB, used=2.64GiB
GlobalReserve, single: total=512.00MiB, used=0.00B

After btrfs defrag there is no difference. btrfs fi show says still 
200/200. I'll try to play with it.
>
--
Martin Mlynář
