Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:55332 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752395AbcAIKzf (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 9 Jan 2016 05:55:35 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1aHrBF-000653-Ss
	for linux-btrfs@vger.kernel.org; Sat, 09 Jan 2016 11:55:34 +0100
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 09 Jan 2016 11:55:33 +0100
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 09 Jan 2016 11:55:33 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: evidence of persistent state, despite device disconnects
Date: Sat, 9 Jan 2016 10:55:23 +0000 (UTC)
Message-ID: <pan$84a33$9b12297$c9fad6dd$fe3dbd43@cox.net>
References: <CAJCQCtS59TFek+g9x_aoqGzepySMrRn6DcOQkuwi=VQYR9M4tw@mail.gmail.com>
	<pan$671e2$87d221b4$c1b40d79$6f794584@cox.net>
	<CAJCQCtSCvzoOdqFx9dB9sbT-dR0XsQVzWwVcK3zBnwC17+ZV_Q@mail.gmail.com>
	<pan$4b55a$cfffcc6c$c8faaa76$1740646a@cox.net>
	<CAJCQCtRkDrUhiCsgO5Wm=1OhpbtxaR58SLLg5JxZvYQE_nSTUQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Chris Murphy posted on Tue, 05 Jan 2016 14:47:52 -0700 as excerpted:

> On Tue, Jan 5, 2016 at 7:50 AM, Duncan <1i5t5.duncan@cox.net> wrote:
> 
> 
>> If however you mounted it degraded,rw at some point, then I'd say the
>> bug is in wetware, as in that case, based on my understanding, it's
>> working as intended.  I was inclined to believe that was what happened
>> based on the obviously partial sequence in the earlier post, but if you
>> say you didn't... then it's all down to duplication and finding why
>> it's suddenly reverting to single mode on non-degraded mounts, which
>> indeed /is/ a bug.
> 
> Clearly I will have to retest.
> 
> But even as rw,degraded, it doesn't matter, that'd still be a huge bug.
> There's no possible way you'll convince me this is a user
> misunderstanding. No where is this documented.
> 
> I made the fs using mfks.btrfs -draid1 -mraid1. There is no way the fs,
> under any circumstance, legitimately creates and uses any other profile
> for any chunk type, ever. Let alone silently.

If you're mounting degraded,rw, and you're down to a single device on a 
raid1, then once the existing chunks fill up, it /has/ to create single 
chunks, because it can't create them raid1 as there's not enough devices 
(a minimum of two devices are required to create raid1 chunks, since two 
copies are required and they can't be on the same device).

And by mounting degraded,rw you've given it permission to create those 
single mode chunks if it has to, so it's not "silent", as you've 
explicitly mounted it degraded,rw, and single is what raid1 degrades to 
when there's only one device.

And with automatic empty-chunk deletion, existing chunks can fill up 
pretty fast...

Further, NOT letting it write single chunks when an otherwise raid1 btrfs 
is mounted in degraded,rw mode, would very possibly prevent you from 
repairing the filesystem with a btrfs replace or btrfs device add and 
delete.  And we've been there, done that, except slightly differently, 
with the can only mount degraded,rw until a single mode chunk is written, 
after which you can only mount degraded,ro, and then can't repair, which 
is the problem that the per-chunk check patches, vs. the old filesystem-
scope check, were designed to eliminate.

But as I said, if it's creating single chunks when you did /not/ have it 
mounted degraded, then you indeed have found a bug, and figuring out how 
to replicate it so it can be properly traced and fixed is where we're 
left, as I can't see how anyone would find that not a bug.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

