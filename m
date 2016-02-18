Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lb0-f178.google.com ([209.85.217.178]:34929 "EHLO
	mail-lb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1426824AbcBRSTK (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 18 Feb 2016 13:19:10 -0500
Received: by mail-lb0-f178.google.com with SMTP id bc4so33587534lbc.2
        for <linux-btrfs@vger.kernel.org>; Thu, 18 Feb 2016 10:19:10 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <b9e02f6f-dc3e-94c1-1a60-30192206c95e@mokrynskyi.com>
References: <b9e02f6f-dc3e-94c1-1a60-30192206c95e@mokrynskyi.com>
Date: Thu, 18 Feb 2016 19:19:09 +0100
Message-ID: <CAPmG0ja7T9waYuBagRjDdGQutrcgA3nPygmLUMjGaT5owWX1sg@mail.gmail.com>
Subject: Re: Major HDD performance degradation on btrfs receive
From: Henk Slager <eye1tm@gmail.com>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Feb 16, 2016 at 5:44 AM, Nazar Mokrynskyi <nazar@mokrynskyi.com> wrote:
> I have 2 SSD with BTRFS filesystem (RAID) on them and several subvolumes.
> Each 15 minutes I'm creating read-only snapshot of subvolumes /root, /home
> and /web inside /backup.
> After this I'm searching for last common subvolume on /backup_hdd, sending
> difference between latest common snapshot and simply latest snapshot to
> /backup_hdd.
> On top of all above there is snapshots rotation, so that /backup contains
> much less snapshots than /backup_hdd.
>
> I'm using this setup for last 7 months or so and this is luckily the longest
> period when I had no problems with BTRFS at all.
> However, last 2+ months btrfs receive command loads HDD so much that I can't
> even get list of directories in it.
> This happens even if diff between snapshots is really small.
> HDD contains 2 filesystems - mentioned BTRFS and ext4 for other files, so I
> can't even play mp3 file from ext4 filesystem while btrfs receive is
> running.
> Since I'm running everything each 15 minutes this is a real headache.
>
> My guess is that performance hit might be caused by filesystem fragmentation
> even though there is more than enough empty space. But I'm not sure how to
> properly check this and can't, obviously, run defragmentation on read-only
> subvolumes.
>
> I'll be thankful for anything that might help to identify and resolve this
> issue.
>
> ~> uname -a
> Linux nazar-pc 4.5.0-rc4-haswell #1 SMP Tue Feb 16 02:09:13 CET 2016 x86_64
> x86_64 x86_64 GNU/Linux
>
> ~> btrfs --version
> btrfs-progs v4.4
>
> ~> sudo btrfs fi show
> Label: none  uuid: 5170aca4-061a-4c6c-ab00-bd7fc8ae6030
>     Total devices 2 FS bytes used 71.00GiB
>     devid    1 size 111.30GiB used 111.30GiB path /dev/sdb2
>     devid    2 size 111.30GiB used 111.29GiB path /dev/sdc2
>
> Label: 'Backup'  uuid: 40b8240a-a0a2-4034-ae55-f8558c0343a8
>     Total devices 1 FS bytes used 252.54GiB
>     devid    1 size 800.00GiB used 266.08GiB path /dev/sda1
>
> ~> sudo btrfs fi df /
> Data, RAID0: total=214.56GiB, used=69.10GiB
> System, RAID1: total=8.00MiB, used=16.00KiB
> System, single: total=4.00MiB, used=0.00B
> Metadata, RAID1: total=4.00GiB, used=1.87GiB
> Metadata, single: total=8.00MiB, used=0.00B
> GlobalReserve, single: total=512.00MiB, used=0.00B
>
> ~> sudo btrfs fi df /backup_hdd
> Data, single: total=245.01GiB, used=243.61GiB
> System, DUP: total=32.00MiB, used=48.00KiB
> System, single: total=4.00MiB, used=0.00B
> Metadata, DUP: total=10.50GiB, used=8.93GiB
> Metadata, single: total=8.00MiB, used=0.00B
> GlobalReserve, single: total=512.00MiB, used=0.00B
>
> Relevant mount options:
> UUID=5170aca4-061a-4c6c-ab00-bd7fc8ae6030    / btrfs
> compress=lzo,noatime,relatime,ssd,subvol=/root    0 1
> UUID=5170aca4-061a-4c6c-ab00-bd7fc8ae6030    /home btrfs
> compress=lzo,noatime,relatime,ssd,subvol=/home 0    1
> UUID=5170aca4-061a-4c6c-ab00-bd7fc8ae6030    /backup btrfs
> compress=lzo,noatime,relatime,ssd,subvol=/backup 0    1
> UUID=5170aca4-061a-4c6c-ab00-bd7fc8ae6030    /web btrfs
> compress=lzo,noatime,relatime,ssd,subvol=/web 0    1
> UUID=40b8240a-a0a2-4034-ae55-f8558c0343a8    /backup_hdd btrfs
> compress=lzo,noatime,relatime,noexec 0    1

As already indicated by Duncan, the amount of snapshots might be just
too much. The fragmentation on the HDD might have become very high. If
there is limited amount of RAM in the system (so limited caching), too
much time is lost in seeks. In addition:

 compress=lzo
this also increases the chance of scattering fragments and fragmentation.

 noatime,relatime
I am not sure why you have this. Hopefully you have the actual mount
listed as   noatime

You could use the principles of the tool/package called  snapper  to
do a sort of non-linear snapshot thinning: further back in time you
will have a much higher granularity of snapshot over a certain
timeframe.

You could use skinny metadata (recreate the fs with newer tools or use
btrfstune -x on /dev/sda1). I think at the moment this flag is not
enabled on /dev/sda1

If you put just 1 btrfs fs on the hdd (so move all the content from
the ext4 fs in the the btrfs fs) you might get better overall
performance. I assume the ext4 fs is on the second (slower part) of
the HDD and that is a disadvantage I think.
But you probably have reasons for why the setup is like it is.
