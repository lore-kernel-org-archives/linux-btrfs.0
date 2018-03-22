Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:38932 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1752335AbeCVHnz (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 22 Mar 2018 03:43:55 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-3@m.gmane.org>)
        id 1eyur3-00083W-Uk
        for linux-btrfs@vger.kernel.org; Thu, 22 Mar 2018 08:41:45 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: grub_probe/grub-mkimage does not find all drives in BTRFS RAID1
Date: Thu, 22 Mar 2018 07:41:39 +0000 (UTC)
Message-ID: <pan$5990f$7d552dab$80963e5a$19633493@cox.net>
References: <DF0C87D105B235419E2D9E5066CCCF51988BA347@gcmxbe02.dac.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Matthew Hawn posted on Thu, 22 Mar 2018 00:13:38 +0000 as excerpted:

> This is almost definitely a bug in GRUB, but I wanted to get the btrfs
> mailing list opinion first.
> 
> Symptoms:
> I have a btrfs raid1 /boot and root filesystem.  Ever since I replaced a
> drive, when I run the grub utilities to create my grub.cfg and install
> to boot sector, it only recognizes one of the drives.

> So, is this a grub bug? If so, any suggestions before I submit to the
> grub-bug list?  Also, as I wait until a fix is published (or I rebuild
> grub with my own patch), any ideas to workaround this?

It does appear to be a grub bug, yes.  I'm not a dev, just a btrfs user 
and list regular, so won't comment further on that, but I do have a 
suggested workaround based on what I do here.

> Grub:  2.02~beta2-36ubuntu3.17

FWIW, 2.02 is out (and installed here on gentoo, gentoo git log says it 
was committed to the gentoo tree on 2017-04-27, and ftp.gnu.org has a 
date of 2017-04-26, so it's out nearing a year now, and gentoo picked it 
up right away =:^), but I don't know if that bug is fixed.

> $ btrfs fi show
> Label: none  uuid: 84c8e78b-9d7f-4451-966d-3c25154e89b8
> 	Total devices 2 FS bytes used 22.16GiB
> 	devid    2 size 100.00GiB used 25.03GiB
> path /dev/mapper/VG_BTRFS2-LV_ROOT2
> 	devid    3 size 100.00GiB used 25.03GiB
> path /dev/mapper/VG_BTRFS3-LV_ROOT3
> 
> 
> Label: none  uuid: 059ab98f-eb63-471d-b099-6561baf39040
> 	Total devices 2 FS bytes used 61.04GiB
> 	devid    2 size 200.00GiB used 62.03GiB 
> path /dev/mapper/VG_BTRFS2-LV_HOME2
> 	devid    3 size 200.00GiB used 62.03GiB
> path /dev/mapper/VG_BTRFS3-LV_HOME3
> 
> 
> Label: none  uuid: ffe8b1a0-030c-42c2-94f5-b7e8e54b1439
> 	Total devices 2 FS bytes used 342.04MiB
> 	devid    2 size 1.00GiB used 693.62MiB 
> path /dev/mapper/VG_BTRFS2-LV_BOOT2
> 	devid    3 size 1.00GiB used 693.62MiB
> path /dev/mapper/VG_BTRFS3-LV_BOOT3

Good, you have a separate dedicated boot.  That will make my suggestion 
/much/ easier. =:^)

OT: I still remember the big deal of my first GB drive upgrade, not even 
a full GiB, and get a bit of "historical vertigo" seeing "a whole gig!!" 
used as a dedicated /boot...


So my setup here now uses mostly btrfs raid1, with a separate /boot, but 
I came up with the general layout years ago, before btrfs, when I was 
using mdraid, then with grub1 (technically 0.97 with a bunch of patches 
after upstream abandoned further development, as they never released 
grub1, dumping it for what became grub2 before 1.0 release).

And the much simpler grub1 didn't really understand mdraid, tho it could 
work with mdraid1 simply because grub treated each mdraid1 device as a 
single device.  But you had to install grub1 to each of the mdraid1 
devices separately if you wanted to be able to boot any of them, as it 
didn't have grub2-core's ability to dynamically detect other devices to 
load further grub modules from.

