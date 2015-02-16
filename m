Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:58357 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751579AbbBPFuk (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 16 Feb 2015 00:50:40 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1YNEZq-0000m6-3y
	for linux-btrfs@vger.kernel.org; Mon, 16 Feb 2015 06:50:38 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 16 Feb 2015 06:50:38 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 16 Feb 2015 06:50:38 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: btrfs raid-1 uuid-fstab
Date: Mon, 16 Feb 2015 05:50:31 +0000 (UTC)
Message-ID: <pan$bfe1d$b1a37d6$247b6812$65dedebb@cox.net>
References: <loom.20150214T001556-40@post.gmane.org>
	<CAJCQCtSRgOmUfNFdvxoU1m77m-K_oKvp-nFeyaR8VtuYZbacyg@mail.gmail.com>
	<pan$61fb6$e370d823$43b0d70$79a222c6@cox.net>
	<sgb6rb-2hv.ln1@hurikhan77.spdns.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Kai Krakow posted on Sun, 15 Feb 2015 12:11:56 +0100 as excerpted:

> Duncan <1i5t5.duncan@cox.net> schrieb:
> 
> Gentoo here, too. And I tried to fiddle around with the exact same issue
> some kernel versions back and didn't get it to work, so I did go with
> dracut which works pretty well for me - combined with grub2,
> multi-device detection works pretty well tho you sometimes need
> rootdelay={1,2,3} to wait up to three seconds for btrfs figure out its
> setup. Looks like btrfs devices are assembled with a delay by the kernel
> and at the point you try to mount one of the compound devices, if done
> too early, the kernel code cannot yet find all the other devices of the
> set. Maybe "rootwait" would also do tho I didn't tried that yet (it
> probably won't as the root device is initrd initially). It may be a
> side-effect of the kernel doing async SCSI device detection. It may be
> worth trying to turn that option of.

Interesting.  I had forgotten I had rootwait set as a builtin kernel 
commandline-option, and was about to reply that I had SCSI_ASYNC_SCAN 
turned on and had never seen problems, but then I remembered having to 
turn on rootwait.

Actually, I had tried rootdelay=N some years ago, perhaps before rootwait 
actually became an kernel commandline option, certainly before I knew of 
it.  I used it with mdraid (initr*-less) too.  But eventually I got tired 
of having to play with rootdelay timeouts, and when I came across rootwait 
I decided to try it, and that solved my timeouts issue once and for all.

So I can confirm that rootwait seems to work for multi-device btrfs as 
well, which of course requires an initr*.  But that actually might be 
dracut reading the kernel commandline and applying the same option at the 
initr* level, and thus not work with other initr*-generators, if they 
don't do the same thing.  I'm actually not sure.

What I can say, however, is that after I set rootwait here, I've had no 
more block-device-detection-timing issues.  It has "just worked" in terms 
of timing.

And what's nice is that rootwait actually appears to go into a loop, 
checking for a mountable root, as well, and will continue immediately 
upon finding it.  So the delay is exactly as long as it needs to be, and 
no longer.  (I don't remember whether rootdelay=N could terminate the 
delay early if it found all necessary devices, or not, but certainly, 
rootwait does.)

> But about your theory: I don't think the cmdline parser works incorrect,
> becauce rootflags=subvol=something works.

Well, so much for /that/ theory, then.  I /thought/ the kernel devs were 
too smart to have let a bug that simple, especially where it was likely 
to be triggered by other = options as well, remain for as long as this 
has.  But that was what I came up with as a possible explanation.  I 
think your theory below makes more sense.

> It's probably just a flaw that
> btrfs device composition comes up later and the kernel tries to early to
> mount root. "rootwait" probably won't help here, too. But "rootdelay"
> may help that case tho I myself don't have the ambitions to experiment
> with it. My dracut initrd setup works fine and has some benefits like
> early debug shell to investigate problems without resorting to rescue
> systems or bootable USB sticks.

FWIW, my root backup and rescue solution are one and the same, an 
occasional (every few kernel cycles) "snapshot" copy (not btrfs snapshot, 
a full copy) of my root filesystem, made when things seem reasonably 
stable and have been working for awhile, to an identically sized "backup 
root filesystem" located elsewhere.  That way, I have effectively a fully 
operational system "snapshot" copy, taken when the system was known to be 
operational, complete with everything I normally use, X, KDE, firefox, 
media players, games, everything, and of course tested to boot and run as 
normal.  No crippled semi-functional rescue media for me! =:^)

With a root filesystem of 8 GiB, that's easy enough, and I keep several 
backup copies available, the first one another 8 GiB partitions each pair-
device btrfs raid1 on the same physical pair of SSDs, with a second and 
third 8 GiB root backup on reiserfs on spinning rust, in case the pair of 
SSD physical devices fail, or if btrfs itself gets majorly bugged out, 
such that booting to the first backup kills it just like it did the 
working copy.

And I have my grub2 menu setup with the root= boot option assigned a 
variable, and menu options to set that variable to point to any of the 
backups as necessary.  So to boot a particular backup, I just select the 
option to set the pointer variable appropriately, and then select boot.  
Similarly with other kernel commandline options, including the kernel 
choice and init=.  They're all loaded into pointer variables, and if I 
want to choose a different one, I simply select the menu option that sets 
the pointer variable appropriately, and then select boot.

Very flexible, this grub2 is! =:^)

Meanwhile, grub2 is setup on both ssds (which have identical partition 
layouts) and on the spinning rust, with each one having its own /boot, 
thus giving me backup /boots as well, and of course I can select any of 
them from the BIOS to boot, so I'm pretty well set as long as I don't 
lose all three devices at once.

If I lose all three devices at once, I figure it's quite likely I'm 
dealing with a rather larger disaster, say a fire or flood or the like, 
and will probably have my hands full just surviving for awhile.  When I 
do get back to worrying about the computer, likely after replacing what I 
lost in the disaster, it won't be that big a deal to start over 
downloading a live image and doing a new install from the stage-3 
starter.  After all, the *REAL* important backup is in my head, and if I 
lose that, I guess I won't be worrying much about computers any more, 
even if I'm still "alive" in some facility somewhere.  Tho I /do/ have 
some stuff backed up on USB thumb drive and the like as well.  But I 
don't put much priority in it, because I figure if I'm having to restore 
from that backup in the first place, I'm pretty much screwed in any case, 
and the /last/ thing I'm likely to be worried about is having to start 
over with a new computer install.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

