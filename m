Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp-18-i2.italiaonline.it ([212.48.25.198]:52140 "EHLO
	smtp-18.italiaonline.it" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932414AbaLJSYW (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 10 Dec 2014 13:24:22 -0500
Message-ID: <5488901F.9090107@inwind.it>
Date: Wed, 10 Dec 2014 19:25:35 +0100
From: Goffredo Baroncelli <kreijack@inwind.it>
Reply-To: kreijack@inwind.it
MIME-Version: 1.0
To: Robert White <rwhite@pobox.com>,
        Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
CC: lists@colorremedies.com, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: get more accurate output in fd command.
References: <B3CDA0F0-14F7-4539-B7FF-B2D2E5F7CAF2@colorremedies.com> <1418124037-8210-1-git-send-email-yangds.fnst@cn.fujitsu.com> <548743CE.1020403@inwind.it> <54879CFE.1090909@cn.fujitsu.com> <54882634.4000809@pobox.com>
In-Reply-To: <54882634.4000809@pobox.com>
Content-Type: text/plain; charset=windows-1252
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 12/10/2014 11:53 AM, Robert White wrote:
> On 12/09/2014 05:08 PM, Dongsheng Yang wrote:
>> On 12/10/2014 02:47 AM, Goffredo Baroncelli wrote:
>>> Hi Dongsheng On 12/09/2014 12:20 PM, Dongsheng Yang wrote:
>>>> When function btrfs_statfs() calculate the tatol size of fs, it
>>>> is calculating the total size of disks and then dividing it by
>>>> a factor. But in some usecase, the result is not good to user.
>>>> 
>>>> Example: # mkfs.btrfs -f /dev/vdf1 /dev/vdf2 -d raid1 # mount
>>>> /dev/vdf1 /mnt # dd if=/dev/zero of=/mnt/zero bs=1M count=1000 
>>>> # df -h /mnt Filesystem      Size  Used Avail Use% Mounted on 
>>>> /dev/vdf1       3.0G 1018M  1.3G  45% /mnt
>>>> 
>>>> # btrfs fi show /dev/vdf1 Label: none  uuid:
>>>> f85d93dc-81f4-445d-91e5-6a5cd9563294 Total devices 2 FS bytes
>>>> used 1001.53MiB devid    1 size 2.00GiB used 1.85GiB path
>>>> /dev/vdf1 devid    2 size 4.00GiB used 1.83GiB path /dev/vdf2
>>>> 
>>>> a. df -h should report Size as 2GiB rather than as 3GiB. 
>>>> Because this is 2 device raid1, the limiting factor is devid 1
>>>> @2GiB.
>>> I agree
> 
> NOPE.
> 
> The model you propose is too simple.
> 
> While the data portion of the file system is set to RAID1 the
> metadata portion of the filesystem is still set to the default of
> DUP. As such it is impossible to guess how much space is "free" since
> it is unknown how the space will be used before hand.


Hi Robert,

sorry but you are talking about a different problem.
Yang is  trying to solve a problem where it is impossible to fill
all the disk space because some portion is not raid1 protected. So
it is incorrect to report all space/2 as free space.

Instead you are stating that *if* the metadata are stored as DUP (and
is not this case, because the metadata are raid1, see below), it is possible
to fill all the disk space.

This is a complex problem. The fact that BTRFS allows different
raid levels causes to be very difficult to evaluate the free space (
as space available directly to the user). There is no a simple answer.

I am still convinced that the best free space *estimation* is considering
the ratio disk-space-consumed/file-allocated constant, and evaluate
the free space as the 

disk-space-unused*file-allocate/disk-space-consumed.

Of course there are pathological cases that make this
prediction fails completely. But I consider the best estimation
possible for the average users.

But again this is a different problem that the one raised by 
Yang.



[...]

> IF you wanted everything to be RAID-1 you should have instead done

> # mkfs.btrfs -f /dev/vdf1 /dev/vdf2 -d raid1 -m raid1
> 
> The mistake is yours, rest of you analysis is, therefore, completely
> inapplicable. Please read all the documentation before making that
> sort of filesystem. Your data will thank you later.
> 
> DSCLAIMER: I have _not_ looked at the numbers you would get if you
> used the corrected command.

Sorry, but you are wrong. Doing mkfs.btrfs -d raid1 /dev/loop[01] leads 
to have both data and metadata  in raid1. IIRC if you have more than
one disks, the metadata switched to raid1 automatically.

$ sudo mkfs.btrfs -d raid1 /dev/loop[01]
Btrfs v3.17
See http://btrfs.wiki.kernel.org for more information.

Performing full device TRIM (10.00GiB) ...
Turning ON incompat feature 'extref': increased hardlink limit per file to 65536
Performing full device TRIM (30.00GiB) ...
adding device /dev/loop1 id 2
fs created label (null) on /dev/loop0
	nodesize 16384 leafsize 16384 sectorsize 4096 size 40.00GiB
ghigo@venice:/tmp$ sudo mount /dev/loop0 t/
ghigo@venice:/tmp$ sudo dd if=/dev/zero of=t/fill bs=4M count=10
10+0 records in
10+0 records out
41943040 bytes (42 MB) copied, 0.018853 s, 2.2 GB/s
ghigo@venice:/tmp$ sync
ghigo@venice:/tmp$ sudo btrfs fi df t/
Data, RAID1: total=1.00GiB, used=40.50MiB
Data, single: total=8.00MiB, used=0.00B
System, RAID1: total=8.00MiB, used=16.00KiB
System, single: total=4.00MiB, used=0.00B
Metadata, RAID1: total=1.00GiB, used=160.00KiB
Metadata, single: total=8.00MiB, used=0.00B
GlobalReserve, single: total=16.00MiB, used=0.00B

[...]

-- 
gpg @keyserver.linux.it: Goffredo Baroncelli <kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
