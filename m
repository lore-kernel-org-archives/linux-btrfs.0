Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:38460 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750711AbcAAFzR (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 1 Jan 2016 00:55:17 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1aEsgE-0008Vj-4p
	for linux-btrfs@vger.kernel.org; Fri, 01 Jan 2016 06:55:14 +0100
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 01 Jan 2016 06:55:14 +0100
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 01 Jan 2016 06:55:14 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: btrfs scrub failing
Date: Fri, 1 Jan 2016 05:55:08 +0000 (UTC)
Message-ID: <pan$1f21$8d293d0$5b6cd545$34c90ade@cox.net>
References: <CAPgWCbQ9HS1N=JCbbHuT9yyTz3JPAizA+DvOAR7_GX73CVix0g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

John Center posted on Thu, 31 Dec 2015 11:20:28 -0500 as excerpted:

> I run a weekly scrub, using Marc Merlin's btrfs-scrub script.
> Usually, it completes without a problem, but this week it failed.  I ran
> the scrub manually & it stops shortly:
> 
> john@mariposa:~$ sudo /sbin/btrfs scrub start -BdR /dev/md124p2
> ERROR: scrubbing /dev/md124p2 failed for device id 1:
> ret=-1, errno=5 (Input/output error)
> scrub device /dev/md124p2 (id 1) canceled
> scrub started at Thu Dec 31 00:26:34 2015
> and was aborted after 00:01:29 [...]

> My Ubuntu 14.04 workstation is using the 4.2 kernel (Wily).
> I'm using btrfs-tools v4.3.1. [...]

A couple months ago, which would have made it around the 4.2 kernel 
you're running (with 4.3 being current and 4.4 nearly out), there were a 
number of similar scrub aborted reports on the list.

I don't recall seeing any directly related patches, but the reports died 
down, whether because everybody having them had reported already, or 
because a newer kernel fixed the problem, I'm not sure, as I never had 
the problem myself[1].

So I'd suggest upgrading to either the current 4.3 kernel or the latest 
4.4-rc, and hopefully the problem will be gone.  If I'd had the problem 
myself I could tell you for sure whether it went away for me with 4.3, 
but as I didn't...

In any event, the 4.2 kernel wasn't a long-term-support kernel anyway.  
4.1 was and 4.4 is scheduled to be.  So upstream 4.2 updates should be 
ended or coming to an end in any case, and an upgrade (or possibly 
downgrade to the LTS 4.1) is recommended anyway, tho of course Ubuntu 
could be doing its own support, independent of upstream, but then you'd 
need to get support from them as upstream won't be tracking patches 
they've backported and thus can't provide proper support.

---
[1]  All my btrfs are relatively small, under 50 GiB per device, and on 
SSD, so scrubs normally complete in under a minute, while your report of 
scrub aborting after a minute and a half was typical, so it's likely my 
scrubs were simply done before whatever the problem was could trigger.


-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

