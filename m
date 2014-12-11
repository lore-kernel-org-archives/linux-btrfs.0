Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from resqmta-ch2-04v.sys.comcast.net ([69.252.207.36]:51388 "EHLO
	resqmta-ch2-04v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932933AbaLKA6a (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 10 Dec 2014 19:58:30 -0500
Message-ID: <5488EC31.8040308@pobox.com>
Date: Wed, 10 Dec 2014 16:58:25 -0800
From: Robert White <rwhite@pobox.com>
MIME-Version: 1.0
To: James West <james@terminalsystems.com>,
        Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: Possibility to have a "transient" snapshot?
References: <5481F91B.6090700@terminalsystems.com> <CAJCQCtTy9SRj1pX4wdQ83hDKf3JU4RfJ9wWTU=+JYbsYd-xiRw@mail.gmail.com> <5488A495.9070404@terminalsystems.com>
In-Reply-To: <5488A495.9070404@terminalsystems.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 12/10/2014 11:52 AM, James West wrote:
> I was just looking into using overlayfs, and although it has some
> promise, I think it's biggest drawback is the upperdir will have to be
> some sort of storage backed filesystem. From my limited understanding of
> tmpfs, it's not supposed to be the greatest with many large files (and
> my system in particular would be downloading many large movies/videos,
> and doing any kind of os update to test it would involve many changes
> all over the volume, which could be problematic to commit to a golden
> state.)
>
> I could partition the main drive in 2 parts, and dynamically zero-out
> then create the volume in the second partition on each boot, but I'm
> still saving no drive writes, and not really extending the life of the
> hardware (which is one of my premises.)

You are over-thinking the "transient" part way too much. If the 
underlying device is not an SSD then most of your wear is immaterial. 
And if it is an SSD, you wear is still pretty damn immaterial.

The "full weight" snapshots are plenty "transient" if you delete them 
between uses and they don't do any recursive copying so they are almost 
wear-free.

[If you want to wear out a hard disk, park it's heads a lot. (The My 
Book series of WD external enclosures had a _horrible_ default of 
parking the heads after every eight seconds of idle time. Ouch.)]

A normal hard disk's runtime (provided its not a lemon) is shorter than 
its mean write wear time anyway.

So the best thing to do in your case is to customize your initramfs to 
do what you need and then "hide" your stuff from normal use. Consider 
this (untested but) hiper-simple init script... (assumes busybox in the 
initramfs providing mount and a few of the other basic tools and the 
btrfs command).

--- snip ---
#!/bin/bash
mkdir /dev
mount -t devtmpfs none /dev
mkdir /scratch
mount -t btrfs /dev/sda1 /scratch
if [ -d /scratch/active ]; then
   btrfs subvol del /scratch/active
fi
btrfs subvol snap /scratch/__Master /scratch/active
mkdir /root
mount -o subvol=/active /dev/sda1 /root
umount /scratch
rmdir /scratch
umount /dev
busybox switch_root /root /sbin/init "$@"
--- snip ---


Every time you boot it makes a fresh snapshot of the /__Master subvolume 
of /dev/sda1 into /active and mounts that as root then
treats that as the root of the file system.

Estimated human-scale time to run this script is in the 
one-second-or-less range.

None of the files in /__Master are then visible to the running system, 
so they won't be subject to search via find or locate etc.

Problem solved.

When you want to do maintenance you can log into you box and do

mount /dev/sda1 /mnt

at which point /__Master is visible as /mnt/__Master.

You can do your backup snapshots and your maintenance via the /mnt view 
without purturbing your running system.

chroot /mnt/__Master /bin/bash

That gives you the "native view" of your master system in that shell. 
 From that shell all your package tools will work just fine etc.

You can prep new or covariant system is snapshots parallel to /__Master 
and use rename to select the __Master for the next reboot.

Even better, since snapshots of snapshots are not degenerate in any way 
at all, you can create multiple system roots as /Whatever and 
/OtherThing (and so on) and always do your maintenance there. Then 
before any reboot you can snap /mnt/Whatever into /mnt/__Master (using 
the same technique as for /active) and then reboot. On that reboot the 
new /__Master will be the master for the new /active.

All of the snapshot activities are almost instant (except for the 
cleanup of the previous /active if it's full of a lot of changes, but 
that will happen in the background so you don't have to care much about 
that time).


ASIDE: And I keep pointing people at it, but I do a lot of experimental 
boot behaviors while testing hardware and such for my job, and my 
baseline initramfs builder at http://underdog.sourceforge.net is easy to 
customize and plenty stable. It already sucks in the btrfs and command 
and friends, and you can take control of the boot-up to do experimental 
tweaks by adding "bash" to the kernel boot args for an individual boot.
