Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:48539 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752277AbaBJDfU (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 9 Feb 2014 22:35:20 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1WCheM-0006Ac-GQ
	for linux-btrfs@vger.kernel.org; Mon, 10 Feb 2014 04:35:14 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 10 Feb 2014 04:35:14 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 10 Feb 2014 04:35:14 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: BTRFS with RAID1 cannot boot when removing drive
Date: Mon, 10 Feb 2014 03:34:49 +0000 (UTC)
Message-ID: <pan$c13e9$73e2c595$53adb8c8$58509a35@cox.net>
References: <20140209224055.3175e70f@system>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Saint Germain posted on Sun, 09 Feb 2014 22:40:55 +0100 as excerpted:

> I am experimenting with BTRFS and RAID1 on my Debian Wheezy (with
> backported kernel 3.12-0.bpo.1-amd64) using a a motherboard with UEFI.

My systems don't do UEFI, but I do run GPT partitions and use grub2 for 
booting, with grub2-core installed to a BIOS/reserved type partition 
(instead of as an EFI service as it would be with UEFI).  And I have root 
filesystem btrfs two-device raid1 mode working fine here, tested bootable 
with only one device of the two available.

So while I can't help you directly with UEFI, I know the rest of it can/
does work.

One more thing:  I do have a (small) separate btrfs /boot, actually two 
of them as I setup a separate /boot on each of the two devices in ordered 
to have a backup /boot, since grub can only point to one /boot by 
default, and while pointing to another in grub's rescue mode is possible, 
I didn't want to have to deal with that if the first /boot was corrupted, 
as it's easier to simply point the BIOS at a different drive entirely and 
load its (independently installed and configured) grub and /boot.

But grub2's btrfs module reads raid1 mode just fine as I can access files 
on the btrfs raid1 mode rootfs directly from grub without issue, so 
that's not a problem.

But I strongly suspect I know what is... and it's a relatively easy fix.  
See below.  =:^)

> However I haven't managed to make the system boot when the removing the
> first hard drive.
> 
> I have installed Debian with the following partition on the first hard
> drive (no BTRFS subsystem):
> /dev/sda1: for / (BTRFS)
> /dev/sda2: for /home (BTRFS)
> /dev/sda3: for swap
> 
> Then I added another drive for a RAID1 configuration (with btrfs
> balance) and I installed grub on the second hard drive with
> "grub-install /dev/sdb".

Just for clarification as you don't mention it specifically, altho your 
btrfs filesystem show information suggests you did it this way, are your 
partition layouts identical on both drives?

That's what I've done here, and I definitely find that easiest to manage 
and even just to think about, tho it's definitely not a requirement.  But 
using different partition layouts does significantly increase management 
complexity, so it's useful to avoid if possible. =:^)

> If I boot on sdb, it takes sda1 as the root filesystem

> If I switched the cable, it always take the first hard drive as
> the root filesystem (now sdb)

That's normal /appearance/, but that /appearance/ doesn't fully reflect 
reality.

The problem is that mount output (and /proc/self/mounts), fstab, etc, 
were designed with single-device filesystems in mind, and multi-device 
btrfs has to be made to fix the existing rules as best it can.

So what's actually happening is that the for a btrfs composed of multiple 
devices, since there's only one "device slot" for the kernel to list 
devices, it only displays the first one it happens to come across, even 
tho the filesystem will normally (unless degraded) require that all 
component devices be available and logically assembled into the 
filesystem before it can be mounted.

When you boot on sdb, naturally, the sdb component of the multi-device 
filesystem that the kernel finds, so it's the one listed, even tho the 
filesystem is actually composed of more devices, not just that one.  When 
you switch the cables, the first one is, at least on your system, always 
the first device component of the filesystem detected, so it's always the 
one occupying the single device slot available for display, even tho the 
filesystem has actually assembled all devices into the complete 
filesystem before mounting.