Meanwhile, while I was running mdraid and additionally had a backup raid 
for most of my filesystems, including root, that I could boot to if my 
primary/working raid and filesystem wouldn't assemble and/or mount for 
whatever reason, because grub1 could only point to one /boot for its 
stage2, I couldn't have a backup /boot raid1 on the same set of physical 
devices as my primary, which meant that if something other than a bad 
device happened to that /boot that made it unbootable, say I fat-fingered 
a mkfs and overwrote /boot, or if a grub upgrade went bad, I was stuck.

But at the time I was using 4-way mdraid1, 4 mirrors, for my primary 
raid, and that gave me an idea.  Instead of the usual 4 mirrors for each 
filesystem and its backup, as I had for most filesystems, for /boot I did 
two, two-way raid1s, each on two two devices, with one of the two two-way 
raid1s being the primary /boot and the second being the backup.  That way 
I could have the BIOS boot selector default to one of the primaries, and 
could still have it select one of the secondaries if I needed to boot the 
backup grub and its stage2 located in the backup /boot raid.

That came in quite handy when I upgraded to grub2, since I could upgrade 
the backup /boot raid1 and its grub to grub2, then test and configure it 
to my satisfaction, all the while keeping the grub1 installed in my 
normal working copy raid1 /boot untouched until I was satisfied that the 
grub2 install on the backup was functional and configured as I wanted, 
and upgrading the working copy raid1 /boot to grub2 only after I knew 
things were working well.


Much later, after some hardware upgrades so I wasn't using the 4-way 
raid1 setup any longer, I switched to btrfs and btrfs raid1.  But I so 
well liked the concept of having a backup /boot so I didn't have to worry 
about bad upgrades or fat-fingering my /boot, that I kept it!

But in addition to two-way raid1 redundancy on multiple devices, btrfs 
has the dup mode, two-way dup redundancy on a single device, so that's 
what I do with my /boot and its backups on other devices now, instead of 
making them raid1s across multiple devices.

So while most of my filesystems and their backups are btrfs raid1 both 
data and metadata across two physical devices (with another pair of 
physical devices for the btrfs raid1 backups), /boot and its backups are 
all btrfs dup mixed-bg-mode (so data and metadata mixed, easier to work 
with on small filesystems), giving me one primary /boot and three 
backups, and I can still select which one to boot from the hardware/BIOS 
(legacy not EFI mode, tho I do use GPT and have EFI-boot partitions 
reserved in case I decide to switch to EFI at some point).


So my suggestion would be to do something similar, multiple /boot, one 
per device, one as the working copy and the other(s) as backups, instead 
of btrfs raid1 across multiple devices.  If you still want to take 
advantage of btrfs' ability to error-correct from a second copy if the 
first fails checksum, as I do, btrfs dup mode is useful, but regardless, 
you'll then have a backup in case the working /boot entirely fails.  Tho 
of course with dup mode you can only use a bit under half the capacity.

Your btrfs fi show says 342 MB used (as data) of the 1 GiB, so dup mode 
should be possible as you'd have a bit under 500 MiB capacity then.  Your 
individual devices say nearly 700 MiB each used, but with only 342 MiB of 
that as data, the rest is likely partially used chunks that a filtered 
balance can take care of.  A btrfs fi usage report would tell the details 
(or btrfs fi df, combined with the show you've already posted).  At a 
GiB, creating the filesystem as mixed-mode is also recommended, tho that 
does make a filtered balance a bit more of a hassle since you have to use 
the same filters for both data and metadata because they're the same 
chunks.

FWIW, I started out with 256 MiB /boot here, btrfs dup mode so ~ 100 MiB 
usable, but after ssd upgrades and redoing the layout, now use 512 MiB 
/boots, for 200+ MiB usable.  That's better.  Your 1 GiB doubles that, so 
should be no trouble at all, even with dup, unless you're storing way 
more in /boot than I do.  (Being gentoo I do configure and run a rather 
slimmer custom initramfs and monolithic kernel configured for only the 
hardware and dracut initr* modules I need, and a fatter generic initr* 
and kernel modules would likely need more space, but your show output 
says it's only using 342 MiB for data, so as I said your 1 GiB for ~500 
MiB usable in dup mode should be quite reasonable.)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

