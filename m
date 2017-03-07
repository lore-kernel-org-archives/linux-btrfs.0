Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from tartarus.angband.pl ([89.206.35.136]:40541 "EHLO
        tartarus.angband.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754332AbdCGExO (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 6 Mar 2017 23:53:14 -0500
Date: Tue, 7 Mar 2017 03:23:41 +0100
From: Adam Borowski <kilobyte@angband.pl>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, lists@colorremedies.com
Subject: Re: [PATCH v2 0/6] Chunk level degradable check
Message-ID: <20170307022341.phpur3esp5fx5cmd@angband.pl>
References: <20170306085855.11403-1-quwenruo@cn.fujitsu.com>
 <20170307003643.a625476u7ltxjxxh@angband.pl>
 <c07e3381-5a6e-4de6-0d9e-4a397f07726c@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <c07e3381-5a6e-4de6-0d9e-4a397f07726c@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Mar 07, 2017 at 09:35:56AM +0800, Qu Wenruo wrote:
> At 03/07/2017 08:36 AM, Adam Borowski wrote:
> > Not so for -draid5 -mraid1, unfortunately:
> 
> Unfortunately, for raid5 there are still unfixed bugs.
> In fact, some raid5/6 bugs are already fixed, but still not merged yet.
> 
> > [/mnt/btr2/scratch]# btrfs fi us /mnt/vol1
> > Data,RAID5: Size:2.02GiB, Used:1.21GiB
> >    /dev/loop0	   1.01GiB
> >    /dev/loop1	   1.01GiB
> >    /dev/loop2	   1.01GiB

> > [/mnt/btr2/scratch]# umount /mnt/vol1
> > [/mnt/btr2/scratch]# losetup -D
> > [/mnt/btr2/scratch]# losetup -f rb
> > [/mnt/btr2/scratch]# losetup -f rc
> 
> So you're pulling out first device.
> In theory, it should be completely OK for RAID5.
> And the degradable check follows it.
> 
> > [/mnt/btr2/scratch]# mount -noatime,degraded /dev/loop0 /mnt/vol1
> > [/mnt/btr2/scratch]# btrfs fi us /mnt/vol1
> > Data,RAID5: Size:2.02GiB, Used:1.21GiB
> >    /dev/loop0	   1.01GiB
> >    /dev/loop0	   1.01GiB
> >    /dev/loop1	   1.01GiB
> 
> Two loop0 shows up here, which should be detected as missing.
> 
> So it should be a btrfs-progs bug, and it'll be much easier to fix than
> kernel.

Alas, it's not merely a display bug, mounting is enough.

> > Write something, mount degraded again.  Massive data corruption, both on
> > plain reads and on scrub, unrecoverable.
> 
> Yep, same thing here.
> And you'll be surprised that even 2 devices RAID5, which is the same as
> RAID1(parity is the same as data), can still cause the problem.
> 
> So, RAID5/6 definitely has problem in degraded mode.
> While I prefer to focus on normal RAID5/6 bug fix first, and until we solve
> all RAID5/6 normal mode bugs with enough test cases covering them.

Actually, turns out even the _first_ mount gets bad, even without writing a
single data byte.  So it's not related to our single chunks bug.

> > Obviously, this problem is somewhere with RAID5 rather than this patch set,
> > but the safety check can't be removed before that is fixed.
> 
> Do we have *safety check* in original behavior?
> 
> At least v4.11-rc1, btrfs still allows us to mount raid5/6 degraded.
> So the patchset itself is behaving just as old one.

Right.  Thus, there's no regression.

As it's a strict improvement over previous state (ie, fixes raid1 issues),
Tested-by: Adam Borowski <kilobyte@angband.pl> (if you don't mind spamming
commits with too many tags).

> I'm completely fine to add a new patch to prohibit raid5/6 degraded mount,
> but that would be a different enhancement though.

Yeah.  I guess it's more in the "don't use RAID5, there be dragons" land.


Thanks for these patches, they fix the #1 problem people have with RAID1.


[Apologies for that "✔" crap on some lines, my exit code on prompt thingy
is very paste-unfriendly; I keep forgetting it so often that I'd better get
rid of it...]

-- 
⢀⣴⠾⠻⢶⣦⠀ Meow!
⣾⠁⢠⠒⠀⣿⡁
⢿⡄⠘⠷⠚⠋⠀ Collisions shmolisions, let's see them find a collision or second
⠈⠳⣄⠀⠀⠀⠀ preimage for double rot13!
