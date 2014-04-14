Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:51497 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751003AbaDNK2t (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 14 Apr 2014 06:28:49 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1WZe88-00089d-EG
	for linux-btrfs@vger.kernel.org; Mon, 14 Apr 2014 12:28:48 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 14 Apr 2014 12:28:48 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 14 Apr 2014 12:28:48 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: very slow btrfs filesystem: any data needed before I wipe it?
Date: Mon, 14 Apr 2014 10:28:36 +0000 (UTC)
Message-ID: <pan$e77e6$b574a284$96e60612$bbaf30db@cox.net>
References: <20140407160506.GG10789@merlins.org> <5342CE0C.3070707@fb.com>
	<20140407185121.GI10222@merlins.org> <5342FD3D.3090905@fb.com>
	<20140407200002.GL1809@merlins.org> <20140409173842.GT10789@merlins.org>
	<20140325014956.GG11533@merlins.org> <20140412202542.GW7322@merlins.org>
	<pan$618bb$88ff516$fa62072a$7143669d@cox.net>
	<20140414014337.GD7322@merlins.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Marc MERLIN posted on Sun, 13 Apr 2014 18:43:37 -0700 as excerpted:

> On Sun, Apr 13, 2014 at 04:02:36AM +0000, Duncan wrote:
>> What happens if you simply mount it ro, without the recovery option? 
>> Is it still normal-speed or is that slow as a rw mount?
> 
> I just tried in ro without recovery, and I could copy data out at 52MB/s
> for a big file, so that's quite good.
> 
> As soon as I mount it r/w, then everything goes to crap, even before I
> start using it.
> So from what I'm seeing, some structures are messed up, btrfs then goes
> into some almost infinite loops to fix them if the filesystem is in
> writeable mode.

Pretty much what I expected in terms of ro vs. rw, but I had forgotten 
the details on the why, and your explanation both prompted my memory and 
agrees with what I had seen before.

IIRC, Hugo mentioned others seeing something similar at times, where read-
only forced btrfs to leave alone what it was going into loops over, so 
you're not the only one to have seen this.

But you might well be the first report where the devs have good access to 
enough detail to actually trace down the problem.

> I'll wait until tomorrow night to see if the devs want anything else out
> of it, but otherwise I'll wipe it and start over.

Given that our exchange happened over the weekend and "tomorrow" is 
Monday, I'd consider waiting until Tuesday nite if possible, just to be 
sure.  Because Monday is of course back to work day, and it's possible if 
there's something urgent (or if they're taking a long weekend for some 
reason), they won't get fully caught up from the weekend until Tuesday.  
So if you can wait until Tuesday and you don't get a request for anything 
else by then, it's probably safe to wipe and redo, but I'd try to wait 
until then, just in case you have something useful, and they simply don't 
get to it the first day back after the weekend.  Because once it's gone 
it's gone, and now that I'm remembering what Hugo mentioned, it does seem 
you're not the only one to have come across this, but you might indeed 
have the missing key the others couldn't provide, so...

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

