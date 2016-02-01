Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:56241 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750899AbcBAXCx (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 1 Feb 2016 18:02:53 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1aQNUh-0007F5-TW
	for linux-btrfs@vger.kernel.org; Tue, 02 Feb 2016 00:02:52 +0100
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 02 Feb 2016 00:02:51 +0100
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 02 Feb 2016 00:02:51 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: booting from BTRFS works only with one device in the pool
Date: Mon, 1 Feb 2016 23:02:42 +0000 (UTC)
Message-ID: <pan$10266$74d6d340$652029ad$fa234679@cox.net>
References: <56AFCEC3.9050803@friedels.name>
	<20160201221120.GD8313@carfax.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hugo Mills posted on Mon, 01 Feb 2016 22:11:20 +0000 as excerpted:

> On Mon, Feb 01, 2016 at 10:31:47PM +0100, Hendrik Friedel wrote:
>> Hello,
>> 
>> I am running CentOS from a btrfs root.
>> This worked fine until I added a device to that pool:
>> btrfs device add /dev/sda3 /
>> reboot
>> 
>> This now causes the errors:
>> BTRFS: failed to read chunk tree on sdb3 BTRFS: open_ctree failed
>> 
>> Here  I am stuck in a recovery prompt.
>> 
>> btrfs fi show displays the file system correctly with 2.1GiB used for
>> sdb3 and 0.00GiB used on sda3
> 
> By far the simplest and most reliable method of doing this is to
> use an initramfs with the command "btrfs dev scan" in it somewhere
> before mounting. Most of the major distributions already have an
> initramfs set up (as does yours, I see), and will install the correct
> commands in the initramfs if you install the btrfs-progs package
> (btrfs-tools in Debian derivatives).
> 
> The other approach is to add "device=/dev/sda3,device=/dev/sdb3" to
> the "rootflags=" option on the grub command line, but that's going to
> break if your kernel or hardware decides to reorder your devices.

As a btrfs user with a two-device btrfs root filesystem who has had to 
deal with this same problem myself...

Unless the problem has been fixed in very recent kernels, device= doesn't 
work in rootflags= for btrfs on the kernel commandline in any case.  I 
don't know why, but I suspect it might be the fact that with 
rootflags=device=, there's at least two =, and the kernel may split it at 
the wrong = and instead of seeing a rootflags= option it knows what to do 
with, it sees a rootflags=device= option that it ignores as making no 
sense, making it a kernel commandline parsing bug.  Alternatively, 
another poster hinted that the kernel may get it correct, but btrfs for 
some reason can't use device= in the form it gets passed in from 
rootflags=, while it can use it when passed in from userspace, which 
would make it a btrfs bug.

Either way, (1) the problem isn't new and has been there for quite some 
time, since early in the kernel 3.x era at least, but (2) other options 
such as degraded _can_ be passed successfully by rootflags=, so btrfs can 
use rootflags= in general, it just has problems with device=, for 
whatever reason.

Which means...

> Do the sensible thing and just use the initramfs solution.

Exactly.

For over a decade I used reiserfs on / and was able to avoid an initr* 
entirely.  And single-device btrfs / works without an initr*.  But multi-
device... not so much.  While I definitely wasn't thrilled at the 
prospect of having to complicate my boot process with an initr* that 
_shouldn't_ be necessary, and had to spend some time learning about initr* 
(I had initially dumped initr* early in my Linux experience and hadn't 
had to learn about them until I tried multi-device btrfs /) so as to be 
able to satisfy myself that I could work with it in both normal operation 
and disaster recovery scenarios...

At this point there's really only two choices if you want multi-device 
btrfs /, either use an initr* and have your multi-device btrfs /, or give 
up on multi-device btrfs / and be satisfied with a more traditional 
single-device /, btrfs or otherwise.

Well, unless you're a kernel-level dev sufficiently motivated to look 
into the problem, devise a patch to solve the problem, and get that patch 
thru the approval process and into kernel mainline.  In that case there's 
three options, and I dearly wish someone with the necessary kernel level 
coder qualification would take that third option, making initr*less multi-
device btrfs / a viable option for the rest of us who in the mean time 
are stuck with only the first two options!

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

