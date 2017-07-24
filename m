Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f52.google.com ([74.125.82.52]:38411 "EHLO
        mail-wm0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752336AbdGXUfG (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 24 Jul 2017 16:35:06 -0400
Received: by mail-wm0-f52.google.com with SMTP id m85so26764370wma.1
        for <linux-btrfs@vger.kernel.org>; Mon, 24 Jul 2017 13:35:06 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1500895655.2781.6.camel@cloud.haefemeier.eu>
References: <1500895655.2781.6.camel@cloud.haefemeier.eu>
From: Chris Murphy <lists@colorremedies.com>
Date: Mon, 24 Jul 2017 14:35:05 -0600
Message-ID: <CAJCQCtT3nEaHox7jiO-jf6hCjpUSRz=AahrapgZDajJdeYr1Rw@mail.gmail.com>
Subject: Re: Best Practice: Add new device to RAID1 pool
To: Cloud Admin <admin@cloud.haefemeier.eu>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jul 24, 2017 at 5:27 AM, Cloud Admin <admin@cloud.haefemeier.eu> wrote:

> I am a little bit confused because the balance command is running since
> 12 hours and only 3GB of data are touched.

That's incredibly slow. Something isn't right.

Using btrfs-debug -b from btrfs-progs, I've selected a few 100% full chunks.

[156777.077378] f26s.localdomain sudo[13757]:    chris : TTY=pts/2 ;
PWD=/home/chris ; USER=root ; COMMAND=/sbin/btrfs balance start
-dvrange=157970071552..159043813376 /
[156773.328606] f26s.localdomain kernel: BTRFS info (device sda1):
relocating block group 157970071552 flags data
[156800.408918] f26s.localdomain kernel: BTRFS info (device sda1):
found 38952 extents
[156861.343067] f26s.localdomain kernel: BTRFS info (device sda1):
found 38951 extents

That 1GiB chunk with quite a few fragments took 88s. That's 11MB/s.
Even for a hard drive, that's slow. I've got maybe a dozen snapshots
on this particular volume and quotas are not enabled. By definition
all of those extents are sequential. So I'm not sure why it's taking
so long. Seems almost like a regression somewhere. A nearby chunk with
~23k extents only takes 45s to balance. And another chunk with ~32000
extents took 55s to balance.

4.11.10-300.fc26.x86_64
btrfs-progs-4.11.1-1.fc27.x86_64

But what you are experiencing is a orders of magnitude worse than what
I'm experiencing. What kernel and progs are you using?

Track down debug-btrfs in the root of
https://github.com/kdave/btrfs-progs  and point it to the mounted
volume with -b so something like
sudo btrfs-debug -b /srv/scratch

Also do you have any output from kernel messages like above "relocated
block group" and "found extents" how many extents in these bg's that
have been relocated?

I don't know if this is a helpful comparison but I'm finding 'btrfs
inspect-internal tree-stats'.

[chris@f26s ~]$ sudo btrfs inspect tree-stats /dev/sda1
WARNING: /dev/sda1 already mounted, results may be inaccurate
Calculating size of root tree
    Total size: 64.00KiB
        Inline data: 0.00B
    Total seeks: 3
        Forward seeks: 2
        Backward seeks: 1
        Avg seek len: 4.82MiB
    Total clusters: 1
        Avg cluster size: 0.00B
        Min cluster size: 0.00B
        Max cluster size: 16.00KiB
    Total disk spread: 6.50MiB
    Total read time: 0 s 3 us
    Levels: 2
Calculating size of extent tree
    Total size: 63.03MiB
        Inline data: 0.00B
    Total seeks: 3613
        Forward seeks: 1801
        Backward seeks: 1812
        Avg seek len: 15.19GiB
    Seek histogram
              16384 -      147456:         546 ###
             180224 -     5554176:         540 ###
            5718016 -    22200320:         540 ###
           22265856 -    96534528:         540 ###
           96616448 - 47356215296:         540 ###
        47357067264 - 64038076416:         540 ###
        64038371328 - 64525729792:         346 #
    Total clusters: 295
        Avg cluster size: 38.78KiB
        Min cluster size: 32.00KiB
        Max cluster size: 128.00KiB
    Total disk spread: 60.12GiB
    Total read time: 0 s 1338 us
    Levels: 3
Calculating size of csum tree
    Total size: 67.44MiB
        Inline data: 0.00B
    Total seeks: 3368
        Forward seeks: 2167
        Backward seeks: 1201
        Avg seek len: 12.95GiB
    Seek histogram
              16384 -       65536:         532 ###
              98304 -      720896:         504 ###
             753664 -    37404672:         504 ###
           38125568 -   215547904:         504 ###
          216481792 - 47522119680:         504 ###
        47522430976 - 63503482880:         505 ###
        63508348928 - 64503119872:         267 #
    Total clusters: 389
        Avg cluster size: 54.75KiB
        Min cluster size: 32.00KiB
        Max cluster size: 640.00KiB
    Total disk spread: 60.12GiB
    Total read time: 0 s 139678 us
    Levels: 3
Calculating size of fs tree
    Total size: 48.00KiB
        Inline data: 0.00B
    Total seeks: 2
        Forward seeks: 0
        Backward seeks: 2
        Avg seek len: 62.95MiB
    Total clusters: 1
        Avg cluster size: 0.00B
        Min cluster size: 0.00B
        Max cluster size: 16.00KiB
    Total disk spread: 125.86MiB
    Total read time: 0 s 19675 us
    Levels: 2
[chris@f26s ~]$


I don't think the number of snapshots you have for Docker containers
is the problem. There's this thread (admittedly on SSD) which suggests
decent performance is possible with thousands of containers per day
(100,000 - 200,000 per day but I don't think that's per file system,
I'm actually not sure how many file systems are involved).

https://www.spinics.net/lists/linux-btrfs/msg67308.html



-- 
Chris Murphy
