Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.15.14]:65258 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752005AbaLHAc3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 7 Dec 2014 19:32:29 -0500
Message-ID: <5484F198.3070206@web.de>
Date: Mon, 08 Dec 2014 01:32:24 +0100
From: Konstantin <newsbox1026@web.de>
MIME-Version: 1.0
To: Phillip Susi <psusi@ubuntu.com>, MegaBrutal <megabrutal@gmail.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: PROBLEM: #89121 BTRFS mixes up mounted devices with their snapshots
References: <CAE8gLhm8Oma6kWdeJtdc1-U2e4+TJDzhmw2Vfr=CYwvJ78GRJQ@mail.gmail.com> <547CE175.6060409@web.de> <547E10BA.6000707@ubuntu.com>
In-Reply-To: <547E10BA.6000707@ubuntu.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Phillip Susi wrote on 02.12.2014 at 20:19:
> On 12/1/2014 4:45 PM, Konstantin wrote:
> > The bug appears also when using mdadm RAID1 - when one of the
> > drives is detached from the array then the OS discovers it and
> > after a while (not directly, it takes several minutes) it appears
> > under /proc/mounts: instead of /dev/md0p1 I see there /dev/sdb1.
> > And usually after some hour or so (depending on system workload)
> > the PC completely freezes. So discussion about the uniqueness of
> > UUIDs or not, a crashing kernel is telling me that there is a
> > serious bug.
>
> I'm guessing you are using metadata format 0.9 or 1.0, which put the
> metadata at the end of the drive and the filesystem still starts in
> sector zero.  1.2 is now the default and would not have this problem
> as its metadata is at the start of the disk ( well, 4k from the start
> ) and the fs starts further down.
I know this and I'm using 0.9 on purpose. I need to boot from these
disks so I can't use 1.2 format as the BIOS wouldn't recognize the
partitions. Having an additional non-RAID disk for booting introduces a
single point of failure which contrary to the idea of RAID>0.

Anyway, to avoid a futile discussion, mdraid and its format is not the
problem, it is just an example of the problem. Using dm-raid would do
the same trouble, LVM apparently, too. I could think of a bunch of other
cases including the use of hardware based RAID controllers. OK, it's not
the majority's problem, but that's not the argument to keep a bug/flaw
capable of crashing your system.

As it is a nice feature that the kernel apparently scans for drives and
automatically identifies BTRFS ones, it seems to me that this feature is
useless. When in a live system a BTRFS RAID disk fails, it is not
sufficient to hot-replace it, the kernel will not automatically
rebalance. Commands are still needed for the task as are with mdraid. So
the only point I can see at the moment where this auto-detect feature
makes sense is when mounting the device for the first time. If I
remember the documentation correctly, you mount one of the RAID devices
and the others are automagically attached as well. But outside of the
mount process, what is this auto-detect used for?

So here a couple of rather simple solutions which, as far as I can see,
could solve the problem:

1. Limit the auto-detect to the mount process and don't do it when
devices are appearing.

2. When a BTRFS device is detected and its metadata is identical to one
already mounted, just ignore it.


