Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:52731 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750894AbbL1CQf (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 27 Dec 2015 21:16:35 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1aDNMO-0004FN-EF
	for linux-btrfs@vger.kernel.org; Mon, 28 Dec 2015 03:16:32 +0100
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 28 Dec 2015 03:16:32 +0100
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 28 Dec 2015 03:16:32 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Btrfs scrub failure for raid 6 kernel 4.3
Date: Mon, 28 Dec 2015 02:16:18 +0000 (UTC)
Message-ID: <pan$ce4e4$679c0a1$8ea944a8$22d67149@cox.net>
References: <567FEEB6.3080701@online.no>
	<CAJCQCtSHWTqn7zzCtUtGjpr5=dMqfC1aGWaeNpZyVVhjrCvDHg@mail.gmail.com>
	<1451263174.6320.5.camel@scientia.net>
	<CAJCQCtTmiKcapPpZ62Ko6mZK_MSDAFS2FAwU8CUJxkWwu-nYuw@mail.gmail.com>
	<1451264981.6320.15.camel@scientia.net>
	<CAJCQCtQ29Jwmywz+TrkYC6RuDpsk4v3gOkfmBGoxPahy5Nk--g@mail.gmail.com>
	<1451266276.6320.31.camel@scientia.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Christoph Anton Mitterer posted on Mon, 28 Dec 2015 02:31:16 +0100 as
excerpted:

> On Sun, 2015-12-27 at 18:23 -0700, Chris Murphy wrote:
>> I'd want scrub to immediately fail in a degraded case, because the
>> higher workload added by the scrub itself could cause additional device
>> failures sooner. And that would negatively impact the ability to get
>> the array healthy again with a rebuild - during which time you wouldn't
>> want the scrub running anyway.
> I think that should be the default behaviour, yes.
> 
> Probebly there should be a --force like override switch,... again take
> my example of classic RAID1 with say 6 disks... (which is right now not
> possible in btrfs, I know).
> Now one fails... so it's degraded, but you still have 5 left and you're
> probably far away from complete loss. OTOH you still may want to scrub
> your data during during that time (e.g. to catch silent block errors),
> in that specific scenario.

Scrub needs to be able to run on a degraded array (possibly with a 
--force switch, I've no real opinion on that), for a number of reasons:

1) As mentioned up-thread, btrfs scrub isn't like others; we have 
checksums and being able to do a global checksum-verify via scrub, even 
on a degraded array where repair may not be possible, is a legitimate use.

2) With raid6 degraded by loss of only a single device, repair should 
still be possible (and checksums should counteract the partial-stripe-
write hole that parity normally risks, verify the "repair" and don't 
write it if it still fails checksum).

3) With the coming N-way-mirroring, degraded repair from a good copy of 
an N-way-mirrored block down to two-way should be possible, and indeed, 
that'd be the biggest reason to run N-way-mirroring with N>2 in the first 
place.


But regardless, agreed with everyone, simply crashing must be seen as a 
bug.  If it's not going to scrub correctly, it should exit normally but 
with an error status and printout to STDERR, not crash.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

