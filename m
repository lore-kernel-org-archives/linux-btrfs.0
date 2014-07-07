Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wg0-f42.google.com ([74.125.82.42]:36429 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751424AbaGGQ5N (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 7 Jul 2014 12:57:13 -0400
Received: by mail-wg0-f42.google.com with SMTP id n12so2901588wgh.1
        for <linux-btrfs@vger.kernel.org>; Mon, 07 Jul 2014 09:57:12 -0700 (PDT)
Message-ID: <53BAD165.808@lianse.eu>
Date: Mon, 07 Jul 2014 18:57:09 +0200
From: =?UTF-8?B?QW5kcsOpLVNlYmFzdGlhbiBMaWViZQ==?= <andre@lianse.eu>
MIME-Version: 1.0
To: Austin S Hemmelgarn <ahferroin7@gmail.com>,
        Konstantinos Skarlatos <k.skarlatos@gmail.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: mount time of multi-disk arrays
References: <53BAA2E5.2090801@lianse.eu> <53BAA67D.1050101@gmail.com> <53BAAB37.7030800@gmail.com>
In-Reply-To: <53BAAB37.7030800@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 07/07/2014 04:14 PM, Austin S Hemmelgarn wrote:
> On 2014-07-07 09:54, Konstantinos Skarlatos wrote:
>> On 7/7/2014 4:38 μμ, André-Sebastian Liebe wrote:
>>> Hello List,
>>>
>>> can anyone tell me how much time is acceptable and assumable for a
>>> multi-disk btrfs array with classical hard disk drives to mount?
>>>
>>> I'm having a bit of trouble with my current systemd setup, because it
>>> couldn't mount my btrfs raid anymore after adding the 5th drive. With
>>> the 4 drive setup it failed to mount once in a few times. Now it fails
>>> everytime because the default timeout of 1m 30s is reached and mount is
>>> aborted.
>>> My last 10 manual mounts took between 1m57s and 2m12s to finish.
>> I have the exact same problem, and have to manually mount my large
>> multi-disk btrfs filesystems, so I would be interested in a solution as
>> well.
>>
>>> My hardware setup contains a
>>> - Intel Core i7 4770
>>> - Kernel 3.15.2-1-ARCH
>>> - 32GB RAM
>>> - dev 1-4 are 4TB Seagate ST4000DM000 (5900rpm)
>>> - dev 5 is a 4TB Wstern Digital WDC WD40EFRX (5400rpm)
>>>
>>> Thanks in advance
>>>
>>> André-Sebastian Liebe
>>> --------------------------------------------------------------------------------------------------
>>>
>>>
>>> # btrfs fi sh
>>> Label: 'apc01_pool0'  uuid: 066141c6-16ca-4a30-b55c-e606b90ad0fb
>>>          Total devices 5 FS bytes used 14.21TiB
>>>          devid    1 size 3.64TiB used 2.86TiB path /dev/sdd
>>>          devid    2 size 3.64TiB used 2.86TiB path /dev/sdc
>>>          devid    3 size 3.64TiB used 2.86TiB path /dev/sdf
>>>          devid    4 size 3.64TiB used 2.86TiB path /dev/sde
>>>          devid    5 size 3.64TiB used 2.88TiB path /dev/sdb
>>>
>>> Btrfs v3.14.2-dirty
>>>
>>> # btrfs fi df /data/pool0/
>>> Data, single: total=14.28TiB, used=14.19TiB
>>> System, RAID1: total=8.00MiB, used=1.54MiB
>>> Metadata, RAID1: total=26.00GiB, used=20.20GiB
>>> unknown, single: total=512.00MiB, used=0.00
> This is interesting, I actually did some profiling of the mount timings
> for a bunch of different configurations of 4 (identical other than
> hardware age) 1TB Seagate disks.  One of the arrangements I tested was
> Data using single profile and Metadata/System using RAID1.  Based on the
> results I got, and what you are reporting, the mount time doesn't scale
> linearly in proportion to the amount of storage space.
>
> You might want to try the RAID10 profile for Metadata, of the
> configurations I tested, the fastest used Single for Data and RAID10 for
> Metadata/System.
Switching Metadata from raid1 to raid10 reduced mount times from roughly
120s to 38s!
>
> Also, based on the System chunk usage, I'm guessing that you have a LOT
> of subvolumes/snapshots, and I do know that having very large (100+)
> numbers of either does slow down the mount command (I don't think that
> we cache subvolume information between mount invocations, so it has to
> re-parse the system chunks for each individual mount).
No, I had to remove the one and only snapshot to recover from a 'no
space left on device' to regain metadata space
(http://marc.merlins.org/perso/btrfs/post_2014-05-04_Fixing-Btrfs-Filesystem-Full-Problems.html)

-- 
André-Sebastian Liebe

