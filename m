Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:37589 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751983AbaEKC2i (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 10 May 2014 22:28:38 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1WjJVE-0000gW-7R
	for linux-btrfs@vger.kernel.org; Sun, 11 May 2014 04:28:36 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 11 May 2014 04:28:36 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 11 May 2014 04:28:36 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: btrfs cleaner failure - fs/btrfs/extent-tree.c:5748 (3.14.0)
Date: Sun, 11 May 2014 02:28:23 +0000 (UTC)
Message-ID: <pan$31216$3d0b94d7$92fede49$858a4a3e@cox.net>
References: <20140507233959.GB11401@merlins.org> <536AD20E.70004@fb.com>
	<20140508004344.GE11401@merlins.org> <20140508013440.GH11401@merlins.org>
	<CAKgsxVR=6GTesbtqG_SAyKnpw9pxz1TZ0oOi_MB8Ej3j4-vMiw@mail.gmail.com>
	<20140508220242.GO11401@merlins.org>
	<CAKhhfD5DTPfKvWcRDERxWa_pjfhCkZxW3WBtznYC94EFy7A0mQ@mail.gmail.com>
	<423AB9BE-EDBF-478B-8CED-C1A9A0FAE736@colorremedies.com>
	<20140509223659.GW11401@merlins.org>
	<0AE72D68-224C-4B12-9C9B-3B7628174ACB@colorremedies.com>
	<20140510010902.GQ16185@carfax.org.uk>
	<CAKhhfD5c+poPPEYd=VLcU7m8xjORx9yc8TY7M3jZDRUapRX__w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Marc MERLIN posted on Fri, 09 May 2014 20:40:26 -0700 as excerpted:

> On May 10, 2014 10:09 AM, "Hugo Mills" <hugo@carfax.org.uk> wrote:
>>    As in, "Your filesystem got corruption as a result of a bug in some
>> earlier version. Upgrading to the new version isn't magically going to
>> make that corruption go away". (Not saying that's what's happened here,
>> but it's common, and commonly misunderstood).
> 
> That's a fair point but I run scrub every day with errors if any, mailed
> to me.
> Can scrub miss latent corruption?

Depends on the type of corruption.  Scrub simply checks the checksums, 
replacing any bad copies it finds with good copies if there's good copies 
to do so with (thus my raid1 here, giving me an alternate to look at, too 
bad I can't get N-way-mirroring yet and have a second alternate just in 
case).  Bitflipping and random corruption, it should detect and if 
possible fix, no problem.

But if the bug was a logic error and btrfs validly checksummed bad 
(meta)data due to that faulty logic, scrub won't do anything to find 
that, because all it does is validate the checksum and that's perfectly 
fine -- the result of the faulty logic was still faulty, but perfectly 
retained. =:^\

Faulty logic is what rebalance and btrfs check will try to detect, except 
unlike checksums which are binary case and match or don't match, there's 
all /sorts/ of ways logic can be faulty, and given the immaturity of the 
tools, there's still some decent gaps in what they'll detect -- there's a 
LOT more ways that the filesystem can be wrong and the logic faulty than 
we know about yet, and if we don't know about it, it's pretty hard to 
test for it.

(Let alone the case of btrfs check /thinking/ it detects something wrong, 
but either it's fine, or it's wrong in a different way than btrfs check 
thinks, such that btrfs check --repair could actually make things 
worse... thus the recommendation not to blindly run --repair, only as a 
last resort before a new mkfs, or on the specific recommendation of a 
dev.)

Bottom line, if the logic was wrong, scrub isn't likely to catch the 
problem, since the checksum on the faulty logic output can and likely 
will still be perfectly valid.  It's simply the wrong tool to detect that 
sort of error.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

