Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:56035 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755006AbaKTAZq (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 19 Nov 2014 19:25:46 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1XrFZA-0005mA-RB
	for linux-btrfs@vger.kernel.org; Thu, 20 Nov 2014 01:25:44 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 20 Nov 2014 01:25:44 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 20 Nov 2014 01:25:44 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: scrub implies failing drive - smartctl blissfully unaware
Date: Thu, 20 Nov 2014 00:25:33 +0000 (UTC)
Message-ID: <pan$338ee$938a2625$869a26d$19fb9c42@cox.net>
References: <E1XqYMg-0000YI-8y@watricky.valid.co.za>
	<546AF572.2020101@swiftspirit.co.za> <20141118153526.GS20972@merlins.org>
	<47FB8035-FEA6-40E1-9672-5BBF92B283A9@colorremedies.com>
	<546BB2EA.5080809@ubuntu.com>
	<pan$7c051$a7c25939$cafa59e$f63379c9@cox.net>
	<546CC04F.6040207@ubuntu.com> <546D0609.9040105@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Robert White posted on Wed, 19 Nov 2014 13:05:13 -0800 as excerpted:

> One of the reasons that the whole industry has started favoring
> point-to-point (SATA, SAS) or physical intercessor chaining
> point-to-point (eSATA) buses is to remove a lot of those wait-and-see
> delays.
> 
> That said, you should not see a drive (or target enclosure, or
> controller) "reset" during spin up. In a SCSI setting this is almost
> always a cabling, termination, or addressing issue. In IDE its jumper
> mismatch (master vs slave vs cable-select). Less often its a
> partitioning issue (trying to access sectors beyond the end of the
> drive).
> 
> Another strong actor is selecting the wrong storage controller chipset
> driver. In that case you may be faling back from high-end device you
> think it is, through intermediate chip-set, and back to ACPI or BIOS
> emulation

FWIW I run a custom-built monolithic kernel, with only the specific 
drivers (SATA/AHCI in this case) builtin.  There's no drivers for 
anything else it could fallback to.

Once in awhile I do see it try at say 6-gig speeds, then eventually fall 
back to 3 and ultimately 1.5, but that /is/ indicative of other issues 
when I see it.  And like I said, there's no other drivers to fall back 
to, so obviously I never see it doing that.

> Another common cause is having a dedicated hardware RAID controller
> (dell likes to put LSI MegaRaid controllers in their boxes for example),
> many mother boards have hardware RAID support available through the
> bios, etc, leaving that feature active, then the adding a drive and
> _not_ initializing that drive with the RAID controller disk setup. In
> this case the controller is going to repeatedly probe the drive for its
> proprietary controller signature blocks (and reset the drive after each
> attempt) and then finally fall back to raw block pass-through. This can
> take a long time (thirty seconds to a minute).

Everything's set JBOD here.  I don't trust those proprietary "firmware" 
raid things.  Besides, that kills portability.  JBOD SATA and AHCI are 
sufficiently standardized that should the hardware die, I can switch out 
to something else and not have to worry about rebuilding the custom 
kernel with the new drivers.  Some proprietary firmware raid, requiring 
dmraid at the software kernel level to support, when I can just as easily 
use full software mdraid on standardized JBOD, no thanks!

And be sure, that's one of the first things I check when I setup a new 
box, any so-called hardware raid that's actually firmware/software raid, 
disabled, JBOD mode, enabled.

> But seriously, if you are seeing "reset" anywhere in any storage chain
> during a normal power-on cycle then you've got a problem  with geometry
> or configuration.

IIRC I don't get it routinely.  But I've seen it a few times, attributing 
it as I said to the 30-second SATA level timeout not being long enough.

Most often, however, it's at resume, not original startup, which is 
understandable as state at resume doesn't match state at suspend/
hibernate.  The irritating thing, as previously discussed, is when one 
device takes long enough to come back that mdraid or btrfs drops it out, 
generally forcing the reboot I was trying to avoid with the suspend/
hibernate in the first place, along with a re-add and resync (for mdraid) 
or a scrub (for btrfs raid).

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

