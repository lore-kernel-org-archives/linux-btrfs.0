Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:50616 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752830AbcCZD4Q (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 25 Mar 2016 23:56:16 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1ajfKe-0005Om-IH
	for linux-btrfs@vger.kernel.org; Sat, 26 Mar 2016 04:56:12 +0100
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 26 Mar 2016 04:56:12 +0100
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 26 Mar 2016 04:56:12 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Possible Raid Bug
Date: Sat, 26 Mar 2016 03:56:06 +0000 (UTC)
Message-ID: <pan$186f2$9b8d4d24$933a1a1f$26522a2b@cox.net>
References: <1458906560.3786108.559411242.3678497C@webmail.messagingengine.com>
	<CAA7pwKNj+qEUk+RhzyceRFqThzhUkroYMxS3b3gAn_5KEyawMQ@mail.gmail.com>
	<CAA7pwKNgDi9C8E+duwNA6H8MrT1nVEHkWAm4=JZp3GjFgAvZ1g@mail.gmail.com>
	<1458926454.3855039.559662618.4F365498@webmail.messagingengine.com>
	<CAA7pwKP90OTQLdOw4LHtGxZEBWhz3bZCam2E2-CHwA1p9CMdnA@mail.gmail.com>
	<CAJCQCtS+VY8ecwAVwjE9Tm=x4=vnNSbd19ssc4+=cBigs7K2Jw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Chris Murphy posted on Fri, 25 Mar 2016 15:34:11 -0600 as excerpted:

> Basically you get one chance to mount rw,degraded and you have to fix
> the problem at that time. And you have to balance away any phantom
> single chunks that have appeared. For what it's worth it's not the
> reboot that degraded it further, it's the unmount and then attempt to
> mount rw,degraded a 2nd time that's not allowed due to this bug.

As CMurphy says here but without mentioning the patch, as Alexander F 
says in sibling to CMurphy's reply, and as I said in my longer 
explanation further upthread, this is a known bug, with a patch in the 
pipeline that really should have made it into 4.5 but didn't as it was 
part of a larger patch set that apparently wasn't considered ready, and 
unfortunately it wasn't cherrypicked.

So right now, yes, known bug.  You get one chance at a degraded-writable 
mount to rebuild the array.  If you crash after writing but before the 
rebuild is complete, too bad, so sad, now you can only mount degraded-
readonly and your only possibility of saving the data (other than 
rebuilding with the appropriate patch) is to do just that, mount degraded-
readonly, and copy off the data to elsewhere.

But there's a patch that has been demonstrated to fix the bug, not only 
in tests, but in live-deployments where people found themselves with a 
degraded-readonly mount until they built with the patch.  Hopefully that 
patch will hit the 4.6 development kernel with a CC to stable, and be 
backported as necessary there, but I'm not sure it will be in 4.6 at this 
point, tho it should hit mainline /eventually/.  Meanwhile, the patch can 
still be applied manually if necessary, and I suppose some distros may 
already be applying it to their shipped versions as it's certainly a fix 
worth having.

I'll simply refer you to previous discussion on the list for the patch, 
as that's where I'd have to look for it if I needed it myself before it 
gets mainlined.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

