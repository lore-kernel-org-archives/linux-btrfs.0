Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-bk0-f44.google.com ([209.85.214.44]:44275 "EHLO
	mail-bk0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752148AbaBKCbE (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 10 Feb 2014 21:31:04 -0500
Received: by mail-bk0-f44.google.com with SMTP id mz12so2078021bkb.3
        for <linux-btrfs@vger.kernel.org>; Mon, 10 Feb 2014 18:31:02 -0800 (PST)
Received: from system (e180211082.adsl.alicedsl.de. [85.180.211.82])
        by mx.google.com with ESMTPSA id tf11sm13898175bkb.17.2014.02.10.18.31.00
        for <linux-btrfs@vger.kernel.org>
        (version=SSLv3 cipher=RC4-SHA bits=128/128);
        Mon, 10 Feb 2014 18:31:01 -0800 (PST)
Date: Tue, 11 Feb 2014 03:30:59 +0100
From: Saint Germain <saintger@gmail.com>
To: linux-btrfs@vger.kernel.org
Subject: Re: BTRFS with RAID1 cannot boot when removing drive
Message-ID: <20140211033059.34bd0ef7@system>
In-Reply-To: <pan$c13e9$73e2c595$53adb8c8$58509a35@cox.net>
References: <20140209224055.3175e70f@system>
 <pan$c13e9$73e2c595$53adb8c8$58509a35@cox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello Duncan,

What an amazing extensive answer you gave me !
Thank you so much for it.

See my comments below.

On Mon, 10 Feb 2014 03:34:49 +0000 (UTC), Duncan <1i5t5.duncan@cox.net>
wrote :

> > I am experimenting with BTRFS and RAID1 on my Debian Wheezy (with
> > backported kernel 3.12-0.bpo.1-amd64) using a a motherboard with
> > UEFI.
> 
> My systems don't do UEFI, but I do run GPT partitions and use grub2
> for booting, with grub2-core installed to a BIOS/reserved type
> partition (instead of as an EFI service as it would be with UEFI).
> And I have root filesystem btrfs two-device raid1 mode working fine
> here, tested bootable with only one device of the two available.
> 
> So while I can't help you directly with UEFI, I know the rest of it
> can/ does work.
> 
> One more thing:  I do have a (small) separate btrfs /boot, actually
> two of them as I setup a separate /boot on each of the two devices in
> ordered to have a backup /boot, since grub can only point to
> one /boot by default, and while pointing to another in grub's rescue
> mode is possible, I didn't want to have to deal with that if the
> first /boot was corrupted, as it's easier to simply point the BIOS at
> a different drive entirely and load its (independently installed and
> configured) grub and /boot.
> 

Can you explain why you choose to have a dedicated "/boot" partition ?
I also read on this thread that it may be better to have a
dedicated /boot partition:
https://bbs.archlinux.org/viewtopic.php?pid=1342893#p1342893


> > However I haven't managed to make the system boot when the removing
> > the first hard drive.
> > 
> > I have installed Debian with the following partition on the first
> > hard drive (no BTRFS subsystem):
> > /dev/sda1: for / (BTRFS)
> > /dev/sda2: for /home (BTRFS)
> > /dev/sda3: for swap
> > 
> > Then I added another drive for a RAID1 configuration (with btrfs
> > balance) and I installed grub on the second hard drive with
> > "grub-install /dev/sdb".
> 
> Just for clarification as you don't mention it specifically, altho
> your btrfs filesystem show information suggests you did it this way,
> are your partition layouts identical on both drives?
> 
> That's what I've done here, and I definitely find that easiest to
> manage and even just to think about, tho it's definitely not a
> requirement.  But using different partition layouts does
> significantly increase management complexity, so it's useful to avoid
> if possible. =:^)

Yes, the partition layout is exactly the same on both drive (copied
with sfdisk). I also try to keep things simple ;-)

