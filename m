Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vk0-f44.google.com ([209.85.213.44]:33930 "EHLO
	mail-vk0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753886AbcGDVNx (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 4 Jul 2016 17:13:53 -0400
Received: by mail-vk0-f44.google.com with SMTP id c2so243250849vkg.1
        for <linux-btrfs@vger.kernel.org>; Mon, 04 Jul 2016 14:13:53 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAKinxcVHevoWzgYO+1tjiGOow=shc=oBpvRrTSedeAn1raUrXA@mail.gmail.com>
References: <CAKinxcVHevoWzgYO+1tjiGOow=shc=oBpvRrTSedeAn1raUrXA@mail.gmail.com>
From: Henk Slager <eye1tm@gmail.com>
Date: Mon, 4 Jul 2016 23:13:52 +0200
Message-ID: <CAPmG0jYfdYt81E8oaky53eYmy69tWgpLkRFWXRxGF_d3g3Uhjg@mail.gmail.com>
Subject: Re: btrfs RAID 10 truncates files over 2G to 4096 bytes.
To: Tomasz Kusmierz <tom.kusmierz@gmail.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Jul 3, 2016 at 1:36 AM, Tomasz Kusmierz <tom.kusmierz@gmail.com> wrote:
> Hi,
>
> My setup is that I use one file system for / and /home (on SSD) and a
> larger raid 10 for /mnt/share (6 x 2TB).
>
> Today I've discovered that 14 of files that are supposed to be over
> 2GB are in fact just 4096 bytes. I've checked the content of those 4KB
> and it seems that it does contain information that were at the
> beginnings of the files.
>
> I've experienced this problem in the past (3 - 4 years ago ?) but
> attributed it to different problem that I've spoke with you guys here
> about (corruption due to non ECC ram). At that time I did deleted
> files affected (56) and similar problem was discovered a year but not
> more than 2 years ago and I believe I've deleted the files.
>
> I periodically (once a month) run a scrub on my system to eliminate
> any errors sneaking in. I believe I did a balance a half a year ago ?
> to reclaim space after I deleted a large database.
>
> root@noname_server:/mnt/share# btrfs fi show
> Label: none  uuid: 060c2345-5d2f-4965-b0a2-47ed2d1a5ba2
>     Total devices 1 FS bytes used 177.19GiB
>     devid    3 size 899.22GiB used 360.06GiB path /dev/sde2
>
> Label: none  uuid: d4cd1d5f-92c4-4b0f-8d45-1b378eff92a1
>     Total devices 6 FS bytes used 4.02TiB
>     devid    1 size 1.82TiB used 1.34TiB path /dev/sdg1
>     devid    2 size 1.82TiB used 1.34TiB path /dev/sdh1
>     devid    3 size 1.82TiB used 1.34TiB path /dev/sdi1
>     devid    4 size 1.82TiB used 1.34TiB path /dev/sdb1
>     devid    5 size 1.82TiB used 1.34TiB path /dev/sda1
>     devid    6 size 1.82TiB used 1.34TiB path /dev/sdf1
>
> root@noname_server:/mnt/share# uname -a
> Linux noname_server 4.4.0-28-generic #47-Ubuntu SMP Fri Jun 24
> 10:09:13 UTC 2016 x86_64 x86_64 x86_64 GNU/Linux
> root@noname_server:/mnt/share# btrfs --version
> btrfs-progs v4.4
> root@noname_server:/mnt/share#
>
>
> Problem is that stuff on this filesystem moves so slowly that it's
> hard to remember historical events ... it's like AWS glacier. What I
> can state with 100% certainty is that:
> - files that are affected are 2GB and over (safe to assume 4GB and over)
> - files affected were just read (and some not even read) never written
> after putting into storage
> - In the past I've assumed that files affected are due to size, but I
> have quite few ISO files some backups of virtual machines ... no
> problems there - seems like problem originates in one folder & size >
> 2GB & extension .mkv

In case some application is the root cause of the issue, I would say
try to keep some ro snapshots done by a tool like snapper for example,
but maybe you do that already. It sounds also like this is some kernel
bug, snaphots won't help that much then I think.
