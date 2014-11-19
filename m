Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:35450 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753731AbaKSCqn (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 18 Nov 2014 21:46:43 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1XqvI2-00031T-68
	for linux-btrfs@vger.kernel.org; Wed, 19 Nov 2014 03:46:42 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 19 Nov 2014 03:46:42 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 19 Nov 2014 03:46:42 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: scrub implies failing drive - smartctl blissfully unaware
Date: Wed, 19 Nov 2014 02:46:29 +0000 (UTC)
Message-ID: <pan$7c051$a7c25939$cafa59e$f63379c9@cox.net>
References: <E1XqYMg-0000YI-8y@watricky.valid.co.za>
	<546AF572.2020101@swiftspirit.co.za> <20141118153526.GS20972@merlins.org>
	<47FB8035-FEA6-40E1-9672-5BBF92B283A9@colorremedies.com>
	<546BB2EA.5080809@ubuntu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Phillip Susi posted on Tue, 18 Nov 2014 15:58:18 -0500 as excerpted:

> Are there really any that take longer than 30 seconds?  That's enough
> time for thousands of retries.  If it can't be read after a dozen tries,
> it ain't never gonna work.  It seems absurd that a drive would keep
> trying for so long.

I'm not sure about normal operation, but certainly, many drives take 
longer than 30 seconds to stabilize after power-on, and I routinely see 
resets during this time.

In fact, as I recently posted, power-up stabilization time can and often 
does kill reliable multi-drive device or filesystem (my experience is 
with mdraid and btrfs raid) resume from suspend to RAM or hibernate to 
disk, either one or both, because it's often enough the case that one 
device or another will take enough longer to stabilize than the other, 
that it'll be failed out of the raid.

This doesn't happen on single-hardware-device block devices and 
filesystems because in that case it's either up or down, if the device 
doesn't come up in time the resume simply fails entirely, instead of 
coming up with one or more devices there, but others missing as they 
didn't stabilize in time, as is unfortunately all too common in the multi-
device scenario.

I've seen this with both spinning rust and with SSDs, with mdraid and 
btrfs, with multiple mobos and device controllers, and with resume both 
from suspend to ram (if the machine powers down the storage devices in 
that case, as most modern ones do) and hibernate to permanent storage 
device, over several years worth of kernel series, so it's a reasonably 
widespread phenomena, at least among consumer-level SATA devices.  (My 
experience doesn't extend to enterprise-raid-level devices or proper 
SCSI, etc, so I simply don't know, there.)

While two minutes is getting a bit long, I think it's still within normal 
range, and some devices definitely take over a minute enough of the time 
to be both noticeable and irritating.

That said, I SHOULD say I'd be far *MORE* irritated if the device simply 
pretended it was stable and started reading/writing data before it really 
had stabilized, particularly with SSDs where that sort of behavior has 
been observed and is known to put some devices at risk of complete 
scrambling of either media or firmware, beyond recovery at times.  That 
of course is the risk of going the other direction, and I'd a WHOLE lot 
rather have devices play it safe for another 30 seconds or so after they /
think/ they're stable and be SURE, than pretend to be just fine when 
voltages have NOT stabilized yet and thus end up scrambling things 
irrecoverably.  I've never had that happen here tho I've never stress-
tested for it, only done normal operation, but I've seen testing reports 
where the testers DID make it happen surprisingly easily, to a surprising 
number of their test devices.

So, umm... I suspect the 2-minute default is 2 minutes due to power-up 
stabilizing issues, where two minutes is a reasonable compromise between 
failing the boot most of the time if the timeout is too low, and taking 
excessively long for very little further gain.

And in my experience, the only way around that, at the consumer level at 
least, would be to split the timeouts, perhaps setting something even 
higher, 2.5-3 minutes on power-on, while lowering the operational timeout 
to something more sane for operation, probably 30 seconds or so by 
default, but easily tunable down to 10-20 seconds (or even lower, 5 
seconds, even for consumer level devices?) for those who had hardware 
that fit within that tolerance and wanted the performance.  But at least 
to my knowledge, there's no such split in reset timeout values available 
(maybe for SCSI?), and due to auto-spindown and power-saving, I'm not 
sure whether it's even possible, without some specific hardware feature 
available to tell the kernel that it has in fact NOT been in power-saving 
mode for say 5-10 minutes, hopefully long enough that voltage readings 
really /are/ fully stabilized and a shorter timeout is possible.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

