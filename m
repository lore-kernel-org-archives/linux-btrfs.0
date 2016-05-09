Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:48972 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750954AbcEITWs (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 9 May 2016 15:22:48 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1azqkf-000544-Rg
	for linux-btrfs@vger.kernel.org; Mon, 09 May 2016 21:21:58 +0200
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 09 May 2016 21:21:57 +0200
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 09 May 2016 21:21:57 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: btrfs ate my data in just two days, after a fresh install. ram
 and disk are ok. it still mounts, but I cannot repair
Date: Mon, 9 May 2016 19:18:59 +0000 (UTC)
Message-ID: <pan$5176$b51afa6d$75bca86d$7e2b8169@cox.net>
References: <3bf4a554-e3b8-44e2-b8e7-d08889dcffed@linuxsystems.it>
	<CAJCQCtRAqxREr8ToorSkbsnYKKk_NPy+1oSHP6WMOnpLe=9T1g@mail.gmail.com>
	<c9bde2c9-c0f3-4bd2-a9ac-81fe0250edcc@linuxsystems.it>
	<20160505174854.GA1012@vader.dhcp.thefacebook.com>
	<585760e0-7d18-4fa0-9974-62a3d7561aee@linuxsystems.it>
	<2cd5aca36f853f3c9cf1d46c2f133aa3@linuxsystems.it>
	<CAFvQSYTQ1yZqPYyv0dmd+JuHRWfKm-RtZLdbKXQeHiWMthnyLw@mail.gmail.com>
	<f1dd07efb34a0a110f62566979530944@linuxsystems.it>
	<799cf552-4612-56c5-b44d-59458119e2b0@gmail.com>
	<52f0c710-d695-443d-b6d5-266e3db634f8@linuxsystems.it>
	<20160509162940.GC15597@hungrycats.org>
	<4aa3dda7-70d6-5dcf-2fa7-4f2b509e4a1e@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Austin S. Hemmelgarn posted on Mon, 09 May 2016 14:21:57 -0400 as
excerpted:

> This practice evolved out of the fact that the only bad RAM I've ever
> dealt with either completely failed to POST (which can have all kinds of
> interesting symptoms if it's just one module, some MB's refuse to boot,
> some report the error, others just disable the module and act like
> nothing happened), or passed all the memory testing tools I threw at it
> (memtest86, memtest86+, memtester, concurrent memtest86 invocations from
> Xen domains, inventive acrobatics with tmpfs and FIO, etc), but failed
> under heavy concurrent random access, which can be reliably produced by
> running a bunch of big software builds at the same time with the CPU
> insanely over-committed.

My (likely much more limited) experience matches yours.

Tho FWIW, in my case I did find that one of the more common memory 
failure indicators was bz2-ed tarball decompression, where the tarball 
would fail its decompression checksum safety checks.  However, that most 
reliably happened in the context of a heavily loaded system doing other 
package builds in parallel to the package tarball extraction that failed.

In my case, I even had ECC RAM, but it was apparently just slightly out 
of spec for its labeled and internally configured memory speeds (PC3200 
DDR1 at the time), at least on my hardware.  Once I got a BIOS update 
that let me, I slightly downclocked the memory (to PC3000, IIRC), and it 
was absolutely solid, no more errors, even with tightened up wait-state 
timings.  Later I upgraded RAM, and the new RAM worked just fine at the 
same PC3200 speeds that were a problem for the older RAM.

The problem was apparently that while the RAM cells that memcheck checks 
were fine, it was testing in an otherwise calm environment (not much 
choice since you can only boot to the test directly and can't do anything 
else at the same time), without all the other stuff going on in the 
hectic environment of a multi-package parallel build, that apparently 
happened to occasionally trigger the edge-case that would corrupt things.

And FWIW, I still have major respect for how well reiserfs behaved under 
those conditions.  No filesystem can be expected to be 100% reliable when 
it's getting corrupted data due to bad memory, but reiserfs held up 
remarkably well, far better than btrfs did under similar conditions (but 
then with the PCI and SATA bus) a few year later, forcing me back to 
reiserfs for a time, which again, continued to work like a champ, even 
under hardware conditions that were absolutely unworkable with btrfs.  I 
had a heat-related (AC went out, in Phoenix, in the summer, 40+ C 
outside, 50+C inside, who knows what the disks were!?) head crash on a 
disk too, where the partitions that were mounted and likely had the head 
flying over them were damaged beyond (easy) recovery, but other 
partitions on the same disk were absolutely fine, and I actually 
continued to run off them for a few months after cooling everything back 
down.  That sort of experience is the reason I still use reiserfs on 
spinning rust, including my second and third level backups, even while 
I'm running btrfs on the ssds for the working system and primary backup.  
It's also the reason I continue to use a partitioned system with multiple 
independent filesystems (btrfs raid1 on a pair of ssds for most of the 
working btrfs and primary backups, individual ssd btrfs in dup mode for 
/boot, and its backup on the other ssd), instead of putting my data eggs 
all in the same filesystem basket with subvolumes, where if the 
filesystem goes out all the subvolumes go with it!

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

