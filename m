Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.17.12]:50581 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752885AbaLAVp3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 1 Dec 2014 16:45:29 -0500
Message-ID: <547CE175.6060409@web.de>
Date: Mon, 01 Dec 2014 22:45:25 +0100
From: Konstantin <newsbox1026@web.de>
MIME-Version: 1.0
To: MegaBrutal <megabrutal@gmail.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: PROBLEM: #89121 BTRFS mixes up mounted devices with their snapshots
References: <CAE8gLhm8Oma6kWdeJtdc1-U2e4+TJDzhmw2Vfr=CYwvJ78GRJQ@mail.gmail.com>
In-Reply-To: <CAE8gLhm8Oma6kWdeJtdc1-U2e4+TJDzhmw2Vfr=CYwvJ78GRJQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


MegaBrutal schrieb am 01.12.2014 um 13:56:
> Hi all,
>
> I've reported the bug I've previously posted about in "BTRFS messes up
> snapshot LV with origin" in the Kernel Bug Tracker.
> https://bugzilla.kernel.org/show_bug.cgi?id=89121
Hi MegaBrutal. If I understand your report correctly, I can give you
another example where this bug is appearing. It is so bad that it leads
to freezing the system and I'm quite sure it's the same thing. I was
thinking about filing a bug but didn't have the time for that yet. Maybe
you could add this case to your bug report as well.

The bug appears also when using mdadm RAID1 - when one of the drives is
detached from the array then the OS discovers it and after a while (not
directly, it takes several minutes) it appears under /proc/mounts:
instead of /dev/md0p1 I see there /dev/sdb1. And usually after some hour
or so (depending on system workload) the PC completely freezes. So
discussion about the uniqueness of UUIDs or not, a crashing kernel is
telling me that there is a serious bug.

While in my case detaching was intentional, there are several real
possibilities when a RAID1 disk can get detached and currently this
leads to crashing the server when using BTRFS. That not what is intended
when using RAID ;-).

In my case I wanted to do something which was working perfectly all the
years before with all other file systems - checking the file system of
the root disk while the server is running. The procedure is simple:

1. detach one of the disks
2. do fsck on the disk device
3. mdadm --zero-superblock on the device so it gets completely rewritten
4. mdadm --add it to the array

There were some surprises with BTRFS - if 2. is not done directly after
1. btrfsck refuses to check the disk as it is reported to be mounted by
/proc/mounts. And while 2. or even after finishing it the system was
freezing. If I got to get to 4. fast enough everything was OK, but
again, that's not what I expect from a good operating system. Any
objections?

Konstantin

