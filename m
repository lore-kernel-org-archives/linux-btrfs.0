Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.15.14]:59698 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752987AbaBPT7D (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 16 Feb 2014 14:59:03 -0500
Received: from frosties.localnet ([149.172.224.32]) by smtp.web.de (mrweb004)
 with ESMTPSA (Nemesis) id 0M6xc5-1XBLE13wX7-00wk5F for
 <linux-btrfs@vger.kernel.org>; Sun, 16 Feb 2014 20:59:01 +0100
Date: Sun, 16 Feb 2014 20:58:59 +0100
From: Goswin von Brederlow <goswin-v-b@web.de>
To: Duncan <1i5t5.duncan@cox.net>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: ENOSPC with 270GiB free
Message-ID: <20140216195859.GA23962@frosties>
References: <20140216135808.GA1491@frosties>
 <pan$3dcd9$71bbddfa$a9318b9a$e36a9655@cox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <pan$3dcd9$71bbddfa$a9318b9a$e36a9655@cox.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Feb 16, 2014 at 06:18:38PM +0000, Duncan wrote:
> Goswin von Brederlow posted on Sun, 16 Feb 2014 14:58:08 +0100 as
> excerpted:
> 
> > As you can see there are still 270GiB free and plenty of block groups
> > free on the device too.
> > 
> > So why isn't btrfs allocating a new block group to store more data?
> 
> I saw this on a much (much) smaller filesystem a few weeks ago, when I 
> redid my /boot.  In my case it was under a gig total, so mixed-mode, but 
> copying files over in a particular order errored some of them out with 
> ENOSPC.  But the way I was copying (using mc) left the ones that hadn't 
> copied selected, and I tried a copy of them again, and/or used mc's 
> directory-diff to find the missing files and copy them over again.  After 
> about three times, they all copied.
> 
> So some combination of size and metadata wasn't triggering a new block 
> allocation, but coming in a different order, it triggered fine.  Again, 
> this was mixed-mode, so data/metadata blocks mixed, and it didn't matter 
> which ran out first since they were combined.
> 
> I wonder if you're running into something similar.  Can you try doing the 
> copy in a different order, or is it one big file?
> 

I'm using rsync and towards the last few GB before it gives ENOSPC the
filesystem gets realy slow and eats more and more cpu time. I'm
copying multi gigabyte files and the second last file managed 2MB/s
and the failed one came down to ~100K/s at the end. So trying a lot of
different files isn't realy feasable, timewise.

MfG
	Goswin
