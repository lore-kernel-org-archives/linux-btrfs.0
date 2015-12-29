Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:49887 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751120AbbL2CW3 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 28 Dec 2015 21:22:29 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1aDjve-0000UP-DU
	for linux-btrfs@vger.kernel.org; Tue, 29 Dec 2015 03:22:26 +0100
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 29 Dec 2015 03:22:26 +0100
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 29 Dec 2015 03:22:26 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: [bug] btrfs fi usage reports bogus 16EiB free space
Date: Tue, 29 Dec 2015 02:22:19 +0000 (UTC)
Message-ID: <pan$18231$95fbaba1$d74d6453$6c085a71@cox.net>
References: <CAJCQCtTKWdAknD9Cbr0kfVNsZ5GW0jH+ZE8ZsNmJ14223aVo2A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Chris Murphy posted on Mon, 28 Dec 2015 17:12:13 -0700 as excerpted:

> Filed a bug:
> https://bugzilla.kernel.org/show_bug.cgi?id=110111
> 
> The gist is that with a full USB stick, 'btrfs fi usage' reports:
> 
>     Free (estimated):  16.00EiB (min: 16.00EiB)
> 
> Which is clearly wrong, but very exciting to imagine what such a thing
> would look like!

[After double-checking the bug report to ensure it was as I suspected, as 
the critical line wasn't included above.]

ENOTIMPLEMENTED.  See that "WARNING: MIXED blockgroups not handled" line 
at the top? =:^)

FWIW I've been seeing this on my /boot and its backup since original fi 
usage implementation.

The patches implementing usage didn't cover the mixed-bg case, except 
with the warning, but were still taken because the report is useful in 
the default case.  IIRC it did something similar for raid56 mode, which 
wasn't complete at the time fi usage was introduced and thus wasn't 
implemented either.

Which is one reason (besides not being in older versions) that we still 
request btrfs fi df and btrfs fi show both, instead of btrfs fi usage.

It's still interesting to imagine a 16 EiB device (not even an array, a 
single device, imagine an array...), tho. Kinda like reading
Hitchhiker's Guide to the Galaxy for the first time, rather mind 
stretching!  =:^)

Of course back a few years ago TiB or even GiB would have seemed equally 
mind stretching...  I remember when the memory in my machine first 
surpassed the size of the entire hard drive I had in my first 486sx25, 4 
MiB RAM, 130 MB hard drive... and I counted myself lucky just to get a 
486 instead of a 386...   Yes, there's kids messing up my lawn too; I 
shout and shake my cane at 'em sometimes. =:^)

(But 16 EiB is STILL mind stretching!)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

