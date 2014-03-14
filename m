Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:43482 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753644AbaCNMIX (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 14 Mar 2014 08:08:23 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1WOQuU-0002An-Fn
	for linux-btrfs@vger.kernel.org; Fri, 14 Mar 2014 13:08:22 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 14 Mar 2014 13:08:22 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 14 Mar 2014 13:08:22 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: discard synchronous on most SSDs?
Date: Fri, 14 Mar 2014 12:07:54 +0000 (UTC)
Message-ID: <pan$667da$c4955705$c59674a0$a844850c@cox.net>
References: <531C1CC4.701@gmail.com> <1553599.dDs6U900Vh@tethys>
	<3438733.p6vCjojJlH@merkaba> <1756989.4ep0Vdupld@tethys>
	<20140309113350.GH6318@carfax.org.uk> <20140314021159.GQ18959@merlins.org>
	<C13A2AFA-A9F0-4219-879C-F1C15ADC63A9@colorremedies.com>
	<20140314051750.GY6143@merlins.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Marc MERLIN posted on Thu, 13 Mar 2014 22:17:50 -0700 as excerpted:

> On Thu, Mar 13, 2014 at 09:39:02PM -0600, Chris Murphy wrote:
>> 
>> On Mar 13, 2014, at 8:11 PM, Marc MERLIN <marc@merlins.org> wrote:
>> 
>> > On Sun, Mar 09, 2014 at 11:33:50AM +0000, Hugo Mills wrote:
>> >> discard is, except on the very latest hardware, a synchronous
>> >> command (it's a limitation of the SATA standard), and therefore
>> >> results in very very poor performance.
>> > 
>> > Interesting. How do I know if a given SSD will hang on discard?
>> > Is a Samsung EVO 840 1TB SSD latest hardware enough, or not? :)
>> 
>> smartctl -a or -x will tell you what SATA revision is in place. The
>> queued trim support is in SATA Rev 3.1. I'm not certain if this
>> requires only the drive to support that revision level, or both
>> controller and drive.
> 
> I'm not sure I'm seeing this, which field is that?

> ATA Version is:   8
> ATA Standard is:  ATA-8-ACS revision 4c

Your drive didn't report it, but here, I have SATA fields as well, in 
addition to the ATA fields:

Here's the fields from my Corsair Neutron SSDs:

ATA Version is:   ATA8-ACS (minor revision not indicated)
SATA Version is:  SATA 2.5, 6.0 Gb/s

Here's the fields from my Seagate 500-gig 2.5-inch spinning rust:

ATA Version is:   ATA8-ACS T13/1699-D revision 4
SATA Version is:  SATA 2.6, 3.0 Gb/s

(More about that below.)

Smartctl version here is 6.2 2013-07-26 r3841, according to the output. 
(I'm running gentoo/~amd64 FWIW so it's a local-build). You snipped that 
bit of your output so I can't compare.

But it may also depend on whether smartctl auto-detected and used the ATA 
or the SCSI (or something else) command set and how your devices are 
actually connected, plus BIOS settings, etc.  See the manpage 
documentation for the -d TYPE (--device=TYPE) option and the ATA/SCSI/SAT 
discussion rather further down the manpage for more.

Here I have direct SATA connections with the BIOS set to AHCI mode and am 
thus using the kernel's AHCI drivers, since that's the most common SATA 
chipset standard these days, thus increasing portability given my 
monolithic kernel build.

smartctl's -d test reports an original guess of scsi, changed to sat 
after detection.

Of course connection via USB bridge or the like complicates things 
considerably.


Meanwhile, SATA 2.5, 6 Gb/s on the SSDs, SATA 2.6, 3 Gb/s on the spinning 
rust?  WTF?  The SSDs have SATA 2.5 but 6 Gb/s while the spinning rust 
has a later 2.6 but only 3 Gb/s (tho of course on a mechanical drive the 
bus speed won't be the bottleneck)?  Now I'm confused.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

