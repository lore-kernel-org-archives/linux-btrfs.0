Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f49.google.com ([209.85.218.49]:33432 "EHLO
        mail-oi0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753832AbcIUCvj (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 20 Sep 2016 22:51:39 -0400
Received: by mail-oi0-f49.google.com with SMTP id r126so45087652oib.0
        for <linux-btrfs@vger.kernel.org>; Tue, 20 Sep 2016 19:51:39 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <566e9000fe30d5b8e0d7e73ebe1d44a0@admin.virtall.com>
References: <566e9000fe30d5b8e0d7e73ebe1d44a0@admin.virtall.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Tue, 20 Sep 2016 20:51:38 -0600
Message-ID: <CAJCQCtQ+uaMCCW81+ePF6scGsTu+MEu1arCQ0wTJhwS8EN8S=A@mail.gmail.com>
Subject: Re: how to understand "btrfs fi show" output? "No space left" issues
To: Tomasz Chmielewski <mangoo@wpkg.org>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Sep 20, 2016 at 12:47 AM, Tomasz Chmielewski <mangoo@wpkg.org> wrote:
> How to understand the following "btrfs fi show" output?
>
> # btrfs fi show /var/lib/lxd
> Label: 'btrfs'  uuid: f5f30428-ec5b-4497-82de-6e20065e6f61
>         Total devices 2 FS bytes used 136.18GiB
>         devid    1 size 423.13GiB used 423.13GiB path /dev/sda3
>         devid    2 size 423.13GiB used 423.13GiB path /dev/sdb3
>
> Why is it "size 423.13GiB used 423.13GiB"? Is it full?
>
> I had "No space left" on this filesystem just yesterday (running kernel
> 4.7.4). This is btrfs RAID-1 on SSD disks. This filesystem is used for 20-30
> LXD containers with different roles (mongo, mysql, postgres databases,
> webservers etc.), around 150 read-only snapshots, btrfs compression is
> disabled.
>
>
> Both "btrfs fi df" and "df -h" show plenty of space:
>
> # btrfs fi df /var/lib/lxd
> Data, RAID1: total=417.12GiB, used=131.33GiB
> System, RAID1: total=8.00MiB, used=80.00KiB
> Metadata, RAID1: total=6.00GiB, used=4.86GiB
> GlobalReserve, single: total=512.00MiB, used=0.00B
>
>
> # df -h
> Filesystem      Size  Used Avail Use% Mounted on
> /dev/sda3       424G  137G  286G  33% /var/lib/lxd

I'm coming into this late and realize most questions have been
answered. But I take the position this is a bug, clearly there's
enough space when df reports only 33% used, and therefore it's
important to gather information about the file system in its current
state so the devs can make decisions. Manually running balance is the
correct work around, but it's bad Ux and should not be necessary (even
though it's known to sometimes be necessary).

Anyway, in this case there is room in all chunks and GlobalReserve
used is 0.00B. Metadata has a bit over a gigabyte of unused space in
its allocated block groups. So at the moment I'm thinking it's a bug.
The two things that'd be useful if you can reproduce this problem at
some point, by NOT trying to prevent it again, are:

grep . -IR /sys/fs/btrfs/<fsuuid>/allocation/

<fsuuid> pick the UUID for the affected fs volume.

btrfs-debugfs found in btrfs-progs upstream as a python program but
typically not packaged by distros
https://github.com/kdave/btrfs-progs/blob/master/btrfs-debugfs

Takes the form:

sudo ./btrfs-debugfs -b <mountpoint>

It'll show you the percent each block group is actually being used so
you can have a good idea what -dusage value to use (in your case) to
free up space. That should help, but ultimately it's a work around,
not a real fix. There shouldn't be enospc anyway.

So if it happens again, first capture the above two bits of
information, and then if  you feel like testing kernel 4.8rc7 do that.
It has a massive pile of enoscp related rework and I bet Josef would
like to know if the problem reproduces with that kernel. As in, just
change kernels, don't try to fix it with balance first.


-- 
Chris Murphy