> > If I boot on sdb, it takes sda1 as the root filesystem
> 
> > If I switched the cable, it always take the first hard drive as
> > the root filesystem (now sdb)
> 
> That's normal /appearance/, but that /appearance/ doesn't fully
> reflect reality.
> 
> The problem is that mount output (and /proc/self/mounts), fstab, etc, 
> were designed with single-device filesystems in mind, and
> multi-device btrfs has to be made to fix the existing rules as best
> it can.
> 
> So what's actually happening is that the for a btrfs composed of
> multiple devices, since there's only one "device slot" for the kernel
> to list devices, it only displays the first one it happens to come
> across, even tho the filesystem will normally (unless degraded)
> require that all component devices be available and logically
> assembled into the filesystem before it can be mounted.
> 
> When you boot on sdb, naturally, the sdb component of the
> multi-device filesystem that the kernel finds, so it's the one
> listed, even tho the filesystem is actually composed of more devices,
> not just that one.

I am not following you: it seems to be the opposite of what you
describe. If I boot on sdb, I expect sdb1 and sdb2 to be the first
components that the kernel find. However I can see that sda1 and sda2
are used (using the 'mount' command).

> When you switch the cables, the first one is, at
> least on your system, always the first device component of the
> filesystem detected, so it's always the one occupying the single
> device slot available for display, even tho the filesystem has
> actually assembled all devices into the complete filesystem before
> mounting.
> 

Normally the 2 hard drive should be exactly the same (or I didn't
understand something) except for the UUID_SUB.
That's why I don't understand if I switch the cable, I should get
exactly the same results with 'mount'.
But that is not the case, the 'mount' command always point to the same
partition:
- without cable switch: sda1 and sda2
- with cable switch: sdb1 and sdb2
Everything happen as if the system is using the UUID_SUB to get his
'favorite' partition.

> > If I disconnect /dev/sda, the system doesn't boot with a message
> > saying that it hasn't found the UUID:
> > 
> > Scanning for BTRFS filesystems...
> > mount:
> > mounting /dev/disk/by-uuid/c64fca2a-5700-4cca-abac-3a61f2f7486c
> > on /root failed: Invalid argument
> > 
> > Can you tell me what I have done incorrectly ?
> > Is it because of UEFI ? If yes I haven't understood how I can
> > correct it in a simple way.
> 
> As you haven't mentioned it and the grub config below doesn't mention
> it either, I'm almost certain that you're simply not aware of the
> "degraded" mount option, and when/how it should be used.
> 

Ah yes I read about it but didn't understand that it applied in my
sitution. Thanks for pointing it out.

> You should be able to mount a two-device btrfs raid1 filesystem with
> only a single device with the degraded mount option, tho I believe
> current kernels refuse a read-write mount in that case, so you'll
> have read-only access until you btrfs device add a second device, so
> it can do normal raid1 mode once again.
> 

Indeed I managed to boot with the degraded option.
However sda1 is mounted ny default in read-write (not read only) and
sda2 (my /home) refuse to be mounted:
Mounting local filesystemsError mounting: mount: wrong fs type, bad
option, bad superblock on /dev/sda2, missing codepage or helper
program, or other error.
This is with the kernel 3.12-0.bpo.1-amd64.

> That should answer your immediate question, but do read up on the
> wiki. In addition to much of the FAQ, you'll want to read the
> sysadmin guide page, particularly the raid and data duplication
> section, and the multiple devices page, since they're directly
> apropos to btrfs multi- device raid modes.  You'll probably want to
> read the problem FAQ and gotchas pages just for the heads-up as well,
> and likely at least the raid section of the use cases page as well.

Will do !

