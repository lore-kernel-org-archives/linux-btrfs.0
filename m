Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:50327 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1727303AbeHaUsn (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 31 Aug 2018 16:48:43 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-3@m.gmane.org>)
        id 1fvmR1-00084Q-SL
        for linux-btrfs@vger.kernel.org; Fri, 31 Aug 2018 18:38:11 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: How to erase a RAID1 (+++)?
Date: Fri, 31 Aug 2018 16:38:03 +0000 (UTC)
Message-ID: <pan$6fa76$8810056e$68edfd30$12da364b@cox.net>
References: <04e4b43f-b21e-b6fd-dfad-0506ff35aff7@couderc.eu>
        <52b06c19-c9e2-29c1-b761-98d770c2d6c7@gmx.com>
        <2e47e913-104e-8d0c-8d49-69518681147b@couderc.eu>
        <f77df1e6-8030-716b-fc95-81ef3ae4f173@gmx.com>
        <22bd27f6-7107-7c34-110d-9cbed0c62790@couderc.eu>
        <CAJCQCtTcCWavzu5k6ZnhCDU+jaHxWfzfuR5Whic1-ic0s+x+8g@mail.gmail.com>
        <pan$4e7f0$2612a395$18eaf6d3$f09fc7a4@cox.net>
        <076f8cb5-1a34-4d1b-727a-466de1e30088@couderc.eu>
        <VI1PR08MB0862F346E3B20945F73133CE920F0@VI1PR08MB0862.eurprd08.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Alberto Bursi posted on Fri, 31 Aug 2018 14:54:46 +0000 as excerpted:

> I just keep around a USB drive with a full Linux system on it, to act as
> "recovery". If the btrfs raid fails I boot into that and I can do
> maintenance with a full graphical interface and internet access so I can
> google things.

I do very similar, except my "recovery boot" is my backup (with normally 
including for root two levels of backup/recovery available, three for 
some things).

I've actually gone so far as to have /etc/fstab be a symlink to one of 
several files, depending on what version of root vs. the off-root 
filesystems I'm booting, with a set of modular files that get assembled 
by scripts to build the fstabs as appropriate.  So updating fstab is a 
process of updating the modules, then running the scripts to create the 
actual fstabs, and after I update a root backup the last step is changing 
the symlink to point to the appropriate fstab for that backup, so it's 
correct if I end up booting from it.

Meanwhile, each root, working and two backups, is its own set of two 
device partitions in btrfs raid1 mode.  (One set of backups is on 
separate physical devices, covering the device death scenario, the other 
is on different partitions on the same, newer and larger pair of physical 
devices as the working set, so it won't cover device death but still 
covers fat-fingering, filesystem fubaring, bad upgrades, etc.)

/boot is separate and there's four of those (working and three backups), 
one each on each device of the two physical pairs, with the bios able to 
point to any of the four.  I run grub2, so once the bios loads that, I 
can interactively load kernels from any of the other three /boots and 
choose to boot any of the three roots.

And I build my own kernels, with an initrd attached as an initramfs to 
each, and test that they boot.  So selecting a kernel by definition 
selects its attached initramfs as well, meaning the initr*s are backed up 
and selected with the kernels.

(As I said earlier it'd sure be nice to be able to do away with the 
initr*s again.  I was actually thinking about testing that today, which 
was supposed to be a day off, but got called in to work, so the test will 
have to wait once again...)

What's nice about all that is that just as you said, each recovery/backup 
is a snapshot of the working system at the time I took the backup, so 
it's not a limited recovery boot at all, it has the same access to tools, 
manpages, net, X/plasma, browsers, etc, that my normal system does, 
because it /is/ my normal system from whenever I took the backup.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman
