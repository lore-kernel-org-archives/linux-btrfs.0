Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.15.3]:63617 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754678AbaLHWZR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 8 Dec 2014 17:25:17 -0500
Message-ID: <54862547.4040102@web.de>
Date: Mon, 08 Dec 2014 23:25:11 +0100
From: Konstantin <newsbox1026@web.de>
MIME-Version: 1.0
To: Phillip Susi <psusi@ubuntu.com>, MegaBrutal <megabrutal@gmail.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: PROBLEM: #89121 BTRFS mixes up mounted devices with their snapshots
References: <CAE8gLhm8Oma6kWdeJtdc1-U2e4+TJDzhmw2Vfr=CYwvJ78GRJQ@mail.gmail.com> <547CE175.6060409@web.de> <547E10BA.6000707@ubuntu.com> <5484F198.3070206@web.de> <5485BCED.1060705@ubuntu.com>
In-Reply-To: <5485BCED.1060705@ubuntu.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


Phillip Susi schrieb am 08.12.2014 um 15:59:
> On 12/7/2014 7:32 PM, Konstantin wrote:
> >> I'm guessing you are using metadata format 0.9 or 1.0, which put
> >> the metadata at the end of the drive and the filesystem still
> >> starts in sector zero.  1.2 is now the default and would not have
> >> this problem as its metadata is at the start of the disk ( well,
> >> 4k from the start ) and the fs starts further down.
> > I know this and I'm using 0.9 on purpose. I need to boot from
> > these disks so I can't use 1.2 format as the BIOS wouldn't
> > recognize the partitions. Having an additional non-RAID disk for
> > booting introduces a single point of failure which contrary to the
> > idea of RAID>0.
>
> The bios does not know or care about partitions.  All you need is a
That's only true for older BIOSs. With current EFI boards they not only
care but some also mess around with GPT partition tables.
> partition table in the MBR and you can install grub there and have it
> boot the system from a mdadm 1.1 or 1.2 format array housed in a
> partition on the rest of the disk.  The only time you really *have* to
I was thinking of this solution as well but as I'm not aware of any
partitioning tool caring about mdadm metadata so I rejected it. It
requires a non-standard layout leaving reserved empty spaces for mdadm
metadata. It's possible but it isn't documented so far I know and before
losing hours of trying I chose the obvious one.
> use 0.9 or 1.0 ( and you really should be using 1.0 instead since it
> handles larger arrays and can't be confused vis. whole disk vs.
> partition components ) is if you are running a raid1 on the raw disk,
> with no partition table and then partition inside the array instead,
> and really, you just shouldn't be doing that.
That's exactly what I want to do - running RAID1 on the whole disk as
most hardware based RAID systems do. Before that I was running RAID on
disk partitions for some years but this was quite a pain in comparison.
Hot(un)plugging a drive brings you a lot of issues with failing mdadm
commands as they don't like concurrent execution when the same physical
device is affected. And rebuild of RAID partitions is done sequentially
with no deterministic order. We could talk for hours about that but if
interested maybe better in private as it is not BTRFS related.
> > Anyway, to avoid a futile discussion, mdraid and its format is not
> > the problem, it is just an example of the problem. Using dm-raid
> > would do the same trouble, LVM apparently, too. I could think of a
> > bunch of other cases including the use of hardware based RAID
> > controllers. OK, it's not the majority's problem, but that's not
> > the argument to keep a bug/flaw capable of crashing your system.
>
> dmraid solves the problem by removing the partitions from the
> underlying physical device ( /dev/sda ), and only exposing them on the
> array ( /dev/mapper/whatever ).  LVM only has the problem when you
> take a snapshot.  User space tools face the same issue and they
> resolve it by ignoring or deprioritizing the snapshot.
I don't agree. dmraid and mdraid both remove the partitions. This is not
a solution BTRFS will still crash the PC using /dev/mapper/whatever or
whatever device appears in the system providing the BTRFS volume.
> > As it is a nice feature that the kernel apparently scans for drives
> > and automatically identifies BTRFS ones, it seems to me that this
> > feature is useless. When in a live system a BTRFS RAID disk fails,
> > it is not sufficient to hot-replace it, the kernel will not
> > automatically rebalance. Commands are still needed for the task as
> > are with mdraid. So the only point I can see at the moment where
> > this auto-detect feature makes sense is when mounting the device
> > for the first time. If I remember the documentation correctly, you
> > mount one of the RAID devices and the others are automagically
> > attached as well. But outside of the mount process, what is this
> > auto-detect used for?
>
> > So here a couple of rather simple solutions which, as far as I can
> > see, could solve the problem:
>
> > 1. Limit the auto-detect to the mount process and don't do it when
> > devices are appearing.
>
> > 2. When a BTRFS device is detected and its metadata is identical to
> > one already mounted, just ignore it.
>
> That doesn't really solve the problem since you can still pick the
> wrong one to mount in the first place.
Oh, it does solve the problem, you are are speaking of another problem
which is always there when having several disks in a system. Mounting
the wrong device can happen the case I'm describing if you use UUID,
label or some other metadata related information to mount it. You won't
try do that when you insert a disk you know it has the same metadata. It
will not happen (except user tools outsmart you ;-)) when using the
device name(s). I think it could be expected from a user mounting things
manually to know or learn which device node is which drive. On the other
hand in my case one of the drives is already mounted so getting it
confused with a freshly inserted drive is not easy. Oh, I forgot that
part of this bug is that /proc/mounts starts to give wrong information
so in this case, yes, it gets much more likely to pick the wrong drive.
It even can happen that you format the mounted drive as user tools would
refuse to work on the non-mounted drive but may go for the mounted
one... not so funny.

Speaking of BTRFS tools, I am still somehow confused that the problem
confusing or mixing devices happens at all. I don't know the metadata of
a BTRFS RAID setup but I assume there must be something like a drive
index in there, as the order of RAID5 drives does matter. So having a
second device with identical metadata should be considered invalid for
auto-adding anyway.

But all this is fighting is at the wrong place. My understanding of a
good system is not that users should learn what flaws can cause an
unintentional crash but that it should not have such flaws. We have
identified such a flaw. Regardless of the discussion that there are
better ways to organize your drives, the system should not shoot itself
when doing suboptimal things. So I'm still convinced that Linux guys
should be interested to make the system better. So is the general
opinion that there is a bug which needs to be fixed or is this a problem
people will have to live with?