> If I disconnect /dev/sda, the system doesn't boot with a message saying
> that it hasn't found the UUID:
> 
> Scanning for BTRFS filesystems...
> mount: mounting /dev/disk/by-uuid/c64fca2a-5700-4cca-abac-3a61f2f7486c
> on /root failed: Invalid argument
> 
> Can you tell me what I have done incorrectly ?
> Is it because of UEFI ? If yes I haven't understood how I can correct it
> in a simple way.

As you haven't mentioned it and the grub config below doesn't mention it 
either, I'm almost certain that you're simply not aware of the "degraded" 
mount option, and when/how it should be used.

And if you're not aware of that, chances are you're not aware of the 
btrfs wiki, and the multitude of other very helpful information it has 
available.  I'd suggest you spend some time reading it, as it'll very 
likely save you quite some btrfs administration questions and headaches 
down the road, as you continue to work with btrfs.

Bookmark it and refer to it often! =:^)

https://btrfs.wiki.kernel.org

(Click on the guides and usage information in contents under section 5, 
documentation.)

Here's the mount options page.  Note that the kernel btrfs documentation 
also includes mount options:

https://btrfs.wiki.kernel.org/index.php/Mount_options

$KERNELDIR/Documentation/filesystems/btrfs.txt

You should be able to mount a two-device btrfs raid1 filesystem with only 
a single device with the degraded mount option, tho I believe current 
kernels refuse a read-write mount in that case, so you'll have read-only 
access until you btrfs device add a second device, so it can do normal 
raid1 mode once again.

Specifically, from grub, edit the kernel commandline, setting 
rootflags=degraded.  The kernel rootflags parameter is the method by 
which such mount options are passed.

Meanwhile, since the degraded mount-opt is in fact a no-op if btrfs can 
actually find all components of the filesystem, some people choose to 
simply add degraded to their standard mount options (edit the grub config 
to add it at every boot), so they don't have to worry about it.  However, 
that is NOT RECOMMENDED, as the accepted wisdom is that the failure to 
mount undegraded serves as a warning to the sysadmin that something VERY 
WRONG is happening, and that they need to fix it.  They can then add 
degraded temporarily if they wish, in ordered to get the filesystem to 
mount and thus be able to boot, but adding the option routinely at every 
boot bypasses this important warning, and it's all too likely that an 
admin will thus ignore the problem (or not know about it at all) until 
too late.

Altho if it is indeed true that btrfs will now refuse to mount writable 
if it's degraded like that, that's not such a huge issue either, as the 
read-only mount can serve as the same warning.  Still, I certainly prefer 
the refusal to mount entirely without the degraded option, if indeed the 
filesystem is lacking a component device.  There's nothing quite like 
forcing me to actually type in "rootflags=degraded" to rub my face in the 
reality and gravity of the situation I'm in! =:^)

...

That should answer your immediate question, but do read up on the wiki.  
In addition to much of the FAQ, you'll want to read the sysadmin guide 
page, particularly the raid and data duplication section, and the 
multiple devices page, since they're directly apropos to btrfs multi-
device raid modes.  You'll probably want to read the problem FAQ and 
gotchas pages just for the heads-up as well, and likely at least the raid 
section of the use cases page as well.

Meanwhile, I don't believe it's on the wiki, but it's worth noting my 
experience with btrfs raid1 mode in my pre-deployment tests.  Actually, 
with the (I believe) mandatory read-only mount if raid1 is degraded below 
two devices, this problem's going to be harder to run into than it was in 
my testing several kernels ago, but here's what I found:

What I did was writable-degraded-mount first one of the btrfs raid1 pair, 
then the other (with the other one offline in each case), and change a 
test file with each mount, so that the two copies were different, and 
neither one the same as the original file.  Then I remounted the 
filesystem with both devices once again, to see what would happen.

Based on my previous history with mdraid and how i knew it to behave, I 
expected some note in the log about the two devices having unmatched 
write generation and possibly an automated resync to catch the one back 
up to the other, or alternatively, dropping the one from the mount and 
requiring me to do some sort of manual sync (tho I really didn't know 
what sort of btrfs command I'd use for that, but this was pre-deployment 
testing and I was experimenting with the intent of finding this sort of 
thing out!).

That's *NOT* what I got!

