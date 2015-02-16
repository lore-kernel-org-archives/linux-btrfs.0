Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:46893 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751277AbbBPXQJ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 16 Feb 2015 18:16:09 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1YNUtb-0006fl-QA
	for linux-btrfs@vger.kernel.org; Tue, 17 Feb 2015 00:16:07 +0100
Received: from ip18864262.dynamic.kabel-deutschland.de ([24.134.66.98])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 17 Feb 2015 00:16:07 +0100
Received: from hurikhan77 by ip18864262.dynamic.kabel-deutschland.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 17 Feb 2015 00:16:07 +0100
To: linux-btrfs@vger.kernel.org
From: Kai Krakow <hurikhan77@gmail.com>
Subject: Re: btrfs raid-1 uuid-fstab
Date: Tue, 17 Feb 2015 00:15:50 +0100
Message-ID: <7aaarb-op3.ln1@hurikhan77.spdns.de>
References: <loom.20150214T001556-40@post.gmane.org> <CAJCQCtSRgOmUfNFdvxoU1m77m-K_oKvp-nFeyaR8VtuYZbacyg@mail.gmail.com> <pan$61fb6$e370d823$43b0d70$79a222c6@cox.net> <sgb6rb-2hv.ln1@hurikhan77.spdns.de> <pan$bfe1d$b1a37d6$247b6812$65dedebb@cox.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Duncan <1i5t5.duncan@cox.net> schrieb:

>> It's probably just a flaw that
>> btrfs device composition comes up later and the kernel tries to early to
>> mount root. "rootwait" probably won't help here, too. But "rootdelay"
>> may help that case tho I myself don't have the ambitions to experiment
>> with it. My dracut initrd setup works fine and has some benefits like
>> early debug shell to investigate problems without resorting to rescue
>> systems or bootable USB sticks.
> 
> FWIW, my root backup and rescue solution are one and the same, an
> occasional (every few kernel cycles) "snapshot" copy (not btrfs snapshot,
> a full copy) of my root filesystem, made when things seem reasonably
> stable and have been working for awhile, to an identically sized "backup
> root filesystem" located elsewhere.  That way, I have effectively a fully
> operational system "snapshot" copy, taken when the system was known to be
> operational, complete with everything I normally use, X, KDE, firefox,
> media players, games, everything, and of course tested to boot and run as
> normal.  No crippled semi-functional rescue media for me! =:^)

I accidently forced myself into using my USB3 backup drive as my rootfs due 
to fiddling around with dracut build options without thinking about it too 
much while waiting for my btrfs device add/del disk jockeying to migrate to 
bcache. Long story short: I managed to strip dracut down to too few modules 
and it lost its ability to mount anything and even could not spawn a shell. 
*gnarf

And when that wasn't fun enough, my BIOS decided to no longer initialize USB 
so I could neither get into BIOS nor into Grub shell. I don't know when that 
problem happened. Probably been that for a while and I never noticed. Just 
that it went a lot slower through BIOS after I managed to convince it to 
initialize USB again (by opening the case and shorting the reset jumper).

The next fun part was: My backup was incomplete in a special way: It had no 
directories dev, proc, run, sys and friends... Don't ask me how I solved 
that, probably by "init=/bin/bash". It happens, because I used "rsync" with 
the option to exclude those dirs. But well: In the end by backup was tested 
bootable. :-)

I fixed by dracut setup and in the same procedure also fixed a long-standing 
issue with "btrfs check" telling me nlink errors. Luckily, this newer 
version could tell me the paths and I just delete those files in the chrome 
profile and var/lib/bluetooth directory. I wonder if those errors were 
causing me issues with chrome freezing the PC and bluetooth stopped working 
sometimes.

And BTW: bcache is pretty fast, booting to graphical.target within 3-8 
seconds (mostly around 5). Now I wonder what I need the resume swap for 
which I created in the process: It takes longer to resume from swap than 
just booting to complete KDE desktop. Well, without the benefit of having a 
fully running session at least.

> Very flexible, this grub2 is! =:^)

I've been waiting long before doing the switch. But I had to use it when I 
migrated from legacy to UEFI boot mode. Although every configuration bit 
looked confusing and cumbersome, everything worked automatically out of the 
box. Very suprising it is. :-)

> If I lose all three devices at once, I figure it's quite likely I'm
> dealing with a rather larger disaster, say a fire or flood or the like,
> and will probably have my hands full just surviving for awhile.  When I
> do get back to worrying about the computer, likely after replacing what I
> lost in the disaster, it won't be that big a deal to start over
> downloading a live image and doing a new install from the stage-3
> starter.  After all, the *REAL* important backup is in my head, and if I
> lose that, I guess I won't be worrying much about computers any more,
> even if I'm still "alive" in some facility somewhere.  Tho I /do/ have
> some stuff backed up on USB thumb drive and the like as well.  But I
> don't put much priority in it, because I figure if I'm having to restore
> from that backup in the first place, I'm pretty much screwed in any case,
> and the /last/ thing I'm likely to be worried about is having to start
> over with a new computer install.

>From my own experience, the head is not a very good backup. While there are 
things which you simply cannot remember to rebuild, there are other things 
which, when rebuilt from scratch, probably get better and more well thought 
about but very frustrating to rebuild and thus never reach the same stage of 
completeness again. So, no: Not a good backup. It's no fun even when I had 
no other stuff to deal with...

But to get back to the multi-device btrfs booting issue: Thanks for 
recommending "rootwait", I will try that. I had thought it would have no 
effect if booting from initrd. Let's see if dracut+systemd with rootwait 
will work for me, too.

-- 
Replies to list only preferred.

