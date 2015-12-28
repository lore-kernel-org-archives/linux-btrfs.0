Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:34925 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750983AbbL1JMU (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 28 Dec 2015 04:12:20 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1aDTqj-0006RH-0o
	for linux-btrfs@vger.kernel.org; Mon, 28 Dec 2015 10:12:17 +0100
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 28 Dec 2015 10:12:17 +0100
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 28 Dec 2015 10:12:17 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: [PATCH] improve documentation of snapshot unaware defrag
Date: Mon, 28 Dec 2015 09:12:12 +0000 (UTC)
Message-ID: <pan$8f4d8$b41d6176$f01023c7$1278ea1a@cox.net>
References: <CAL3q7H6TGU2rz+zP8hcHxaDGx47nTrCndYvP9ArS+Z0HmZ86=A@mail.gmail.com>
	<1451185407-11422-1-git-send-email-mail@christoph.anton.mitterer.name>
	<pan$3bca9$74a60ba5$bf56792f$3c0040ca@cox.net>
	<1451263809.6320.9.camel@scientia.net>
	<20151228015807.GM1586@carfax.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hugo Mills posted on Mon, 28 Dec 2015 01:58:07 +0000 as excerpted:

> On Mon, Dec 28, 2015 at 01:50:09AM +0100, Christoph Anton Mitterer
> wrote:
>> On Sun, 2015-12-27 at 07:09 +0000, Duncan wrote:
>> > raid1 mode
>> I wonder when that reaches my pain threshold... and I submit a patch
>> that renames it "notreallyraid1" in all places ;-)
> 
> Isn't this an FAQ already? There is already a patch to rename the
> RAID modes. It's been sitting in the progs patch queue for about 2
> years, because none of the senior devs has acked it yet (since it's a
> big user-visible change).

I don't see it in the FAQ, but I see hints on both the sysadmin's guide 
and the usecases pages.

(Either the wiki or firefox seems to be having certificate problems ATM 
and all I'm getting is an OCSP response has an invalid sig error.  But 
the resurrect this page extension to the rescue, click the resurrect via 
google and I get it.  Links has no problem loading the page, but lynx 
does, so it's not just firefox.)

UseCases:

First section is RAID, first question there is on creating a raid1 mirror 
in btrfs.  It has this to say at the end of the answer:

>>>>>

NOTE This does not do the 'usual thing' for 3 or more drives. Until "N-
Way" (traditional) RAID-1 is implemented: Loss of more than one drive 
might crash the array. For now, RAID-1 means 'one copy of what's 
important exists on two of the drives in the array no matter how many 
drives there may be in it'.

<<<<<

SysadminGuide:

Second section is data usage and allocation.  First subsection there is 
RAID and data replication.  The first paragraph there is:

>>>>>

Btrfs's "RAID" implementation bears only passing resemblance to 
traditional RAID implementations. Instead, btrfs replicates data on a per-
chunk basis. If the filesystem is configured to use "RAID-1", for 
example, chunks are allocated in pairs, with each chunk of the pair being 
taken from a different block device. Data written to such a chunk pair 
will be duplicated across both chunks.

<<<<<

The multi-device page has little theoretical discussion, only discussing 
current status and having a bunch of specific commandline examples.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

