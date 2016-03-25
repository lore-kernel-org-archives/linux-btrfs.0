Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f181.google.com ([209.85.213.181]:34177 "EHLO
	mail-ig0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754384AbcCYVeM (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 25 Mar 2016 17:34:12 -0400
Received: by mail-ig0-f181.google.com with SMTP id av4so19897477igc.1
        for <linux-btrfs@vger.kernel.org>; Fri, 25 Mar 2016 14:34:11 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAA7pwKP90OTQLdOw4LHtGxZEBWhz3bZCam2E2-CHwA1p9CMdnA@mail.gmail.com>
References: <1458906560.3786108.559411242.3678497C@webmail.messagingengine.com>
	<CAA7pwKNj+qEUk+RhzyceRFqThzhUkroYMxS3b3gAn_5KEyawMQ@mail.gmail.com>
	<CAA7pwKNgDi9C8E+duwNA6H8MrT1nVEHkWAm4=JZp3GjFgAvZ1g@mail.gmail.com>
	<1458926454.3855039.559662618.4F365498@webmail.messagingengine.com>
	<CAA7pwKP90OTQLdOw4LHtGxZEBWhz3bZCam2E2-CHwA1p9CMdnA@mail.gmail.com>
Date: Fri, 25 Mar 2016 15:34:11 -0600
Message-ID: <CAJCQCtS+VY8ecwAVwjE9Tm=x4=vnNSbd19ssc4+=cBigs7K2Jw@mail.gmail.com>
Subject: Re: Possible Raid Bug
From: Chris Murphy <lists@colorremedies.com>
To: Patrik Lundquist <patrik.lundquist@gmail.com>
Cc: Stephen Williams <stephenw@veryfast.biz>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Mar 25, 2016 at 1:57 PM, Patrik Lundquist
<patrik.lundquist@gmail.com> wrote:

>
> Only errors on the device formerly known as /dev/sde, so why won't it
> mount degraded,rw? Now I'm stuck like Stephen.
>
> # btrfs device usage /mnt
> /dev/sdb, ID: 1
>    Device size:             2.00GiB
>    Data,single:           624.00MiB       <<----------
>    Data,RAID10:           102.38MiB
>    Metadata,RAID10:       102.38MiB
>    System,RAID10:           4.00MiB
>    Unallocated:             1.19GiB
>
> /dev/sdc, ID: 2
>    Device size:             2.00GiB
>    Data,RAID10:           102.38MiB
>    Metadata,RAID10:       102.38MiB
>    System,single:          32.00MiB       <<----------
>    System,RAID10:           4.00MiB
>    Unallocated:             1.76GiB
>
> /dev/sdd, ID: 3
>    Device size:             2.00GiB
>    Data,RAID10:           102.38MiB
>    Metadata,single:       256.00MiB       <<----------
>    Metadata,RAID10:       102.38MiB
>    System,RAID10:           4.00MiB
>    Unallocated:             1.55GiB
>
> missing, ID: 4
>    Device size:               0.00B
>    Data,RAID10:           102.38MiB
>    Metadata,RAID10:       102.38MiB
>    System,RAID10:           4.00MiB
>    Unallocated:             1.80GiB
>
> The data written while mounted degraded is in profile 'single' and
> will have to be converted to 'raid10' once the filesystem is whole
> again.
>
> So what do I do now? Why did it degrade further after a reboot?

You're hosed. The file system is read only and can't be fixed. It's an
old bug. It's not a data loss bug, but it's major time loss bug
because now the volume has to be rebuilt, and totally unworkable for
production use.

While the appearance of the single chunks is one bug that shouldn't
happen, the worse bug is the truly bogus one that claims there aren't
enough drives for rw degraded mount. Those single chunks aren't on the
missing drive. They're on the three remaining ones. So the rw fail is
just a bad bug. It's a PITA but at least it's not a data loss bug.

Basically you get one chance to mount rw,degraded and you have to fix
the problem at that time. And you have to balance away any phantom
single chunks that have appeared. For what it's worth it's not the
reboot that degraded it further, it's the unmount and then attempt to
mount rw,degraded a 2nd time that's not allowed due to this bug.


-- 
Chris Murphy