What I got was NO warnings, simply one of the two new versions displayed 
when I catted the file.  I'm not sure if it could have shown me the other 
one such that which one it showed was random, or not, but that I didn't 
get a warning was certainly unsettling to me.

Then I unmounted and unplugged the one with that version of the file, and 
remounted degraded again, to check if the other copy had been silently 
updated.  It was exactly as it had been, so the copies were still 
different.

What I'd do after that today were I redoing this test, would be either a 
scrub or a balance, which would presumably find and correct the 
difference.  However, back then I didn't know enough about what I was 
doing to test that, so I didn't, and I still don't actually know how/
whether the difference would have been detected and corrected, since I 
never did actually test that.


My takeaway from that test was not to actually play around with degraded 
writable mounts to much, and for SURE if I did, to take care that if I 
was to write-mount one and ever intended to bring back the other one, I 
should be sure it was always the same one I was write-mounting and 
updating, so only one would be changed and it'd always be clear which 
copy was the newest.  (Btrfs behavior on this point has since been 
confirmed by a dev, btrfs tracks write generation and will always take 
the higher sequence write generation if there's a difference.  If the 
write generations happened to be the same, however, as I took what he 
said, it'd depend on which one the kernel happened to find first.  So 
always making sure the same one was written to was and remains a good 
idea, so different writes don't get done to different devices, with some 
of those writes dropped when they're recombined in an undegraded mount.)

And if there was any doubt, the best action would be to wipe (or trim/
discard, my devices are SSD so that's the simplest option) the one 
filesystem, and btrfs device add and btrfs balance back to it from the 
other exactly as if it were a new device, rather than risk not knowing 
which of the two differing versions btrfs would end up with.

But as I said, if btrfs only allows read-only mounts of filesystems 
without enough devices to properly complete the raidlevel, that shouldn't 
be as big an issue these days, since it should be more difficult or 
impossible to get the two devices separately mounted writable in the 
first place, with the consequence that the differing copies issue will be 
difficult or impossible to trigger in the first place. =:^)


But that's still a very useful heads-up for anyone using btrfs in raid1 
mode to know about, particularly when they're working with degraded mode, 
just to keep the possibility in mind and be safe with their manipulations 
to avoid it... unless of course they're testing exactly the same sort of 
thing I was. =:^)

> As extra question, I don't see also how I can configure the system to
> get the correct swap in case of disk failure. Should I force both swap
> partition to have the same UUID ?

No.  There's no harm in having multiple swap entries in fstab, so simply 
add a separate fstab entry for each swap partition.  That way, if both 
are available, they'll both be activated by the usual swapon -a.  If only 
one's available, it'll be activated.

(You may want to use the fstab nofail option, described in the fstab (5) 
manpage and mentioned under --ifexists in the swapon (8) manpage as well, 
if your distro's swap initialization doesn't already use --ifexists, to 
prevent a warning if the one doesn't actually exist as it's on a 
disconnected drive.)

As a nice variant, consider using the priority=n option, as detailed in 
the swapon (2,8) manpages.  The kernel defaults to negative priorities, 
with each successive activates swap getting a lower (further negative) 
priority than the others, but you can specify positive swap priorities as 
well.  Higher priority swap is used first, so if you want one swap used 
before another, set its priority higher.

But what REALLY makes swap priorities useful is the fact that if two 
swaps have equal priority, the kernel will automatically effectively 
raid0-stripe swap between them, thus effectively multiplying your swap 
speed! =:^)  Since especially spinning rust is so slow, if your drives 
are spinning rust, that can help significantly if you're actually using 
swap, especially when using it heavily (thrashing).

With ssds the raid0 effect of equal swap priorities should still be 
noticeable, tho they're typically enough faster than spinning rust that 
actively swapping to just one isn't the huge drag it is on spinning rust, 
and with the limited write-cycles of ssd, you may wish to set one a 
higher swap priority than the other just so it gets used more, sparing 
the other.

[Some of the outputs also posted were useful, particularly in implying 
that you had identical partition layout on each device as well as to 
verify that you weren't already using the degraded mount option, but I've 
snipped them as too much to include here.]

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

