Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:44687 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934103AbaLKIeF (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 11 Dec 2014 03:34:05 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1XyzCE-0006BM-5V
	for linux-btrfs@vger.kernel.org; Thu, 11 Dec 2014 09:34:02 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 11 Dec 2014 09:34:02 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 11 Dec 2014 09:34:02 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Balance & scrub & defrag
Date: Thu, 11 Dec 2014 08:33:51 +0000 (UTC)
Message-ID: <pan$ba432$48f246af$15aa09a4$398e6f59@cox.net>
References: <CAAe=sHWSR=G0+hJCbLCQfgBB_b9VQxu2Q8JETMuRgz79fcBUbg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

sys.syphus posted on Wed, 10 Dec 2014 16:15:17 -0600 as excerpted:

> I am working on a script that i can run daily that will do maintenance
> on my btrfs mountpoints. is there any reason not to concurrently do all
> of the above? possibly including discards as well.
> 
> 
> also, is there anything existing currently that will do maintenance on
> btrfs so i don't have to reinvent the wheel?
> 
> #!/bin/bash btrfs filesystem defragment -r -v /media/btrfs/  &
> btrfs scrub start /media/btrfs/ &
> btrfs balance start /media/btrfs/ &

Btrfs has had concurrency issues in the past, tho there has been a recent 
patch series aimed at fixing many of them.  Still, running more than one 
of defrag/scrub/balance at once, particularly on spinning rust (as 
opposed to SSD which is faster and doesn't have I/O bottlenecks to the 
same degree) does put a lot of stress on the system and is thus more 
likely to trigger bugs than running them one at a time.  If your goal is 
to stress-test and find and report bugs, that's a reasonable start, 
otherwise consider doing one at a time.

There's also the memory issue.  These utilities can take quite a bit of 
memory at times, particularly if you're running with lots of snapshots.

Meanwhile, as others have said, doing these daily is overkill.  If you're 
running multi-TB filesystems on spinning rust, it'll take several hours 
for one of these anyway.  Maybe once a week for scrub, which won't 
rewrite anything unless it finds errors.  Balance you don't need to run 
routinely, only when adding/deleting devices or if your data/metadata 
chunk balance (see btrfs fi df) gets out of balance.

And for defrag, take a look at the autodefrag mount option.  Tho be aware 
that it can interact badly with large (say half a gig or larger), 
actively internal-write-pattern rewritten, files such as VM images and 
databases.  With autodefrag on, you shouldn't have to worry about 
fragmentation at all, unless of course you're using big VMs or the like, 
but there's available solutions for that as well.  See the wiki and many 
previous threads here for more.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

