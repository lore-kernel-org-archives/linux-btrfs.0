Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:59683 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752172AbcFIPdm (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 9 Jun 2016 11:33:42 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1bB1ry-0005BG-QO
	for linux-btrfs@vger.kernel.org; Thu, 09 Jun 2016 17:27:42 +0200
Received: from ip-64-134-228-1.public.wayport.net ([64.134.228.1])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 09 Jun 2016 17:27:42 +0200
Received: from 1i5t5.duncan by ip-64-134-228-1.public.wayport.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 09 Jun 2016 17:27:42 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Replacing drives with larger ones in a 4 drive raid1
Date: Thu, 9 Jun 2016 15:20:47 +0000 (UTC)
Message-ID: <pan$6ab4$792ded48$cf23daab$a8e4c2@cox.net>
References: <022F65B5-228D-4EEF-95C9-3C269B63B290@bueechi.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

boli posted on Wed, 08 Jun 2016 20:55:13 +0200 as excerpted:

> Recently I had the idea to replace the 6 TB HDDs with 8 TB ones ("WD
> Red"), because their price is now acceptable.

Are those the 8 TB SMR "archive" drives?

I haven't been following the issue very closely, but be aware that there 
were serious issues with those drives a few kernels back, and that while 
those issues are now fixed, the drives themselves operate rather 
differently than normal drives, and simply don't work well in normal 
usage.

The short version is that they really are designed for archiving and work 
well when used for that purpose -- a mostly write once and leave it there 
for archiving and retrieval but rarely if ever rewrite it, type usage.  
However, they work rather poorly in normal usage where data is rewritten, 
because they have to rewrite entire zones of data, and that takes much 
longer than simply rewriting individual sectors on normal drives does.

With the kernel patches to fix the initial problems they do work well 
enough, tho performance may not be what you expect, but the key to 
keeping them working well is being aware that they continue to do 
rewrites in the background for long after they are done with the initial 
write, and shutting them down while they are doing them can be an issue.

Due to btrfs' data checksumming feature, small variances to data that 
wouldn't normally be detected on non-checksumming filesystems were 
detected far sooner on btrfs, making it far more sensitive to these small 
errors.  However, if you use the drives for their intended nearly write-
only purpose, and/or very seldom power down the drives at all or do so 
only long after (give it half an hour, say) any writes have completed, as 
long as you're running a current kernel with the initial issues patched, 
you should be fine.  Just don't treat them like normal drives.

If OTOH you need more normal drive usage including lots of data rewrites, 
especially if you frequently poweroff the devices, strongly consider 
avoiding those 8 TB SMR drives, at least until the technology has a few 
more years to mature.

There's more information on other threads on the list and on other lists, 
if you need it and nobody posts more direct information (such as the 
specific patches in question and what specific kernel versions they hit) 
here.  I could find it but I'd have to do a search in my own list 
archives, and now that you are aware of the problem, you can of course do 
the search as well, if you need to. =:^)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

