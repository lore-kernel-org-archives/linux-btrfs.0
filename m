Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:40130 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751849Ab3JZOMW (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 26 Oct 2013 10:12:22 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1Va4bD-0007rY-PW
	for linux-btrfs@vger.kernel.org; Sat, 26 Oct 2013 16:12:19 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 26 Oct 2013 16:12:19 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 26 Oct 2013 16:12:19 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: swapfile on btrfs, temporary solution for wiki
Date: Sat, 26 Oct 2013 14:11:56 +0000 (UTC)
Message-ID: <pan$8a853$88d20f1b$177325a2$f72a8d1a@cox.net>
References: <CAGqmi74OvQ=BFroP+QCf6eUtc61__LYRGtZJNcPz1XrSWX-q_w@mail.gmail.com>
	<CAGqmi74F9GurJL73qtU4JG+Fi4RbXE7tiaO1uEQqEY2ym278eA@mail.gmail.com>
	<20131025163546.4cf3291a@natsu> <20131025104414.GD31029@carfax.org.uk>
	<CAOTdububnKzatt1ojXhXry36vkr1D3DgBc-HFks46=P6R40gmg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

karim.allah.ahmed@gmail.com posted on Sat, 26 Oct 2013 10:30:18 +0100 as
excerpted:

> Is the swap over NFS code upstream ?

?esrever ni txet referp uoy od ;tsop-pot t'nod esaelP

(Please don't top-post; do you prefer text in reverse?)

Quote the context you need so your question makes sense and reply below 
it, and you're more likely to get useful answers as it'll be less work to 
reply properly.  Here's how it should have looked, now quoted another 
level for my reply:

>> That said, there's been a lot of work recently on getting
>> swap-over-NFS to work properly -- effectively giving a new interface
>> for the swap code that doesn't rely on direct mapping to device
>> blocks. That new interface gives us the minimal external
>> infrastructure necessary to consider doing swapfiles on btrfs.
>>
> Is the swap over NFS code upstream ?

The answer is yes, I've definitely seen commit comments about swap over 
NFS on recent commits, so the work is indeed going in, tho it may well 
still be a WIP.

(I don't use NFS here and in fact with 8-16 gigs RAM common these days, I 
don't use swap so much any more either and often don't even have the 
kernel swap option on for my current configs unless I'm using it for 
suspend-to-disk, so I've not followed the issue closely enough to know 
current in-kernel status, but based on the commits I've happened across, 
yes, the work is certainly going in, if the feature isn't already there 
and working in general and they're simply tweaking it now.)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

