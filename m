Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f65.google.com ([209.85.218.65]:33999 "EHLO
	mail-oi0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752813AbcD0A6I (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 26 Apr 2016 20:58:08 -0400
Received: by mail-oi0-f65.google.com with SMTP id b10so4314264oig.1
        for <linux-btrfs@vger.kernel.org>; Tue, 26 Apr 2016 17:58:07 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAHaPQf39H-JRhQmCssmgJ98RCxL_36poE_kObAmgmH6nkn4xoA@mail.gmail.com>
References: <CAHaPQf0-qh0sLpUotSdESi8W6dnMOBQPXVJvBP8f2sEj2MC9EA@mail.gmail.com>
	<pan$c3f48$4829429e$7ab0117b$7d124f52@cox.net>
	<571DFCF2.6050604@gmail.com>
	<pan$193a9$b381fd2b$1c0f329f$7b14e34b@cox.net>
	<571E154C.9060604@gmail.com>
	<CAHaPQf03yMAxMZRa=zr3Fjh_B+-ggwwuzRFwDsUyK3t=jW2WFw@mail.gmail.com>
	<571F4CD0.9050004@gmail.com>
	<CAHaPQf39H-JRhQmCssmgJ98RCxL_36poE_kObAmgmH6nkn4xoA@mail.gmail.com>
Date: Tue, 26 Apr 2016 18:58:06 -0600
Message-ID: <CAJCQCtQbCbR9V7z4jZCejbKLJyhBbtrZJmcQBkX=VnxReBf46g@mail.gmail.com>
Subject: Re: Add device while rebalancing
From: Chris Murphy <lists@colorremedies.com>
To: Juan Alberto Cirez <jacirez@rdcsafety.com>
Cc: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Apr 26, 2016 at 5:44 AM, Juan Alberto Cirez
<jacirez@rdcsafety.com> wrote:
> Well,
> RAID1 offers no parity, striping, or spanning of disk space across
> multiple disks.

Btrfs raid1 does span, although it's typically called the "volume", or
a "pool" similar to ZFS terminology. e.g. 10 2TiB disks will get you a
single volume on which you can store about 10TiB of data with two
copies (called stripes in Btrfs). In effect the way chunk replication
works, it's a concat+raid1.


> RAID10 configuration, on the other hand, requires a minimum of four
> HDD, but it stripes data across mirrored pairs. As long as one disk in
> each mirrored pair is functional, data can be retrieved.

Not Btrfs raid10. It's not the devices that are mirrored pairs, but
rather the chunks. There's no way to control or determine on what
devices the pairs are on. It's certain you get at least a partial
failure (data for sure and likely metadata if it's also using raid10
profile) of the volume if you lose more than 1 device, planning wise
you have to assume you lose the entire array.



>
> With GlusterFS as a distributed volume, the files are already spread
> among the servers causing file I/O to be spread fairly evenly among
> them as well, thus probably providing the benefit one might expect
> with stripe (RAID10).

Yes, the raid1 of Btrfs is just so you don't have to rebuild volumes
if you lose a drive. But since raid1 is not n-way copies, and only
means two copies, you don't really want the file systems getting that
big or you increase the chances of a double failure.

I've always though it'd be neat in a Btrfs + GlusterFS, if it were
possible for Btrfs to inform Gluster FS of "missing/corrupt" files,
and then for Btrfs to drop reference for those files, instead of
either rebuilding or remaining degraded. And then let GlusterFS deal
with replication of those files to maintain redundancy. i.e. the Btrfs
volumes would be single profile for data, and raid1 for metadata. When
there's n-way raid1, each drive can have a copy of the file system,
and it'd tolerate in effect n-1 drive failures and the file system
could at least still inform Gluster (or Ceph) of the missing data, the
file system still remains valid, only briefly degraded, and can still
be expanded when new drives become available.

I'm not a big fan of hot (or cold) spares. They contribute nothing,
but take up physical space and power.




-- 
Chris Murphy
