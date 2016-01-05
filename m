Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:50236 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751104AbcAEOui (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 5 Jan 2016 09:50:38 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1aGSwP-0002EZ-AT
	for linux-btrfs@vger.kernel.org; Tue, 05 Jan 2016 15:50:29 +0100
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 05 Jan 2016 15:50:29 +0100
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 05 Jan 2016 15:50:29 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: evidence of persistent state, despite device disconnects
Date: Tue, 5 Jan 2016 14:50:23 +0000 (UTC)
Message-ID: <pan$4b55a$cfffcc6c$c8faaa76$1740646a@cox.net>
References: <CAJCQCtS59TFek+g9x_aoqGzepySMrRn6DcOQkuwi=VQYR9M4tw@mail.gmail.com>
	<pan$671e2$87d221b4$c1b40d79$6f794584@cox.net>
	<CAJCQCtSCvzoOdqFx9dB9sbT-dR0XsQVzWwVcK3zBnwC17+ZV_Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Chris Murphy posted on Sun, 03 Jan 2016 14:33:40 -0700 as excerpted:

> kernel-4.4.0-0.rc6.git0.1.fc24.x86_64 btrfs-progs 4.3.1
> 
> There was some copy pasting, hence /mnt/brick vs /mnt/brick2 confusion,
> but the volume was always cleanly mounted and umounted.
> 
> The biggest problem I have with all of this is the completely silent
> addition of single chunks. That made the volume, in effect, no longer
> completely raid1. No other details matter, except to try and reproduce
> the problem, and find its source so it can be fixed. It is a bug,
> because it's definitely not sane or expected behavior at all.

If there's no way you mounted it degraded,rw at any point, I agree, 
single mode chunks are unexpected on a raid1 for both data and metadata, 
and it's a bug -- possibly actually related to that new code that allows 
degraded,rw recovery via per-chunk checks.

If however you mounted it degraded,rw at some point, then I'd say the bug 
is in wetware, as in that case, based on my understanding, it's working 
as intended.  I was inclined to believe that was what happened based on 
the obviously partial sequence in the earlier post, but if you say you 
didn't... then it's all down to duplication and finding why it's suddenly 
reverting to single mode on non-degraded mounts, which indeed /is/ a bug.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

