Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:49716 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751172AbaFPMQr (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 16 Jun 2014 08:16:47 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1WwVq9-00060W-Jq
	for linux-btrfs@vger.kernel.org; Mon, 16 Jun 2014 14:16:45 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 16 Jun 2014 14:16:45 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 16 Jun 2014 14:16:45 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: BTRFS, SSD and single metadata
Date: Mon, 16 Jun 2014 12:16:33 +0000 (UTC)
Message-ID: <pan$5075b$6568c7ca$c4158fb1$b65edba2@cox.net>
References: <1723493.aXdklhDgAK@vajra>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Swâmi Petaramesh posted on Mon, 16 Jun 2014 09:54:01 +0200 as excerpted:

> I created a BTRFS filesytem over LVM over LUKS encryption on an SSD
> [yes, I know...], and I noticed that the FS got created with metadata in
> "DUP" mode, contrary to what "man mkfs.btrfs" says for SSDs -> it would
> be supposed to be "SINGLE"...
> 
> Well I don't know if my system didn't identify the SSD because of the
> LVM+LUKS stack (however it mounts well by itself with the "ssd" flag and
> accepts the "discard" option [yes, I know...]), or if the manpage is
> obsolete or if this feature just doesn't work...?

Does btrfs automatically add the ssd mount option or do you have to add 
it?  If you have to add it, that means btrfs isn't detecting the ssd, 
which would explain why mkfs.btrfs didn't detect it either... as you said 
very likely due to the LVM over LUKS stack.

I believe the detection is actually based on what the kernel reports.  I 
may be mistaken and I'm not running stacked devices ATM in ordered to 
check them, but check /sys/block/<device>/queue/rotational.  On my ssds, 
the value in that file is 0.  On my spinning rust, it's 1.  If that is 
indeed what it's looking at, you can verify that your hardware device is 
actually detected by the kernel as rotational 0, and then check the 
various layers of your stack and see where the rotational 0 (or the 
rotational file itself) gets dropped.

> The SSD being a Micron RealSSD C400
> 
> For both SSD preservation and data integrity, would it be advisable to
> change metadata to "SINGLE" using a rebalance, or if I'd better just
> leave things the way they are...?
> 
> TIA for any insight.

That's a very good question, on which there has been some debate on this 
list.

The first question:  Does your SSD firmware do compression and dedup, or 
not?  IIRC the sandforce (I believe that's the firmware name) firmware 
does compression and dedup, but not all firmware does.  I know a bullet-
point feature of my SSDs (several Corsair Neutron 256 GB, FWIW) is that 
they do NOT do this sort of compression and dedup -- what the system 
tells them to save is what they save, and if you tell it to save a 
hundred copies of the same thing, that's what it does.  (These SSDs are 
targeted at commercial usage and this is billed as a performance 
reliability feature.)

The reason originally given for defaulting to single mode metadata on 
SSDs was that it was due to this possible dedup -- dup-mode metadata 
might actually end up single-copy-only due to the firmware compression 
and dedup in any case.  Between that and their typically smaller size, I 
guess the decision was that single was the best default.

However, it occurs to me that with the LUKS encryption layer, I'm not 
entirely sure if duplication at the btrfs level would end up as the same 
encrypted stream headed to the hardware in any case.  If it would encrypt 
the two copies of the dup-mode metadata as different, then the hardware 
dedup/compression wouldn't work on it anyway.  OTOH, if it encrypts them 
as the same stream headed to hardware, then again, it would matter.

Meanwhile... which is better and should you rebalance to single?  In 
terms of data integrity, dup mode is definitely better, since if there's 
damage to one copy such that it doesn't pass checksum verification, you 
still have the other copy to read from... and to rebuild the damaged copy 
from.

OTOH, single does take less space, and performance should be slightly 
better.  If you're keeping good backups anyway, or if the ssd's firmware 
might be mucking with things leaving you with only a single copy in any 
case, single mode could be a better choice.


FWIW, while most of my partitions are btrfs raid1 here, so the second 
copy is on a different physical device, /boot is an exception.  I have a 
separate /boot on each device, pointed at by the grub loaded on each 
device so I can use the BIOS boot selector to choose which one I boot.  
That lets me keep a working /boot that I boot most of the time on one 
device, and a backup /boot on the other device, in case something goes 
wrong with the first.

So those dedicated /boot partitions are an exception to my normal btrfs 
raid1.  They're both (working and primary backup) 256 MiB mixed-data/
metadata mode as they're so small, which means data and metadata must 
both be the same mode, and they're both set to dup mode.

Which means they effectively only hold (a bit under) 128 MiB worth of 
data, since it's dup mode for both data and metadata, but 128 MiB is fine 
for /boot, as long as I don't let too many kernels build up.

So I'd obviously recommend dup mode, unless you know your ssd's firmware 
is going to dedup it anyway.  But that's just me.  As I said, there has 
been some discussion about it on the list, and some people make other 
choices.  You can of course dig in the list archives if you want to see 
previous threads on the subject, but ultimately, it's upto you. =:^)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

