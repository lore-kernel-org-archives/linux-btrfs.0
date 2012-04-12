From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Wiki update request: source repo page   Was: [PATCH] Btrfs: use
 i_version instead of our own sequence
Date: Thu, 12 Apr 2012 22:56:00 +0000 (UTC)
Message-ID: <pan.2012.04.12.22.56.00@cox.net>
References: <1333986794-6525-1-git-send-email-josef@redhat.com>
	<CALLzPKY0ViBnaH8PVOmxad+oPpbWiYOz24+Lc8CWNuzKbyHHng@mail.gmail.com>
	<20120412133107.GC1924@localhost.localdomain>
	<pan.2012.04.12.21.41.17@cox.net> <20120412215546.GB4856@carfax.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hugo Mills posted on Thu, 12 Apr 2012 22:55:46 +0100 as excerpted:

> On Thu, Apr 12, 2012 at 09:41:17PM +0000, Duncan wrote:

>> 4) The instructions appear to assume a kernel module an initr* based
>> setup.  What about people who configure and build a custom monolithic
>> kernel, with module loading disabled?
> 
> Then in general, they're stuffed.
> 
> If you want to mount a multi-device filesystem, you have to run
> btrfs dev scan before it's mounted. If that filesystem is your root
> filesystem, then you have to do it before root is mounted. This requires
> an initramfs/initrd.
> 
> It is possible to supply a full list of explicit device names for
> the root FS to the kernel at boot time with the device= mount parameter,
> but this is unreliable at best. We certainly had a very hard time
> getting it to work last time the issue came up on IRC.
> 
> The general advice is -- use a single-device root filesystem, or an
> initramfs. These are simple, supported, and will generally get good
> help. Any other configuration will cause you to be told to use an
> initramfs. So far, I've not heard any concrete reason why one shouldn't
> be used except "ooh, I don't understand them, and they're scary!".

FWIW, device names appear to be reasonably stable, here.  Stable enough 
that I currently have this built into the kernel as part of my kernel 
command line:

md=3,/dev/sda6,/dev/sdb6,/dev/sdc6,/dev/sdd6 root=/dev/md3p1

When I need to override that to mount the primary backup/recovery root, 
this as part of grub2's linux line extends/overrides the kernel builtin:

md=9,/dev/sda12,/dev/sdb12,/dev/sdc12,/dev/sdd12 root=/dev/md9p1

When I boot from thumbdrive or otherwise might trigger device reordering, 
grub's interactivity allows me to find the correct mds and substitute 
device names as appropriate.  And yes, if you're wondering,
init=/bin/bash is tested and known to work, too. =:^)

I don't see why btrfs would have additional kernel device naming or 
finding problems that md doesn't already have.

So while I'd agree that multi-device noinitr* btrfs builtin might not be 
appropriate as a general distro-wide solution, it does seem quite 
reasonable (here) for sysadmins familiar enough with their own systems to 
have custom-built no-module-loading kernels in general, to be able to do 
the same with btrfs.

That's one of a couple reasons I don't use lvm2, as well.  Both lvm2 and 
an initr* add complexity and thus recovery failure risk due to admin fat-
fingering or failure to anticipate and test all permutations of failure 
mode, for little or no gain in my current deployments.  Because lvm2 
requires an initr* to handle root, it's TWO such layers of additional 
complexity to test the failure modes for and be prepared to deal with at 
recovery time.  The added complexity and risk is simply not a reasonable 
tradeoff, for me, and I sleep better with a tested confidence in my 
disaster recovery abilities.  =:^)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

