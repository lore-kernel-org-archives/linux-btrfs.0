Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:49730 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752936AbaJNVft (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 14 Oct 2014 17:35:49 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1Xe9kv-0007C6-90
	for linux-btrfs@vger.kernel.org; Tue, 14 Oct 2014 23:35:45 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 14 Oct 2014 23:35:45 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 14 Oct 2014 23:35:45 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: btrfs random filesystem corruption in kernel 3.17
Date: Tue, 14 Oct 2014 21:35:31 +0000 (UTC)
Message-ID: <pan$67a58$c42f6156$af002a14$c1094f5a@cox.net>
References: <543450DC.90504@prnet.org>
	<1412714780.2374.0@mail.thefacebook.com> <543A61EE.7070200@prnet.org>
	<CAGfcS_k7Y2-j3moyFw3j0gzb6Xuj-AutfjvZzEnpMem-z0KPRA@mail.gmail.com>
	<543C35C3.9070002@prnet.org>
	<CAGfcS_n5+ToT6kM5+J9TLjdwpriC3uu7hg2HVZXTmTSo-URO9Q@mail.gmail.com>
	<pan$e02d1$5d8cd0cc$87f3cfc$b14a0d51@cox.net>
	<c2103f1c229cdd887b8743d0946a8a8f@prnet.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

admin posted on Tue, 14 Oct 2014 13:17:41 +0200 as excerpted:

>> And if you're affected, be aware that until we have a fix, we don't
>> know if it'll be possible to remove the affected and currently
>> undeletable snapshots.  If it's not, at some point you'll need to do a
>> fresh mkfs.btrfs, to get rid of the damage.  Since the bug doesn't
>> appear to affect writable snapshots or the "head" from which snapshots
>> are made, it's not urgent, and a full fix is likely to include a patch
>> to detect and fix the problem as well, but until we know what the
>> problem is we can't be sure of that, so be prepared to do that mkfs at
>> some point, as at this point it's possible that's the only way you'll
>> be able to kill the corrupted snapshots.
> 
> I don't agree with you concerning the not urgent part. In my opinion,
> any problem leading to filesystem or other data corruption should be
> considered as urgent, at least as long as it isn't known what exactly is
> affected and whether there is a simple way to salvage the corruption
> without going the backup/restore route.

I shouldn't have used a pronoun there as "it" wasn't clear.

By "it", I didn't mean the bug, which I agree is urgent for the reasons 
you state, but the mkfs.  Since there's currently no fix for the bug but 
it (the bug) seems to be limited to read-only snapshots at this point, 
_doing_the_mkfs_ isn't urgent.  With the damage limited to the read-only 
snapshots, you don't have to drop everything and do a mkfs _right_now_ to 
be rid of it.

But at some point, presumably after a fix is in place, since the damaged 
snapshots aren't currently always deletable, if the fix only prevents new 
damage from occurring and doesn't provide a way to fix the damaged ones, 
then mkfs would be the only way to do so.  With the damage limited to 
those snapshots and not spreading to normal writable snapshots or the 
working copy, dropping everything to do that mkfs isn't urgent, but it 
(the mkfs) will need to be done at some point to clear the undeletable 
snapshots, again, assuming the fix doesn't provide a way to get rid of 
them (the currently undeletable snapshots).

That's what I meant.  Yes the bug is urgent.  Doing a mkfs _right_now_ to 
get rid of the damage, not so much, because by all accounts so far the 
damage is limited to those read-only snapshots and isn't affecting 
ordinary writable snapshots or the working copies.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

