Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:38939 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750944AbaAJPxr (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 10 Jan 2014 10:53:47 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1W1eP3-0008Mb-Uo
	for linux-btrfs@vger.kernel.org; Fri, 10 Jan 2014 16:53:45 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 10 Jan 2014 16:53:45 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 10 Jan 2014 16:53:45 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: backpointer mismatch
Date: Fri, 10 Jan 2014 15:53:19 +0000 (UTC)
Message-ID: <pan$3cf85$2453ae59$210fcea3$d7c39e55@cox.net>
References: <52CF7032.3090004@oma.be>
	<pan$d701f$adb6e087$f10cdac$a6ccb243@cox.net>
	<20140110211659.2bc9e1d7@natsu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Roman Mamedov posted on Fri, 10 Jan 2014 21:16:59 +0600 as excerpted:

> On Fri, 10 Jan 2014 14:26:19 +0000 (UTC)
> Duncan <1i5t5.duncan@cox.net> wrote:
> 
>> IOW, your backups shouldn't be btrfs, because btrfs itself is testing,
>> and any data stored on it is by definition testing-only data you don't
>> particularly care about, either because you have good tested-restorable
>> backups, or because the data really isn't that valuable to you in the
>> first place.
> 
> On the contrary, I think a backup storage area is an excellent place to
> start rolling-out btrfs from, because:
> 
> 1) the snapshot capability 

Point agreed. =:^)

> 2) it's *backups*, by definition it's non-unique replaceable data that
> also exists elsewhere (and in this case on the primary storage, that's
> probably much less experimental and more redundant as well).
> 
> My primary storage is currently Ext4 and backups are all on btrfs.

But what happens if you actually /need/ those backups, and in going to 
use them, you find they're bugged due to some as yet unfixed bug in still 
under development btrfs?

To me, the /point/ of backups is reliability.  I need to *KNOW* they're 
reliable, and btrfs simply isn't intended or claimed to provide that 
guaranteed stable reliability yet.

While admittedly a lot of people are now using btrfs without issue, and 
I'm using it here myself as my primary/working copy as well as first 
level backup (with off-btrfs backups to my first-level btrfs backups), I 
simply couldn't rest well if I were using it for (all level) backups, 
because it simply doesn't provide the proven over years level of 
stability and reliability that for me is the whole /point/ of backups 
(otherwise, why bother?), yet.

Never-the-less, if you're comfortable with that level of additional risk 
in your backups, it's your system and your data at risk, so more power to 
you! =:^)

But IMO, /recommending/ btrfs for backups at this point (regardless of 
what I was or was not doing myself, accepting the brown-bag should my 
decision for my own data turn out to have been a bad one) is nothing 
other than irresponsible, and as such I could never do it.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

