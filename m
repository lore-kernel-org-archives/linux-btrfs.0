Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:52640 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751857AbaATREi (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 20 Jan 2014 12:04:38 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1W5IH4-0007f2-Gw
	for linux-btrfs@vger.kernel.org; Mon, 20 Jan 2014 18:04:34 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 20 Jan 2014 18:04:34 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 20 Jan 2014 18:04:34 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Confirmation on how btrfs works with RAID and single.
Date: Mon, 20 Jan 2014 17:04:11 +0000 (UTC)
Message-ID: <pan$639a0$5630e1c0$adc2c5bf$313ef79d@cox.net>
References: <CANjusZdjBTzreOTc3xvNeiu-LOBzbO2kLCOmjn=m19B-76m67w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

G. Michael Carter posted on Mon, 20 Jan 2014 10:43:59 -0500 as excerpted:

> I'm pretty sure I know the answers but just wanted confirmation.
> 
> 
> RAID1:  When it reads does it read from only one disk or does it try to
> read from multiple disks?

*) Btrfs will read from one device[1] at a time, per thread.  AFAIK which 
one it reads from is currently determined by a not ideal, but suitable 
for original first-working-hack implementation, even/odd-PID-based round-
robin, so while one thread will always read from the same device, 
assuming a reasonable balance in even/odd PID/TID and I/O activity (not 
always a reasonable assumption), overall use should be balanced between 
the pair.

a) The devs are aware that the current even/odd-PID algorithm isn't ideal 
and will presumably replace it at some point, but it's what we have now.

b) Btrfs raid1 is currently 2-way-mirroring, regardless of the number of 
devices.  Three or more devices just means it alternates which two are 
paired.  N-way-mirroring is on the roadmap, mapped in for introduction 
after raid5/6 completion (the currently available raid5/6 mode isn't 
complete, lacking scrub support and proper device recovery support, etc), 
and that's my single-most-wanted-but-still-lacking feature, but it's not 
there yet, so device pairing with even/odd-PID round-robining is what 
raid1 mode does, at present.

> Single:  When it writes does it simple fill up one drive then move to
> the next or does it write in a round robin type fashion?

AFAIK, single mode allocates and fills up a "chunk" at a time, one device 
at a time, then moves on to the next "chunk", which in a multi-device all-
equal-sizes case, will often be on a different device, tho that isn't 
required.  (Data chunks are 1 GiB in size; metadata chunks a quarter GiB 
aka 256 MiB.)

Raid0 mode, OTOH, stripes at the sub-chunk level, I believe a btrfs 
sector (4 KiB on x86/amd64) per device at a time.  Chunk allocation is 
full available width, one chunk on each available device, thus N chunks 
allocated at once, with multiple stripe-lengths per chunk.  (The wiki 
used to say otherwise, paired-chunk-allocation as with raid1, but Hugo 
and I discussed that and I believe he changed that on the wiki too.)

So single mode on a multi-device filesystem can be /loosely/ thought of 
as raid0 with REALLY HUGE 1 GiB single-devide stripe-depth and a not 
entirely strict device-stripe allocation policy.

Conversely, raid0 mode can be thought of as single mode with much smaller 
sub-chunk striping and strict device-stripe allocation.

---
[1] Device vs. drive vs. disk:  I'm in the midst of a habit change, 
trying to replace usage of "disk" or "drive" with "device" where 
appropriate, which is most cases, since "disk" arguably implies physical 
spinning rust and "drive" may be spinning rust or SSD but still implies 
physical, while "device" implicitly acknowledges the virtual possibility 
as well.  So when I'm thinking about it I try to use "device" unless I 
specifically mean physical drive or literal spinning disk, but when I'm 
thinking about other things, "drive" or "disk" may slip in, and I haven't 
gone back and done a statistical analysis of how often I slip up.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

