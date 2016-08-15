Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:35140 "EHLO
	mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750977AbcHOFvG (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 15 Aug 2016 01:51:06 -0400
Received: by mail-wm0-f65.google.com with SMTP id i5so9358697wmg.2
        for <linux-btrfs@vger.kernel.org>; Sun, 14 Aug 2016 22:51:06 -0700 (PDT)
Subject: Re: Likelihood of read error, recover device failure raid10
To: Chris Murphy <lists@colorremedies.com>,
        Wolfgang Mader <Wolfgang_Mader@brain-frog.de>
References: <2336793.AMaAIAxWk4@discus>
 <CAJCQCtR1odXy1WjR3+tWZsb=d1=VFdpZiFk90oPeykoDTvw1Uw@mail.gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
From: Andrei Borzenkov <arvidjaar@gmail.com>
Message-ID: <f7f00f5d-4185-c235-1e73-2c608d05ee24@gmail.com>
Date: Mon, 15 Aug 2016 08:51:02 +0300
MIME-Version: 1.0
In-Reply-To: <CAJCQCtR1odXy1WjR3+tWZsb=d1=VFdpZiFk90oPeykoDTvw1Uw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

14.08.2016 19:20, Chris Murphy пишет:
> 
> As an aside, I'm finding the size information for the data chunk in
> 'fi us' confusing...
> 
> The sample file system contains one file:
> [root@f24s ~]# ls -lh /mnt/0
> total 1.4G
> -rw-r--r--. 1 root root 1.4G Aug 13 19:24
> Fedora-Workstation-Live-x86_64-25-20160810.n.0.iso
> 
> 
> [root@f24s ~]# btrfs fi us /mnt/0
> Overall:
>     Device size:         400.00GiB
>     Device allocated:           8.03GiB
>     Device unallocated:         391.97GiB
>     Device missing:             0.00B
>     Used:               2.66GiB
>     Free (estimated):         196.66GiB    (min: 196.66GiB)
>     Data ratio:                  2.00
>     Metadata ratio:              2.00
>     Global reserve:          16.00MiB    (used: 0.00B)
> 
> ## "Device size" is total volume or pool size, "Used" shows actual
> usage accounting for the replication of raid1, and yet "Free" shows
> 1/2. This can't work long term as by the time I have 100GiB in the
> volume, Used will report 200Gib while Free will report 100GiB for a
> total of 300GiB which does not match the device size. So that's a bug
> in my opinion.
> 

Well, it says "estimated". It shows how much you could possibly write
using current allocation profile(s). There is no way to predict actual
space usage if you mix allocation profiles.

I agree that having single field that is referring to virtual capacity
among fields showing physical consumption is confusing.

> Data,RAID10: Size:2.00GiB, Used:1.33GiB
>    /dev/mapper/VG-1     512.00MiB
>    /dev/mapper/VG-2     512.00MiB
>    /dev/mapper/VG-3     512.00MiB
>    /dev/mapper/VG-4     512.00MiB
> 
> ## The file is 1.4GiB but the Used reported is 1.33GiB? That's weird.

I think this is difference between rounding done by ls and internal
btrfs counting. I bet if you show size in KiB (or even 512B) you will
get better match.

> And now in this area the user is somehow expected to know that all of
> these values are 1/2 their actual value due to the RAID10. I don't
> like this inconsistency for one. But it's made worse by using the
> secret decoder ring method of usage when it comes to individual device
> allocations. Very clearly Size if really 4, and each device has a 1GiB
> chunk. So why not say that? This is consistent with the earlier
> "Device allocated" value of 8GiB.
> 
> 

This looks like a bug in RAID10. In RAID1 output is consistent with Size
showing virtual size and each disk allocated size matching it. This is
openSUSE Tumbleweed with brfsprogs 4.7 and kernel 4.7.

