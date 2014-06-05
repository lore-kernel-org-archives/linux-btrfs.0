Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:37425 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751884AbaFEWZr (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 5 Jun 2014 18:25:47 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1Wsg6O-0000Js-OH
	for linux-btrfs@vger.kernel.org; Fri, 06 Jun 2014 00:25:40 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 06 Jun 2014 00:25:40 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 06 Jun 2014 00:25:40 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Using BTRFS on SSD now ?
Date: Thu, 5 Jun 2014 22:25:26 +0000 (UTC)
Message-ID: <pan$4b696$bb5c3db8$50f45a4e$fdad0f36@cox.net>
References: <2215647.hErg5R77lo@zafu> <20140605145632.GD14713@merlins.org>
	<FFF0E455-5905-47D4-A768-96CA2FEDF3B3@colorremedies.com>
	<20140605190526.GS7210@merlins.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Marc MERLIN posted on Thu, 05 Jun 2014 12:05:26 -0700 as excerpted:

> On Thu, Jun 05, 2014 at 12:13:37PM -0600, Chris Murphy wrote:
>> I'd say, what slight additional wear occurs from not using discard,
>> makes the SSD die sooner in order to justify getting a new SSD that
>> maybe (?) doesn't have this problem anymore.
> 
> Your points are well noted, although on the flipside I've had an SSD
> perform horribly because without TRIM, it had to use its own garbage
> collection which was horrible. Also, if you rely on garbage collection,
> you need to make sure to make an empty partition with 5 or 10% of your
> space and never use it so that yoru SSD can easily use that for garbage
> collection without impacting performance too much.

This subthread nicely addresses the subject next on my list to tackle in 
relation to this thread. =:^)

Here's the deal with trim/discard (two different names for the same 
feature):

Early SSDs didn't have it or had proprietary implementations, quickly 
making the community aware of the need.  Any decent and reasonably 
current SSD should offer the now standardized feature, but unfortunately, 
the initial standard made the trim instruction non-queued, so on a lot of 
hardware, issuing a trim instruction acts as an IO barrier, disrupting 
continued traffic to/from the device until the existing queue is emptied 
and the trim instruction completed, after which the queue can refill... 
until the next such operation.

As a result, while most current hardware supports trim/discard, on a lot 
of it, trim/discard in normal operation can reduce performance 
substantially. =:^(

For this sort of hardware, trim works best when used in flag-day fashion, 
at mkfs.btrfs for instance (and it /does/ issue a whole-range trim before 
setting up the filesystem), and periodically using tools such as fstrim.  
It does /not/ work so well when used routinely as part of the normal IO 
flow, when deleting a file or COWing a block, for instance, because these 
disrupt the normal hardware operations queue.

OTOH, certain high-performance hardware goes beyond the current standard 
and does a queued trim, without forcing a flush of the queue in the 
process.  But this hardware tends to be rather rare and expensive, and 
general claims to support trim can't be taken to indicate support for 
this sort of trim at all, so it tends to be a rather poor basis for a 
general recommendation or a routine-trim-by-default choice.

Then there's the encrypted device implications, which tend to favor not 
enabling discard/trim by default as well, due to the information leakage 
potential.

Thus we have the current situation, discard (aka trim) as a SEPARATE 
mount option from ssd, with ssd enabled by default where non-rotational 
storage is detected, but discard always requiring explicit invocation, as 
it simply isn't appropriate for a default option, at this point.

FWIW, the latest SATA standard (SATA 3.something) is said to explicitly 
support or perhaps even require queued trim support.  However, actual 
hardware with this support remains rare, at this point.

(FWIW, in new enough versions of smartctl, smartctl -i will have a "SATA 
Version is:" line, but even my newer Corsair Neutrons report only SATA 
2.5, so obviously they don't support queued trim by the standard, tho 
it's still possible they implement it beyond the standard, I simply don't 
know.)

Meanwhile, most authorities recommend leaving some portion of an SSD, 
typically 20-30% unformatted, thus giving the firmware plenty of room to 
manage erase-blocks as necessary, and that normally lessens the 
requirement to keep a nicely trimmed filesystem as well.

Here, it happened that when I was looking for SSDs, the 128 GB or so I 
figured I needed were either out of stock or the 256 GB or so versions 
were only a few dollars more expensive, so I ended up buying 256 GB 
versions where I had intended to buy 128 GB versions.  So in addition to 
actually putting more on the SSDs than I had originally intended (I still 
use lower cost spinning rust for my media partition, tho), I'm actually 
running only a bit over 50% partitioned, as well, with the rest of the 
SSDs being entirely unused, reserved for firmware erase-block management 
or for future use.  So I haven't actually worried much about whether I 
could efficiently turn on trim/discard or not, I just let the over-
provisioning handle it, along with doing a fresh mkfs.btrfs and restore 
from backup every few kernel cycles (and thus getting the mkfs.btrfs 
whole-filesystem trim in the process), in ordered to take advantage of 
the latest btrfs filesystem features. =:^)  I do occasional fstrims as 
well, but haven't worried about doing that in any scheduled fashion 
either, simply because what with fresh mkfs.btrfs every few kernel cycles 
and with nearly 100% overprovisioning, I've not needed to.  Tho I 
probably will once btrfs development slows down and there aren't new 
filesystem format features to be taken advantage of every few kernel 
cycles.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