> 
> Meanwhile, I don't believe it's on the wiki, but it's worth noting my 
> experience with btrfs raid1 mode in my pre-deployment tests.
> Actually, with the (I believe) mandatory read-only mount if raid1 is
> degraded below two devices, this problem's going to be harder to run
> into than it was in my testing several kernels ago, but here's what I
> found:
> 
> What I did was writable-degraded-mount first one of the btrfs raid1
> pair, then the other (with the other one offline in each case), and
> change a test file with each mount, so that the two copies were
> different, and neither one the same as the original file.  Then I
> remounted the filesystem with both devices once again, to see what
> would happen.
> 
> Based on my previous history with mdraid and how i knew it to behave,
> I expected some note in the log about the two devices having
> unmatched write generation and possibly an automated resync to catch
> the one back up to the other, or alternatively, dropping the one from
> the mount and requiring me to do some sort of manual sync (tho I
> really didn't know what sort of btrfs command I'd use for that, but
> this was pre-deployment testing and I was experimenting with the
> intent of finding this sort of thing out!).
> 
> That's *NOT* what I got!
> 
> What I got was NO warnings, simply one of the two new versions
> displayed when I catted the file.  I'm not sure if it could have
> shown me the other one such that which one it showed was random, or
> not, but that I didn't get a warning was certainly unsettling to me.
> 
> Then I unmounted and unplugged the one with that version of the file,
> and remounted degraded again, to check if the other copy had been
> silently updated.  It was exactly as it had been, so the copies were
> still different.
> 
> What I'd do after that today were I redoing this test, would be
> either a scrub or a balance, which would presumably find and correct
> the difference.  However, back then I didn't know enough about what I
> was doing to test that, so I didn't, and I still don't actually know
> how/ whether the difference would have been detected and corrected,
> since I never did actually test that.
> 
> 
> My takeaway from that test was not to actually play around with
> degraded writable mounts to much, and for SURE if I did, to take care
> that if I was to write-mount one and ever intended to bring back the
> other one, I should be sure it was always the same one I was
> write-mounting and updating, so only one would be changed and it'd
> always be clear which copy was the newest.  (Btrfs behavior on this
> point has since been confirmed by a dev, btrfs tracks write
> generation and will always take the higher sequence write generation
> if there's a difference.  If the write generations happened to be the
> same, however, as I took what he said, it'd depend on which one the
> kernel happened to find first.  So always making sure the same one
> was written to was and remains a good idea, so different writes don't
> get done to different devices, with some of those writes dropped when
> they're recombined in an undegraded mount.)
> 
> And if there was any doubt, the best action would be to wipe (or trim/
> discard, my devices are SSD so that's the simplest option) the one 
> filesystem, and btrfs device add and btrfs balance back to it from
> the other exactly as if it were a new device, rather than risk not
> knowing which of the two differing versions btrfs would end up with.
> 
> But as I said, if btrfs only allows read-only mounts of filesystems 
> without enough devices to properly complete the raidlevel, that
> shouldn't be as big an issue these days, since it should be more
> difficult or impossible to get the two devices separately mounted
> writable in the first place, with the consequence that the differing
> copies issue will be difficult or impossible to trigger in the first
> place. =:^)
> 
> 
> But that's still a very useful heads-up for anyone using btrfs in
> raid1 mode to know about, particularly when they're working with
> degraded mode, just to keep the possibility in mind and be safe with
> their manipulations to avoid it... unless of course they're testing
> exactly the same sort of thing I was. =:^)
> 

Well I think I just experienced it the hard way.
I tried unplugging one hard drive and the other to test a little how
BTRFS will react and after several times (I absolutely didn't make
any modification whatsoever) the system refuse to boot.
I tried everything for hours to restore it (btrfsck, scrub, etc.) but I
keep receiving error messages.
At the end I just reinstall everything (fortunately it was a test
system).
So yes you are right, as soon as one hard drive failed, you MUST mount
in read-only mode, otherwise it is almost a given that something bad
will happen.

I think I will try again to experiment, but by taking snapshots before
this time ;-)

Thanks again for your superb help ! It keeps me motivated to keep on
with BTRFS !
